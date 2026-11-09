import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/features/member_home/data/my_member_repository.dart';
import 'package:abs_fitness/features/whatsapp/domain/whatsapp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/member_fakes.dart';
import '../helpers/pump.dart';
import '../helpers/whatsapp_fakes.dart';

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

/// Leaving for WhatsApp and coming back.
Future<void> roundTrip(WidgetTester tester) async {
  for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
  await tester.pump();
  for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
  await settle(tester);
}

void main() {
  testWidgets('free mode: send opens WhatsApp, coming back ticks the row, undo puts it back', (tester) async {
    final wa = FakeWhatsAppRepository();
    final launcher = FakeLauncher();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, launcher: launcher, size: tall);
    await go(tester, c, Routes.whatsApp);

    expect(vis('3 to send'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('wa-send-q-1')));
    await settle(tester);
    expect(launcher.opened.single.$1, '+919876500002');
    expect(launcher.opened.single.$2, startsWith('Hi Priya, your Monthly membership'));
    // Waiting for the trip to WhatsApp: the row offers "Mark sent".
    expect(find.byKey(const ValueKey('wa-mark-q-1')), findsOneWidget);

    await roundTrip(tester);
    expect(wa.calls, contains('mark:q-1:sent'));
    expect(vis('2 to send'), findsOneWidget);
    expect(find.text('Ticked: sent to Priya'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('wa-undo-q-1')));
    await settle(tester);
    expect(wa.calls.last, 'mark:q-1:queued');
    expect(vis('3 to send'), findsOneWidget);
  });

  testWidgets('"Send next" walks the queue; moving on ticks the last one', (tester) async {
    final wa = FakeWhatsAppRepository();
    final launcher = FakeLauncher();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, launcher: launcher, size: tall);
    await go(tester, c, Routes.whatsApp);

    await tester.tap(find.byKey(const ValueKey('wa-next')));
    await settle(tester);
    expect(find.text('Send to Rohit · 3 left'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('wa-next')));
    await settle(tester);
    expect(launcher.opened.map((o) => o.$1), ['+919876500002', '+919876500003']);
    expect(wa.calls, ['mark:q-1:sent']);

    await roundTrip(tester);
    expect(wa.calls, ['mark:q-1:sent', 'mark:q-2:sent']);
    expect(find.text('Send to Aarav · 1 left'), findsOneWidget);
  });

  testWidgets('skip is optimistic and rolls back when the server refuses', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsApp);

    wa.error = const ServerFailure('down');
    await tester.tap(find.byKey(const ValueKey('wa-skip-q-2')));
    await settle(tester);
    expect(find.byKey(const ValueKey('wa-send-q-2')), findsOneWidget);
    expect(vis('3 to send'), findsOneWidget);

    wa.error = null;
    await tester.tap(find.byKey(const ValueKey('wa-skip-q-2')));
    await settle(tester);
    expect(wa.calls, ['mark:q-2:skipped']);
    expect(find.text('Skipped Rohit'), findsOneWidget);
  });

  testWidgets('a phone without WhatsApp says so and leaves the row as it was', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, launcher: FakeLauncher()..works = false, size: tall);
    await go(tester, c, Routes.whatsApp);
    await tester.tap(find.byKey(const ValueKey('wa-send-q-1')));
    await settle(tester);
    expect(find.text("Couldn't open WhatsApp on this device."), findsOneWidget);
    expect(find.byKey(const ValueKey('wa-send-q-1')), findsOneWidget);
    expect(wa.calls, isEmpty);
  });

  testWidgets('empty queue offers to check for today\'s reminders', (tester) async {
    final wa = FakeWhatsAppRepository(queue: []);
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsApp);
    expect(find.text('Nothing to send'), findsOneWidget);
    await tester.tap(find.text("Check for today's reminders").hitTestable().last);
    await settle(tester);
    expect(wa.calls, ['build']);
    expect(find.text('No new reminders'), findsOneWidget);
  });

  testWidgets('the log filters by status', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: ownerUser, whatsapp: wa, size: tall);
    await go(tester, c, '${Routes.whatsApp}?tab=1');
    expect(vis('Sneha Kumari'), findsOneWidget);
    expect(vis('Priya Verma'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('wa-log-sent')));
    await settle(tester);
    expect(vis('Sneha Kumari'), findsOneWidget);
    expect(vis('Read'), findsOneWidget);
    expect(vis('Priya Verma'), findsNothing);
  });

  testWidgets('broadcast: pick a segment, see who it reaches, preview, queue', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsAppBroadcast);

    expect(vis('3 of 3 members get it'), findsOneWidget);
    await tester.tap(vis('Everyone'));
    await settle(tester);
    expect(vis('4 of 5 members get it'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('wa-broadcast-title')), 'Diwali timings');
    await tester.enterText(find.byKey(const ValueKey('wa-broadcast-body')), 'Hi ');
    await tester.tap(vis('{first_name}'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('wa-broadcast-body')),
      'Hi {first_name}, {gym_name} is open 6–10 am on Diwali.',
    );
    await settle(tester, 4);
    expect(find.text('Hi Riya, ABS Fitness Zone is open 6–10 am on Diwali.'), findsOneWidget);

    await tester.tap(vis('Gym update'));
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('wa-broadcast-send')));
    await settle(tester);
    expect(wa.calls, ['broadcast:all:utility:']);
    expect(find.text('4 queued · 1 skipped'), findsOneWidget);
  });

  testWidgets('bulk WhatsApp from the members list goes to the picked members', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.staffMembers);
    await tester.longPress(vis('Aarav Sharma'));
    await settle(tester, 4);
    await tester.tap(vis('Priya Verma'));
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('bulk-whatsapp')));
    await settle(tester);

    expect(vis('2 selected members'), findsOneWidget);
    expect(vis('2 of 2 members get it'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('wa-broadcast-title')), 'Batch change');
    await tester.enterText(find.byKey(const ValueKey('wa-broadcast-body')), 'Morning batch moves to 6:30 from Monday.');
    await tester.tap(find.byKey(const ValueKey('wa-broadcast-send')));
    await settle(tester);
    expect(wa.calls, ['broadcast:members:marketing:m-1,m-2']);
    // Back on the list with the selection cleared.
    expect(find.byKey(const ValueKey('bulk-whatsapp')), findsNothing);
  });

  testWidgets('owner edits a template with a live sample preview', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: ownerUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsAppTemplates);

    await tester.tap(find.byKey(const ValueKey('tpl-expiry_soon-en')));
    await settle(tester);
    expect(
      find.text(
        'Hi Riya, your Quarterly membership at ABS Fitness Zone ends on 10 Nov 2026 (7 days left). '
        'Renew at the desk or reply here to keep going 💪',
      ),
      findsOneWidget,
    );
    // Meta's numbered form for registering the template (API mode).
    expect(
      find.textContaining('Hi {{1}}, your {{2}} membership at {{3}} ends on {{4}} ({{5}} days left).'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const ValueKey('tpl-body')), 'Hi {first_name}, {plan} ends {end_date}.');
    await settle(tester, 4);
    expect(find.text('Hi Riya, Quarterly ends 10 Nov 2026.'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('tpl-save')));
    await tester.tap(find.byKey(const ValueKey('tpl-save')));
    await settle(tester);
    expect(wa.calls, ['template:expiry_soon:en']);
    expect(wa.templateList.first.body, 'Hi {first_name}, {plan} ends {end_date}.');
  });

  testWidgets('front desk reads templates but cannot change them', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await go(tester, c, Routes.whatsAppTemplates);
    expect(find.text('Only the owner can change templates.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tpl-birthday-en')));
    await settle(tester);
    expect(find.byKey(const ValueKey('tpl-save')), findsNothing);
  });

  testWidgets('owner adds a festival and switches one off', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: ownerUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsAppFestivals);
    expect(vis('15 Nov 2026 · In 12 days · Everyone'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('fest-on-f-2')));
    await settle(tester);
    expect(wa.calls, ['festival:Christmas']);
    expect(wa.festivalList.last.isEnabled, isFalse);

    await tester.tap(find.byKey(const ValueKey('fest-add')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('fest-name')), 'Lohri');
    await tester.tap(find.byKey(const ValueKey('fest-save')));
    await settle(tester);
    expect(wa.calls.last, 'festival:Lohri');
    expect(vis('Lohri'), findsOneWidget);
  });

  testWidgets('owner switches to API mode, changes reminder days and sees the cost meter', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(tester, user: ownerUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsAppSettings);

    expect(find.text('₹94.20 of ₹200 marketing cap used'), findsOneWidget);
    await tester.tap(find.text('API mode'));
    await settle(tester, 4);
    expect(find.textContaining('Cloud API'), findsOneWidget);

    // Drop "3 days after", add "5 days before".
    await tester.tap(find.descendant(of: find.byKey(const ValueKey('wa-day--3')), matching: find.byType(Icon)).last);
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('wa-add-day')));
    await settle(tester, 4);
    await tester.enterText(find.byType(TextField).last, '5');
    await tester.tap(find.text('Done').last);
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('wa-auto-birthday')));
    await settle(tester, 4);

    await tester.ensureVisible(find.byKey(const ValueKey('wa-settings-save')));
    await tester.tap(find.byKey(const ValueKey('wa-settings-save')));
    await settle(tester);
    expect(wa.calls, ['settings:api']);
    expect(wa.current.mode, WhatsAppMode.api);
    expect(wa.current.expiryDays, [7, 5, 3, 0]);
    expect(wa.current.automation('birthday'), isFalse);
    expect(wa.current.toSettings()['expiry_reminder_days'], [7, 5, 3, 0]);
  });

  testWidgets('API mode shows "Send now" on the queue', (tester) async {
    final wa = FakeWhatsAppRepository(settings: const WhatsAppSettings(mode: WhatsAppMode.api));
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, size: tall);
    await go(tester, c, Routes.whatsApp);
    expect(vis('API mode'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('wa-send-now')));
    await settle(tester);
    expect(wa.calls, ['send-now']);
  });

  testWidgets('member detail: WhatsApp button logs the message; desk turns WhatsApp off', (tester) async {
    final wa = FakeWhatsAppRepository();
    final launcher = FakeLauncher();
    final c = await pumpApp(tester, user: deskUser, whatsapp: wa, launcher: launcher, size: tall);
    await go(tester, c, Routes.memberDetail('m-2'));

    // Priya has a queued "ending soon" reminder: the hand-sent one replaces it.
    await tester.tap(find.text('WhatsApp').hitTestable().last);
    await settle(tester);
    expect(launcher.opened.single.$1, '+919876500002');
    expect(wa.calls, ['replace:q-1']);

    await tester.ensureVisible(find.byKey(const ValueKey('wa-opt')));
    await tester.tap(find.byKey(const ValueKey('wa-opt')));
    await settle(tester);
    expect(wa.calls.last, 'opt:m-2:true');
    expect(find.text('WhatsApp messages turned off'), findsOneWidget);
    expect(find.text('Turned off: no WhatsApp messages from the gym.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('wa-member-log')));
    await settle(tester);
    expect(find.text("Priya's messages"), findsOneWidget);
    expect(vis('Membership ending soon'), findsOneWidget);
  });

  testWidgets('member turns WhatsApp off in their own profile', (tester) async {
    final wa = FakeWhatsAppRepository();
    final c = await pumpApp(
      tester,
      user: memberUser,
      whatsapp: wa,
      size: tall,
      prefs: {'member_onboarding_done': true},
      overrides: [myMemberProvider.overrideWith((ref) async => sampleMembers().first)],
    );
    await go(tester, c, Routes.meProfile);
    await tester.tap(find.byKey(const ValueKey('wa-opt')));
    await settle(tester);
    expect(wa.calls, ['opt:m-1:true']);
    expect(find.text('WhatsApp messages turned off'), findsOneWidget);
  });

  testWidgets('staff home shows what is left to send and opens the queue', (tester) async {
    await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    expect(find.text('3 to send · 1 sent'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('wa-today')));
    await tester.tap(find.byKey(const ValueKey('wa-today')));
    await settle(tester);
    expect(find.byKey(const ValueKey('wa-send-q-1')), findsOneWidget);
  });

  testWidgets('trainers cannot open WhatsApp', (tester) async {
    final c = await pumpApp(tester, user: trainerUser, size: tall);
    await go(tester, c, Routes.whatsApp);
    expect(c.read(routerProvider).routerDelegate.currentConfiguration.uri.path, Routes.staffMore);
  });
}
