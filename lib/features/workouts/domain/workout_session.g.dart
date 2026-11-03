// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionSet _$SessionSetFromJson(Map<String, dynamic> json) => _SessionSet(
  setNo: (json['setNo'] as num).toInt(),
  targetWeight: (json['targetWeight'] as num?)?.toDouble(),
  targetReps: (json['targetReps'] as num?)?.toInt(),
  targetDuration: (json['targetDuration'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toDouble(),
  reps: (json['reps'] as num?)?.toInt(),
  durationS: (json['durationS'] as num?)?.toInt(),
  distanceM: (json['distanceM'] as num?)?.toInt(),
  done: json['done'] as bool? ?? false,
  doneAt: json['doneAt'] == null
      ? null
      : DateTime.parse(json['doneAt'] as String),
);

Map<String, dynamic> _$SessionSetToJson(_SessionSet instance) =>
    <String, dynamic>{
      'setNo': instance.setNo,
      'targetWeight': instance.targetWeight,
      'targetReps': instance.targetReps,
      'targetDuration': instance.targetDuration,
      'weight': instance.weight,
      'reps': instance.reps,
      'durationS': instance.durationS,
      'distanceM': instance.distanceM,
      'done': instance.done,
      'doneAt': instance.doneAt?.toIso8601String(),
    };

_SessionExercise _$SessionExerciseFromJson(Map<String, dynamic> json) =>
    _SessionExercise(
      exerciseId: json['exerciseId'] as String,
      name: json['name'] as String,
      trackingType:
          $enumDecodeNullable(_$TrackingTypeEnumMap, json['trackingType']) ??
          TrackingType.repsWeight,
      block: $enumDecodeNullable(_$BlockEnumMap, json['block']) ?? Block.main,
      groupKey: json['groupKey'] as String?,
      restS: (json['restS'] as num?)?.toInt() ?? 60,
      tempo: json['tempo'] as String?,
      notes: json['notes'] as String?,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((e) => SessionSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SessionSet>[],
    );

Map<String, dynamic> _$SessionExerciseToJson(_SessionExercise instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'name': instance.name,
      'trackingType': _$TrackingTypeEnumMap[instance.trackingType]!,
      'block': _$BlockEnumMap[instance.block]!,
      'groupKey': instance.groupKey,
      'restS': instance.restS,
      'tempo': instance.tempo,
      'notes': instance.notes,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
    };

const _$TrackingTypeEnumMap = {
  TrackingType.repsWeight: 'reps_weight',
  TrackingType.reps: 'reps',
  TrackingType.time: 'time',
  TrackingType.distanceTime: 'distance_time',
};

const _$BlockEnumMap = {
  Block.warmup: 'warmup',
  Block.main: 'main',
  Block.cooldown: 'cooldown',
};

_WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) =>
    _WorkoutSession(
      clientId: json['clientId'] as String,
      memberId: json['memberId'] as String,
      programId: json['programId'] as String?,
      dayId: json['dayId'] as String?,
      name: json['name'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => SessionExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SessionExercise>[],
      current: (json['current'] as num?)?.toInt() ?? 0,
      restEndsAt: json['restEndsAt'] == null
          ? null
          : DateTime.parse(json['restEndsAt'] as String),
      restTotalS: (json['restTotalS'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WorkoutSessionToJson(_WorkoutSession instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'memberId': instance.memberId,
      'programId': instance.programId,
      'dayId': instance.dayId,
      'name': instance.name,
      'startedAt': instance.startedAt.toIso8601String(),
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
      'current': instance.current,
      'restEndsAt': instance.restEndsAt?.toIso8601String(),
      'restTotalS': instance.restTotalS,
    };
