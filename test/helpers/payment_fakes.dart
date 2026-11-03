import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/paging.dart';
import 'package:abs_fitness/core/utils/dates.dart';
import 'package:abs_fitness/features/payments/data/payments_repository.dart';
import 'package:abs_fitness/features/payments/domain/payment_models.dart';

import 'member_fakes.dart';

/// In-memory payments backend that follows the database rules closely
/// enough for widget flows: partial payments, overpayment to credit, claims,
/// verification, voids, refunds and the day-close lock.
class FakePaymentsRepository implements PaymentsRepository {
  FakePaymentsRepository({List<Invoice>? invoices, Map<String, Object?>? profile})
    : store = invoices ?? sampleInvoices(),
      profile = BillingProfile(
        profile ??
            const {
              'gym_name': 'ABS Fitness Zone',
              'gym_phone': '+919812345678',
              'gym_address': 'Boring Road, Patna',
              'upi_id': 'absfitness@okhdfc',
              'gstin': null,
              'gst_enabled': false,
              'razorpay_enabled': false,
            },
      );

  final List<Invoice> store;
  final BillingProfile profile;
  final Map<String, int> credits = {};
  final List<Expense> expenseList = [
    Expense(
      id: 'ex-1',
      category: 'electricity',
      amountPaise: 850000,
      spentOn: DateTime.utc(2026, 11, 2),
      note: 'Oct bill',
    ),
    Expense(id: 'ex-2', category: 'supplies', amountPaise: 120000, spentOn: DateTime.utc(2026, 11, 1)),
  ];
  final List<String> calls = [];
  bool dayClosed = false;
  int countedCash = 0;
  Object? error;
  int _receipt = 10;
  int _invoiceNo = 10;
  int _seq = 100;

  void _maybeThrow() {
    final e = error;
    if (e != null) throw e;
  }

  List<Payment> get allPayments => [for (final i in store) ...i.payments];

  int _index(String id) {
    final i = store.indexWhere((inv) => inv.id == id);
    if (i < 0) throw const NotFoundFailure();
    return i;
  }

  /// Recomputes paid / balance / status like `refresh_invoice`.
  Invoice _refresh(Invoice inv) {
    if (inv.status == InvoiceStatus.voided) return inv;
    final paid = inv.payments
        .where((p) => p.status == PaymentStatus.confirmed)
        .fold<int>(0, (a, p) => a + p.appliedPaise - p.refundedPaise);
    var cumulative = 0;
    DateTime? next;
    final inst = [
      for (final i in inv.instalments)
        () {
          cumulative += i.amountPaise;
          final done = cumulative <= paid;
          if (!done) next ??= i.dueDate;
          return i.copyWith(status: done ? 'paid' : 'due');
        }(),
    ];
    final balance = inv.totalPaise - paid;
    return inv.copyWith(
      paidPaise: paid,
      balancePaise: balance,
      instalments: inst,
      nextDueDate: balance <= 0 ? null : (next ?? inv.dueDate),
      status: balance <= 0
          ? InvoiceStatus.paid
          : paid > 0
          ? InvoiceStatus.partial
          : InvoiceStatus.unpaid,
    );
  }

  String _today() => paymentDate(IstDates.today())!;

  bool _isOverdue(Invoice i) =>
      i.status.isOpen && i.nextDueDate != null && paymentDate(i.nextDueDate)!.compareTo(_today()) < 0;

  @override
  Future<Paged<Invoice>> invoices({required InvoiceTab tab, String search = '', int offset = 0}) async {
    _maybeThrow();
    final s = search.trim().toLowerCase();
    final list = store.where((i) {
      final inTab = switch (tab) {
        InvoiceTab.due => i.status.isOpen && !_isOverdue(i),
        InvoiceTab.overdue => _isOverdue(i),
        InvoiceTab.paid => i.status == InvoiceStatus.paid,
      };
      return inTab && (s.isEmpty || i.memberName.toLowerCase().contains(s) || i.invoiceNo.toLowerCase().contains(s));
    }).toList()..sort((a, b) => (a.nextDueDate ?? a.issueDate!).compareTo(b.nextDueDate ?? b.issueDate!));
    final page = list.skip(offset).take(kPageSize).toList();
    return Paged(page, hasMore: offset + page.length < list.length);
  }

