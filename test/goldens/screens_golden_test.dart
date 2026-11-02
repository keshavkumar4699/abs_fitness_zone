@Tags(['golden'])
library;

import 'package:abs_fitness/app/app.dart';
import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:abs_fitness/features/member_home/data/my_member_repository.dart';
import 'package:abs_fitness/features/settings/data/staff_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/pump.dart';

/// Screenshots of every M0 screen in light and dark mode (spec rule 10).
/// Regenerate: flutter test --update-goldens --tags golden
void main() {
  final overrides = <Override>[
    staffRepositoryProvider.overrideWithValue(FakeStaffRepository([...sampleStaff])),
    myMemberProvider.overrideWith(
      (ref) async => const MyMember(id: 'm-1', name: 'Aarav Sharma', memberCode: 'ABS-0001', phone: '+919876543210'),
    ),
  ];

  Future<void> shot(
    WidgetTester tester,
    String name,
    Brightness brightness, {
    AppUser? user,
    String? route,
    bool onboarded = true,
    Size size = phoneSize,
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
    testWidgets(
      'staff shell desktop ${b.name}',
      (t) => shot(t, 'staff_shell_desktop', b, user: ownerUser, route: Routes.staffTeam, size: const Size(1440, 900)),
    );
  }
}
