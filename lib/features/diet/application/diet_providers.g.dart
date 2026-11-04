// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The foods, indexed for instant search. Loaded once per session and
/// refreshed on pull-to-refresh or after an edit.

@ProviderFor(foodCatalogue)
final foodCatalogueProvider = FoodCatalogueProvider._();

/// The foods, indexed for instant search. Loaded once per session and
/// refreshed on pull-to-refresh or after an edit.

final class FoodCatalogueProvider extends $FunctionalProvider<AsyncValue<FoodIndex>, FoodIndex, FutureOr<FoodIndex>>
    with $FutureModifier<FoodIndex>, $FutureProvider<FoodIndex> {
  /// The foods, indexed for instant search. Loaded once per session and
  /// refreshed on pull-to-refresh or after an edit.
  FoodCatalogueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodCatalogueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodCatalogueHash();

  @$internal
  @override
  $FutureProviderElement<FoodIndex> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<FoodIndex> create(Ref ref) {
    return foodCatalogue(ref);
  }
}

String _$foodCatalogueHash() => r'17aa7a9b5f5d1c46144e1558c268cdff9ca99ae4';

@ProviderFor(DietTemplateList)
final dietTemplateListProvider = DietTemplateListFamily._();

final class DietTemplateListProvider extends $AsyncNotifierProvider<DietTemplateList, Paged<DietTemplate>> {
  DietTemplateListProvider._({required DietTemplateListFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dietTemplateListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietTemplateListHash();

  @override
  String toString() {
    return r'dietTemplateListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DietTemplateList create() => DietTemplateList();

  @override
  bool operator ==(Object other) {
    return other is DietTemplateListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dietTemplateListHash() => r'c512a449e0b8378b700d61fd5aa85d4d0e8316f9';

final class DietTemplateListFamily extends $Family
    with
        $ClassFamilyOverride<
          DietTemplateList,
          AsyncValue<Paged<DietTemplate>>,
          Paged<DietTemplate>,
          FutureOr<Paged<DietTemplate>>,
          String
        > {
  DietTemplateListFamily._()
    : super(
        retry: null,
        name: r'dietTemplateListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DietTemplateListProvider call(String search) => DietTemplateListProvider._(argument: search, from: this);

  @override
  String toString() => r'dietTemplateListProvider';
}

abstract class _$DietTemplateList extends $AsyncNotifier<Paged<DietTemplate>> {
  late final _$args = ref.$arg as String;
  String get search => _$args;

  FutureOr<Paged<DietTemplate>> build(String search);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<DietTemplate>>, Paged<DietTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<DietTemplate>>, Paged<DietTemplate>>,
              AsyncValue<Paged<DietTemplate>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(dietTemplateDetail)
final dietTemplateDetailProvider = DietTemplateDetailFamily._();

final class DietTemplateDetailProvider
    extends $FunctionalProvider<AsyncValue<DietTemplate>, DietTemplate, FutureOr<DietTemplate>>
    with $FutureModifier<DietTemplate>, $FutureProvider<DietTemplate> {
  DietTemplateDetailProvider._({required DietTemplateDetailFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dietTemplateDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietTemplateDetailHash();

  @override
  String toString() {
    return r'dietTemplateDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DietTemplate> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<DietTemplate> create(Ref ref) {
    final argument = this.argument as String;
    return dietTemplateDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DietTemplateDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dietTemplateDetailHash() => r'db3c072c3439d8d4afac8e2ae4e831a25c943f6c';

final class DietTemplateDetailFamily extends $Family with $FunctionalFamilyOverride<FutureOr<DietTemplate>, String> {
  DietTemplateDetailFamily._()
    : super(
        retry: null,
        name: r'dietTemplateDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DietTemplateDetailProvider call(String id) => DietTemplateDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'dietTemplateDetailProvider';
}

@ProviderFor(memberDiets)
final memberDietsProvider = MemberDietsFamily._();

final class MemberDietsProvider
    extends $FunctionalProvider<AsyncValue<List<MemberDiet>>, List<MemberDiet>, FutureOr<List<MemberDiet>>>
    with $FutureModifier<List<MemberDiet>>, $FutureProvider<List<MemberDiet>> {
  MemberDietsProvider._({required MemberDietsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberDietsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberDietsHash();

  @override
  String toString() {
    return r'memberDietsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemberDiet>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemberDiet>> create(Ref ref) {
    final argument = this.argument as String;
    return memberDiets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberDietsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberDietsHash() => r'046909fa1ffa38575a41962f9c73821881e8e7c0';

final class MemberDietsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<MemberDiet>>, String> {
  MemberDietsFamily._()
    : super(
        retry: null,
        name: r'memberDietsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberDietsProvider call(String memberId) => MemberDietsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberDietsProvider';
}

/// The running plan, else the next queued one.

@ProviderFor(currentDiet)
final currentDietProvider = CurrentDietFamily._();

/// The running plan, else the next queued one.

final class CurrentDietProvider extends $FunctionalProvider<AsyncValue<MemberDiet?>, MemberDiet?, FutureOr<MemberDiet?>>
    with $FutureModifier<MemberDiet?>, $FutureProvider<MemberDiet?> {
  /// The running plan, else the next queued one.
  CurrentDietProvider._({required CurrentDietFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'currentDietProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDietHash();

  @override
  String toString() {
    return r'currentDietProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MemberDiet?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<MemberDiet?> create(Ref ref) {
    final argument = this.argument as String;
    return currentDiet(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentDietProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentDietHash() => r'30e331b14833bf4250b1a382dcbc69801c120761';

/// The running plan, else the next queued one.

final class CurrentDietFamily extends $Family with $FunctionalFamilyOverride<FutureOr<MemberDiet?>, String> {
  CurrentDietFamily._()
    : super(
        retry: null,
        name: r'currentDietProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The running plan, else the next queued one.

  CurrentDietProvider call(String memberId) => CurrentDietProvider._(argument: memberId, from: this);

  @override
  String toString() => r'currentDietProvider';
}

/// The last 8 weeks of meals, water and supplements, with marks still
/// waiting in the outbox applied on top (so offline taps stick).

@ProviderFor(MemberDietLogs)
final memberDietLogsProvider = MemberDietLogsFamily._();

/// The last 8 weeks of meals, water and supplements, with marks still
/// waiting in the outbox applied on top (so offline taps stick).
final class MemberDietLogsProvider extends $AsyncNotifierProvider<MemberDietLogs, DietLogs> {
  /// The last 8 weeks of meals, water and supplements, with marks still
  /// waiting in the outbox applied on top (so offline taps stick).
  MemberDietLogsProvider._({required MemberDietLogsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberDietLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberDietLogsHash();

  @override
  String toString() {
    return r'memberDietLogsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MemberDietLogs create() => MemberDietLogs();

  @override
  bool operator ==(Object other) {
    return other is MemberDietLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberDietLogsHash() => r'1b979b5b197a49794046bf95e24e9e277d919182';

/// The last 8 weeks of meals, water and supplements, with marks still
/// waiting in the outbox applied on top (so offline taps stick).

final class MemberDietLogsFamily extends $Family
    with $ClassFamilyOverride<MemberDietLogs, AsyncValue<DietLogs>, DietLogs, FutureOr<DietLogs>, String> {
  MemberDietLogsFamily._()
    : super(
        retry: null,
        name: r'memberDietLogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The last 8 weeks of meals, water and supplements, with marks still
  /// waiting in the outbox applied on top (so offline taps stick).

  MemberDietLogsProvider call(String memberId) => MemberDietLogsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberDietLogsProvider';
}

/// The last 8 weeks of meals, water and supplements, with marks still
/// waiting in the outbox applied on top (so offline taps stick).

abstract class _$MemberDietLogs extends $AsyncNotifier<DietLogs> {
  late final _$args = ref.$arg as String;
  String get memberId => _$args;

  FutureOr<DietLogs> build(String memberId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DietLogs>, DietLogs>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DietLogs>, DietLogs>,
              AsyncValue<DietLogs>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// The member's latest weight: the newest measurement, else the health form.

@ProviderFor(memberWeight)
final memberWeightProvider = MemberWeightFamily._();

/// The member's latest weight: the newest measurement, else the health form.

final class MemberWeightProvider extends $FunctionalProvider<AsyncValue<double?>, double?, FutureOr<double?>>
    with $FutureModifier<double?>, $FutureProvider<double?> {
  /// The member's latest weight: the newest measurement, else the health form.
  MemberWeightProvider._({required MemberWeightFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'memberWeightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberWeightHash();

  @override
  String toString() {
    return r'memberWeightProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<double?> create(Ref ref) {
    final argument = this.argument as String;
    return memberWeight(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberWeightProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberWeightHash() => r'a07ccd0c786a2e7c564f7761543011a17c473a44';

/// The member's latest weight: the newest measurement, else the health form.

final class MemberWeightFamily extends $Family with $FunctionalFamilyOverride<FutureOr<double?>, String> {
  MemberWeightFamily._()
    : super(
        retry: null,
        name: r'memberWeightProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The member's latest weight: the newest measurement, else the health form.

  MemberWeightProvider call(String memberId) => MemberWeightProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberWeightProvider';
}

@ProviderFor(dietStats)
final dietStatsProvider = DietStatsFamily._();

final class DietStatsProvider extends $FunctionalProvider<AsyncValue<DietStats>, DietStats, FutureOr<DietStats>>
    with $FutureModifier<DietStats>, $FutureProvider<DietStats> {
  DietStatsProvider._({required DietStatsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dietStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietStatsHash();

  @override
  String toString() {
    return r'dietStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DietStats> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<DietStats> create(Ref ref) {
    final argument = this.argument as String;
    return dietStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DietStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dietStatsHash() => r'10b70067fc6e5ccad17c446713d58e0e11899a71';

final class DietStatsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<DietStats>, String> {
  DietStatsFamily._()
    : super(
        retry: null,
        name: r'dietStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DietStatsProvider call(String memberId) => DietStatsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'dietStatsProvider';
}

@ProviderFor(DietOverviewList)
final dietOverviewListProvider = DietOverviewListFamily._();

final class DietOverviewListProvider extends $AsyncNotifierProvider<DietOverviewList, Paged<DietRow>> {
  DietOverviewListProvider._({required DietOverviewListFamily super.from, required (String?, String) super.argument})
    : super(
        retry: null,
        name: r'dietOverviewListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietOverviewListHash();

  @override
  String toString() {
    return r'dietOverviewListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DietOverviewList create() => DietOverviewList();

  @override
  bool operator ==(Object other) {
    return other is DietOverviewListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dietOverviewListHash() => r'd7046c2527e0b81d000aa81a5ec4b3371198bf76';

final class DietOverviewListFamily extends $Family
    with
        $ClassFamilyOverride<
          DietOverviewList,
          AsyncValue<Paged<DietRow>>,
          Paged<DietRow>,
          FutureOr<Paged<DietRow>>,
          (String?, String)
        > {
  DietOverviewListFamily._()
    : super(
        retry: null,
        name: r'dietOverviewListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DietOverviewListProvider call(String? trainerId, String search) =>
      DietOverviewListProvider._(argument: (trainerId, search), from: this);

  @override
  String toString() => r'dietOverviewListProvider';
}

abstract class _$DietOverviewList extends $AsyncNotifier<Paged<DietRow>> {
  late final _$args = ref.$arg as (String?, String);
  String? get trainerId => _$args.$1;
  String get search => _$args.$2;

  FutureOr<Paged<DietRow>> build(String? trainerId, String search);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<DietRow>>, Paged<DietRow>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<DietRow>>, Paged<DietRow>>,
              AsyncValue<Paged<DietRow>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

@ProviderFor(dietFlags)
final dietFlagsProvider = DietFlagsFamily._();

final class DietFlagsProvider extends $FunctionalProvider<AsyncValue<DietFlags>, DietFlags, FutureOr<DietFlags>>
    with $FutureModifier<DietFlags>, $FutureProvider<DietFlags> {
  DietFlagsProvider._({required DietFlagsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dietFlagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietFlagsHash();

  @override
  String toString() {
    return r'dietFlagsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DietFlags> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<DietFlags> create(Ref ref) {
    final argument = this.argument as String;
    return dietFlags(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DietFlagsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dietFlagsHash() => r'59176dad39d97fc494eb2e9bb062b1c50967a012';

final class DietFlagsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<DietFlags>, String> {
  DietFlagsFamily._()
    : super(
        retry: null,
        name: r'dietFlagsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DietFlagsProvider call(String memberId) => DietFlagsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'dietFlagsProvider';
}

@ProviderFor(dietComments)
final dietCommentsProvider = DietCommentsFamily._();

final class DietCommentsProvider
    extends $FunctionalProvider<AsyncValue<List<DietComment>>, List<DietComment>, FutureOr<List<DietComment>>>
    with $FutureModifier<List<DietComment>>, $FutureProvider<List<DietComment>> {
  DietCommentsProvider._({required DietCommentsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'dietCommentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dietCommentsHash();

  @override
  String toString() {
    return r'dietCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DietComment>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DietComment>> create(Ref ref) {
    final argument = this.argument as String;
    return dietComments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DietCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dietCommentsHash() => r'e6fcd072f40f84d57052e040793e9269034c0659';

final class DietCommentsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<DietComment>>, String> {
  DietCommentsFamily._()
    : super(
        retry: null,
        name: r'dietCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DietCommentsProvider call(String memberId) => DietCommentsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'dietCommentsProvider';
}

/// Uploads diet marks waiting in the outbox; the member home watches this,
/// so it runs on every launch and pull-to-refresh.

@ProviderFor(syncDiet)
final syncDietProvider = SyncDietProvider._();

/// Uploads diet marks waiting in the outbox; the member home watches this,
/// so it runs on every launch and pull-to-refresh.

final class SyncDietProvider extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Uploads diet marks waiting in the outbox; the member home watches this,
  /// so it runs on every launch and pull-to-refresh.
  SyncDietProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncDietProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncDietHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return syncDiet(ref);
  }
}

String _$syncDietHash() => r'c5c0a1582abc21a9dda48d23938aec21adb38465';

@ProviderFor(MealReminderSwitch)
final mealReminderSwitchProvider = MealReminderSwitchProvider._();

final class MealReminderSwitchProvider extends $NotifierProvider<MealReminderSwitch, bool> {
  MealReminderSwitchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealReminderSwitchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealReminderSwitchHash();

  @$internal
  @override
  MealReminderSwitch create() => MealReminderSwitch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$mealReminderSwitchHash() => r'd316920accbf33ed75bdae797b31bea5ff4a7d14';

abstract class _$MealReminderSwitch extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
