import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// How the workout player logs an exercise (spec 4.8).
enum TrackingType {
  @JsonValue('reps_weight')
  repsWeight,
  @JsonValue('reps')
  reps,
  @JsonValue('time')
  time,
  @JsonValue('distance_time')
  distanceTime;

  String get wire => switch (this) {
    repsWeight => 'reps_weight',
    reps => 'reps',
    time => 'time',
    distanceTime => 'distance_time',
  };

  bool get usesWeight => this == repsWeight;
  bool get usesReps => this == repsWeight || this == reps;
  bool get usesTime => this == time || this == distanceTime;
}

/// Muscle groups in the catalogue, front of the body first.
const kMuscles = [
  'chest',
  'shoulders',
  'biceps',
  'forearms',
  'abdominals',
  'quadriceps',
  'adductors',
  'abductors',
  'calves',
  'neck',
  'traps',
  'lats',
  'middle back',
  'lower back',
  'triceps',
  'glutes',
  'hamstrings',
];

/// Equipment the catalogue uses (the owner ticks what the gym has).
const kEquipment = [
  'barbell',
  'dumbbell',
  'cable',
  'machine',
  'kettlebells',
  'bands',
  'medicine ball',
  'exercise ball',
  'foam roll',
  'e-z curl bar',
  'body only',
  'other',
];

const kExerciseLevels = ['beginner', 'intermediate', 'expert'];

const kExerciseCategories = [
  'strength',
  'stretching',
  'cardio',
  'plyometrics',
  'powerlifting',
  'olympic weightlifting',
  'strongman',
];

DateTime _ts(Object? v) => v == null ? DateTime.utc(2026) : DateTime.parse(v as String);

@freezed
abstract class Exercise with _$Exercise {
  const Exercise._();

  const factory Exercise({
    required String id,
    @JsonKey(name: 'source_id') String? sourceId,
    required String name,
    @JsonKey(name: 'local_name') String? localName,
    @JsonKey(name: 'primary_muscles') @Default(<String>[]) List<String> primaryMuscles,
    @JsonKey(name: 'secondary_muscles') @Default(<String>[]) List<String> secondaryMuscles,
    String? equipment,
    String? level,
    String? category,
    String? mechanic,
    String? force,
    @JsonKey(name: 'tracking_type') @Default(TrackingType.repsWeight) TrackingType trackingType,
    @Default(<String>[]) List<String> instructions,
    String? tips,
    String? mistakes,
    @Default(<String>[]) List<String> images,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'is_custom') @Default(false) bool isCustom,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'updated_at', fromJson: _ts) required DateTime updatedAt,
    @JsonKey(name: 'archived_at') DateTime? archivedAt,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

  bool get isArchived => archivedAt != null;
  String? get primaryMuscle => primaryMuscles.firstOrNull;
  List<String> get allMuscles => [...primaryMuscles, ...secondaryMuscles];
}

/// Library filters (4.3). Empty means "any".
@freezed
abstract class ExerciseFilter with _$ExerciseFilter {
  const ExerciseFilter._();

  const factory ExerciseFilter({
    @Default('') String search,
    String? muscle,
    String? equipment,
    String? level,
    String? category,
    @Default(false) bool ourEquipmentOnly,
    @Default(false) bool favouritesOnly,
  }) = _ExerciseFilter;

  int get activeCount =>
      (muscle == null ? 0 : 1) +
      (equipment == null ? 0 : 1) +
      (level == null ? 0 : 1) +
      (category == null ? 0 : 1) +
      (ourEquipmentOnly ? 1 : 0) +
      (favouritesOnly ? 1 : 0);
}

/// The whole catalogue in memory with pre-lowered names, so a search across
/// 800+ exercises takes a millisecond or two (spec: under 100 ms).
class ExerciseIndex {
  ExerciseIndex(List<Exercise> all)
    : all = List.unmodifiable(all.where((e) => !e.isArchived).toList()..sort((a, b) => a.name.compareTo(b.name))),
      byId = {for (final e in all) e.id: e} {
    for (final e in this.all) {
      _names[e.id] = _fold(e.name);
      if (e.localName != null) _local[e.id] = e.localName!.toLowerCase();
    }
  }

  /// Active exercises, A–Z.
  final List<Exercise> all;

  /// Every exercise, including archived ones (old workouts may use them).
  final Map<String, Exercise> byId;
  final _names = <String, String>{};
  final _local = <String, String>{};

  static final _nonWord = RegExp(r'[^a-z0-9]+');
  static String _fold(String s) => s.toLowerCase().replaceAll(_nonWord, ' ').trim();

  Exercise? operator [](String id) => byId[id];
  int get length => all.length;

