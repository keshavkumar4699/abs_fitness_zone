import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/diet/data/diet_repository.dart';
import 'package:abs_fitness/features/diet/domain/diet_models.dart';
import 'package:abs_fitness/features/diet/presentation/diet_builder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/diet_fakes.dart';
import '../helpers/fakes.dart';
import '../helpers/pump.dart';

Future<void> settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

const tall = Size(390, 2400);

Finder vis(String text) => find.text(text).hitTestable();

Future<void> go(WidgetTester tester, dynamic container, String route) async {
  container.read(routerProvider).go(route);
  await settle(tester);
}

Future<void> openDiet(WidgetTester tester, [String? tab]) async {
  await tester.tap(find.descendant(of: find.byKey(const ValueKey('training-area')), matching: find.text('Diet')));
  await settle(tester, 6);
  if (tab != null) {
    await tester.tap(vis(tab));
    await settle(tester, 6);
  }
}

String ringKcal(WidgetTester tester, [String key = 'total-kcal']) =>
    (tester.widget<Text>(find.byKey(ValueKey(key)).first)).data!;

/// Scrolls the builder until [target] is built, then fully into view.
Future<void> scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    300,
    scrollable: find.descendant(of: find.byType(DietBuilderScreen), matching: find.byType(Scrollable)).first,
  );
  await tester.ensureVisible(target);
  await tester.pump();
}

