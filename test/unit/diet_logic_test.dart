import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/features/diet/data/diet_repository.dart';
import 'package:abs_fitness/features/diet/domain/diet_models.dart';
import 'package:abs_fitness/features/diet/domain/food.dart';
import 'package:abs_fitness/features/diet/domain/nutrition.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/diet_fakes.dart';

Food? _lookup(String id) => food(id);

DietItem it(String key, double qty, {int alt = 0, int pos = 1}) =>
    DietItem(foodId: key, qty: qty, altGroup: alt, position: pos, food: food(key));

void main() {
  final today = DateTime.utc(2026, 11, 3); // a Tuesday
  final foods = seedFoods();
  final index = FoodIndex(foods);

  group('the seed (6.1)', () {
    test('300 foods, calories match macros, sensible steps', () {
      expect(foods, hasLength(300));
      for (final f in foods) {
        final atwater = 4 * f.protein + 4 * f.carbs + 9 * f.fat;
        expect((atwater - f.kcal).abs(), lessThanOrEqualTo((f.kcal * 0.15).clamp(8, 1000)), reason: f.name);
        expect([0.25, 0.5, 1.0], contains(f.qtyStep), reason: f.name);
        expect(kFoodCategories, contains(f.category));
        expect(kServingUnits, contains(f.servingUnit));
        expect(f.allergens.every(kAllergens.contains), isTrue, reason: f.name);
      }
    });

    test('six starter plans within 5% of their target, foods fit the preference', () {
      final ts = starterTemplates();
      expect(ts, hasLength(6));
      for (final t in ts) {
        expect(
          (dayTotals(t, _lookup).kcal - t.kcalTarget).abs(),
          lessThanOrEqualTo(t.kcalTarget * 0.05),
          reason: t.name,
        );
        expect(planConflicts(t, _lookup), isEmpty, reason: t.name);
        for (final m in t.meals) {
          expect(m.options.length, lessThanOrEqualTo(2));
        }
      }
    });
  });

  group('totals (6.3)', () {
    final t = vegFatLoss();
    final breakfast = t.meal('breakfast')!;

    test('meal, option and day totals', () {
      expect(mealTotals(breakfast, _lookup).kcal, 310);
      expect(mealTotals(breakfast, _lookup, group: 1).kcal, 255);
      expect(dayTotals(t, _lookup).kcal, closeTo(1486.5, 0.01));
      expect(dayTotals(t, _lookup).protein, closeTo(80.5, 0.01));
    });

    test('a mark counts like the database: eaten, partly, swapped, skipped', () {
      expect(markedMacros(breakfast, 'eaten', null, _lookup).kcal, 310);
      expect(markedMacros(breakfast, 'partly', null, _lookup).kcal, 155);
      expect(markedMacros(breakfast, 'swapped', 1, _lookup).kcal, 255);
      expect(markedMacros(breakfast, 'skipped', null, _lookup), Macros.zero);
    });

    test('meals come in the order of the day; payload groups options', () {
      final shuffled = t.copyWith(meals: t.meals.reversed.toList());
      expect(shuffled.orderedMeals.map((m) => m.slot).first, 'early_morning');
      final p = t.toPayload();
      final lunch = (p['meals'] as List).firstWhere((m) => m['meal_slot'] == 'lunch') as Map;
      expect([for (final i in lunch['items'] as List) i['alt_group']], [0, 0, 0, 0, 1, 1, 1, 1]);
      expect(lunch['time_of_day'], '13:30');
    });
  });

  group('targets calculator (6.2)', () {
    test('Mifflin-St Jeor BMR', () {
      expect(bmr(gender: 'male', weightKg: 80, heightCm: 180, age: 30), 1780);
      expect(bmr(gender: 'female', weightKg: 60, heightCm: 165, age: 28), 1330.25);
      expect(bmr(gender: null, weightKg: 70, heightCm: 170, age: 40), 10 * 70 + 6.25 * 170 - 200 - 78);
    });

    test('TDEE and the goal', () {
      final b = bmr(gender: 'male', weightKg: 80, heightCm: 180, age: 30);
      final t = tdee(b, ActivityLevel.moderate);
      expect(t, closeTo(2759, 0.1));
      expect(calorieTarget(tdee: t, bmr: b, goal: 'fat_loss'), 2200);
      expect(calorieTarget(tdee: t, bmr: b, goal: 'maintenance'), 2750);
      expect(calorieTarget(tdee: t, bmr: b, goal: 'muscle_gain'), 3050);
    });

    test('a deficit never goes below BMR or 1,200 kcal', () {
      final b = bmr(gender: 'female', weightKg: 45, heightCm: 150, age: 50);
      expect(calorieTarget(tdee: tdee(b, ActivityLevel.sedentary), bmr: b, goal: 'fat_loss'), 1200);
    });

    test('macro presets with protein per kg', () {
      expect(
        macroSplit(kcal: 2200, weightKg: 80, preset: 'high_protein'),
        const MacroTargets(kcal: 2200, protein: 160, carbs: 255, fat: 60),
      );
      expect(
        macroSplit(kcal: 2000, weightKg: 70, preset: 'balanced'),
        const MacroTargets(kcal: 2000, protein: 110, carbs: 240, fat: 65),
      );
      expect(
        macroSplit(kcal: 2000, weightKg: 70, preset: 'keto_light'),
        const MacroTargets(kcal: 2000, protein: 125, carbs: 100, fat: 120),
      );
      expect(macroSplit(kcal: 2000, weightKg: 70, preset: 'balanced', proteinPerKg: 2.2).protein, 155);
    });

    test('protein is capped at 40% of calories', () {
      expect(macroSplit(kcal: 1500, weightKg: 120, preset: 'high_protein', proteinPerKg: 3).protein, 150);
    });

    test('age from date of birth', () {
      expect(ageOn(DateTime.utc(1996, 11, 4), today), 29);
      expect(ageOn(DateTime.utc(1996, 11, 3), today), 30);
    });
  });

  group('scaling templates (6.6)', () {
    final base = DietTemplate(
      id: 'tpl',
      name: 'Veg balanced 1,800 kcal',
      kcalTarget: 1800,
      proteinG: 90,
      carbsG: 220,
      fatG: 60,
      isStarter: true,
      meals: [
        DietMeal(
          id: 'm1',
          slot: 'lunch',
          items: [it('roti', 2), it('paneer', 1, pos: 2), it('boiled-egg', 2, pos: 3), it('toor-dal', 1, pos: 4)],
        ),
        DietMeal(id: 'm2', slot: 'dinner', items: [it('ghee', 1), it('white-rice', 1, alt: 1)]),
      ],
    );

    test('1,800 → 2,200 kcal: proportional, rounded to half roti and 25 g', () {
      final s = scaleTemplate(base, 2200, _lookup);
      final lunch = s.meal('lunch')!;
      expect(lunch.main.map((i) => i.qty), [2.5, 1.25, 2, 1.0]);
      expect(food('paneer').servingG * lunch.main[1].qty, 125); // grams, in 25 g steps
      expect(s.kcalTarget, 2200);
      expect(s.name, 'Veg balanced 2,200 kcal');
      expect([s.proteinG, s.carbsG, s.fatG], [110, 270, 75]);
      expect(s.id, isNull);
      expect(s.sourceTemplateId, 'tpl');
      expect(s.isStarter, isFalse);
      expect(s.meal('dinner')!.group(1).single.qty, 1.0); // options scale too
    });

    test('scaling down never drops below one step', () {
      final s = scaleTemplate(base, 900, _lookup);
      expect(s.meal('dinner')!.main.single.qty, 0.5); // ghee: half a teaspoon
      expect(s.meal('lunch')!.main[2].qty, 1); // eggs stay whole
    });

    test('roundToStep', () {
      expect(roundToStep(2.44, 0.5), 2.5);
      expect(roundToStep(2.2, 0.5), 2.0);
      expect(roundToStep(1.13, 0.25), 1.25);
      expect(roundToStep(0.1, 0.5), 0.5);
      expect(roundToStep(2.4, 1), 2);
    });
  });

  group('preferences and conflicts (6.4)', () {
    test('which foods suit which preference', () {
      expect(fitsPreference(food('chicken-curry'), 'veg'), isFalse);
      expect(fitsPreference(food('boiled-egg'), 'veg'), isFalse);
      expect(fitsPreference(food('boiled-egg'), 'eggetarian'), isTrue);
      expect(fitsPreference(food('paneer'), 'vegan'), isFalse);
      expect(fitsPreference(food('tofu'), 'vegan'), isTrue);
      expect(fitsPreference(food('aloo-paratha'), 'jain'), isFalse); // potato
      expect(fitsPreference(food('honey'), 'jain'), isFalse);
      expect(fitsPreference(food('moong-dal'), 'jain'), isTrue);
      expect(fitsPreference(food('fish-curry'), 'non_veg'), isTrue);
    });

    test('preference, allergies and foods to avoid', () {
      expect(conflictsFor(food('chicken-curry'), dietPref: 'veg'), [
        const FoodConflict(ConflictKind.preference, 'veg'),
      ]);
      expect(conflictsFor(food('poha'), allergies: ['peanut', 'dairy']), [
        const FoodConflict(ConflictKind.allergy, 'peanut'),
      ]);
      expect(conflictsFor(food('palak-paneer'), avoid: [' Paneer ']), [
        const FoodConflict(ConflictKind.avoid, 'Paneer'),
      ]);
      expect(conflictsFor(food('palak-paneer'), avoid: ['पालक']), hasLength(1)); // Hindi too
      expect(conflictsFor(food('roti'), dietPref: 'veg', allergies: ['dairy']), isEmpty);
    });

    test('a member\'s flags win over the plan\'s preference', () {
      final plan = vegFatLoss();
      const aarav = DietFlags(memberId: 'm-1', dietPref: 'vegan', allergies: ['dairy']);
      final c = planConflicts(plan, _lookup, member: aarav);
      expect(c.keys, contains('low-fat-paneer'));
      expect(c['curd'], isNotNull); // options are checked too
      expect(c.values.expand((x) => x).map((x) => x.kind).toSet(), {ConflictKind.preference, ConflictKind.allergy});
    });
  });

  group('"or" options (6.5)', () {
    test('a swap uses the same food groups at similar calories', () {
      final main = [it('moong-chilla', 2), it('green-chutney', 1, pos: 2)];
      final swap = suggestSwap(main, index, dietPref: 'veg');
      expect(swap, hasLength(2));
      final first = food(swap.first.foodId);
      expect(first.id, isNot('moong-chilla'));
      expect(first.category, 'pulses');
      expect(fitsPreference(first, 'veg'), isTrue);
      final kcal = first.kcal * swap.first.qty;
      expect(kcal, inInclusiveRange(300 * 0.6, 300 * 1.4));
      expect(swap[1].foodId, 'green-chutney'); // tiny items stay
    });

    test('respects the preference', () {
      final swap = suggestSwap([it('paneer', 1)], index, dietPref: 'vegan');
      expect(fitsPreference(food(swap.single.foodId), 'vegan'), isTrue);
    });
  });

  group('adherence (6.11), like the database example', () {
    // 7 meals a day from two days ago: day 1 all eaten; day 2 three eaten,
    // two partly, one swapped, one skipped; today two eaten → 14 of 16.
    MealLog l(DateTime day, String slot, String status) =>
        MealLog(memberId: 'm', day: day, slot: slot, status: status, altGroup: status == 'swapped' ? 1 : null);
    final d1 = today.subtract(const Duration(days: 2)), d2 = today.subtract(const Duration(days: 1));
    const slots = ['early_morning', 'breakfast', 'mid_morning', 'lunch', 'evening_snack', 'dinner', 'bedtime'];
    final logs = [
      for (final s in slots) l(d1, s, 'eaten'),
      l(d2, 'early_morning', 'eaten'),
      l(d2, 'breakfast', 'eaten'),
      l(d2, 'mid_morning', 'eaten'),
      l(d2, 'lunch', 'partly'),
      l(d2, 'evening_snack', 'partly'),
      l(d2, 'dinner', 'swapped'),
      l(d2, 'bedtime', 'skipped'),
      l(today, 'early_morning', 'eaten'),
      l(today, 'breakfast', 'eaten'),
    ];

    test('the last 7 days', () {
      expect(
        dietAdherence(
          mealsPerDay: 7,
          start: d1,
          logs: logs,
          from: today.subtract(const Duration(days: 6)),
          to: today,
          today: today,
        ),
        0.88,
      );
    });

    test('missed meals: skipped or never marked, before today', () {
      expect(missedMeals(mealsPerDay: 7, start: d1, logs: logs, today: today), 1);
      expect(missedMeals(mealsPerDay: 7, start: today, logs: logs, today: today), 0);
    });

    test('nothing due yet is null, not 0%', () {
      expect(dietAdherence(mealsPerDay: 7, start: today, logs: const [], from: today, to: today, today: today), isNull);
    });

    test('an ended plan stops counting', () {
      expect(dietAdherence(mealsPerDay: 7, start: d1, end: d1, logs: logs, from: d1, to: today, today: today), 1.0);
    });

    test('week by week, Monday first', () {
      final diet = MemberDiet(id: 'd', memberId: 'm', templateId: 't', name: 'x', startDate: d1);
      final w = weeklyAdherence(diet: diet, mealsPerDay: 7, logs: logs, today: today);
      expect(w, hasLength(8));
      expect(w.last.week, DateTime.utc(2026, 11, 2));
      expect(w.last.adherence, closeTo(7 / 9, 0.01)); // Mon 2 Nov + today
      expect(w[6].adherence, 1.0); // Sun 1 Nov only
      expect(w.first.adherence, isNull);
    });
  });

  group('water (6.9)', () {
    test('35 ml per kg in 250 ml glasses, 6 to 16', () {
      expect(waterGoal(70), 10);
      expect(waterGoal(null), 8);
      expect(waterGoal(40), 6);
      expect(waterGoal(150), 16);
    });
  });

  group('grocery list (6.12)', () {
    final t = DietTemplate(
      name: 'x',
      meals: [
        DietMeal(slot: 'breakfast', items: [it('boiled-egg', 2), it('toned-milk', 0.5, pos: 2)]),
        DietMeal(slot: 'lunch', items: [it('roti', 2), it('toor-dal', 1, pos: 2), it('white-rice', 1, alt: 1)]),
        DietMeal(slot: 'dinner', items: [it('roti', 1), it('paneer', 1, pos: 2)]),
      ],
    );

    test('a week of the plan, added up by item (options left out)', () {
      final g = groceryList(t, _lookup);
      final byItem = {for (final x in g) x.item: groceryAmount(x)};
      expect(byItem['Whole wheat atta'], '650 g'); // 3 roti × 30 g × 7 = 630 g
      expect(byItem['Toor dal'], '250 g');
      expect(byItem['Eggs'], '14');
      expect(byItem['Milk'], '900 ml');
      expect(byItem['Paneer'], '700 g');
      expect(byItem.containsKey('Rice'), isFalse);
      expect(
        g.map((x) => x.item).toList(),
        [...g.map((x) => x.item)]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
      );
    });

    test('amounts read naturally', () {
      expect(groceryAmount(const GroceryLine('Rice', 1234, 'g')), '1.2 kg');
      expect(groceryAmount(const GroceryLine('Rice', 2000, 'g')), '2 kg');
      expect(groceryAmount(const GroceryLine('Ghee', 35, 'g')), '40 g');
      expect(groceryAmount(const GroceryLine('Milk', 1750, 'ml')), '1.8 L');
      expect(groceryAmount(const GroceryLine('Bananas', 6.5, 'pc')), '7');
    });
  });

  group('food search', () {
    test('ranks names that start with the query first', () {
      final r = index.query(search: 'dal');
      expect(r.first.name.toLowerCase(), startsWith('dal'));
      expect(r.map((f) => f.id), containsAll(['toor-dal', 'moong-dal', 'dal-makhani']));
    });

    test('Hindi names, groups and preferences', () {
      expect(index.query(search: 'रोटी').map((f) => f.id), contains('roti'));
      expect(index.query(category: 'eggs').every((f) => f.category == 'eggs'), isTrue);
      expect(index.query(dietPref: 'vegan').every((f) => f.vegType == 'vegan'), isTrue);
      expect(index.query(unreviewedOnly: true), hasLength(300));
    });

    test('is instant on 300 foods', () {
      final sw = Stopwatch()..start();
      for (var i = 0; i < 20; i++) {
        index.query(search: 'pan');
      }
      expect(sw.elapsedMilliseconds / 20, lessThan(16));
    });

    test('removed foods hide from search but still resolve for old plans', () {
      final x = FoodIndex([food('roti').copyWith(archivedAt: today), food('naan')]);
      expect(x.all.map((f) => f.id), ['naan']);
      expect(x['roti'], isNotNull);
    });
  });

  group('outbox', () {
    test('the last tap wins; uploads in order; stops offline; drops refusals', () async {
      SharedPreferences.setMockInitialValues({});
      final box = DietOutbox(await SharedPreferences.getInstance());
      await box.put(DietOutbox.meal(today, 'lunch', 'eaten', null));
      await box.put(DietOutbox.meal(today, 'lunch', 'partly', null));
      await box.put(DietOutbox.water(today, 3));
      expect(box.pending(), hasLength(2));

      final repo = FakeDietRepository()..offline = true;
      await box.flush(repo);
      expect(box.pending(), hasLength(2));

      repo.offline = false;
      final out = await box.flush(repo);
      expect(box.pending(), isEmpty);
      expect(out[DietOutbox.mealKey(today, 'lunch')]!.status, 'partly');
      expect(repo.calls, ['meal:2026-11-03:lunch:partly', 'water:2026-11-03:3']);

      await box.put(DietOutbox.meal(today, 'brunch', 'eaten', null)); // not in the plan
      await box.flush(repo);
      expect(box.pending(), isEmpty);
    });

    test('a failing server keeps marks queued', () async {
      SharedPreferences.setMockInitialValues({});
      final box = DietOutbox(await SharedPreferences.getInstance());
      await box.put(DietOutbox.supplement(today, 'Creatine', taken: true));
      final repo = FakeDietRepository()..offline = true;
      expect(await box.flush(repo), isEmpty);
      expect(box.pending().single['name'], 'Creatine');
      await expectLater(repo.diets('m-1'), throwsA(isA<NetworkFailure>()));
    });
  });
}
