// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DietItem _$DietItemFromJson(Map<String, dynamic> json) => _DietItem(
  id: json['id'] as String?,
  foodId: json['food_id'] as String,
  qty: _num(json['qty']),
  altGroup: (json['alt_group'] as num?)?.toInt() ?? 0,
  position: (json['position'] as num?)?.toInt() ?? 1,
  food: json['food'] == null ? null : Food.fromJson(json['food'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DietItemToJson(_DietItem instance) => <String, dynamic>{
  'id': instance.id,
  'food_id': instance.foodId,
  'qty': instance.qty,
  'alt_group': instance.altGroup,
  'position': instance.position,
  'food': instance.food?.toJson(),
};

_DietMeal _$DietMealFromJson(Map<String, dynamic> json) => _DietMeal(
  id: json['id'] as String?,
  slot: json['meal_slot'] as String,
  time: json['time_of_day'] as String?,
  position: (json['position'] as num?)?.toInt() ?? 1,
  notes: json['notes'] as String?,
  items:
      (json['diet_meal_items'] as List<dynamic>?)?.map((e) => DietItem.fromJson(e as Map<String, dynamic>)).toList() ??
      const <DietItem>[],
);

Map<String, dynamic> _$DietMealToJson(_DietMeal instance) => <String, dynamic>{
  'id': instance.id,
  'meal_slot': instance.slot,
  'time_of_day': instance.time,
  'position': instance.position,
  'notes': instance.notes,
  'diet_meal_items': instance.items.map((e) => e.toJson()).toList(),
};

_DietTemplate _$DietTemplateFromJson(Map<String, dynamic> json) => _DietTemplate(
  id: json['id'] as String?,
  name: json['name'] as String,
  description: json['description'] as String?,
  goal: json['goal'] as String?,
  dietPref: json['diet_pref'] as String?,
  kcalTarget: (json['kcal_target'] as num?)?.toInt() ?? 2000,
  proteinG: (json['protein_g'] as num?)?.toInt(),
  carbsG: (json['carbs_g'] as num?)?.toInt(),
  fatG: (json['fat_g'] as num?)?.toInt(),
  macroPreset: json['macro_preset'] as String?,
  supplements: (json['supplements'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  isGymTemplate: json['is_gym_template'] as bool? ?? true,
  isStarter: json['is_starter'] as bool? ?? false,
  sourceTemplateId: json['source_template_id'] as String?,
  createdBy: json['created_by'] as String?,
  meals:
      (json['diet_meals'] as List<dynamic>?)?.map((e) => DietMeal.fromJson(e as Map<String, dynamic>)).toList() ??
      const <DietMeal>[],
);

Map<String, dynamic> _$DietTemplateToJson(_DietTemplate instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'goal': instance.goal,
  'diet_pref': instance.dietPref,
  'kcal_target': instance.kcalTarget,
  'protein_g': instance.proteinG,
  'carbs_g': instance.carbsG,
  'fat_g': instance.fatG,
  'macro_preset': instance.macroPreset,
  'supplements': instance.supplements,
  'is_gym_template': instance.isGymTemplate,
  'is_starter': instance.isStarter,
  'source_template_id': instance.sourceTemplateId,
  'created_by': instance.createdBy,
  'diet_meals': instance.meals.map((e) => e.toJson()).toList(),
};

_MemberDiet _$MemberDietFromJson(Map<String, dynamic> json) => _MemberDiet(
  id: json['id'] as String,
  memberId: json['member_id'] as String,
  templateId: json['template_id'] as String,
  sourceTemplateId: json['source_template_id'] as String?,
  name: json['name'] as String,
  startDate: _date(json['start_date']),
  endDate: _date(json['end_date']),
  status: $enumDecodeNullable(_$DietStatusEnumMap, json['status']) ?? DietStatus.active,
  assignedAt: json['assigned_at'] == null ? null : DateTime.parse(json['assigned_at'] as String),
  template: json['template'] == null ? null : DietTemplate.fromJson(json['template'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MemberDietToJson(_MemberDiet instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'template_id': instance.templateId,
  'source_template_id': instance.sourceTemplateId,
  'name': instance.name,
  'start_date': _dateOut(instance.startDate),
  'end_date': _dateOut(instance.endDate),
  'status': _$DietStatusEnumMap[instance.status]!,
  'assigned_at': instance.assignedAt?.toIso8601String(),
  'template': instance.template?.toJson(),
};

const _$DietStatusEnumMap = {
  DietStatus.active: 'active',
  DietStatus.queued: 'queued',
  DietStatus.replaced: 'replaced',
  DietStatus.ended: 'ended',
  DietStatus.dropped: 'dropped',
};

_MealLog _$MealLogFromJson(Map<String, dynamic> json) => _MealLog(
  id: json['id'] as String?,
  memberId: json['member_id'] as String,
  memberDietId: json['member_diet_id'] as String?,
  day: _date(json['day']),
  slot: json['meal_slot'] as String,
  status: json['status'] as String,
  altGroup: (json['alt_group'] as num?)?.toInt(),
  kcal: json['kcal'] == null ? 0 : _num(json['kcal']),
  protein: json['protein_g'] == null ? 0 : _num(json['protein_g']),
  carbs: json['carbs_g'] == null ? 0 : _num(json['carbs_g']),
  fat: json['fat_g'] == null ? 0 : _num(json['fat_g']),
  loggedAt: json['logged_at'] == null ? null : DateTime.parse(json['logged_at'] as String),
);

Map<String, dynamic> _$MealLogToJson(_MealLog instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'member_diet_id': instance.memberDietId,
  'day': _dateOut(instance.day),
  'meal_slot': instance.slot,
  'status': instance.status,
  'alt_group': instance.altGroup,
  'kcal': instance.kcal,
  'protein_g': instance.protein,
  'carbs_g': instance.carbs,
  'fat_g': instance.fat,
  'logged_at': instance.loggedAt?.toIso8601String(),
};

_WaterLog _$WaterLogFromJson(Map<String, dynamic> json) =>
    _WaterLog(day: _date(json['day']), glasses: (json['glasses'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$WaterLogToJson(_WaterLog instance) => <String, dynamic>{
  'day': _dateOut(instance.day),
  'glasses': instance.glasses,
};

_SupplementLog _$SupplementLogFromJson(Map<String, dynamic> json) =>
    _SupplementLog(day: _date(json['day']), name: json['name'] as String);

Map<String, dynamic> _$SupplementLogToJson(_SupplementLog instance) => <String, dynamic>{
  'day': _dateOut(instance.day),
  'name': instance.name,
};

_DietLogs _$DietLogsFromJson(Map<String, dynamic> json) => _DietLogs(
  meals:
      (json['meals'] as List<dynamic>?)?.map((e) => MealLog.fromJson(e as Map<String, dynamic>)).toList() ??
      const <MealLog>[],
  water:
      (json['water'] as List<dynamic>?)?.map((e) => WaterLog.fromJson(e as Map<String, dynamic>)).toList() ??
      const <WaterLog>[],
  supplements:
      (json['supplements'] as List<dynamic>?)?.map((e) => SupplementLog.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SupplementLog>[],
);

Map<String, dynamic> _$DietLogsToJson(_DietLogs instance) => <String, dynamic>{
  'meals': instance.meals.map((e) => e.toJson()).toList(),
  'water': instance.water.map((e) => e.toJson()).toList(),
  'supplements': instance.supplements.map((e) => e.toJson()).toList(),
};

_DietComment _$DietCommentFromJson(Map<String, dynamic> json) => _DietComment(
  id: json['id'] as String,
  authorName: json['author_name'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$DietCommentToJson(_DietComment instance) => <String, dynamic>{
  'id': instance.id,
  'author_name': instance.authorName,
  'body': instance.body,
  'created_at': instance.createdAt.toIso8601String(),
};

_DietFlags _$DietFlagsFromJson(Map<String, dynamic> json) => _DietFlags(
  memberId: json['member_id'] as String,
  name: json['name'] as String? ?? '',
  dietPref: json['diet_pref'] as String?,
  allergies: (json['food_allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  avoid: (json['foods_to_avoid'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  conditions: json['conditions'] as String?,
  hasConditions: json['has_conditions'] as bool? ?? false,
);

Map<String, dynamic> _$DietFlagsToJson(_DietFlags instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'name': instance.name,
  'diet_pref': instance.dietPref,
  'food_allergies': instance.allergies,
  'foods_to_avoid': instance.avoid,
  'conditions': instance.conditions,
  'has_conditions': instance.hasConditions,
};

_DietRow _$DietRowFromJson(Map<String, dynamic> json) => _DietRow(
  memberId: json['member_id'] as String,
  name: json['name'] as String,
  memberCode: json['member_code'] as String,
  photoPath: json['photo_url'] as String?,
  trainerId: json['trainer_id'] as String?,
  status: json['status'] as String?,
  dietId: json['diet_id'] as String?,
  dietName: json['diet_name'] as String?,
  dietStatus: $enumDecodeNullable(_$DietStatusEnumMap, json['diet_status']),
  dietStart: _date(json['diet_start']),
  kcalTarget: (json['kcal_target'] as num?)?.toInt(),
  mealsPerDay: (json['meals_per_day'] as num?)?.toInt() ?? 0,
  adherence: _numOrNull(json['adherence_7d']),
  missed7d: (json['missed_7d'] as num?)?.toInt() ?? 0,
  loggedToday: (json['logged_today'] as num?)?.toInt() ?? 0,
  lastLoggedAt: json['last_logged_at'] == null ? null : DateTime.parse(json['last_logged_at'] as String),
  hasConditions: json['has_conditions'] as bool? ?? false,
);

Map<String, dynamic> _$DietRowToJson(_DietRow instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'name': instance.name,
  'member_code': instance.memberCode,
  'photo_url': instance.photoPath,
  'trainer_id': instance.trainerId,
  'status': instance.status,
  'diet_id': instance.dietId,
  'diet_name': instance.dietName,
  'diet_status': _$DietStatusEnumMap[instance.dietStatus],
  'diet_start': _dateOut(instance.dietStart),
  'kcal_target': instance.kcalTarget,
  'meals_per_day': instance.mealsPerDay,
  'adherence_7d': instance.adherence,
  'missed_7d': instance.missed7d,
  'logged_today': instance.loggedToday,
  'last_logged_at': instance.lastLoggedAt?.toIso8601String(),
  'has_conditions': instance.hasConditions,
};
