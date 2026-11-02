import 'package:abs_fitness/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('AbsButton keeps its width while loading and ignores taps', (tester) async {
    var taps = 0;
    var loading = false;
    late StateSetter set;
    await pumpThemed(
      tester,
      Scaffold(
        body: Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              set = setState;
              return AbsButton(label: 'Collect payment', expand: false, isLoading: loading, onPressed: () => taps++);
            },
          ),
        ),
      ),
    );
    final idleSize = tester.getSize(find.byType(AbsButton));
    await tester.tap(find.byType(AbsButton));
    expect(taps, 1);

    set(() => loading = true);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getSize(find.byType(AbsButton)), idleSize);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(AbsButton));
    expect(taps, 1);
  });

  testWidgets('StatusPill always shows text, not colour alone', (tester) async {
    await pumpThemed(
      tester,
      const Scaffold(
        body: Column(
          children: [
            StatusPill(status: PillStatus.expiring, days: 3),
            StatusPill(status: PillStatus.overdue),
            StatusPill(status: PillStatus.expiring, days: 1),
          ],
        ),
      ),
    );
    expect(find.text('Expiring · 3 days'), findsOneWidget);
    expect(find.text('Expiring · 1 day'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
  });

  testWidgets('SegmentedTabs reports the tapped segment', (tester) async {
    int? picked;
    await pumpThemed(
      tester,
      Scaffold(
        body: SegmentedTabs(labels: const ['Due', 'Overdue', 'Paid'], selected: 0, onChanged: (i) => picked = i),
      ),
    );
    await tester.tap(find.text('Paid'));
    expect(picked, 2);
  });

  testWidgets('AbsTextField validates when it loses focus', (tester) async {
    await pumpThemed(
      tester,
      Scaffold(
        body: Column(
          children: [
            AbsTextField(label: 'Name', validator: (v) => (v ?? '').isEmpty ? 'Required' : null),
            const AbsTextField(label: 'Other'),
          ],
        ),
      ),
    );
    await tester.tap(find.widgetWithText(TextFormField, 'Name'));
    await tester.pump();
    expect(find.text('Required'), findsNothing);
    await tester.tap(find.widgetWithText(TextFormField, 'Other'));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('AsyncView renders loading, empty, error and data', (tester) async {
    var retried = false;
    Widget view(AsyncValue<List<int>> v) => Scaffold(
      body: AsyncView<List<int>>(
        value: v,
        onRetry: () => retried = true,
        empty: const Text('nothing here'),
        data: (items) => Text('items: ${items.length}'),
      ),
    );

    await pumpThemed(tester, view(const AsyncLoading()));
    expect(find.byType(SkeletonList), findsOneWidget);

    await pumpThemed(tester, view(const AsyncData([])));
    await tester.pumpAndSettle();
    expect(find.text('nothing here'), findsOneWidget);

    await pumpThemed(tester, view(AsyncError(Exception('x'), StackTrace.empty)));
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retried, isTrue);

    await pumpThemed(tester, view(const AsyncData([1, 2])));
    await tester.pumpAndSettle();
    expect(find.text('items: 2'), findsOneWidget);
  });

  testWidgets('MemberTile swipe triggers actions and keeps the tile', (tester) async {
    var collected = 0;
    var reminded = 0;
    await pumpThemed(
      tester,
      Scaffold(
        body: MemberTile(
          name: 'Aarav Sharma',
          plan: 'Quarterly',
          status: PillStatus.active,
          daysLeft: 30,
          onCollect: () => collected++,
          onRemind: () => reminded++,
        ),
      ),
    );
    await tester.drag(find.text('Aarav Sharma'), const Offset(300, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.text('Aarav Sharma'), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(collected, 1);
    expect(reminded, 1);
    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('30 days left'), findsOneWidget);
  });

  testWidgets('QuickActionFab reveals its four actions', (tester) async {
    final hits = <String>[];
    await pumpThemed(
      tester,
      Scaffold(
        floatingActionButton: Builder(
          builder: (context) => QuickActionFab(
            actions: staffQuickActions(
              context,
              onNewMember: () => hits.add('new'),
              onCollect: () => hits.add('collect'),
              onCheckIn: () => hits.add('checkin'),
              onEnquiry: () => hits.add('enquiry'),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Collect'), findsNothing);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    for (final label in ['New member', 'Collect', 'Check-in', 'Enquiry']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('Check-in'));
    await tester.pumpAndSettle();
    expect(hits, ['checkin']);
  });
}
