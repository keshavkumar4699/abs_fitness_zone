@Tags(['golden'])
library;

import 'package:abs_fitness/app/app.dart';
import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:abs_fitness/features/member_home/data/my_member_repository.dart';
import 'package:abs_fitness/features/members/domain/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/member_fakes.dart';
import '../helpers/pump.dart';

/// Screenshots of every screen in light and dark mode (spec rule 10).
/// Regenerate: flutter test --update-goldens --tags golden
void main() {
  List<Override> overridesFor(Member me) => [myMemberProvider.overrideWith((ref) async => me)];
  final sneha = sampleMembers()[3];
  final snehaUser = memberUser.copyWith(memberId: sneha.id, name: sneha.name);

  Future<void> shot(
    WidgetTester tester,
    String name,
    Brightness brightness, {
    AppUser? user,
    String? route,
    bool onboarded = true,
    Size size = phoneSize,
    Member? me,
    FakeAuthRepository? auth,
    Future<void> Function(WidgetTester tester)? interact,
  }) async {
    final container = await pumpApp(
      tester,
      user: user,
      auth: auth,
      brightness: brightness,
      size: size,
      prefs: {'member_onboarding_done': onboarded},
      overrides: overridesFor(me ?? sampleMembers().first),
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
    testWidgets(
      'welcome refused ${b.name}',
      (t) => shot(
        t,
        'welcome_refused',
        b,
        interact: (tester) => tester.tap(find.text('Continue with Google')),
        auth: FakeAuthRepository()..refuseWith = const NoProfileFailure(),
      ),
    );
    testWidgets(
      'member onboarding ${b.name}',
      (t) => shot(t, 'member_onboarding', b, user: memberUser, onboarded: false),
    );
    testWidgets('staff home ${b.name}', (t) => shot(t, 'staff_home', b, user: ownerUser));
    testWidgets('staff more ${b.name}', (t) => shot(t, 'staff_more', b, user: ownerUser, route: Routes.staffMore));
    testWidgets('staff team ${b.name}', (t) => shot(t, 'staff_team', b, user: ownerUser, route: Routes.staffTeam));
    testWidgets(
      'staff team add ${b.name}',
      (t) => shot(
        t,
        'staff_team_add',
        b,
        user: ownerUser,
        route: Routes.staffTeam,
        interact: (tester) => tester.tap(find.text('Add staff').last),
      ),
    );
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
    // M2 screens.
    testWidgets('payments ${b.name}', (t) => shot(t, 'payments', b, user: deskUser, route: Routes.staffPayments));
    testWidgets(
      'payments overdue ${b.name}',
      (t) => shot(
        t,
        'payments_overdue',
        b,
        user: ownerUser,
        route: Routes.staffPayments,
        interact: (tester) => tester.tap(find.text('Overdue 2').hitTestable()),
      ),
    );
    testWidgets(
      'collect sheet ${b.name}',
      (t) => shot(
        t,
        'collect_sheet',
        b,
        user: deskUser,
        route: Routes.invoiceDetail('inv-2'),
        interact: (tester) => tester.tap(find.byKey(const ValueKey('invoice-collect'))),
      ),
    );
    testWidgets(
      'collect done ${b.name}',
      (t) => shot(
        t,
        'collect_done',
        b,
        user: deskUser,
        route: Routes.invoiceDetail('inv-2'),
        interact: (tester) async {
          await tester.tap(find.byKey(const ValueKey('invoice-collect')));
          for (var i = 0; i < 8; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          await tester.tap(find.byKey(const ValueKey('collect-confirm')));
          for (var i = 0; i < 20; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
        },
      ),
    );
    testWidgets(
      'invoice detail ${b.name}',
      (t) => shot(t, 'invoice_detail', b, user: ownerUser, route: Routes.invoiceDetail('inv-2')),
    );
    testWidgets('day close ${b.name}', (t) => shot(t, 'day_close', b, user: deskUser, route: Routes.dayClose));
    testWidgets('expenses ${b.name}', (t) => shot(t, 'expenses', b, user: ownerUser, route: Routes.expenses));
    testWidgets(
      'payment history ${b.name}',
      (t) => shot(t, 'payment_history', b, user: deskUser, route: Routes.paymentHistory),
    );
    testWidgets(
      'member detail payments ${b.name}',
      (t) => shot(
        t,
        'member_detail_payments',
        b,
        user: ownerUser,
        route: Routes.memberDetail('m-2'),
        interact: (tester) => tester.tap(find.text('Payments').hitTestable()),
      ),
    );
    testWidgets('member home dues ${b.name}', (t) => shot(t, 'member_home_dues', b, user: snehaUser, me: sneha));
    testWidgets(
      'my payments ${b.name}',
      (t) => shot(t, 'my_payments', b, user: snehaUser, me: sneha, route: Routes.mePayments),
    );
    testWidgets(
      'member pay ${b.name}',
      (t) => shot(t, 'member_pay', b, user: snehaUser, me: sneha, route: Routes.mePay('inv-4')),
    );
    // M3 screens.
    Future<void> frames(WidgetTester tester, [int n = 8]) async {
      for (var i = 0; i < n; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets(
      'training members ${b.name}',
      (t) => shot(t, 'training_members', b, user: ownerUser, route: Routes.staffPlans),
    );
    testWidgets(
      'training programs ${b.name}',
      (t) => shot(
        t,
        'training_programs',
        b,
        user: ownerUser,
        route: Routes.staffPlans,
        interact: (tester) => tester.tap(find.text('Programs').hitTestable()),
      ),
    );
    testWidgets(
      'exercise library ${b.name}',
      (t) => shot(
        t,
        'exercise_library',
        b,
        user: trainerUser,
        route: Routes.staffPlans,
        interact: (tester) async {
          await tester.tap(find.text('Exercises').hitTestable());
          await frames(tester);
          await tester.tap(find.bySemanticsLabel('Chest').first);
        },
      ),
    );
    testWidgets(
      'exercise detail ${b.name}',
      (t) => shot(t, 'exercise_detail', b, user: trainerUser, route: Routes.exerciseDetail('Barbell_Squat')),
    );
    testWidgets(
      'custom exercise ${b.name}',
      (t) => shot(t, 'custom_exercise', b, user: trainerUser, route: Routes.exerciseNew),
    );
    testWidgets(
      'template detail ${b.name}',
      (t) => shot(t, 'template_detail', b, user: ownerUser, route: Routes.programDetail('tpl-ppl')),
    );
    testWidgets(
      'program builder ${b.name}',
      (t) => shot(t, 'program_builder', b, user: ownerUser, route: Routes.programEdit('tpl-ppl')),
    );
    testWidgets(
      'assign program ${b.name}',
      (t) => shot(
        t,
        'assign_program',
        b,
        user: ownerUser,
        route: Routes.programDetail('tpl-ppl'),
        interact: (tester) => tester.tap(find.byKey(const ValueKey('template-assign'))),
      ),
    );
    testWidgets(
      'member detail workouts ${b.name}',
      (t) => shot(t, 'member_detail_workouts', b, user: ownerUser, route: '${Routes.memberDetail('m-1')}?tab=workouts'),
    );
    testWidgets('my workout ${b.name}', (t) => shot(t, 'my_workout', b, user: memberUser, route: Routes.meWorkout));
    testWidgets(
      'workout player ${b.name}',
      (t) => shot(
        t,
        'workout_player',
        b,
        user: memberUser,
        route: Routes.meWorkout,
        interact: (tester) => tester.tap(find.byKey(const ValueKey('start-workout')).hitTestable()),
      ),
    );
    testWidgets(
      'workout rest ${b.name}',
      (t) => shot(
        t,
        'workout_rest',
        b,
        user: memberUser,
        route: Routes.meWorkout,
        interact: (tester) async {
          await tester.tap(find.byKey(const ValueKey('start-workout')).hitTestable());
          await frames(tester, 12);
          await tester.tap(find.byKey(const ValueKey('tick-0-0')));
        },
      ),
    );
    testWidgets(
      'workout summary ${b.name}',
      (t) => shot(
        t,
        'workout_summary',
        b,
        user: memberUser,
        route: Routes.meWorkout,
        interact: (tester) async {
          await tester.tap(find.byKey(const ValueKey('start-workout')).hitTestable());
          await frames(tester, 12);
          await tester.tap(find.byTooltip('+ kg').first);
          await frames(tester, 2);
          await tester.tap(find.byKey(const ValueKey('tick-0-0')));
          await frames(tester, 2);
          await tester.tap(find.byKey(const ValueKey('player-finish')));
          await frames(tester, 4);
          await tester.tap(find.byKey(const ValueKey('finish-anyway')));
          await frames(tester, 30);
        },
      ),
    );
    testWidgets(
      'my exercises ${b.name}',
      (t) => shot(t, 'my_exercises', b, user: memberUser, route: Routes.meExercises),
    );
    // M4: diet and nutrition.
    Future<void> openDiet(WidgetTester tester, [String? tab]) async {
      await tester.tap(find.descendant(of: find.byKey(const ValueKey('training-area')), matching: find.text('Diet')));
      await frames(tester, 6);
      if (tab != null) await tester.tap(find.text(tab).first);
    }

    testWidgets(
      'training diet members ${b.name}',
      (t) => shot(t, 'training_diet_members', b, user: ownerUser, route: Routes.staffPlans, interact: openDiet),
    );
    testWidgets(
      'training diet plans ${b.name}',
      (t) => shot(
        t,
        'training_diet_plans',
        b,
        user: ownerUser,
        route: Routes.staffPlans,
        interact: (tester) => openDiet(tester, 'Diet plans'),
      ),
    );
    testWidgets(
      'foods ${b.name}',
      (t) => shot(
        t,
        'foods',
        b,
        user: ownerUser,
        route: Routes.staffPlans,
        interact: (tester) => openDiet(tester, 'Foods'),
      ),
    );
    testWidgets(
      'food sheet ${b.name}',
      (t) => shot(
        t,
        'food_sheet',
        b,
        user: ownerUser,
        route: Routes.staffPlans,
        interact: (tester) async {
          await openDiet(tester, 'Foods');
          await frames(tester, 6);
          await tester.tap(find.byKey(const ValueKey('food-row-aloo-gobi')));
        },
      ),
    );
    testWidgets(
      'food editor ${b.name}',
      (t) => shot(t, 'food_editor', b, user: ownerUser, route: Routes.foodEdit('paneer')),
    );
    testWidgets(
      'diet template detail ${b.name}',
      (t) => shot(t, 'diet_template_detail', b, user: ownerUser, route: Routes.dietDetail('dt-1')),
    );
    testWidgets(
      'diet builder ${b.name}',
      (t) => shot(t, 'diet_builder', b, user: ownerUser, route: Routes.dietEdit('dt-1')),
    );
    testWidgets(
      'diet builder member ${b.name}',
      (t) => shot(t, 'diet_builder_member', b, user: ownerUser, route: '${Routes.dietEdit('snap-aarav')}?member=m-1'),
    );
    testWidgets(
      'targets calculator ${b.name}',
      (t) => shot(
        t,
        'targets_calculator',
        b,
        user: ownerUser,
        route: Routes.dietEdit('dt-1'),
        interact: (tester) => tester.tap(find.byKey(const ValueKey('open-calculator'))),
      ),
    );
    testWidgets(
      'assign diet ${b.name}',
      (t) => shot(
        t,
        'assign_diet',
        b,
        user: ownerUser,
        route: Routes.dietDetail('dt-1'),
        interact: (tester) => tester.tap(find.byKey(const ValueKey('diet-assign'))),
      ),
    );
    testWidgets(
      'member detail diet ${b.name}',
      (t) => shot(t, 'member_detail_diet', b, user: ownerUser, route: '${Routes.memberDetail('m-1')}?tab=diet'),
    );
    testWidgets('my diet ${b.name}', (t) => shot(t, 'my_diet', b, user: memberUser, route: Routes.meDiet));
    testWidgets(
      'meal sheet ${b.name}',
      (t) => shot(
        t,
        'meal_sheet',
        b,
        user: memberUser,
        route: Routes.meDiet,
        interact: (tester) async {
          await tester.ensureVisible(find.byKey(const ValueKey('timeline-dinner')));
          await frames(tester, 2);
          await tester.tap(find.byKey(const ValueKey('timeline-dinner')));
        },
      ),
    );
    testWidgets(
      'grocery list ${b.name}',
      (t) => shot(
        t,
        'grocery_list',
        b,
        user: memberUser,
        route: Routes.meDiet,
        interact: (tester) async {
          await tester.ensureVisible(find.byKey(const ValueKey('open-grocery')));
          await frames(tester, 2);
          await tester.tap(find.byKey(const ValueKey('open-grocery')));
        },
      ),
    );
    testWidgets(
      'new invoice ${b.name}',
      (t) => shot(
        t,
        'new_invoice',
        b,
        user: deskUser,
        route: '${Routes.memberDetail('m-1')}?tab=payments',
        interact: (tester) => tester.tap(find.byKey(const ValueKey('new-invoice'))),
      ),
    );
    testWidgets(
      'whatsapp queue ${b.name}',
      (t) => shot(t, 'whatsapp_queue', b, user: deskUser, route: Routes.whatsApp),
    );
    testWidgets(
      'whatsapp log ${b.name}',
      (t) => shot(t, 'whatsapp_log', b, user: ownerUser, route: '${Routes.whatsApp}?tab=1'),
    );
    testWidgets(
      'whatsapp broadcast ${b.name}',
      (t) => shot(t, 'whatsapp_broadcast', b, user: deskUser, route: Routes.whatsAppBroadcast),
    );
    testWidgets(
      'whatsapp templates ${b.name}',
      (t) => shot(t, 'whatsapp_templates', b, user: ownerUser, route: Routes.whatsAppTemplates),
    );
    testWidgets(
      'whatsapp festivals ${b.name}',
      (t) => shot(t, 'whatsapp_festivals', b, user: ownerUser, route: Routes.whatsAppFestivals),
    );
    testWidgets(
      'whatsapp settings ${b.name}',
      (t) => shot(t, 'whatsapp_settings', b, user: ownerUser, route: Routes.whatsAppSettings),
    );
    testWidgets(
      'staff shell desktop ${b.name}',
      (t) => shot(t, 'staff_shell_desktop', b, user: ownerUser, route: Routes.staffTeam, size: const Size(1440, 900)),
    );
  }
}
