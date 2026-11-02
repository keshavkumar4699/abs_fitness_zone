import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../settings/application/theme_mode_controller.dart';

/// Hidden screen showing every design-system component and state.
/// Reach it by long-pressing the logo on the welcome screen (or from More,
/// for the owner).
class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  bool _bigText = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(_bigText ? AbsTextScale.max : 1)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.galleryTitle),
          actions: [
            IconButton(
              tooltip: l.moreAppearance,
              icon: Icon(isDark ? PhosphorIcons.sun() : PhosphorIcons.moon()),
              onPressed: () =>
                  ref.read(themeModeControllerProvider.notifier).set(isDark ? ThemeMode.light : ThemeMode.dark),
            ),
            Row(
              children: [
                Text(l.galleryTextScale, style: context.text.label),
                Switch(value: _bigText, activeThumbColor: c.accent, onChanged: (v) => setState(() => _bigText = v)),
              ],
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: c.accent,
                labelColor: c.textPrimary,
                unselectedLabelColor: c.textSecondary,
                dividerColor: c.border,
                tabs: [
                  Tab(text: l.galleryButtons),
                  Tab(text: l.galleryStates),
                ],
              ),
              const Expanded(child: TabBarView(children: [GalleryContent(), GalleryStatesContent()])),
            ],
          ),
        ),
        floatingActionButton: QuickActionFab(
          actions: staffQuickActions(
            context,
            onNewMember: () => showAbsSnackbar(context, l.fabNewMember),
            onCollect: () => showAbsSnackbar(context, l.fabCollect),
            onCheckIn: () => showAbsSnackbar(context, l.fabCheckIn),
            onEnquiry: () => showAbsSnackbar(context, l.fabEnquiry),
          ),
        ),
      ),
    );
  }
}

/// The gallery body, also used by golden/screenshot tests.
class GalleryContent extends StatefulWidget {
  const GalleryContent({super.key});

  @override
  State<GalleryContent> createState() => _GalleryContentState();
}

class _GalleryContentState extends State<GalleryContent> {
  int _tab = 0;
  ChartPeriod _period = ChartPeriod.d30;
  bool _loading = false;
  bool _success = false;

  static const _revenue = <double>[
    18.0,
    22,
    19,
    26,
    24,
    31,
    28,
    35,
    30,
    33,
    41,
    38,
    36,
    44,
    40,
    47,
    43,
    50,
    46,
    52,
    49,
    55,
    51,
    58,
    54,
    61,
    57,
    63,
    60,
    66,
  ];

  Future<void> _fakeSave() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _success = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _success = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final pad = context.screenPadding;

