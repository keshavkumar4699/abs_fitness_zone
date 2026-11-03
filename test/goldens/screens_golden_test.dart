@Tags(['golden'])
library;

import 'package:abs_fitness/app/app.dart';
import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:abs_fitness/features/member_home/data/my_member_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/member_fakes.dart';
import '../helpers/pump.dart';

/// Screenshots of every M0 screen in light and dark mode (spec rule 10).
/// Regenerate: flutter test --update-goldens --tags golden
void main() {
  final overrides = <Override>[myMemberProvider.overrideWith((ref) async => sampleMembers().first)];

  Future<void> shot(
    WidgetTester tester,
    String name,
    Brightness brightness, {
    AppUser? user,
    String? route,
    bool onboarded = true,
    Size size = phoneSize,
    Future<void> Function(WidgetTester tester)? interact,
  }) async {
    final container = await pumpApp(
      tester,
      user: user,
      brightness: brightness,
      size: size,
      prefs: {'member_onboarding_done': onboarded},
      overrides: overrides,
    );
    if (route != null) {
      container.read(routerProvider).go(route);
    }
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    if (interact != null) {
      await interact(tester);
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }
    await expectLater(find.byType(AbsApp), matchesGoldenFile('screens/${name}_${brightness.name}.png'));
  }

  for (final b in Brightness.values) {
    testWidgets('welcome ${b.name}', (t) => shot(t, 'welcome', b));
    testWidgets('staff login ${b.name}', (t) => shot(t, 'staff_login', b, route: Routes.staffLogin));
    testWidgets('member login ${b.name}', (t) => shot(t, 'member_login', b, route: Routes.memberLogin));
    testWidgets(
      'set password ${b.name}',
      (t) => shot(t, 'set_password', b, user: deskUser.copyWith(mustSetPassword: true)),
    );
    testWidgets(
      'member onboarding ${b.name}',
      (t) => shot(t, 'member_onboarding', b, user: memberUser, onboarded: false),
    );
    testWidgets('staff home ${b.name}', (t) => shot(t, 'staff_home', b, user: ownerUser));
    testWidgets('staff more ${b.name}', (t) => shot(t, 'staff_more', b, user: ownerUser, route: Routes.staffMore));
    testWidgets('staff team ${b.name}', (t) => shot(t, 'staff_team', b, user: ownerUser, route: Routes.staffTeam));
    testWidgets('member pin ${b.name}', (t) => shot(t, 'member_pin', b, user: deskUser, route: Routes.memberPin));
    testWidgets('member home ${b.name}', (t) => shot(t, 'member_home', b, user: memberUser));
    testWidgets(
      'member profile ${b.name}',
      (t) => shot(t, 'member_profile', b, user: memberUser, route: Routes.meProfile),
    );
    testWidgets(
      'staff shell tablet ${b.name}',
      (t) => shot(t, 'staff_shell_tablet', b, user: ownerUser, route: Routes.staffMore, size: const Size(900, 1200)),
    );
    // M1 screens.
    testWidgets(
      'members list ${b.name}',
      (t) => shot(t, 'members_list', b, user: deskUser, route: Routes.staffMembers),
    );
    testWidgets(
      'member detail ${b.name}',
      (t) => shot(t, 'member_detail', b, user: ownerUser, route: Routes.memberDetail('m-1')),
    );
    testWidgets(
      'member detail membership ${b.name}',
      (t) => shot(
        t,
        'member_detail_membership',
        b,
        user: ownerUser,
        route: Routes.memberDetail('m-1'),
        interact: (tester) async {
          await tester.tap(find.text('Membership').hitTestable());
        },
      ),
    );
    testWidgets('add member ${b.name}', (t) => shot(t, 'add_member', b, user: deskUser, route: Routes.memberNew));
    testWidgets(
      'add member membership step ${b.name}',
      (t) => shot(
        t,
        'add_member_membership',
        b,
        user: deskUser,
        route: Routes.memberNew,
        interact: (tester) async {
          await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Meera Iyer');
          await tester.enterText(find.widgetWithText(TextFormField, 'Phone number'), '9988776655');
          await tester.tap(find.text('Continue'));
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          await tester.tap(find.text('Continue'));
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          await tester.tap(find.text('Quarterly'));
        },
      ),
    );
    testWidgets('check in ${b.name}', (t) => shot(t, 'check_in', b, user: deskUser, route: Routes.checkIn));
    testWidgets(
      'check in welcome ${b.name}',
      (t) => shot(
        t,
        'check_in_welcome',
        b,
        user: deskUser,
        route: Routes.checkIn,
        interact: (tester) async {
          await tester.enterText(find.widgetWithText(TextFormField, 'Search member to check in'), 'aarav');
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          await tester.tap(find.text('Aarav Sharma'));
          await tester.pump(const Duration(milliseconds: 100));
        },
      ),
    );
    testWidgets(
      'membership plans ${b.name}',
      (t) => shot(t, 'membership_plans', b, user: ownerUser, route: Routes.membershipPlans),
    );
    testWidgets(
      'import members ${b.name}',
      (t) => shot(t, 'import_members', b, user: deskUser, route: Routes.memberImport),
    );
    testWidgets('gym profile ${b.name}', (t) => shot(t, 'gym_profile', b, user: ownerUser, route: Routes.gymProfile));
    testWidgets('my progress ${b.name}', (t) => shot(t, 'my_progress', b, user: memberUser, route: Routes.meProgress));
    testWidgets(
      'staff shell desktop ${b.name}',
      (t) => shot(t, 'staff_shell_desktop', b, user: ownerUser, route: Routes.staffTeam, size: const Size(1440, 900)),
    );
  }
}
