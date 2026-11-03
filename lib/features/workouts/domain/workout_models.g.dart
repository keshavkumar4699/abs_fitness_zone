// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutItem _$WorkoutItemFromJson(Map<String, dynamic> json) => _WorkoutItem(
  id: json['id'] as String?,
  exerciseId: json['exercise_id'] as String,
  position: (json['position'] as num?)?.toInt() ?? 1,
  block: $enumDecodeNullable(_$ItemBlockEnumMap, json['block']) ?? ItemBlock.main,
  groupKey: json['group_key'] as String?,
  sets: (json['sets'] as num?)?.toInt() ?? 3,
  reps: (json['reps'] as num?)?.toInt(),
  repsMax: (json['reps_max'] as num?)?.toInt(),
  durationS: (json['duration_s'] as num?)?.toInt(),
  distanceM: (json['distance_m'] as num?)?.toInt(),
  targetWeight: _num(json['target_weight']),
  rpe: _num(json['rpe']),
  restS: (json['rest_s'] as num?)?.toInt() ?? 60,
  tempo: json['tempo'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$WorkoutItemToJson(_WorkoutItem instance) => <String, dynamic>{
  'id': instance.id,
  'exercise_id': instance.exerciseId,
  'position': instance.position,
  'block': _$ItemBlockEnumMap[instance.block]!,
  'group_key': instance.groupKey,
  'sets': instance.sets,
  'reps': instance.reps,
  'reps_max': instance.repsMax,
  'duration_s': instance.durationS,
  'distance_m': instance.distanceM,
  'target_weight': instance.targetWeight,
  'rpe': instance.rpe,
  'rest_s': instance.restS,
  'tempo': instance.tempo,
  'notes': instance.notes,
};

const _$ItemBlockEnumMap = {ItemBlock.warmup: 'warmup', ItemBlock.main: 'main', ItemBlock.cooldown: 'cooldown'};

_WorkoutDay _$WorkoutDayFromJson(Map<String, dynamic> json) => _WorkoutDay(
  id: json['id'] as String?,
  dayIndex: (json['day_index'] as num?)?.toInt() ?? 1,
  name: json['name'] as String,
  notes: json['notes'] as String?,
  items:
      (json['workout_items'] as List<dynamic>?)?.map((e) => WorkoutItem.fromJson(e as Map<String, dynamic>)).toList() ??
      const <WorkoutItem>[],
);

Map<String, dynamic> _$WorkoutDayToJson(_WorkoutDay instance) => <String, dynamic>{
  'id': instance.id,
  'day_index': instance.dayIndex,
  'name': instance.name,
  'notes': instance.notes,
  'workout_items': instance.items.map((e) => e.toJson()).toList(),
};

_WorkoutTemplate _$WorkoutTemplateFromJson(Map<String, dynamic> json) => _WorkoutTemplate(
  id: json['id'] as String?,
  name: json['name'] as String,
  description: json['description'] as String?,
  goal: json['goal'] as String?,
  level: json['level'] as String?,
  weeks: (json['weeks'] as num?)?.toInt() ?? 4,
  progression: $enumDecodeNullable(_$ProgressionEnumMap, json['progression']) ?? Progression.none,
  progressionStep: json['progression_step'] == null ? 0 : _num(json['progression_step']),
  isGymTemplate: json['is_gym_template'] as bool? ?? true,
  isStarter: json['is_starter'] as bool? ?? false,
  sourceTemplateId: json['source_template_id'] as String?,
  createdBy: json['created_by'] as String?,
  days:
      (json['workout_days'] as List<dynamic>?)?.map((e) => WorkoutDay.fromJson(e as Map<String, dynamic>)).toList() ??
      const <WorkoutDay>[],
);

Map<String, dynamic> _$WorkoutTemplateToJson(_WorkoutTemplate instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'goal': instance.goal,
  'level': instance.level,
  'weeks': instance.weeks,
  'progression': _$ProgressionEnumMap[instance.progression]!,
  'progression_step': instance.progressionStep,
  'is_gym_template': instance.isGymTemplate,
  'is_starter': instance.isStarter,
  'source_template_id': instance.sourceTemplateId,
  'created_by': instance.createdBy,
  'workout_days': instance.days.map((e) => e.toJson()).toList(),
};

const _$ProgressionEnumMap = {Progression.none: 'none', Progression.weight: 'weight', Progression.reps: 'reps'};

_MemberProgram _$MemberProgramFromJson(Map<String, dynamic> json) => _MemberProgram(
  id: json['id'] as String,
  memberId: json['member_id'] as String,
  templateId: json['template_id'] as String,
  sourceTemplateId: json['source_template_id'] as String?,
  name: json['name'] as String,
  startDate: _date(json['start_date']),
  endDate: _date(json['end_date']),
  weekdays: (json['weekdays'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const <int>[],
  status: $enumDecodeNullable(_$ProgramStatusEnumMap, json['status']) ?? ProgramStatus.active,
  assignedAt: json['assigned_at'] == null ? null : DateTime.parse(json['assigned_at'] as String),
  template: json['template'] == null ? null : WorkoutTemplate.fromJson(json['template'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MemberProgramToJson(_MemberProgram instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'template_id': instance.templateId,
  'source_template_id': instance.sourceTemplateId,
  'name': instance.name,
  'start_date': _dateOut(instance.startDate),
  'end_date': _dateOut(instance.endDate),
  'weekdays': instance.weekdays,
  'status': _$ProgramStatusEnumMap[instance.status]!,
  'assigned_at': instance.assignedAt?.toIso8601String(),
  'template': instance.template?.toJson(),
};

const _$ProgramStatusEnumMap = {
  ProgramStatus.active: 'active',
  ProgramStatus.queued: 'queued',
  ProgramStatus.completed: 'completed',
  ProgramStatus.replaced: 'replaced',
  ProgramStatus.cancelled: 'cancelled',
};

_SetLog _$SetLogFromJson(Map<String, dynamic> json) => _SetLog(
  id: json['id'] as String?,
  exerciseId: json['exercise_id'] as String,
  setNo: (json['set_no'] as num).toInt(),
  weight: _num(json['weight']),
  reps: (json['reps'] as num?)?.toInt(),
  durationS: (json['duration_s'] as num?)?.toInt(),
  distanceM: (json['distance_m'] as num?)?.toInt(),
  e1rm: _num(json['e1rm']),
  isPr: json['is_pr'] as bool? ?? false,
  prKinds: (json['pr_kinds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  doneAt: json['done_at'] == null ? null : DateTime.parse(json['done_at'] as String),
);

Map<String, dynamic> _$SetLogToJson(_SetLog instance) => <String, dynamic>{
  'id': instance.id,
  'exercise_id': instance.exerciseId,
  'set_no': instance.setNo,
  'weight': instance.weight,
  'reps': instance.reps,
  'duration_s': instance.durationS,
  'distance_m': instance.distanceM,
  'e1rm': instance.e1rm,
  'is_pr': instance.isPr,
  'pr_kinds': instance.prKinds,
  'done_at': instance.doneAt?.toIso8601String(),
};

_WorkoutComment _$WorkoutCommentFromJson(Map<String, dynamic> json) => _WorkoutComment(
  id: json['id'] as String,
  authorName: json['author_name'] as String,
  body: json['body'] as String?,
  emoji: json['emoji'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$WorkoutCommentToJson(_WorkoutComment instance) => <String, dynamic>{
  'id': instance.id,
  'author_name': instance.authorName,
  'body': instance.body,
  'emoji': instance.emoji,
  'created_at': instance.createdAt.toIso8601String(),
};

_WorkoutLog _$WorkoutLogFromJson(Map<String, dynamic> json) => _WorkoutLog(
  id: json['id'] as String,
  clientId: json['client_id'] as String,
  memberId: json['member_id'] as String,
  programId: json['program_id'] as String?,
  dayId: json['day_id'] as String?,
  name: json['name'] as String,
  startedAt: DateTime.parse(json['started_at'] as String),
  finishedAt: DateTime.parse(json['finished_at'] as String),
  day: _date(json['day']),
  durationS: (json['duration_s'] as num?)?.toInt() ?? 0,
  totalVolume: json['total_volume'] == null ? 0 : _num(json['total_volume']),
  status: json['status'] as String? ?? 'completed',
  notes: json['notes'] as String?,
  sets:
      (json['set_logs'] as List<dynamic>?)?.map((e) => SetLog.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SetLog>[],
  comments:
      (json['workout_comments'] as List<dynamic>?)
          ?.map((e) => WorkoutComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <WorkoutComment>[],
);

Map<String, dynamic> _$WorkoutLogToJson(_WorkoutLog instance) => <String, dynamic>{
  'id': instance.id,
  'client_id': instance.clientId,
  'member_id': instance.memberId,
  'program_id': instance.programId,
  'day_id': instance.dayId,
  'name': instance.name,
  'started_at': instance.startedAt.toIso8601String(),
  'finished_at': instance.finishedAt.toIso8601String(),
  'day': _dateOut(instance.day),
  'duration_s': instance.durationS,
  'total_volume': instance.totalVolume,
  'status': instance.status,
  'notes': instance.notes,
  'set_logs': instance.sets.map((e) => e.toJson()).toList(),
  'workout_comments': instance.comments.map((e) => e.toJson()).toList(),
};

_CoachRow _$CoachRowFromJson(Map<String, dynamic> json) => _CoachRow(
  memberId: json['member_id'] as String,
  name: json['name'] as String,
  memberCode: json['member_code'] as String,
  photoPath: json['photo_url'] as String?,
  trainerId: json['trainer_id'] as String?,
  status: json['status'] as String?,
  programId: json['program_id'] as String?,
  programName: json['program_name'] as String?,
  programStatus: $enumDecodeNullable(_$ProgramStatusEnumMap, json['program_status']),
  programStart: _date(json['program_start']),
  programEnd: _date(json['program_end']),
  lastWorkoutAt: json['last_workout_at'] == null ? null : DateTime.parse(json['last_workout_at'] as String),
  workouts7d: (json['workouts_7d'] as num?)?.toInt() ?? 0,
  adherence: _num(json['adherence']),
  plannedToday: json['planned_today'] as bool? ?? false,
  doneToday: json['done_today'] as bool? ?? false,
  missed7d: (json['missed_7d'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CoachRowToJson(_CoachRow instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'name': instance.name,
  'member_code': instance.memberCode,
  'photo_url': instance.photoPath,
  'trainer_id': instance.trainerId,
  'status': instance.status,
  'program_id': instance.programId,
  'program_name': instance.programName,
  'program_status': _$ProgramStatusEnumMap[instance.programStatus],
  'program_start': _dateOut(instance.programStart),
  'program_end': _dateOut(instance.programEnd),
  'last_workout_at': instance.lastWorkoutAt?.toIso8601String(),
  'workouts_7d': instance.workouts7d,
  'adherence': instance.adherence,
  'planned_today': instance.plannedToday,
  'done_today': instance.doneToday,
  'missed_7d': instance.missed7d,
};

_PrHit _$PrHitFromJson(Map<String, dynamic> json) => _PrHit(
  exerciseId: json['exercise_id'] as String,
  setNo: (json['set_no'] as num).toInt(),
  kinds: (json['kinds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  weight: _num(json['weight']),
  reps: (json['reps'] as num?)?.toInt(),
  e1rm: _num(json['e1rm']),
);

Map<String, dynamic> _$PrHitToJson(_PrHit instance) => <String, dynamic>{
  'exercise_id': instance.exerciseId,
  'set_no': instance.setNo,
  'kinds': instance.kinds,
  'weight': instance.weight,
  'reps': instance.reps,
  'e1rm': instance.e1rm,
};

_SaveLogResult _$SaveLogResultFromJson(Map<String, dynamic> json) => _SaveLogResult(
  logId: json['log_id'] as String,
  totalVolume: json['total_volume'] == null ? 0 : _num(json['total_volume']),
  prs:
      (json['prs'] as List<dynamic>?)?.map((e) => PrHit.fromJson(e as Map<String, dynamic>)).toList() ??
      const <PrHit>[],
);

Map<String, dynamic> _$SaveLogResultToJson(_SaveLogResult instance) => <String, dynamic>{
  'log_id': instance.logId,
  'total_volume': instance.totalVolume,
  'prs': instance.prs.map((e) => e.toJson()).toList(),
};
