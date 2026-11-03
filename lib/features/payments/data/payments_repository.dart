import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../domain/payment_models.dart';

part 'payments_repository.g.dart';

/// Fees and payments (F2). Every money change goes through database RPCs, so
/// the rules (totals, day close, owner-only voids) live in the database.
abstract interface class PaymentsRepository {
  Future<Paged<Invoice>> invoices({required InvoiceTab tab, String search = '', int offset = 0});
  Future<List<Invoice>> memberInvoices(String memberId);
  Future<Invoice> invoice(String id);
  Future<Paged<Payment>> payments({
    PaymentStatus status = PaymentStatus.confirmed,
    String search = '',
    PaymentMode? mode,
    DateTime? from,
    DateTime? to,
    String? memberId,
    int offset = 0,
  });

  Future<PaymentResult> collect({
    required String invoiceId,
    required int amountPaise,
    required PaymentMode mode,
    String? utr,
    DateTime? paidOn,
    String? note,
  });
  Future<int> creditBalance(String memberId);
  Future<PaymentResult> applyCredit({required String invoiceId, required int amountPaise});
  Future<String> claim({required String invoiceId, required int amountPaise, required String utr});
  Future<PaymentResult> verify({required String paymentId, required bool approve, String? reason});
  Future<void> voidPayment({required String paymentId, required String reason});
  Future<void> refund({
    required String paymentId,
    required int amountPaise,
    required PaymentMode mode,
    required String reason,
  });
  Future<void> voidInvoice({required String invoiceId, required String reason});
  Future<String> createInvoice({
    required String memberId,
    required List<InvoiceLine> lines,
    DateTime? dueDate,
    int discountPaise = 0,
    String? discountReason,
  });
  Future<void> setInstalments(String invoiceId, List<(DateTime, int)> plan);

  Future<DaySummary> daySummary({DateTime? day});
  Future<DaySummary> closeDay({required int countedCashPaise, String? note});

  /// Recent day closes: the owner sees everyone's, the desk their own.
  Future<List<DayClose>> dayCloses();
  Future<void> reopenDay(String dayCloseId);
  Future<DuesSummary> duesSummary();
  Future<CollectionsSummary> collections({required DateTime from, required DateTime to});
  Future<List<DueReminder>> remindersToday();

  Future<List<Expense>> expenses({required DateTime from, required DateTime to});
  Future<void> addExpense(Expense e);
  Future<void> deleteExpense(String id);

  /// Optional Razorpay payment link (returns the short URL).
  Future<String> gatewayLink(String invoiceId);

  /// Gym name, address, GSTIN, UPI ID and payment switches.
  Future<BillingProfile> billingProfile();
}

Never _rethrow(Object e) {
  if (e is AppFailure) throw e;
  if (e is PostgrestException) {
    switch (e.code) {
      case '42501':
        throw const NotAllowedFailure();
      case 'P0002':
        throw const NotFoundFailure();
      case '22023' || '23P01' || '23514' || '23505':
        throw RuleFailure(e.message);
    }
    throw ServerFailure(e.message);
  }
  if (e is FunctionException) {
    final details = e.details;
    final msg = details is Map ? details['error']?.toString() : null;
    throw e.status == 409 && msg != null ? RuleFailure(msg) : ServerFailure('gateway ${e.status}');
  }
  final t = e.toString();
  if (t.contains('SocketException') || t.contains('ClientException') || e is TimeoutException) {
    throw const NetworkFailure();
  }
  throw ServerFailure(t);
}

Future<T> _guard<T>(Future<T> Function() run) async {
  try {
    return await run();
  } catch (e) {
    _rethrow(e);
  }
}

class SupabasePaymentsRepository implements PaymentsRepository {
  SupabasePaymentsRepository(this._db);

  final SupabaseClient _db;
  static const _invoiceFull = '*, invoice_items(*), instalments(*), payments(*)';

  String get _today => paymentDate(IstDates.today())!;

