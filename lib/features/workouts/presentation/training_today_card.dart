import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/presentation/widgets/member_photo.dart';
import '../application/workouts_providers.dart';
import '../domain/workout_models.dart';

/// Staff home for coaches (6.0): who trains today and who missed sessions.
class TrainingTodayCard extends ConsumerWidget {
  const TrainingTodayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final rows = ref.watch(coachListProvider(null, '')).value?.items;
    if (rows == null) return const SizedBox.shrink();
    final today = rows.where((r) => r.plannedToday).toList();
    final missed = rows.where((r) => r.missed7d > 0).toList()..sort((a, b) => b.missed7d.compareTo(a.missed7d));
    Widget person(CoachRow r, Widget trailing) => Semantics(
      button: true,
      child: InkWell(
        borderRadius: AbsRadius.buttonAll,
        onTap: () => context.push('${Routes.memberDetail(r.memberId)}?tab=workouts'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
          child: Row(
            children: [
              MemberPhoto(name: r.name, path: r.photoPath, size: 36),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (r.programName != null)
                      Text(r.programName!, style: t.caption.copyWith(color: c.textSecondary), maxLines: 1),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
    return AbsCard(
      key: const ValueKey('training-today'),
      hue: PopHue.bubblegum,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.dashTrainingToday, style: t.title),
            const SizedBox(height: AbsSpace.x2),
            if (today.isEmpty)
              Text(l.dashNoSessionsToday, style: t.body.copyWith(color: c.textSecondary))
            else
              for (final r in today.take(6))
                person(
                  r,
                  Icon(
                    r.doneToday
                        ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                        : PhosphorIcons.clock(PhosphorIconsStyle.bold),
                    color: r.doneToday ? c.success : c.textSecondary,
                    semanticLabel: r.doneToday ? l.wkDone : l.wkPlanned,
                  ),
                ),
            if (missed.isNotEmpty) ...[
              const SizedBox(height: AbsSpace.x3),
              Text(l.dashMissedWorkouts, style: t.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x1),
              for (final r in missed.take(5))
                person(r, PopSticker(label: l.dashMissedCount(r.missed7d), hue: PopHue.coral)),
            ],
          ],
        ),
      ),
    );
  }
}
