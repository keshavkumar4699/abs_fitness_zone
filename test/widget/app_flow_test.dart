import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/core/errors.dart';
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
  testWidgets('signed out: welcome offers only Continue with Google', (tester) async {
    await pumpApp(tester);
    await settle(tester);
    expect(find.text('Transform.'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text("I'm a member"), findsNothing);
    expect(find.text('Staff login'), findsNothing);
    expect(find.byType(TextFormField), findsNothing, reason: 'no email, password or PIN fields');
  });

  testWidgets('staff signs in with Google and lands on staff home with five tabs', (tester) async {
    final auth = FakeAuthRepository();
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text('Continue with Google'));
    await settle(tester);

    expect(auth.calls, ['google']);
    expect(find.text('Hey Keshav!'), findsOneWidget);
    for (final tab in ['Home', 'Members', 'Payments', 'Plans', 'More']) {
      expect(find.text(tab), findsWidgets, reason: tab);
    }
  });

  testWidgets('an unregistered Google account is told to ask the desk', (tester) async {
    final auth = FakeAuthRepository()..refuseWith = const NoProfileFailure();
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text('Continue with Google'));
    await settle(tester);
    expect(find.byKey(const ValueKey('sign-in-refused')), findsOneWidget);
    expect(find.textContaining("isn't registered at the gym"), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await settle(tester);
    expect(find.byKey(const ValueKey('sign-in-refused')), findsNothing);
  });

  testWidgets('switched-off staff and shared Gmails get their own explanation', (tester) async {
    final auth = FakeAuthRepository()..refuseWith = const StaffDeactivatedFailure();
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text('Continue with Google'));
    await settle(tester);
    expect(find.textContaining('turned off'), findsOneWidget);

    auth.refuseWith = const SharedEmailFailure();
    await tester.tap(find.text('Continue with Google'));
    await settle(tester);
    expect(find.textContaining('more than one member'), findsOneWidget);
    expect(find.textContaining('turned off'), findsNothing);
  });

  testWidgets('member signs in with Google, sees onboarding once, then member tabs', (tester) async {
    final auth = FakeAuthRepository()..googleResult = memberUser;
    await pumpApp(tester, auth: auth);
    await settle(tester);
    await tester.tap(find.text('Continue with Google'));
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

  testWidgets('owner adds staff by Gmail and is told how they sign in', (tester) async {
    final staff = FakeStaffRepository([...sampleStaff]);
    final container = await pumpApp(tester, user: ownerUser, staff: staff, size: const Size(390, 1400));
    await settle(tester);
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);
    await tester.tap(find.text('Add staff').last);
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Riya Sen');
    await tester.enterText(find.widgetWithText(TextFormField, 'Gmail'), 'Riya.Sen@gmail.com');
    await tester.tap(find.text('Add to team'));
    await settle(tester);
    expect(find.text('Added to the team'), findsOneWidget);
    expect(find.text('riya.sen@gmail.com'), findsWidgets);
    expect(staff.staff.last.email, 'riya.sen@gmail.com');
    await tester.tap(find.text('Done'));
    await settle(tester);
  });

  testWidgets('owner sees Staff in More and can open the roster', (tester) async {
    final container = await pumpApp(tester, user: ownerUser, staff: FakeStaffRepository([...sampleStaff]));
    await settle(tester);
    container.read(routerProvider).go(Routes.staffMore);
    await settle(tester);
    expect(find.text('Add and manage your team'), findsOneWidget);
    expect(find.text('Member PIN'), findsNothing);

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
    expect(find.text('Add and manage your team'), findsNothing);

    // Deep-linking to the owner-only page bounces back to More.
    container.read(routerProvider).go(Routes.staffTeam);
    await settle(tester);
    expect(find.text('Add and manage your team'), findsNothing);
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