  @override
  Future<Paged<Invoice>> invoices({required InvoiceTab tab, String search = '', int offset = 0}) => _guard(() async {
    var q = _db.from('invoices').select('*, instalments(*)');
    q = switch (tab) {
      InvoiceTab.due => q.inFilter('status', ['unpaid', 'partial']).gte('next_due_date', _today),
      InvoiceTab.overdue => q.inFilter('status', ['unpaid', 'partial']).lt('next_due_date', _today),
      InvoiceTab.paid => q.eq('status', 'paid'),
    };
    final s = sanitizeSearch(search);
    if (s.isNotEmpty) q = q.or('member_name.ilike.*$s*,invoice_no.ilike.*$s*,member_code.ilike.*$s*');
    final ordered = tab == InvoiceTab.paid
        ? q.order('issue_date', ascending: false)
        : q.order('next_due_date', ascending: true);
    final rows = await ordered.range(offset, offset + kPageSize - 1);
    final items = rows.map(Invoice.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<List<Invoice>> memberInvoices(String memberId) => _guard(() async {
    final rows = await _db
        .from('invoices')
        .select('*, instalments(*)')
        .eq('member_id', memberId)
        .order('issue_date', ascending: false)
        .limit(100);
    return rows.map(Invoice.fromJson).toList();
  });

  @override
  Future<Invoice> invoice(String id) => _guard(() async {
    final row = await _db.from('invoices').select(_invoiceFull).eq('id', id).maybeSingle();
    if (row == null) throw const NotFoundFailure();
    final inv = Invoice.fromJson(row);
    return inv.copyWith(
      items: [...inv.items]..sort((a, b) => a.position.compareTo(b.position)),
      instalments: [...inv.instalments]..sort((a, b) => a.seq.compareTo(b.seq)),
      payments: [...inv.payments]..sort((a, b) => b.paidAt.compareTo(a.paidAt)),
    );
  });

  @override
  Future<Paged<Payment>> payments({
    PaymentStatus status = PaymentStatus.confirmed,
    String search = '',
    PaymentMode? mode,
    DateTime? from,
    DateTime? to,
    String? memberId,
    int offset = 0,
  }) => _guard(() async {
    var q = _db.from('payments').select();
    q = q.eq('status', switch (status) {
      PaymentStatus.confirmed => 'confirmed',
      PaymentStatus.pendingVerification => 'pending_verification',
      PaymentStatus.rejected => 'rejected',
      PaymentStatus.voided => 'voided',
    });
    if (mode != null) q = q.eq('mode', mode.wire);
    if (memberId != null) q = q.eq('member_id', memberId);
    if (from != null) q = q.gte('paid_on', paymentDate(from)!);
    if (to != null) q = q.lte('paid_on', paymentDate(to)!);
    final s = sanitizeSearch(search);
    if (s.isNotEmpty) q = q.or('member_name.ilike.*$s*,receipt_no.ilike.*$s*,utr.ilike.*$s*');
    final rows = await q.order('paid_at', ascending: false).range(offset, offset + kPageSize - 1);
    final items = rows.map(Payment.fromJson).toList();
    return Paged(items, hasMore: items.length == kPageSize);
  });

  @override
  Future<PaymentResult> collect({
    required String invoiceId,
    required int amountPaise,
    required PaymentMode mode,
    String? utr,
    DateTime? paidOn,
    String? note,
  }) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>(
      'collect_payment',
      params: {
        'p_invoice_id': invoiceId,
        'p_amount_paise': amountPaise,
        'p_mode': mode.wire,
        'p_utr': utr,
        'p_paid_on': paymentDate(paidOn),
        'p_note': note,
      },
    );
    return PaymentResult.fromJson(res);
  });

  @override
  Future<int> creditBalance(String memberId) =>
      _guard(() => _db.rpc<int>('member_credit_balance', params: {'p_member_id': memberId}));

  @override
  Future<PaymentResult> applyCredit({required String invoiceId, required int amountPaise}) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>(
      'apply_credit',
      params: {'p_invoice_id': invoiceId, 'p_amount_paise': amountPaise},
    );
    return PaymentResult.fromJson(res);
  });

  @override
  Future<String> claim({required String invoiceId, required int amountPaise, required String utr}) => _guard(
    () => _db.rpc<String>(
      'claim_payment',
      params: {'p_invoice_id': invoiceId, 'p_amount_paise': amountPaise, 'p_utr': utr.trim()},
    ),
  );

  @override
  Future<PaymentResult> verify({required String paymentId, required bool approve, String? reason}) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>(
      'verify_payment',
      params: {'p_payment_id': paymentId, 'p_approve': approve, 'p_reason': reason},
    );
    return PaymentResult.fromJson(res);
  });

  @override
  Future<void> voidPayment({required String paymentId, required String reason}) =>
      _guard(() => _db.rpc<void>('void_payment', params: {'p_payment_id': paymentId, 'p_reason': reason}));

  @override
  Future<void> refund({
    required String paymentId,
    required int amountPaise,
    required PaymentMode mode,
    required String reason,
  }) => _guard(
    () => _db.rpc<void>(
      'refund_payment',
      params: {'p_payment_id': paymentId, 'p_amount_paise': amountPaise, 'p_mode': mode.wire, 'p_reason': reason},
    ),
  );

  @override
  Future<void> voidInvoice({required String invoiceId, required String reason}) =>
      _guard(() => _db.rpc<void>('void_invoice', params: {'p_invoice_id': invoiceId, 'p_reason': reason}));

  @override
  Future<String> createInvoice({
    required String memberId,
    required List<InvoiceLine> lines,
    DateTime? dueDate,
    int discountPaise = 0,
    String? discountReason,
  }) => _guard(
    () => _db.rpc<String>(
      'create_invoice',
      params: {
        'p_member_id': memberId,
        'p_lines': [for (final l in lines) l.toJson()],
        'p_due_date': paymentDate(dueDate),
        'p_discount_paise': discountPaise,
        'p_discount_reason': discountReason,
      },
    ),
  );

  @override
  Future<void> setInstalments(String invoiceId, List<(DateTime, int)> plan) => _guard(
    () => _db.rpc<void>(
      'set_instalments',
      params: {
        'p_invoice_id': invoiceId,
        'p_plan': [
          for (final (d, a) in plan) {'due_date': paymentDate(d), 'amount_paise': a},
        ],
      },
    ),
  );

  @override
  Future<DaySummary> daySummary({DateTime? day}) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('day_summary', params: {'p_day': paymentDate(day)});
    return DaySummary.fromJson(res);
  });

  @override
  Future<DaySummary> closeDay({required int countedCashPaise, String? note}) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>(
      'close_day',
      params: {'p_counted_cash_paise': countedCashPaise, 'p_note': note},
    );
    return DaySummary.fromJson(res);
  });

  @override
  Future<List<DayClose>> dayCloses() => _guard(() async {
    final rows = await _db
        .from('day_closes')
        .select('*, staff(name)')
        .order('day', ascending: false)
        .order('closed_at', ascending: false)
        .limit(kPageSize);
    return [
      for (final r in rows) DayClose.fromJson({...r, 'staff_name': (r['staff'] as Map<String, dynamic>?)?['name']}),
    ];
  });

  @override
  Future<void> reopenDay(String dayCloseId) =>
      _guard(() => _db.rpc<void>('reopen_day', params: {'p_day_close_id': dayCloseId}));

  @override
  Future<DuesSummary> duesSummary() => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('dues_summary');
    return DuesSummary.fromJson(res);
  });

  @override
  Future<CollectionsSummary> collections({required DateTime from, required DateTime to}) => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>(
      'collections_summary',
      params: {'p_from': paymentDate(from), 'p_to': paymentDate(to)},
    );
    return CollectionsSummary.fromJson(res);
  });

  @override
  Future<List<DueReminder>> remindersToday() => _guard(() async {
    final rows = await _db.rpc<List<dynamic>>('dues_reminders_today');
    return rows.cast<Map<String, dynamic>>().map(DueReminder.fromJson).toList();
  });

  @override
  Future<List<Expense>> expenses({required DateTime from, required DateTime to}) => _guard(() async {
    final rows = await _db
        .from('expenses')
        .select('id, category, amount_paise, spent_on, note')
        .gte('spent_on', paymentDate(from)!)
        .lte('spent_on', paymentDate(to)!)
        .order('spent_on', ascending: false);
    return rows.map(Expense.fromJson).toList();
  });

  @override
  Future<void> addExpense(Expense e) => _guard(() async {
    await _db.from('expenses').insert(e.toJson()..remove('id'));
  });

  @override
  Future<void> deleteExpense(String id) => _guard(() async {
    await _db.from('expenses').delete().eq('id', id);
  });

  @override
  Future<String> gatewayLink(String invoiceId) => _guard(() async {
    final res = await _db.functions.invoke('razorpay-link', body: {'invoice_id': invoiceId});
    return (res.data as Map<String, dynamic>)['url'] as String;
  });

  @override
  Future<BillingProfile> billingProfile() => _guard(() async {
    final res = await _db.rpc<Map<String, dynamic>>('billing_profile');
    return BillingProfile(res);
  });
}

@Riverpod(keepAlive: true)
PaymentsRepository paymentsRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) throw const NotConfiguredFailure();
  return SupabasePaymentsRepository(client);
}
