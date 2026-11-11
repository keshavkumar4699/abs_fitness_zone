import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/presentation/exercise_ui.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/workouts_providers.dart';
import '../data/workouts_repository.dart';
import '../domain/workout_logic.dart';
import '../domain/workout_models.dart';

String blockLabel(AppLocalizations l, ItemBlock b) => switch (b) {
  ItemBlock.warmup => l.blockWarmup,
  ItemBlock.main => l.blockMain,
  ItemBlock.cooldown => l.blockCooldown,
};

String progressionLabel(AppLocalizations l, WorkoutTemplate t) {
  final step = t.progressionStep ?? 0;
  final s = step % 1 == 0 ? step.toInt().toString() : step.toStringAsFixed(1);
  return switch (t.progression) {
    Progression.weight when step > 0 => l.progProgressionWeight(s),
    Progression.reps when step > 0 => l.progProgressionReps(s),
    _ => l.progProgressionNone,
  };
}

/// "3 × 8–10 @ 40 kg · rest 1 min 30 s"
String itemSummary(
  AppLocalizations l,
  WorkoutItem i, {
  TrackingType? tracking,
  ({double? weight, int? reps, int? repsMax})? target,
}) {
  final reps = target?.reps ?? i.reps;
  final repsMax = target?.repsMax ?? i.repsMax;
  final weight = target?.weight ?? i.targetWeight;
  final timed = tracking?.usesTime ?? (i.durationS != null && reps == null);
  final parts = <String>[
    if (timed && i.durationS != null)
      l.itemSetsTime(i.sets, durationLabel(i.durationS!))
    else
      l.itemSetsReps(i.sets, repsMax == null || reps == null ? '${reps ?? '—'}' : '$reps–$repsMax'),
    if (weight != null && weight > 0) l.itemAt(kg(weight)),
  ];
  final extra = <String>[
    if (i.restS > 0) l.itemRest(durationLabel(i.restS)),
    if (i.rpe != null) l.itemRpe(i.rpe!.toStringAsFixed(i.rpe! % 1 == 0 ? 0 : 1)),
    if (i.tempo != null) l.itemTempo(i.tempo!),
  ];
  return [parts.join(' '), ...extra].join(' · ');
}

/// One exercise line in a program day (view mode).
class ProgramItemRow extends ConsumerWidget {
  const ProgramItemRow({super.key, required this.item, this.week = 1, this.template});

  final WorkoutItem item;
  final int week;
  final WorkoutTemplate? template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final ex = ref.watch(exerciseCatalogueProvider).value?[item.exerciseId];
    final target = template == null ? null : progressedTarget(item, template!, week);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AbsRadius.chipAll,
            child: SizedBox(
              width: 44,
              height: 44,
              child: ExerciseImage(path: ex?.images.firstOrNull, hue: muscleHue(ex?.primaryMuscle), size: 44),
            ),
          ),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex?.name ?? '—', style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  itemSummary(l, item, tracking: ex?.trackingType, target: target),
                  style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (item.groupKey != null) ...[
            const SizedBox(width: AbsSpace.x2),
            PopSticker(label: l.superset(item.groupKey!), hue: PopHue.grape),
          ] else if (item.block != ItemBlock.main) ...[
            const SizedBox(width: AbsSpace.x2),
            PopSticker(
              label: blockLabel(l, item.block),
              hue: item.block == ItemBlock.warmup ? PopHue.tangerine : PopHue.sky,
            ),
          ],
        ],
      ),
    );
  }
}

/// A program day as a card with its exercises.
class ProgramDayCard extends StatelessWidget {
  const ProgramDayCard({super.key, required this.day, this.template, this.week = 1, this.trailing, this.hue});

  final WorkoutDay day;
  final WorkoutTemplate? template;
  final int week;
  final Widget? trailing;
  final PopHue? hue;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        hue: hue,
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PopSticker(label: l.buildDay(day.dayIndex), hue: PopHue.lime),
                const SizedBox(width: AbsSpace.x2),
                Expanded(
                  child: Text(day.name, style: context.text.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: AbsSpace.x2),
            for (final i in day.ordered) ProgramItemRow(item: i, template: template, week: week),
          ],
        ),
      ),
    );
  }
}

/// Program header: name, dates, week, adherence, streak (5.5, 5.8).
class ProgramSummaryCard extends StatelessWidget {
  const ProgramSummaryCard({super.key, required this.program, this.stats, this.actions = const []});

