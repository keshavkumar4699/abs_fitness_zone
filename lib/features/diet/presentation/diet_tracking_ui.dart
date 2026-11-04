import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/diet_providers.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/food.dart';
import '../domain/nutrition.dart';
import 'diet_ui.dart';

/// Today's meals as a vertical timeline (6.8): time, meal, calories and how
/// it was marked. Tapping a meal opens [onTap].
class MealTimeline extends StatelessWidget {
  const MealTimeline({super.key, required this.plan, required this.marks, required this.lookup, this.onTap});

  final DietTemplate plan;
  final Map<String, MealLog> marks;
  final FoodLookup lookup;
  final ValueChanged<DietMeal>? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final meals = plan.orderedMeals;
    return Column(
      children: [
        for (final (n, m) in meals.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 52,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AbsSpace.x4),
                    child: Text(m.hhmm ?? '', style: t.numericOf(t.caption).copyWith(color: c.textSecondary)),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Expanded(child: Container(width: 3, color: n == 0 ? Colors.transparent : c.border)),
                      _Node(log: marks[m.slot]),
                      Expanded(
                        flex: 4,
                        child: Container(width: 3, color: n == meals.length - 1 ? Colors.transparent : c.border),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AbsSpace.x2),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
                    child: AbsCard(
                      key: ValueKey('timeline-${m.slot}'),
                      onTap: onTap == null ? null : () => onTap!(m),
                      hue: marks[m.slot] == null ? null : mealStatusHue(marks[m.slot]!.status),
                      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(mealSlotIcon(m.slot), size: AbsSize.iconSmall),
                              const SizedBox(width: AbsSpace.x2),
                              Expanded(child: Text(mealSlotLabel(l, m.slot), style: t.heading)),
                              if (marks[m.slot] case final log?)
                                PopSticker(label: mealStatusLabel(l, log.status), hue: mealStatusHue(log.status))
                              else
                                Text(kcalText(mealTotals(m, lookup).kcal), style: t.numericOf(t.label)),
                            ],
                          ),
                          const SizedBox(height: AbsSpace.x1),
                          Text(
                            m.main
                                .map((i) => '${foodOf(i, lookup)?.name ?? '—'} ${qtyText(l, foodOf(i, lookup), i.qty)}')
                                .join(' · '),
                            style: t.caption.copyWith(color: c.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({this.log});

  final MealLog? log;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = log == null ? null : c.pop(mealStatusHue(log!.status));
    return AnimatedContainer(
      duration: AbsMotion.bouncy.duration,
      curve: AbsMotion.bouncy.curve,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p?.fill ?? c.surface,
        border: Border.all(color: c.isDark ? (p?.deep ?? c.border) : c.ink, width: AbsDepth.outline),
      ),
      child: log == null ? null : Icon(mealStatusIcon(log!.status), size: 14, color: p!.onFill),
    );
  }
}

/// Mark a meal Eaten / Partly / Skipped / Swapped (6.8).
Future<void> showMealSheet(
  BuildContext context, {
  required DietMeal meal,
  required MealLog? current,
  required Future<void> Function(String? status, int? alt) onMark,
}) => showAbsBottomSheet<void>(
  context: context,
  builder: (context, controller) => _MealSheet(meal: meal, current: current, onMark: onMark, controller: controller),
);

class _MealSheet extends ConsumerWidget {
  const _MealSheet({required this.meal, required this.current, required this.onMark, required this.controller});

  final DietMeal meal;
  final MealLog? current;
  final Future<void> Function(String? status, int? alt) onMark;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    void mark(String? status, [int? alt]) {
      Navigator.pop(context);
      onMark(status, alt);
    }

