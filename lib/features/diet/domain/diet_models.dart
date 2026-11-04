import 'package:freezed_annotation/freezed_annotation.dart';

import 'food.dart';

part 'diet_models.freezed.dart';
part 'diet_models.g.dart';

/// Calendar dates arrive as "YYYY-MM-DD" and are kept as UTC midnight.
DateTime? _date(Object? v) {
  if (v == null || v == '') return null;
  final d = DateTime.parse(v as String);
  return DateTime.utc(d.year, d.month, d.day);
}

String? _dateOut(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String? dietDate(DateTime? d) => _dateOut(d);

double _num(Object? v) => v == null ? 0 : (v as num).toDouble();
double? _numOrNull(Object? v) => v == null ? null : (v as num).toDouble();

/// The day's meals in order (6.3); each is optional in a plan.
const kMealSlots = [
  'early_morning',
  'breakfast',
  'mid_morning',
  'lunch',
  'evening_snack',
  'pre_workout',
  'post_workout',
  'dinner',
  'bedtime',
];

/// Suggested times for a new meal ("HH:MM").
const kDefaultMealTimes = {
  'early_morning': '06:30',
  'breakfast': '08:30',
  'mid_morning': '11:00',
  'lunch': '13:30',
  'evening_snack': '17:00',
  'pre_workout': '18:00',
  'post_workout': '19:30',
  'dinner': '21:00',
  'bedtime': '22:30',
};

const kDietPrefs = ['veg', 'eggetarian', 'non_veg', 'vegan', 'jain'];
const kDietGoals = ['fat_loss', 'maintenance', 'muscle_gain'];
const kMacroPresets = ['high_protein', 'balanced', 'keto_light'];
const kMealStatuses = ['eaten', 'partly', 'skipped', 'swapped'];

/// Supplements offered in the builder (6.9); any name can be typed.
const kCommonSupplements = ['Whey protein', 'Creatine', 'Multivitamin', 'Fish oil', 'Vitamin D3', 'Vitamin B12'];

enum DietStatus {
  @JsonValue('active')
  active,
  @JsonValue('queued')
  queued,
  @JsonValue('replaced')
  replaced,
  @JsonValue('ended')
  ended,
  @JsonValue('dropped')
  dropped;

  bool get isCurrent => this == active || this == queued;
}

/// A food in a meal. alt_group 0 is the meal itself; 1 and 2 are its "or"
/// options (6.5). The food row comes embedded so a plan opens offline.
@freezed
abstract class DietItem with _$DietItem {
  const factory DietItem({
    String? id,
    @JsonKey(name: 'food_id') required String foodId,
    @JsonKey(fromJson: _num) required double qty,
    @JsonKey(name: 'alt_group') @Default(0) int altGroup,
    @Default(1) int position,
    Food? food,
  }) = _DietItem;

  factory DietItem.fromJson(Map<String, dynamic> json) => _$DietItemFromJson(json);
}

@freezed
abstract class DietMeal with _$DietMeal {
  const DietMeal._();

  const factory DietMeal({
    String? id,
    @JsonKey(name: 'meal_slot') required String slot,
    @JsonKey(name: 'time_of_day') String? time,
    @Default(1) int position,
    String? notes,
    @JsonKey(name: 'diet_meal_items') @Default(<DietItem>[]) List<DietItem> items,
  }) = _DietMeal;

  factory DietMeal.fromJson(Map<String, dynamic> json) => _$DietMealFromJson(json);

  List<DietItem> group(int g) =>
      items.where((i) => i.altGroup == g).toList()..sort((a, b) => a.position.compareTo(b.position));

  List<DietItem> get main => group(0);

  /// The "or" options that have foods (1, 2).
  List<int> get options => [
    for (final g in const [1, 2])
      if (items.any((i) => i.altGroup == g)) g,
  ];

  /// "08:30" from "08:30:00".
  String? get hhmm => time == null || time!.length < 5 ? time : time!.substring(0, 5);

  /// Minutes after midnight, for ordering and reminders.
  int? get minutes {
    final t = hhmm;
    if (t == null) return null;
    final parts = t.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]), m = int.tryParse(parts[1]);
    return h == null || m == null ? null : h * 60 + m;
  }
}

