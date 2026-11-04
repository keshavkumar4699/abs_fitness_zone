import 'dart:math' as math;

import 'diet_models.dart';
import 'food.dart';

/// Finds a food by id: the row embedded in the plan, else the catalogue.
typedef FoodLookup = Food? Function(String id);

FoodLookup lookupIn(FoodIndex? index) =>
    (id) => index?[id];

Food? foodOf(DietItem i, FoodLookup lookup) => i.food ?? lookup(i.foodId);

// ---------------------------------------------------------------------------
// Totals (6.3)
// ---------------------------------------------------------------------------
Macros itemMacros(DietItem i, FoodLookup lookup) {
  final f = foodOf(i, lookup);
  return f == null ? Macros.zero : f.macros * i.qty;
}

Macros sumItems(Iterable<DietItem> items, FoodLookup lookup) =>
    items.fold(Macros.zero, (a, i) => a + itemMacros(i, lookup));

/// A meal's totals for option [group] (0 = the meal itself).
Macros mealTotals(DietMeal m, FoodLookup lookup, {int group = 0}) => sumItems(m.group(group), lookup);

/// The day's totals: every meal as planned (options don't add up).
Macros dayTotals(DietTemplate t, FoodLookup lookup) => t.meals.fold(Macros.zero, (a, m) => a + mealTotals(m, lookup));

/// What one mark of a meal counts for (eaten 1×, partly ½, skipped 0,
/// swapped = the option eaten). Mirrors the database's `log_meal`.
Macros markedMacros(DietMeal m, String status, int? alt, FoodLookup lookup) => switch (status) {
  'eaten' => mealTotals(m, lookup),
  'partly' => mealTotals(m, lookup) * 0.5,
  'swapped' => mealTotals(m, lookup, group: alt ?? 1),
  _ => Macros.zero,
};

// ---------------------------------------------------------------------------
// Targets calculator (6.2)
// ---------------------------------------------------------------------------
enum ActivityLevel {
  sedentary(1.2),
  light(1.375),
  moderate(1.55),
  active(1.725),
  athlete(1.9);

  const ActivityLevel(this.factor);
  final double factor;
}

/// Mifflin-St Jeor: 10·kg + 6.25·cm − 5·age, +5 for men, −161 for women
/// (the midpoint, −78, when not stated).
double bmr({required String? gender, required double weightKg, required double heightCm, required int age}) {
  final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
  return base +
      switch (gender) {
        'male' => 5,
        'female' => -161,
        _ => -78,
      };
}

double tdee(double bmr, ActivityLevel activity) => bmr * activity.factor;

int _round(double v, int to) => (v / to).round() * to;

/// Calories for the goal: 20% under maintenance for fat loss (never below
/// BMR or 1,200 kcal), maintenance as is, 300 kcal over for muscle gain.
/// Rounded to 50 kcal.
int calorieTarget({required double tdee, required double bmr, required String goal}) => switch (goal) {
  'fat_loss' => _round(math.max(tdee * 0.8, math.max(bmr, 1200)), 50),
  'muscle_gain' => _round(tdee + 300, 50),
  _ => _round(tdee, 50),
};

/// Protein in g per kg body weight that each preset starts from.
double defaultProteinPerKg(String preset) => switch (preset) {
  'high_protein' => 2.0,
  'keto_light' => 1.8,
  _ => 1.6,
};

class MacroTargets {
  const MacroTargets({required this.kcal, required this.protein, required this.carbs, required this.fat});

  final int kcal;
  final int protein;
  final int carbs;
  final int fat;

  @override
  bool operator ==(Object other) =>
      other is MacroTargets &&
      other.kcal == kcal &&
      other.protein == protein &&
      other.carbs == carbs &&
      other.fat == fat;

  @override
  int get hashCode => Object.hash(kcal, protein, carbs, fat);

  @override
  String toString() => 'MacroTargets($kcal kcal, P $protein, C $carbs, F $fat)';
}

