// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The catalogue, indexed for instant search. Loaded once per session and
/// refreshed on pull-to-refresh.

@ProviderFor(exerciseCatalogue)
final exerciseCatalogueProvider = ExerciseCatalogueProvider._();

/// The catalogue, indexed for instant search. Loaded once per session and
/// refreshed on pull-to-refresh.

final class ExerciseCatalogueProvider
    extends $FunctionalProvider<AsyncValue<ExerciseIndex>, ExerciseIndex, FutureOr<ExerciseIndex>>
    with $FutureModifier<ExerciseIndex>, $FutureProvider<ExerciseIndex> {
  /// The catalogue, indexed for instant search. Loaded once per session and
  /// refreshed on pull-to-refresh.
  ExerciseCatalogueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseCatalogueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseCatalogueHash();

  @$internal
  @override
  $FutureProviderElement<ExerciseIndex> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<ExerciseIndex> create(Ref ref) {
    return exerciseCatalogue(ref);
  }
}

String _$exerciseCatalogueHash() => r'1505dea1f43d1eb5dced4c56b4a7f89555ec8c9c';

@ProviderFor(trainingSettings)
final trainingSettingsProvider = TrainingSettingsProvider._();

final class TrainingSettingsProvider
    extends $FunctionalProvider<AsyncValue<TrainingSettings>, TrainingSettings, FutureOr<TrainingSettings>>
    with $FutureModifier<TrainingSettings>, $FutureProvider<TrainingSettings> {
  TrainingSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingSettingsHash();

  @$internal
  @override
  $FutureProviderElement<TrainingSettings> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<TrainingSettings> create(Ref ref) {
    return trainingSettings(ref);
  }
}

String _$trainingSettingsHash() => r'99406e39d4099747c0121b7af065193c99fff0e7';

/// Builds image URLs for catalogue paths.

@ProviderFor(exerciseImages)
final exerciseImagesProvider = ExerciseImagesProvider._();

/// Builds image URLs for catalogue paths.

final class ExerciseImagesProvider
    extends
        $FunctionalProvider<
          String? Function(String? path),
          String? Function(String? path),
          String? Function(String? path)
        >
    with $Provider<String? Function(String? path)> {
  /// Builds image URLs for catalogue paths.
  ExerciseImagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseImagesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseImagesHash();

  @$internal
  @override
  $ProviderElement<String? Function(String? path)> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? Function(String? path) create(Ref ref) {
    return exerciseImages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? Function(String? path) value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String? Function(String? path)>(value));
  }
}

String _$exerciseImagesHash() => r'fbd7efbc30795818627d16878eb85d852208ad53';

/// The signed-in user's starred exercises (4.6). Toggles show at once and
/// roll back if the save fails.

@ProviderFor(FavouriteExercises)
final favouriteExercisesProvider = FavouriteExercisesProvider._();

/// The signed-in user's starred exercises (4.6). Toggles show at once and
/// roll back if the save fails.
final class FavouriteExercisesProvider extends $AsyncNotifierProvider<FavouriteExercises, Set<String>> {
  /// The signed-in user's starred exercises (4.6). Toggles show at once and
  /// roll back if the save fails.
  FavouriteExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favouriteExercisesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favouriteExercisesHash();

  @$internal
  @override
  FavouriteExercises create() => FavouriteExercises();
}

String _$favouriteExercisesHash() => r'c161b13c3a86f6f7d67039cdf1eca6cdfc953794';

/// The signed-in user's starred exercises (4.6). Toggles show at once and
/// roll back if the save fails.

abstract class _$FavouriteExercises extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
