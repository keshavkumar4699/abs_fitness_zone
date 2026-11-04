import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/application/members_providers.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/diet_providers.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/nutrition.dart';
import 'assign_diet_sheet.dart';
import 'diet_share.dart';
import 'diet_tracking_ui.dart';
import 'diet_training_views.dart' show adherenceHue;
import 'diet_ui.dart';

/// Member detail → Diet (6.4, 6.7, 6.11) for the member's trainer and the
/// owner: health flag, preferences, the plan with adherence, today's meals,
/// the weekly chart with the weight trend, comments and earlier plans. Diet
/// data is private, so the front desk sees a note instead.
class MemberDietTab extends ConsumerWidget {
  const MemberDietTab({super.key, required this.member, required this.canCoach});

  final Member member;
  final bool canCoach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (!canCoach) {
      return EmptyState(
        title: l.tabDiet,
        message: l.dietPrivate,
        illustration: EmptyIllustration.search,
        hue: PopHue.mint,
      );
    }
    final diets = ref.watch(memberDietsProvider(member.id));
    final flags = ref.watch(dietFlagsProvider(member.id)).value;
    final stats = ref.watch(dietStatsProvider(member.id)).value;
    final logs = ref.watch(memberDietLogsProvider(member.id)).value ?? const DietLogs();
    final comments = ref.watch(dietCommentsProvider(member.id)).value ?? const <DietComment>[];
    final measurements = ref.watch(memberMeasurementsProvider(member.id)).value ?? const <Measurement>[];
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    final pad = EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x10);
    final t = context.text;
    final c = context.colors;

    Future<void> assign() => showPickAndAssignDiet(context, memberId: member.id, memberName: member.name);

    return AsyncView<List<MemberDiet>>(
      value: diets,
      onRetry: () => ref.invalidate(memberDietsProvider(member.id)),
      loading: const SkeletonList(itemCount: 4),
      isEmpty: (_) => false,
      empty: const SizedBox.shrink(),
      data: (list) {
        final current =
            list.where((d) => d.status == DietStatus.active).firstOrNull ??
            list.where((d) => d.status == DietStatus.queued).firstOrNull;
        final earlier = list.where((d) => !d.status.isCurrent).toList();
        final plan = current?.template;
        final today = IstDates.today();
        final adh = stats?.adherence7d;
        return ListView(
          padding: pad,
          children: [
            if (flags != null && flags.hasConditions) MedicalFlag(name: member.name, conditions: flags.conditions),
            AbsCard(
              key: const ValueKey('diet-preferences'),
              title: l.prefsTitle,
              action: flags == null
                  ? null
                  : IconButton(
                      key: const ValueKey('edit-preferences'),
                      tooltip: l.progEdit,
                      icon: Icon(PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold)),
                      onPressed: () => showPreferencesSheet(context, flags: flags),
                    ),
              padding: const EdgeInsets.all(AbsSpace.x4),
              child: flags == null ? const SizedBox(height: 26) : PreferenceStickers(flags: flags),
            ),
            const SizedBox(height: AbsSpace.x3),
            if (current == null || plan == null)
              EmptyState(
                title: l.dietNoPlanTitle,
                message: l.dietNoPlanStaffBody,
                illustration: EmptyIllustration.rocket,
                hue: PopHue.mint,
                actionLabel: l.dietAssign,
                onAction: assign,
              )
            else ...[
              AbsCard(
                key: const ValueKey('diet-summary'),
                hue: PopHue.mint,
                padding: const EdgeInsets.all(AbsSpace.x4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(current.name, style: t.title),
                              Text(
                                current.status == DietStatus.queued
                                    ? l.dietStarts(dateLabel(current.startDate!))
                                    : l.dietSince(dateLabel(current.startDate!)),
                                style: t.caption.copyWith(color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (adh != null)
                          ProgressRing(
                            progress: adh,
                            size: 64,
                            strokeWidth: 7,
                            hue: adherenceHue(adh),
                            semanticsLabel: l.trainAdherence((adh * 100).round()),
                            child: Text('${(adh * 100).round()}%', style: t.numericOf(t.label)),
                          ),
                      ],
                    ),
                    const SizedBox(height: AbsSpace.x2),
                    Wrap(
                      spacing: AbsSpace.x1,
                      runSpacing: AbsSpace.x1,
                      children: [
                        PopSticker(label: kcalText(plan.kcalTarget), hue: PopHue.lime),
                        if (plan.proteinG != null)
                          PopSticker(label: '${l.dietP} ${plan.proteinG} g', hue: PopHue.bubblegum),
                        if (stats != null && stats.missed7d > 0)
                          PopSticker(label: l.dietMissedMeals(stats.missed7d), hue: PopHue.tangerine),
                        if (stats != null)
                          PopSticker(
                            label: l.waterAverage(stats.waterAvg7d.toStringAsFixed(1), stats.waterGoal),
                            hue: PopHue.sky,
                          ),
                      ],
                    ),
                    const SizedBox(height: AbsSpace.x3),
                    Wrap(
                      spacing: AbsSpace.x2,
                      runSpacing: AbsSpace.x2,
                      children: [
                        AbsButton.secondary(
                          key: const ValueKey('tune-diet'),
                          label: l.dietTune,
                          icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                          expand: false,
                          onPressed: () async {
                            await context.push('${Routes.dietEdit(current.templateId)}?member=${member.id}');
                            ref.refreshDiet(member.id);
                          },
                        ),
                        AbsButton.secondary(
                          key: const ValueKey('assign-diet'),
                          label: l.dietAssign,
                          icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
                          expand: false,
                          onPressed: assign,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DietShareMenu(template: plan, memberName: member.name),
                  TextButton.icon(
                    key: const ValueKey('end-diet'),
                    icon: Icon(PhosphorIcons.stopCircle(PhosphorIconsStyle.bold), color: c.danger),
                    label: Text(l.dietEnd, style: TextStyle(color: c.danger)),
                    onPressed: () => _end(context, ref, current),
                  ),
                ],
              ),
              Text(l.dietToday, style: t.title),
              const SizedBox(height: AbsSpace.x2),
              MealTimeline(plan: plan, marks: logs.mealsOn(today), lookup: lookup),
              if (stats != null && stats.weekly.isNotEmpty) ...[
                const SizedBox(height: AbsSpace.x4),
                AdherenceWeightChart(weeks: stats.weekly, measurements: measurements),
              ],
            ],
            const SizedBox(height: AbsSpace.x4),
            DietCommentsCard(
              comments: comments,
              footer: _CommentBox(memberId: member.id),
            ),
            if (earlier.isNotEmpty) ...[
              const SizedBox(height: AbsSpace.x4),
              Text(l.dietHistory, style: t.title),
              const SizedBox(height: AbsSpace.x2),
              for (final d in earlier)
                Padding(
                  padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                  child: AbsCard(
                    padding: const EdgeInsets.all(AbsSpace.x3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name, style: t.heading),
                              Text(
                                [dateLabel(d.startDate!), if (d.endDate != null) dateLabel(d.endDate!)].join(' – '),
                                style: t.caption.copyWith(color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        PopSticker(label: dietStatusLabel(l, d.status), hue: PopHue.sky),
                      ],
                    ),
                  ),
                ),
            ],
            const DietDisclaimer(),
          ],
        );
      },
    );
  }

  Future<void> _end(BuildContext context, WidgetRef ref, MemberDiet d) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.dietEndTitle(d.name)),
        content: Text(l.dietEndBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.dietEnd, style: TextStyle(color: context.colors.danger)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(dietRepositoryProvider).endDiet(d.id);
      ref.refreshDiet(member.id);
      if (context.mounted) showAbsSnackbar(context, l.dietEnded, tone: SnackTone.success);
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }
}

class _CommentBox extends ConsumerStatefulWidget {
  const _CommentBox({required this.memberId});

  final String memberId;

  @override
  ConsumerState<_CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends ConsumerState<_CommentBox> {
  final _ctl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l = context.l10n;
    final body = _ctl.text.trim();
    if (body.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(dietRepositoryProvider).comment(widget.memberId, body);
      _ctl.clear();
      ref.invalidate(dietCommentsProvider(widget.memberId));
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        Expanded(
          child: AbsTextField(
            key: const ValueKey('diet-comment'),
            label: l.dietAddNote,
            controller: _ctl,
            maxLength: 500,
          ),
        ),
        IconButton(
          key: const ValueKey('diet-comment-send'),
          tooltip: l.commonSave,
          icon: Icon(PhosphorIcons.paperPlaneRight(PhosphorIconsStyle.fill)),
          onPressed: _busy ? null : _send,
        ),
      ],
    );
  }
}