@freezed
abstract class DietTemplate with _$DietTemplate {
  const DietTemplate._();

  const factory DietTemplate({
    String? id,
    required String name,
    String? description,
    String? goal,
    @JsonKey(name: 'diet_pref') String? dietPref,
    @JsonKey(name: 'kcal_target') @Default(2000) int kcalTarget,
    @JsonKey(name: 'protein_g') int? proteinG,
    @JsonKey(name: 'carbs_g') int? carbsG,
    @JsonKey(name: 'fat_g') int? fatG,
    @JsonKey(name: 'macro_preset') String? macroPreset,
    @Default(<String>[]) List<String> supplements,
    @JsonKey(name: 'is_gym_template') @Default(true) bool isGymTemplate,
    @JsonKey(name: 'is_starter') @Default(false) bool isStarter,
    @JsonKey(name: 'source_template_id') String? sourceTemplateId,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'diet_meals') @Default(<DietMeal>[]) List<DietMeal> meals,
  }) = _DietTemplate;

  factory DietTemplate.fromJson(Map<String, dynamic> json) => _$DietTemplateFromJson(json);

  /// Meals in the order of the day.
  List<DietMeal> get orderedMeals =>
      [...meals]..sort((a, b) => kMealSlots.indexOf(a.slot).compareTo(kMealSlots.indexOf(b.slot)));

  int get foodCount => meals.fold(0, (a, m) => a + m.main.length);

  DietMeal? meal(String slot) => meals.where((m) => m.slot == slot).firstOrNull;

  /// What `save_diet_template` expects.
  Map<String, dynamic> toPayload() => {
    'id': id,
    'name': name.trim(),
    'description': description,
    'goal': goal,
    'diet_pref': dietPref,
    'kcal_target': kcalTarget,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'macro_preset': macroPreset,
    'supplements': supplements,
    'meals': [
      for (final m in orderedMeals)
        {
          'meal_slot': m.slot,
          'time_of_day': m.hhmm,
          'notes': m.notes,
          'items': [
            for (final g in const [0, 1, 2])
              for (final i in m.group(g)) {'food_id': i.foodId, 'qty': i.qty, 'alt_group': g},
          ],
        },
    ],
  };
}

@freezed
abstract class MemberDiet with _$MemberDiet {
  const factory MemberDiet({
    required String id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'template_id') required String templateId,
    @JsonKey(name: 'source_template_id') String? sourceTemplateId,
    required String name,
    @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) required DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) DateTime? endDate,
    @Default(DietStatus.active) DietStatus status,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    DietTemplate? template,
  }) = _MemberDiet;

  factory MemberDiet.fromJson(Map<String, dynamic> json) => _$MemberDietFromJson(json);
}

@freezed
abstract class MealLog with _$MealLog {
  const MealLog._();

  const factory MealLog({
    String? id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'member_diet_id') String? memberDietId,
    @JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day,
    @JsonKey(name: 'meal_slot') required String slot,
    required String status,
    @JsonKey(name: 'alt_group') int? altGroup,
    @JsonKey(fromJson: _num) @Default(0) double kcal,
    @JsonKey(name: 'protein_g', fromJson: _num) @Default(0) double protein,
    @JsonKey(name: 'carbs_g', fromJson: _num) @Default(0) double carbs,
    @JsonKey(name: 'fat_g', fromJson: _num) @Default(0) double fat,
    @JsonKey(name: 'logged_at') DateTime? loggedAt,
  }) = _MealLog;

  factory MealLog.fromJson(Map<String, dynamic> json) => _$MealLogFromJson(json);

  Macros get macros => Macros(kcal, protein, carbs, fat);

  /// Adherence points: eaten or swapped 1, partly ½, skipped 0.
  double get points => switch (status) {
    'eaten' || 'swapped' => 1,
    'partly' => 0.5,
    _ => 0,
  };
}

