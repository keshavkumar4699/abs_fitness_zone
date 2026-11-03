import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_models.freezed.dart';
part 'workout_models.g.dart';

/// Calendar dates arrive as "YYYY-MM-DD" and are kept as UTC midnight.
DateTime? _date(Object? v) {
  if (v == null || v == '') return null;
  final d = DateTime.parse(v as String);
  return DateTime.utc(d.year, d.month, d.day);
}

String? _dateOut(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String? workoutDate(DateTime? d) => _dateOut(d);

double? _num(Object? v) => v == null ? null : (v as num).toDouble();

enum Progression {
  @JsonValue('none')
  none,
  @JsonValue('weight')
  weight,
  @JsonValue('reps')
  reps,
}

enum ItemBlock {
  @JsonValue('warmup')
  warmup,
  @JsonValue('main')
  main,
  @JsonValue('cooldown')
  cooldown,
}

enum ProgramStatus {
  @JsonValue('active')
  active,
  @JsonValue('queued')
  queued,
  @JsonValue('completed')
  completed,
  @JsonValue('replaced')
  replaced,
  @JsonValue('cancelled')
  cancelled;

  bool get isCurrent => this == active || this == queued;
}

const kWorkoutGoals = ['fat_loss', 'muscle_gain', 'strength', 'general_fitness', 'rehab'];
const kWorkoutLevels = ['beginner', 'intermediate', 'advanced'];
const kReactions = ['thumbs_up', 'fire', 'muscle', 'clap', 'star'];

@freezed
abstract class WorkoutItem with _$WorkoutItem {
  const WorkoutItem._();

  const factory WorkoutItem({
    String? id,
    @JsonKey(name: 'exercise_id') required String exerciseId,
    @Default(1) int position,
    @Default(ItemBlock.main) ItemBlock block,
    @JsonKey(name: 'group_key') String? groupKey,
    @Default(3) int sets,
    int? reps,
    @JsonKey(name: 'reps_max') int? repsMax,
    @JsonKey(name: 'duration_s') int? durationS,
    @JsonKey(name: 'distance_m') int? distanceM,
    @JsonKey(name: 'target_weight', fromJson: _num) double? targetWeight,
    @JsonKey(fromJson: _num) double? rpe,
    @JsonKey(name: 'rest_s') @Default(60) int restS,
    String? tempo,
    String? notes,
  }) = _WorkoutItem;

  factory WorkoutItem.fromJson(Map<String, dynamic> json) => _$WorkoutItemFromJson(json);

  /// What `save_template` expects for this item.
  Map<String, dynamic> toPayload() => {
    'exercise_id': exerciseId,
    'block': switch (block) {
      ItemBlock.warmup => 'warmup',
      ItemBlock.main => 'main',
      ItemBlock.cooldown => 'cooldown',
    },
    'group_key': groupKey,
    'sets': sets,
    'reps': reps,
    'reps_max': repsMax,
    'duration_s': durationS,
    'distance_m': distanceM,
    'target_weight': targetWeight,
    'rpe': rpe,
    'rest_s': restS,
    'tempo': tempo,
    'notes': notes,
  };
}

@freezed
abstract class WorkoutDay with _$WorkoutDay {
  const WorkoutDay._();

  const factory WorkoutDay({
    String? id,
    @JsonKey(name: 'day_index') @Default(1) int dayIndex,
    required String name,
    String? notes,
    @JsonKey(name: 'workout_items') @Default(<WorkoutItem>[]) List<WorkoutItem> items,
  }) = _WorkoutDay;

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => _$WorkoutDayFromJson(json);

  List<WorkoutItem> get ordered => [...items]..sort((a, b) => a.position.compareTo(b.position));
}

@freezed
abstract class WorkoutTemplate with _$WorkoutTemplate {
  const WorkoutTemplate._();

  const factory WorkoutTemplate({
    String? id,
    required String name,
    String? description,
    String? goal,
    String? level,
    @Default(4) int weeks,
    @Default(Progression.none) Progression progression,
    @JsonKey(name: 'progression_step', fromJson: _num) @Default(0) double? progressionStep,
    @JsonKey(name: 'is_gym_template') @Default(true) bool isGymTemplate,
    @JsonKey(name: 'is_starter') @Default(false) bool isStarter,
    @JsonKey(name: 'source_template_id') String? sourceTemplateId,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'workout_days') @Default(<WorkoutDay>[]) List<WorkoutDay> days,
  }) = _WorkoutTemplate;

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) => _$WorkoutTemplateFromJson(json);

  List<WorkoutDay> get orderedDays => [...days]..sort((a, b) => a.dayIndex.compareTo(b.dayIndex));
  int get exerciseCount => days.fold(0, (a, d) => a + d.items.length);

  /// What `save_template` expects.
  Map<String, dynamic> toPayload() => {
    'id': id,
    'name': name.trim(),
    'description': description,
    'goal': goal,
    'level': level,
    'weeks': weeks,
    'progression': switch (progression) {
      Progression.none => 'none',
      Progression.weight => 'weight',
      Progression.reps => 'reps',
    },
    'progression_step': progressionStep ?? 0,
    'days': [
      for (final d in orderedDays)
        {
          'name': d.name,
          'notes': d.notes,
          'items': [for (final i in d.ordered) i.toPayload()],
        },
    ],
  };
}

