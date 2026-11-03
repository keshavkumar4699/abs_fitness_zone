import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/dates.dart';

part 'payment_models.freezed.dart';
part 'payment_models.g.dart';

/// Calendar dates arrive as "YYYY-MM-DD" and are kept as UTC midnight.
DateTime? _date(Object? v) {
  if (v == null || v == '') return null;
  final d = DateTime.parse(v as String);
  return DateTime.utc(d.year, d.month, d.day);
}

String? _dateOut(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

enum InvoiceStatus {
  @JsonValue('unpaid')
  unpaid,
  @JsonValue('partial')
  partial,
  @JsonValue('paid')
  paid,
  @JsonValue('void')
  voided;

  bool get isOpen => this == unpaid || this == partial;
}

enum PaymentMode {
  @JsonValue('cash')
  cash,
  @JsonValue('upi')
  upi,
  @JsonValue('card')
  card,
  @JsonValue('bank')
  bank,
  @JsonValue('online')
  online,
  @JsonValue('credit')
  credit;

  String get wire => name;

  /// Modes the desk can choose when collecting.
  static const collectable = [cash, upi, card, bank];

  bool get needsReference => this == upi || this == bank;
}

enum PaymentStatus {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('pending_verification')
  pendingVerification,
  @JsonValue('rejected')
  rejected,
  @JsonValue('voided')
  voided,
}

@freezed
abstract class InvoiceItem with _$InvoiceItem {
  const factory InvoiceItem({
    required String id,
    required int position,
    @Default('other') String kind,
    required String description,
    @Default(1) int qty,
    @JsonKey(name: 'unit_paise') required int unitPaise,
    @JsonKey(name: 'gross_paise') required int grossPaise,
    @JsonKey(name: 'discount_paise') @Default(0) int discountPaise,
    @JsonKey(name: 'net_paise') required int netPaise,
    @JsonKey(name: 'gst_rate') @Default(0) num gstRate,
    @JsonKey(name: 'taxable_paise') @Default(0) int taxablePaise,
    @JsonKey(name: 'gst_paise') @Default(0) int gstPaise,
  }) = _InvoiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);
}

@freezed
abstract class Instalment with _$Instalment {
  const factory Instalment({
    required String id,
    required int seq,
    @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) required DateTime? dueDate,
    @JsonKey(name: 'amount_paise') required int amountPaise,
    @Default('due') String status,
  }) = _Instalment;

  factory Instalment.fromJson(Map<String, dynamic> json) => _$InstalmentFromJson(json);
}

@freezed
abstract class Payment with _$Payment {
  const Payment._();

