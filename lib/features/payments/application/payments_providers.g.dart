// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.

@ProviderFor(InvoiceList)
final invoiceListProvider = InvoiceListFamily._();

/// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.
final class InvoiceListProvider
    extends $AsyncNotifierProvider<InvoiceList, Paged<Invoice>> {
  /// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.
  InvoiceListProvider._({
    required InvoiceListFamily super.from,
    required (InvoiceTab, String) super.argument,
  }) : super(
         retry: null,
         name: r'invoiceListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$invoiceListHash();

  @override
  String toString() {
    return r'invoiceListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  InvoiceList create() => InvoiceList();

  @override
  bool operator ==(Object other) {
    return other is InvoiceListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$invoiceListHash() => r'361c50bf56a9dcf08f272a0c42c96827fb2fe676';

/// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.

final class InvoiceListFamily extends $Family
    with
        $ClassFamilyOverride<
          InvoiceList,
          AsyncValue<Paged<Invoice>>,
          Paged<Invoice>,
          FutureOr<Paged<Invoice>>,
          (InvoiceTab, String)
        > {
  InvoiceListFamily._()
    : super(
        retry: null,
        name: r'invoiceListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.

  InvoiceListProvider call(InvoiceTab tab, String search) =>
      InvoiceListProvider._(argument: (tab, search), from: this);

  @override
  String toString() => r'invoiceListProvider';
}

/// Paged invoices for one Payments tab (Due / Overdue / Paid), searchable.

abstract class _$InvoiceList extends $AsyncNotifier<Paged<Invoice>> {
  late final _$args = ref.$arg as (InvoiceTab, String);
  InvoiceTab get tab => _$args.$1;
  String get search => _$args.$2;

  FutureOr<Paged<Invoice>> build(InvoiceTab tab, String search);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<Invoice>>, Paged<Invoice>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<Invoice>>, Paged<Invoice>>,
              AsyncValue<Paged<Invoice>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// Paged payment history, newest first.

@ProviderFor(PaymentHistory)
final paymentHistoryProvider = PaymentHistoryFamily._();

/// Paged payment history, newest first.
final class PaymentHistoryProvider
    extends $AsyncNotifierProvider<PaymentHistory, Paged<Payment>> {
  /// Paged payment history, newest first.
  PaymentHistoryProvider._({
    required PaymentHistoryFamily super.from,
    required PaymentFilter super.argument,
  }) : super(
         retry: null,
         name: r'paymentHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentHistoryHash();

  @override
  String toString() {
    return r'paymentHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PaymentHistory create() => PaymentHistory();

  @override
  bool operator ==(Object other) {
    return other is PaymentHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentHistoryHash() => r'a96c2f658a2a591245ca38a17bf0a8291afdd4bd';

/// Paged payment history, newest first.

final class PaymentHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          PaymentHistory,
          AsyncValue<Paged<Payment>>,
          Paged<Payment>,
          FutureOr<Paged<Payment>>,
          PaymentFilter
        > {
  PaymentHistoryFamily._()
    : super(
        retry: null,
        name: r'paymentHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paged payment history, newest first.

  PaymentHistoryProvider call(PaymentFilter filter) =>
      PaymentHistoryProvider._(argument: filter, from: this);

  @override
  String toString() => r'paymentHistoryProvider';
}

/// Paged payment history, newest first.

abstract class _$PaymentHistory extends $AsyncNotifier<Paged<Payment>> {
  late final _$args = ref.$arg as PaymentFilter;
  PaymentFilter get filter => _$args;

  FutureOr<Paged<Payment>> build(PaymentFilter filter);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<Payment>>, Paged<Payment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<Payment>>, Paged<Payment>>,
              AsyncValue<Paged<Payment>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(billingProfile)
final billingProfileProvider = BillingProfileProvider._();

final class BillingProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<BillingProfile>,
          BillingProfile,
          FutureOr<BillingProfile>
        >
    with $FutureModifier<BillingProfile>, $FutureProvider<BillingProfile> {
  BillingProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billingProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billingProfileHash();

  @$internal
  @override
  $FutureProviderElement<BillingProfile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BillingProfile> create(Ref ref) {
    return billingProfile(ref);
  }
}

String _$billingProfileHash() => r'2086dfab21ad9ea562909e0c732a6ebaca384632';

@ProviderFor(invoiceDetail)
final invoiceDetailProvider = InvoiceDetailFamily._();

final class InvoiceDetailProvider
    extends $FunctionalProvider<AsyncValue<Invoice>, Invoice, FutureOr<Invoice>>
    with $FutureModifier<Invoice>, $FutureProvider<Invoice> {
  InvoiceDetailProvider._({
    required InvoiceDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'invoiceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$invoiceDetailHash();

  @override
  String toString() {
    return r'invoiceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Invoice> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Invoice> create(Ref ref) {
    final argument = this.argument as String;
    return invoiceDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$invoiceDetailHash() => r'e8f8f3aca43ed12a8aa4d62a30dba658f68b5743';

final class InvoiceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Invoice>, String> {
  InvoiceDetailFamily._()
    : super(
        retry: null,
        name: r'invoiceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InvoiceDetailProvider call(String id) =>
      InvoiceDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'invoiceDetailProvider';
}

@ProviderFor(memberInvoices)
final memberInvoicesProvider = MemberInvoicesFamily._();

final class MemberInvoicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invoice>>,
          List<Invoice>,
          FutureOr<List<Invoice>>
        >
    with $FutureModifier<List<Invoice>>, $FutureProvider<List<Invoice>> {
  MemberInvoicesProvider._({
    required MemberInvoicesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'memberInvoicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberInvoicesHash();

  @override
  String toString() {
    return r'memberInvoicesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Invoice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invoice>> create(Ref ref) {
    final argument = this.argument as String;
    return memberInvoices(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberInvoicesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberInvoicesHash() => r'ed7da263aead155e55d93698a3ff99fec4410fa3';

final class MemberInvoicesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Invoice>>, String> {
  MemberInvoicesFamily._()
    : super(
        retry: null,
        name: r'memberInvoicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberInvoicesProvider call(String memberId) =>
      MemberInvoicesProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberInvoicesProvider';
}

@ProviderFor(memberPayments)
final memberPaymentsProvider = MemberPaymentsFamily._();

final class MemberPaymentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          FutureOr<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $FutureProvider<List<Payment>> {
  MemberPaymentsProvider._({
    required MemberPaymentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'memberPaymentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberPaymentsHash();

  @override
  String toString() {
    return r'memberPaymentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Payment>> create(Ref ref) {
    final argument = this.argument as String;
    return memberPayments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberPaymentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberPaymentsHash() => r'2f95221ad148bb58a0093fb64b291315784d401b';

final class MemberPaymentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Payment>>, String> {
  MemberPaymentsFamily._()
    : super(
        retry: null,
        name: r'memberPaymentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberPaymentsProvider call(String memberId) =>
      MemberPaymentsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberPaymentsProvider';
}

/// A member's "I've paid" claims still waiting for the desk.

@ProviderFor(memberPendingClaims)
final memberPendingClaimsProvider = MemberPendingClaimsFamily._();

/// A member's "I've paid" claims still waiting for the desk.

final class MemberPendingClaimsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          FutureOr<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $FutureProvider<List<Payment>> {
  /// A member's "I've paid" claims still waiting for the desk.
  MemberPendingClaimsProvider._({
    required MemberPendingClaimsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'memberPendingClaimsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberPendingClaimsHash();

  @override
  String toString() {
    return r'memberPendingClaimsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Payment>> create(Ref ref) {
    final argument = this.argument as String;
    return memberPendingClaims(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberPendingClaimsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberPendingClaimsHash() =>
    r'dfbbae46bc4b7d0ffa1f139ccdee8f4e22cec0a9';

/// A member's "I've paid" claims still waiting for the desk.

final class MemberPendingClaimsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Payment>>, String> {
  MemberPendingClaimsFamily._()
    : super(
        retry: null,
        name: r'memberPendingClaimsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A member's "I've paid" claims still waiting for the desk.

  MemberPendingClaimsProvider call(String memberId) =>
      MemberPendingClaimsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberPendingClaimsProvider';
}

@ProviderFor(memberCredit)
final memberCreditProvider = MemberCreditFamily._();

final class MemberCreditProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  MemberCreditProvider._({
    required MemberCreditFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'memberCreditProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberCreditHash();

  @override
  String toString() {
    return r'memberCreditProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return memberCredit(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberCreditProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberCreditHash() => r'0e4255048fccc060cb8682d1391686b8e50b1511';

final class MemberCreditFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  MemberCreditFamily._()
    : super(
        retry: null,
        name: r'memberCreditProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberCreditProvider call(String memberId) =>
      MemberCreditProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberCreditProvider';
}

@ProviderFor(duesSummary)
final duesSummaryProvider = DuesSummaryProvider._();

final class DuesSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DuesSummary>,
          DuesSummary,
          FutureOr<DuesSummary>
        >
    with $FutureModifier<DuesSummary>, $FutureProvider<DuesSummary> {
  DuesSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'duesSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$duesSummaryHash();

  @$internal
  @override
  $FutureProviderElement<DuesSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DuesSummary> create(Ref ref) {
    return duesSummary(ref);
  }
}

String _$duesSummaryHash() => r'9ba775dd71b7b9609c19a2b7ae30b3094f49c36d';

@ProviderFor(remindersToday)
final remindersTodayProvider = RemindersTodayProvider._();

final class RemindersTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DueReminder>>,
          List<DueReminder>,
          FutureOr<List<DueReminder>>
        >
    with
        $FutureModifier<List<DueReminder>>,
        $FutureProvider<List<DueReminder>> {
  RemindersTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remindersTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remindersTodayHash();

  @$internal
  @override
  $FutureProviderElement<List<DueReminder>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DueReminder>> create(Ref ref) {
    return remindersToday(ref);
  }
}

String _$remindersTodayHash() => r'afba267b6bf9f4566f43d25c2408fd8f647cd197';

/// The signed-in staff member's own collections for today (day close).

@ProviderFor(myDay)
final myDayProvider = MyDayProvider._();

/// The signed-in staff member's own collections for today (day close).

final class MyDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<DaySummary>,
          DaySummary,
          FutureOr<DaySummary>
        >
    with $FutureModifier<DaySummary>, $FutureProvider<DaySummary> {
  /// The signed-in staff member's own collections for today (day close).
  MyDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDayHash();

  @$internal
  @override
  $FutureProviderElement<DaySummary> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DaySummary> create(Ref ref) {
    return myDay(ref);
  }
}

String _$myDayHash() => r'2c07435f01f7104fff79d44a35a93dea78d840b2';

@ProviderFor(dayCloses)
final dayClosesProvider = DayClosesProvider._();

final class DayClosesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DayClose>>,
          List<DayClose>,
          FutureOr<List<DayClose>>
        >
    with $FutureModifier<List<DayClose>>, $FutureProvider<List<DayClose>> {
  DayClosesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dayClosesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dayClosesHash();

  @$internal
  @override
  $FutureProviderElement<List<DayClose>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DayClose>> create(Ref ref) {
    return dayCloses(ref);
  }
}

String _$dayClosesHash() => r'eacab16f93f5d512b1cecc230b394462ae33e62c';

@ProviderFor(collections)
final collectionsProvider = CollectionsFamily._();

final class CollectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<CollectionsSummary>,
          CollectionsSummary,
          FutureOr<CollectionsSummary>
        >
    with
        $FutureModifier<CollectionsSummary>,
        $FutureProvider<CollectionsSummary> {
  CollectionsProvider._({
    required CollectionsFamily super.from,
    required RevenuePeriod super.argument,
  }) : super(
         retry: null,
         name: r'collectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$collectionsHash();

  @override
  String toString() {
    return r'collectionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CollectionsSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CollectionsSummary> create(Ref ref) {
    final argument = this.argument as RevenuePeriod;
    return collections(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionsHash() => r'e1e933e7af23177d6ce275a062f185fe58b466a7';

final class CollectionsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<CollectionsSummary>, RevenuePeriod> {
  CollectionsFamily._()
    : super(
        retry: null,
        name: r'collectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CollectionsProvider call(RevenuePeriod period) =>
      CollectionsProvider._(argument: period, from: this);

  @override
  String toString() => r'collectionsProvider';
}

/// The last 30 days, for the dashboard sparkline.

@ProviderFor(collectionsTrend)
final collectionsTrendProvider = CollectionsTrendProvider._();

/// The last 30 days, for the dashboard sparkline.

final class CollectionsTrendProvider
    extends
        $FunctionalProvider<
          AsyncValue<CollectionsSummary>,
          CollectionsSummary,
          FutureOr<CollectionsSummary>
        >
    with
        $FutureModifier<CollectionsSummary>,
        $FutureProvider<CollectionsSummary> {
  /// The last 30 days, for the dashboard sparkline.
  CollectionsTrendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionsTrendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionsTrendHash();

  @$internal
  @override
  $FutureProviderElement<CollectionsSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CollectionsSummary> create(Ref ref) {
    return collectionsTrend(ref);
  }
}

String _$collectionsTrendHash() => r'807078acef455ebb8c054061c44bbcbfb5d37aad';

/// Expenses for one calendar month (owner).

@ProviderFor(expensesForMonth)
final expensesForMonthProvider = ExpensesForMonthFamily._();

/// Expenses for one calendar month (owner).

final class ExpensesForMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
  /// Expenses for one calendar month (owner).
  ExpensesForMonthProvider._({
    required ExpensesForMonthFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'expensesForMonthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesForMonthHash();

  @override
  String toString() {
    return r'expensesForMonthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return expensesForMonth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesForMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesForMonthHash() => r'9887acd7d1fafd62cb8d85fc30ef270281a3d8a4';

/// Expenses for one calendar month (owner).

final class ExpensesForMonthFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Expense>>, DateTime> {
  ExpensesForMonthFamily._()
    : super(
        retry: null,
        name: r'expensesForMonthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Expenses for one calendar month (owner).

  ExpensesForMonthProvider call(DateTime month) =>
      ExpensesForMonthProvider._(argument: month, from: this);

  @override
  String toString() => r'expensesForMonthProvider';
}
