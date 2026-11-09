import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/presentation/member_ui.dart' show goalLabel, levelLabel;
import '../application/exercise_providers.dart';
import '../domain/exercise.dart';

/// Network images on/off (off in widget tests and screenshots).
final networkImagesEnabledProvider = Provider<bool>((ref) => true);

String muscleLabel(AppLocalizations l, String m) => switch (m) {
  'chest' => l.muscleChest,
  'shoulders' => l.muscleShoulders,
  'biceps' => l.muscleBiceps,
  'forearms' => l.muscleForearms,
  'abdominals' => l.muscleAbdominals,
  'quadriceps' => l.muscleQuadriceps,
  'adductors' => l.muscleAdductors,
  'abductors' => l.muscleAbductors,
  'calves' => l.muscleCalves,
  'neck' => l.muscleNeck,
  'traps' => l.muscleTraps,
  'lats' => l.muscleLats,
  'middle back' => l.muscleMiddleBack,
  'lower back' => l.muscleLowerBack,
  'triceps' => l.muscleTriceps,
  'glutes' => l.muscleGlutes,
  'hamstrings' => l.muscleHamstrings,
  _ => m,
};

String equipmentLabel(AppLocalizations l, String? e) => switch (e) {
  'barbell' => l.equipBarbell,
  'dumbbell' => l.equipDumbbell,
  'cable' => l.equipCable,
  'machine' => l.equipMachine,
  'kettlebells' => l.equipKettlebells,
  'bands' => l.equipBands,
  'medicine ball' => l.equipMedicineBall,
  'exercise ball' => l.equipExerciseBall,
  'foam roll' => l.equipFoamRoll,
  'e-z curl bar' => l.equipEzBar,
  'body only' || null => l.equipBodyOnly,
  _ => l.equipOther,
};

String exerciseLevelLabel(AppLocalizations l, String? v) =>
    v == 'expert' ? l.levelExpert : levelLabel(l, v ?? 'beginner');

String categoryLabel(AppLocalizations l, String? c) => switch (c) {
  'stretching' => l.catStretching,
  'cardio' => l.catCardio,
  'plyometrics' => l.catPlyometrics,
  'powerlifting' => l.catPowerlifting,
  'olympic weightlifting' => l.catOlympic,
  'strongman' => l.catStrongman,
  _ => l.catStrength,
};

String trackingLabel(AppLocalizations l, TrackingType t) => switch (t) {
  TrackingType.repsWeight => l.trackRepsWeight,
  TrackingType.reps => l.trackReps,
  TrackingType.time => l.trackTime,
  TrackingType.distanceTime => l.trackDistanceTime,
};

String goalShort(AppLocalizations l, String? g) => switch (g) {
  'fat_loss' => l.goalFatLossShort,
  'muscle_gain' => l.goalMuscleGainShort,
  'strength' => l.goalStrengthShort,
  'rehab' => l.goalRehabShort,
  'general_fitness' => l.goalGeneralShort,
  _ => g == null ? '' : goalLabel(l, g),
};

String weekdayShort(AppLocalizations l, int d) =>
    [l.weekdayMon, l.weekdayTue, l.weekdayWed, l.weekdayThu, l.weekdayFri, l.weekdaySat, l.weekdaySun][(d - 1) % 7];

/// "45 s", "2 min", "1 min 30 s".
String durationLabel(int seconds) {
  if (seconds < 60) return '$seconds s';
  final m = seconds ~/ 60, s = seconds % 60;
  return s == 0 ? '$m min' : '$m min $s s';
}

/// "42.5 kg" without a trailing .0.
String kg(num v) => '${v % 1 == 0 ? v.toInt() : v.toStringAsFixed(1)} kg';

/// Each muscle group owns a pop colour, so lists and the body map agree.
PopHue muscleHue(String? m) => switch (m) {
  'chest' || 'triceps' => PopHue.coral,
  'shoulders' || 'traps' || 'neck' => PopHue.tangerine,
  'biceps' || 'forearms' => PopHue.bubblegum,
  'abdominals' || 'lower back' => PopHue.lime,
  'lats' || 'middle back' => PopHue.sky,
  'glutes' || 'hamstrings' => PopHue.grape,
  _ => PopHue.mint,
};

