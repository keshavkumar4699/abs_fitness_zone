import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

/// The start and end positions alternating like a 2-frame animation (4.4).
class ExerciseFrames extends StatefulWidget {
  const ExerciseFrames({super.key, required this.exercise, this.height = 220, this.heroTag});

  final Exercise exercise;
  final double height;
  final Object? heroTag;

  @override
  State<ExerciseFrames> createState() => _ExerciseFramesState();
}

class _ExerciseFramesState extends State<ExerciseFrames> {
  Timer? _timer;
  int _frame = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (widget.exercise.images.length > 1 && !AbsMotion.reduced(context)) {
      _timer = Timer.periodic(const Duration(milliseconds: 1100), (_) {
        if (mounted) setState(() => _frame = (_frame + 1) % widget.exercise.images.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    final hue = muscleHue(e.primaryMuscle);
    final c = context.colors;
    Widget image = AnimatedSwitcher(
      duration: AbsMotion.standard.duration,
      child: KeyedSubtree(
        key: ValueKey(_frame),
        child: SizedBox.expand(
          child: ExerciseImage(path: e.images.isEmpty ? null : e.images[_frame % e.images.length], hue: hue),
        ),
      ),
    );
    if (widget.heroTag != null) image = Hero(tag: widget.heroTag!, child: image);
    return Semantics(
      image: true,
      label: e.name,
      child: Container(
        height: widget.height,
        clipBehavior: Clip.antiAlias,
        decoration: stickerDecoration(c, color: c.surfaceRaised, borderRadius: AbsRadius.cardAll),
        child: image,
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
// Body map (4.2): an original, chunky sticker figure. Each muscle is a set of
// rounded shapes on a 100 × 200 grid; tapping one selects it.
// ---------------------------------------------------------------------------
typedef _Shape = ({double l, double t, double r, double b, double radius});

_Shape _box(double l, double t, double r, double b, [double radius = 6]) => (l: l, t: t, r: r, b: b, radius: radius);

List<_Shape> _pair(double l, double t, double r, double b, [double radius = 6]) => [
  _box(l, t, r, b, radius),
  _box(100 - r, t, 100 - l, b, radius),
];

/// Silhouette parts that are not muscles (head, hands, knees, feet).
final _frame = <_Shape>[
  _box(40, 2, 60, 22, 10), // head
  ..._pair(14, 96, 22, 106, 4), // hands
  ..._pair(36, 140, 47, 148, 4), // knees
  ..._pair(35, 186, 47, 196, 4), // feet
];

final kBodyFront = <String, List<_Shape>>{
  'neck': [_box(45, 21, 55, 29, 3)],
  'shoulders': _pair(21, 30, 34, 46, 8),
  'chest': [_box(35, 31, 49.4, 50, 6), _box(50.6, 31, 65, 50, 6)],
  'biceps': _pair(18, 47, 28, 68, 6),
  'forearms': _pair(14, 69, 25, 95, 6),
  'abdominals': [_box(39, 52, 61, 84, 8)],
  'abductors': _pair(30, 80, 36, 104, 4),
  'quadriceps': _pair(36, 86, 49, 139, 7),
  'adductors': [_box(46, 98, 49.4, 124, 2), _box(50.6, 98, 54, 124, 2)],
  'calves': _pair(37, 149, 46, 185, 6),
};

final kBodyBack = <String, List<_Shape>>{
  'neck': [_box(45, 21, 55, 27, 3)],
  'traps': [_box(37, 26, 63, 40, 10)],
  'shoulders': _pair(21, 31, 34, 46, 8),
  'triceps': _pair(18, 47, 28, 68, 6),
  'forearms': _pair(14, 69, 25, 95, 6),
  'lats': _pair(34, 44, 45, 72, 7),
  'middle back': [_box(45.6, 40, 54.4, 62, 4)],
  'lower back': [_box(40, 64, 60, 82, 6)],
  'glutes': _pair(35, 84, 49.4, 106, 9),
  'hamstrings': _pair(36, 107, 49, 139, 7),
  'calves': _pair(37, 149, 46, 185, 7),
};

/// Widens the figure so it reads as a chunky sticker.
const kBodyStretch = 1.35;

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

  Map<String, List<_Shape>> get _muscles => back ? kBodyBack : kBodyFront;

  String? _hit(Offset local, Size size) {
    final s = size.height / 200, sx = s * kBodyStretch, dx = (size.width - 100 * sx) / 2;
    final p = Offset((local.dx - dx) / sx, local.dy / s);
    for (final e in _muscles.entries.toList().reversed) {
      for (final b in e.value) {
        if (p.dx >= b.l && p.dx <= b.r && p.dy >= b.t && p.dy <= b.b) return e.key;
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
          final s = height / 200, sx = s * kBodyStretch, dx = (box.maxWidth - 100 * sx) / 2;
          return GestureDetector(
            onTapUp: onSelect == null
                ? null
                : (d) {
                    final m = _hit(d.localPosition, size);
                    if (m != null) onSelect!(m == selected ? null : m);
                  },
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BodyPainter(
                      muscles: _muscles,
                      selected: selected,
                      primary: primary,
                      secondary: secondary,
                      colors: c,
                    ),
                  ),
                ),
                // Invisible, labelled tap targets for screen readers.
                for (final e in _muscles.entries)
                  Positioned(
                    left: dx + e.value.first.l * sx,
                    top: e.value.first.t * s,
                    width: (e.value.first.r - e.value.first.l) * sx,
                    height: (e.value.first.b - e.value.first.t) * s,
                    child: Semantics(
                      button: onSelect != null,
                      selected: selected == e.key,
                      label: muscleLabel(l, e.key),
                      onTap: onSelect == null ? null : () => onSelect!(e.key == selected ? null : e.key),
                      child: const SizedBox.expand(),
                    ),
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
    required this.muscles,
    required this.selected,
    required this.primary,
    required this.secondary,
    required this.colors,
  });

  final Map<String, List<_Shape>> muscles;
  final String? selected;
  final Set<String> primary;
  final Set<String> secondary;
  final AbsColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.height / 200, sx = s * kBodyStretch, dx = (size.width - 100 * sx) / 2;
    RRect rr(_Shape b) => RRect.fromRectAndRadius(
      Rect.fromLTRB(dx + b.l * sx, b.t * s, dx + b.r * sx, b.b * s),
      Radius.circular(b.radius * s),
    );
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = colors.isDark ? colors.border : colors.ink;
    final frame = Paint()..color = colors.surfaceRaised;
    for (final b in _frame) {
      canvas
        ..drawRRect(rr(b), frame)
        ..drawRRect(rr(b), outline);
    }
    final accent = colors.primary;
    for (final e in muscles.entries) {
      final m = e.key;
      final isSel = m == selected;
      final isPrimary = primary.contains(m);
      final isSecondary = secondary.contains(m);
      final fill = Paint()
        ..color = isSel || isPrimary
            ? accent.fill
            : isSecondary
            ? colors.pop(PopHue.sky).fill
            : colors.pop(muscleHue(m)).soft;
      for (final b in e.value) {
        final r = rr(b);
        if (isSel) {
          // Glow around the selected muscle.
          canvas.drawRRect(
            r.inflate(3),
            Paint()
              ..color = accent.fill.withValues(alpha: 0.55)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
          );
        }
        canvas
          ..drawRRect(r, fill)
          ..drawRRect(r, outline);
      }
    }
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.selected != selected ||
      old.primary != primary ||
      old.secondary != secondary ||
      old.muscles != muscles ||
      old.colors != colors;
}
