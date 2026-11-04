import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/diet_models.dart';
import '../domain/nutrition.dart';
import 'diet_ui.dart';

/// What the calculator hands back to the builder.
class TargetsResult {
  const TargetsResult({required this.targets, required this.preset, required this.goal});

  final MacroTargets targets;
  final String preset;
  final String goal;
}

/// What the calculator starts from: the member's profile (F1) when known.
class TargetsInput {
  const TargetsInput({this.gender, this.age, this.heightCm, this.weightKg, this.goal, this.preset});

  final String? gender;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final String? goal;
  final String? preset;
}

/// The targets calculator (6.2): Mifflin-St Jeor BMR, TDEE from activity,
/// calories by goal, and a macro preset with protein in g per kg.
Future<TargetsResult?> showTargetsSheet(BuildContext context, {TargetsInput input = const TargetsInput()}) =>
    showAbsBottomSheet<TargetsResult>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _TargetsSheet(controller: controller, input: input),
    );

class _TargetsSheet extends StatefulWidget {
  const _TargetsSheet({required this.controller, required this.input});

  final ScrollController controller;
  final TargetsInput input;

  @override
  State<_TargetsSheet> createState() => _TargetsSheetState();
}

class _TargetsSheetState extends State<_TargetsSheet> {
  late final _age = TextEditingController(text: widget.input.age?.toString() ?? '30');
  late final _height = TextEditingController(text: widget.input.heightCm?.round().toString() ?? '165');
  late final _weight = TextEditingController(text: widget.input.weightKg?.toString() ?? '65');
  late String? _gender = widget.input.gender;
  ActivityLevel _activity = ActivityLevel.moderate;
  late String _goal = widget.input.goal ?? 'fat_loss';
  late String _preset = widget.input.preset ?? 'high_protein';
  late double _perKg = defaultProteinPerKg(_preset);

  @override
  void dispose() {
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  double? _num(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.'));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final age = _num(_age), height = _num(_height), weight = _num(_weight);
    final ok =
        age != null &&
        age >= 14 &&
        age <= 90 &&
        height != null &&
        height >= 120 &&
        height <= 230 &&
        weight != null &&
        weight >= 30 &&
        weight <= 250;
    final b = ok ? bmr(gender: _gender, weightKg: weight, heightCm: height, age: age.round()) : null;
    final d = b == null ? null : tdee(b, _activity);
    final kcal = d == null ? null : calorieTarget(tdee: d, bmr: b!, goal: _goal);
    final split = kcal == null
        ? null
        : macroSplit(kcal: kcal, weightKg: weight!, preset: _preset, proteinPerKg: _perKg);

    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: t.label.copyWith(color: c.textSecondary)),
    );
    Widget field(String key, String text, TextEditingController ctl) => Expanded(
      child: AbsTextField(
        key: ValueKey(key),
        label: text,
        controller: ctl,
        numeric: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        onChanged: (_) => setState(() {}),
      ),
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.targetsTitle, style: t.title),
              Text(l.targetsBody, style: t.caption.copyWith(color: c.textSecondary)),
              label(l.targetsGender),
              PopSingleChips<String>(
                options: const ['male', 'female', 'other'],
                labelOf: (g) => switch (g) {
                  'male' => l.genderMale,
                  'female' => l.genderFemale,
                  _ => l.genderOther,
                },
                value: _gender,
                hue: PopHue.grape,
                onChanged: (v) => setState(() => _gender = v),
              ),
              const SizedBox(height: AbsSpace.x3),
              Row(
                children: [
                  field('targets-age', l.targetsAge, _age),
                  const SizedBox(width: AbsSpace.x2),
                  field('targets-height', l.targetsHeight, _height),
                  const SizedBox(width: AbsSpace.x2),
                  field('targets-weight', l.targetsWeight, _weight),
                ],
              ),
              label(l.targetsActivity),
              PopSingleChips<ActivityLevel>(
                options: ActivityLevel.values,
                labelOf: (a) => activityLabel(l, a),
                value: _activity,
                allowEmpty: false,
                hue: PopHue.sky,
                onChanged: (v) => setState(() => _activity = v ?? _activity),
              ),
              label(l.targetsGoal),
              PopSingleChips<String>(
                options: kDietGoals,
                labelOf: (g) => dietGoalLabel(l, g),
                value: _goal,
                allowEmpty: false,
                hue: PopHue.coral,
                onChanged: (v) => setState(() => _goal = v ?? _goal),
              ),
              label(l.targetsPreset),
              PopSingleChips<String>(
                options: kMacroPresets,
                labelOf: (p) => macroPresetLabel(l, p),
                value: _preset,
                allowEmpty: false,
                hue: PopHue.bubblegum,
                onChanged: (v) => setState(() {
                  _preset = v ?? _preset;
                  _perKg = defaultProteinPerKg(_preset);
                }),
              ),
              label(l.targetsProteinPerKg),
              Row(
                children: [
                  IconButton(
                    key: const ValueKey('protein-less'),
                    icon: Icon(PhosphorIcons.minusCircle(PhosphorIconsStyle.bold)),
                    onPressed: _perKg <= 0.8 ? null : () => setState(() => _perKg = ((_perKg - 0.1) * 10).round() / 10),
                  ),
                  Text('${_perKg.toStringAsFixed(1)} g/kg', style: t.numericOf(t.heading)),
                  IconButton(
                    key: const ValueKey('protein-more'),
                    icon: Icon(PhosphorIcons.plusCircle(PhosphorIconsStyle.bold)),
                    onPressed: _perKg >= 3 ? null : () => setState(() => _perKg = ((_perKg + 0.1) * 10).round() / 10),
                  ),
                ],
              ),
              const SizedBox(height: AbsSpace.x3),
              if (split == null)
                Text(l.targetsNeedProfile, style: t.body.copyWith(color: c.danger))
              else
                AbsCard(
                  key: const ValueKey('targets-result'),
                  hue: PopHue.lime,
                  padding: const EdgeInsets.all(AbsSpace.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.targetsBmrTdee(formatKcal(b!.round()), formatKcal(d!.round())),
                        style: t.caption.copyWith(color: c.textSecondary),
                      ),
                      const SizedBox(height: AbsSpace.x1),
                      Text(kcalText(split.kcal), style: t.numericOf(t.title)),
                      Text(
                        '${l.dietP} ${split.protein} g · ${l.dietC} ${split.carbs} g · ${l.dietF} ${split.fat} g',
                        style: t.numericOf(t.body),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('targets-use'),
            label: l.targetsUse,
            hue: PopHue.lime,
            icon: PhosphorIcons.target(PhosphorIconsStyle.bold),
            onPressed: split == null
                ? null
                : () => Navigator.pop(context, TargetsResult(targets: split, preset: _preset, goal: _goal)),
          ),
        ),
      ],
    );
  }
}
