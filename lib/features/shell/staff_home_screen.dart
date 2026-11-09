import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/theme.dart';
import '../../core/services/contact_links.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/widgets.dart';
import '../auth/application/auth_providers.dart';
import '../auth/domain/app_user.dart';
import '../members/application/members_providers.dart';
import '../members/domain/models.dart';
import '../members/presentation/member_ui.dart';
import '../members/presentation/widgets/member_photo.dart';
import '../payments/application/payments_providers.dart';
import '../payments/domain/payment_models.dart';
import '../payments/presentation/payment_ui.dart';
import '../settings/data/gym_settings_repository.dart';
import '../workouts/application/workouts_providers.dart';
import '../whatsapp/application/whatsapp_providers.dart';
import '../whatsapp/presentation/whatsapp_ui.dart';
import '../workouts/presentation/training_today_card.dart';
import 'greeting_header.dart';

/// Staff home dashboard: the owner's revenue hero, member counts, fee dues
/// for the desk, needs-action and live check-ins. Trainers see the member
/// view scoped to their own members by RLS, today's sessions and missed
/// workouts, and no money.
class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(dashboardProvider)
      ..invalidate(needsActionProvider)
      ..invalidate(plansProvider)
      ..invalidate(duesSummaryProvider)
      ..invalidate(collectionsProvider)
      ..invalidate(collectionsTrendProvider)
      ..invalidate(coachListProvider)
      ..invalidate(queueSummaryProvider);
    await ref.read(dashboardProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();
    final l = context.l10n;
    final t = context.text;
    final counts = ref.watch(dashboardProvider);
    final plans = ref.watch(plansProvider);
    final needsSetup = user.role.isOwner && plans.hasValue && plans.value!.isEmpty;

    final tiles = <(String, int Function(DashboardCounts), PopHue, IconData, VoidCallback)>[
      (
        l.dashActive,
        (c) => c.active,
        PopHue.sky,
        PhosphorIcons.users(PhosphorIconsStyle.bold),
        () => context.go('${Routes.staffMembers}?status=active'),
      ),
      (
        l.dashExpiring,
        (c) => c.expiring,
        PopHue.tangerine,
        PhosphorIcons.hourglassMedium(PhosphorIconsStyle.bold),
        () => context.go('${Routes.staffMembers}?status=expiring'),
      ),
      (
        l.dashCheckIns,
        (c) => c.checkinsToday,
        PopHue.mint,
        PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
        () => context.push(Routes.checkIn),
      ),
      (
        l.dashNew,
        (c) => c.newThisMonth,
        PopHue.bubblegum,
        PhosphorIcons.sparkle(PhosphorIconsStyle.bold),
        () => context.go('${Routes.staffMembers}?sort=joined'),
      ),
    ];

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: QuickActionFab(
          actions: [
            if (user.role.isDesk)
              QuickAction(
                icon: PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
                label: l.fabNewMember,
                hue: PopHue.sky,
                onTap: () => context.push(Routes.memberNew),
              ),
            QuickAction(
              icon: PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
              label: l.fabCheckIn,
              hue: PopHue.mint,
              onTap: () => context.push(Routes.checkIn),
            ),
            if (user.role.isDesk)
              QuickAction(
                icon: PhosphorIcons.fileArrowUp(PhosphorIconsStyle.bold),
                label: l.membersImport,
                hue: PopHue.tangerine,
                onTap: () => context.push(Routes.memberImport),
              ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: AbsRefresh(
          onRefresh: () => _refresh(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              context.screenPadding,
              AbsSpace.x4,
              context.screenPadding,
              MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
            ),
            children: [
              GreetingHeader(name: user.name.split(' ').first),
              const SizedBox(height: AbsSpace.x5),
              if (needsSetup) ...[
                _SetupCard(
                  icon: PhosphorIcons.storefront(PhosphorIconsStyle.bold),
                  title: l.dashSetupGym,
                  body: l.dashSetupGymBody,
                  hue: PopHue.grape,
                  onTap: () => context.push(Routes.gymProfile),
                ),
                _SetupCard(
                  icon: PhosphorIcons.tag(PhosphorIconsStyle.bold),
                  title: l.dashSetupPlans,
                  body: l.dashSetupPlansBody,
                  hue: PopHue.lime,
                  onTap: () => context.push(Routes.membershipPlans),
                ),
                _SetupCard(
                  icon: PhosphorIcons.usersThree(PhosphorIconsStyle.bold),
                  title: l.homeStepInvite,
                  body: l.homeStepInviteBody,
                  hue: PopHue.sky,
                  onTap: () => context.push(Routes.staffTeam),
                ),
                const SizedBox(height: AbsSpace.x3),
              ],
              if (user.role.canSeeRevenue) ...[const _RevenueHero(), const SizedBox(height: AbsSpace.x4)],
              AsyncView<DashboardCounts>(
                value: counts,
                isEmpty: (_) => false,
                empty: const SizedBox.shrink(),
                onRetry: () => ref.invalidate(dashboardProvider),
                loading: SkeletonBlock(
                  child: _TileGrid(tiles: tiles, counts: const DashboardCounts()),
                ),
                data: (c) => _TileGrid(tiles: tiles, counts: c),
              ),
              if (user.role.isDesk) ...[
                const _DuesTiles(),
                const SizedBox(height: AbsSpace.x4),
                const WhatsAppTodayCard(),
              ],
              if (user.role == UserRole.trainer || user.role.isOwner) ...[
                const SizedBox(height: AbsSpace.x4),
                const TrainingTodayCard(),
              ],
              const SizedBox(height: AbsSpace.x5),
              Text(l.dashNeedsAction, style: t.title),
              const SizedBox(height: AbsSpace.x2),
              const _NeedsActionList(),
              const SizedBox(height: AbsSpace.x5),
              Text(l.dashLiveFeed, style: t.title),
              const SizedBox(height: AbsSpace.x2),
              const _LiveFeed(),
              if (user.role == UserRole.trainer) ...[
                const SizedBox(height: AbsSpace.x5),
                Text(l.homeTrainerBody, style: t.caption.copyWith(color: context.colors.textSecondary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Owner-only revenue: Today / This week / This month with a 30-day trend.
class _RevenueHero extends ConsumerStatefulWidget {
  const _RevenueHero();

  @override
  ConsumerState<_RevenueHero> createState() => _RevenueHeroState();
}

class _RevenueHeroState extends ConsumerState<_RevenueHero> {
  RevenuePeriod _period = RevenuePeriod.today;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final summary = ref.watch(collectionsProvider(_period)).value;
    final trend = ref.watch(collectionsTrendProvider).value;
    final today = IstDates.today(now: ref.watch(clockProvider)());
    final byDay = {for (final d in trend?.byDay ?? const <DayAmount>[]) paymentDate(d.day): d.paise};
    final spark = [
      for (var i = 29; i >= 0; i--) (byDay[paymentDate(today.subtract(Duration(days: i)))] ?? 0).toDouble(),
    ];
    final p = c.pop(PopHue.lime);
    return Pressable(
      onTap: () => context.go(Routes.staffPayments),
      child: Container(
        key: const ValueKey('revenue-hero'),
        padding: const EdgeInsets.all(AbsSpace.x5),
        decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedTabs(
              labels: [l.dashToday, l.dashWeek, l.dashMonth],
              selected: _period.index,
              dense: true,
              hue: PopHue.tangerine,
              onChanged: (i) => setState(() => _period = RevenuePeriod.values[i]),
            ),
            const SizedBox(height: AbsSpace.x4),
            Text(l.dashRevenue, style: t.label.copyWith(color: p.onFill)),
            CountUp(
              value: summary?.collected ?? 0,
              format: (v) => Money.format(v.round()),
              style: t.numericOf(t.displayXL).copyWith(color: p.onFill, height: 1.1),
            ),
            Text(
              [
                l.payPaymentsCount(summary?.paymentsCount ?? 0),
                if ((summary?.outstanding ?? 0) > 0) l.dashOutstanding(Money.format(summary!.outstanding)),
              ].join(' · '),
              style: t.label.copyWith(color: p.onFill),
            ),
            const SizedBox(height: AbsSpace.x3),
            Row(
              children: [
                Text(l.dashLast30, style: t.caption.copyWith(color: p.onFill)),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: SizedBox(
                    height: AbsSize.sparklineHeight,
                    child: Sparkline(values: spark, color: p.onFill),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Fee dues for the desk: overdue ₹ and count, and claims to verify.
class _DuesTiles extends ConsumerWidget {
  const _DuesTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final dues = ref.watch(duesSummaryProvider).value;
    if (dues == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StatTile(
              key: const ValueKey('overdue-tile'),
              label: '${l.dashOverdue} · ${l.dashInvoices(dues.overdueCount)}',
              value: dues.overduePaise,
              format: (v) => Money.format(v.round()),
              hue: PopHue.coral,
              icon: PhosphorIcons.warningCircle(PhosphorIconsStyle.bold),
              onTap: () => context.go(Routes.staffPayments),
            ),
          ),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: StatTile(
              label: l.dashToVerify,
              value: dues.pendingClaims,
              hue: PopHue.grape,
              icon: PhosphorIcons.sealCheck(PhosphorIconsStyle.bold),
              onTap: () => context.go(Routes.staffPayments),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.tiles, required this.counts});

  final List<(String, int Function(DashboardCounts), PopHue, IconData, VoidCallback)> tiles;
  final DashboardCounts counts;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final columns = box.maxWidth > 700 ? 4 : 2;
      final width = (box.maxWidth - AbsSpace.x3 * (columns - 1)) / columns;
      return Wrap(
        spacing: AbsSpace.x3,
        runSpacing: AbsSpace.x1,
        children: [
          for (final (i, (label, value, hue, icon, onTap)) in tiles.indexed)
            SizedBox(
              width: width,
              child: Entrance(
                index: i,
                child: StatTile(label: label, value: value(counts), hue: hue, icon: icon, onTap: onTap),
              ),
            ),
        ],
      );
    },
  );
}

class _SetupCard extends StatelessWidget {
  const _SetupCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.hue,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final PopHue hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AbsSpace.x2),
    child: AbsCard(
      hue: hue,
      onTap: onTap,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Row(
        children: [
          IconBubble(icon: icon, hue: hue),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.heading),
                Text(body, style: context.text.caption.copyWith(color: context.colors.textSecondary)),
              ],
            ),
          ),
          Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
        ],
      ),
    ),
  );
}

class _NeedsActionList extends ConsumerWidget {
  const _NeedsActionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final items = ref.watch(needsActionProvider);
    final gym = ref.watch(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;

    (String, PopHue, IconData, String) look(NeedsAction a) {
      final first = a.name.split(' ').first;
      if (a.reason == ActionReason.overdue) {
        // detail: "next_due_date|balance_paise"
        final parts = (a.detail ?? '').split('|');
        final due = DateTime.tryParse(parts.first);
        final balance = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        return (
          l.reasonOverdue(Money.format(balance), dateLabel(due)),
          PopHue.coral,
          PhosphorIcons.currencyInr(PhosphorIconsStyle.bold),
          duesReminderText(l, name: a.name, balancePaise: balance, dueDate: due, gym: gym),
        );
      }
      final date = a.detail == null || a.detail!.isEmpty ? '' : dateLabel(DateTime.tryParse(a.detail!));
      return switch (a.reason) {
        ActionReason.overdue => throw StateError('handled above'),
        ActionReason.renewalDue => (
          l.reasonRenewal(date),
          PopHue.tangerine,
          PhosphorIcons.hourglassMedium(PhosphorIconsStyle.bold),
          l.whatsappReminderText(first, '', gym, date).replaceAll('  ', ' '),
        ),
        ActionReason.expired => (
          l.reasonExpired(date),
          PopHue.coral,
          PhosphorIcons.calendarX(PhosphorIconsStyle.bold),
          l.whatsappExpiredText(first, gym, date),
        ),
        ActionReason.birthday => (
          l.reasonBirthday,
          PopHue.bubblegum,
          PhosphorIcons.cake(PhosphorIconsStyle.bold),
          l.whatsappBirthdayText(first, gym),
        ),
        ActionReason.absent => (
          date.isEmpty || date == '—' ? l.reasonAbsent : l.reasonAbsentSince(date),
          PopHue.sky,
          PhosphorIcons.footprints(PhosphorIconsStyle.bold),
          l.whatsappAbsentText(first, gym),
        ),
      };
    }

    return AsyncView<List<NeedsAction>>(
      value: items,
      onRetry: () => ref.invalidate(needsActionProvider),
      loading: const SizedBox(height: 160, child: SkeletonList(itemCount: 2)),
      empty: AbsCard(
        hue: PopHue.mint,
        child: Row(
          children: [
            IconBubble(icon: PhosphorIcons.confetti(PhosphorIconsStyle.bold), hue: PopHue.mint),
            const SizedBox(width: AbsSpace.x3),
            Expanded(child: Text(l.dashAllClear, style: context.text.body)),
          ],
        ),
      ),
      data: (list) => AbsCard(
        padding: const EdgeInsets.symmetric(vertical: AbsSpace.x2),
        child: Column(
          children: [
            for (final a in list.take(12))
              () {
                final (reason, hue, icon, text) = look(a);
                return ListTile(
                  onTap: () => context.push(Routes.memberDetail(a.memberId)),
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MemberPhoto(name: a.name, path: a.photoPath, size: 42),
                      Positioned(
                        right: -6,
                        bottom: -6,
                        child: IconBubble(icon: icon, hue: hue, size: 22),
                      ),
                    ],
                  ),
                  title: Text(a.name, style: context.text.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(reason, style: context.text.caption.copyWith(color: c.pop(hue).text)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l.actionWhatsApp,
                        icon: Icon(PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold), color: c.pop(PopHue.mint).text),
                        onPressed: () => ref.sendWhatsApp(
                          memberId: a.memberId,
                          phone: a.phone,
                          text: text,
                          replaces: switch (a.reason) {
                            ActionReason.overdue => 'dues_reminder',
                            ActionReason.renewalDue || ActionReason.expired => 'expir',
                            ActionReason.birthday => 'birthday',
                            ActionReason.absent => null,
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: l.actionCall,
                        icon: Icon(PhosphorIcons.phone(PhosphorIconsStyle.bold), color: c.pop(PopHue.sky).text),
                        onPressed: () => ContactLinks.openCall(a.phone),
                      ),
                    ],
                  ),
                );
              }(),
          ],
        ),
      ),
    );
  }
}

class _LiveFeed extends ConsumerWidget {
  const _LiveFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final feed = ref.watch(todaysCheckInsProvider);
    return AsyncView<List<Attendance>>(
      value: feed,
      onRetry: () => ref.invalidate(todaysCheckInsProvider),
      loading: const SizedBox(height: 80, child: SkeletonList(itemCount: 1)),
      empty: AbsCard(
        child: Row(
          children: [
            IconBubble(icon: PhosphorIcons.doorOpen(PhosphorIconsStyle.bold), hue: PopHue.sky, solid: false),
            const SizedBox(width: AbsSpace.x3),
            Expanded(child: Text(l.dashNoCheckIns, style: context.text.body)),
          ],
        ),
      ),
      data: (list) => AbsCard(
        hue: PopHue.mint,
        padding: const EdgeInsets.symmetric(vertical: AbsSpace.x2),
        child: Column(
          children: [
            for (final (i, a) in list.take(8).indexed)
              Entrance(
                index: i,
                child: ListTile(
                  dense: true,
                  onTap: () => context.push(Routes.memberDetail(a.memberId)),
                  leading: IconBubble(
                    icon: PhosphorIcons.footprints(PhosphorIconsStyle.bold),
                    hue: PopHue.mint,
                    size: 32,
                  ),
                  title: Text(a.memberName ?? '', style: context.text.body),
                  trailing: Text(IstDates.formatTime(a.checkedInAt), style: context.text.numericOf(context.text.label)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
