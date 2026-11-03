import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/presentation/exercise_ui.dart' show kg;
import '../application/workouts_providers.dart';
import '../domain/workout_models.dart';

/// Member progress (5.8): workouts per week, streak, adherence and the
/// latest personal records.
class WorkoutProgressCard extends ConsumerWidget {
  const WorkoutProgressCard({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final stats = ref.watch(workoutStatsProvider(memberId)).value;
    final logs = ref.watch(recentWorkoutsProvider(memberId)).value ?? const <WorkoutLog>[];
    final catalogue = ref.watch(exerciseCatalogueProvider).value;
    final perWeek = stats?.perWeek ?? List.filled(8, 0);
    final peak = perWeek.fold<int>(1, (a, b) => b > a ? b : a);
    final prs = [
      for (final log in logs)
        for (final s in log.sets.where((s) => s.isPr)) (log, s),
    ].take(3).toList();
    final p = c.pop(PopHue.bubblegum);
    return AbsCard(
      key: const ValueKey('workout-progress'),
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.meProgressWorkouts, style: t.heading)),
              PopSticker(label: '${l.wkStreak} ${stats?.streak ?? 0}', hue: PopHue.tangerine, numeric: true),
              if (stats?.adherence != null) ...[
                const SizedBox(width: AbsSpace.x1),
                PopSticker(label: l.trainAdherence((stats!.adherence! * 100).round()), hue: PopHue.mint),
              ],
            ],
          ),
          const SizedBox(height: AbsSpace.x3),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, n) in perWeek.indexed)
                  Expanded(
                    child: Semantics(
                      label: '$n',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: AbsMotion.expressive.duration,
                              height: 6 + 46 * (n / peak),
                              decoration: BoxDecoration(
                                color: i == perWeek.length - 1 ? c.accent : p.fill,
                                borderRadius: AbsRadius.chipAll,
                                border: Border.all(color: c.isDark ? p.deep : c.ink, width: 1.5),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text('$n', style: t.numericOf(t.caption)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AbsSpace.x3),
          Text(l.meProgressPrs, style: t.label.copyWith(color: c.textSecondary)),
          const SizedBox(height: AbsSpace.x1),
          if (prs.isEmpty)
            Text(l.meNoPrs, style: t.caption)
          else
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x1,
              children: [
                for (final (_, s) in prs)
                  PopSticker(
                    label:
                        '${catalogue?[s.exerciseId]?.name ?? '—'} ${s.weight != null && s.weight! > 0 ? kg(s.weight!) : ''}'
                            .trim(),
                    hue: PopHue.tangerine,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
