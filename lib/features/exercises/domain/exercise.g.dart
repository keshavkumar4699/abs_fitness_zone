// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: json['id'] as String,
  sourceId: json['source_id'] as String?,
  name: json['name'] as String,
  localName: json['local_name'] as String?,
  primaryMuscles: (json['primary_muscles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  secondaryMuscles: (json['secondary_muscles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  equipment: json['equipment'] as String?,
  level: json['level'] as String?,
  category: json['category'] as String?,
  mechanic: json['mechanic'] as String?,
  force: json['force'] as String?,
  trackingType: $enumDecodeNullable(_$TrackingTypeEnumMap, json['tracking_type']) ?? TrackingType.repsWeight,
  instructions: (json['instructions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  tips: json['tips'] as String?,
  mistakes: json['mistakes'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  videoUrl: json['video_url'] as String?,
  isCustom: json['is_custom'] as bool? ?? false,
  createdBy: json['created_by'] as String?,
  updatedAt: _ts(json['updated_at']),
  archivedAt: json['archived_at'] == null ? null : DateTime.parse(json['archived_at'] as String),
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'source_id': instance.sourceId,
  'name': instance.name,
  'local_name': instance.localName,
  'primary_muscles': instance.primaryMuscles,
  'secondary_muscles': instance.secondaryMuscles,
  'equipment': instance.equipment,
  'level': instance.level,
  'category': instance.category,
  'mechanic': instance.mechanic,
  'force': instance.force,
  'tracking_type': _$TrackingTypeEnumMap[instance.trackingType]!,
  'instructions': instance.instructions,
  'tips': instance.tips,
  'mistakes': instance.mistakes,
  'images': instance.images,
  'video_url': instance.videoUrl,
  'is_custom': instance.isCustom,
  'created_by': instance.createdBy,
  'updated_at': instance.updatedAt.toIso8601String(),
  'archived_at': instance.archivedAt?.toIso8601String(),
};

const _$TrackingTypeEnumMap = {
  TrackingType.repsWeight: 'reps_weight',
  TrackingType.reps: 'reps',
  TrackingType.time: 'time',
  TrackingType.distanceTime: 'distance_time',
};