  @override
  Future<List<Invoice>> memberInvoices(String memberId) async {
    _maybeThrow();
    return store.where((i) => i.memberId == memberId).toList()..sort((a, b) => b.issueDate!.compareTo(a.issueDate!));
  }

  @override
  Future<Invoice> invoice(String id) async {
    _maybeThrow();
    final inv = store[_index(id)];
    return inv.copyWith(payments: [...inv.payments]..sort((a, b) => b.paidAt.compareTo(a.paidAt)));
  }

  @override
  Future<Paged<Payment>> payments({
    PaymentStatus status = PaymentStatus.confirmed,
    String search = '',
    PaymentMode? mode,
    DateTime? from,
    DateTime? to,
    String? memberId,
    int offset = 0,
  }) async {
    _maybeThrow();
    final s = search.trim().toLowerCase();
    final list =
        allPayments
            .where(
              (p) =>
                  p.status == status &&
                  (mode == null || p.mode == mode) &&
                  (memberId == null || p.memberId == memberId) &&
                  (from == null || !p.paidOn!.isBefore(from)) &&
                  (to == null || !p.paidOn!.isAfter(to)) &&
                  (s.isEmpty ||
                      p.memberName.toLowerCase().contains(s) ||
                      (p.receiptNo ?? '').toLowerCase().contains(s) ||
                      (p.utr ?? '').toLowerCase().contains(s)),
            )
            .toList()
          ..sort((a, b) => b.paidAt.compareTo(a.paidAt));
    final page = list.skip(offset).take(kPageSize).toList();
    return Paged(page, hasMore: offset + page.length < list.length);
  }

  Payment _newPayment(Invoice inv, int amount, int applied, PaymentMode mode, String? utr, PaymentStatus status) =>
      Payment(
        id: 'pay-${_seq++}',
        receiptNo: status == PaymentStatus.confirmed ? 'RCPT/26-27/${(_receipt++).toString().padLeft(4, '0')}' : null,
        invoiceId: inv.id,
        memberId: inv.memberId,
        memberName: inv.memberName,
        amountPaise: amount,
        appliedPaise: applied,
        mode: mode,
        utr: utr,
        paidAt: DateTime.utc(2026, 11, 3, 5, _seq % 60),
        paidOn: fakeToday,
        collectedBy: status == PaymentStatus.confirmed ? '2' : null,
        status: status,
      );

  @override
  Future<PaymentResult> collect({
    required String invoiceId,
    required int amountPaise,
    required PaymentMode mode,
    String? utr,
    DateTime? paidOn,
    String? note,
  }) async {
    _maybeThrow();
    calls.add('collect:$invoiceId:$amountPaise:${mode.wire}');
    if (dayClosed) throw const RuleFailure('your day is closed; ask the owner to reopen it');
    if (amountPaise <= 0) throw const RuleFailure('amount must be more than zero');
    if (mode.needsReference && (utr == null || utr.trim().length < 6)) {
      throw const RuleFailure('enter the UPI / bank reference (UTR)');
    }
    final i = _index(invoiceId);
    var inv = store[i];
    if (inv.balancePaise <= 0) throw const RuleFailure('this invoice is already paid');
    final applied = amountPaise < inv.balancePaise ? amountPaise : inv.balancePaise;
    final credit = amountPaise - applied;
    final pay = _newPayment(inv, amountPaise, applied, mode, utr, PaymentStatus.confirmed);
    inv = _refresh(inv.copyWith(payments: [...inv.payments, pay]));
    store[i] = inv;
    if (credit > 0) credits.update(inv.memberId!, (v) => v + credit, ifAbsent: () => credit);
    return PaymentResult(
      paymentId: pay.id,
      receiptNo: pay.receiptNo,
      amountPaise: amountPaise,
      appliedPaise: applied,
      creditPaise: credit,
      balancePaise: inv.balancePaise,
    );
  }

  @override
  Future<int> creditBalance(String memberId) async => credits[memberId] ?? 0;

