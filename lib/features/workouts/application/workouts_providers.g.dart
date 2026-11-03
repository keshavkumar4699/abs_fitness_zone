// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workouts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemplateList)
final templateListProvider = TemplateListFamily._();

final class TemplateListProvider
    extends $AsyncNotifierProvider<TemplateList, Paged<WorkoutTemplate>> {
  TemplateListProvider._({
    required TemplateListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'templateListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$templateListHash();

  @override
  String toString() {
    return r'templateListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TemplateList create() => TemplateList();

  @override
  bool operator ==(Object other) {
    return other is TemplateListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$templateListHash() => r'cdc99ec88b588173993aa007192ebd61e9ea6327';

final class TemplateListFamily extends $Family
    with
        $ClassFamilyOverride<
          TemplateList,
          AsyncValue<Paged<WorkoutTemplate>>,
          Paged<WorkoutTemplate>,
          FutureOr<Paged<WorkoutTemplate>>,
          String
        > {
  TemplateListFamily._()
    : super(
        retry: null,
        name: r'templateListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TemplateListProvider call(String search) =>
      TemplateListProvider._(argument: search, from: this);

  @override
  String toString() => r'templateListProvider';
}

abstract class _$TemplateList extends $AsyncNotifier<Paged<WorkoutTemplate>> {
  late final _$args = ref.$arg as String;
  String get search => _$args;

  FutureOr<Paged<WorkoutTemplate>> build(String search);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Paged<WorkoutTemplate>>, Paged<WorkoutTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Paged<WorkoutTemplate>>,
                Paged<WorkoutTemplate>
              >,
              AsyncValue<Paged<WorkoutTemplate>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(templateDetail)
final templateDetailProvider = TemplateDetailFamily._();

final class TemplateDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutTemplate>,
          WorkoutTemplate,
          FutureOr<WorkoutTemplate>
        >
    with $FutureModifier<WorkoutTemplate>, $FutureProvider<WorkoutTemplate> {
  TemplateDetailProvider._({
    required TemplateDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'templateDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$templateDetailHash();

  @override
  String toString() {
    return r'templateDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WorkoutTemplate> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkoutTemplate> create(Ref ref) {
    final argument = this.argument as String;
    return templateDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplateDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$templateDetailHash() => r'3acc045c6a7afffe7bc82bd5b8ddc55755a30af7';

final class TemplateDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WorkoutTemplate>, String> {
  TemplateDetailFamily._()
    : super(
        retry: null,
        name: r'templateDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TemplateDetailProvider call(String id) =>
      TemplateDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'templateDetailProvider';
}

@ProviderFor(memberPrograms)
final memberProgramsProvider = MemberProgramsFamily._();

final class MemberProgramsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemberProgram>>,
          List<MemberProgram>,
          FutureOr<List<MemberProgram>>
        >
    with
        $FutureModifier<List<MemberProgram>>,
        $FutureProvider<List<MemberProgram>> {
  MemberProgramsProvider._({
    required MemberProgramsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'memberProgramsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memberProgramsHash();

  @override
  String toString() {
    return r'memberProgramsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemberProgram>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemberProgram>> create(Ref ref) {
    final argument = this.argument as String;
    return memberPrograms(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberProgramsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memberProgramsHash() => r'2153a3858c576b0cc79166e0836a881a8ac196cc';

final class MemberProgramsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MemberProgram>>, String> {
  MemberProgramsFamily._()
    : super(
        retry: null,
        name: r'memberProgramsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemberProgramsProvider call(String memberId) =>
      MemberProgramsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'memberProgramsProvider';
}

/// The running program, else the next queued one.

@ProviderFor(currentProgram)
final currentProgramProvider = CurrentProgramFamily._();

/// The running program, else the next queued one.

final class CurrentProgramProvider
    extends
        $FunctionalProvider<
          AsyncValue<MemberProgram?>,
          MemberProgram?,
          FutureOr<MemberProgram?>
        >
    with $FutureModifier<MemberProgram?>, $FutureProvider<MemberProgram?> {
  /// The running program, else the next queued one.
  CurrentProgramProvider._({
    required CurrentProgramFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'currentProgramProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentProgramHash();

  @override
  String toString() {
    return r'currentProgramProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MemberProgram?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MemberProgram?> create(Ref ref) {
    final argument = this.argument as String;
    return currentProgram(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentProgramProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentProgramHash() => r'6c3bd883e542c6e8a1689530ed021bd66fd4d248';

/// The running program, else the next queued one.

final class CurrentProgramFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MemberProgram?>, String> {
  CurrentProgramFamily._()
    : super(
        retry: null,
        name: r'currentProgramProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The running program, else the next queued one.

  CurrentProgramProvider call(String memberId) =>
      CurrentProgramProvider._(argument: memberId, from: this);

  @override
  String toString() => r'currentProgramProvider';
}

/// The last 12 weeks of workouts with their sets (stats, calendar, "last
/// time" prefill and local PR checks).

@ProviderFor(recentWorkouts)
final recentWorkoutsProvider = RecentWorkoutsFamily._();

/// The last 12 weeks of workouts with their sets (stats, calendar, "last
/// time" prefill and local PR checks).

final class RecentWorkoutsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutLog>>,
          List<WorkoutLog>,
          FutureOr<List<WorkoutLog>>
        >
    with $FutureModifier<List<WorkoutLog>>, $FutureProvider<List<WorkoutLog>> {
  /// The last 12 weeks of workouts with their sets (stats, calendar, "last
  /// time" prefill and local PR checks).
  RecentWorkoutsProvider._({
    required RecentWorkoutsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recentWorkoutsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recentWorkoutsHash();

  @override
  String toString() {
    return r'recentWorkoutsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WorkoutLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkoutLog>> create(Ref ref) {
    final argument = this.argument as String;
    return recentWorkouts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentWorkoutsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recentWorkoutsHash() => r'9473b0b22df5ed85fbe2ddfc6e0ffff1ff604def';

/// The last 12 weeks of workouts with their sets (stats, calendar, "last
/// time" prefill and local PR checks).

final class RecentWorkoutsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WorkoutLog>>, String> {
  RecentWorkoutsFamily._()
    : super(
        retry: null,
        name: r'recentWorkoutsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The last 12 weeks of workouts with their sets (stats, calendar, "last
  /// time" prefill and local PR checks).

  RecentWorkoutsProvider call(String memberId) =>
      RecentWorkoutsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'recentWorkoutsProvider';
}

@ProviderFor(WorkoutHistory)
final workoutHistoryProvider = WorkoutHistoryFamily._();

final class WorkoutHistoryProvider
    extends $AsyncNotifierProvider<WorkoutHistory, Paged<WorkoutLog>> {
  WorkoutHistoryProvider._({
    required WorkoutHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workoutHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutHistoryHash();

  @override
  String toString() {
    return r'workoutHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WorkoutHistory create() => WorkoutHistory();

  @override
  bool operator ==(Object other) {
    return other is WorkoutHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutHistoryHash() => r'ad990f0df5de66194bc3a747260c63785e61dec6';

final class WorkoutHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          WorkoutHistory,
          AsyncValue<Paged<WorkoutLog>>,
          Paged<WorkoutLog>,
          FutureOr<Paged<WorkoutLog>>,
          String
        > {
  WorkoutHistoryFamily._()
    : super(
        retry: null,
        name: r'workoutHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkoutHistoryProvider call(String memberId) =>
      WorkoutHistoryProvider._(argument: memberId, from: this);

  @override
  String toString() => r'workoutHistoryProvider';
}

abstract class _$WorkoutHistory extends $AsyncNotifier<Paged<WorkoutLog>> {
  late final _$args = ref.$arg as String;
  String get memberId => _$args;

  FutureOr<Paged<WorkoutLog>> build(String memberId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Paged<WorkoutLog>>, Paged<WorkoutLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<WorkoutLog>>, Paged<WorkoutLog>>,
              AsyncValue<Paged<WorkoutLog>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(exerciseHistory)
final exerciseHistoryProvider = ExerciseHistoryFamily._();

final class ExerciseHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DatedSet>>,
          List<DatedSet>,
          FutureOr<List<DatedSet>>
        >
    with $FutureModifier<List<DatedSet>>, $FutureProvider<List<DatedSet>> {
  ExerciseHistoryProvider._({
    required ExerciseHistoryFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'exerciseHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseHistoryHash();

  @override
  String toString() {
    return r'exerciseHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<DatedSet>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DatedSet>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return exerciseHistory(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseHistoryHash() => r'52c4527ac1163f8b1511b59baca3120a44a834e8';

final class ExerciseHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DatedSet>>, (String, String)> {
  ExerciseHistoryFamily._()
    : super(
        retry: null,
        name: r'exerciseHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseHistoryProvider call(String memberId, String exerciseId) =>
      ExerciseHistoryProvider._(argument: (memberId, exerciseId), from: this);

  @override
  String toString() => r'exerciseHistoryProvider';
}

@ProviderFor(workoutStats)
final workoutStatsProvider = WorkoutStatsFamily._();

final class WorkoutStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutStats>,
          WorkoutStats,
          FutureOr<WorkoutStats>
        >
    with $FutureModifier<WorkoutStats>, $FutureProvider<WorkoutStats> {
  WorkoutStatsProvider._({
    required WorkoutStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workoutStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutStatsHash();

  @override
  String toString() {
    return r'workoutStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WorkoutStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkoutStats> create(Ref ref) {
    final argument = this.argument as String;
    return workoutStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutStatsHash() => r'f44883c5ed10e973ea07f3ba242a39bc1fe7ca77';

final class WorkoutStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WorkoutStats>, String> {
  WorkoutStatsFamily._()
    : super(
        retry: null,
        name: r'workoutStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkoutStatsProvider call(String memberId) =>
      WorkoutStatsProvider._(argument: memberId, from: this);

  @override
  String toString() => r'workoutStatsProvider';
}

@ProviderFor(CoachList)
final coachListProvider = CoachListFamily._();

final class CoachListProvider
    extends $AsyncNotifierProvider<CoachList, Paged<CoachRow>> {
  CoachListProvider._({
    required CoachListFamily super.from,
    required (String?, String) super.argument,
  }) : super(
         retry: null,
         name: r'coachListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coachListHash();

  @override
  String toString() {
    return r'coachListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  CoachList create() => CoachList();

  @override
  bool operator ==(Object other) {
    return other is CoachListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachListHash() => r'e2083b75015cb69488aafc20a982e306b10e2348';

final class CoachListFamily extends $Family
    with
        $ClassFamilyOverride<
          CoachList,
          AsyncValue<Paged<CoachRow>>,
          Paged<CoachRow>,
          FutureOr<Paged<CoachRow>>,
          (String?, String)
        > {
  CoachListFamily._()
    : super(
        retry: null,
        name: r'coachListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoachListProvider call(String? trainerId, String search) =>
      CoachListProvider._(argument: (trainerId, search), from: this);

  @override
  String toString() => r'coachListProvider';
}

abstract class _$CoachList extends $AsyncNotifier<Paged<CoachRow>> {
  late final _$args = ref.$arg as (String?, String);
  String? get trainerId => _$args.$1;
  String get search => _$args.$2;

  FutureOr<Paged<CoachRow>> build(String? trainerId, String search);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paged<CoachRow>>, Paged<CoachRow>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paged<CoachRow>>, Paged<CoachRow>>,
              AsyncValue<Paged<CoachRow>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// Uploads finished workouts waiting in the outbox; the member home watches
/// this, so it runs on every launch and pull-to-refresh.

@ProviderFor(syncWorkouts)
final syncWorkoutsProvider = SyncWorkoutsProvider._();

/// Uploads finished workouts waiting in the outbox; the member home watches
/// this, so it runs on every launch and pull-to-refresh.

final class SyncWorkoutsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Uploads finished workouts waiting in the outbox; the member home watches
  /// this, so it runs on every launch and pull-to-refresh.
  SyncWorkoutsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncWorkoutsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncWorkoutsHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return syncWorkouts(ref);
  }
}

String _$syncWorkoutsHash() => r'c0826955d6042d0d3a8dba3992852543133bae8e';

@ProviderFor(ActiveWorkout)
final activeWorkoutProvider = ActiveWorkoutProvider._();

final class ActiveWorkoutProvider
    extends $NotifierProvider<ActiveWorkout, WorkoutSession?> {
  ActiveWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutHash();

  @$internal
  @override
  ActiveWorkout create() => ActiveWorkout();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutSession?>(value),
    );
  }
}

String _$activeWorkoutHash() => r'345ca2361dc3a9cf7b01a31cfe01af8a2e267964';

abstract class _$ActiveWorkout extends $Notifier<WorkoutSession?> {
  WorkoutSession? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WorkoutSession?, WorkoutSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutSession?, WorkoutSession?>,
              WorkoutSession?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