/// A catalogue image with a soft, blurred placeholder while it loads
/// (spec 4: "images lazy-load with blur-up placeholders"). Decoded at the
/// size shown (thumbnails stay small in memory).
class ExerciseImage extends ConsumerWidget {
  const ExerciseImage({super.key, required this.path, required this.hue, this.size, this.fit = BoxFit.cover});

  final String? path;
  final PopHue hue;
  final double? size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(networkImagesEnabledProvider) ? ref.watch(exerciseImagesProvider)(path) : null;
    final placeholder = _Placeholder(hue: hue);
    if (url == null) return placeholder;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: size == null ? 800 : (size! * dpr).round(),
      fadeInDuration: AbsMotion.standard.duration,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.hue});

  final PopHue hue;

  @override
  Widget build(BuildContext context) {
    final p = context.colors.pop(hue);
    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [p.soft, p.fill.withValues(alpha: 0.5), p.soft],
            ),
          ),
          child: Center(
            child: Icon(PhosphorIcons.barbell(PhosphorIconsStyle.bold), color: p.deep.withValues(alpha: 0.5), size: 32),
          ),
        ),
      ),
    );
  }
}

/// The start and end positions playing like a looping GIF (4.4): hold the
/// start, cross-fade to the end, hold, fade back. Tap to pause or play. With
/// reduced motion it stays still and a tap switches position.
class ExerciseFrames extends StatefulWidget {
  const ExerciseFrames({super.key, required this.exercise, this.height = 220, this.heroTag});

  final Exercise exercise;
  final double height;
  final Object? heroTag;

  @override
  State<ExerciseFrames> createState() => _ExerciseFramesState();
}

class _ExerciseFramesState extends State<ExerciseFrames> with SingleTickerProviderStateMixin {
  static const _hold = 900;
  static final _fade = AbsMotion.expressive.duration.inMilliseconds;