  /// Filters and ranks: name starts with the query, then a word starts with
  /// it, then it appears anywhere (English or local name).
  List<Exercise> query(ExerciseFilter f, {Set<String> favourites = const {}, Set<String> gymEquipment = const {}}) {
    final q = _fold(f.search);
    final qLocal = f.search.trim().toLowerCase();
    final ranked = <(int, Exercise)>[];
    for (final e in all) {
      if (f.muscle != null && !e.primaryMuscles.contains(f.muscle) && !e.secondaryMuscles.contains(f.muscle)) continue;
      if (f.equipment != null && e.equipment != f.equipment) continue;
      if (f.level != null && e.level != f.level) continue;
      if (f.category != null && e.category != f.category) continue;
      if (f.favouritesOnly && !favourites.contains(e.id)) continue;
      if (f.ourEquipmentOnly && e.equipment != null && !gymEquipment.contains(e.equipment)) continue;
      var rank = 3;
      if (q.isNotEmpty) {
        final name = _names[e.id]!;
        final local = _local[e.id];
        if (name.startsWith(q)) {
          rank = 0;
        } else if (name.contains(' $q')) {
          rank = 1;
        } else if (name.contains(q) || (local != null && qLocal.isNotEmpty && local.contains(qLocal))) {
          rank = 2;
        } else {
          continue;
        }
      }
      // Primary-muscle matches before secondary when filtering by muscle.
      if (f.muscle != null && !e.primaryMuscles.contains(f.muscle)) rank += 4;
      ranked.add((rank, e));
    }
    ranked.sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.name.compareTo(b.$2.name));
    return [for (final r in ranked) r.$2];
  }

  /// Same primary muscle, different equipment (4.4 "alternatives").
  List<Exercise> alternatives(Exercise e, {int limit = 8}) {
    final m = e.primaryMuscle;
    if (m == null) return const [];
    final out = all.where((x) => x.id != e.id && x.primaryMuscles.contains(m) && x.equipment != e.equipment).toList()
      ..sort((a, b) {
        // Same category and level first.
        int score(Exercise x) => (x.category == e.category ? 0 : 2) + (x.level == e.level ? 0 : 1);
        final s = score(a).compareTo(score(b));
        return s != 0 ? s : a.name.compareTo(b.name);
      });
    return out.take(limit).toList();
  }

  /// Number of exercises training each muscle (for the body map badges).
  Map<String, int> muscleCounts() {
    final out = <String, int>{};
    for (final e in all) {
      for (final m in e.primaryMuscles) {
        out.update(m, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return out;
  }
}

/// Public URL of a catalogue image: the configured base (if the owner set
/// one) or the Supabase "exercises" bucket.
String? exerciseImageUrl(String? path, {required String? supabaseUrl, String? imageBase}) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return path;
  final base = (imageBase != null && imageBase.isNotEmpty)
      ? imageBase.replaceAll(RegExp(r'/+$'), '')
      : supabaseUrl == null || supabaseUrl.isEmpty
      ? null
      : '${supabaseUrl.replaceAll(RegExp(r'/+$'), '')}/storage/v1/object/public/exercises';
  return base == null ? null : '$base/$path';
}

/// Fields for a custom exercise (4.5).
class ExerciseDraft {
  const ExerciseDraft({
    this.id,
    required this.name,
    this.localName,
    this.primaryMuscles = const [],
    this.secondaryMuscles = const [],
    this.equipment,
    this.level,
    this.category = 'strength',
    this.trackingType = TrackingType.repsWeight,
    this.instructions = const [],
    this.tips,
    this.mistakes,
    this.videoUrl,
    this.images = const [],
  });

  final String? id;
  final String name;
  final String? localName;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final String? equipment;
  final String? level;
  final String? category;
  final TrackingType trackingType;
  final List<String> instructions;
  final String? tips;
  final String? mistakes;
  final String? videoUrl;
  final List<String> images;

  Map<String, dynamic> toJson() {
    String? blank(String? s) => s == null || s.trim().isEmpty ? null : s.trim();
    return {
      'name': name.trim(),
      'local_name': blank(localName),
      'primary_muscles': primaryMuscles,
      'secondary_muscles': secondaryMuscles,
      'equipment': equipment,
      'level': level,
      'category': category,
      'tracking_type': trackingType.wire,
      'instructions': [
        for (final s in instructions)
          if (s.trim().isNotEmpty) s.trim(),
      ],
      'tips': blank(tips),
      'mistakes': blank(mistakes),
      'video_url': blank(videoUrl),
      'images': images,
    };
  }

  static final _youtube = RegExp(r'^https://(www\.|m\.)?(youtube\.com|youtu\.be)/', caseSensitive: false);
  static bool isYoutube(String url) => _youtube.hasMatch(url.trim());
}
