import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:abs_fitness/features/settings/data/staff_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/pump.dart';

Future<void> settle(WidgetTester tester, [int frames = 10]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('owner turns a trainer off and back on', (tester) async {
    final repo = FakeStaffRepository([...sampleStaff]);
    final container = await pumpApp(
      tester,
      user: ownerUser,
      overrides: [staffRepositoryProvider.overrideWithValue(repo)],
    );
    await settle(tester);
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);

    await tester.tap(find.text('Vikram Rao'));
    await settle(tester);
    await tester.tap(find.text('Turn off access'));
    await settle(tester);
    expect(repo.staff.firstWhere((s) => s.id == '3').isActive, isFalse);
    expect(find.text('Inactive'), findsNWidgets(2));

    await tester.tap(find.text('Vikram Rao'));
    await settle(tester);
    await tester.tap(find.text('Turn access back on'));
    await settle(tester);
    expect(repo.staff.firstWhere((s) => s.id == '3').isActive, isTrue);
  });

  testWidgets('the owner account cannot be switched off', (tester) async {
    final container = await pumpApp(
      tester,
      user: ownerUser,
      overrides: [
        staffRepositoryProvider.overrideWithValue(FakeStaffRepository([...sampleStaff])),
      ],
    );
    await settle(tester);
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);
    await tester.tap(find.text('Keshav Kumar'));
    await settle(tester);
    expect(find.text('The owner account is always on.'), findsOneWidget);
    expect(find.text('Turn off access'), findsNothing);
  });

  testWidgets('long rosters scroll and load the next page of 30', (tester) async {
    final many = [
      for (var i = 0; i < 45; i++)
        StaffMember(
          id: 's$i',
          name: 'Trainer ${i.toString().padLeft(2, '0')}',
          email: 't$i@abs.in',
          role: UserRole.trainer,
          isActive: true,
        ),
    ];
    final container = await pumpApp(
      tester,
      user: ownerUser,
      overrides: [staffRepositoryProvider.overrideWithValue(FakeStaffRepository(many))],
    );
    await settle(tester);
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);
    expect(find.text('Trainer 00'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Trainer 44'), 400, scrollable: find.byType(Scrollable).first);
    await settle(tester);
    expect(find.text('Trainer 44'), findsOneWidget);
  });

  testWidgets('unknown links show a friendly page with a way home', (tester) async {
    final container = await pumpApp(tester, user: ownerUser);
    await settle(tester);
    container.read(routerProvider).go('/no/such/page');
    await settle(tester);
    expect(find.text('Lost your way?'), findsOneWidget);
    await tester.tap(find.text('Go home'));
    await settle(tester);
    expect(find.text('Hey Keshav!'), findsOneWidget);
  });

  testWidgets('Android back on another tab returns to Home instead of exiting', (tester) async {
    final container = await pumpApp(tester, user: deskUser);
    await settle(tester);
    container.read(routerProvider).go(Routes.staffPayments);
    await settle(tester);
    expect(container.read(routerProvider).state.matchedLocation, Routes.staffPayments);

    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(container.read(routerProvider).state.matchedLocation, Routes.staffHome);
  });

  testWidgets('trainers see their own home, not the owner checklist', (tester) async {
    await pumpApp(tester, user: trainerUser);
    await settle(tester);
    expect(find.text('Hey Vikram!'), findsOneWidget);
    expect(find.text('Invite your team'), findsNothing);
    expect(find.text('Your assigned members, sessions and plans will show up here.'), findsOneWidget);
  });

  testWidgets('front desk checklist links to Member PIN', (tester) async {
    final container = await pumpApp(tester, user: deskUser);
    await settle(tester);
    expect(find.text('Invite your team'), findsNothing);
    await tester.tap(find.text('Give members app access'));
    await settle(tester);
    expect(container.read(routerProvider).state.matchedLocation, Routes.memberPin);
    expect(find.text('Find member'), findsOneWidget);
  });
}
