import 'dart:async';

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
import '../../members/application/members_providers.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../../members/presentation/widgets/member_photo.dart';
import '../../settings/data/staff_repository.dart';
import '../application/workouts_providers.dart';
import '../domain/workout_models.dart';

/// "My members" for trainers, everyone (filterable by trainer) for the
/// owner: program, last workout, workouts this week and adherence (5.5).
class CoachMembersView extends ConsumerStatefulWidget {
  const CoachMembersView({super.key, this.footerPad = 0});

  final double footerPad;

  @override
  ConsumerState<CoachMembersView> createState() => _CoachMembersViewState();
}

class _CoachMembersViewState extends ConsumerState<CoachMembersView> {
  String _search = '';
  String? _trainer;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final trainers = owner ? (ref.watch(trainersProvider).value ?? const <StaffMember>[]) : const <StaffMember>[];
    final list = ref.watch(coachListProvider(_trainer, _search));
    return AbsRefresh(
      onRefresh: () => ref.refresh(coachListProvider(_trainer, _search).future),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 500) ref.read(coachListProvider(_trainer, _search).notifier).loadMore();
          return false;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, widget.footerPad + AbsSpace.x6),
          children: [
            AbsTextField(
              label: l.trainSearchMembers,
              suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(AbsMotion.standard.duration, () => setState(() => _search = v.trim()));
              },
            ),
            if (owner && trainers.isNotEmpty) ...[
              const SizedBox(height: AbsSpace.x3),
              SizedBox(
                height: AbsSize.touchTarget,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PopChip(
                      label: l.trainAllTrainers,
                      selected: _trainer == null,
                      hue: PopHue.bubblegum,
                      onTap: () => setState(() => _trainer = null),
                    ),
                    for (final t in trainers) ...[
                      const SizedBox(width: AbsSpace.x2),
                      PopChip(
                        label: t.name,
                        selected: _trainer == t.id,
                        hue: PopHue.bubblegum,
                        onTap: () => setState(() => _trainer = t.id),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: AbsSpace.x4),
            switch (list) {
              AsyncData(:final value) when value.items.isNotEmpty => Column(
                children: [
                  for (final (i, r) in value.items.indexed)
                    Entrance(
                      index: i,
                      child: _CoachTile(row: r),
                    ),
                ],
              ),
              AsyncData() => EmptyState(
                title: l.trainEmptyMembersTitle,
                message: l.trainEmptyMembersBody,
                illustration: EmptyIllustration.people,
                hue: PopHue.bubblegum,
              ),
              AsyncError(:final error) => ErrorState(
                message: friendlyError(l, error),
                onRetry: () => ref.invalidate(coachListProvider(_trainer, _search)),
              ),
              _ => const SizedBox(height: 400, child: SkeletonList(itemCount: 5)),
            },
          ],
        ),
      ),
    );
  }
}

class _CoachTile extends StatelessWidget {
  const _CoachTile({required this.row});

  final CoachRow row;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final r = row;
    final adh = r.adherence;
    final adhHue = adh == null
        ? PopHue.sky
        : adh >= 0.75
        ? PopHue.mint
        : adh >= 0.5
        ? PopHue.tangerine
        : PopHue.coral;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        key: ValueKey('coach-${r.memberId}'),
        onTap: () => context.push('${Routes.memberDetail(r.memberId)}?tab=workouts'),
        padding: const EdgeInsets.all(AbsSpace.x3),
        child: Row(
          children: [
            MemberPhoto(name: r.name, path: r.photoPath, size: 46),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    r.lastWorkoutAt == null
                        ? l.trainNeverWorkedOut
                        : l.trainLastWorkout(dateLabel(IstDates.istDate(r.lastWorkoutAt!))),
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AbsSpace.x1),
                  Wrap(
                    spacing: AbsSpace.x1,
                    runSpacing: AbsSpace.x1,
                    children: [
                      PopSticker(
                        label: r.programName ?? l.trainNoProgram,
                        hue: r.programName == null ? PopHue.coral : PopHue.lime,
                      ),
                      if (r.programStatus == ProgramStatus.queued) PopSticker(label: l.wkQueued, hue: PopHue.sky),
                      PopSticker(label: l.trainThisWeek(r.workouts7d), hue: PopHue.grape),
                    ],
                  ),
                ],
              ),
            ),
            if (adh != null)
              ProgressRing(
                progress: adh,
                size: 54,
                strokeWidth: 6,
                hue: adhHue,
                semanticsLabel: l.trainAdherence((adh * 100).round()),
                child: Text('${(adh * 100).round()}%', style: t.numericOf(t.label)),
              ),
          ],
        ),
      ),
    );
  }
}
