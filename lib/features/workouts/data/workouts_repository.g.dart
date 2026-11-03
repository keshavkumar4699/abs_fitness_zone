// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workouts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutsRepository)
final workoutsRepositoryProvider = WorkoutsRepositoryProvider._();

final class WorkoutsRepositoryProvider
    extends
        $FunctionalProvider<
          WorkoutsRepository,
          WorkoutsRepository,
          WorkoutsRepository
        >
    with $Provider<WorkoutsRepository> {
  WorkoutsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutsRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutsRepository create(Ref ref) {
    return workoutsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutsRepository>(value),
    );
  }
}

String _$workoutsRepositoryHash() =>
    r'dee44ba9873159003d02187fb60a66b29da11b69';

@ProviderFor(workoutOutbox)
final workoutOutboxProvider = WorkoutOutboxProvider._();

final class WorkoutOutboxProvider
    extends $FunctionalProvider<WorkoutOutbox, WorkoutOutbox, WorkoutOutbox>
    with $Provider<WorkoutOutbox> {
  WorkoutOutboxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutOutboxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutOutboxHash();

  @$internal
  @override
  $ProviderElement<WorkoutOutbox> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkoutOutbox create(Ref ref) {
    return workoutOutbox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutOutbox value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutOutbox>(value),
    );
  }
}

String _$workoutOutboxHash() => r'135f37db7917135dfb1cc0a383a76437853d7468';

@ProviderFor(myWorkoutCache)
final myWorkoutCacheProvider = MyWorkoutCacheProvider._();

final class MyWorkoutCacheProvider
    extends $FunctionalProvider<MyWorkoutCache, MyWorkoutCache, MyWorkoutCache>
    with $Provider<MyWorkoutCache> {
  MyWorkoutCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myWorkoutCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myWorkoutCacheHash();

  @$internal
  @override
  $ProviderElement<MyWorkoutCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyWorkoutCache create(Ref ref) {
    return myWorkoutCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyWorkoutCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyWorkoutCache>(value),
    );
  }
}

String _$myWorkoutCacheHash() => r'de3fbd2403b41c364530d5b1f68decdd66885ceb';
