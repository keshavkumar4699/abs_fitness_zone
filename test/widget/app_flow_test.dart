import 'package:abs_fitness/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/pump.dart';

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('signed out: welcome offers member and staff login', (tester) async {
    await pumpApp(tester);
    await settle(tester);
    expect(find.text('Transform.'), findsOneWidget);
    expect(find.text("I'm a member"), findsOneWidget);
    expect(find.text('Staff login'), findsOneWidget);
  });

  testWidgets('staff signs in and lands on staff home with five tabs', (tester) async {
    final auth = FakeAuthRepository();
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text('Staff login'));
    await settle(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'owner@absfitness.in');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret-pass');
    await tester.tap(find.text('Sign in'));
    await settle(tester);

    expect(auth.calls, contains('staff:owner@absfitness.in'));
    expect(find.text('Hey Keshav!'), findsOneWidget);
    for (final tab in ['Home', 'Members', 'Payments', 'Plans', 'More']) {
      expect(find.text(tab), findsWidgets, reason: tab);
    }
  });

  testWidgets('staff login validates before calling the server', (tester) async {
    final auth = FakeAuthRepository();
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text('Staff login'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'not-an-email');
    await tester.tap(find.text('Sign in'));
    await settle(tester);
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(auth.calls, isEmpty);
  });

  testWidgets('wrong member PIN shows attempts left', (tester) async {
    final auth = FakeAuthRepository()..nextError = const InvalidPinFailureForTest(2);
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text("I'm a member"));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone number'), '9876543210');
    await tester.enterText(find.widgetWithText(TextFormField, '4-digit PIN'), '1234');
    await tester.tap(find.text('Sign in'));
    await settle(tester);
    expect(auth.calls, ['member:9876543210:1234']);
    expect(find.textContaining('2 attempts left'), findsOneWidget);
  });

  testWidgets('member signs in, sees onboarding once, then member tabs', (tester) async {
    final auth = FakeAuthRepository();
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text("I'm a member"));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone number'), '9876543210');
    await tester.enterText(find.widgetWithText(TextFormField, '4-digit PIN'), '4321');
    await tester.tap(find.text('Sign in'));
    await settle(tester);

    expect(find.text('Your membership, at a glance'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text("Let's go"));
    await settle(tester);

    for (final tab in ['Home', 'Workout', 'Diet', 'Progress', 'Profile']) {
      expect(find.text(tab), findsWidgets, reason: tab);
    }
  });

  testWidgets('new staff must set a password before anything else', (tester) async {
    final auth = FakeAuthRepository(deskUser.copyWith(mustSetPassword: true));
    await pumpApp(tester, auth: auth);
    await settle(tester);
    expect(find.text('Set your password'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'New password'), 'short');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm password'), 'short');
    await tester.tap(find.text('Save password'));
    await settle(tester);
    expect(find.text('Use at least 8 characters'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'New password'), 'long-enough-1');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm password'), 'long-enough-1');
    await tester.tap(find.text('Save password'));
    await settle(tester);
    expect(auth.calls, contains('password'));
    expect(find.text('Hey Neha!'), findsOneWidget);
  });

  testWidgets('owner sees Staff in More and can open the roster', (tester) async {
    final container = await pumpApp(tester, user: ownerUser, staff: FakeStaffRepository([...sampleStaff]));
    await settle(tester);
    container.read(routerProvider).go(Routes.staffMore);
    await settle(tester);
    expect(find.text('Invite and manage your team'), findsOneWidget);
    expect(find.text('Set or reset a member\'s app PIN'), findsOneWidget);

    await tester.tap(find.text('Staff').last);
    await settle(tester);
    expect(find.text('Neha Singh'), findsOneWidget);
    expect(find.text('Vikram Rao'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'vik');
    await settle(tester);
    expect(find.text('Vikram Rao'), findsOneWidget);
    expect(find.text('Neha Singh'), findsNothing);
  });

  testWidgets('front desk does not see staff management', (tester) async {
    final container = await pumpApp(tester, user: deskUser);
    await settle(tester);
    container.read(routerProvider).go(Routes.staffMore);
    await settle(tester);
    expect(find.text('Invite and manage your team'), findsNothing);
    expect(find.text('Set or reset a member\'s app PIN'), findsOneWidget);

    // Deep-linking to the owner-only page bounces back to More.
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);
    expect(find.text('Invite and manage your team'), findsNothing);
    expect(container.read(routerProvider).state.matchedLocation, Routes.staffMore);
  });

  testWidgets('roster shows error state with a working retry', (tester) async {
    final repo = FakeStaffRepository([...sampleStaff])..error = networkDown;
    final container = await pumpApp(tester, user: ownerUser, staff: repo);
    await settle(tester);
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);
    expect(find.text('No connection. Check your internet and try again.'), findsOneWidget);

    repo.error = null;
    await tester.tap(find.text('Try again'));
    await settle(tester);
    expect(find.text('Neha Singh'), findsOneWidget);
  });

  testWidgets('sign out returns to welcome', (tester) async {
    final container = await pumpApp(tester, user: trainerUser);
    await settle(tester);
    container.read(routerProvider).go(Routes.staffMore);
    await settle(tester);
    await tester.ensureVisible(find.text('Sign out'));
    await tester.tap(find.text('Sign out'));
    await settle(tester);
    expect(find.text('Transform.'), findsOneWidget);
  });
}