  final MemberProgram program;
  final WorkoutStats? stats;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final today = IstDates.today();
    final weeks = program.template?.weeks ?? 1;
    final queued = program.status == ProgramStatus.queued;
    final p = c.pop(queued ? PopHue.sky : PopHue.lime);
    return Container(
      key: const ValueKey('program-summary'),
      padding: const EdgeInsets.all(AbsSpace.x5),
      decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(program.name, style: t.title.copyWith(color: p.onFill)),
              ),
              PopSticker(
                label: queued ? l.wkQueued : l.wkWeekOf(programWeek(program, today, weeks: weeks), weeks),
                hue: PopHue.grape,
              ),
            ],
          ),
          Text(
            queued ? l.wkStartsOn(dateLabel(program.startDate)) : l.wkEnds(dateLabel(program.endDate)),
            style: t.label.copyWith(color: p.onFill),
          ),
          const SizedBox(height: AbsSpace.x2),
          Wrap(
            spacing: AbsSpace.x1,
            children: [for (final d in program.weekdays) PopSticker(label: weekdayShort(l, d), hue: PopHue.sky)],
          ),
          if (stats != null && !queued) ...[
            const SizedBox(height: AbsSpace.x4),
            Row(
              children: [
                Expanded(
                  child: _HeroStat(
                    label: l.wkAdherence,
                    value: stats!.adherence == null ? '—' : '${(stats!.adherence! * 100).round()}%',
                    color: p.onFill,
                  ),
                ),
                Expanded(
                  child: _HeroStat(label: l.wkStreak, value: '${stats!.streak}', color: p.onFill),
                ),
                Expanded(
                  child: _HeroStat(
                    label: l.wkThisWeek,
                    value: '${stats!.perWeek.isEmpty ? 0 : stats!.perWeek.last}',
                    color: p.onFill,
                  ),
                ),
              ],
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: AbsSpace.x4),
            Wrap(spacing: AbsSpace.x2, runSpacing: AbsSpace.x2, children: actions),
          ],
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: context.text.caption.copyWith(color: color)),
      Text(value, style: context.text.numericOf(context.text.displayL).copyWith(color: color, height: 1.1)),
    ],
  );
}

/// Month grid of planned vs completed workouts (5.11).
class PlanCalendar extends StatefulWidget {
  const PlanCalendar({super.key, required this.program, required this.logs});

  final MemberProgram? program;
  final List<WorkoutLog> logs;

  @override
  State<PlanCalendar> createState() => _PlanCalendarState();
}

class _PlanCalendarState extends State<PlanCalendar> {
  late DateTime _month = () {
    final t = IstDates.today();
    return DateTime.utc(t.year, t.month);
  }();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final today = IstDates.today();
    final first = _month;
    final daysIn = DateTime.utc(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1;
    final done = {for (final x in widget.logs) x.day ?? IstDates.istDate(x.startedAt)};
    final planned = widget.program == null
        ? const <DateTime>{}
        : {
            for (final s in plannedSessions(widget.program!, first, DateTime.utc(first.year, first.month, daysIn)))
              s.date,
          };
    final monthLabel = MaterialLocalizations.of(context).formatMonthYear(first);
    Widget dot(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AbsSpace.x1),
        Text(label, style: t.caption),
      ],
    );
    return AbsCard(
      key: const ValueKey('plan-calendar'),
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.previousMonth,
                icon: Icon(PhosphorIcons.caretLeft(PhosphorIconsStyle.bold)),
                onPressed: () => setState(() => _month = DateTime.utc(first.year, first.month - 1)),
              ),
              Expanded(
                child: Text(monthLabel, style: t.heading, textAlign: TextAlign.center),
              ),
              IconButton(
                tooltip: l.nextMonth,
                icon: Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold)),
                onPressed: () => setState(() => _month = DateTime.utc(first.year, first.month + 1)),
              ),
            ],
          ),
          Row(
            children: [
              for (var d = 1; d <= 7; d++)
                Expanded(
                  child: Text(
                    weekdayShort(l, d).substring(0, 1),
                    textAlign: TextAlign.center,
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AbsSpace.x1),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (var i = 0; i < lead; i++) const SizedBox.shrink(),
              for (var d = 1; d <= daysIn; d++)
                () {
                  final day = DateTime.utc(first.year, first.month, d);
                  final isDone = done.contains(day);
                  final isPlanned = planned.contains(day);
                  final missed = isPlanned && !isDone && day.isBefore(today);
                  final p = c.pop(
                    isDone
                        ? PopHue.lime
                        : missed
                        ? PopHue.coral
                        : PopHue.sky,
                  );
                  final semantic = [
                    dateLabel(day),
                    if (isDone) l.wkDone else if (missed) l.wkMissed else if (isPlanned) l.wkPlanned,
                  ].join(', ');
                  return Semantics(
                    label: semantic,
                    excludeSemantics: true,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDone || missed ? p.fill : (isPlanned ? p.soft : null),
                        borderRadius: AbsRadius.chipAll,
                        border: day == today ? Border.all(color: c.isDark ? c.textPrimary : c.ink, width: 2) : null,
                      ),
                      child: Text(
                        '$d',
                        style: t.numericOf(t.label).copyWith(color: isDone || missed ? p.onFill : null),
                      ),
                    ),
                  );
                }(),
            ],
          ),
          const SizedBox(height: AbsSpace.x3),
          Wrap(
            spacing: AbsSpace.x4,
            children: [
              dot(c.pop(PopHue.sky).soft, l.wkPlanned),
              dot(c.pop(PopHue.lime).fill, l.wkDone),
              dot(c.pop(PopHue.coral).fill, l.wkMissed),
            ],
          ),
        ],
      ),
    );
  }
}