  late final _ctl = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 2 * (_hold + _fade)),
  );

  /// How much of the end position shows: 0 → 1 → 0 over one loop.
  late final Animation<double> _end = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0), weight: _hold.toDouble()),
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: AbsMotion.standard.curve)),
      weight: _fade.toDouble(),
    ),
    TweenSequenceItem(tween: ConstantTween(1), weight: _hold.toDouble()),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: AbsMotion.standard.curve)),
      weight: _fade.toDouble(),
    ),
  ]).animate(_ctl);

  bool _paused = false;
  bool _reduced = false;

  bool get _moves => widget.exercise.images.length > 1;

  void _sync() {
    if (_moves && !_paused && !_reduced) {
      if (!_ctl.isAnimating) _ctl.repeat();
    } else {
      _ctl.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = AbsMotion.reduced(context);
    _sync();
  }

  @override
  void didUpdateWidget(ExerciseFrames old) {
    super.didUpdateWidget(old);
    if (old.exercise.id != widget.exercise.id) _ctl.value = 0;
    _sync();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _tap() {
    if (!_moves) return;
    HapticFeedback.selectionClick();
    if (_reduced) {
      // Still mode: a tap shows the other position.
      setState(() => _ctl.value = _end.value < 0.5 ? 0.6 : 0);
      return;
    }
    setState(() => _paused = !_paused);
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = widget.exercise;
    final hue = muscleHue(e.primaryMuscle);
    final c = context.colors;
    Widget frame(int i) => SizedBox.expand(
      child: ExerciseImage(path: e.images.isEmpty ? null : e.images[i % e.images.length], hue: hue),
    );
    Widget image = Stack(
      fit: StackFit.expand,
      children: [
        frame(0),
        if (_moves) FadeTransition(opacity: _end, child: frame(1)),
      ],
    );
    if (widget.heroTag != null) image = Hero(tag: widget.heroTag!, child: image);
    return Semantics(
      image: true,
      label: e.name,
      button: _moves,
      hint: _moves ? (_paused ? l.exPlayMotion : l.exPauseMotion) : null,
      child: GestureDetector(
        onTap: _tap,
        child: Container(
          height: widget.height,
          clipBehavior: Clip.antiAlias,
          decoration: stickerDecoration(c, color: c.surfaceRaised, borderRadius: AbsRadius.cardAll),
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              if (_moves && !_reduced)
                Positioned(
                  right: AbsSpace.x2,
                  bottom: AbsSpace.x2,
                  child: AnimatedSwitcher(
                    duration: AbsMotion.quick.duration,
                    child: Container(
                      key: ValueKey(_paused),
                      padding: const EdgeInsets.all(AbsSpace.x1 + 2),
                      decoration: BoxDecoration(color: c.surface.withValues(alpha: 0.85), shape: BoxShape.circle),
                      child: Icon(
                        _paused
                            ? PhosphorIcons.play(PhosphorIconsStyle.fill)
                            : PhosphorIcons.pause(PhosphorIconsStyle.fill),
                        size: AbsSize.iconSmall,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A row in the library: thumbnail, name, muscles and equipment, star.
class ExerciseTile extends ConsumerWidget {
  const ExerciseTile({
    super.key,
    required this.exercise,
    this.onTap,
    this.selected,
    this.trailing,
    this.showStar = true,
  });

  final Exercise exercise;
  final VoidCallback? onTap;

  /// Multi-select mode (program builder): shows a tick instead of the star.
  final bool? selected;
  final Widget? trailing;
  final bool showStar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = exercise;
    final hue = muscleHue(e.primaryMuscle);
    final fav = ref.watch(favouriteExercisesProvider).value?.contains(e.id) ?? false;
    final subtitle = [
      if (e.primaryMuscle != null) muscleLabel(l, e.primaryMuscle!),
      equipmentLabel(l, e.equipment),
      if (e.localName != null) e.localName!,
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x2),
      child: AbsCard(
        onTap: onTap,
        hue: selected == true ? hue : null,
        solid: selected == true,
        padding: const EdgeInsets.fromLTRB(AbsSpace.x2, AbsSpace.x2, AbsSpace.x1, AbsSpace.x2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AbsRadius.chipAll,
              child: SizedBox(
                width: 60,
                height: 60,
                child: ExerciseImage(path: e.images.firstOrNull, hue: hue, size: 60),
              ),
            ),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.name,
                    style: t.heading.copyWith(color: selected == true ? c.pop(hue).onFill : null),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: t.caption.copyWith(color: selected == true ? c.pop(hue).onFill : c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (e.isCustom) ...[const SizedBox(height: 2), PopSticker(label: l.exCustom, hue: PopHue.grape)],
                ],
              ),
            ),
            if (selected != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x2),
                child: Icon(
                  selected!
                      ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                      : PhosphorIcons.circle(PhosphorIconsStyle.bold),
                  color: selected! ? c.pop(hue).onFill : c.textSecondary,
                ),
              )
            else if (showStar)
              IconButton(
                tooltip: fav ? l.exUnstar : l.exStar,
                icon: Icon(
                  fav ? PhosphorIcons.star(PhosphorIconsStyle.fill) : PhosphorIcons.star(PhosphorIconsStyle.bold),
                  color: fav ? c.pop(PopHue.tangerine).text : c.textSecondary,
                ),
                onPressed: () => ref.read(favouriteExercisesProvider.notifier).toggle(e.id).catchError((Object _) {}),
              ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body map (4.2): an original, smooth figure. The silhouette and each muscle
// are traced as points on a 100 × 200 grid (the right side, mirrored for the
// left) and drawn as closed curves through those points, so nothing looks
// boxy. Tapping a muscle selects it.
// ---------------------------------------------------------------------------

/// A closed outline on the 100 × 200 grid.
typedef BodyShape = List<Offset>;

BodyShape _pts(List<double> xy) => [for (var i = 0; i < xy.length; i += 2) Offset(xy[i], xy[i + 1])];

/// The same outline on the figure's left side.
BodyShape _mirror(BodyShape s) => [for (final p in s.reversed) Offset(100 - p.dx, p.dy)];

List<BodyShape> _both(List<double> xy) {
  final right = _pts(xy);
  return [right, _mirror(right)];
}

/// A smooth closed curve through [pts] (Catmull-Rom as cubic Béziers).
Path smoothBodyPath(BodyShape pts) {
  final n = pts.length;
  final path = Path()..moveTo(pts[0].dx, pts[0].dy);
  for (var i = 0; i < n; i++) {
    final p0 = pts[(i - 1 + n) % n], p1 = pts[i], p2 = pts[(i + 1) % n], p3 = pts[(i + 2) % n];
    final c1 = p1 + (p2 - p0) / 6, c2 = p2 - (p3 - p1) / 6;
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }
  return path..close();
}

/// The whole figure, arms slightly away from the body: neck down the right
/// side, round the hand and foot, to the crotch; the left side mirrors it.
final BodyShape _silhouetteRight = _pts([
  50, 21.5, 54.8, 21.8, 55.6, 26, 57, 29.8, 63, 31.5, 71, 33, 76.5, 36.5, 79.5, 43, 80.8, 52, 81.6, 61, 82.6, 70, //
  84.6, 80, 85.8, 90, 86.2, 97, 88.4, 103, 88, 110, 84.8, 112.4, 81.8, 109, 80.6, 103, 79.6, 96, //
  77.6, 87, 75.4, 77, 73.4, 67, 71.6, 58, 69.6, 51, 67.6, 58, 66.2, 68, 65.2, 77, 66.6, 87, //
  67.8, 97, 67.2, 110, 65.4, 125, 62.6, 140, 61.6, 148, 62.4, 158, 61.2, 172, 58.8, 186, 61.6, 193, //
  60.2, 197.6, 53.4, 197.6, 52.6, 190, 53.6, 174, 54, 160, 53.2, 148, 52.4, 138, 51.8, 120, 50, 104,
]);

final BodyShape kBodySilhouette = [
  ..._silhouetteRight,
  ..._mirror(_silhouetteRight).skip(1).take(_silhouetteRight.length - 2),
];

/// The head, a soft oval.
final BodyShape kBodyHead = [
  for (var i = 0; i < 16; i++) Offset(50 + 8.6 * math.cos(i * math.pi / 8), 13.2 + 11 * math.sin(i * math.pi / 8)),
];

final kBodyFront = <String, List<BodyShape>>{
  'neck': [
    _pts([46.2, 24.6, 53.8, 24.6, 54.6, 29.6, 50, 31, 45.4, 29.6]),
  ],
  'shoulders': _both([66.4, 33.2, 71.6, 33.6, 76.6, 37.2, 79, 44, 77.6, 50.4, 73.4, 47.4, 69, 40.6]),
  'chest': _both([51, 35.6, 56.6, 33.8, 62.6, 34.4, 66.6, 38.6, 67.4, 45.6, 64.6, 50.8, 58, 53, 51, 51.4]),
  'biceps': _both([72.2, 49.8, 77.2, 50.4, 79.6, 57, 80, 64.6, 77, 69.4, 73.8, 66, 72.2, 58]),
  'forearms': _both([75.2, 72.4, 80.4, 71.4, 83.4, 79, 84.8, 88, 84.8, 94.6, 81.2, 95.6, 78.4, 86, 76.2, 79]),
  'abdominals': [
    _pts([44.8, 56, 50, 55, 55.2, 56, 56.4, 66, 56.2, 77, 54.2, 85.6, 50, 89.6, 45.8, 85.6, 43.8, 77, 43.6, 66]),
    ..._both([57.8, 57, 63.4, 56.2, 64.6, 66, 64, 76.6, 60.8, 83, 57.4, 79, 57.8, 68]),
  ],
  'abductors': _both([64.2, 84.2, 66.6, 88, 67.4, 97, 66.2, 105.6, 63.4, 101, 62.6, 91.8]),
  'quadriceps': _both([
    52.6,
    104.6,
    57.6,
    98.6,
    62.8,
    103.4,
    65.2,
    112.4,
    64.4,
    126,
    61.4,
    137.4,
    56.6,
    139.4,
    53.6,
    131,
    52.4,
    118,
  ]),
  'adductors': _both([50.9, 106.4, 52.4, 104.6, 53.6, 115, 52.8, 127, 51, 122]),
  'calves': _both([53.8, 150.6, 58.6, 148.6, 61, 156, 60.6, 168, 57.6, 181, 54.6, 177, 53.4, 163]),
};

final kBodyBack = <String, List<BodyShape>>{
  'neck': [
    _pts([46, 23.8, 54, 23.8, 54.6, 27.8, 50, 28.4, 45.4, 27.8]),
  ],
  'traps': [
    _pts([
      50,
      29.4,
      56,
      28.8,
      64,
      31,
      67.4,
      33.4,
      60.6,
      36.6,
      55,
      43.6,
      50,
      52.4,
      45,
      43.6,
      39.4,
      36.6,
      32.6,
      33.4,
      36,
      31,
      44,
      28.8,
    ]),
  ],
  'shoulders': _both([66.6, 33.6, 72.4, 33.4, 77.4, 37.6, 79.2, 44.6, 76.6, 49.6, 71.6, 43.8]),
  'triceps': _both([72.6, 50.2, 77.6, 50.6, 80, 58, 80, 65.6, 77, 69.6, 74, 65, 72.4, 57.6]),
  'forearms': _both([75.2, 72.4, 80.4, 71.4, 83.4, 79, 84.8, 88, 84.8, 94.6, 81.2, 95.6, 78.4, 86, 76.2, 79]),
  'lats': _both([55.6, 46, 61.4, 38.8, 67.2, 41.8, 68.4, 51, 66.4, 61.6, 62.6, 70.8, 57.2, 73.8, 55.4, 62]),
  'middle back': [
    _pts([47.4, 54.6, 50, 55.6, 52.6, 54.6, 54, 61, 50, 66.4, 46, 61]),
  ],
  'lower back': [
    _pts([45.4, 68.6, 50, 69.8, 54.6, 68.6, 56.8, 77.6, 55, 86, 50, 84.2, 45, 86, 43.2, 77.6]),
  ],
  'glutes': _both([51, 88.6, 57.6, 86.4, 64.4, 89.6, 67, 98.6, 64.8, 107.4, 57.6, 110.4, 51.4, 106.4]),
  'hamstrings': _both([
    52.2,
    112.6,
    58.2,
    111.4,
    63.8,
    114.4,
    64.2,
    126,
    61.2,
    137.6,
    56.4,
    139.6,
    53.4,
    130.6,
    52.2,
    120,
  ]),
  'calves': _both([53.6, 147.6, 58.2, 145.8, 62, 151.8, 62.2, 163.6, 59.4, 176, 55.4, 178.4, 53.2, 166]),
};

/// Slightly widens the figure so small muscles stay easy to tap.
const kBodyStretch = 1.25;

/// Places the 100 × 200 grid in a box of [size]: centred, height-fitted.
Matrix4 bodyTransform(Size size) {
  final s = size.height / 200, sx = s * kBodyStretch, dx = (size.width - 100 * sx) / 2;
  return Matrix4.identity()
    ..translateByDouble(dx, 0, 0, 1)
    ..scaleByDouble(sx, s, 1, 1);
}

class BodyMap extends StatelessWidget {
  const BodyMap({
    super.key,
    required this.back,
    this.selected,
    this.onSelect,
    this.primary = const {},
    this.secondary = const {},
    this.height = 280,
  });

  /// Back view (otherwise front).
  final bool back;
  final String? selected;
  final ValueChanged<String?>? onSelect;

  /// Highlighted without a selection (exercise detail "muscles worked").
  final Set<String> primary;
  final Set<String> secondary;
  final double height;

  Map<String, List<BodyShape>> get _muscles => back ? kBodyBack : kBodyFront;

  /// The muscle under [local] (topmost first). A tap that just misses a
  /// small muscle still finds the nearest one within a fingertip.
  String? _hit(Offset local, Size size) {
    final m = bodyTransform(size)..invert();
    final p = MatrixUtils.transformPoint(m, local);
    final paths = [
      for (final e in _muscles.entries.toList().reversed)
        for (final shape in e.value) (e.key, smoothBodyPath(shape)),
    ];
    for (final radius in const [0.0, 2.0, 4.0]) {
      for (var i = 0; i < (radius == 0 ? 1 : 8); i++) {
        final q = p + Offset.fromDirection(i * math.pi / 4, radius);
        for (final (muscle, path) in paths) {
          if (path.contains(q)) return muscle;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, box) {
          final size = Size(box.maxWidth, height);
          final m = bodyTransform(size);
          return GestureDetector(
            onTapUp: onSelect == null
                ? null
                : (d) {
                    final hit = _hit(d.localPosition, size);
                    if (hit != null) onSelect!(hit == selected ? null : hit);
                  },
            child: Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _BodyPainter(
                        back: back,
                        muscles: _muscles,
                        selected: selected,
                        primary: primary,
                        secondary: secondary,
                        colors: c,
                      ),
                    ),
                  ),
                ),
                // Invisible, labelled tap targets for screen readers.
                for (final e in _muscles.entries)
                  Builder(
                    builder: (context) {
                      final r = MatrixUtils.transformRect(m, smoothBodyPath(e.value.first).getBounds());
                      return Positioned.fromRect(
                        rect: r,
                        child: Semantics(
                          button: onSelect != null,
                          selected: selected == e.key,
                          label: muscleLabel(l, e.key),
                          onTap: onSelect == null ? null : () => onSelect!(e.key == selected ? null : e.key),
                          child: const SizedBox.expand(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.back,
    required this.muscles,
    required this.selected,
    required this.primary,
    required this.secondary,
    required this.colors,
  });

  final bool back;
  final Map<String, List<BodyShape>> muscles;
  final String? selected;
  final Set<String> primary;
  final Set<String> secondary;
  final AbsColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final m = bodyTransform(size).storage;
    Path path(BodyShape shape) => smoothBodyPath(shape).transform(m);
    final ink = colors.isDark ? colors.border : colors.ink;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..color = ink;
    final muscleLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeJoin = StrokeJoin.round
      ..color = ink.withValues(alpha: colors.isDark ? 0.9 : 0.55);
    final skin = Paint()..color = colors.surfaceRaised;

    // The figure: a soft shadow, then the silhouette and head.
    final body = path(kBodySilhouette), head = path(kBodyHead);
    for (final p in [body, head]) {
      canvas
        ..drawPath(
          p.shift(const Offset(0, 2)),
          Paint()
            ..color = colors.shadow.withValues(alpha: 0.12)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        )
        ..drawPath(p, skin)
        ..drawPath(p, outline);
    }

    final accent = colors.primary;
    for (final e in muscles.entries) {
      final muscle = e.key;
      final isSel = muscle == selected;
      final isPrimary = primary.contains(muscle);
      final isSecondary = secondary.contains(muscle);
      final fill = Paint()
        ..color = isSel || isPrimary
            ? accent.fill
            : isSecondary
            ? colors.pop(PopHue.sky).fill
            : colors.pop(muscleHue(muscle)).soft;
      for (final shape in e.value) {
        final p = path(shape);
        if (isSel) {
          // Glow around the selected muscle.
          canvas.drawPath(
            p,
            Paint()
              ..color = accent.fill.withValues(alpha: 0.6)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
          );
        }
        canvas
          ..drawPath(p, fill)
          ..drawPath(p, muscleLine);
      }
    }

    // Details that make it read as a body, not blocks.
    final detail = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = ink.withValues(alpha: colors.isDark ? 0.55 : 0.35);
    void line(double x1, double y1, double x2, double y2) {
      final a = MatrixUtils.transformPoint(bodyTransform(size), Offset(x1, y1));
      final b = MatrixUtils.transformPoint(bodyTransform(size), Offset(x2, y2));
      canvas.drawLine(a, b, detail);
    }

    if (!back) {
      // Collarbones, six-pack, knee caps.
      line(51.4, 31.6, 63.4, 32.4);
      line(48.6, 31.6, 36.6, 32.4);
      line(50, 57, 50, 86);
      for (final y in [63.5, 71.0, 78.5]) {
        line(45, y, 55, y);
      }
      for (final x in [42.6, 57.4]) {
        canvas.drawOval(
          MatrixUtils.transformRect(
            bodyTransform(size),
            Rect.fromCenter(center: Offset(x, 143.6), width: 5.4, height: 6.4),
          ),
          detail,
        );
      }
    } else {
      // Spine and the back of the knees.
      line(50, 30, 50, 86);
      for (final s in [1, -1]) {
        line(50 + s * 4, 144, 50 + s * 9.6, 144);
      }
    }
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.back != back ||
      old.selected != selected ||
      old.primary != primary ||
      old.secondary != secondary ||
      old.muscles != muscles ||
      old.colors != colors;
}
