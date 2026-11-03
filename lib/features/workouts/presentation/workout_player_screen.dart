import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/providers.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/presentation/exercise_ui.dart';
import '../application/workouts_providers.dart';
import '../domain/workout_models.dart';
import '../domain/workout_session.dart';
import 'workout_ui.dart';

String _clock(Duration d) {
  final s = d.inSeconds < 0 ? 0 : d.inSeconds;
  final h = s ~/ 3600, m = (s % 3600) ~/ 60, sec = s % 60;
  final mm = m.toString().padLeft(h > 0 ? 2 : 1, '0'), ss = sec.toString().padLeft(2, '0');
  return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
}

/// The full-screen workout player (5.6): swipe between exercises, tick sets
/// with weight / reps prefilled from last time, a rest ring between sets,
/// the next exercise below, then a summary with PRs and a celebration. Works
/// offline: every change is saved on the phone.
class WorkoutPlayerScreen extends ConsumerStatefulWidget {
  const WorkoutPlayerScreen({super.key});

  @override
  ConsumerState<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends ConsumerState<WorkoutPlayerScreen> {
  late final PageController _pages = PageController(initialPage: ref.read(activeWorkoutProvider)?.current ?? 0);
  Timer? _tick;
  WorkoutSummary? _summary;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(milliseconds: 500), (_) => _onTick());
  }

  void _onTick() {
    if (!mounted) return;
    final s = ref.read(activeWorkoutProvider);
    final ends = s?.restEndsAt;
    if (ends != null && !ref.read(clockProvider)().isBefore(ends)) {
      unawaited(HapticFeedback.heavyImpact());
      ref.read(activeWorkoutProvider.notifier).endRest();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tick?.cancel();
    _pages.dispose();
    super.dispose();
  }

  Future<void> _finish(WorkoutSession s) async {
    final l = context.l10n;
    if (!s.isComplete) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.playFinishEarlyTitle),
          content: Text(l.playFinishEarlyBody(s.doneSets, s.totalSets)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
            TextButton(
              key: const ValueKey('finish-anyway'),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.playFinishAnyway),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _finishing = true);
    try {
      final summary = await ref.read(activeWorkoutProvider.notifier).finish();
      unawaited(HapticFeedback.mediumImpact());
      ref.refreshWorkouts(s.memberId);
      if (mounted) setState(() => _summary = summary);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  Future<void> _exit(WorkoutSession s) async {
    final l = context.l10n;
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.playExitTitle),
        content: Text(l.playExitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: Text(l.playExitDiscard, style: TextStyle(color: context.colors.danger)),
          ),
          if (s.doneSets > 0) TextButton(onPressed: () => Navigator.pop(context, 'save'), child: Text(l.playExitSave)),
          TextButton(
            key: const ValueKey('exit-keep'),
            onPressed: () => Navigator.pop(context, 'keep'),
            child: Text(l.playExitKeep),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;
    switch (choice) {
      case 'discard':
        ref.read(activeWorkoutProvider.notifier).discard();
        context.pop();
      case 'save':
        final summary = await ref.read(activeWorkoutProvider.notifier).finish();
        ref.refreshWorkouts(s.memberId);
        if (mounted) setState(() => _summary = summary);
      default:
        context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_summary != null) return _SummaryView(summary: _summary!);
    final s = ref.watch(activeWorkoutProvider);
    if (s == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          title: l.wkNoWorkoutsTitle,
          message: l.playOfflineHint,
          illustration: EmptyIllustration.dumbbell,
          actionLabel: l.playDone,
          onAction: () => context.pop(),
        ),
      );
    }
    final c = context.colors;
    final t = context.text;
    final now = ref.watch(clockProvider)();
    final catalogue = ref.watch(exerciseCatalogueProvider).value;
    final current = s.current.clamp(0, s.exercises.length - 1);
    final next = current + 1 < s.exercises.length ? s.exercises[current + 1] : null;
    final resting = s.restEndsAt != null && now.isBefore(s.restEndsAt!);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit(s);
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AbsSpace.x2, AbsSpace.x2, AbsSpace.x4, 0),
                    child: Row(
                      children: [
                        IconButton(
                          key: const ValueKey('player-close'),
                          tooltip: l.commonClose,
                          icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
                          onPressed: () => _exit(s),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(
                                l.playElapsed(_clock(now.difference(s.startedAt))),
                                style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text('${s.doneSets}/${s.totalSets}', style: t.numericOf(t.heading)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x2),
                    child: ClipRRect(
                      borderRadius: AbsRadius.pill,
                      child: LinearProgressIndicator(
                        value: s.progress,
                        minHeight: 8,
                        color: c.accent,
                        backgroundColor: c.surfaceRaised,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pages,
                      itemCount: s.exercises.length,
                      onPageChanged: (i) => ref.read(activeWorkoutProvider.notifier).goTo(i),
                      itemBuilder: (context, i) =>
                          _ExercisePage(index: i, session: s, exercise: catalogue?[s.exercises[i].exerciseId]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.screenPadding,
                      AbsSpace.x2,
                      context.screenPadding,
                      AbsSpace.x3,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            next == null ? l.playLastExercise : l.playNext(next.name),
                            key: const ValueKey('next-up'),
                            style: t.label.copyWith(color: c.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AbsSpace.x2),
                        AbsButton(
                          key: const ValueKey('player-finish'),
                          label: l.playFinish,
                          hue: s.isComplete ? PopHue.lime : PopHue.grape,
                          icon: PhosphorIcons.flagCheckered(PhosphorIconsStyle.bold),
                          expand: false,
                          isLoading: _finishing,
                          onPressed: () => _finish(s),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (resting)
                Positioned(
                  left: context.screenPadding,
                  right: context.screenPadding,
                  bottom: AbsSpace.x14 + AbsSpace.x4,
                  child: _RestCard(endsAt: s.restEndsAt!, totalS: s.restTotalS, now: now),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisePage extends ConsumerWidget {
  const _ExercisePage({required this.index, required this.session, required this.exercise});

  final int index;
  final WorkoutSession session;
  final Exercise? exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = session.exercises[index];
    return ListView(
      padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x14 * 2),
      children: [
        if (exercise != null) ExerciseFrames(exercise: exercise!, height: 190),
        const SizedBox(height: AbsSpace.x3),
        Text(e.name, style: t.title),
        const SizedBox(height: AbsSpace.x1),
        Wrap(
          spacing: AbsSpace.x1,
          runSpacing: AbsSpace.x1,
          children: [
            PopSticker(label: '${index + 1} / ${session.exercises.length}', hue: PopHue.sky, numeric: true),
            if (e.block != ItemBlock.main)
              PopSticker(
                label: blockLabel(l, e.block),
                hue: e.block == ItemBlock.warmup ? PopHue.tangerine : PopHue.sky,
              ),
            if (e.groupKey != null) PopSticker(label: l.superset(e.groupKey!), hue: PopHue.grape),
            if (e.tempo != null) PopSticker(label: l.itemTempo(e.tempo!), hue: PopHue.mint),
            if (session.restAfter(index) > 0)
              PopSticker(label: l.itemRest(durationLabel(session.restAfter(index))), hue: PopHue.bubblegum),
          ],
        ),
        if (e.notes != null) ...[
          const SizedBox(height: AbsSpace.x2),
          Text(e.notes!, style: t.body.copyWith(color: c.textSecondary)),
        ],
        const SizedBox(height: AbsSpace.x3),
        for (final (i, set) in e.sets.indexed)
          _SetRow(exerciseIndex: index, setIndex: i, set: set, tracking: e.trackingType),
        Align(
          alignment: Alignment.centerLeft,
          child: AbsButton.ghost(
            key: ValueKey('add-set-$index'),
            label: l.playAddSet,
            icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
            onPressed: () => ref.read(activeWorkoutProvider.notifier).addSet(index),
          ),
        ),
      ],
    );
  }
}

class _SetRow extends ConsumerWidget {
  const _SetRow({required this.exerciseIndex, required this.setIndex, required this.set, required this.tracking});

  final int exerciseIndex;
  final int setIndex;
  final SessionSet set;
  final TrackingType tracking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final n = ref.read(activeWorkoutProvider.notifier);
    final p = c.pop(PopHue.lime);
    final target = [
      if (set.targetReps != null) '${set.targetReps}',
      if (set.targetDuration != null && tracking.usesTime) durationLabel(set.targetDuration!),
      if (set.targetWeight != null && tracking.usesWeight) kg(set.targetWeight!),
    ].join(' · ');
    return AnimatedContainer(
      key: ValueKey('set-$exerciseIndex-$setIndex'),
      duration: AbsMotion.quick.duration,
      margin: const EdgeInsets.only(bottom: AbsSpace.x2),
      padding: const EdgeInsets.fromLTRB(AbsSpace.x3, AbsSpace.x2, AbsSpace.x2, AbsSpace.x2),
      decoration: stickerDecoration(
        c,
        color: set.done ? p.soft : c.surfaceRaised,
        lipDepth: 2,
        borderRadius: AbsRadius.cardAll,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text('${set.setNo}', style: t.numericOf(t.title)),
                Text(l.playSet, style: t.caption.copyWith(color: c.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (target.isNotEmpty)
                  Text('${l.playTarget} $target', style: t.numericOf(t.caption).copyWith(color: c.textSecondary)),
                Wrap(
                  spacing: AbsSpace.x2,
                  runSpacing: AbsSpace.x1,
                  children: [
                    if (tracking.usesWeight)
                      _Stepper(
                        key: ValueKey('w-$exerciseIndex-$setIndex'),
                        value: set.weight ?? 0,
                        unit: l.playKg,
                        step: 2.5,
                        decimals: true,
                        onChanged: (v) => n.updateSet(exerciseIndex, setIndex, weight: v),
                      ),
                    if (tracking.usesReps)
                      _Stepper(
                        key: ValueKey('r-$exerciseIndex-$setIndex'),
                        value: (set.reps ?? 0).toDouble(),
                        unit: l.playReps,
                        step: 1,
                        onChanged: (v) => n.updateSet(exerciseIndex, setIndex, reps: v.round()),
                      ),
                    if (tracking.usesTime)
                      _Stepper(
                        key: ValueKey('t-$exerciseIndex-$setIndex'),
                        value: (set.durationS ?? 0).toDouble(),
                        unit: l.playSec,
                        step: 5,
                        onChanged: (v) => n.updateSet(exerciseIndex, setIndex, durationS: v.round()),
                      ),
                    if (tracking == TrackingType.distanceTime)
                      _Stepper(
                        value: (set.distanceM ?? 0).toDouble(),
                        unit: l.playMetres,
                        step: 100,
                        onChanged: (v) => n.updateSet(exerciseIndex, setIndex, distanceM: v.round()),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            checked: set.done,
            label: set.done ? l.playUntick : l.playTick,
            excludeSemantics: true,
            child: GestureDetector(
              key: ValueKey('tick-$exerciseIndex-$setIndex'),
              onTap: () => n.toggleSet(exerciseIndex, setIndex),
              child: AnimatedContainer(
                duration: AbsMotion.quick.duration,
                width: AbsSize.touchTarget + 4,
                height: AbsSize.touchTarget + 4,
                decoration: stickerDecoration(
                  c,
                  color: set.done ? p.fill : c.surface,
                  lipDepth: 3,
                  borderRadius: AbsRadius.pill,
                ),
                child: Icon(
                  PhosphorIcons.check(PhosphorIconsStyle.bold),
                  color: set.done ? p.onFill : c.textSecondary,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// − value + with a tap on the value to type it.
class _Stepper extends StatelessWidget {
  const _Stepper({
    super.key,
    required this.value,
    required this.unit,
    required this.step,
    required this.onChanged,
    this.decimals = false,
  });

  final double value;
  final String unit;
  final double step;
  final bool decimals;
  final ValueChanged<double> onChanged;

  String get _text => decimals && value % 1 != 0 ? value.toStringAsFixed(1) : value.round().toString();

  Future<void> _type(BuildContext context) async {
    final raw = await promptText(
      context,
      label: unit,
      initial: _text,
      numeric: true,
      keyboardType: TextInputType.numberWithOptions(decimal: decimals),
    );
    final v = raw == null ? null : double.tryParse(raw.replaceAll(',', '.'));
    if (v != null && v >= 0) onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    Widget btn(IconData icon, VoidCallback? onTap, String label) => SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        tooltip: label,
        padding: EdgeInsets.zero,
        iconSize: AbsSize.iconSmall,
        icon: Icon(icon),
        onPressed: onTap,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AbsRadius.pill,
        border: Border.all(color: c.border, width: AbsDepth.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(
            PhosphorIcons.minus(PhosphorIconsStyle.bold),
            value - step < 0 ? null : () => onChanged(value - step),
            '− $unit',
          ),
          InkWell(
            onTap: () => _type(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x1),
              child: Text('$_text $unit', style: t.numericOf(t.heading)),
            ),
          ),
          btn(PhosphorIcons.plus(PhosphorIconsStyle.bold), () => onChanged(value + step), '+ $unit'),
        ],
      ),
    );
  }
}

class _RestCard extends ConsumerWidget {
  const _RestCard({required this.endsAt, required this.totalS, required this.now});

  final DateTime endsAt;
  final int totalS;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final left = endsAt.difference(now);
    final p = c.pop(PopHue.grape);
    final n = ref.read(activeWorkoutProvider.notifier);
    return Container(
      key: const ValueKey('rest-card'),
      padding: const EdgeInsets.all(AbsSpace.x4),
      decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
      child: Row(
        children: [
          ProgressRing(
            progress: totalS == 0 ? 0 : (left.inMilliseconds / (totalS * 1000)).clamp(0.0, 1.0),
            size: 72,
            strokeWidth: 8,
            hue: PopHue.lime,
            semanticsLabel: '${l.playRest} ${_clock(left)}',
            child: Text(_clock(left), style: t.numericOf(t.heading).copyWith(color: p.onFill)),
          ),
          const SizedBox(width: AbsSpace.x4),
          Expanded(
            child: Text(l.playRest, style: t.title.copyWith(color: p.onFill)),
          ),
          AbsButton.secondary(label: l.playRestAdd, expand: false, onPressed: () => n.addRest(15)),
          const SizedBox(width: AbsSpace.x2),
          AbsButton(
            key: const ValueKey('rest-skip'),
            label: l.playRestSkip,
            hue: PopHue.lime,
            expand: false,
            onPressed: n.endRest,
          ),
        ],
      ),
    );
  }
}

/// Finish (5.6): time, kg lifted, sets, PRs, and a celebration.
class _SummaryView extends ConsumerWidget {
  const _SummaryView({required this.summary});

  final WorkoutSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final catalogue = ref.watch(exerciseCatalogueProvider).value;
    final s = summary;
    String kind(String k) => switch (k) {
      'weight' => l.playPrWeight,
      'reps' => l.playPrReps,
      _ => l.playPrE1rm,
    };
    Widget tile(String label, String value, PopHue hue) => Expanded(
      child: AbsCard(
        hue: hue,
        padding: const EdgeInsets.all(AbsSpace.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: t.caption.copyWith(color: c.textSecondary)),
            Text(value, style: t.numericOf(t.title), maxLines: 1),
          ],
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              key: const ValueKey('workout-summary'),
              padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x8, context.screenPadding, AbsSpace.x8),
              children: [
                Center(
                  child: ProgressRing(
                    progress: 1,
                    size: 140,
                    hue: s.complete ? PopHue.lime : PopHue.sky,
                    child: Icon(
                      s.complete
                          ? PhosphorIcons.trophy(PhosphorIconsStyle.fill)
                          : PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                      size: 56,
                      color: c.pop(s.complete ? PopHue.lime : PopHue.sky).text,
                    ),
                  ),
                ),
                const SizedBox(height: AbsSpace.x4),
                Text(
                  s.complete ? l.playSummaryTitle : l.playSummaryPartial,
                  style: t.displayL,
                  textAlign: TextAlign.center,
                ),
                Text(
                  s.name,
                  style: t.heading.copyWith(color: c.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AbsSpace.x5),
                Row(
                  children: [
                    tile(l.playSummaryDuration, _clock(s.duration), PopHue.sky),
                    const SizedBox(width: AbsSpace.x2),
                    tile(l.playSummaryVolume, kg(s.volume.round()), PopHue.tangerine),
                    const SizedBox(width: AbsSpace.x2),
                    tile(l.playSummarySets, '${s.setsDone}', PopHue.grape),
                  ],
                ),
                if (s.prs.isNotEmpty) ...[
                  const SizedBox(height: AbsSpace.x5),
                  Text(l.playSummaryPrs, style: t.title),
                  const SizedBox(height: AbsSpace.x2),
                  for (final (i, pr) in s.prs.indexed)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: AbsMotion.reduced(context) ? 1 : 0.6, end: 1),
                      duration: AbsMotion.bouncy.duration + Duration(milliseconds: 80 * i),
                      curve: AbsMotion.bouncy.curve,
                      builder: (context, v, child) => Transform.scale(scale: v, child: child),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                        child: AbsCard(
                          key: ValueKey('pr-${pr.exerciseId}-${pr.setNo}'),
                          hue: PopHue.tangerine,
                          solid: true,
                          padding: const EdgeInsets.all(AbsSpace.x3),
                          child: Row(
                            children: [
                              Icon(
                                PhosphorIcons.trophy(PhosphorIconsStyle.fill),
                                size: 30,
                                color: c.pop(PopHue.tangerine).onFill,
                              ),
                              const SizedBox(width: AbsSpace.x3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      catalogue?[pr.exerciseId]?.name ?? '—',
                                      style: t.heading.copyWith(color: c.pop(PopHue.tangerine).onFill),
                                    ),
                                    Text(
                                      [
                                        pr.kinds.map(kind).join(' · '),
                                        if (pr.weight != null && pr.weight! > 0) kg(pr.weight!),
                                        if (pr.reps != null) '× ${pr.reps}',
                                      ].join('  '),
                                      style: t.numericOf(t.label).copyWith(color: c.pop(PopHue.tangerine).onFill),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: AbsSpace.x4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      s.synced
                          ? PhosphorIcons.cloudCheck(PhosphorIconsStyle.bold)
                          : PhosphorIcons.cloudSlash(PhosphorIconsStyle.bold),
                      size: AbsSize.iconSmall,
                      color: c.textSecondary,
                    ),
                    const SizedBox(width: AbsSpace.x1),
                    Flexible(
                      child: Text(
                        s.synced ? l.playSynced : l.playQueued,
                        style: t.caption.copyWith(color: c.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AbsSpace.x6),
                AbsButton(
                  key: const ValueKey('summary-done'),
                  label: l.playDone,
                  hue: PopHue.lime,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const Positioned.fill(child: ConfettiBurst()),
          ],
        ),
      ),
    );
  }
}