@freezed
abstract class MemberProgram with _$MemberProgram {
  const MemberProgram._();

  const factory MemberProgram({
    required String id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'template_id') required String templateId,
    @JsonKey(name: 'source_template_id') String? sourceTemplateId,
    required String name,
    @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) required DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) required DateTime? endDate,
    @Default(<int>[]) List<int> weekdays,
    @Default(ProgramStatus.active) ProgramStatus status,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    WorkoutTemplate? template,
  }) = _MemberProgram;

  factory MemberProgram.fromJson(Map<String, dynamic> json) => _$MemberProgramFromJson(json);
}

@freezed
abstract class SetLog with _$SetLog {
  const SetLog._();

  const factory SetLog({
    String? id,
    @JsonKey(name: 'exercise_id') required String exerciseId,
    @JsonKey(name: 'set_no') required int setNo,
    @JsonKey(fromJson: _num) double? weight,
    int? reps,
    @JsonKey(name: 'duration_s') int? durationS,
    @JsonKey(name: 'distance_m') int? distanceM,
    @JsonKey(fromJson: _num) double? e1rm,
    @JsonKey(name: 'is_pr') @Default(false) bool isPr,
    @JsonKey(name: 'pr_kinds') @Default(<String>[]) List<String> prKinds,
    @JsonKey(name: 'done_at') DateTime? doneAt,
  }) = _SetLog;

  factory SetLog.fromJson(Map<String, dynamic> json) => _$SetLogFromJson(json);

  double get volume => (weight ?? 0) * (reps ?? 0);
}

@freezed
abstract class WorkoutComment with _$WorkoutComment {
  const factory WorkoutComment({
    required String id,
    @JsonKey(name: 'author_name') required String authorName,
    String? body,
    String? emoji,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WorkoutComment;

  factory WorkoutComment.fromJson(Map<String, dynamic> json) => _$WorkoutCommentFromJson(json);
}

@freezed
abstract class WorkoutLog with _$WorkoutLog {
  const WorkoutLog._();

  const factory WorkoutLog({
    required String id,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'program_id') String? programId,
    @JsonKey(name: 'day_id') String? dayId,
    required String name,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'finished_at') required DateTime finishedAt,
    @JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day,
    @JsonKey(name: 'duration_s') @Default(0) int durationS,
    @JsonKey(name: 'total_volume', fromJson: _num) @Default(0) double? totalVolume,
    @Default('completed') String status,
    String? notes,
    @JsonKey(name: 'set_logs') @Default(<SetLog>[]) List<SetLog> sets,
    @JsonKey(name: 'workout_comments') @Default(<WorkoutComment>[]) List<WorkoutComment> comments,
  }) = _WorkoutLog;

  factory WorkoutLog.fromJson(Map<String, dynamic> json) => _$WorkoutLogFromJson(json);

  int get prCount => sets.where((s) => s.isPr).length;

  /// Members may change a finished workout for 24 hours (5.7).
  bool editableAt(DateTime now) => now.difference(finishedAt) < const Duration(hours: 24);
}

/// One row of the coach overview (5.5).
@freezed
abstract class CoachRow with _$CoachRow {
  const factory CoachRow({
    @JsonKey(name: 'member_id') required String memberId,
    required String name,
    @JsonKey(name: 'member_code') required String memberCode,
    @JsonKey(name: 'photo_url') String? photoPath,
    @JsonKey(name: 'trainer_id') String? trainerId,
    String? status,
    @JsonKey(name: 'program_id') String? programId,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'program_status') ProgramStatus? programStatus,
    @JsonKey(name: 'program_start', fromJson: _date, toJson: _dateOut) DateTime? programStart,
    @JsonKey(name: 'program_end', fromJson: _date, toJson: _dateOut) DateTime? programEnd,
    @JsonKey(name: 'last_workout_at') DateTime? lastWorkoutAt,
    @JsonKey(name: 'workouts_7d') @Default(0) int workouts7d,
    @JsonKey(fromJson: _num) double? adherence,
    @JsonKey(name: 'planned_today') @Default(false) bool plannedToday,
    @JsonKey(name: 'done_today') @Default(false) bool doneToday,
    @JsonKey(name: 'missed_7d') @Default(0) int missed7d,
  }) = _CoachRow;

  factory CoachRow.fromJson(Map<String, dynamic> json) => _$CoachRowFromJson(json);
}

/// A personal record from a saved (or locally finished) workout.
@freezed
abstract class PrHit with _$PrHit {
  const factory PrHit({
    @JsonKey(name: 'exercise_id') required String exerciseId,
    @JsonKey(name: 'set_no') required int setNo,
    @Default(<String>[]) List<String> kinds,
    @JsonKey(fromJson: _num) double? weight,
    int? reps,
    @JsonKey(fromJson: _num) double? e1rm,
  }) = _PrHit;

  factory PrHit.fromJson(Map<String, dynamic> json) => _$PrHitFromJson(json);
}

@freezed
abstract class SaveLogResult with _$SaveLogResult {
  const factory SaveLogResult({
    @JsonKey(name: 'log_id') required String logId,
    @JsonKey(name: 'total_volume', fromJson: _num) @Default(0) double? totalVolume,
    @Default(<PrHit>[]) List<PrHit> prs,
  }) = _SaveLogResult;

  factory SaveLogResult.fromJson(Map<String, dynamic> json) => _$SaveLogResultFromJson(json);
}
