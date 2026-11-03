import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../../members/application/members_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';

part 'payments_providers.g.dart';

/// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.
@riverpod
class InvoiceList extends _$InvoiceList {
  @override
  Future<Paged<Invoice>> build(InvoiceTab tab, String search) =>
      ref.watch(paymentsRepositoryProvider).invoices(tab: tab, search: search);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(paymentsRepositoryProvider)
          .invoices(tab: tab, search: search, offset: current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

/// Filters for the payment history (2.10).
class PaymentFilter {
  const PaymentFilter({this.status = PaymentStatus.confirmed, this.search = '', this.mode, this.from, this.to});

  final PaymentStatus status;
  final String search;
  final PaymentMode? mode;
  final DateTime? from;
  final DateTime? to;

  static const pending = PaymentFilter(status: PaymentStatus.pendingVerification);

  bool get isFiltered => mode != null || from != null || to != null;

  PaymentFilter copyWith({String? search, PaymentMode? Function()? mode, (DateTime?, DateTime?)? range}) =>
      PaymentFilter(
        status: status,
        search: search ?? this.search,
        mode: mode == null ? this.mode : mode(),
        from: range == null ? from : range.$1,
        to: range == null ? to : range.$2,
      );

  @override
  bool operator ==(Object other) =>
      other is PaymentFilter &&
      other.status == status &&
      other.search == search &&
      other.mode == mode &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(status, search, mode, from, to);
}

/// Paged payment history, newest first.
@riverpod
class PaymentHistory extends _$PaymentHistory {
  Future<Paged<Payment>> _page(int offset) => ref
      .read(paymentsRepositoryProvider)
      .payments(
        status: filter.status,
        search: filter.search,
        mode: filter.mode,
        from: filter.from,
        to: filter.to,
        offset: offset,
      );

  @override
  Future<Paged<Payment>> build(PaymentFilter filter) {
    ref.watch(paymentsRepositoryProvider);
    return _page(0);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await _page(current.items.length);
      state = AsyncData(Paged([...current.items, ...next.items], hasMore: next.hasMore));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}

@riverpod
Future<BillingProfile> billingProfile(Ref ref) => ref.watch(paymentsRepositoryProvider).billingProfile();

@riverpod
Future<Invoice> invoiceDetail(Ref ref, String id) => ref.watch(paymentsRepositoryProvider).invoice(id);

@riverpod
Future<List<Invoice>> memberInvoices(Ref ref, String memberId) =>
    ref.watch(paymentsRepositoryProvider).memberInvoices(memberId);

@riverpod
Future<List<Payment>> memberPayments(Ref ref, String memberId) async =>
    (await ref.watch(paymentsRepositoryProvider).payments(memberId: memberId)).items;

/// A member's "I've paid" claims still waiting for the desk.
@riverpod
Future<List<Payment>> memberPendingClaims(Ref ref, String memberId) async =>
    (await ref
            .watch(paymentsRepositoryProvider)
            .payments(memberId: memberId, status: PaymentStatus.pendingVerification))
        .items;

@riverpod
Future<int> memberCredit(Ref ref, String memberId) => ref.watch(paymentsRepositoryProvider).creditBalance(memberId);

@riverpod
Future<DuesSummary> duesSummary(Ref ref) => ref.watch(paymentsRepositoryProvider).duesSummary();

@riverpod
Future<List<DueReminder>> remindersToday(Ref ref) => ref.watch(paymentsRepositoryProvider).remindersToday();

/// The signed-in staff member's own collections for today (day close).
@riverpod
Future<DaySummary> myDay(Ref ref) => ref.watch(paymentsRepositoryProvider).daySummary();

@riverpod
Future<List<DayClose>> dayCloses(Ref ref) => ref.watch(paymentsRepositoryProvider).dayCloses();

/// Revenue windows on the owner dashboard.
enum RevenuePeriod { today, week, month }

(DateTime, DateTime) periodRange(RevenuePeriod p, {DateTime? now}) {
  final today = IstDates.today(now: now);
  return switch (p) {
    RevenuePeriod.today => (today, today),
    // Weeks start on Monday.
    RevenuePeriod.week => (today.subtract(Duration(days: today.weekday - 1)), today),
    RevenuePeriod.month => (DateTime.utc(today.year, today.month), today),
  };
}

@riverpod
Future<CollectionsSummary> collections(Ref ref, RevenuePeriod period) {
  final (from, to) = periodRange(period, now: ref.watch(clockProvider)());
  return ref.watch(paymentsRepositoryProvider).collections(from: from, to: to);
}

/// The last 30 days, for the dashboard sparkline.
@riverpod
Future<CollectionsSummary> collectionsTrend(Ref ref) {
  final today = IstDates.today(now: ref.watch(clockProvider)());
  return ref.watch(paymentsRepositoryProvider).collections(from: today.subtract(const Duration(days: 29)), to: today);
}

/// Expenses for one calendar month (owner).
@riverpod
Future<List<Expense>> expensesForMonth(Ref ref, DateTime month) {
  final from = DateTime.utc(month.year, month.month);
  final to = DateTime.utc(month.year, month.month + 1, 0);
  return ref.watch(paymentsRepositoryProvider).expenses(from: from, to: to);
}

/// Refresh everything money-related after a collection, void or claim.
extension PaymentsRefresh on WidgetRef {
  void refreshPayments({String? memberId, String? invoiceId}) {
    invalidate(invoiceListProvider);
    invalidate(paymentHistoryProvider);
    invalidate(duesSummaryProvider);
    invalidate(remindersTodayProvider);
    invalidate(myDayProvider);
    invalidate(dayClosesProvider);
    invalidate(collectionsProvider);
    invalidate(collectionsTrendProvider);
    invalidate(needsActionProvider);
    if (invoiceId != null) invalidate(invoiceDetailProvider(invoiceId));
    if (memberId != null) {
      invalidate(memberInvoicesProvider(memberId));
      invalidate(memberPaymentsProvider(memberId));
      invalidate(memberPendingClaimsProvider(memberId));
      invalidate(memberCreditProvider(memberId));
      invalidate(memberProvider(memberId));
      invalidate(memberEventsProvider(memberId));
    }
  }
}
