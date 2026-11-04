import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../application/diet_providers.dart';
import '../domain/food.dart';
import 'diet_ui.dart';

/// Trainers add the gym's own foods (6.1), or correct a seeded one, which
/// counts as reviewing it.
class FoodEditorScreen extends ConsumerStatefulWidget {
  const FoodEditorScreen({super.key, this.foodId});

  final String? foodId;

  @override
  ConsumerState<FoodEditorScreen> createState() => _FoodEditorScreenState();
}

class _FoodEditorScreenState extends ConsumerState<FoodEditorScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _local = TextEditingController();
  final _grams = TextEditingController(text: '100');
  final _kcal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  final _fibre = TextEditingController();
  String _category = 'snacks';
  String _unit = 'piece';
  String _veg = 'veg';
  bool _jain = false;
  Set<String> _allergens = {};
  Food? _original;
  bool _loaded = false;
  bool _busy = false;

  List<TextEditingController> get _all => [_name, _local, _grams, _kcal, _protein, _carbs, _fat, _fibre];

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  String _n(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

  void _load(Food f) {
    _loaded = true;
    _original = f;
    _name.text = f.name;
    _local.text = f.localName ?? '';
    _grams.text = _n(f.servingG);
    _kcal.text = _n(f.kcal);
    _protein.text = _n(f.protein);
    _carbs.text = _n(f.carbs);
    _fat.text = _n(f.fat);
    _fibre.text = _n(f.fibre);
    _category = f.category;
    _unit = f.servingUnit;
    _veg = f.vegType;
    _jain = f.jainOk;
    _allergens = f.allergens.toSet();
  }

  double _v(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  Future<void> _save() async {
    final l = context.l10n;
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final weighed = _unit == 'g' || _unit == 'ml';
    final base =
        _original ??
        Food(id: '', name: '', category: _category, servingUnit: _unit, servingG: 100, kcal: 0, vegType: _veg);
    final food = base.copyWith(
      name: _name.text.trim(),
      localName: _local.text.trim().isEmpty ? null : _local.text.trim(),
      category: _category,
      servingUnit: _unit,
      servingG: weighed ? 100 : _v(_grams),
      qtyStep: weighed ? 0.25 : (_original?.qtyStep ?? 0.5),
      kcal: _v(_kcal),
      protein: _v(_protein),
      carbs: _v(_carbs),
      fat: _v(_fat),
      fibre: _v(_fibre),
      vegType: _veg,
      jainOk: _jain && (_veg == 'veg' || _veg == 'vegan'),
      allergens: [
        for (final a in kAllergens)
          if (_allergens.contains(a)) a,
      ],
    );
    try {
      await ref.saveFood(food);
      if (!mounted) return;
      showAbsSnackbar(context, l.foodSaved, tone: SnackTone.success);
      context.pop();
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
    if (widget.foodId != null && !_loaded) {
      final f = ref.watch(foodCatalogueProvider).value?[widget.foodId!];
      if (f != null) _load(f);
    }
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: t.label.copyWith(color: c.textSecondary)),
    );
    String? number(String? s, {double max = 3000, bool required = false}) {
      final v = double.tryParse((s ?? '').trim());
      if (v == null) return required || (s ?? '').trim().isNotEmpty ? l.foodBadNumber : null;
      return v < 0 || v > max ? l.foodBadNumber : null;
    }

    Widget field(String key, String text, TextEditingController ctl, {double max = 300, bool required = false}) =>
        Expanded(
          child: AbsTextField(
            key: ValueKey(key),
            label: text,
            controller: ctl,
            numeric: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            validator: (s) => number(s, max: max, required: required),
            onChanged: (_) => setState(() {}),
          ),
        );

    final atwater = 4 * _v(_protein) + 4 * _v(_carbs) + 9 * _v(_fat);
    final kcal = _v(_kcal);
    final mismatch = kcal > 0 && (atwater - kcal).abs() > (kcal * 0.15).clamp(8, 1000);
    final weighed = _unit == 'g' || _unit == 'ml';
    const gap = SizedBox(height: AbsSpace.x3);

    return Scaffold(
      appBar: AppBar(title: Text(widget.foodId == null ? l.foodNewTitle : l.foodEditTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x2),
          child: AbsButton(
            key: const ValueKey('food-save'),
            label: _original != null && !_original!.isReviewed ? l.foodSaveReviewed : l.commonSave,
            hue: PopHue.lime,
            isLoading: _busy,
            onPressed: _save,
          ),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x10),
          children: [
            if (_original != null && !_original!.isReviewed)
              Padding(
                padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                child: AbsCard(
                  hue: PopHue.tangerine,
                  padding: const EdgeInsets.all(AbsSpace.x4),
                  child: Text(l.foodReviewHint, style: t.body),
                ),
              ),
            AbsTextField(
              key: const ValueKey('food-name'),
              label: l.foodFieldName,
              controller: _name,
              validator: (s) => (s == null || s.trim().length < 2) ? l.commonRequired : null,
            ),
            gap,
            AbsTextField(label: l.foodFieldLocalName, controller: _local),
            label(l.foodFieldCategory),
            PopSingleChips<String>(
              options: kFoodCategories,
              labelOf: (v) => foodCategoryLabel(l, v),
              value: _category,
              allowEmpty: false,
              hue: PopHue.sky,
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            label(l.foodFieldServing),
            PopSingleChips<String>(
              key: const ValueKey('food-unit'),
              options: kServingUnits,
              labelOf: (v) => unitLabel(l, v, 1),
              value: _unit,
              allowEmpty: false,
              hue: PopHue.grape,
              onChanged: (v) => setState(() => _unit = v ?? _unit),
            ),
            if (!weighed) ...[
              gap,
              Row(
                children: [
                  field('food-grams', l.foodFieldGrams(unitLabel(l, _unit, 1)), _grams, max: 2000, required: true),
                ],
              ),
            ],
            label(weighed ? l.foodValuesPer100(_unit) : l.foodValuesPerServing(unitLabel(l, _unit, 1))),
            Row(
              children: [
                field('food-kcal', l.dietCalories, _kcal, max: 3000, required: true),
                const SizedBox(width: AbsSpace.x2),
                field('food-protein', l.dietProteinG, _protein),
              ],
            ),
            gap,
            Row(
              children: [
                field('food-carbs', l.dietCarbsG, _carbs, max: 500),
                const SizedBox(width: AbsSpace.x2),
                field('food-fat', l.dietFatG, _fat),
                const SizedBox(width: AbsSpace.x2),
                field('food-fibre', l.dietFibreG, _fibre, max: 100),
              ],
            ),
            if (mismatch)
              Padding(
                padding: const EdgeInsets.only(top: AbsSpace.x2),
                child: Row(
                  key: const ValueKey('food-mismatch'),
                  children: [
                    Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill), size: AbsSize.iconSmall, color: c.danger),
                    const SizedBox(width: AbsSpace.x2),
                    Expanded(
                      child: Text(l.foodMismatch(atwater.round()), style: t.caption.copyWith(color: c.danger)),
                    ),
                  ],
                ),
              ),
            label(l.foodFieldVeg),
            PopSingleChips<String>(
              options: kVegTypes,
              labelOf: (v) => vegTypeLabel(l, v),
              value: _veg,
              allowEmpty: false,
              hue: PopHue.mint,
              onChanged: (v) => setState(() => _veg = v ?? _veg),
            ),
            if (_veg == 'veg' || _veg == 'vegan')
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.foodJainOk),
                subtitle: Text(l.foodJainHint),
                value: _jain,
                onChanged: (v) => setState(() => _jain = v),
              ),
            label(l.foodAllergens),
            PopChoiceChips<String>(
              options: kAllergens,
              labelOf: (a) => allergenLabel(l, a),
              selected: _allergens,
              hue: PopHue.coral,
              onChanged: (v) => setState(() => _allergens = v),
            ),
          ],
        ),
      ),
    );
  }
}
