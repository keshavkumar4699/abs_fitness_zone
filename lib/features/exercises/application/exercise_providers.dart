import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../data/exercise_repository.dart';
import '../domain/exercise.dart';

part 'exercise_providers.g.dart';

/// The catalogue, indexed for instant search. Loaded once per session and
/// refreshed on pull-to-refresh.
@Riverpod(keepAlive: true)
Future<ExerciseIndex> exerciseCatalogue(Ref ref) async =>
    ExerciseIndex(await ref.watch(exerciseRepositoryProvider).catalogue());

@Riverpod(keepAlive: true)
Future<TrainingSettings> trainingSettings(Ref ref) => ref.watch(exerciseRepositoryProvider).trainingSettings();

/// Builds image URLs for catalogue paths.
@Riverpod(keepAlive: true)
String? Function(String? path) exerciseImages(Ref ref) {
  final url = ref.watch(envProvider).supabaseUrl;
  final base = ref.watch(trainingSettingsProvider).value?.imageBase;
  return (path) => exerciseImageUrl(path, supabaseUrl: url, imageBase: base);
}

/// The signed-in user's starred exercises (4.6). Toggles show at once and
/// roll back if the save fails.
@Riverpod(keepAlive: true)
class FavouriteExercises extends _$FavouriteExercises {
  @override
  Future<Set<String>> build() => ref.watch(exerciseRepositoryProvider).favourites();

  Future<void> toggle(String exerciseId) async {
    final before = state.value ?? const <String>{};
    final on = !before.contains(exerciseId);
    state = AsyncData(on ? {...before, exerciseId} : ({...before}..remove(exerciseId)));
    try {
      await ref.read(exerciseRepositoryProvider).setFavourite(exerciseId, on: on);
    } catch (_) {
      state = AsyncData(before);
      rethrow;
    }
  }
}

extension ExerciseActions on WidgetRef {
  /// Saves a custom exercise and refreshes the catalogue.
  Future<String> saveCustomExercise(ExerciseDraft draft, {Uint8List? photo}) async {
    final id = await read(exerciseRepositoryProvider).saveCustom(draft, photo: photo);
    invalidate(exerciseCatalogueProvider);
    return id;
  }
}