/// Splits calories into grams. Protein is g per kg of body weight (capped
/// at 40% of calories); high protein and balanced set fat at 25% / 30% of
/// calories and carbs take the rest; keto-light caps carbs at 20% and fat
/// takes the rest. Grams rounded to 5.
MacroTargets macroSplit({required int kcal, required double weightKg, required String preset, double? proteinPerKg}) {
  final perKg = proteinPerKg ?? defaultProteinPerKg(preset);
  final protein = math.min(perKg * weightKg, kcal * 0.4 / 4);
  final rest = math.max(kcal - protein * 4, 0.0);
  double carbs, fat;
  if (preset == 'keto_light') {
    carbs = math.min(kcal * 0.2 / 4, rest / 4);
    fat = (rest - carbs * 4) / 9;
  } else {
    fat = math.min(kcal * (preset == 'high_protein' ? 0.25 : 0.30) / 9, rest / 9);
    carbs = (rest - fat * 9) / 4;
  }
  return MacroTargets(kcal: kcal, protein: _round(protein, 5), carbs: _round(carbs, 5), fat: _round(fat, 5));
}

/// Whole years between [dob] and [today].
int ageOn(DateTime dob, DateTime today) {
  var age = today.year - dob.year;
  if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) age--;
  return age;
}

// ---------------------------------------------------------------------------
// Scaling templates (6.6)
// ---------------------------------------------------------------------------
/// Rounds to the food's sensible step (half a roti, one egg, 25 g), never
/// below one step.
double roundToStep(double qty, double step) {
  final r = (qty / step).round() * step;
  return double.parse(math.max(step, r).toStringAsFixed(2));
}

final _kcalInName = RegExp(r'\d[\d,]*\s*kcal');

String formatKcal(int kcal) {
  final s = kcal.toString();
  return s.length > 3 ? '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}' : s;
}

