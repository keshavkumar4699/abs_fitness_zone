import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../workouts/application/workouts_providers.dart';
import '../../workouts/data/workouts_repository.dart';
import '../application/exercise_providers.dart';
import '../data/exercise_repository.dart';
import '../domain/exercise.dart';
import 'exercise_ui.dart';

/// Exercise detail (4.4): alternating start/end images, muscles worked,
/// steps, tips, mistakes, YouTube, alternatives, and the member's own
/// progress (5.8).
class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId, required this.basePath, this.memberId});

  final String exerciseId;

  /// Where sibling exercises open ('/staff/plans/exercises' or '/me/exercises').
  final String basePath;

  /// Whose progress to show (the signed-in member by default).
  final String? memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final catalogue = ref.watch(exerciseCatalogueProvider);
    final e = catalogue.value?[exerciseId];
    final user = ref.watch(currentUserProvider).value;
    final fav = ref.watch(favouriteExercisesProvider).value?.contains(exerciseId) ?? false;
    final canEdit =
        e != null &&
        user != null &&
        (user.role.isOwner || (user.role == UserRole.trainer && e.isCustom && e.createdBy == user.userId)) &&
        e.isCustom;
    final progressFor = memberId ?? (user?.role == UserRole.member ? user?.memberId : null);
    return Scaffold(
      appBar: AppBar(
        title: Text(e?.name ?? l.exTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (e != null)
            IconButton(
              tooltip: fav ? l.exUnstar : l.exStar,
              icon: Icon(
                fav ? PhosphorIcons.star(PhosphorIconsStyle.fill) : PhosphorIcons.star(PhosphorIconsStyle.bold),
                color: fav ? context.colors.pop(PopHue.tangerine).text : null,
              ),
              onPressed: () =>
                  ref.read(favouriteExercisesProvider.notifier).toggle(exerciseId).catchError((Object _) {}),
            ),
          if (canEdit)
            PopupMenuButton<String>(
              tooltip: l.actionMore,
              onSelected: (a) async {
                if (a == 'edit') {
                  await context.push('$basePath/$exerciseId/edit');
                  return;
                }
                try {
                  await ref.read(exerciseRepositoryProvider).archive(exerciseId);
                  ref.invalidate(exerciseCatalogueProvider);
                  if (!context.mounted) return;
                  showAbsSnackbar(context, l.exArchived, tone: SnackTone.success);
                  context.pop();
                } catch (err) {
                  if (context.mounted) showAbsSnackbar(context, friendlyError(l, err), tone: SnackTone.error);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: Text(l.exEdit)),
                PopupMenuItem(
                  value: 'archive',
                  child: Text(l.exArchive, style: TextStyle(color: context.colors.danger)),
                ),
              ],
            ),
        ],
      ),
      body: AsyncView<ExerciseIndex>(
        value: catalogue,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(exerciseCatalogueProvider),
        loading: const SkeletonList(itemCount: 4),
        data: (index) {
          final ex = index[exerciseId];
          if (ex == null) {
            return ErrorState(
              message: friendlyError(l, const NotFoundFailure()),
              onRetry: () => ref.invalidate(exerciseCatalogueProvider),
            );
          }
          return _Body(exercise: ex, index: index, basePath: basePath, memberId: progressFor);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.exercise, required this.index, required this.basePath, this.memberId});

  final Exercise exercise;
  final ExerciseIndex index;
  final String basePath;
  final String? memberId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = exercise;
    final hue = muscleHue(e.primaryMuscle);
    final alts = index.alternatives(e);
    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.title),
          const SizedBox(height: AbsSpace.x2),
          child,
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(
        context.screenPadding,
        AbsSpace.x2,
        context.screenPadding,
        MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
      ),
      children: [
        ExerciseFrames(exercise: e, heroTag: 'exercise-${e.id}', height: 240),
        const SizedBox(height: AbsSpace.x4),
        Text(e.name, style: t.displayL),
        if (e.localName != null) Text(e.localName!, style: t.heading.copyWith(color: c.textSecondary)),
        const SizedBox(height: AbsSpace.x3),
        Wrap(
          spacing: AbsSpace.x2,
          runSpacing: AbsSpace.x2,
          children: [
            if (e.primaryMuscle != null) PopSticker(label: muscleLabel(l, e.primaryMuscle!), hue: hue),
            PopSticker(label: equipmentLabel(l, e.equipment), hue: PopHue.mint),
            if (e.level != null) PopSticker(label: exerciseLevelLabel(l, e.level), hue: PopHue.sky),
            PopSticker(label: categoryLabel(l, e.category), hue: PopHue.bubblegum),
            PopSticker(label: trackingLabel(l, e.trackingType), hue: PopHue.grape),
            if (e.isCustom) PopSticker(label: l.exCustom, hue: PopHue.tangerine),
          ],
        ),
        if (e.videoUrl != null) ...[
          const SizedBox(height: AbsSpace.x4),
          AbsButton.secondary(
            label: l.exWatchVideo,
            icon: PhosphorIcons.youtubeLogo(PhosphorIconsStyle.bold),
            onPressed: () => launchUrl(Uri.parse(e.videoUrl!), mode: LaunchMode.externalApplication),
          ),
        ],
        if (memberId != null) _Progress(memberId: memberId!, exercise: e),
        section(
          l.exMuscles,
          AbsCard(
            padding: const EdgeInsets.all(AbsSpace.x3),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BodyMap(
                        back: false,
                        height: 180,
                        primary: e.primaryMuscles.toSet(),
                        secondary: e.secondaryMuscles.toSet(),
                      ),
                    ),
                    Expanded(
                      child: BodyMap(
                        back: true,
                        height: 180,
                        primary: e.primaryMuscles.toSet(),
                        secondary: e.secondaryMuscles.toSet(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AbsSpace.x2),
                Wrap(
                  spacing: AbsSpace.x2,
                  runSpacing: AbsSpace.x2,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final m in e.primaryMuscles)
                      PopSticker(label: '${l.exPrimary}: ${muscleLabel(l, m)}', hue: PopHue.lime),
                    for (final m in e.secondaryMuscles)
                      PopSticker(label: '${l.exSecondary}: ${muscleLabel(l, m)}', hue: muscleHue(m)),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (e.instructions.isNotEmpty)
          section(
            l.exInstructions,
            Column(
              children: [
                for (final (i, step) in e.instructions.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: stickerDecoration(
                            c,
                            color: c.pop(hue).fill,
                            lipDepth: 2,
                            borderRadius: AbsRadius.pill,
                          ),
                          child: Text('${i + 1}', style: t.numericOf(t.label).copyWith(color: c.pop(hue).onFill)),
                        ),
                        const SizedBox(width: AbsSpace.x3),
                        Expanded(child: Text(step, style: t.body)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (e.tips != null)
          section(
            l.exTips,
            AbsCard(
              hue: PopHue.mint,
              child: Text(e.tips!, style: t.body),
            ),
          ),
        if (e.mistakes != null)
          section(
            l.exMistakes,
            AbsCard(
              hue: PopHue.coral,
              child: Text(e.mistakes!, style: t.body),
            ),
          ),
        if (alts.isNotEmpty)
          section(
            l.exAlternatives,
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: alts.length,
                separatorBuilder: (_, _) => const SizedBox(width: AbsSpace.x3),
                itemBuilder: (context, i) {
                  final a = alts[i];
                  return SizedBox(
                    width: 140,
                    child: AbsCard(
                      onTap: () => context.pushReplacement('$basePath/${a.id}'),
                      padding: const EdgeInsets.all(AbsSpace.x2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: AbsRadius.chipAll,
                            child: SizedBox(
                              height: 84,
                              width: double.infinity,
                              child: ExerciseImage(
                                path: a.images.firstOrNull,
                                hue: muscleHue(a.primaryMuscle),
                                size: 140,
                              ),
                            ),
                          ),
                          const SizedBox(height: AbsSpace.x1),
                          Text(a.name, style: t.label, maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text(
                            equipmentLabel(l, a.equipment),
                            style: t.caption.copyWith(color: c.textSecondary),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// Best weight, estimated 1RM and the trend of the best set per session.
class _Progress extends ConsumerWidget {
  const _Progress({required this.memberId, required this.exercise});

  final String memberId;
  final Exercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final history = ref.watch(exerciseHistoryProvider(memberId, exercise.id));
    return Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x5),
      child: AbsCard(
        key: const ValueKey('exercise-progress'),
        title: l.exYourProgress,
        hue: PopHue.lime,
        child: AsyncView<List<DatedSet>>(
          value: history,
          onRetry: () => ref.invalidate(exerciseHistoryProvider(memberId, exercise.id)),
          loading: const SizedBox(height: 80, child: SkeletonList(itemCount: 1)),
          isEmpty: (v) => v.isEmpty,
          empty: Text(l.exNoHistory, style: t.body),
          data: (sets) {
            final byDay = <DateTime, double>{};
            for (final d in sets) {
              final v = d.set.e1rm ?? (d.set.weight ?? 0) * (1 + (d.set.reps ?? 0) / 30);
              byDay.update(d.day, (x) => v > x ? v : x, ifAbsent: () => v);
            }
            final bestWeight = sets.map((d) => d.set.weight ?? 0).fold<double>(0, (a, b) => b > a ? b : a);
            final bestE1rm = byDay.values.fold<double>(0, (a, b) => b > a ? b : a);
            final days = byDay.keys.toList()..sort();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(label: l.exBestWeight, value: bestWeight > 0 ? kg(bestWeight) : '—'),
                    ),
                    Expanded(
                      child: _Stat(label: l.exBestE1rm, value: bestE1rm > 0 ? kg((bestE1rm * 10).round() / 10) : '—'),
                    ),
                    Expanded(
                      child: _Stat(label: l.wkHistory, value: l.exSessions(days.length)),
                    ),
                  ],
                ),
                if (days.length > 1) ...[
                  const SizedBox(height: AbsSpace.x3),
                  SizedBox(height: 64, child: Sparkline(values: [for (final d in days) byDay[d]!])),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: context.text.caption.copyWith(color: context.colors.textSecondary)),
      Text(value, style: context.text.numericOf(context.text.title)),
    ],
  );
}
