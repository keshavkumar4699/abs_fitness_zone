import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/workouts/application/workouts_providers.dart';
import 'package:abs_fitness/features/workouts/data/workouts_repository.dart';
import 'package:abs_fitness/features/workouts/presentation/my_workout_screen.dart' show MyWorkoutScreen;
import 'package:abs_fitness/features/workouts/presentation/workout_ui.dart' show WorkoutLogCard;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/workout_fakes.dart';
import '../helpers/pump.dart';

Future<void> settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

const tall = Size(390, 1800);

Finder vis(String text) => find.text(text).hitTestable();

Future<void> go(WidgetTester tester, dynamic container, String route) async {
  container.read(routerProvider).go(route);
  await settle(tester);
}

void main() {
  testWidgets('library: search, body map, favourites (4.2, 4.3, 4.6)', (tester) async {
    final ex = FakeExerciseRepository();
    final c = await pumpApp(tester, user: trainerUser, exercises: ex, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPlans);
    await tester.tap(vis('Exercises'));
    await settle(tester);
    expect(find.text('Search 876 exercises'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('exercise-search')), 'barbell squat');
    await settle(tester, 6);
    expect(vis('Barbell Squat'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('exercise-search')), '');
    await settle(tester, 6);
    await tester.tap(find.bySemanticsLabel('Chest').first);
    await settle(tester, 6);
    expect(find.text('Chest'), findsWidgets);
    expect(vis('Barbell Squat'), findsNothing, reason: 'squats are not a chest exercise');

    await tester.tap(vis('All muscles'));
    await tester.tap(vis('Favourites'));
    await settle(tester, 6);
    expect(vis('Barbell Squat'), findsOneWidget, reason: 'the only starred exercise');
    await tester.tap(find.byTooltip('Remove from favourites').first);
    await settle(tester, 6);
    expect(ex.calls, contains('fav:Barbell_Squat:false'));
    expect(vis('No favourites yet'), findsOneWidget);
  });

  testWidgets('exercise detail: steps, muscles, alternatives and own progress (4.4, 5.8)', (tester) async {
    final c = await pumpApp(tester, user: memberUser, prefs: {'member_onboarding_done': true}, size: tall);
    await settle(tester);
    await go(tester, c, Routes.meExercise('Barbell_Squat'));
    expect(find.byKey(const ValueKey('exercise-progress')), findsOneWidget);
    expect(find.text('45 kg'), findsOneWidget, reason: 'best set last Saturday');
    expect(find.text('Muscles worked'), findsOneWidget);
    expect(find.text('How to do it'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Alternatives'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Alternatives'), findsOneWidget);
  });

  testWidgets('trainer adds a custom exercise; desk cannot (4.5)', (tester) async {
    final ex = FakeExerciseRepository();
    final c = await pumpApp(tester, user: trainerUser, exercises: ex, size: tall);
    await settle(tester);
    await go(tester, c, Routes.exerciseNew);
    await tester.enterText(find.byKey(const ValueKey('exercise-name')), 'ABS band walk');
    await tester.tap(find.byKey(const ValueKey('exercise-save')));
    await settle(tester);
    expect(find.text('Pick at least one main muscle.'), findsOneWidget);
    await tester.tap(vis('Glutes').first);
    await tester.tap(find.byKey(const ValueKey('exercise-save')));
    await settle(tester);
    expect(ex.calls, contains('custom:ABS band walk'));
    expect(ex.exercises.last.primaryMuscles, ['glutes']);
  });

  testWidgets('desk can browse but not add exercises or programs', (tester) async {
    final desk = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, desk, Routes.exerciseNew);
    expect(desk.read(routerProvider).state.matchedLocation, Routes.staffPlans);
    expect(vis('My members'), findsNothing);
    expect(vis('Programs'), findsOneWidget);
    expect(find.byKey(const ValueKey('new-exercise')), findsNothing);
    expect(find.byKey(const ValueKey('new-program')), findsNothing);
    await go(tester, desk, Routes.programNew);
    expect(desk.read(routerProvider).state.matchedLocation, Routes.staffPlans);
  });

  testWidgets('builder: new program from the library with a superset (5.1)', (tester) async {
    final w = FakeWorkoutsRepository();
    final c = await pumpApp(tester, user: trainerUser, workouts: w, size: tall);
    await settle(tester);
    await go(tester, c, Routes.programNew);
    await tester.tap(find.byKey(const ValueKey('builder-save')));
    await settle(tester);
    expect(find.text('Give the program a name.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('builder-name')), 'Vikram full body');
    await tester.tap(find.byKey(const ValueKey('builder-add-exercises')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('exercise-search')).last, 'plank');
    await settle(tester, 6);
    await tester.tap(vis('Plank'));
    await tester.enterText(find.byKey(const ValueKey('exercise-search')).last, 'pushups');
    await settle(tester, 6);
    await tester.tap(vis('Pushups'));
    await tester.pump();
    expect(find.text('Add 2 exercises'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('picker-add')));
    await settle(tester);
    expect(vis('Plank'), findsOneWidget);
    expect(find.text('3 × 30 s · rest 45 s'), findsOneWidget, reason: 'timed defaults for a plank');

    await tester.tap(vis('Pushups'));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('item-sets')), '4');
    await tester.tap(vis('Superset A'));
    await tester.tap(find.byKey(const ValueKey('item-done')));
    await settle(tester);
    expect(find.textContaining('4 × 12'), findsOneWidget);
    expect(find.text('Superset A'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('builder-save')));
    await settle(tester);
    expect(w.calls, contains('save:Vikram full body:1'));
    expect(w.library.last.days.single.items.last.groupKey, 'A');
  });

  testWidgets('owner duplicates a starter and assigns it (5.3, 5.4)', (tester) async {
    final w = FakeWorkoutsRepository();
    final c = await pumpApp(tester, user: ownerUser, workouts: w, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPlans);
    await tester.tap(vis('Programs'));
    await settle(tester);
    expect(vis('Push / Pull / Legs'), findsOneWidget);
    expect(vis('Starter'), findsWidgets);
    await tester.tap(vis('Push / Pull / Legs'));
    await settle(tester);
    expect(find.text('Push'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('template-assign')));
    await settle(tester);
    expect(find.text('Assign "Push / Pull / Legs"'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('assign-member-m-2')));
    await tester.tap(vis('Wed').first);
    await tester.pump();
    expect(find.text('Pick 3 days'), findsOneWidget, reason: '4 weekdays for a 3-day program');
    await tester.tap(vis('Wed').first);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('assign-confirm')));
    await settle(tester);
    expect(w.calls, contains('assign:tpl-ppl:m-2:replace:135'));
    expect(w.programsByMember['m-2']!.single.name, 'Push / Pull / Legs');

    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.text('Duplicate').last);
    await settle(tester);
    expect(w.calls, contains('duplicate:tpl-ppl'));
    expect(find.text('Edit program'), findsOneWidget);
  });

  testWidgets('member detail Workouts: program, calendar, logs and a reaction (5.10, 5.11)', (tester) async {
    final w = FakeWorkoutsRepository();
    final c = await pumpApp(tester, user: ownerUser, workouts: w, size: tall);
    await settle(tester);
    await go(tester, c, '${Routes.memberDetail('m-1')}?tab=workouts');
    expect(find.byKey(const ValueKey('program-summary')), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.byKey(const ValueKey('plan-calendar')), findsOneWidget);
    final legsLog = find.descendant(of: find.byType(WorkoutLogCard), matching: find.text('Legs'));
    await tester.scrollUntilVisible(legsLog, 300, scrollable: find.byType(Scrollable).last);
    await tester.tap(legsLog);
    await settle(tester);
    expect(find.text('Solid squats!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('react-clap')));
    await settle(tester);
    expect(w.calls, contains('comment:log-3::clap'));
    await settle(tester, 50);
  });

  testWidgets('desk sees a member\'s program but not their workout logs', (tester) async {
    final desk = await pumpApp(tester, user: deskUser, workouts: FakeWorkoutsRepository(), size: tall);
    await settle(tester);
    await go(tester, desk, '${Routes.memberDetail('m-1')}?tab=workouts');
    expect(find.byKey(const ValueKey('program-summary')), findsOneWidget);
    expect(find.byKey(const ValueKey('plan-calendar')), findsNothing, reason: 'workout logs are for coaches');
    expect(find.byKey(const ValueKey('tune-program')), findsNothing);
  });

  testWidgets('player: prefill, rest timer, PR and celebration (5.6, 5.7, 5.9)', (tester) async {
    final w = FakeWorkoutsRepository();
    final alerts = RecordingRestAlerts();
    final c = await pumpApp(
      tester,
      user: memberUser,
      workouts: w,
      restAlerts: alerts,
      prefs: {'member_onboarding_done': true},
      size: tall,
    );
    await settle(tester);
    await go(tester, c, Routes.meWorkout);
    expect(find.text('Today: Push'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('start-workout')).hitTestable());
    await settle(tester);
    expect(find.text('Barbell Bench Press - Medium Grip'), findsOneWidget);
    expect(find.text('40 kg'), findsWidgets, reason: 'prefilled from last Tuesday');
    expect(find.textContaining('Next: Dumbbell Shoulder Press'), findsOneWidget);

    await tester.tap(find.byTooltip('+ kg').first);
    await tester.pump();
    expect(find.text('42.5 kg'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tick-0-0')));
    await settle(tester, 4);
    expect(find.byKey(const ValueKey('rest-card')), findsOneWidget);
    expect(alerts.scheduled, hasLength(1), reason: 'an alert for when the phone is locked');
    await tester.tap(find.byKey(const ValueKey('rest-skip')));
    await settle(tester, 4);
    expect(find.byKey(const ValueKey('rest-card')), findsNothing);
    expect(alerts.cancels, 1);

    await tester.tap(find.byKey(const ValueKey('player-finish')));
    await settle(tester, 4);
    expect(find.text('1 of 12 sets done. It is saved as a partial workout.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('finish-anyway')));
    await settle(tester, 20);
    expect(find.byKey(const ValueKey('workout-summary')), findsOneWidget);
    expect(find.text('New personal records'), findsOneWidget);
    expect(find.textContaining('Heaviest'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    final sent = w.saved.single;
    expect(sent['status'], 'partial');
    expect((sent['sets'] as List<dynamic>).single, containsPair('weight', 42.5));
    expect(c.read(workoutOutboxProvider).pending(), isEmpty);
    expect(c.read(activeWorkoutProvider), isNull);

    await tester.tap(find.byKey(const ValueKey('summary-done')));
    await settle(tester);
    expect(find.text('Done for today. Great work!'), findsWidgets);
  });

  testWidgets('a finished workout can be fixed for 24 hours (5.7)', (tester) async {
    final w = FakeWorkoutsRepository();
    final c = await pumpApp(tester, user: memberUser, workouts: w, prefs: {'member_onboarding_done': true}, size: tall);
    await settle(tester);
    await go(tester, c, Routes.meWorkout);
    await tester.tap(find.byKey(const ValueKey('start-workout')).hitTestable());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('tick-0-0')));
    await settle(tester, 2);
    await tester.tap(find.byKey(const ValueKey('player-finish')));
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('finish-anyway')));
    await settle(tester, 20);
    await tester.tap(find.byKey(const ValueKey('summary-done')));
    await settle(tester);
    final clientId = w.saved.single['client_id'];

    final today = find.descendant(of: find.byType(WorkoutLogCard), matching: find.textContaining('3 Nov 2026'));
    await tester.scrollUntilVisible(
      today,
      300,
      scrollable: find.descendant(of: find.byType(MyWorkoutScreen), matching: find.byType(Scrollable)).first,
    );
    await tester.tap(today.first);
    await settle(tester);
    expect(find.byKey(const ValueKey('edit-workout')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('edit-workout')));
    await settle(tester);
    await tester.tap(find.byTooltip('+ reps').first);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('player-finish')));
    await settle(tester, 20);
    expect(w.saved, hasLength(2));
    expect(w.saved.last['client_id'], clientId, reason: 'the same workout is replaced, not duplicated');
    expect(w.saved.last['finished_at'], w.saved.first['finished_at'], reason: 'edits keep the original times');
    expect((w.saved.last['sets'] as List<dynamic>).single, containsPair('reps', 9));
  });

  testWidgets('player works offline and uploads later; leaving keeps the session', (tester) async {
    final w = FakeWorkoutsRepository();
    final c = await pumpApp(tester, user: memberUser, workouts: w, prefs: {'member_onboarding_done': true}, size: tall);
    await settle(tester);
    await go(tester, c, Routes.meWorkout);
    await tester.tap(find.byKey(const ValueKey('start-workout')).hitTestable());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('tick-0-0')));
    await settle(tester, 4);

    // Leave for later: the session stays on the phone.
    await tester.tap(find.byKey(const ValueKey('player-close')));
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('exit-keep')));
    await settle(tester);
    expect(find.byKey(const ValueKey('resume-workout')).hitTestable(), findsOneWidget);
    expect(find.text('1 of 12 sets done'), findsWidgets);

    w.offline = true;
    await tester.tap(find.byKey(const ValueKey('resume-workout')).hitTestable());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('player-finish')));
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('finish-anyway')));
    await settle(tester, 20);
    expect(find.text('Saved on this phone. It uploads when you are back online.'), findsOneWidget);
    expect(c.read(workoutOutboxProvider).pending(), hasLength(1));

    w.offline = false;
    expect(await c.read(workoutOutboxProvider).flush(w), hasLength(1));
    expect(c.read(workoutOutboxProvider).pending(), isEmpty);
    expect(w.saved, hasLength(1));
  });

  testWidgets('coaches: My members with adherence and Training today on home (5.5)', (tester) async {
    final c = await pumpApp(tester, user: trainerUser, size: tall);
    await settle(tester);
    expect(find.byKey(const ValueKey('training-today')), findsOneWidget);
    expect(find.text('Training today'), findsOneWidget);
    expect(find.text('2 missed this week'), findsOneWidget);

    await go(tester, c, Routes.staffPlans);
    expect(vis('My members'), findsOneWidget);
    expect(vis('Aarav Sharma'), findsOneWidget);
    expect(vis('75%'), findsOneWidget);
    expect(vis('No program'), findsOneWidget);
    await tester.tap(vis('Aarav Sharma'));
    await settle(tester);
    expect(c.read(routerProvider).state.uri.toString(), '${Routes.memberDetail('m-1')}?tab=workouts');
  });

  testWidgets('member without a program sees a friendly empty state', (tester) async {
    final w = FakeWorkoutsRepository(programs: {}, logs: []);
    final c = await pumpApp(tester, user: memberUser, workouts: w, prefs: {'member_onboarding_done': true}, size: tall);
    await settle(tester);
    await go(tester, c, Routes.meWorkout);
    expect(find.text('No program yet'), findsWidgets);
    expect(find.text('No workouts yet'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('open-library')));
    await settle(tester);
    expect(c.read(routerProvider).state.matchedLocation, Routes.meExercises);
    expect(find.text('Exercises'), findsOneWidget);
  });

  test('assign modes are sent as replace / queue', () {
    expect(AssignMode.replace.name, 'replace');
    expect(AssignMode.queue.name, 'queue');
  });
}
