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
import '../../auth/application/auth_providers.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../../shell/member_shell.dart' show MemberHues;
import '../application/workouts_providers.dart';
import '../domain/workout_logic.dart';
import '../domain/workout_models.dart';
import 'template_detail_screen.dart' show ShareMenu;
import 'workout_ui.dart';

/// Starts (or resumes) a program day and opens the player.
Future<void> startWorkout(BuildContext context, WidgetRef ref, MemberProgram program, WorkoutDay day) async {
  try {
    await ref.read(activeWorkoutProvider.notifier).start(program: program, day: day);
    if (context.mounted) await context.push(Routes.mePlayer);
  } catch (e) {
    if (context.mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
  }
}

/// Today's workout on the member home and Workout tab (5.6).
class TodayWorkoutCard extends ConsumerWidget {
  const TodayWorkoutCard({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final stats = ref.watch(workoutStatsProvider(memberId));
    final running = ref.watch(activeWorkoutProvider);
    final s = stats.value;
    if (running != null && running.memberId == memberId) {
      final p = c.pop(PopHue.tangerine);
      return _Hero(
        key: const ValueKey('today-workout'),
        color: p,
        title: running.name,
        subtitle: l.playSetsDone(running.doneSets, running.totalSets),
        progress: running.progress,
        button: AbsButton(
          key: const ValueKey('resume-workout'),
          label: l.wkResume,
          hue: PopHue.grape,
          icon: PhosphorIcons.play(PhosphorIconsStyle.fill),
          onPressed: () => context.push(Routes.mePlayer),
        ),
      );
    }
    if (s == null) {
      return stats.hasError
          ? ErrorState(
              message: friendlyError(l, stats.error!),
              onRetry: () => ref.invalidate(workoutStatsProvider(memberId)),
            )
          : const SkeletonBlock(child: SizedBox(height: 150, width: double.infinity));
    }
    final program = s.program;
    if (program == null) {
      return AbsCard(
        key: const ValueKey('today-workout'),
        hue: MemberHues.workout,
        child: Row(
          children: [
            IconBubble(icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold), hue: MemberHues.workout),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.wkNoProgramTitle, style: t.heading),
                  Text(l.wkNoProgramBody, style: t.caption.copyWith(color: c.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final today = s.today;
    if (today != null && !s.doneToday) {
      final p = c.pop(PopHue.lime);
      return _Hero(
        key: const ValueKey('today-workout'),
        color: p,
        title: l.wkTodayWorkout(today.name),
        subtitle: [program.name, l.progExercises(today.items.length)].join(' · '),
        button: AbsButton(
          key: const ValueKey('start-workout'),
          label: l.wkStart,
          hue: PopHue.grape,
          icon: PhosphorIcons.play(PhosphorIconsStyle.fill),
          onPressed: () => startWorkout(context, ref, program, today),
        ),
      );
    }
    if (s.doneToday) {
      return AbsCard(
        key: const ValueKey('today-workout'),
        hue: PopHue.mint,
        solid: true,
        child: Row(
          children: [
            Icon(PhosphorIcons.confetti(PhosphorIconsStyle.fill), color: c.pop(PopHue.mint).onFill, size: 32),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Text(l.wkDoneToday, style: t.heading.copyWith(color: c.pop(PopHue.mint).onFill)),
            ),
          ],
        ),
      );
    }
    final next = s.next;
    return AbsCard(
      key: const ValueKey('today-workout'),
      hue: PopHue.sky,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBubble(icon: PhosphorIcons.moonStars(PhosphorIconsStyle.bold), hue: PopHue.sky),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.wkRestDay, style: t.heading),
                    if (next != null)
                      Text(
                        l.wkRestDayBody(next.day.name, dateLabel(next.date)),
                        style: t.caption.copyWith(color: c.textSecondary),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (next != null && program.status == ProgramStatus.active) ...[
            const SizedBox(height: AbsSpace.x3),
            AbsButton.ghost(
              label: l.wkStartNext(next.day.name),
              icon: PhosphorIcons.play(PhosphorIconsStyle.bold),
              onPressed: () => startWorkout(context, ref, program, next.day),
            ),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.button,
    this.progress,
  });

  final PopColor color;
  final String title;
  final String subtitle;
  final Widget button;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Container(
      padding: const EdgeInsets.all(AbsSpace.x5),
      decoration: stickerDecoration(c, color: color.fill, lip: c.isDark ? color.deep : c.ink),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.meTodayWorkout, style: t.label.copyWith(color: color.onFill)),
                    Text(title, style: t.displayL.copyWith(color: color.onFill, height: 1.1)),
                    Text(subtitle, style: t.label.copyWith(color: color.onFill)),
                  ],
                ),
              ),
              if (progress != null)
                ProgressRing(
                  progress: progress!,
                  size: 64,
                  strokeWidth: 7,
                  hue: PopHue.grape,
                  child: Text(
                    '${(progress! * 100).round()}%',
                    style: t.numericOf(t.label).copyWith(color: color.onFill),
                  ),
                )
              else
                Icon(PhosphorIcons.barbell(PhosphorIconsStyle.fill), size: 48, color: color.onFill),
            ],
          ),
          const SizedBox(height: AbsSpace.x4),
          button,
        ],
      ),
    );
  }
}

