// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paged, searchable, filterable members list (1.13).

@ProviderFor(MemberList)
final memberListProvider = MemberListFamily._();

/// Paged, searchable, filterable members list (1.13).
final class MemberListProvider extends $AsyncNotifierProvider<MemberList, Paged<Member>> {
  /// Paged, searchable, filterable members list (1.13).
  MemberListProvider._({required MemberListFamily super.from, required MemberQuery super.argument})
    : super(
        retry: null,
        name: r'memberListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberListHash();

  @override
  String toString() {
    return r'memberListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MemberList create() => MemberList();

  @override
  bool operator ==(Object other) {
    return other is MemberListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberListHash() => r'6e055b8502d9b361df5c67a3825af9830b051271';

/// Paged, searchable, filterable members list (1.13).

final class MemberListFamily extends $Family
    with
        $ClassFamilyOverride<
          MemberList,
          AsyncValue<Paged<Member>>,
          Paged<Member>,
          FutureOr<Paged<Member>>,
          MemberQuery
        > {
  MemberListFamily._()
    : super(
        retry: null,
        name: r'memberListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paged, searchable, filterable members list (1.13).

  MemberListProvider call(MemberQuery query) => MemberListProvider._(argument: query, from: this);

  @override
  String toString() => r'memberListProvider';
}

/// Paged, searchable, filterable members list (1.13).

abstract class _$MemberList extends $AsyncNotifier<Paged<Member>> {
  late final _$args = ref.$arg as MemberQuery;
  MemberQuery get query => _$args;

  FutureOr<Paged<Member>> build(MemberQuery query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<Member>>, Paged<Member>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<Member>>, Paged<Member>>,
              AsyncValue<Paged<Member>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(member)
final memberProvider = MemberFamily._();

final class MemberProvider extends $FunctionalProvider<AsyncValue<Member>, Member, FutureOr<Member>>
    with $FutureModifier<Member>, $FutureProvider<Member> {
  MemberProvider._({required MemberFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberHash();

  @override
  String toString() {
    return r'memberProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Member> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Member> create(Ref ref) {
    final argument = this.argument as String;
    return member(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberHash() => r'dc2355f98254b155f2b75741a4f92f0fdc82065c';

final class MemberFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Member>, String> {
  MemberFamily._()
    : super(
        retry: null,
        name: r'memberProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberProvider call(String id) => MemberProvider._(argument: id, from: this);

  @override
  String toString() => r'memberProvider';
}

@ProviderFor(memberMemberships)
final memberMembershipsProvider = MemberMembershipsFamily._();

final class MemberMembershipsProvider
    extends $FunctionalProvider<AsyncValue<List<Membership>>, List<Membership>, FutureOr<List<Membership>>>
    with $FutureModifier<List<Membership>>, $FutureProvider<List<Membership>> {
  MemberMembershipsProvider._({required MemberMembershipsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberMembershipsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberMembershipsHash();

  @override
  String toString() {
    return r'memberMembershipsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Membership>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Membership>> create(Ref ref) {
    final argument = this.argument as String;
    return memberMemberships(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberMembershipsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberMembershipsHash() => r'1ecca72cb36927c01375ae0c4b18100145bb243f';

final class MemberMembershipsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Membership>>, String> {
  MemberMembershipsFamily._()
    : super(
        retry: null,
        name: r'memberMembershipsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberMembershipsProvider call(String id) => MemberMembershipsProvider._(argument: id, from: this);

  @override
  String toString() => r'memberMembershipsProvider';
}

@ProviderFor(memberHealth)
final memberHealthProvider = MemberHealthFamily._();

final class MemberHealthProvider
    extends $FunctionalProvider<AsyncValue<MemberHealth?>, MemberHealth?, FutureOr<MemberHealth?>>
    with $FutureModifier<MemberHealth?>, $FutureProvider<MemberHealth?> {
  MemberHealthProvider._({required MemberHealthFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberHealthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberHealthHash();

  @override
  String toString() {
    return r'memberHealthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MemberHealth?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<MemberHealth?> create(Ref ref) {
    final argument = this.argument as String;
    return memberHealth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberHealthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberHealthHash() => r'07a653bf8f1ba05965db728465261136b0b457a0';

final class MemberHealthFamily extends $Family with $FunctionalFamilyOverride<FutureOr<MemberHealth?>, String> {
  MemberHealthFamily._()
    : super(
        retry: null,
        name: r'memberHealthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberHealthProvider call(String id) => MemberHealthProvider._(argument: id, from: this);

  @override
  String toString() => r'memberHealthProvider';
}

@ProviderFor(memberMeasurements)
final memberMeasurementsProvider = MemberMeasurementsFamily._();

final class MemberMeasurementsProvider
    extends $FunctionalProvider<AsyncValue<List<Measurement>>, List<Measurement>, FutureOr<List<Measurement>>>
    with $FutureModifier<List<Measurement>>, $FutureProvider<List<Measurement>> {
  MemberMeasurementsProvider._({required MemberMeasurementsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberMeasurementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberMeasurementsHash();

  @override
  String toString() {
    return r'memberMeasurementsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Measurement>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Measurement>> create(Ref ref) {
    final argument = this.argument as String;
    return memberMeasurements(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberMeasurementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberMeasurementsHash() => r'df2e6ebffd29c830c67cf827b03e0e47a45ad6cb';

final class MemberMeasurementsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Measurement>>, String> {
  MemberMeasurementsFamily._()
    : super(
        retry: null,
        name: r'memberMeasurementsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberMeasurementsProvider call(String id) => MemberMeasurementsProvider._(argument: id, from: this);

  @override
  String toString() => r'memberMeasurementsProvider';
}

@ProviderFor(memberEvents)
final memberEventsProvider = MemberEventsFamily._();

final class MemberEventsProvider
    extends $FunctionalProvider<AsyncValue<List<MemberEvent>>, List<MemberEvent>, FutureOr<List<MemberEvent>>>
    with $FutureModifier<List<MemberEvent>>, $FutureProvider<List<MemberEvent>> {
  MemberEventsProvider._({required MemberEventsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberEventsHash();

  @override
  String toString() {
    return r'memberEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemberEvent>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemberEvent>> create(Ref ref) {
    final argument = this.argument as String;
    return memberEvents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberEventsHash() => r'a8dfc8584dd9acb4130a837122d6958cbe83267a';

final class MemberEventsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<MemberEvent>>, String> {
  MemberEventsFamily._()
    : super(
        retry: null,
        name: r'memberEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberEventsProvider call(String id) => MemberEventsProvider._(argument: id, from: this);

  @override
  String toString() => r'memberEventsProvider';
}

/// Check-ins for the 12 weeks up to today.

@ProviderFor(memberAttendance)
final memberAttendanceProvider = MemberAttendanceFamily._();

/// Check-ins for the 12 weeks up to today.

final class MemberAttendanceProvider
    extends $FunctionalProvider<AsyncValue<List<Attendance>>, List<Attendance>, FutureOr<List<Attendance>>>
    with $FutureModifier<List<Attendance>>, $FutureProvider<List<Attendance>> {
  /// Check-ins for the 12 weeks up to today.
  MemberAttendanceProvider._({required MemberAttendanceFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberAttendanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberAttendanceHash();

  @override
  String toString() {
    return r'memberAttendanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Attendance>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Attendance>> create(Ref ref) {
    final argument = this.argument as String;
    return memberAttendance(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberAttendanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberAttendanceHash() => r'5891b2e6f006b263ec1b92ba777b4352ce1e70a7';

/// Check-ins for the 12 weeks up to today.

final class MemberAttendanceFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<Attendance>>, String> {
  MemberAttendanceFamily._()
    : super(
        retry: null,
        name: r'memberAttendanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Check-ins for the 12 weeks up to today.

  MemberAttendanceProvider call(String id) => MemberAttendanceProvider._(argument: id, from: this);

  @override
  String toString() => r'memberAttendanceProvider';
}

@ProviderFor(plans)
final plansProvider = PlansProvider._();

final class PlansProvider extends $FunctionalProvider<AsyncValue<List<Plan>>, List<Plan>, FutureOr<List<Plan>>>
    with $FutureModifier<List<Plan>>, $FutureProvider<List<Plan>> {
  PlansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plansHash();

  @$internal
  @override
  $FutureProviderElement<List<Plan>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Plan>> create(Ref ref) {
    return plans(ref);
  }
}

String _$plansHash() => r'07a4558f20dc084063ce82569a99184c1cb7eb54';

@ProviderFor(allPlans)
final allPlansProvider = AllPlansProvider._();

final class AllPlansProvider extends $FunctionalProvider<AsyncValue<List<Plan>>, List<Plan>, FutureOr<List<Plan>>>
    with $FutureModifier<List<Plan>>, $FutureProvider<List<Plan>> {
  AllPlansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPlansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPlansHash();

  @$internal
  @override
  $FutureProviderElement<List<Plan>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Plan>> create(Ref ref) {
    return allPlans(ref);
  }
}

String _$allPlansHash() => r'2c25127f7d5728aa5fcf6ac686e163d4ec158ba4';

@ProviderFor(planCounts)
final planCountsProvider = PlanCountsProvider._();

final class PlanCountsProvider
    extends $FunctionalProvider<AsyncValue<Map<String, int>>, Map<String, int>, FutureOr<Map<String, int>>>
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  PlanCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return planCounts(ref);
  }
}

String _$planCountsHash() => r'fa77a4cc220c240550c7a0a00d34a648aa73a8f7';

@ProviderFor(addons)
final addonsProvider = AddonsProvider._();

final class AddonsProvider extends $FunctionalProvider<AsyncValue<List<Addon>>, List<Addon>, FutureOr<List<Addon>>>
    with $FutureModifier<List<Addon>>, $FutureProvider<List<Addon>> {
  AddonsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addonsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addonsHash();

  @$internal
  @override
  $FutureProviderElement<List<Addon>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Addon>> create(Ref ref) {
    return addons(ref);
  }
}

String _$addonsHash() => r'486f8d396664cada736e7634888f5f9123bb0e19';

@ProviderFor(allAddons)
final allAddonsProvider = AllAddonsProvider._();

final class AllAddonsProvider extends $FunctionalProvider<AsyncValue<List<Addon>>, List<Addon>, FutureOr<List<Addon>>>
    with $FutureModifier<List<Addon>>, $FutureProvider<List<Addon>> {
  AllAddonsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allAddonsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allAddonsHash();

  @$internal
  @override
  $FutureProviderElement<List<Addon>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Addon>> create(Ref ref) {
    return allAddons(ref);
  }
}

String _$allAddonsHash() => r'5725be2ac4dfc04069a4204667e4913724f03d96';

@ProviderFor(trainers)
final trainersProvider = TrainersProvider._();

final class TrainersProvider
    extends $FunctionalProvider<AsyncValue<List<StaffMember>>, List<StaffMember>, FutureOr<List<StaffMember>>>
    with $FutureModifier<List<StaffMember>>, $FutureProvider<List<StaffMember>> {
  TrainersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainersHash();

  @$internal
  @override
  $FutureProviderElement<List<StaffMember>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StaffMember>> create(Ref ref) {
    return trainers(ref);
  }
}

String _$trainersHash() => r'4eee44d8a922e786e025bfe11a4fdd5eaf63fccc';

@ProviderFor(dashboard)
final dashboardProvider = DashboardProvider._();

final class DashboardProvider
    extends $FunctionalProvider<AsyncValue<DashboardCounts>, DashboardCounts, FutureOr<DashboardCounts>>
    with $FutureModifier<DashboardCounts>, $FutureProvider<DashboardCounts> {
  DashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardHash();

  @$internal
  @override
  $FutureProviderElement<DashboardCounts> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardCounts> create(Ref ref) {
    return dashboard(ref);
  }
}

String _$dashboardHash() => r'd6c3286dfb963a09c325f01c512f855a7fd43be0';

@ProviderFor(needsAction)
final needsActionProvider = NeedsActionProvider._();

final class NeedsActionProvider
    extends $FunctionalProvider<AsyncValue<List<NeedsAction>>, List<NeedsAction>, FutureOr<List<NeedsAction>>>
    with $FutureModifier<List<NeedsAction>>, $FutureProvider<List<NeedsAction>> {
  NeedsActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'needsActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$needsActionHash();

  @$internal
  @override
  $FutureProviderElement<List<NeedsAction>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NeedsAction>> create(Ref ref) {
    return needsAction(ref);
  }
}

String _$needsActionHash() => r'd3481c4c49a77ac31e8093423f63b725f8bbd591';

@ProviderFor(todaysCheckIns)
final todaysCheckInsProvider = TodaysCheckInsProvider._();

final class TodaysCheckInsProvider
    extends $FunctionalProvider<AsyncValue<List<Attendance>>, List<Attendance>, Stream<List<Attendance>>>
    with $FutureModifier<List<Attendance>>, $StreamProvider<List<Attendance>> {
  TodaysCheckInsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysCheckInsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysCheckInsHash();

  @$internal
  @override
  $StreamProviderElement<List<Attendance>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Attendance>> create(Ref ref) {
    return todaysCheckIns(ref);
  }
}

String _$todaysCheckInsHash() => r'd13009f8759fcf5134eb3e620b254ab42f42fa54';

/// Short-lived signed URL for a private member photo.

@ProviderFor(photoUrl)
final photoUrlProvider = PhotoUrlFamily._();

/// Short-lived signed URL for a private member photo.

final class PhotoUrlProvider extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Short-lived signed URL for a private member photo.
  PhotoUrlProvider._({required PhotoUrlFamily super.from, required String? super.argument})
    : super(
        retry: null,
        name: r'photoUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoUrlHash();

  @override
  String toString() {
    return r'photoUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String?;
    return photoUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$photoUrlHash() => r'c3300611524b69f8b174b3cd70657887106e8e74';

/// Short-lived signed URL for a private member photo.

final class PhotoUrlFamily extends $Family with $FunctionalFamilyOverride<FutureOr<String?>, String?> {
  PhotoUrlFamily._()
    : super(
        retry: null,
        name: r'photoUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Short-lived signed URL for a private member photo.

  PhotoUrlProvider call(String? path) => PhotoUrlProvider._(argument: path, from: this);

  @override
  String toString() => r'photoUrlProvider';
}

/// Filters saved on this device (1.13 "saved filters").

@ProviderFor(SavedFilters)
final savedFiltersProvider = SavedFiltersProvider._();

/// Filters saved on this device (1.13 "saved filters").
final class SavedFiltersProvider extends $NotifierProvider<SavedFilters, Map<String, MemberQuery>> {
  /// Filters saved on this device (1.13 "saved filters").
  SavedFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedFiltersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedFiltersHash();

  @$internal
  @override
  SavedFilters create() => SavedFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, MemberQuery> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<String, MemberQuery>>(value));
  }
}

String _$savedFiltersHash() => r'b2c1e8577a22c45c765a0e8d9201b89f5515dddf';

/// Filters saved on this device (1.13 "saved filters").

abstract class _$SavedFilters extends $Notifier<Map<String, MemberQuery>> {
  Map<String, MemberQuery> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, MemberQuery>, Map<String, MemberQuery>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, MemberQuery>, Map<String, MemberQuery>>,
              Map<String, MemberQuery>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