void main() {
  const member = {'member_onboarding_done': true};

  testWidgets('member: today\'s timeline, mark a meal, rings fill (6.8)', (tester) async {
    final diet = FakeDietRepository();
    await pumpApp(tester, user: memberUser, prefs: member, diet: diet, size: tall);
    await settle(tester);
    await tester.tap(vis('Diet'));
    await settle(tester);
    expect(vis('Veg fat loss 1,500 kcal'), findsWidgets);
    expect(vis('2 of 7 meals marked'), findsOneWidget);
    expect(ringKcal(tester), '388');
    expect(find.byKey(const ValueKey('diet-disclaimer')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('timeline-lunch')));
    await settle(tester, 6);
    expect(vis('Or option 1 · 433 kcal'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('mark-eaten')));
    await settle(tester, 6);
    expect(diet.calls, contains('meal:2026-11-03:lunch:eaten'));
    expect(vis('3 of 7 meals marked'), findsOneWidget);
    expect(ringKcal(tester), '836', reason: '388 + lunch 448');
  });

  testWidgets('member: swap to an option, then clear it', (tester) async {
    final diet = FakeDietRepository();
    await pumpApp(tester, user: memberUser, prefs: member, diet: diet, size: tall);
    await settle(tester);
    await tester.tap(vis('Diet'));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('timeline-dinner')));
    await settle(tester, 6);
    await tester.tap(find.byKey(const ValueKey('mark-swapped1')));
    await settle(tester, 6);
    expect(diet.calls, contains('meal:2026-11-03:dinner:swapped:1'));
    expect(ringKcal(tester), '766', reason: '388 + the dinner option 378');

    await tester.tap(find.byKey(const ValueKey('timeline-dinner')));
    await settle(tester, 6);
    await tester.tap(find.byKey(const ValueKey('mark-clear')));
    await settle(tester, 6);
    expect(diet.calls, contains('meal:2026-11-03:dinner:null'));
    expect(ringKcal(tester), '388');
  });

  testWidgets('member: yesterday can still be filled in; water and supplements (6.9)', (tester) async {
    final diet = FakeDietRepository();
    await pumpApp(tester, user: memberUser, prefs: member, diet: diet, size: tall);
    await settle(tester);
    await tester.tap(vis('Diet'));
    await settle(tester);
    expect(find.text('4 of 8 glasses'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('water-plus')));
    await settle(tester, 6);
    expect(find.text('5 of 8 glasses'), findsOneWidget);
    expect(diet.calls, contains('water:2026-11-03:5'));
    await tester.tap(find.byKey(const ValueKey('supp-Multivitamin')));
    await settle(tester, 6);
    expect(diet.calls, contains('supp:2026-11-03:Multivitamin:true'));

    await tester.tap(find.byKey(const ValueKey('diet-day-1')));
    await settle(tester, 6);
    expect(vis('7 of 7 meals marked'), findsOneWidget);
    expect(find.text('7 of 8 glasses'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('timeline-bedtime')));
    await settle(tester, 6);
    await tester.tap(find.byKey(const ValueKey('mark-eaten')));
    await settle(tester, 6);
    expect(diet.calls, contains('meal:2026-11-02:bedtime:eaten'));
  });

  testWidgets('member: marks made offline stick and upload later', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: memberUser, prefs: member, diet: diet, size: tall);
    await settle(tester);
    await tester.tap(vis('Diet'));
    await settle(tester);
    diet.offline = true;
    await tester.tap(find.byKey(const ValueKey('timeline-mid_morning')));
    await settle(tester, 6);
    await tester.tap(find.byKey(const ValueKey('mark-eaten')));
    await settle(tester, 6);
    expect(vis('3 of 7 meals marked'), findsOneWidget, reason: 'shown at once');
    final outbox = c.read(dietOutboxProvider);
    expect(outbox.pending().single['slot'], 'mid_morning');
    expect(diet.calls.where((x) => x.startsWith('meal:')), isEmpty);

    diet.offline = false;
    await outbox.flush(diet);
    expect(outbox.pending(), isEmpty);
    expect(diet.calls, contains('meal:2026-11-03:mid_morning:eaten'));
  });

  testWidgets('member: meal reminders at the plan\'s times (6.10)', (tester) async {
    final reminders = RecordingMealReminders();
    await pumpApp(tester, user: memberUser, prefs: member, mealReminders: reminders, size: tall);
    await settle(tester);
    await tester.tap(vis('Diet'));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('meal-reminders')));
    await settle(tester, 6);
    expect(reminders.scheduled, hasLength(7));
    expect(reminders.scheduled.first.minutes, 6 * 60 + 30);
    expect(reminders.scheduled.first.title, 'Time for Early morning');
    expect(reminders.channelName, 'Meal reminders');
    expect((await SharedPreferences.getInstance()).getBool('meal_reminders_on'), isTrue);
    await tester.tap(find.byKey(const ValueKey('meal-reminders')));
    await settle(tester, 6);
    expect(reminders.cancels, 1);
  });

  testWidgets('member: weekly grocery list (6.12) and own preferences (6.4)', (tester) async {
    final diet = FakeDietRepository();
    await pumpApp(tester, user: memberUser, prefs: member, diet: diet, size: tall);
    await settle(tester);
    await tester.tap(vis('Diet'));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('open-grocery')));
    await settle(tester, 6);
    expect(find.byKey(const ValueKey('grocery-Low-fat paneer')), findsOneWidget);
    expect(find.text('700 g'), findsWidgets);
    expect(find.byKey(const ValueKey('grocery-share')), findsOneWidget);
    await tester.tapAt(const Offset(195, 40));
    await settle(tester, 6);

    await tester.tap(find.byKey(const ValueKey('my-preferences')));
    await settle(tester, 6);
    await tester.tap(vis('Gluten'));
    await tester.enterText(find.byKey(const ValueKey('prefs-avoid')), 'mushroom, brinjal');
    await tester.tap(find.byKey(const ValueKey('prefs-save')));
    await settle(tester, 6);
    expect(diet.calls, contains('prefs:m-1:veg:gluten+peanut:mushroom+brinjal'));
  });

  testWidgets('member without a plan still tracks water', (tester) async {
    await pumpApp(tester, user: memberUser, prefs: member, diet: FakeDietRepository(withAarav: false), size: tall);
    await settle(tester);
    expect(find.byKey(const ValueKey('today-diet')), findsNothing);
    await tester.tap(vis('Diet'));
    await settle(tester);
    expect(vis('No diet plan yet'), findsOneWidget);
    expect(find.byKey(const ValueKey('water-card')), findsOneWidget);
  });

  testWidgets('member home: today\'s meals card', (tester) async {
    await pumpApp(tester, user: memberUser, prefs: member, size: tall);
    await settle(tester);
    expect(find.byKey(const ValueKey('today-diet')), findsOneWidget);
    expect(find.text('Next: Mid-morning at 11:00'), findsOneWidget);
  });

  testWidgets('coach: nutrition overview → member Diet tab with chart and a note (6.11)', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: ownerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPlans);
    await openDiet(tester);
    expect(find.byKey(const ValueKey('diet-member-m-1')), findsOneWidget);
    expect(vis('91%'), findsOneWidget);
    expect(vis('1 missed meal'), findsOneWidget);
    expect(vis('Health condition'), findsOneWidget, reason: 'Priya has one');

    await tester.tap(find.byKey(const ValueKey('diet-member-m-1')));
    await settle(tester);
    expect(find.byKey(const ValueKey('diet-summary')), findsOneWidget);
    expect(find.text('Allergic to Peanuts'), findsOneWidget);
    expect(find.byKey(const ValueKey('adherence-chart')), findsOneWidget);
    expect(find.byKey(const ValueKey('timeline-breakfast')), findsOneWidget);
    expect(find.text('Great start! Add a glass of water before each meal.'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('diet-comment')), 'Swap the chai for green tea');
    await tester.tap(find.byKey(const ValueKey('diet-comment-send')));
    await settle(tester, 6);
    expect(diet.calls, contains('comment:m-1:Swap the chai for green tea'));
    expect(find.text('Swap the chai for green tea'), findsOneWidget);
  });

  testWidgets('desk: browses plans and foods, never members\' diets', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPlans);
    await openDiet(tester);
    expect(vis('My members'), findsNothing);
    expect(find.byKey(const ValueKey('diet-template-dt-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('new-diet')), findsNothing);
    await tester.tap(vis('Foods'));
    await settle(tester, 6);
    expect(find.byKey(const ValueKey('food-unreviewed')), findsNothing);
    expect(find.byKey(const ValueKey('new-food')), findsNothing);

    await go(tester, c, '${Routes.memberDetail('m-1')}?tab=diet');
    expect(
      find.text('Diet plans and logs are private: only the member\'s trainer and the owner can see them.'),
      findsOneWidget,
    );
    await go(tester, c, Routes.dietNew);
    expect(find.byType(DietBuilderScreen), findsNothing, reason: 'the router sends the desk back');
  });

  testWidgets('duplicate and scale a template from 1,500 to 1,800 kcal (6.6)', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: trainerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, Routes.dietDetail('dt-1'));
    expect(find.byKey(const ValueKey('diet-disclaimer')), findsOneWidget);
    expect(find.byKey(const ValueKey('diet-edit')), findsNothing, reason: 'a starter: only the owner edits it');
    await tester.tap(find.byKey(const ValueKey('diet-duplicate')));
    await settle(tester, 4);
    await tester.enterText(find.byType(TextField).last, '1800');
    await tester.tap(vis('Done'));
    await settle(tester);
    expect(find.byType(DietBuilderScreen), findsOneWidget);
    expect(find.text('Veg fat loss 1,800 kcal'), findsOneWidget);
    // Roti 1.5 → 1.8 → 2 rotis; low-fat paneer 100 g → 120 g → 125 g.
    await scrollTo(tester, find.byKey(const ValueKey('qty-lunch-0-0')));
    expect(
      find.descendant(of: find.byKey(const ValueKey('qty-lunch-0-0')), matching: find.text('2 rotis')),
      findsOneWidget,
    );
    await scrollTo(tester, find.byKey(const ValueKey('qty-dinner-0-0')));
    expect(
      find.descendant(of: find.byKey(const ValueKey('qty-dinner-0-0')), matching: find.text('125 g')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('diet-builder-save')));
    await settle(tester);
    expect(diet.calls, contains('save:Veg fat loss 1,800 kcal'));
    expect(diet.templateList.last.kcalTarget, 1800);
    expect(diet.templateList.last.sourceTemplateId, 'dt-1');
  });

  testWidgets('builder: add foods, totals update within one frame, save (6.3)', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: trainerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPlans);
    await openDiet(tester, 'Diet plans');
    await tester.tap(find.byKey(const ValueKey('new-diet')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('diet-builder-name')), 'Quick cut');
    for (final slot in ['lunch', 'evening_snack', 'dinner']) {
      await scrollTo(tester, find.byKey(ValueKey('remove-meal-$slot')));
      await tester.tap(find.byKey(ValueKey('remove-meal-$slot')));
      await settle(tester, 2);
    }
    await scrollTo(tester, find.byKey(const ValueKey('add-food-breakfast')));
    await tester.tap(find.byKey(const ValueKey('add-food-breakfast')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('food-search')), 'boiled egg');
    await settle(tester, 6);
    await tester.tap(find.byKey(const ValueKey('food-row-boiled-egg')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('food-picker-done')));
    await settle(tester);
    expect(ringKcal(tester), '78');

    await scrollTo(tester, find.byKey(const ValueKey('plus-breakfast-0-0')));
    await tester.tap(find.byKey(const ValueKey('plus-breakfast-0-0')));
    await tester.pump();
    expect(ringKcal(tester), '156', reason: 'one frame after the tap');
    expect(
      find.descendant(of: find.byKey(const ValueKey('qty-breakfast-0-0')), matching: find.text('2 pieces')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('suggest-option-breakfast')));
    await settle(tester, 2);
    expect(find.textContaining('Or option 1'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('diet-builder-save')));
    await settle(tester);
    expect(diet.calls, contains('save:Quick cut'));
    final saved = diet.templateList.firstWhere((t) => t.name == 'Quick cut');
    expect(saved.meals.single.main.single.qty, 2);
    expect(saved.meals.single.options, [1]);
  });

  testWidgets('builder: flags a member with a health condition (F6 acceptance)', (tester) async {
    final diet = FakeDietRepository();
    diet.dietsByMember['m-2'] = [
      aaravDiet().copyWith(
        id: 'md-priya',
        memberId: 'm-2',
        templateId: 'snap-priya',
        template: aaravDiet().template!.copyWith(id: 'snap-priya'),
      ),
    ];
    final c = await pumpApp(tester, user: ownerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, '${Routes.dietEdit('snap-priya')}?member=m-2');
    expect(find.byKey(const ValueKey('medical-flag')), findsOneWidget);
    expect(find.text('Thyroid'), findsOneWidget);
    expect(find.byKey(const ValueKey('builder-conflicts')), findsNothing);
  });

  testWidgets('builder: warns when a food clashes with the member\'s preferences (6.4)', (tester) async {
    final c = await pumpApp(tester, user: ownerUser, size: tall);
    await settle(tester);
    await go(tester, c, '${Routes.dietEdit('snap-aarav')}?member=m-1');
    expect(find.byKey(const ValueKey('medical-flag')), findsNothing);
    expect(find.byKey(const ValueKey('builder-conflicts')), findsNothing);
    await scrollTo(tester, find.byKey(const ValueKey('add-food-lunch')));
    await tester.tap(find.byKey(const ValueKey('add-food-lunch')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('food-suits')));
    await tester.enterText(find.byKey(const ValueKey('food-search')), 'poha');
    await settle(tester, 6);
    expect(find.text('Contains Peanuts'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('food-row-poha')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('food-picker-done')));
    await settle(tester);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('builder-conflicts')),
      -300,
      scrollable: find.descendant(of: find.byType(DietBuilderScreen), matching: find.byType(Scrollable)).first,
    );
    expect(find.text('1 food doesn\'t suit Aarav Sharma'), findsOneWidget);
  });

  testWidgets('targets calculator fills the plan\'s targets (6.2)', (tester) async {
    final c = await pumpApp(tester, user: ownerUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.dietEdit('dt-1'));
    await tester.tap(find.byKey(const ValueKey('open-calculator')));
    await settle(tester);
    await tester.tap(vis('Male'));
    await tester.enterText(find.byKey(const ValueKey('targets-age')), '30');
    await tester.enterText(find.byKey(const ValueKey('targets-height')), '180');
    await tester.enterText(find.byKey(const ValueKey('targets-weight')), '80');
    await settle(tester, 2);
    expect(find.text('BMR 1,780 kcal · maintenance 2,759 kcal'), findsOneWidget);
    expect(find.text('2,200 kcal'), findsOneWidget);
    expect(find.text('P 160 g · C 255 g · F 60 g'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('targets-use')));
    await settle(tester);
    expect(find.descendant(of: find.byKey(const ValueKey('target-kcal')), matching: find.text('2200')), findsOneWidget);
    expect(
      find.descendant(of: find.byKey(const ValueKey('target-protein')), matching: find.text('160')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('scale-to-target')), findsOneWidget, reason: 'planned 1,487 vs 2,200');
  });

  testWidgets('assign from a template: health warning, then assign (6.7)', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: ownerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, Routes.dietDetail('dt-4'));
    await tester.tap(find.byKey(const ValueKey('diet-assign')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('assign-diet-member-m-2')));
    await settle(tester, 4);
    expect(find.byKey(const ValueKey('assign-flag-health-m-2')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('assign-diet-member-m-1')));
    await settle(tester, 4);
    expect(find.byKey(const ValueKey('assign-flag-foods-m-1')), findsOneWidget, reason: 'non-veg plan, veg member');
    await tester.tap(find.byKey(const ValueKey('assign-diet-confirm')));
    await settle(tester);
    expect(diet.calls, contains('assign:dt-4:m-2,m-1:2026-11-03'));
    expect(diet.dietsByMember['m-1']!.first.status, DietStatus.active);
    expect(diet.dietsByMember['m-1']![1].status, DietStatus.replaced);
  });

  testWidgets('foods: search, review, and a custom food with a calorie check (6.1)', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: trainerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPlans);
    await openDiet(tester, 'Foods');
    expect(find.text('Not reviewed (300)'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('food-search')), 'पनीर');
    await settle(tester, 6);
    expect(find.byKey(const ValueKey('food-row-paneer')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('food-row-paneer')));
    await settle(tester, 6);
    await tester.tap(find.byKey(const ValueKey('food-mark-reviewed')));
    await settle(tester, 6);
    expect(diet.calls, contains('review:paneer'));
    await tester.tapAt(const Offset(195, 40));
    await settle(tester, 50); // the snackbar clears
    expect(find.text('Not reviewed (299)'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('new-food')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('food-name')), 'Sattu paratha');
    await tester.enterText(find.byKey(const ValueKey('food-grams')), '100');
    await tester.enterText(find.byKey(const ValueKey('food-kcal')), '500');
    await tester.enterText(find.byKey(const ValueKey('food-protein')), '10');
    await tester.enterText(find.byKey(const ValueKey('food-carbs')), '38');
    await tester.enterText(find.byKey(const ValueKey('food-fat')), '7.5');
    await settle(tester, 2);
    expect(find.byKey(const ValueKey('food-mismatch')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('food-kcal')), '260');
    await settle(tester, 2);
    expect(find.byKey(const ValueKey('food-mismatch')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('food-save')));
    await settle(tester);
    expect(diet.calls, contains('food:Sattu paratha'));
    expect(diet.foodList.last.servingG, 100);
    expect(diet.foodList.last.isCustom, isTrue);
  });

  testWidgets('coach ends a member\'s plan; history keeps it', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: ownerUser, diet: diet, size: tall);
    await settle(tester);
    await go(tester, c, '${Routes.memberDetail('m-1')}?tab=diet');
    await tester.ensureVisible(find.byKey(const ValueKey('end-diet')));
    await tester.tap(find.byKey(const ValueKey('end-diet')));
    await settle(tester, 4);
    await tester.tap(find.text('End plan').last);
    await settle(tester);
    expect(diet.calls, contains('end:md-aarav'));
    expect(vis('No diet plan yet'), findsOneWidget);
    expect(find.text('Earlier plans'), findsOneWidget);
  });
}
