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
import '../../members/domain/models.dart';
import '../application/workouts_providers.dart';
import '../data/workouts_repository.dart';
import '../domain/workout_logic.dart';
import '../domain/workout_models.dart';
import 'assign_sheet.dart';
import 'template_detail_screen.dart' show ShareMenu;
import 'workout_ui.dart';

/// Member detail → Workouts (5.4, 5.5, 5.10, 5.11): the program with
/// adherence and streak, plan vs done, the logs with coach feedback. Coaches
/// assign, tune and end programs; the desk only sees the program.
class MemberWorkoutsTab extends ConsumerWidget {
  const MemberWorkoutsTab({super.key, required this.member, required this.canCoach});

  final Member member;
  final bool canCoach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final programs = ref.watch(memberProgramsProvider(member.id));
    final stats = canCoach ? ref.watch(workoutStatsProvider(member.id)).value : null;
    final logs = canCoach
        ? ref.watch(recentWorkoutsProvider(member.id)).value ?? const <WorkoutLog>[]
        : const <WorkoutLog>[];
    final history = canCoach ? ref.watch(workoutHistoryProvider(member.id)) : null;
    final pad = EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x10);

    Future<void> assign() async {
      await showPickAndAssign(context, memberId: member.id, memberName: member.name);
    }

    return AsyncView<List<MemberProgram>>(
      value: programs,
      onRetry: () => ref.invalidate(memberProgramsProvider(member.id)),
      loading: const SkeletonList(itemCount: 4),
      isEmpty: (_) => false,
      empty: const SizedBox.shrink(),
      data: (list) {
        final current =
            list.where((p) => p.status == ProgramStatus.active).firstOrNull ??
            list.where((p) => p.status == ProgramStatus.queued).firstOrNull;
        final today = IstDates.today();
        return ListView(
          padding: pad,
          children: [
            if (current == null)
              EmptyState(
                title: l.wkNoProgramTitle,
                message: canCoach ? l.wkNoProgramStaffBody : l.wkNoProgramBody,
                illustration: EmptyIllustration.dumbbell,
                hue: PopHue.bubblegum,
                actionLabel: canCoach ? l.wkAssign : null,
                onAction: canCoach ? assign : null,
              )
            else ...[
              ProgramSummaryCard(
                program: current,
                stats: stats,
                actions: [
                  if (canCoach)
                    AbsButton.secondary(
                      key: const ValueKey('tune-program'),
                      label: l.wkEditProgram,
                      icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                      expand: false,
                      onPressed: () async {
                        await context.push('${Routes.programEdit(current.templateId)}?member=${member.id}');
                        ref.refreshWorkouts(member.id);
                      },
                    ),
                  if (canCoach)
                    AbsButton.secondary(
                      label: l.wkAssign,
                      icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
                      expand: false,
                      onPressed: assign,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (current.template != null)
                    ShareMenu(template: current.template!, memberName: member.name, weekdays: current.weekdays),
                  if (canCoach)
                    TextButton.icon(
                      key: const ValueKey('end-program'),
                      icon: Icon(PhosphorIcons.stopCircle(PhosphorIconsStyle.bold), color: context.colors.danger),
                      label: Text(l.wkEndProgram, style: TextStyle(color: context.colors.danger)),
                      onPressed: () => _end(context, ref, current),
                    ),
                ],
              ),
              const SizedBox(height: AbsSpace.x2),
              for (final d in current.template?.orderedDays ?? const <WorkoutDay>[])
                ProgramDayCard(
                  day: d,
                  template: current.template,
                  week: programWeek(current, today),
                  hue: plannedDayOn(current, today)?.id == d.id ? PopHue.lime : null,
                ),
            ],
            if (canCoach) ...[
              const SizedBox(height: AbsSpace.x3),
              Text(l.wkCalendar, style: context.text.title),
              const SizedBox(height: AbsSpace.x2),
              PlanCalendar(program: current, logs: logs),
              const SizedBox(height: AbsSpace.x5),
              Text(l.wkHistory, style: context.text.title),
              const SizedBox(height: AbsSpace.x2),
              switch (history) {
                AsyncData(:final value) when value.items.isNotEmpty => Column(
                  children: [
                    for (final log in value.items)
                      WorkoutLogCard(
                        log: log,
                        onTap: () => showWorkoutLogSheet(context, log: log, canComment: true),
                      ),
                  ],
                ),
                AsyncError(:final error) => ErrorState(
                  message: friendlyError(l, error),
                  onRetry: () => ref.invalidate(workoutHistoryProvider(member.id)),
                ),
                AsyncData() => Text(l.wkNoWorkoutsBody, style: context.text.body),
                _ => const SizedBox(height: 160, child: SkeletonList(itemCount: 2)),
              },
            ],
          ],
        );
      },
    );
  }

  Future<void> _end(BuildContext context, WidgetRef ref, MemberProgram p) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.wkEndTitle(p.name)),
        content: Text(l.wkEndBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.wkEndProgram, style: TextStyle(color: context.colors.danger)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(workoutsRepositoryProvider).endProgram(p.id);
      ref.refreshWorkouts(member.id);
      if (context.mounted) showAbsSnackbar(context, l.wkEnded, tone: SnackTone.success);
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }
}