  const factory Payment({
    required String id,
    @JsonKey(name: 'receipt_no') String? receiptNo,
    @JsonKey(name: 'invoice_id') String? invoiceId,
    @JsonKey(name: 'member_id') String? memberId,
    @JsonKey(name: 'member_name') required String memberName,
    @JsonKey(name: 'amount_paise') required int amountPaise,
    @JsonKey(name: 'applied_paise') @Default(0) int appliedPaise,
    @JsonKey(name: 'refunded_paise') @Default(0) int refundedPaise,
    required PaymentMode mode,
    String? utr,
    @JsonKey(name: 'paid_at') required DateTime paidAt,
    @JsonKey(name: 'paid_on', fromJson: _date, toJson: _dateOut) DateTime? paidOn,
    @JsonKey(name: 'collected_by') String? collectedBy,
    @Default(PaymentStatus.confirmed) PaymentStatus status,
    String? note,
    @JsonKey(name: 'voided_reason') String? voidedReason,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  int get netPaise => amountPaise - refundedPaise;
}

@freezed
abstract class Invoice with _$Invoice {
  const Invoice._();

  const factory Invoice({
    required String id,
    @JsonKey(name: 'invoice_no') required String invoiceNo,
    @JsonKey(name: 'member_id') String? memberId,
    @JsonKey(name: 'member_name') required String memberName,
    @JsonKey(name: 'member_code') required String memberCode,
    @JsonKey(name: 'member_phone') String? memberPhone,
    @JsonKey(name: 'membership_id') String? membershipId,
    @JsonKey(name: 'issue_date', fromJson: _date, toJson: _dateOut) required DateTime? issueDate,
    @JsonKey(name: 'due_date', fromJson: _date, toJson: _dateOut) required DateTime? dueDate,
    @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) required DateTime? nextDueDate,
    @JsonKey(name: 'subtotal_paise') @Default(0) int subtotalPaise,
    @JsonKey(name: 'discount_paise') @Default(0) int discountPaise,
    @JsonKey(name: 'discount_reason') String? discountReason,
    @JsonKey(name: 'taxable_paise') @Default(0) int taxablePaise,
    @JsonKey(name: 'cgst_paise') @Default(0) int cgstPaise,
    @JsonKey(name: 'sgst_paise') @Default(0) int sgstPaise,
    @JsonKey(name: 'total_paise') @Default(0) int totalPaise,
    @JsonKey(name: 'paid_paise') @Default(0) int paidPaise,
    @JsonKey(name: 'balance_paise') @Default(0) int balancePaise,
    @Default(InvoiceStatus.unpaid) InvoiceStatus status,
    @JsonKey(name: 'overdue_days') @Default(0) int overdueDays,
    @JsonKey(name: 'gateway_link_url') String? gatewayLinkUrl,
    @JsonKey(name: 'voided_reason') String? voidedReason,
    @JsonKey(name: 'invoice_items') @Default([]) List<InvoiceItem> items,
    @Default([]) List<Instalment> instalments,
    @Default([]) List<Payment> payments,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  int get gstPaise => cgstPaise + sgstPaise;

  /// Days past the next due date (0 when not overdue), from the IST clock.
  int daysOverdue({DateTime? now}) {
    if (!status.isOpen || nextDueDate == null) return 0;
    final d = -IstDates.daysUntil(nextDueDate!, now: now);
    return d > 0 ? d : 0;
  }

  bool isOverdue({DateTime? now}) => daysOverdue(now: now) > 0;

  /// The amount of the next instalment still due (or the whole balance).
  int nextInstalmentDuePaise() {
    if (instalments.isEmpty) return balancePaise;
    var cumulative = 0;
    for (final i in [...instalments]..sort((a, b) => a.seq.compareTo(b.seq))) {
      cumulative += i.amountPaise;
      if (cumulative > paidPaise) return cumulative - paidPaise;
    }
    return balancePaise;
  }
}

/// What a collect / verify call returns.
@freezed
abstract class PaymentResult with _$PaymentResult {
  const factory PaymentResult({
    @JsonKey(name: 'payment_id') required String paymentId,
    @JsonKey(name: 'receipt_no') String? receiptNo,
    @JsonKey(name: 'amount_paise') required int amountPaise,
    @JsonKey(name: 'applied_paise') @Default(0) int appliedPaise,
    @JsonKey(name: 'credit_paise') @Default(0) int creditPaise,
    @JsonKey(name: 'balance_paise') @Default(0) int balancePaise,
  }) = _PaymentResult;

  factory PaymentResult.fromJson(Map<String, dynamic> json) => _$PaymentResultFromJson(json);
}

@freezed
abstract class DaySummary with _$DaySummary {
  const factory DaySummary({
    @JsonKey(fromJson: _date, toJson: _dateOut) DateTime? day,
    @Default(0) int cash,
    @Default(0) int upi,
    @Default(0) int card,
    @Default(0) int bank,
    @Default(0) int online,
    @Default(0) int credit,
    @Default(0) int total,
    @Default(0) int count,
    @Default(false) bool closed,
    @JsonKey(name: 'closed_at') DateTime? closedAt,
    @JsonKey(name: 'counted_cash') int? countedCash,
    int? difference,
  }) = _DaySummary;

  factory DaySummary.fromJson(Map<String, dynamic> json) => _$DaySummaryFromJson(json);
}

/// A closed (or reopened) day for one staff member.
@freezed
abstract class DayClose with _$DayClose {
  const DayClose._();

  const factory DayClose({
    required String id,
    @JsonKey(name: 'staff_id') required String staffId,
    @JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day,
    @JsonKey(name: 'total_paise') @Default(0) int totalPaise,
    @JsonKey(name: 'cash_paise') @Default(0) int cashPaise,
    @JsonKey(name: 'counted_cash_paise') @Default(0) int countedCashPaise,
    @JsonKey(name: 'difference_paise') @Default(0) int differencePaise,
    @JsonKey(name: 'payments_count') @Default(0) int paymentsCount,
    String? note,
    @JsonKey(name: 'closed_at') required DateTime closedAt,
    @JsonKey(name: 'reopened_at') DateTime? reopenedAt,
    @JsonKey(name: 'staff_name') String? staffName,
  }) = _DayClose;

  factory DayClose.fromJson(Map<String, dynamic> json) => _$DayCloseFromJson(json);

  bool get isOpen => reopenedAt != null;
}

@freezed
abstract class DuesSummary with _$DuesSummary {
  const factory DuesSummary({
    @JsonKey(name: 'overdue_count') @Default(0) int overdueCount,
    @JsonKey(name: 'overdue_paise') @Default(0) int overduePaise,
    @JsonKey(name: 'due_count') @Default(0) int dueCount,
    @JsonKey(name: 'due_paise') @Default(0) int duePaise,
    @JsonKey(name: 'pending_claims') @Default(0) int pendingClaims,
  }) = _DuesSummary;

  factory DuesSummary.fromJson(Map<String, dynamic> json) => _$DuesSummaryFromJson(json);
}

@freezed
abstract class DayAmount with _$DayAmount {
  const factory DayAmount({@JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day, @Default(0) int paise}) =
      _DayAmount;

  factory DayAmount.fromJson(Map<String, dynamic> json) => _$DayAmountFromJson(json);
}

@freezed
abstract class CollectionsSummary with _$CollectionsSummary {
  const factory CollectionsSummary({
    @Default(0) int collected,
    @JsonKey(name: 'by_mode') @Default(<String, int>{}) Map<String, int> byMode,
    @JsonKey(name: 'by_day') @Default([]) List<DayAmount> byDay,
    @Default(0) int invoiced,
    @Default(0) int outstanding,
    @Default(0) int refunds,
    @Default(0) int expenses,
    @JsonKey(name: 'payments_count') @Default(0) int paymentsCount,
  }) = _CollectionsSummary;

  factory CollectionsSummary.fromJson(Map<String, dynamic> json) => _$CollectionsSummaryFromJson(json);
}

@freezed
abstract class DueReminder with _$DueReminder {
  const factory DueReminder({
    @JsonKey(name: 'invoice_id') required String invoiceId,
    @JsonKey(name: 'invoice_no') required String invoiceNo,
    @JsonKey(name: 'member_id') String? memberId,
    @JsonKey(name: 'member_name') required String memberName,
    @JsonKey(name: 'member_phone') String? memberPhone,
    @JsonKey(name: 'balance_paise') required int balancePaise,
    @JsonKey(name: 'next_due_date', fromJson: _date, toJson: _dateOut) required DateTime? nextDueDate,
    @JsonKey(name: 'days_to_due') required int daysToDue,
  }) = _DueReminder;

  factory DueReminder.fromJson(Map<String, dynamic> json) => _$DueReminderFromJson(json);
}

const expenseCategories = [
  'rent',
  'salaries',
  'electricity',
  'equipment',
  'maintenance',
  'marketing',
  'supplies',
  'other',
];

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    String? id,
    required String category,
    @JsonKey(name: 'amount_paise') required int amountPaise,
    @JsonKey(name: 'spent_on', fromJson: _date, toJson: _dateOut) required DateTime? spentOn,
    String? note,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}

/// Gym details for receipts and pay screens (`billing_profile` RPC).
class BillingProfile {
  const BillingProfile(this.values);

  final Map<String, Object?> values;

  String? _text(String key) {
    final v = values[key];
    return v is String && v.trim().isNotEmpty ? v.trim() : null;
  }

  bool _flag(String key, {bool fallback = false}) => switch (values[key]) {
    final bool b => b,
    final String s => s == 'true',
    _ => fallback,
  };

  String get gymName => _text('gym_name') ?? 'ABS Fitness Zone';
  String? get phone => _text('gym_phone');
  String? get address => _text('gym_address');
  String? get upiId => _text('upi_id');
  String? get gstin => _text('gstin');
  bool get gstEnabled => _flag('gst_enabled');
  bool get gstInclusive => _flag('gst_inclusive', fallback: true);
  bool get razorpayEnabled => _flag('razorpay_enabled');
}

/// One line for an ad-hoc invoice.
class InvoiceLine {
  const InvoiceLine({
    required this.description,
    required this.unitPaise,
    this.qty = 1,
    this.kind = 'other',
    this.gstRate = 0,
  });

  final String description;
  final int unitPaise;
  final int qty;
  final String kind;
  final num gstRate;

  Map<String, dynamic> toJson() => {
    'description': description,
    'unit_paise': unitPaise,
    'qty': qty,
    'kind': kind,
    'gst_rate': gstRate,
  };
}

/// Which invoices a Payments tab shows.
enum InvoiceTab { due, overdue, paid }

String? paymentDate(DateTime? d) => _dateOut(d);
