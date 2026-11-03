import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/presentation/exercise_library.dart';
import '../../exercises/presentation/exercise_ui.dart';
import '../../members/presentation/member_ui.dart' show levelLabel;
import '../application/workouts_providers.dart';
import '../data/workouts_repository.dart';
import '../domain/workout_models.dart';
import 'workout_ui.dart';

/// Routine and program builder (5.1, 5.2): days, exercises in order (drag to
/// reorder), sets × reps or time, targets, rest, tempo, supersets, warm-up
/// and cool-down, weeks and the weekly progression rule.
class ProgramBuilderScreen extends ConsumerStatefulWidget {
  const ProgramBuilderScreen({super.key, this.templateId, this.memberId});

  /// Null for a new program.
  final String? templateId;

  /// Set when tuning a member's own copy (refreshes their views on save).
  final String? memberId;

  @override
  ConsumerState<ProgramBuilderScreen> createState() => _ProgramBuilderScreenState();
}

class _ProgramBuilderScreenState extends ConsumerState<ProgramBuilderScreen> {
  WorkoutTemplate? _t;
  int _day = 0;
  bool _dirty = false;
  bool _busy = false;
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _step = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _step.dispose();
    super.dispose();
  }

  void _init(WorkoutTemplate t) {
    _t = t;
    _name.text = t.name;
    _description.text = t.description ?? '';
    final step = t.progressionStep ?? 0;
    _step.text = step == 0 ? '' : (step % 1 == 0 ? step.toInt().toString() : step.toString());
  }

  void _edit(WorkoutTemplate Function(WorkoutTemplate t) change) => setState(() {
    _t = change(_t!);
    _dirty = true;
  });

  List<WorkoutDay> get _days => _t!.orderedDays;

  void _setDay(int i, WorkoutDay d) => _edit((t) {
    final days = [..._days]..[i] = d;
    return t.copyWith(days: days);
  });

  WorkoutItem _defaults(Exercise e, int position) => switch (e.trackingType) {
    TrackingType.repsWeight => WorkoutItem(exerciseId: e.id, position: position, sets: 3, reps: 10, restS: 90),
    TrackingType.reps => WorkoutItem(exerciseId: e.id, position: position, sets: 3, reps: 12, restS: 60),
    TrackingType.time => WorkoutItem(exerciseId: e.id, position: position, sets: 3, durationS: 30, restS: 45),
    TrackingType.distanceTime => WorkoutItem(exerciseId: e.id, position: position, sets: 1, durationS: 600, restS: 60),
  };

  Future<void> _addExercises() async {
    final picked = await showExercisePicker(context);
    if (picked == null || picked.isEmpty) return;
    final d = _days[_day];
    final start = d.items.length;
    _setDay(_day, d.copyWith(items: [...d.ordered, for (final (i, e) in picked.indexed) _defaults(e, start + i + 1)]));
  }

  void _addDay() {
    final n = _days.length + 1;
    _edit(
      (t) => t.copyWith(
        days: [
          ..._days,
          WorkoutDay(dayIndex: n, name: context.l10n.buildDay(n)),
        ],
      ),
    );
    setState(() => _day = n - 1);
  }

  void _removeDay(int i) {
    final days = [..._days]..removeAt(i);
    _edit((t) => t.copyWith(days: [for (final (n, d) in days.indexed) d.copyWith(dayIndex: n + 1)]));
    setState(() => _day = _day.clamp(0, days.length - 1));
  }

  Future<void> _renameDay(int i) async {
    final l = context.l10n;
    final name = await promptText(context, title: l.buildRenameDay, label: l.buildDayName, initial: _days[i].name);
    if (name != null && name.isNotEmpty) _setDay(i, _days[i].copyWith(name: name));
  }

  Future<void> _editItem(int index) async {
    final d = _days[_day];
    final items = d.ordered;
    final result = await showItemSheet(context, items[index]);
    if (result == null) return;
    final next = [...items];
    if (result.remove) {
      next.removeAt(index);
    } else {
      next[index] = result.item!;
    }
    _setDay(_day, d.copyWith(items: [for (final (p, i) in next.indexed) i.copyWith(position: p + 1)]));
  }

  void _reorder(int from, int to) {
    final d = _days[_day];
    final items = [...d.ordered];
    items.insert(to, items.removeAt(from));
    _setDay(_day, d.copyWith(items: [for (final (p, i) in items.indexed) i.copyWith(position: p + 1)]));
  }

  Future<void> _save() async {
    final l = context.l10n;
    final t = _t!.copyWith(
      name: _name.text.trim(),
      description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      progressionStep: double.tryParse(_step.text.replaceAll(',', '.')) ?? 0,
    );
    if (t.name.length < 2) {
      showAbsSnackbar(context, l.buildNeedsName, tone: SnackTone.error);
      return;
    }
    if (t.days.isEmpty || t.days.any((d) => d.items.isEmpty)) {
      showAbsSnackbar(context, l.buildNeedsExercises, tone: SnackTone.error);
      return;
    }
    setState(() => _busy = true);
    try {
      final id = await ref.read(workoutsRepositoryProvider).saveTemplate(t);
      ref
        ..invalidate(templateListProvider)
        ..invalidate(templateDetailProvider(id));
      if (widget.memberId != null) ref.refreshWorkouts(widget.memberId!);
      if (!mounted) return;
      _dirty = false;
      showAbsSnackbar(context, l.buildSaved, tone: SnackTone.success);
      context.pop(id);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty) return true;
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.buildDiscardTitle),
        content: Text(l.buildDiscardBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.buildKeepEditing)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.buildDiscard, style: TextStyle(color: context.colors.danger)),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_t == null) {
      if (widget.templateId == null) {
        _init(
          WorkoutTemplate(
            name: '',
            days: [WorkoutDay(name: l.buildDay(1))],
          ),
        );
      } else {
        final loaded = ref.watch(templateDetailProvider(widget.templateId!));
        if (loaded.hasValue) {
          _init(loaded.value!);
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(l.buildEditTitle)),
            body: AsyncView<WorkoutTemplate>(
              value: loaded,
              isEmpty: (_) => false,
              empty: const SizedBox.shrink(),
              onRetry: () => ref.invalidate(templateDetailProvider(widget.templateId!)),
              loading: const SkeletonList(itemCount: 5),
              data: (_) => const SizedBox.shrink(),
            ),
          );
        }
      }
    }
    final t = _t!;
    final c = context.colors;
    final tt = context.text;
    final days = _days;
    final day = days[_day.clamp(0, days.length - 1)];
    final catalogue = ref.watch(exerciseCatalogueProvider).value;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: tt.label.copyWith(color: c.textSecondary)),
    );

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) {
          _dirty = false;
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.templateId == null ? l.buildNewTitle : l.buildEditTitle)),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x2),
            child: AbsButton(
              key: const ValueKey('builder-save'),
              label: l.commonSave,
              hue: PopHue.lime,
              isLoading: _busy,
              onPressed: _save,
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x8),
          children: [
            AbsTextField(
              key: const ValueKey('builder-name'),
              label: l.buildName,
              controller: _name,
              onChanged: (_) => _dirty = true,
            ),
            const SizedBox(height: AbsSpace.x3),
            AbsTextField(label: l.buildDescription, controller: _description, onChanged: (_) => _dirty = true),
            label(l.buildGoal),
            PopSingleChips<String>(
              options: kWorkoutGoals,
              labelOf: (g) => goalShort(l, g),
              value: t.goal,
              hue: PopHue.coral,
              onChanged: (g) => _edit((t) => t.copyWith(goal: g)),
            ),
            label(l.buildLevel),
            PopSingleChips<String>(
              options: kWorkoutLevels,
              labelOf: (v) => levelLabel(l, v),
              value: t.level,
              hue: PopHue.sky,
              onChanged: (v) => _edit((t) => t.copyWith(level: v)),
            ),
            label(l.buildWeeks),
            Row(
              children: [
                IconButton.outlined(
                  tooltip: '−',
                  icon: Icon(PhosphorIcons.minus(PhosphorIconsStyle.bold)),
                  onPressed: t.weeks > 1 ? () => _edit((t) => t.copyWith(weeks: t.weeks - 1)) : null,
                ),
                SizedBox(
                  width: 120,
                  child: Text(l.progWeeks(t.weeks), textAlign: TextAlign.center, style: tt.numericOf(tt.title)),
                ),
                IconButton.outlined(
                  tooltip: '+',
                  icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
                  onPressed: t.weeks < 52 ? () => _edit((t) => t.copyWith(weeks: t.weeks + 1)) : null,
                ),
              ],
            ),
            label(l.buildProgression),
            SegmentedTabs(
              dense: true,
              hue: PopHue.grape,
              labels: [l.progProgressionNone, '+ kg', '+ reps'],
              selected: t.progression.index,
              onChanged: (i) => _edit((t) => t.copyWith(progression: Progression.values[i])),
            ),
            if (t.progression != Progression.none) ...[
              const SizedBox(height: AbsSpace.x3),
              SizedBox(
                width: 160,
                child: AbsTextField(
                  label: '${l.buildStep} (${t.progression == Progression.weight ? l.playKg : l.playReps})',
                  controller: _step,
                  numeric: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _dirty = true,
                ),
              ),
            ],
            const SizedBox(height: AbsSpace.x6),
            SizedBox(
              height: AbsSize.touchTarget,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final (i, d) in days.indexed) ...[
                    PopChip(
                      key: ValueKey('builder-day-$i'),
                      label: '${l.buildDay(i + 1)} · ${d.name}',
                      selected: i == _day,
                      hue: PopHue.lime,
                      onTap: () => setState(() => _day = i),
                    ),
                    const SizedBox(width: AbsSpace.x2),
                  ],
                  if (days.length < 7)
                    PopChip(
                      key: const ValueKey('builder-add-day'),
                      label: l.buildAddDay,
                      icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                      selected: false,
                      onTap: _addDay,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AbsSpace.x3),
            Row(
              children: [
                Expanded(child: Text(day.name, style: tt.title)),
                IconButton(
                  tooltip: l.buildRenameDay,
                  icon: Icon(PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold)),
                  onPressed: () => _renameDay(_day),
                ),
                if (days.length > 1)
                  IconButton(
                    tooltip: l.buildRemoveDay,
                    icon: Icon(PhosphorIcons.trash(PhosphorIconsStyle.bold)),
                    onPressed: () => _removeDay(_day),
                  ),
              ],
            ),
            if (day.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AbsSpace.x4),
                child: Text(l.buildEmptyDay, style: tt.body.copyWith(color: c.textSecondary)),
              )
            else ...[
              Text(l.buildDragHint, style: tt.caption.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x2),
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                onReorderItem: _reorder,
                children: [
                  for (final (i, item) in day.ordered.indexed)
                    Padding(
                      key: ValueKey('item-$i-${item.exerciseId}'),
                      padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                      child: AbsCard(
                        onTap: () => _editItem(i),
                        padding: const EdgeInsets.fromLTRB(AbsSpace.x3, AbsSpace.x2, AbsSpace.x1, AbsSpace.x2),
                        child: Row(
                          children: [
                            Expanded(child: ProgramItemRow(item: item)),
                            ReorderableDragStartListener(
                              index: i,
                              child: Padding(
                                padding: const EdgeInsets.all(AbsSpace.x2),
                                child: Icon(
                                  PhosphorIcons.dotsSixVertical(PhosphorIconsStyle.bold),
                                  color: c.textSecondary,
                                  semanticLabel: l.buildDragHint,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AbsSpace.x2),
            AbsButton.secondary(
              key: const ValueKey('builder-add-exercises'),
              label: l.buildAddExercises,
              icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
              onPressed: catalogue == null ? null : _addExercises,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sets and targets for one exercise in a day.
Future<({WorkoutItem? item, bool remove})?> showItemSheet(BuildContext context, WorkoutItem item) =>
    showAbsBottomSheet<({WorkoutItem? item, bool remove})>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _ItemSheet(controller: controller, item: item),
    );

class _ItemSheet extends ConsumerStatefulWidget {
  const _ItemSheet({required this.controller, required this.item});

  final ScrollController controller;
  final WorkoutItem item;

  @override
  ConsumerState<_ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends ConsumerState<_ItemSheet> {
  late final _sets = TextEditingController(text: '${widget.item.sets}');
  late final _reps = TextEditingController(text: widget.item.reps?.toString() ?? '');
  late final _repsMax = TextEditingController(text: widget.item.repsMax?.toString() ?? '');
  late final _secs = TextEditingController(text: widget.item.durationS?.toString() ?? '');
  late final _metres = TextEditingController(text: widget.item.distanceM?.toString() ?? '');
  late final _weight = TextEditingController(text: _num(widget.item.targetWeight));
  late final _rpe = TextEditingController(text: _num(widget.item.rpe));
  late final _rest = TextEditingController(text: '${widget.item.restS}');
  late final _tempo = TextEditingController(text: widget.item.tempo ?? '');
  late final _notes = TextEditingController(text: widget.item.notes ?? '');
  late ItemBlock _block = widget.item.block;
  late String? _group = widget.item.groupKey;

  static String _num(double? v) => v == null ? '' : (v % 1 == 0 ? v.toInt().toString() : v.toString());

  @override
  void dispose() {
    for (final c in [_sets, _reps, _repsMax, _secs, _metres, _weight, _rpe, _rest, _tempo, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  int? _int(TextEditingController c) => int.tryParse(c.text.trim());
  double? _dbl(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.'));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final ex = ref.watch(exerciseCatalogueProvider).value?[widget.item.exerciseId];
    final tracking = ex?.trackingType ?? TrackingType.repsWeight;
    const gap = SizedBox(width: AbsSpace.x2);
    Widget field(String label, TextEditingController ctrl, {bool decimal = false, Key? key}) => Expanded(
      child: AbsTextField(
        key: key,
        label: label,
        controller: ctrl,
        numeric: true,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(decimal ? r'[0-9.,]' : r'[0-9]'))],
      ),
    );
    Widget row(List<Widget> children) => Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: Row(children: children),
    );
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(ex?.name ?? l.buildItemTitle, style: t.title),
              Text(trackingLabel(l, tracking), style: t.caption.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x4),
              row([
                field(l.buildSets, _sets, key: const ValueKey('item-sets')),
                gap,
                if (tracking.usesReps) ...[
                  field(l.buildReps, _reps, key: const ValueKey('item-reps')),
                  gap,
                  field(l.buildRepsMax, _repsMax),
                ] else
                  field(l.buildSeconds, _secs),
              ]),
              if (tracking == TrackingType.distanceTime) row([field(l.buildMetres, _metres)]),
              row([
                if (tracking.usesWeight) ...[field(l.buildWeight, _weight, decimal: true), gap],
                field(l.buildRpe, _rpe, decimal: true),
              ]),
              row([
                field(l.buildRestSeconds, _rest),
                gap,
                Expanded(
                  child: AbsTextField(label: l.buildTempo, controller: _tempo),
                ),
              ]),
              AbsTextField(label: l.buildNotes, controller: _notes),
              const SizedBox(height: AbsSpace.x4),
              Text(l.buildBlock, style: t.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x2),
              PopSingleChips<ItemBlock>(
                options: ItemBlock.values,
                labelOf: (b) => blockLabel(l, b),
                value: _block,
                allowEmpty: false,
                hue: PopHue.tangerine,
                onChanged: (b) => setState(() => _block = b ?? ItemBlock.main),
              ),
              const SizedBox(height: AbsSpace.x4),
              Text(l.buildGroup, style: t.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x2),
              PopSingleChips<String>(
                options: const ['A', 'B', 'C', 'D', 'E', 'F'],
                labelOf: (g) => l.superset(g),
                value: _group,
                hue: PopHue.grape,
                onChanged: (g) => setState(() => _group = g),
              ),
              const SizedBox(height: AbsSpace.x4),
              AbsButton.ghost(
                label: l.buildRemoveItem,
                icon: PhosphorIcons.trash(PhosphorIconsStyle.bold),
                hue: PopHue.coral,
                onPressed: () => Navigator.pop(context, (item: null, remove: true)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('item-done'),
            label: l.commonDone,
            hue: PopHue.lime,
            onPressed: () {
              final reps = _int(_reps);
              final max = _int(_repsMax);
              final tempo = _tempo.text.trim();
              Navigator.pop(context, (
                item: widget.item.copyWith(
                  sets: (_int(_sets) ?? widget.item.sets).clamp(1, 20),
                  reps: tracking.usesReps ? reps?.clamp(1, 100) : null,
                  repsMax: tracking.usesReps && max != null && reps != null && max > reps ? max.clamp(1, 100) : null,
                  durationS: tracking.usesTime ? _int(_secs)?.clamp(1, 7200) : null,
                  distanceM: tracking == TrackingType.distanceTime ? _int(_metres)?.clamp(1, 100000) : null,
                  targetWeight: tracking.usesWeight ? _dbl(_weight)?.clamp(0, 1000) : null,
                  rpe: _dbl(_rpe)?.clamp(1, 10),
                  restS: (_int(_rest) ?? widget.item.restS).clamp(0, 900),
                  tempo: RegExp(r'^[0-9X]-[0-9X]-[0-9X](-[0-9X])?$').hasMatch(tempo) ? tempo : null,
                  notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                  block: _block,
                  groupKey: _group,
                ),
                remove: false,
              ));
            },
          ),
        ),
      ],
    );
  }
}