/// One logged workout: name, date, time, volume, PRs, coach notes.
class WorkoutLogCard extends StatelessWidget {
  const WorkoutLogCard({super.key, required this.log, required this.onTap});

  final WorkoutLog log;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final prs = log.prCount;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Row(
          children: [
            IconBubble(
              icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold),
              hue: log.status == 'partial' ? PopHue.tangerine : PopHue.lime,
              size: 40,
            ),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.name, style: t.heading),
                  Text(
                    [
                      dateLabel(log.day),
                      l.wkDuration((log.durationS / 60).round()),
                      if ((log.totalVolume ?? 0) > 0) l.wkVolume((log.totalVolume!).round().toString()),
                    ].join(' · '),
                    style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                  ),
                  if (prs > 0 || log.comments.isNotEmpty || log.status == 'partial') ...[
                    const SizedBox(height: AbsSpace.x1),
                    Wrap(
                      spacing: AbsSpace.x1,
                      runSpacing: AbsSpace.x1,
                      children: [
                        if (prs > 0) PopSticker(label: l.wkPrs(prs), hue: PopHue.tangerine),
                        if (log.status == 'partial') PopSticker(label: l.wkPartial, hue: PopHue.sky),
                        if (log.comments.isNotEmpty)
                          PopSticker(label: '${l.wkComments} ${log.comments.length}', hue: PopHue.grape),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall, color: c.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Coach reactions (5.10) as icons in the design's set.
(IconData, PopHue) reactionLook(String key) => switch (key) {
  'fire' => (PhosphorIcons.fire(PhosphorIconsStyle.fill), PopHue.coral),
  'muscle' => (PhosphorIcons.handFist(PhosphorIconsStyle.fill), PopHue.tangerine),
  'clap' => (PhosphorIcons.handsClapping(PhosphorIconsStyle.fill), PopHue.bubblegum),
  'star' => (PhosphorIcons.star(PhosphorIconsStyle.fill), PopHue.lime),
  _ => (PhosphorIcons.thumbsUp(PhosphorIconsStyle.fill), PopHue.sky),
};

/// Sets by exercise with PR badges, the coach's notes, and (for coaches) a
/// reaction row and comment box (5.10).
Future<void> showWorkoutLogSheet(BuildContext context, {required WorkoutLog log, required bool canComment}) =>
    showAbsBottomSheet<void>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _LogSheet(controller: controller, log: log, canComment: canComment),
    );

class _LogSheet extends ConsumerStatefulWidget {
  const _LogSheet({required this.controller, required this.log, required this.canComment});

  final ScrollController controller;
  final WorkoutLog log;
  final bool canComment;

  @override
  ConsumerState<_LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends ConsumerState<_LogSheet> {
  final _text = TextEditingController();
  late List<WorkoutComment> _comments = widget.log.comments;
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send({String? emoji}) async {
    final l = context.l10n;
    final body = _text.text.trim();
    if (emoji == null && body.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(workoutsRepositoryProvider)
          .comment(widget.log.id, body: emoji == null ? body : null, emoji: emoji);
      final me = ref.read(currentUserProvider).value?.name ?? '';
      setState(() {
        _comments = [
          ..._comments,
          WorkoutComment(
            id: 'local-${_comments.length}',
            authorName: me,
            body: emoji == null ? body : null,
            emoji: emoji,
            createdAt: ref.read(clockProvider)(),
          ),
        ];
        _text.clear();
      });
      ref.refreshWorkouts(widget.log.memberId);
      if (mounted) showAbsSnackbar(context, l.wkReacted, tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final log = widget.log;
    final catalogue = ref.watch(exerciseCatalogueProvider).value;
    final byExercise = <String, List<SetLog>>{};
    final isMember = ref.watch(currentUserProvider).value?.role == UserRole.member;
    for (final s in log.sets) {
      byExercise.putIfAbsent(s.exerciseId, () => []).add(s);
    }
    String setText(SetLog s) => [
      if (s.weight != null && s.weight! > 0) kg(s.weight!),
      if (s.reps != null) '× ${s.reps}',
      if (s.durationS != null) durationLabel(s.durationS!),
      if (s.distanceM != null) '${s.distanceM} m',
    ].join(' ');
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x8),
      children: [
        Text(l.wkLogTitle(log.name, dateLabel(log.day)), style: t.title),
        Text(
          [
            l.wkDuration((log.durationS / 60).round()),
            if ((log.totalVolume ?? 0) > 0) l.wkVolume(log.totalVolume!.round().toString()),
          ].join(' · '),
          style: t.caption.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AbsSpace.x4),
        for (final e in byExercise.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x3),
            child: AbsCard(
              padding: const EdgeInsets.all(AbsSpace.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(catalogue?[e.key]?.name ?? '—', style: t.heading),
                  const SizedBox(height: AbsSpace.x1),
                  Wrap(
                    spacing: AbsSpace.x2,
                    runSpacing: AbsSpace.x1,
                    children: [
                      for (final s in e.value..sort((a, b) => a.setNo.compareTo(b.setNo)))
                        PopSticker(
                          label: '${s.isPr ? 'PR · ' : ''}${setText(s)}',
                          hue: s.isPr ? PopHue.tangerine : PopHue.sky,
                          numeric: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AbsSpace.x2),
        Text(l.wkComments, style: t.title),
        const SizedBox(height: AbsSpace.x2),
        for (final cm in _comments)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x2),
            child: AbsCard(
              hue: PopHue.grape,
              padding: const EdgeInsets.all(AbsSpace.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AbsAvatar(name: cm.authorName, size: 32),
                  const SizedBox(width: AbsSpace.x2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cm.authorName, style: t.label),
                        if (cm.body != null) Text(cm.body!, style: t.body),
                      ],
                    ),
                  ),
                  if (cm.emoji != null)
                    IconBubble(icon: reactionLook(cm.emoji!).$1, hue: reactionLook(cm.emoji!).$2, size: 36),
                ],
              ),
            ),
          ),
        if (!widget.canComment && log.editableAt(ref.watch(clockProvider)())) ...[
          const SizedBox(height: AbsSpace.x3),
          Text(
            l.wkEditable(IstDates.formatDateTime(log.finishedAt.add(const Duration(hours: 24)))),
            style: t.caption.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AbsSpace.x2),
          AbsButton.secondary(
            key: const ValueKey('edit-workout'),
            label: l.wkEditWorkout,
            icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
            onPressed: () async {
              final router = GoRouter.of(context);
              final nav = Navigator.of(context);
              await ref.read(activeWorkoutProvider.notifier).edit(log);
              nav.pop();
              await router.push(Routes.mePlayer);
            },
          ),
        ],
        if (widget.canComment) ...[
          const SizedBox(height: AbsSpace.x2),
          Wrap(
            spacing: AbsSpace.x2,
            children: [
              for (final r in kReactions)
                Semantics(
                  button: true,
                  label: r,
                  child: InkWell(
                    key: ValueKey('react-$r'),
                    borderRadius: AbsRadius.pill,
                    onTap: _busy ? null : () => _send(emoji: r),
                    child: Padding(
                      padding: const EdgeInsets.all(AbsSpace.x1),
                      child: IconBubble(icon: reactionLook(r).$1, hue: reactionLook(r).$2, size: 44),
                    ),
                  ),
                ),
            ],
          ),
        ],
        // Members reply to their coach in words; reactions are the coach's.
        if (widget.canComment || isMember) ...[
          const SizedBox(height: AbsSpace.x2),
          Row(
            children: [
              Expanded(
                child: AbsTextField(
                  key: const ValueKey('comment-field'),
                  label: widget.canComment ? l.wkCommentHint : l.wkReplyHint,
                  controller: _text,
                ),
              ),
              const SizedBox(width: AbsSpace.x2),
              AbsButton(
                key: const ValueKey('comment-send'),
                label: l.wkSend,
                hue: PopHue.grape,
                expand: false,
                isLoading: _busy,
                onPressed: () => _send(),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