/// A copy of [t] scaled from its calorie target to [kcal]: every quantity
/// (options too) moves proportionally and is rounded to the food's step;
/// macro targets follow. The copy is unsaved (no id).
DietTemplate scaleTemplate(DietTemplate t, int kcal, FoodLookup lookup) {
  final factor = kcal / t.kcalTarget;
  int? scale(int? v) => v == null ? null : _round(v * factor, 5);
  return t.copyWith(
    id: null,
    name: _kcalInName.hasMatch(t.name) ? t.name.replaceFirst(_kcalInName, '${formatKcal(kcal)} kcal') : t.name,
    kcalTarget: kcal,
    proteinG: scale(t.proteinG),
    carbsG: scale(t.carbsG),
    fatG: scale(t.fatG),
    isStarter: false,
    isGymTemplate: true,
    sourceTemplateId: t.id,
    meals: [
      for (final m in t.meals)
        m.copyWith(
          id: null,
          items: [
            for (final i in m.items)
              i.copyWith(id: null, qty: roundToStep(i.qty * factor, foodOf(i, lookup)?.qtyStep ?? 0.5)),
          ],
        ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Preferences and conflicts (6.4)
// ---------------------------------------------------------------------------
enum ConflictKind { preference, allergy, avoid }

class FoodConflict {
  const FoodConflict(this.kind, this.detail);

  final ConflictKind kind;

  /// The preference, allergen or avoided word.
  final String detail;

  @override
  bool operator ==(Object other) => other is FoodConflict && other.kind == kind && other.detail == detail;

  @override
  int get hashCode => Object.hash(kind, detail);

  @override
  String toString() => 'FoodConflict($kind, $detail)';
}

List<FoodConflict> conflictsFor(
  Food f, {
  String? dietPref,
  List<String> allergies = const [],
  List<String> avoid = const [],
}) {
  final name = '${f.name} ${f.localName ?? ''}'.toLowerCase();
  return [
    if (dietPref != null && !fitsPreference(f, dietPref)) FoodConflict(ConflictKind.preference, dietPref),
    for (final a in allergies)
      if (f.allergens.contains(a)) FoodConflict(ConflictKind.allergy, a),
    for (final w in avoid)
      if (w.trim().isNotEmpty && name.contains(w.trim().toLowerCase())) FoodConflict(ConflictKind.avoid, w.trim()),
  ];
}

/// Conflicts per food id across a plan (meals and options).
Map<String, List<FoodConflict>> planConflicts(DietTemplate t, FoodLookup lookup, {DietFlags? member}) {
  final out = <String, List<FoodConflict>>{};
  for (final m in t.meals) {
    for (final i in m.items) {
      final f = foodOf(i, lookup);
      if (f == null || out.containsKey(f.id)) continue;
      final c = conflictsFor(
        f,
        dietPref: member?.dietPref ?? t.dietPref,
        allergies: member?.allergies ?? const [],
        avoid: member?.avoid ?? const [],
      );
      if (c.isNotEmpty) out[f.id] = c;
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// "Or" options (6.5)
// ---------------------------------------------------------------------------
/// Suggests a swap for a meal: each food is replaced by the closest food of
/// the same group (similar protein per calorie) that suits the preference,
/// sized to the same calories. Tiny items (chutney, black coffee) stay.
List<DietItem> suggestSwap(List<DietItem> main, FoodIndex index, {String? dietPref, Set<String> avoid = const {}}) {
  final used = {for (final i in main) i.foodId, ...avoid};
  final out = <DietItem>[];
  for (final (n, i) in main.indexed) {
    final f = foodOf(i, lookupIn(index));
    if (f == null) continue;
    final kcal = f.kcal * i.qty;
    if (kcal < 20) {
      out.add(i.copyWith(id: null, position: n + 1));
      continue;
    }
    final density = f.kcal == 0 ? 0.0 : f.protein / f.kcal;
    Food? closest({required bool sameGroup}) {
      Food? best;
      var bestScore = double.infinity;
      for (final c in index.all) {
        if (used.contains(c.id) || c.kcal < 20 || !fitsPreference(c, dietPref)) continue;
        if (sameGroup && c.category != f.category) continue;
        final score = ((c.protein / c.kcal) - density).abs();
        if (score < bestScore) {
          bestScore = score;
          best = c;
        }
      }
      return best;
    }

    // The same food group first; any group when none suits (paneer for a vegan).
    final pick = closest(sameGroup: true) ?? closest(sameGroup: false) ?? f;
    used.add(pick.id);
    out.add(
      DietItem(
        foodId: pick.id,
        food: pick,
        qty: roundToStep(kcal / pick.kcal, pick.qtyStep),
        altGroup: i.altGroup,
        position: n + 1,
      ),
    );
  }
  return out;
}

// ---------------------------------------------------------------------------
// Adherence (6.11), water (6.9)
// ---------------------------------------------------------------------------
DateTime _d(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// Share of due meals that were eaten (or swapped), partly counting half,
/// from [from] to [to]. Past days count every meal in the plan; today counts
/// only what's already marked. Null when nothing was due. Mirrors the
/// database's `diet_adherence`.
double? dietAdherence({
  required int mealsPerDay,
  required DateTime start,
  DateTime? end,
  required List<MealLog> logs,
  required DateTime from,
  required DateTime to,
  required DateTime today,
}) {
  final first = _d(start.isAfter(from) ? start : from);
  var last = _d(to.isBefore(today) ? to : today);
  if (end != null && end.isBefore(last)) last = _d(end);
  if (last.isBefore(first)) return null;
  final inRange = logs.where((l) => l.day != null && !l.day!.isBefore(first) && !l.day!.isAfter(last)).toList();
  final pastLast = last.isBefore(today) ? last : today.subtract(const Duration(days: 1));
  final pastDays = pastLast.isBefore(first) ? 0 : pastLast.difference(first).inDays + 1;
  final planned = mealsPerDay * pastDays + inRange.where((l) => l.day == today).length;
  if (planned == 0) return null;
  final score = inRange.fold<double>(0, (a, l) => a + l.points);
  return (math.min(score, planned.toDouble()) / planned * 100).round() / 100;
}

/// Meals due in the last 7 days (before today) that were skipped or never
/// marked.
int missedMeals({
  required int mealsPerDay,
  required DateTime start,
  required List<MealLog> logs,
  required DateTime today,
}) {
  final from = today.subtract(const Duration(days: 7));
  final first = start.isAfter(from) ? _d(start) : from;
  final days = today.difference(first).inDays;
  if (days <= 0) return 0;
  final done = logs
      .where((l) => l.day != null && !l.day!.isBefore(first) && l.day!.isBefore(today) && l.status != 'skipped')
      .length;
  return math.max(mealsPerDay * days - done, 0);
}

/// Monday of [d]'s week.
DateTime weekStart(DateTime d) => _d(d).subtract(Duration(days: d.weekday - 1));

/// Adherence for each of the last [weeks] Monday-start weeks, oldest first.
List<({DateTime week, double? adherence})> weeklyAdherence({
  required MemberDiet diet,
  required int mealsPerDay,
  required List<MealLog> logs,
  required DateTime today,
  int weeks = 8,
}) {
  final thisWeek = weekStart(today);
  return [
    for (var w = weeks - 1; w >= 0; w--)
      (
        week: thisWeek.subtract(Duration(days: 7 * w)),
        adherence: dietAdherence(
          mealsPerDay: mealsPerDay,
          start: diet.startDate!,
          end: diet.endDate,
          logs: logs,
          from: thisWeek.subtract(Duration(days: 7 * w)),
          to: thisWeek.subtract(Duration(days: 7 * w - 6)),
          today: today,
        ),
      ),
  ];
}

/// Daily water goal in 250 ml glasses: 35 ml per kg, 6 to 16 glasses; 8
/// when the weight isn't known.
int waterGoal(double? weightKg) => weightKg == null ? 8 : (weightKg * 35 / 250).round().clamp(6, 16);

// ---------------------------------------------------------------------------
// Grocery list (6.12)
// ---------------------------------------------------------------------------
class GroceryLine {
  const GroceryLine(this.item, this.qty, this.unit);

  final String item;
  final double qty;

  /// g, ml or pc.
  final String unit;

  @override
  String toString() => 'GroceryLine($item, $qty $unit)';
}

/// What to buy for [days] days of the plan as written (the meals, not the
/// options), added up by item and sorted A–Z.
List<GroceryLine> groceryList(DietTemplate t, FoodLookup lookup, {int days = 7}) {
  final totals = <String, ({String item, double qty, String unit})>{};
  for (final m in t.meals) {
    for (final i in m.main) {
      final f = foodOf(i, lookup);
      if (f == null) continue;
      final parts = f.grocery.isNotEmpty
          ? f.grocery
          : [
              GroceryPart(
                item: f.name,
                qty: f.servingG,
                unit: f.servingUnit == 'ml' || f.servingUnit == 'glass' ? 'ml' : 'g',
              ),
            ];
      for (final p in parts) {
        final key = '${p.item.toLowerCase()}|${p.unit}';
        final add = p.qty * i.qty * days;
        final cur = totals[key];
        totals[key] = (item: cur?.item ?? p.item, qty: (cur?.qty ?? 0) + add, unit: p.unit);
      }
    }
  }
  final out = [for (final v in totals.values) GroceryLine(v.item, v.qty, v.unit)]
    ..sort((a, b) => a.item.toLowerCase().compareTo(b.item.toLowerCase()));
  return out;
}

/// "1.2 kg", "350 g", "1.5 L", "14": grams over 200 g round to 50 g, below
/// to 10 g; pieces round up.
String groceryAmount(GroceryLine g) {
  String trim(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
  switch (g.unit) {
    case 'pc':
      return '${g.qty.ceil()}';
    case 'ml':
      if (g.qty >= 1000) return '${trim((g.qty / 100).round() / 10)} L';
      return '${_round(g.qty, g.qty >= 200 ? 50 : 10)} ml';
    default:
      if (g.qty >= 1000) return '${trim((g.qty / 100).round() / 10)} kg';
      return '${math.max(_round(g.qty, g.qty >= 200 ? 50 : 10), 10)} g';
  }
}