  @override
  Future<PaymentResult> applyCredit({required String invoiceId, required int amountPaise}) async {
    final i = _index(invoiceId);
    var inv = store[i];
    final available = credits[inv.memberId] ?? 0;
    if (amountPaise > available || amountPaise > inv.balancePaise) throw const RuleFailure('not enough credit');
    final pay = _newPayment(inv, amountPaise, amountPaise, PaymentMode.credit, null, PaymentStatus.confirmed);
    credits[inv.memberId!] = available - amountPaise;
    inv = _refresh(inv.copyWith(payments: [...inv.payments, pay]));
    store[i] = inv;
    return PaymentResult(
      paymentId: pay.id,
      receiptNo: pay.receiptNo,
      amountPaise: amountPaise,
      appliedPaise: amountPaise,
      balancePaise: inv.balancePaise,
    );
  }

  @override
  Future<String> claim({required String invoiceId, required int amountPaise, required String utr}) async {
    _maybeThrow();
    calls.add('claim:$invoiceId:$amountPaise:$utr');
    if (!RegExp(r'^[A-Za-z0-9]{6,30}$').hasMatch(utr.trim())) {
      throw const RuleFailure('enter the UPI reference (UTR) from your payment app');
    }
    if (allPayments.any((p) => p.utr == utr.trim())) throw const RuleFailure('this reference was already used');
    final i = _index(invoiceId);
    final inv = store[i];
    if (amountPaise <= 0 || amountPaise > inv.balancePaise) {
      throw const RuleFailure('amount must be between ₹1 and the amount due');
    }
    final pay = _newPayment(inv, amountPaise, 0, PaymentMode.upi, utr.trim(), PaymentStatus.pendingVerification);
    store[i] = inv.copyWith(payments: [...inv.payments, pay]);
    return pay.id;
  }

  ({int invoice, int payment}) _findPayment(String id) {
    for (var i = 0; i < store.length; i++) {
      final j = store[i].payments.indexWhere((p) => p.id == id);
      if (j >= 0) return (invoice: i, payment: j);
    }
    throw const NotFoundFailure();
  }

  void _replacePayment(String id, Payment Function(Payment p) change) {
    final at = _findPayment(id);
    final inv = store[at.invoice];
    final list = [...inv.payments];
    list[at.payment] = change(list[at.payment]);
    store[at.invoice] = _refresh(inv.copyWith(payments: list));
  }

  @override
  Future<PaymentResult> verify({required String paymentId, required bool approve, String? reason}) async {
    _maybeThrow();
    calls.add('verify:$paymentId:$approve');
    if (!approve && (reason == null || reason.trim().isEmpty)) throw const RuleFailure('a reason is required');
    final at = _findPayment(paymentId);
    final inv = store[at.invoice];
    final p = inv.payments[at.payment];
    final applied = approve ? (p.amountPaise < inv.balancePaise ? p.amountPaise : inv.balancePaise) : 0;
    _replacePayment(
      paymentId,
      (p) => p.copyWith(
        status: approve ? PaymentStatus.confirmed : PaymentStatus.rejected,
        appliedPaise: applied,
        receiptNo: approve ? 'RCPT/26-27/${(_receipt++).toString().padLeft(4, '0')}' : null,
        voidedReason: approve ? null : reason,
      ),
    );
    final after = store[at.invoice];
    return PaymentResult(
      paymentId: paymentId,
      receiptNo: after.payments[at.payment].receiptNo,
      amountPaise: p.amountPaise,
      appliedPaise: applied,
      balancePaise: after.balancePaise,
    );
  }

  @override
  Future<void> voidPayment({required String paymentId, required String reason}) async {
    _maybeThrow();
    calls.add('void:$paymentId');
    _replacePayment(paymentId, (p) => p.copyWith(status: PaymentStatus.voided, voidedReason: reason));
  }

  @override
  Future<void> refund({
    required String paymentId,
    required int amountPaise,
    required PaymentMode mode,
    required String reason,
  }) async {
    _maybeThrow();
    calls.add('refund:$paymentId:$amountPaise');
    _replacePayment(paymentId, (p) {
      if (amountPaise > p.appliedPaise - p.refundedPaise) throw const RuleFailure('refund is more than the payment');
      return p.copyWith(refundedPaise: p.refundedPaise + amountPaise);
    });
  }

  @override
  Future<void> voidInvoice({required String invoiceId, required String reason}) async {
    _maybeThrow();
    calls.add('voidInvoice:$invoiceId');
    final i = _index(invoiceId);
    if (store[i].paidPaise > 0) throw const RuleFailure('void or refund its payments first');
    store[i] = store[i].copyWith(status: InvoiceStatus.voided, voidedReason: reason, nextDueDate: null);
  }