    Widget foods(List<DietItem> items) => Column(
      children: [
        for (final i in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                if (foodOf(i, lookup) case final f?) ...[
                  VegMark(vegType: f.vegType, size: 12),
                  const SizedBox(width: AbsSpace.x2),
                ],
                Expanded(child: Text(foodOf(i, lookup)?.name ?? '—', style: t.body)),
                Text(qtyText(l, foodOf(i, lookup), i.qty), style: t.numericOf(t.label)),
              ],
            ),
          ),
      ],
    );

    Widget statusButton(String status, {int? alt, String? label}) {
      final on = current?.status == status && (status != 'swapped' || current?.altGroup == alt);
      return Padding(
        padding: const EdgeInsets.only(bottom: AbsSpace.x2),
        child: on
            ? AbsButton(
                key: ValueKey('mark-$status${alt ?? ''}'),
                label: label ?? mealStatusLabel(l, status),
                icon: mealStatusIcon(status),
                hue: mealStatusHue(status),
                onPressed: () => mark(status, alt),
              )
            : AbsButton.secondary(
                key: ValueKey('mark-$status${alt ?? ''}'),
                label: label ?? mealStatusLabel(l, status),
                icon: mealStatusIcon(status),
                onPressed: () => mark(status, alt),
              ),
      );
    }

    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x6),
      children: [
        Text([mealSlotLabel(l, meal.slot), ?meal.hhmm].join(' · '), style: t.title),
        Text(
          '${kcalText(mealTotals(meal, lookup).kcal)} · ${macroLine(l, mealTotals(meal, lookup))}',
          style: t.caption.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AbsSpace.x3),
        foods(meal.main),
        if (meal.notes != null)
          Padding(
            padding: const EdgeInsets.only(top: AbsSpace.x2),
            child: Text(meal.notes!, style: t.caption.copyWith(color: c.textSecondary)),
          ),
        for (final g in meal.options) ...[
          const SizedBox(height: AbsSpace.x3),
          Text(
            '${l.dietOr(g)} · ${kcalText(mealTotals(meal, lookup, group: g).kcal)}',
            style: t.label.copyWith(color: c.pop(PopHue.sky).text),
          ),
          foods(meal.group(g)),
        ],
        const SizedBox(height: AbsSpace.x5),
        statusButton('eaten'),
        statusButton('partly'),
        for (final g in meal.options) statusButton('swapped', alt: g, label: l.markSwappedTo(l.dietOr(g))),
        statusButton('skipped'),
        if (current != null)
          AbsButton.ghost(
            key: const ValueKey('mark-clear'),
            label: l.markClear,
            icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.bold),
            onPressed: () => mark(null),
          ),
      ],
    );
  }
}

/// A glass that fills with a gentle wave (6.9), with − and +.
class WaterTracker extends StatelessWidget {
  const WaterTracker({super.key, required this.glasses, required this.goal, this.onChanged});

  final int glasses;
  final int goal;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final fill = goal == 0 ? 0.0 : (glasses / goal).clamp(0.0, 1.0);
    return AbsCard(
      key: const ValueKey('water-card'),
      hue: PopHue.sky,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Row(
        children: [
          SizedBox(width: 64, height: 84, child: _WaveGlass(level: fill)),
          const SizedBox(width: AbsSpace.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.waterTitle, style: t.heading),
                Text(l.waterGlasses(glasses, goal), key: const ValueKey('water-count'), style: t.numericOf(t.title)),
                Text(l.waterGoalHint, style: t.caption.copyWith(color: c.textSecondary)),
              ],
            ),
          ),
          if (onChanged != null)
            Column(
              children: [
                IconButton.filledTonal(
                  key: const ValueKey('water-plus'),
                  tooltip: l.waterAdd,
                  icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
                  onPressed: glasses >= 30 ? null : () => onChanged!(glasses + 1),
                ),
                IconButton(
                  key: const ValueKey('water-minus'),
                  tooltip: l.waterRemove,
                  icon: Icon(PhosphorIcons.minus(PhosphorIconsStyle.bold)),
                  onPressed: glasses <= 0 ? null : () => onChanged!(glasses - 1),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The glass: when the level changes, the water rises (or falls) with a
/// wave that sloshes once and settles (expressive token); with reduced
/// motion it just moves to the new level.
class _WaveGlass extends StatefulWidget {
  const _WaveGlass({required this.level});

  final double level;

  @override
  State<_WaveGlass> createState() => _WaveGlassState();
}

class _WaveGlassState extends State<_WaveGlass> with SingleTickerProviderStateMixin {
  late final _ctl = AnimationController(vsync: this, duration: AbsMotion.expressive.duration, value: 1);
  late double _from = widget.level;

  @override
  void didUpdateWidget(_WaveGlass old) {
    super.didUpdateWidget(old);
    if (old.level == widget.level) return;
    _from = old.level;
    if (AbsMotion.reduced(context)) {
      _ctl.value = 1;
    } else {
      _ctl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(PopHue.sky);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctl,
        builder: (context, _) {
          final t = _ctl.value;
          final eased = AbsMotion.expressive.curve.transform(t);
          return CustomPaint(
            painter: _GlassPainter(
              level: _from + (widget.level - _from) * eased,
              phase: t * 2 * math.pi,
              amplitude: math.sin(t * math.pi) * 4,
              water: p.fill,
              edge: c.isDark ? p.deep : c.ink,
            ),
          );
        },
      ),
    );
  }
}

class _GlassPainter extends CustomPainter {
  _GlassPainter({
    required this.level,
    required this.phase,
    required this.amplitude,
    required this.water,
    required this.edge,
  });

  final double level;
  final double phase;
  final double amplitude;
  final Color water;
  final Color edge;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = size.width * 0.12;
    final glass = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - inset, size.height)
      ..lineTo(inset, size.height)
      ..close();
    canvas.save();
    canvas.clipPath(glass);
    if (level > 0) {
      final top = size.height * (1 - level);
      final amp = level >= 1 ? 0.0 : amplitude;
      final wave = Path()..moveTo(0, size.height);
      for (var x = 0.0; x <= size.width; x += 2) {
        wave.lineTo(x, top + math.sin(x / size.width * 2 * math.pi + phase) * amp);
      }
      wave
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(wave, Paint()..color = water);
    }
    canvas.restore();
    canvas.drawPath(
      glass,
      Paint()
        ..color = edge
        ..style = PaintingStyle.stroke
        ..strokeWidth = AbsDepth.outline
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_GlassPainter old) =>
      old.level != level || old.phase != phase || old.amplitude != amplitude || old.water != water;
}

/// Tick off the day's supplements (6.9).
class SupplementChecklist extends StatelessWidget {
  const SupplementChecklist({super.key, required this.names, required this.taken, this.onChanged});

  final List<String> names;
  final Set<String> taken;
  final void Function(String name, bool taken)? onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AbsCard(
      key: const ValueKey('supplements-card'),
      title: l.dietSupplements,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Wrap(
        spacing: AbsSpace.x2,
        runSpacing: AbsSpace.x2,
        children: [
          for (final s in names)
            PopChip(
              key: ValueKey('supp-$s'),
              label: s,
              icon: taken.contains(s)
                  ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                  : PhosphorIcons.circle(PhosphorIconsStyle.bold),
              hue: PopHue.tangerine,
              selected: taken.contains(s),
              onTap: onChanged == null ? () {} : () => onChanged!(s, !taken.contains(s)),
            ),
        ],
      ),
    );
  }
}

/// Weekly adherence bars with the weight trend on top (6.11).
class AdherenceWeightChart extends StatelessWidget {
  const AdherenceWeightChart({super.key, required this.weeks, required this.measurements});

