import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/member_home/data/my_member_repository.dart';
import 'package:abs_fitness/features/members/domain/models.dart';
import 'package:abs_fitness/features/workouts/presentation/workout_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/diet_fakes.dart';
import '../helpers/fakes.dart';
import '../helpers/member_fakes.dart';
import '../helpers/payment_fakes.dart';
import '../helpers/pump.dart';
import '../helpers/workout_fakes.dart';

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
  testWidgets('desk ends a visit from the attendance tab (optional check-out)', (tester) async {
    final members = seededMembers();
    final c = await pumpApp(tester, user: deskUser, members: members, size: tall);
    await go(tester, c, '${Routes.memberDetail('m-1')}?tab=attendance');
    await tester.tap(find.byKey(const ValueKey('mark-present')));
    await settle(tester);
    expect(find.text('Marked present'), findsOneWidget);
    // Once checked in, the same spot offers to end the visit.
    expect(find.byKey(const ValueKey('mark-present')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('check-out')));
    await settle(tester);
    expect(members.checkOuts, ['m-1']);
    expect(find.text('Checked out · 3 h 0 min'), findsOneWidget);
    expect(vis('In 7:00 am · out 10:00 am'), findsOneWidget);
    expect(find.byKey(const ValueKey('check-out')), findsNothing);
  });

  testWidgets('member checks out from home after checking in', (tester) async {
    final members = seededMembers();
    members.checkIns['m-1'] = [
      Attendance(
        id: 'a-today',
        memberId: 'm-1',
        day: fakeToday,
        checkedInAt: DateTime.utc(2026, 11, 3, 1, 30),
        method: 'qr',
      ),
    ];
    await pumpApp(
      tester,
      user: memberUser,
      members: members,
      size: tall,
      prefs: {'member_onboarding_done': true},
      overrides: [myMemberProvider.overrideWith((ref) async => sampleMembers().first)],
    );
    await settle(tester);
    expect(find.text('Checked in at 7:00 am'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('me-check-out')));
    await settle(tester);
    expect(members.checkOuts, ['m-1']);
    expect(find.text('Checked out · 3 h 0 min'), findsOneWidget);
    expect(find.byKey(const ValueKey('visit-done')), findsOneWidget);
    expect(find.text('Today: in 7:00 am · out 10:00 am'), findsOneWidget);
  });

  testWidgets('member replies to the coach on a logged workout (words, no reactions)', (tester) async {
    final w = FakeWorkoutsRepository();
    final c = await pumpApp(
      tester,
      user: memberUser,
      workouts: w,
      size: tall,
      prefs: {'member_onboarding_done': true},
      overrides: [myMemberProvider.overrideWith((ref) async => sampleMembers().first)],
    );
    await go(tester, c, Routes.meWorkout);
    final legs = find.descendant(of: find.byType(WorkoutLogCard), matching: find.text('Legs'));
    await tester.scrollUntilVisible(legs, 300, scrollable: find.byType(Scrollable).last);
    await tester.tap(legs);
    await settle(tester);
    expect(find.text('Solid squats!'), findsOneWidget);
    expect(find.byKey(const ValueKey('react-clap')), findsNothing, reason: 'reactions are for coaches');
    await tester.enterText(find.byKey(const ValueKey('comment-field')), 'Thanks coach!');
    await tester.tap(find.byKey(const ValueKey('comment-send')));
    await settle(tester);
    expect(w.calls, contains('comment:log-3:Thanks coach!:'));
    expect(find.text('Thanks coach!'), findsWidgets);
  });

  testWidgets('trainer edits what to buy for a food', (tester) async {
    final diet = FakeDietRepository();
    final c = await pumpApp(tester, user: trainerUser, diet: diet, size: tall);
    await go(tester, c, Routes.foodEdit('paneer'));
    final before = diet.foodList.firstWhere((f) => f.id == 'paneer').grocery.length;
    await tester.ensureVisible(find.byKey(const ValueKey('grocery-add')));
    await tester.tap(find.byKey(const ValueKey('grocery-add')));
    await settle(tester, 4);
    await tester.enterText(find.byKey(ValueKey('grocery-item-$before')), 'Milk');
    await tester.enterText(find.byKey(ValueKey('grocery-qty-$before')), '200');
    await tester.tap(find.text('ml').last);
    await settle(tester, 4);
    await tester.ensureVisible(find.byKey(const ValueKey('food-save')));
    await tester.tap(find.byKey(const ValueKey('food-save')));
    await settle(tester);
    final saved = diet.foodList.firstWhere((f) => f.id == 'paneer');
    expect(saved.grocery.length, before + 1);
    expect(saved.grocery.last.item, 'Milk');
    expect(saved.grocery.last.qty, 200);
    expect(saved.grocery.last.unit, 'ml');
  });

  testWidgets('desk raises an ad-hoc invoice from the member page', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: deskUser, payments: pay, size: tall);
    await go(tester, c, '${Routes.memberDetail('m-1')}?tab=payments');
    await tester.tap(find.byKey(const ValueKey('new-invoice')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('invoice-desc-0')), 'Protein shake');
    await tester.enterText(find.byKey(const ValueKey('invoice-amount-0')), '250');
    await settle(tester, 2);
    await tester.tap(find.byKey(const ValueKey('invoice-qty-plus-0')));
    await settle(tester, 2);
    expect(find.text('Raise invoice · ₹500'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('invoice-create')));
    await tester.tap(find.byKey(const ValueKey('invoice-create')));
    await settle(tester);
    expect(pay.store.last.memberId, 'm-1');
    expect(pay.store.last.subtotalPaise, 50000);
    expect(find.text('Invoice raised'), findsOneWidget);
  });
}
