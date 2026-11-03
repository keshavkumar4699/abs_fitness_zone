// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => _InvoiceItem(
  id: json['id'] as String,
  position: (json['position'] as num).toInt(),
  kind: json['kind'] as String? ?? 'other',
  description: json['description'] as String,
  qty: (json['qty'] as num?)?.toInt() ?? 1,
  unitPaise: (json['unit_paise'] as num).toInt(),
  grossPaise: (json['gross_paise'] as num).toInt(),
  discountPaise: (json['discount_paise'] as num?)?.toInt() ?? 0,
  netPaise: (json['net_paise'] as num).toInt(),
  gstRate: json['gst_rate'] as num? ?? 0,
  taxablePaise: (json['taxable_paise'] as num?)?.toInt() ?? 0,
  gstPaise: (json['gst_paise'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$InvoiceItemToJson(_InvoiceItem instance) => <String, dynamic>{
  'id': instance.id,
  'position': instance.position,
  'kind': instance.kind,
  'description': instance.description,
  'qty': instance.qty,
  'unit_paise': instance.unitPaise,
  'gross_paise': instance.grossPaise,
  'discount_paise': instance.discountPaise,
  'net_paise': instance.netPaise,
  'gst_rate': instance.gstRate,
  'taxable_paise': instance.taxablePaise,
  'gst_paise': instance.gstPaise,
};

_Instalment _$InstalmentFromJson(Map<String, dynamic> json) => _Instalment(
  id: json['id'] as String,
  seq: (json['seq'] as num).toInt(),
  dueDate: _date(json['due_date']),
  amountPaise: (json['amount_paise'] as num).toInt(),
  status: json['status'] as String? ?? 'due',
);

Map<String, dynamic> _$InstalmentToJson(_Instalment instance) => <String, dynamic>{
  'id': instance.id,
  'seq': instance.seq,
  'due_date': _dateOut(instance.dueDate),
  'amount_paise': instance.amountPaise,
  'status': instance.status,
};

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  receiptNo: json['receipt_no'] as String?,
  invoiceId: json['invoice_id'] as String?,
  memberId: json['member_id'] as String?,
  memberName: json['member_name'] as String,
  amountPaise: (json['amount_paise'] as num).toInt(),
  appliedPaise: (json['applied_paise'] as num?)?.toInt() ?? 0,
  refundedPaise: (json['refunded_paise'] as num?)?.toInt() ?? 0,
  mode: $enumDecode(_$PaymentModeEnumMap, json['mode']),
  utr: json['utr'] as String?,
  paidAt: DateTime.parse(json['paid_at'] as String),
  paidOn: _date(json['paid_on']),
  collectedBy: json['collected_by'] as String?,
  status: $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ?? PaymentStatus.confirmed,
  note: json['note'] as String?,
  voidedReason: json['voided_reason'] as String?,
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'receipt_no': instance.receiptNo,
  'invoice_id': instance.invoiceId,
  'member_id': instance.memberId,
  'member_name': instance.memberName,
  'amount_paise': instance.amountPaise,
  'applied_paise': instance.appliedPaise,
  'refunded_paise': instance.refundedPaise,
  'mode': _$PaymentModeEnumMap[instance.mode]!,
  'utr': instance.utr,
  'paid_at': instance.paidAt.toIso8601String(),
  'paid_on': _dateOut(instance.paidOn),
  'collected_by': instance.collectedBy,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'note': instance.note,
  'voided_reason': instance.voidedReason,
};

const _$PaymentModeEnumMap = {
  PaymentMode.cash: 'cash',
  PaymentMode.upi: 'upi',
  PaymentMode.card: 'card',
  PaymentMode.bank: 'bank',
  PaymentMode.online: 'online',
  PaymentMode.credit: 'credit',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.confirmed: 'confirmed',
  PaymentStatus.pendingVerification: 'pending_verification',
  PaymentStatus.rejected: 'rejected',
  PaymentStatus.voided: 'voided',
};

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String,
  invoiceNo: json['invoice_no'] as String,
  memberId: json['member_id'] as String?,
  memberName: json['member_name'] as String,
  memberCode: json['member_code'] as String,
  memberPhone: json['member_phone'] as String?,
  membershipId: json['membership_id'] as String?,
  issueDate: _date(json['issue_date']),
  dueDate: _date(json['due_date']),
  nextDueDate: _date(json['next_due_date']),
  subtotalPaise: (json['subtotal_paise'] as num?)?.toInt() ?? 0,
  discountPaise: (json['discount_paise'] as num?)?.toInt() ?? 0,
  discountReason: json['discount_reason'] as String?,
  taxablePaise: (json['taxable_paise'] as num?)?.toInt() ?? 0,
  cgstPaise: (json['cgst_paise'] as num?)?.toInt() ?? 0,
  sgstPaise: (json['sgst_paise'] as num?)?.toInt() ?? 0,
  totalPaise: (json['total_paise'] as num?)?.toInt() ?? 0,
  paidPaise: (json['paid_paise'] as num?)?.toInt() ?? 0,
  balancePaise: (json['balance_paise'] as num?)?.toInt() ?? 0,
  status: $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ?? InvoiceStatus.unpaid,
  overdueDays: (json['overdue_days'] as num?)?.toInt() ?? 0,
  gatewayLinkUrl: json['gateway_link_url'] as String?,
  voidedReason: json['voided_reason'] as String?,
  items:
      (json['invoice_items'] as List<dynamic>?)?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  instalments:
      (json['instalments'] as List<dynamic>?)?.map((e) => Instalment.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  payments:
      (json['payments'] as List<dynamic>?)?.map((e) => Payment.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'invoice_no': instance.invoiceNo,
  'member_id': instance.memberId,
  'member_name': instance.memberName,
  'member_code': instance.memberCode,
  'member_phone': instance.memberPhone,
  'membership_id': instance.membershipId,
  'issue_date': _dateOut(instance.issueDate),
  'due_date': _dateOut(instance.dueDate),
  'next_due_date': _dateOut(instance.nextDueDate),
  'subtotal_paise': instance.subtotalPaise,
  'discount_paise': instance.discountPaise,
  'discount_reason': instance.discountReason,
  'taxable_paise': instance.taxablePaise,
  'cgst_paise': instance.cgstPaise,
  'sgst_paise': instance.sgstPaise,
  'total_paise': instance.totalPaise,
  'paid_paise': instance.paidPaise,
  'balance_paise': instance.balancePaise,
  'status': _$InvoiceStatusEnumMap[instance.status]!,
  'overdue_days': instance.overdueDays,
  'gateway_link_url': instance.gatewayLinkUrl,
  'voided_reason': instance.voidedReason,
  'invoice_items': instance.items.map((e) => e.toJson()).toList(),
  'instalments': instance.instalments.map((e) => e.toJson()).toList(),
  'payments': instance.payments.map((e) => e.toJson()).toList(),
};

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.unpaid: 'unpaid',
  InvoiceStatus.partial: 'partial',
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.voided: 'void',
};

_PaymentResult _$PaymentResultFromJson(Map<String, dynamic> json) => _PaymentResult(
  paymentId: json['payment_id'] as String,
  receiptNo: json['receipt_no'] as String?,
  amountPaise: (json['amount_paise'] as num).toInt(),
  appliedPaise: (json['applied_paise'] as num?)?.toInt() ?? 0,
  creditPaise: (json['credit_paise'] as num?)?.toInt() ?? 0,
  balancePaise: (json['balance_paise'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PaymentResultToJson(_PaymentResult instance) => <String, dynamic>{
  'payment_id': instance.paymentId,
  'receipt_no': instance.receiptNo,
  'amount_paise': instance.amountPaise,
  'applied_paise': instance.appliedPaise,
  'credit_paise': instance.creditPaise,
  'balance_paise': instance.balancePaise,
};

_DaySummary _$DaySummaryFromJson(Map<String, dynamic> json) => _DaySummary(
  day: _date(json['day']),
  cash: (json['cash'] as num?)?.toInt() ?? 0,
  upi: (json['upi'] as num?)?.toInt() ?? 0,
  card: (json['card'] as num?)?.toInt() ?? 0,
  bank: (json['bank'] as num?)?.toInt() ?? 0,
  online: (json['online'] as num?)?.toInt() ?? 0,
  credit: (json['credit'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  count: (json['count'] as num?)?.toInt() ?? 0,
  closed: json['closed'] as bool? ?? false,
  closedAt: json['closed_at'] == null ? null : DateTime.parse(json['closed_at'] as String),
  countedCash: (json['counted_cash'] as num?)?.toInt(),
  difference: (json['difference'] as num?)?.toInt(),
);

Map<String, dynamic> _$DaySummaryToJson(_DaySummary instance) => <String, dynamic>{
  'day': _dateOut(instance.day),
  'cash': instance.cash,
  'upi': instance.upi,
  'card': instance.card,
  'bank': instance.bank,
  'online': instance.online,
  'credit': instance.credit,
  'total': instance.total,
  'count': instance.count,
  'closed': instance.closed,
  'closed_at': instance.closedAt?.toIso8601String(),
  'counted_cash': instance.countedCash,
  'difference': instance.difference,
};

_DayClose _$DayCloseFromJson(Map<String, dynamic> json) => _DayClose(
  id: json['id'] as String,
  staffId: json['staff_id'] as String,
  day: _date(json['day']),
  totalPaise: (json['total_paise'] as num?)?.toInt() ?? 0,
  cashPaise: (json['cash_paise'] as num?)?.toInt() ?? 0,
  countedCashPaise: (json['counted_cash_paise'] as num?)?.toInt() ?? 0,
  differencePaise: (json['difference_paise'] as num?)?.toInt() ?? 0,
  paymentsCount: (json['payments_count'] as num?)?.toInt() ?? 0,
  note: json['note'] as String?,
  closedAt: DateTime.parse(json['closed_at'] as String),
  reopenedAt: json['reopened_at'] == null ? null : DateTime.parse(json['reopened_at'] as String),
  staffName: json['staff_name'] as String?,
);

Map<String, dynamic> _$DayCloseToJson(_DayClose instance) => <String, dynamic>{
  'id': instance.id,
  'staff_id': instance.staffId,
  'day': _dateOut(instance.day),
  'total_paise': instance.totalPaise,
  'cash_paise': instance.cashPaise,
  'counted_cash_paise': instance.countedCashPaise,
  'difference_paise': instance.differencePaise,
  'payments_count': instance.paymentsCount,
  'note': instance.note,
  'closed_at': instance.closedAt.toIso8601String(),
  'reopened_at': instance.reopenedAt?.toIso8601String(),
  'staff_name': instance.staffName,
};

_DuesSummary _$DuesSummaryFromJson(Map<String, dynamic> json) => _DuesSummary(
  overdueCount: (json['overdue_count'] as num?)?.toInt() ?? 0,
  overduePaise: (json['overdue_paise'] as num?)?.toInt() ?? 0,
  dueCount: (json['due_count'] as num?)?.toInt() ?? 0,
  duePaise: (json['due_paise'] as num?)?.toInt() ?? 0,
  pendingClaims: (json['pending_claims'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DuesSummaryToJson(_DuesSummary instance) => <String, dynamic>{
  'overdue_count': instance.overdueCount,
  'overdue_paise': instance.overduePaise,
  'due_count': instance.dueCount,
  'due_paise': instance.duePaise,
  'pending_claims': instance.pendingClaims,
};

_DayAmount _$DayAmountFromJson(Map<String, dynamic> json) =>
    _DayAmount(day: _date(json['day']), paise: (json['paise'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$DayAmountToJson(_DayAmount instance) => <String, dynamic>{
  'day': _dateOut(instance.day),
  'paise': instance.paise,
};

_CollectionsSummary _$CollectionsSummaryFromJson(Map<String, dynamic> json) => _CollectionsSummary(
  collected: (json['collected'] as num?)?.toInt() ?? 0,
  byMode:
      (json['by_mode'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, (e as num).toInt())) ??
      const <String, int>{},
  byDay:
      (json['by_day'] as List<dynamic>?)?.map((e) => DayAmount.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  invoiced: (json['invoiced'] as num?)?.toInt() ?? 0,
  outstanding: (json['outstanding'] as num?)?.toInt() ?? 0,
  refunds: (json['refunds'] as num?)?.toInt() ?? 0,
  expenses: (json['expenses'] as num?)?.toInt() ?? 0,
  paymentsCount: (json['payments_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CollectionsSummaryToJson(_CollectionsSummary instance) => <String, dynamic>{
  'collected': instance.collected,
  'by_mode': instance.byMode,
  'by_day': instance.byDay.map((e) => e.toJson()).toList(),
  'invoiced': instance.invoiced,
  'outstanding': instance.outstanding,
  'refunds': instance.refunds,
  'expenses': instance.expenses,
  'payments_count': instance.paymentsCount,
};

_DueReminder _$DueReminderFromJson(Map<String, dynamic> json) => _DueReminder(
  invoiceId: json['invoice_id'] as String,
  invoiceNo: json['invoice_no'] as String,
  memberId: json['member_id'] as String?,
  memberName: json['member_name'] as String,
  memberPhone: json['member_phone'] as String?,
  balancePaise: (json['balance_paise'] as num).toInt(),
  nextDueDate: _date(json['next_due_date']),
  daysToDue: (json['days_to_due'] as num).toInt(),
);

Map<String, dynamic> _$DueReminderToJson(_DueReminder instance) => <String, dynamic>{
  'invoice_id': instance.invoiceId,
  'invoice_no': instance.invoiceNo,
  'member_id': instance.memberId,
  'member_name': instance.memberName,
  'member_phone': instance.memberPhone,
  'balance_paise': instance.balancePaise,
  'next_due_date': _dateOut(instance.nextDueDate),
  'days_to_due': instance.daysToDue,
};

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String?,
  category: json['category'] as String,
  amountPaise: (json['amount_paise'] as num).toInt(),
  spentOn: _date(json['spent_on']),
  note: json['note'] as String?,
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'amount_paise': instance.amountPaise,
  'spent_on': _dateOut(instance.spentOn),
  'note': instance.note,
};