/// Member app → Workout tab: today, the program, plan vs done, history and
/// the exercise library.
class MyWorkoutScreen extends ConsumerWidget {
  const MyWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final memberId = ref.watch(currentUserProvider).value?.memberId;
    if (memberId == null) return const SizedBox.shrink();
    // Upload any workout finished while offline.
    ref.listen(syncWorkoutsProvider, (_, next) {
      if ((next.value ?? 0) > 0) ref.refreshWorkouts(memberId);
    });
    final stats = ref.watch(workoutStatsProvider(memberId)).value;
    final logs = ref.watch(recentWorkoutsProvider(memberId)).value ?? const <WorkoutLog>[];
    final history = ref.watch(workoutHistoryProvider(memberId));
    final program = stats?.program;
    final today = IstDates.today();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AbsRefresh(
          onRefresh: () async {
            ref
              ..invalidate(syncWorkoutsProvider)
              ..refreshWorkouts(memberId);
            await ref.read(workoutStatsProvider(memberId).future);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              context.screenPadding,
              AbsSpace.x4,
              context.screenPadding,
              MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.navWorkout,
                      style: context.text.displayL.copyWith(fontSize: context.text.title.fontSize! * 1.3),
                    ),
                  ),
                  if (program?.template != null) ShareMenu(template: program!.template!, weekdays: program.weekdays),
                ],
              ),
              const SizedBox(height: AbsSpace.x4),
              TodayWorkoutCard(memberId: memberId),
              const SizedBox(height: AbsSpace.x4),
              if (program != null) ...[
                ProgramSummaryCard(program: program, stats: stats),
                const SizedBox(height: AbsSpace.x4),
              ],
              AbsButton.secondary(
                key: const ValueKey('open-library'),
                label: l.wkLibrary,
                icon: PhosphorIcons.books(PhosphorIconsStyle.bold),
                onPressed: () => context.push(Routes.meExercises),
              ),
              if (program != null) ...[
                const SizedBox(height: AbsSpace.x5),
                Text(l.wkCalendar, style: context.text.title),
                const SizedBox(height: AbsSpace.x2),
                PlanCalendar(program: program, logs: logs),
                const SizedBox(height: AbsSpace.x5),
                Text(l.wkDays, style: context.text.title),
                const SizedBox(height: AbsSpace.x2),
                for (final d in program.template?.orderedDays ?? const <WorkoutDay>[])
                  ProgramDayCard(
                    day: d,
                    template: program.template,
                    week: programWeek(program, today),
                    hue: plannedDayOn(program, today)?.id == d.id ? PopHue.lime : null,
                    trailing: program.status == ProgramStatus.active
                        ? IconButton(
                            tooltip: l.wkStart,
                            icon: Icon(PhosphorIcons.playCircle(PhosphorIconsStyle.fill), size: 32),
                            onPressed: () => startWorkout(context, ref, program, d),
                          )
                        : null,
                  ),
              ],
              const SizedBox(height: AbsSpace.x5),
              Text(l.wkHistory, style: context.text.title),
              const SizedBox(height: AbsSpace.x2),
              switch (history) {
                AsyncData(:final value) when value.items.isNotEmpty => Column(
                  children: [
                    for (final log in value.items)
                      WorkoutLogCard(
                        log: log,
                        onTap: () => showWorkoutLogSheet(context, log: log, canComment: false),
                      ),
                  ],
                ),
                AsyncData() => EmptyState(
                  title: l.wkNoWorkoutsTitle,
                  message: l.wkNoWorkoutsBody,
                  illustration: EmptyIllustration.trophy,
                  hue: MemberHues.workout,
                ),
                AsyncError(:final error) => ErrorState(
                  message: friendlyError(l, error),
                  onRetry: () => ref.invalidate(workoutHistoryProvider(memberId)),
                ),
                _ => const SizedBox(height: 160, child: SkeletonList(itemCount: 2)),
              },
            ],
          ),
        ),
      ),
    );
  }
}