  @override
  Future<String> createInvoice({
    required String memberId,
    required List<InvoiceLine> lines,
    DateTime? dueDate,
    int discountPaise = 0,
    String? discountReason,
  }) async {
    _maybeThrow();
    final member = seededMembers().members.firstWhere((m) => m.id == memberId);
    final subtotal = lines.fold<int>(0, (a, l) => a + l.unitPaise * l.qty);
    final id = 'inv-${_seq++}';
    store.add(
      Invoice(
        id: id,
        invoiceNo: 'ABS/26-27/${(_invoiceNo++).toString().padLeft(4, '0')}',
        memberId: memberId,
        memberName: member.name,
        memberCode: member.memberCode,
        memberPhone: member.phone,
        issueDate: fakeToday,
        dueDate: dueDate ?? fakeToday,
        nextDueDate: dueDate ?? fakeToday,
        subtotalPaise: subtotal,
        discountPaise: discountPaise,
        taxablePaise: subtotal - discountPaise,
        totalPaise: subtotal - discountPaise,
        balancePaise: subtotal - discountPaise,
        items: [
          for (final (n, l) in lines.indexed)
            InvoiceItem(
              id: '$id-$n',
              position: n + 1,
              kind: l.kind,
              description: l.description,
              qty: l.qty,
              unitPaise: l.unitPaise,
              grossPaise: l.unitPaise * l.qty,
              netPaise: l.unitPaise * l.qty,
            ),
        ],
      ),
    );
    return id;
  }

  @override
  Future<void> setInstalments(String invoiceId, List<(DateTime, int)> plan) async {
    _maybeThrow();
    calls.add('instalments:$invoiceId:${plan.length}');
    final i = _index(invoiceId);
    if (plan.length > 4) throw const RuleFailure('at most 4 instalments');
    final total = plan.fold<int>(0, (a, p) => a + p.$2);
    if (total != store[i].totalPaise) throw const RuleFailure('instalments must add up to the invoice total');
    store[i] = _refresh(
      store[i].copyWith(
        instalments: [
          for (final (n, (d, a)) in plan.indexed)
            Instalment(id: '$invoiceId-i$n', seq: n + 1, dueDate: d, amountPaise: a),
        ],
      ),
    );
  }

  DaySummary _summary() {
    final mine = allPayments.where(
      (p) => p.status == PaymentStatus.confirmed && p.collectedBy == '2' && paymentDate(p.paidOn) == _today(),
    );
    int by(PaymentMode m) => mine.where((p) => p.mode == m).fold(0, (a, p) => a + p.amountPaise - p.refundedPaise);
    final cash = by(PaymentMode.cash);
    return DaySummary(
      day: fakeToday,
      cash: cash,
      upi: by(PaymentMode.upi),
      card: by(PaymentMode.card),
      bank: by(PaymentMode.bank),
      total: mine.fold(0, (a, p) => a + p.amountPaise - p.refundedPaise),
      count: mine.length,
      closed: dayClosed,
      closedAt: dayClosed ? DateTime.utc(2026, 11, 3, 15) : null,
      countedCash: dayClosed ? countedCash : null,
      difference: dayClosed ? countedCash - cash : null,
    );
  }

  @override
  Future<DaySummary> daySummary({DateTime? day}) async {
    _maybeThrow();
    return _summary();
  }

  @override
  Future<DaySummary> closeDay({required int countedCashPaise, String? note}) async {
    _maybeThrow();
    calls.add('closeDay:$countedCashPaise');
    if (dayClosed) throw const RuleFailure('this day is already closed');
    dayClosed = true;
    countedCash = countedCashPaise;
    return _summary();
  }

  @override
  Future<List<DayClose>> dayCloses() async => [
    if (dayClosed)
      DayClose(
        id: 'dc-1',
        staffId: '2',
        staffName: 'Neha Singh',
        day: fakeToday,
        cashPaise: _summary().cash,
        totalPaise: _summary().total,
        countedCashPaise: countedCash,
        differencePaise: countedCash - _summary().cash,
        closedAt: DateTime.utc(2026, 11, 3, 15),
      ),
  ];

