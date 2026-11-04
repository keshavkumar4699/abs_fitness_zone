import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/application/members_providers.dart';
import '../application/diet_providers.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/food.dart';
import '../domain/nutrition.dart';
import 'diet_training_views.dart';
import 'diet_ui.dart';
import 'targets_sheet.dart';

/// The meal-wise plan builder (6.3–6.5): meals in the order of the day with
/// times and notes, foods with amounts in sensible steps, up to two "or"
/// options per meal, supplements, targets (with the calculator), and a live
/// totals bar. With [memberId] it edits that member's own plan and warns
/// about their preferences, allergies and health conditions.
class DietBuilderScreen extends ConsumerStatefulWidget {
  const DietBuilderScreen({super.key, this.templateId, this.memberId, this.initial});

  final String? templateId;
  final String? memberId;

  /// An unsaved plan to start from (a scaled duplicate).
  final DietTemplate? initial;

  @override
  ConsumerState<DietBuilderScreen> createState() => _DietBuilderScreenState();
}

class _DietBuilderScreenState extends ConsumerState<DietBuilderScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _kcal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  DietTemplate? _t;
  bool _dirty = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _load(widget.initial!);
      _dirty = true;
    } else if (widget.templateId == null) {
      _load(
        DietTemplate(
          name: '',
          kcalTarget: 2000,
          macroPreset: 'balanced',
          meals: [
            for (final s in const ['breakfast', 'lunch', 'evening_snack', 'dinner'])
              DietMeal(slot: s, time: kDefaultMealTimes[s]),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _description, _kcal, _protein, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  void _load(DietTemplate t) {
    _t = t;
    _name.text = t.name;
    _description.text = t.description ?? '';
    _kcal.text = '${t.kcalTarget}';
    _protein.text = t.proteinG?.toString() ?? '';
    _carbs.text = t.carbsG?.toString() ?? '';
    _fat.text = t.fatG?.toString() ?? '';
  }

  void _change(DietTemplate Function(DietTemplate) f) => setState(() {
    _t = f(_t!);
    _dirty = true;
  });

  void _changeMeal(String slot, DietMeal Function(DietMeal) f) =>
      _change((t) => t.copyWith(meals: [for (final m in t.meals) m.slot == slot ? f(m) : m]));

  /// Renumbers each option's items 1..n.
  static List<DietItem> _renumber(List<DietItem> items) {
    final out = <DietItem>[];
    for (final g in const [0, 1, 2]) {
      var n = 0;
      for (final i in items.where((i) => i.altGroup == g)) {
        out.add(i.copyWith(position: ++n));
      }
    }
    return out;
  }

  int? _int(TextEditingController c) => int.tryParse(c.text.trim());

  DietTemplate _current() => _t!.copyWith(
    name: _name.text.trim(),
    description: _description.text.trim().isEmpty ? null : _description.text.trim(),
    kcalTarget: _int(_kcal) ?? _t!.kcalTarget,
    proteinG: _int(_protein),
    carbsG: _int(_carbs),
    fatG: _int(_fat),
  );

  Future<void> _save() async {
    final l = context.l10n;
    final t = _current();
    if (t.name.length < 2) {
      showAbsSnackbar(context, l.buildNeedsName, tone: SnackTone.error);
      return;
    }
    if (t.kcalTarget < 800 || t.kcalTarget > 6000) {
      showAbsSnackbar(context, l.dietKcalRange, tone: SnackTone.error);
      return;
    }
    if (t.meals.isEmpty || t.meals.any((m) => m.main.isEmpty)) {
      showAbsSnackbar(context, l.dietNeedsFoods, tone: SnackTone.error);
      return;
    }
    setState(() => _busy = true);
    try {
      final id = await ref.read(dietRepositoryProvider).saveTemplate(t);
      ref
        ..invalidate(dietTemplateListProvider)
        ..invalidate(dietTemplateDetailProvider(id));
      if (widget.memberId != null) ref.refreshDiet(widget.memberId!);
      if (!mounted) return;
      _dirty = false;
      showAbsSnackbar(context, l.dietSaved, tone: SnackTone.success);
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
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.buildDiscard)),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _calculate(DietFlags? flags) async {
    final memberId = widget.memberId;
    var input = TargetsInput(goal: _t!.goal, preset: _t!.macroPreset);
    if (memberId != null) {
      final member = ref.read(memberProvider(memberId)).value;
      final health = ref.read(memberHealthProvider(memberId)).value;
      final weight = ref.read(memberWeightProvider(memberId)).value;
      input = TargetsInput(
        gender: member?.gender,
        age: member?.dob == null ? null : ageOn(member!.dob!, IstDates.today()),
        heightCm: health?.heightCm?.toDouble(),
        weightKg: weight,
        goal: _t!.goal,
        preset: _t!.macroPreset,
      );
    }
    final r = await showTargetsSheet(context, input: input);
    if (r == null || !mounted) return;
    _kcal.text = '${r.targets.kcal}';
    _protein.text = '${r.targets.protein}';
    _carbs.text = '${r.targets.carbs}';
    _fat.text = '${r.targets.fat}';
    _change((t) => t.copyWith(kcalTarget: r.targets.kcal, macroPreset: r.preset, goal: r.goal));
  }

  /// Scales every amount so the plan's calories match the target.
  void _scaleToTarget(FoodLookup lookup) {
    final t = _current();
    final planned = dayTotals(t, lookup).kcal.round();
    if (planned <= 0) return;
    final scaled = scaleTemplate(t.copyWith(kcalTarget: planned), t.kcalTarget, lookup);
    _change((_) => t.copyWith(meals: scaled.meals));
  }

  Future<void> _addFoods(String slot, int group, {String? dietPref, DietFlags? flags}) async {
    final picked = await showFoodPicker(context, dietPref: dietPref, flags: flags);
    if (picked == null || picked.isEmpty) return;
    _changeMeal(
      slot,
      (m) => m.copyWith(
        items: _renumber([
          ...m.items,
          for (final f in picked) DietItem(foodId: f.id, food: f, qty: 1, altGroup: group, position: 99),
        ]),
      ),
    );
  }

  void _suggestOption(DietMeal m, FoodIndex index, String? pref) {
    final group = m.options.contains(1) ? 2 : 1;
    final swap = suggestSwap(m.main, index, dietPref: pref);
    _changeMeal(
      m.slot,
      (x) => x.copyWith(items: _renumber([...x.items, for (final i in swap) i.copyWith(altGroup: group)])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final tt = context.text;
    if (_t == null && widget.templateId != null) {
      final loaded = ref.watch(dietTemplateDetailProvider(widget.templateId!));
      if (loaded.value case final t?) {
        _load(t);
      } else {
        return Scaffold(
          appBar: AppBar(title: Text(l.dietEditTitle)),
          body: loaded.hasError
              ? ErrorState(
                  message: friendlyError(l, loaded.error!),
                  onRetry: () => ref.invalidate(dietTemplateDetailProvider(widget.templateId!)),
                )
              : const SkeletonList(itemCount: 5),
        );
      }
    }
    final index = ref.watch(foodCatalogueProvider).value;
    final lookup = lookupIn(index);
    final memberId = widget.memberId;
    final flags = memberId == null ? null : ref.watch(dietFlagsProvider(memberId)).value;
    if (memberId != null) {
      // Loaded early so the calculator starts from the member's profile.
      ref
        ..watch(memberProvider(memberId))
        ..watch(memberHealthProvider(memberId))
        ..watch(memberWeightProvider(memberId));
    }
    final t = _t!;
    final total = dayTotals(t, lookup);
    final target = MacroTargets(
      kcal: _int(_kcal) ?? t.kcalTarget,
      protein: _int(_protein) ?? 0,
      carbs: _int(_carbs) ?? 0,
      fat: _int(_fat) ?? 0,
    );
    final pref = flags?.dietPref ?? t.dietPref;
    final conflicts = planConflicts(t, lookup, member: flags);
    final offTarget = target.kcal > 0 && total.kcal > 0 && (total.kcal - target.kcal).abs() > target.kcal * 0.05;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: tt.label.copyWith(color: c.textSecondary)),
    );
    Widget numField(String key, String text, TextEditingController ctl) => Expanded(
      child: AbsTextField(
        key: ValueKey(key),
        label: text,
        controller: ctl,
        numeric: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (_) => setState(() => _dirty = true),
      ),
    );
    final unused = [
      for (final s in kMealSlots)
        if (t.meal(s) == null) s,
    ];
    final supplements = {...kCommonSupplements, ...t.supplements}.toList();

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
        appBar: AppBar(
          title: Text(
            widget.memberId != null && flags != null
                ? l.dietEditFor(flags.name)
                : widget.templateId == null
                ? l.dietNewTitle
                : l.dietEditTitle,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Material(
            color: c.surface,
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x3, context.screenPadding, AbsSpace.x2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MacroRings(key: const ValueKey('builder-totals'), value: total, target: target, compact: true),
                  const SizedBox(height: AbsSpace.x2),
                  AbsButton(
                    key: const ValueKey('diet-builder-save'),
                    label: l.commonSave,
                    hue: PopHue.lime,
                    isLoading: _busy,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x8),
          children: [
            if (flags != null && flags.hasConditions) MedicalFlag(name: flags.name, conditions: flags.conditions),
            if (flags != null && flags.hasPreferences)
              Padding(
                padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                child: PreferenceStickers(flags: flags),
              ),
            if (conflicts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                child: AbsCard(
                  key: const ValueKey('builder-conflicts'),
                  hue: PopHue.tangerine,
                  padding: const EdgeInsets.all(AbsSpace.x3),
                  child: Row(
                    children: [
                      Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill), color: c.danger, size: AbsSize.iconSmall),
                      const SizedBox(width: AbsSpace.x2),
                      Expanded(
                        child: Text(
                          flags == null
                              ? l.dietConflictsPlan(conflicts.length, dietPrefLabel(l, t.dietPref))
                              : l.dietConflictsMember(conflicts.length, flags.name),
                          style: tt.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            AbsTextField(
              key: const ValueKey('diet-builder-name'),
              label: l.dietPlanName,
              controller: _name,
              onChanged: (_) => _dirty = true,
            ),
            const SizedBox(height: AbsSpace.x3),
            AbsTextField(label: l.buildDescription, controller: _description, onChanged: (_) => _dirty = true),
            label(l.dietTargets),
            AbsCard(
              key: const ValueKey('diet-targets'),
              padding: const EdgeInsets.all(AbsSpace.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      numField('target-kcal', l.dietCalories, _kcal),
                      const SizedBox(width: AbsSpace.x2),
                      numField('target-protein', l.dietProteinG, _protein),
                    ],
                  ),
                  const SizedBox(height: AbsSpace.x2),
                  Row(
                    children: [
                      numField('target-carbs', l.dietCarbsG, _carbs),
                      const SizedBox(width: AbsSpace.x2),
                      numField('target-fat', l.dietFatG, _fat),
                    ],
                  ),
                  const SizedBox(height: AbsSpace.x2),
                  Wrap(
                    spacing: AbsSpace.x2,
                    runSpacing: AbsSpace.x2,
                    children: [
                      AbsButton.secondary(
                        key: const ValueKey('open-calculator'),
                        label: l.targetsCalculate,
                        icon: PhosphorIcons.calculator(PhosphorIconsStyle.bold),
                        expand: false,
                        onPressed: () => _calculate(flags),
                      ),
                      if (offTarget)
                        AbsButton.ghost(
                          key: const ValueKey('scale-to-target'),
                          label: l.dietScaleToTarget(formatKcal(target.kcal)),
                          icon: PhosphorIcons.arrowsOutSimple(PhosphorIconsStyle.bold),
                          expand: false,
                          onPressed: () => _scaleToTarget(lookup),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            label(l.dietPreference),
            PopSingleChips<String>(
              options: kDietPrefs,
              labelOf: (p) => dietPrefLabel(l, p),
              value: t.dietPref,
              hue: PopHue.mint,
              onChanged: (v) => _change((x) => x.copyWith(dietPref: v)),
            ),
            label(l.targetsGoal),
            PopSingleChips<String>(
              options: kDietGoals,
              labelOf: (g) => dietGoalLabel(l, g),
              value: t.goal,
              hue: PopHue.coral,
              onChanged: (v) => _change((x) => x.copyWith(goal: v)),
            ),
            label(l.dietSupplements),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                for (final s in supplements)
                  PopChip(
                    label: s,
                    hue: PopHue.tangerine,
                    selected: t.supplements.contains(s),
                    onTap: () => _change(
                      (x) => x.copyWith(
                        supplements: x.supplements.contains(s)
                            ? [...x.supplements.where((y) => y != s)]
                            : [...x.supplements, s],
                      ),
                    ),
                  ),
                PopChip(
                  label: l.dietAddSupplement,
                  icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                  hue: PopHue.tangerine,
                  selected: false,
                  onTap: () async {
                    final name = (await promptText(context, label: l.dietSupplementName))?.trim();
                    if (name == null || name.isEmpty || name.length > 40 || t.supplements.contains(name)) return;
                    if (t.supplements.length >= 8) return;
                    _change((x) => x.copyWith(supplements: [...x.supplements, name]));
                  },
                ),
              ],
            ),
            label(l.dietMeals),
            for (final m in t.orderedMeals)
              _MealEditor(
                key: ValueKey('meal-editor-${m.slot}'),
                meal: m,
                lookup: lookup,
                conflicts: conflicts,
                onChange: (f) => _changeMeal(m.slot, (x) => f(x).copyWith(items: _renumber(f(x).items))),
                onRemove: () => _change((x) => x.copyWith(meals: [...x.meals.where((y) => y.slot != m.slot)])),
                onAdd: (group) => _addFoods(m.slot, group, dietPref: pref, flags: flags),
                onSuggest: index == null || m.main.isEmpty || m.options.length >= 2
                    ? null
                    : () => _suggestOption(m, index, pref),
              ),
            if (unused.isNotEmpty) ...[
              Text(l.dietAddMeal, style: tt.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x2),
              Wrap(
                spacing: AbsSpace.x2,
                runSpacing: AbsSpace.x2,
                children: [
                  for (final s in unused)
                    PopChip(
                      key: ValueKey('add-meal-$s'),
                      label: mealSlotLabel(l, s),
                      icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                      hue: PopHue.mint,
                      selected: false,
                      onTap: () => _change(
                        (x) => x.copyWith(
                          meals: [
                            ...x.meals,
                            DietMeal(slot: s, time: kDefaultMealTimes[s]),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: AbsSpace.x3),
            const DietDisclaimer(),
          ],
        ),
      ),
    );
  }
}

class _MealEditor extends StatelessWidget {
  const _MealEditor({
    super.key,
    required this.meal,
    required this.lookup,
    required this.conflicts,
    required this.onChange,
    required this.onRemove,
    required this.onAdd,
    required this.onSuggest,
  });

  final DietMeal meal;
  final FoodLookup lookup;
  final Map<String, List<FoodConflict>> conflicts;
  final void Function(DietMeal Function(DietMeal)) onChange;
  final VoidCallback onRemove;
  final ValueChanged<int> onAdd;
  final VoidCallback? onSuggest;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final m = meal;

    void setQty(DietItem i, double q) =>
        onChange((x) => x.copyWith(items: [for (final y in x.items) identical(y, i) ? y.copyWith(qty: q) : y]));
    void remove(DietItem i) => onChange((x) => x.copyWith(items: [...x.items.where((y) => !identical(y, i))]));

    Widget item(DietItem i, int n) {
      final f = foodOf(i, lookup);
      final step = f?.qtyStep ?? 0.5;
      final key = '${m.slot}-${i.altGroup}-$n';
      return Padding(
        key: ValueKey('item-$key'),
        padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
        child: Row(
          children: [
            if (f != null) ...[VegMark(vegType: f.vegType, size: 12), const SizedBox(width: AbsSpace.x2)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f?.name ?? '—', style: t.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(kcalText(itemMacros(i, lookup).kcal), style: t.caption.copyWith(color: c.textSecondary)),
                ],
              ),
            ),
            if (conflicts[i.foodId] != null)
              Tooltip(
                message: conflicts[i.foodId]!.map((x) => conflictLabel(l, x)).join(', '),
                child: Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill), size: AbsSize.iconSmall, color: c.danger),
              ),
            IconButton(
              key: ValueKey('minus-$key'),
              visualDensity: VisualDensity.compact,
              tooltip: l.dietLess,
              icon: Icon(PhosphorIcons.minusCircle(PhosphorIconsStyle.bold)),
              onPressed: i.qty <= step ? null : () => setQty(i, roundToStep(i.qty - step, step)),
            ),
            InkWell(
              key: ValueKey('qty-$key'),
              onTap: () async {
                final weighed = f?.isWeighed ?? false;
                final raw = await promptText(
                  context,
                  label: weighed ? l.dietAmountGrams : l.dietAmountServings,
                  initial: weighed ? '${((f?.servingG ?? 100) * i.qty).round()}' : fmtQty(i.qty).replaceAll('½', '.5'),
                  numeric: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                );
                final v = double.tryParse(raw?.trim().replaceAll(',', '.') ?? '');
                if (v == null || v <= 0) return;
                final q = weighed ? v / (f?.servingG ?? 100) : v;
                if (q > 50) return;
                setQty(i, double.parse(q.toStringAsFixed(2)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x1),
                child: Text(qtyText(l, f, i.qty), style: t.numericOf(t.label)),
              ),
            ),
            IconButton(
              key: ValueKey('plus-$key'),
              visualDensity: VisualDensity.compact,
              tooltip: l.dietMore,
              icon: Icon(PhosphorIcons.plusCircle(PhosphorIconsStyle.bold)),
              onPressed: () => setQty(i, roundToStep(i.qty + step, step)),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: l.foodRemove,
              icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
              onPressed: () => remove(i),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        padding: const EdgeInsets.all(AbsSpace.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(mealSlotIcon(m.slot), size: AbsSize.iconSmall),
                const SizedBox(width: AbsSpace.x2),
                Expanded(child: Text(mealSlotLabel(l, m.slot), style: t.heading)),
                ActionChip(
                  key: ValueKey('meal-time-${m.slot}'),
                  avatar: Icon(PhosphorIcons.clock(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
                  label: Text(m.hhmm ?? l.dietSetTime),
                  onPressed: () async {
                    final mins = m.minutes ?? 12 * 60;
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: mins ~/ 60, minute: mins % 60),
                    );
                    if (picked == null) return;
                    String two(int v) => v.toString().padLeft(2, '0');
                    onChange((x) => x.copyWith(time: '${two(picked.hour)}:${two(picked.minute)}'));
                  },
                ),
                IconButton(
                  key: ValueKey('remove-meal-${m.slot}'),
                  tooltip: l.dietRemoveMeal,
                  icon: Icon(PhosphorIcons.trash(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
                  onPressed: onRemove,
                ),
              ],
            ),
            Text(kcalText(mealTotals(m, lookup).kcal), style: t.caption.copyWith(color: c.textSecondary)),
            for (final (n, i) in m.main.indexed) item(i, n),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: ValueKey('add-food-${m.slot}'),
                icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
                label: Text(l.dietAddFood),
                onPressed: () => onAdd(0),
              ),
            ),
            for (final g in m.options) ...[
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l.dietOr(g)} · ${kcalText(mealTotals(m, lookup, group: g).kcal)}',
                      style: t.label.copyWith(color: c.pop(PopHue.sky).text),
                    ),
                  ),
                  IconButton(
                    tooltip: l.dietRemoveOption,
                    icon: Icon(PhosphorIcons.trash(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
                    onPressed: () => onChange(
                      (x) => x.copyWith(
                        items: [
                          for (final y in x.items)
                            if (y.altGroup != g) y.altGroup > g ? y.copyWith(altGroup: y.altGroup - 1) : y,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              for (final (n, i) in m.group(g).indexed) item(i, n),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: ValueKey('add-food-${m.slot}-$g'),
                  icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
                  label: Text(l.dietAddFood),
                  onPressed: () => onAdd(g),
                ),
              ),
            ],
            if (m.options.length < 2 && m.main.isNotEmpty)
              Wrap(
                spacing: AbsSpace.x2,
                children: [
                  TextButton.icon(
                    key: ValueKey('suggest-option-${m.slot}'),
                    icon: Icon(PhosphorIcons.sparkle(PhosphorIconsStyle.bold)),
                    label: Text(l.dietSuggestOption),
                    onPressed: onSuggest,
                  ),
                  TextButton.icon(
                    key: ValueKey('add-option-${m.slot}'),
                    icon: Icon(PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.bold)),
                    label: Text(l.dietAddOption),
                    onPressed: () => onAdd(m.options.contains(1) ? 2 : 1),
                  ),
                ],
              ),
            TextFormField(
              key: ValueKey('meal-notes-${m.slot}'),
              initialValue: m.notes,
              maxLength: 300,
              decoration: InputDecoration(labelText: l.dietMealNotes, counterText: ''),
              onChanged: (v) => onChange((x) => x.copyWith(notes: v.trim().isEmpty ? null : v.trim())),
            ),
          ],
        ),
      ),
    );
  }
}

/// Multi-select food picker over the cached database. Foods that clash with
/// the member's preferences are marked.
Future<List<Food>?> showFoodPicker(BuildContext context, {String? dietPref, DietFlags? flags}) =>
    showAbsBottomSheet<List<Food>>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _FoodPicker(dietPref: dietPref, flags: flags),
    );

class _FoodPicker extends StatefulWidget {
  const _FoodPicker({this.dietPref, this.flags});

  final String? dietPref;
  final DietFlags? flags;

  @override
  State<_FoodPicker> createState() => _FoodPickerState();
}

class _FoodPickerState extends State<_FoodPicker> {
  final _picked = <String, Food>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        Expanded(
          child: FoodsView(
            picking: _picked.keys.toSet(),
            dietPref: widget.dietPref,
            conflictsOf: (f) => conflictsFor(
              f,
              dietPref: widget.dietPref,
              allergies: widget.flags?.allergies ?? const [],
              avoid: widget.flags?.avoid ?? const [],
            ),
            onToggle: (f) => setState(() => _picked.containsKey(f.id) ? _picked.remove(f.id) : _picked[f.id] = f),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('food-picker-done'),
            label: l.dietAddFoods(_picked.length),
            hue: PopHue.lime,
            onPressed: _picked.isEmpty ? null : () => Navigator.pop(context, _picked.values.toList()),
          ),
        ),
      ],
    );
  }
}