    Widget section(String title, Widget child) => Padding(
      padding: EdgeInsets.fromLTRB(pad, AbsSpace.x6, pad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title.toUpperCase(), style: t.caption.copyWith(color: c.textSecondary, letterSpacing: 1.2)),
          const SizedBox(height: AbsSpace.x3),
          child,
        ],
      ),
    );

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(bottom: AbsSpace.x14 * 4 + MediaQuery.paddingOf(context).bottom),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(pad, AbsSpace.x4, pad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.statTodayCollections, style: t.label.copyWith(color: c.textSecondary)),
                  CountUp(
                    value: 4235000,
                    format: (v) => Money.format(v.toInt()),
                    style: t.displayXL.copyWith(color: c.accentText),
                  ),
                ],
              ),
            ),
            section(
              l.galleryButtons,
              Column(
                children: [
                  AbsButton(label: l.galleryPrimary, onPressed: _fakeSave, isLoading: _loading, isSuccess: _success),
                  const SizedBox(height: AbsSpace.x3),
                  AbsButton.secondary(label: l.gallerySecondary, icon: PhosphorIcons.plus(), onPressed: () {}),
                  const SizedBox(height: AbsSpace.x3),
                  AbsButton.destructive(label: l.galleryDestructive, icon: PhosphorIcons.trash(), onPressed: () {}),
                  const SizedBox(height: AbsSpace.x3),
                  Row(
                    children: [
                      Expanded(
                        child: AbsButton(label: l.galleryLoading, isLoading: true, onPressed: () {}),
                      ),
                      const SizedBox(width: AbsSpace.x3),
                      Expanded(
                        child: AbsButton(label: l.gallerySuccess, isSuccess: true, onPressed: () {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: AbsSpace.x2),
                  Row(
                    children: [
                      AbsButton.ghost(label: l.galleryGhost, onPressed: () {}),
                      const Spacer(),
                      AbsButton(label: l.galleryDisabled, onPressed: null, expand: false),
                    ],
                  ),
                ],
              ),
            ),
            section(
              l.galleryCards,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: l.statActiveMembers,
                          value: 287,
                          deltaPercent: 4.2,
                          sparkline: const [240, 248, 251, 262, 270, 276, 287],
                        ),
                      ),
                      const SizedBox(width: AbsSpace.x3),
                      Expanded(child: StatTile(label: l.statCheckIns, value: 96, deltaPercent: -3.1)),
                    ],
                  ),
                  const SizedBox(height: AbsSpace.x3),
                  AbsCard(
                    title: l.galleryCards,
                    action: Icon(PhosphorIcons.caretRight(), color: c.textSecondary),
                    onTap: () {},
                    child: Text(l.gallerySheetBody, style: t.body.copyWith(color: c.textSecondary)),
                  ),
                ],
              ),
            ),
            section(
              l.galleryPills,
              const Wrap(
                spacing: AbsSpace.x2,
                runSpacing: AbsSpace.x2,
                children: [
                  StatusPill(status: PillStatus.active),
                  StatusPill(status: PillStatus.expiring, days: 5),
                  StatusPill(status: PillStatus.expired),
                  StatusPill(status: PillStatus.frozen),
                  StatusPill(status: PillStatus.paid),
                  StatusPill(status: PillStatus.partial),
                  StatusPill(status: PillStatus.overdue),
                  StatusPill(status: PillStatus.lead),
                ],
              ),
            ),
            section(
              l.galleryRings,
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: AbsSpace.x4,
                runSpacing: AbsSpace.x4,
                children: [
                  ProgressRing(
                    progress: 0.62,
                    semanticsLabel: l.galleryDaysUsed,
                    child: Text('38', style: t.numericOf(t.title)),
                  ),
                  ProgressRing(
                    progress: 0.85,
                    color: c.success,
                    child: Icon(PhosphorIcons.barbell(), color: c.success),
                  ),
                  ProgressRing(
                    progress: 0.4,
                    color: c.chart[2],
                    size: 72,
                    strokeWidth: AbsSize.ringStroke - 2,
                    child: Text('40%', style: t.numericOf(t.label)),
                  ),
                ],
              ),
            ),
            section(
              l.galleryFields,
              Column(
                children: [
                  AbsTextField(label: l.fieldName, validator: (v) => (v ?? '').isEmpty ? l.commonRequired : null),
                  const SizedBox(height: AbsSpace.x4),
                  AbsTextField(
                    label: l.fieldPhone,
                    prefixText: '+91',
                    numeric: true,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AbsSpace.x4),
                  AbsTextField(
                    label: l.fieldAmount,
                    prefixText: '₹',
                    numeric: true,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            section(
              l.galleryTabs,
              SegmentedTabs(
                labels: [l.statusPaid, l.statusOverdue, l.statusPartial],
                selected: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
            ),
            section(
              l.galleryCharts,
              ChartCard(
                title: l.chartRevenue,
                values: _revenue,
                period: _period,
                onPeriodChanged: (p) => setState(() => _period = p),
                formatValue: (v) => Money.format((v * 100000).round()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Second gallery page: list-shaped components and the four screen states.
class GalleryStatesContent extends StatelessWidget {
  const GalleryStatesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final pad = context.screenPadding;

    Widget label(String text) => Padding(
      padding: EdgeInsets.fromLTRB(pad, AbsSpace.x6, pad, AbsSpace.x3),
      child: Text(text.toUpperCase(), style: t.caption.copyWith(color: c.textSecondary, letterSpacing: 1.2)),
    );

    Widget framed(double height, Widget child) => Padding(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: c.border),
          borderRadius: AbsRadius.cardAll,
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );

    return ListView(
      padding: EdgeInsets.only(bottom: AbsSpace.x14 + MediaQuery.paddingOf(context).bottom),
      children: [
        label(l.galleryTiles),
        MemberTile(
          name: 'Aarav Sharma',
          plan: 'Quarterly · Morning',
          status: PillStatus.active,
          daysLeft: 54,
          onTap: () {},
          onCollect: () => showAbsSnackbar(context, l.swipeCollect),
          onRemind: () => showAbsSnackbar(context, l.gallerySnackbarMessage, onUndo: () {}),
        ),
        MemberTile(
          name: 'Priya Verma',
          plan: 'Monthly · Evening',
          status: PillStatus.expiring,
          daysLeft: 4,
          onTap: () {},
        ),
        MemberTile(name: 'Rohit Yadav', plan: 'Annual · Morning', status: PillStatus.expired, onTap: () {}),
        MemberTile(name: 'Sneha Kumari', plan: 'Half-yearly', status: PillStatus.frozen, onTap: () {}),
        label(l.galleryFeedback),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: Row(
            children: [
              Expanded(
                child: AbsButton.secondary(
                  label: l.galleryOpenSheet,
                  onPressed: () => showAbsBottomSheet<void>(
                    context: context,
                    builder: (context, controller) => ListView(
                      controller: controller,
                      padding: EdgeInsets.symmetric(horizontal: pad),
                      children: [
                        Text(l.galleryOpenSheet, style: t.title),
                        const SizedBox(height: AbsSpace.x2),
                        Text(l.gallerySheetBody, style: t.body.copyWith(color: c.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                child: AbsButton.secondary(
                  label: l.galleryShowSnackbar,
                  onPressed: () =>
                      showAbsSnackbar(context, l.gallerySnackbarMessage, tone: SnackTone.success, onUndo: () {}),
                ),
              ),
            ],
          ),
        ),
        label(l.galleryStateLoading),
        framed(220, const SkeletonList(itemCount: 3)),
        label(l.galleryStateEmpty),
        framed(
          320,
          EmptyState(
            title: l.staffEmptyTitle,
            message: l.galleryEmptyBody,
            actionLabel: l.galleryEmptyAction,
            onAction: () {},
            illustration: EmptyIllustration.search,
          ),
        ),
        label(l.galleryStateError),
        framed(220, ErrorState(message: l.gallerySampleError, onRetry: () {})),
      ],
    );
  }
}