  @override
  Future<void> reopenDay(String dayCloseId) async {
    calls.add('reopen:$dayCloseId');
    dayClosed = false;
  }

  @override
  Future<DuesSummary> duesSummary() async {
    _maybeThrow();
    final open = store.where((i) => i.status.isOpen);
    final overdue = open.where(_isOverdue);
    final due = open.where((i) => !_isOverdue(i));
    return DuesSummary(
      overdueCount: overdue.length,
      overduePaise: overdue.fold(0, (a, i) => a + i.balancePaise),
      dueCount: due.length,
      duePaise: due.fold(0, (a, i) => a + i.balancePaise),
      pendingClaims: allPayments.where((p) => p.status == PaymentStatus.pendingVerification).length,
    );
  }

  @override
  Future<CollectionsSummary> collections({required DateTime from, required DateTime to}) async {
    _maybeThrow();
    final f = paymentDate(from)!;
    final t = paymentDate(to)!;
    final inRange = allPayments.where((p) {
      final d = paymentDate(p.paidOn)!;
      return p.status == PaymentStatus.confirmed &&
          p.mode != PaymentMode.credit &&
          d.compareTo(f) >= 0 &&
          d.compareTo(t) <= 0;
    });
    final byMode = <String, int>{};
    final byDay = <String, int>{};
    for (final p in inRange) {
      byMode.update(p.mode.wire, (v) => v + p.netPaise, ifAbsent: () => p.netPaise);
      byDay.update(paymentDate(p.paidOn)!, (v) => v + p.netPaise, ifAbsent: () => p.netPaise);
    }
    return CollectionsSummary(
      collected: inRange.fold(0, (a, p) => a + p.netPaise),
      byMode: byMode,
      byDay: [for (final e in byDay.entries) DayAmount(day: DateTime.parse(e.key), paise: e.value)]
        ..sort((a, b) => a.day!.compareTo(b.day!)),
      invoiced: store.fold(0, (a, i) => a + i.totalPaise),
      outstanding: store.where((i) => i.status.isOpen).fold(0, (a, i) => a + i.balancePaise),
      expenses: expenseList.fold(0, (a, e) => a + e.amountPaise),
      paymentsCount: inRange.length,
    );
  }

  @override
  Future<List<DueReminder>> remindersToday() async {
    _maybeThrow();
    return [
      for (final i in store.where((i) => i.status.isOpen && i.nextDueDate != null))
        if (const [3, 0, -3, -7].contains(IstDates.daysUntil(i.nextDueDate!)))
          DueReminder(
            invoiceId: i.id,
            invoiceNo: i.invoiceNo,
            memberId: i.memberId,
            memberName: i.memberName,
            memberPhone: i.memberPhone,
            balancePaise: i.balancePaise,
            nextDueDate: i.nextDueDate,
            daysToDue: IstDates.daysUntil(i.nextDueDate!),
          ),
    ];
  }

  @override
  Future<List<Expense>> expenses({required DateTime from, required DateTime to}) async {
    _maybeThrow();
    return expenseList.where((e) => !e.spentOn!.isBefore(from) && !e.spentOn!.isAfter(to)).toList()
      ..sort((a, b) => b.spentOn!.compareTo(a.spentOn!));
  }

  @override
  Future<void> addExpense(Expense e) async {
    _maybeThrow();
    calls.add('expense:${e.category}:${e.amountPaise}');
    expenseList.add(e.copyWith(id: 'ex-${_seq++}'));
  }

  @override
  Future<void> deleteExpense(String id) async {
    calls.add('deleteExpense:$id');
    expenseList.removeWhere((e) => e.id == id);
  }

  @override
  Future<String> gatewayLink(String invoiceId) async {
    _maybeThrow();
    calls.add('gatewayLink:$invoiceId');
    return 'https://rzp.io/i/abs$invoiceId';
  }

  @override
  Future<BillingProfile> billingProfile() async => profile;
}

