import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/members/domain/models.dart';
import 'package:abs_fitness/features/members/presentation/import_members_screen.dart';
import 'package:abs_fitness/features/members/data/members_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/member_fakes.dart';
import '../helpers/pump.dart';

Future<void> settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Tall phone so long forms and lists are fully built.
const tall = Size(390, 1800);

/// Only what's actually on screen (other tabs stay alive but hidden).
Finder vis(String text) => find.text(text).hitTestable();

Future<void> go(WidgetTester tester, dynamic container, String route) async {
  container.read(routerProvider).go(route);
  await settle(tester);
}

void main() {
  testWidgets('members list shows status, days left, search and quick filters', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffMembers);

    expect(vis('Aarav Sharma'), findsOneWidget);
    expect(vis('Priya Verma'), findsOneWidget);
    expect(vis('Expired'), findsWidgets);

    final search = find.byType(TextField).hitTestable().first;
    await tester.enterText(search, 'priya');
    await settle(tester, 6);
    expect(vis('Priya Verma'), findsOneWidget);
    expect(vis('Aarav Sharma'), findsNothing);

    await tester.enterText(search, '');
    await settle(tester, 6);
    await tester.tap(vis('Frozen').first);
    await settle(tester);
    expect(vis('Sneha Kumari'), findsOneWidget);
    expect(vis('Aarav Sharma'), findsNothing);
  });

  testWidgets('dashboard counts and the expiring tile opens a filtered list', (tester) async {
    final c = await pumpApp(tester, user: ownerUser, size: tall);
    await settle(tester);
    expect(find.text('Active members'), findsOneWidget);
    expect(find.text('Needs action today'), findsOneWidget);
    // Priya is expiring (renewal due) and Rohit expired: both need action.
    expect(find.textContaining('Renewal due'), findsOneWidget);
    expect(find.textContaining('Expired'), findsWidgets);

    await tester.tap(find.text('Expiring soon'));
    await settle(tester);
    expect(c.read(routerProvider).state.uri.toString(), '${Routes.staffMembers}?status=expiring');
    expect(vis('Priya Verma'), findsOneWidget);
    expect(vis('Aarav Sharma'), findsNothing);
  });

  testWidgets('add member: basics → health → membership → saved', (tester) async {
    final repo = seededMembers();
    final c = await pumpApp(tester, user: deskUser, members: repo, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberNew);
    expect(find.text('New member'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Meera Iyer');
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone number'), '+91 99887 76655');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('Health'), findsWidgets);

    // Health details need consent.
    await tester.enterText(find.widgetWithText(TextFormField, 'Medical conditions'), 'Mild asthma');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('Tick the consent box to save health details.'), findsOneWidget);
    await tester.tap(find.text('Member agrees to share health details with the gym'));
    await tester.tap(find.text('Continue'));
    await settle(tester);

    await tester.tap(find.text('Monthly'));
    await settle(tester);
    expect(find.text('Total'), findsOneWidget);
    await tester.tap(find.text('Save member'));
    await settle(tester, 20);

    final added = repo.members.firstWhere((m) => m.name == 'Meera Iyer');
    expect(added.phone, '+919988776655');
    expect(added.status, MemberStatus.active);
    expect(repo.healthByMember[added.id]?.conditions, 'Mild asthma');
    expect(c.read(routerProvider).state.matchedLocation, Routes.memberDetail(added.id));
    expect(find.text('Meera Iyer'), findsWidgets);
  });

  testWidgets('add member refuses a phone that already exists', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberNew);
    await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Someone New');
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone number'), '9876500002');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('Another member already uses this phone number.'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);
  });

  testWidgets('member detail: renew from the bottom bar', (tester) async {
    final repo = seededMembers();
    final c = await pumpApp(tester, user: deskUser, members: repo, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberDetail('m-2'));
    expect(vis('Priya Verma'), findsOneWidget);

    await tester.tap(vis('Renew').first);
    await settle(tester);
    expect(find.text('Renew membership'), findsOneWidget);
    await tester.tap(find.widgetWithText(GestureDetector, 'Renew').last);
    await settle(tester);
    expect(repo.calls, contains('renew:m-2'));
    expect(find.textContaining('Renewed until 6 Dec 2026'), findsOneWidget);
  });

  testWidgets('member detail: freeze from the membership tab', (tester) async {
    final repo = seededMembers();
    final c = await pumpApp(tester, user: deskUser, members: repo, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberDetail('m-1'));
    await tester.tap(vis('Membership'));
    await settle(tester);
    await tester.tap(vis('Freeze'));
    await settle(tester);
    expect(find.text('15 freeze days left on this plan'), findsOneWidget);
    await tester.tap(find.widgetWithText(GestureDetector, 'Freeze').last);
    await settle(tester);
    expect(repo.calls.single, 'freeze:ms-1:7');
  });

  testWidgets('trainers do not get desk actions on a member', (tester) async {
    final c = await pumpApp(tester, user: trainerUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberDetail('m-1'));
    expect(find.byTooltip('More actions'), findsNothing);
    expect(find.text('Renew'), findsNothing);
    expect(find.text('WhatsApp'), findsOneWidget);
  });

  testWidgets('desk check-in by search shows the welcome, then "already"', (tester) async {
    final repo = seededMembers();
    final c = await pumpApp(tester, user: deskUser, members: repo, size: tall);
    await settle(tester);
    await go(tester, c, Routes.checkIn);
    expect(find.text('Camera unavailable. Search by name instead.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Search member to check in'), 'aarav');
    await settle(tester);
    await tester.tap(find.text('Aarav Sharma'));
    await settle(tester, 4);
    expect(find.text('Welcome, Aarav!'), findsOneWidget);
    expect(find.text('58 days left'), findsWidgets);
    await settle(tester, 15); // auto-closes after 1.2 s
    expect(find.text('Welcome, Aarav!'), findsNothing);

    await tester.tap(find.text('Aarav Sharma'));
    await settle(tester, 4);
    expect(find.text('Already checked in today'), findsOneWidget);
    expect(repo.checkIns['m-1'], hasLength(1));
    await settle(tester, 15);
  });

  testWidgets('expired member check-in warns and waits for OK', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.checkIn);
    await tester.enterText(find.widgetWithText(TextFormField, 'Search member to check in'), 'rohit');
    await settle(tester);
    await tester.tap(find.text('Rohit Yadav'));
    await settle(tester, 20);
    expect(find.text('Membership expired'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await settle(tester);
    expect(find.text('Membership expired'), findsNothing);
  });

  testWidgets('CSV import: map, preview, import, report counts', (tester) async {
    final repo = seededMembers();
    await pumpThemed(
      tester,
      ImportMembersScreen(
        pickFile: () async =>
            'Member Name,Mobile No,Date of Joining\n'
            'Kiran Rao,98765 11111,01/10/2026\n'
            'Priya Verma,9876500002,02/10/2026\n'
            ',9876511112,\n',
      ),
      overrides: [membersRepositoryProvider.overrideWithValue(repo)],
      size: tall,
    );
    await tester.pump();
    await tester.tap(find.text('Choose a CSV file').last);
    await settle(tester);
    expect(find.text('Match your columns'), findsOneWidget);
    expect(find.text('2 rows ready to import'), findsOneWidget);
    expect(find.text('1 row has problems'), findsOneWidget);

    await tester.tap(find.text('Import 2 members'));
    await settle(tester, 20);
    expect(find.text('Import finished'), findsOneWidget);
    expect(find.text('1 imported'), findsOneWidget);
    expect(find.text('1 duplicates skipped'), findsOneWidget);
    expect(find.text('1 not imported'), findsOneWidget);
    expect(repo.members.any((m) => m.name == 'Kiran Rao'), isTrue);
  });

  testWidgets('owner creates a membership plan', (tester) async {
    final plans = FakePlansRepository();
    final c = await pumpApp(tester, user: ownerUser, plans: plans, size: tall);
    await settle(tester);
    await go(tester, c, Routes.membershipPlans);
    expect(vis('Monthly'), findsOneWidget);
    expect(vis('31 active members'), findsOneWidget);

    await tester.tap(find.text('New plan'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Plan name'), 'Half-yearly');
    await tester.enterText(find.widgetWithText(TextFormField, 'Duration'), '6');
    await tester.enterText(find.widgetWithText(TextFormField, 'Price (₹)'), '7000');
    await tester.tap(find.text('Save').last);
    await settle(tester);
    expect(plans.planList.last.name, 'Half-yearly');
    expect(plans.planList.last.pricePaise, 700000);
    expect(find.text('Half-yearly'), findsOneWidget);
  });

  testWidgets('member home shows the card with QR and days left', (tester) async {
    final c = await pumpApp(
      tester,
      user: memberUser.copyWith(memberId: 'm-1'),
      prefs: {'member_onboarding_done': true},
      size: tall,
    );
    await settle(tester);
    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('ABS-0001'), findsOneWidget);
    expect(find.text('58 days left'), findsOneWidget);
    await tester.tap(find.text('Check in'));
    await settle(tester);
    expect(c.read(routerProvider).state.matchedLocation, Routes.meCheckIn);
  });

  testWidgets('notes are added to the timeline', (tester) async {
    final repo = seededMembers();
    final c = await pumpApp(tester, user: deskUser, members: repo, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberDetail('m-1'));
    await tester.ensureVisible(find.text('Notes'));
    await settle(tester, 4);
    await tester.tap(vis('Notes'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Add a note…'), 'Prefers evening slot');
    await tester.tap(find.text('Add'));
    await settle(tester);
    expect(find.text('Prefers evening slot'), findsOneWidget);
  });
}