@freezed
abstract class WaterLog with _$WaterLog {
  const factory WaterLog({
    @JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day,
    @Default(0) int glasses,
  }) = _WaterLog;

  factory WaterLog.fromJson(Map<String, dynamic> json) => _$WaterLogFromJson(json);
}

@freezed
abstract class SupplementLog with _$SupplementLog {
  const factory SupplementLog({
    @JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day,
    required String name,
  }) = _SupplementLog;

  factory SupplementLog.fromJson(Map<String, dynamic> json) => _$SupplementLogFromJson(json);
}

/// Everything a member logged since a date (meals, water, supplements).
@freezed
abstract class DietLogs with _$DietLogs {
  const DietLogs._();

  const factory DietLogs({
    @Default(<MealLog>[]) List<MealLog> meals,
    @Default(<WaterLog>[]) List<WaterLog> water,
    @Default(<SupplementLog>[]) List<SupplementLog> supplements,
  }) = _DietLogs;

  factory DietLogs.fromJson(Map<String, dynamic> json) => _$DietLogsFromJson(json);

  Map<String, MealLog> mealsOn(DateTime day) => {
    for (final m in meals)
      if (m.day == day) m.slot: m,
  };

  int glassesOn(DateTime day) => water.where((w) => w.day == day).firstOrNull?.glasses ?? 0;

  Set<String> supplementsOn(DateTime day) => {
    for (final s in supplements)
      if (s.day == day) s.name,
  };
}

@freezed
abstract class DietComment with _$DietComment {
  const factory DietComment({
    required String id,
    @JsonKey(name: 'author_name') required String authorName,
    required String body,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DietComment;

  factory DietComment.fromJson(Map<String, dynamic> json) => _$DietCommentFromJson(json);
}

/// What the builder and assign sheet warn about (6.4): preference,
/// allergies, foods to avoid, and medical conditions from F1 1.2.
@freezed
abstract class DietFlags with _$DietFlags {
  const DietFlags._();

  const factory DietFlags({
    @JsonKey(name: 'member_id') required String memberId,
    @Default('') String name,
    @JsonKey(name: 'diet_pref') String? dietPref,
    @JsonKey(name: 'food_allergies') @Default(<String>[]) List<String> allergies,
    @JsonKey(name: 'foods_to_avoid') @Default(<String>[]) List<String> avoid,
    String? conditions,
    @JsonKey(name: 'has_conditions') @Default(false) bool hasConditions,
  }) = _DietFlags;

  factory DietFlags.fromJson(Map<String, dynamic> json) => _$DietFlagsFromJson(json);

  bool get hasPreferences => dietPref != null || allergies.isNotEmpty || avoid.isNotEmpty;
}

/// One row of the nutrition overview (6.11).
@freezed
abstract class DietRow with _$DietRow {
  const factory DietRow({
    @JsonKey(name: 'member_id') required String memberId,
    required String name,
    @JsonKey(name: 'member_code') required String memberCode,
    @JsonKey(name: 'photo_url') String? photoPath,
    @JsonKey(name: 'trainer_id') String? trainerId,
    String? status,
    @JsonKey(name: 'diet_id') String? dietId,
    @JsonKey(name: 'diet_name') String? dietName,
    @JsonKey(name: 'diet_status') DietStatus? dietStatus,
    @JsonKey(name: 'diet_start', fromJson: _date, toJson: _dateOut) DateTime? dietStart,
    @JsonKey(name: 'kcal_target') int? kcalTarget,
    @JsonKey(name: 'meals_per_day') @Default(0) int mealsPerDay,
    @JsonKey(name: 'adherence_7d', fromJson: _numOrNull) double? adherence,
    @JsonKey(name: 'missed_7d') @Default(0) int missed7d,
    @JsonKey(name: 'logged_today') @Default(0) int loggedToday,
    @JsonKey(name: 'last_logged_at') DateTime? lastLoggedAt,
    @JsonKey(name: 'has_conditions') @Default(false) bool hasConditions,
  }) = _DietRow;

  factory DietRow.fromJson(Map<String, dynamic> json) => _$DietRowFromJson(json);
}