/// Four invoices across the tabs plus one pending member claim:
/// Aarav paid in full, Priya part-paid and overdue, Rohit due in 2 days (with
/// a claim waiting), Sneha 3 days overdue.
List<Invoice> sampleInvoices() {
  Invoice inv(
    String id,
    String no,
    String memberId,
    String name,
    String code,
    String phone, {
    required DateTime issued,
    required DateTime due,
    required List<(String, String, int)> lines,
    List<Payment> payments = const [],
  }) {
    final total = lines.fold<int>(0, (a, l) => a + l.$3);
    final paid = payments.where((p) => p.status == PaymentStatus.confirmed).fold<int>(0, (a, p) => a + p.appliedPaise);
    return Invoice(
      id: id,
      invoiceNo: no,
      memberId: memberId,
      memberName: name,
      memberCode: code,
      memberPhone: phone,
      issueDate: issued,
      dueDate: due,
      nextDueDate: paid >= total ? null : due,
      subtotalPaise: total,
      taxablePaise: total,
      totalPaise: total,
      paidPaise: paid,
      balancePaise: total - paid,
      status: paid >= total
          ? InvoiceStatus.paid
          : paid > 0
          ? InvoiceStatus.partial
          : InvoiceStatus.unpaid,
      items: [
        for (final (n, l) in lines.indexed)
          InvoiceItem(
            id: '$id-$n',
            position: n + 1,
            kind: l.$1,
            description: l.$2,
            unitPaise: l.$3,
            grossPaise: l.$3,
            netPaise: l.$3,
          ),
      ],
      payments: payments,
    );
  }

  Payment pay(
    String id,
    String invoiceId,
    String memberId,
    String name,
    int amount,
    PaymentMode mode, {
    String? receipt,
    String? utr,
    PaymentStatus status = PaymentStatus.confirmed,
    required DateTime at,
  }) => Payment(
    id: id,
    receiptNo: receipt,
    invoiceId: invoiceId,
    memberId: memberId,
    memberName: name,
    amountPaise: amount,
    appliedPaise: status == PaymentStatus.confirmed ? amount : 0,
    mode: mode,
    utr: utr,
    paidAt: at,
    paidOn: DateTime.utc(at.year, at.month, at.day),
    collectedBy: status == PaymentStatus.confirmed ? '2' : null,
    status: status,
  );

  return [
    inv(
      'inv-1',
      'ABS/26-27/0001',
      'm-1',
      'Aarav Sharma',
      'ABS-0001',
      '+919876500001',
      issued: DateTime.utc(2026, 10, 1),
      due: DateTime.utc(2026, 10, 1),
      lines: [('plan', 'Quarterly', 400000)],
      payments: [
        pay(
          'pay-1',
          'inv-1',
          'm-1',
          'Aarav Sharma',
          400000,
          PaymentMode.cash,
          receipt: 'RCPT/26-27/0001',
          at: DateTime.utc(2026, 10, 1, 6),
        ),
      ],
    ),
    inv(
      'inv-2',
      'ABS/26-27/0002',
      'm-2',
      'Priya Verma',
      'ABS-0002',
      '+919876500002',
      issued: DateTime.utc(2026, 10, 7),
      due: DateTime.utc(2026, 10, 14),
      lines: [('plan', 'Monthly', 150000), ('joining_fee', 'Joining fee', 50000)],
      payments: [
        pay(
          'pay-2',
          'inv-2',
          'm-2',
          'Priya Verma',
          100000,
          PaymentMode.upi,
          receipt: 'RCPT/26-27/0002',
          utr: '412345678901',
          at: DateTime.utc(2026, 11, 3, 4),
        ),
      ],
    ),
    inv(
      'inv-3',
      'ABS/26-27/0003',
      'm-3',
      'Rohit Yadav',
      'ABS-0003',
      '+919876500003',
      issued: DateTime.utc(2026, 11, 1),
      due: DateTime.utc(2026, 11, 5),
      lines: [('plan', 'Monthly', 150000)],
      payments: [
        pay(
          'pay-3',
          'inv-3',
          'm-3',
          'Rohit Yadav',
          150000,
          PaymentMode.upi,
          utr: 'ROHITUPI1234',
          status: PaymentStatus.pendingVerification,
          at: DateTime.utc(2026, 11, 3, 3),
        ),
      ],
    ),
    inv(
      'inv-4',
      'ABS/26-27/0004',
      'm-4',
      'Sneha Kumari',
      'ABS-0004',
      '+919876500004',
      issued: DateTime.utc(2026, 9, 15),
      due: DateTime.utc(2026, 10, 31),
      lines: [('plan', 'Quarterly', 400000)],
    ),
  ];
}