  final List<({DateTime week, double? adherence})> weeks;
  final List<Measurement> measurements;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final weights = <double?>[
      for (final w in weeks)
        () {
          final inWeek = [
            for (final m in measurements)
              if (m.weightKg != null &&
                  m.measuredOn != null &&
                  !m.measuredOn!.isBefore(w.week) &&
                  m.measuredOn!.isBefore(w.week.add(const Duration(days: 7))))
                m.weightKg!.toDouble(),
          ];
          return inWeek.isEmpty ? null : inWeek.reduce((a, b) => a + b) / inWeek.length;
        }(),
    ];
    final bar = c.pop(PopHue.mint);
    final line = c.pop(PopHue.grape);
    Widget key(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AbsSpace.x1),
        Text(label, style: t.caption.copyWith(color: c.textSecondary)),
      ],
    );
    final known = weights.whereType<double>().toList();
    return AbsCard(
      key: const ValueKey('adherence-chart'),
      title: l.dietWeeklyAdherence,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: _AdherencePainter(
                  values: [for (final w in weeks) w.adherence],
                  weights: weights,
                  bar: bar.fill,
                  barEdge: c.isDark ? bar.deep : c.ink,
                  track: c.border,
                  line: line.text,
                ),
              ),
            ),
          ),
          const SizedBox(height: AbsSpace.x2),
          Row(
            children: [
              Text(dateLabel(weeks.first.week), style: t.caption.copyWith(color: c.textSecondary)),
              const Spacer(),
              Text(l.dietThisWeek, style: t.caption.copyWith(color: c.textSecondary)),
            ],
          ),
          const SizedBox(height: AbsSpace.x2),
          Wrap(
            spacing: AbsSpace.x4,
            children: [
              key(bar.fill, l.dietAdherence),
              if (known.isNotEmpty)
                key(
                  line.text,
                  l.dietWeightRange(
                    known.reduce(math.min).toStringAsFixed(1),
                    known.reduce(math.max).toStringAsFixed(1),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdherencePainter extends CustomPainter {
  _AdherencePainter({
    required this.values,
    required this.weights,
    required this.bar,
    required this.barEdge,
    required this.track,
    required this.line,
  });

  final List<double?> values;
  final List<double?> weights;
  final Color bar;
  final Color barEdge;
  final Color track;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final slot = size.width / n;
    final w = slot * 0.56;
    for (var i = 0; i < n; i++) {
      final x = slot * i + (slot - w) / 2;
      final r = RRect.fromRectAndRadius(Rect.fromLTWH(x, 0, w, size.height), const Radius.circular(6));
      canvas.drawRRect(r, Paint()..color = track.withValues(alpha: 0.35));
      final v = values[i];
      if (v == null || v <= 0) continue;
      final h = size.height * v.clamp(0, 1);
      final fill = RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height - h, w, h), const Radius.circular(6));
      canvas
        ..drawRRect(fill, Paint()..color = bar)
        ..drawRRect(
          fill,
          Paint()
            ..color = barEdge
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
    }
    final known = weights.whereType<double>().toList();
    if (known.isEmpty) return;
    final lo = known.reduce(math.min) - 0.5, hi = known.reduce(math.max) + 0.5;
    final pts = <Offset>[
      for (var i = 0; i < n; i++)
        if (weights[i] != null)
          Offset(slot * i + slot / 2, size.height * (1 - (weights[i]! - lo) / (hi - lo)) * 0.8 + size.height * 0.1),
    ];
    final paint = Paint()
      ..color = line
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    if (pts.length > 1) canvas.drawPath(Path()..addPolygon(pts, false), paint);
    for (final p in pts) {
      canvas
        ..drawCircle(p, 4.5, Paint()..color = line)
        ..drawCircle(p, 2, Paint()..color = bar);
    }
  }

  @override
  bool shouldRepaint(_AdherencePainter old) => old.values != values || old.weights != weights || old.bar != bar;
}

/// Food preference, allergies and foods to avoid (6.4), for the member or
/// their coach.
Future<void> showPreferencesSheet(BuildContext context, {required DietFlags flags}) => showAbsBottomSheet<void>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _PreferencesSheet(flags: flags, controller: controller),
);

class _PreferencesSheet extends ConsumerStatefulWidget {
  const _PreferencesSheet({required this.flags, required this.controller});

  final DietFlags flags;
  final ScrollController controller;

  @override
  ConsumerState<_PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends ConsumerState<_PreferencesSheet> {
  late String? _pref = widget.flags.dietPref;
  late Set<String> _allergies = widget.flags.allergies.toSet();
  late final _avoid = TextEditingController(text: widget.flags.avoid.join(', '));
  bool _busy = false;

  @override
  void dispose() {
    _avoid.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      await ref
          .read(dietRepositoryProvider)
          .setPreferences(
            widget.flags.memberId,
            dietPref: _pref,
            allergies: [
              for (final a in kAllergens)
                if (_allergies.contains(a)) a,
            ],
            avoid: [
              for (final w in _avoid.text.split(','))
                if (w.trim().isNotEmpty) w.trim(),
            ],
          );
      ref.refreshDiet(widget.flags.memberId);
      if (!mounted) return;
      showAbsSnackbar(context, l.prefsSaved, tone: SnackTone.success);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: t.label.copyWith(color: c.textSecondary)),
    );
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.prefsTitle, style: t.title),
              label(l.dietPreference),
              PopSingleChips<String>(
                options: kDietPrefs,
                labelOf: (p) => dietPrefLabel(l, p),
                value: _pref,
                hue: PopHue.mint,
                onChanged: (v) => setState(() => _pref = v),
              ),
              label(l.prefsAllergies),
              PopChoiceChips<String>(
                options: kAllergens,
                labelOf: (a) => allergenLabel(l, a),
                selected: _allergies,
                hue: PopHue.coral,
                onChanged: (v) => setState(() => _allergies = v),
              ),
              label(l.prefsAvoid),
              AbsTextField(key: const ValueKey('prefs-avoid'), label: l.prefsAvoidHint, controller: _avoid),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('prefs-save'),
            label: l.commonSave,
            hue: PopHue.lime,
            isLoading: _busy,
            onPressed: _save,
          ),
        ),
      ],
    );
  }
}

/// Coach comments on the member's nutrition (6.11).
class DietCommentsCard extends StatelessWidget {
  const DietCommentsCard({super.key, required this.comments, this.footer});

  final List<DietComment> comments;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    return AbsCard(
      key: const ValueKey('diet-comments'),
      title: l.dietCoachNotes,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comments.isEmpty) Text(l.dietNoNotes, style: t.body.copyWith(color: c.textSecondary)),
          for (final x in comments.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(PhosphorIcons.chatCircleText(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
                  const SizedBox(width: AbsSpace.x2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(x.body, style: t.body),
                        Text(
                          '${x.authorName} · ${dateLabel(x.createdAt)}',
                          style: t.caption.copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ?footer,
        ],
      ),
    );
  }
}
