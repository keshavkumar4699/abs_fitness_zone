import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../application/diet_providers.dart';
import '../domain/diet_models.dart';
import '../domain/food.dart';
import '../domain/nutrition.dart';

// ---------------------------------------------------------------------------
// Labels
// ---------------------------------------------------------------------------
String mealSlotLabel(AppLocalizations l, String slot) => switch (slot) {
  'early_morning' => l.mealEarlyMorning,
  'breakfast' => l.mealBreakfast,
  'mid_morning' => l.mealMidMorning,
  'lunch' => l.mealLunch,
  'evening_snack' => l.mealEveningSnack,
  'pre_workout' => l.mealPreWorkout,
  'post_workout' => l.mealPostWorkout,
  'dinner' => l.mealDinner,
  _ => l.mealBedtime,
};

String foodCategoryLabel(AppLocalizations l, String c) => switch (c) {
  'grains' => l.foodCatGrains,
  'pulses' => l.foodCatPulses,
  'vegetables' => l.foodCatVegetables,
  'fruits' => l.foodCatFruits,
  'dairy' => l.foodCatDairy,
  'eggs' => l.foodCatEggs,
  'meat_fish' => l.foodCatMeatFish,
  'nuts_seeds' => l.foodCatNuts,
  'snacks' => l.foodCatSnacks,
  'sweets' => l.foodCatSweets,
  'drinks' => l.foodCatDrinks,
  'fats_oils' => l.foodCatFats,
  'condiments' => l.foodCatCondiments,
  _ => l.foodCatSupplements,
};

String vegTypeLabel(AppLocalizations l, String v) => switch (v) {
  'vegan' => l.vegVegan,
  'veg' => l.vegVeg,
  'egg' => l.vegEgg,
  _ => l.vegNonVeg,
};

String dietPrefLabel(AppLocalizations l, String? p) => switch (p) {
  'veg' => l.prefVeg,
  'eggetarian' => l.prefEggetarian,
  'non_veg' => l.prefNonVeg,
  'vegan' => l.prefVegan,
  'jain' => l.prefJain,
  _ => l.prefAny,
};

String dietGoalLabel(AppLocalizations l, String? g) => switch (g) {
  'fat_loss' => l.dietGoalFatLoss,
  'muscle_gain' => l.dietGoalMuscleGain,
  _ => l.dietGoalMaintenance,
};

String macroPresetLabel(AppLocalizations l, String? p) => switch (p) {
  'high_protein' => l.presetHighProtein,
  'keto_light' => l.presetKetoLight,
  _ => l.presetBalanced,
};

String allergenLabel(AppLocalizations l, String a) => switch (a) {
  'dairy' => l.allergyDairy,
  'gluten' => l.allergyGluten,
  'nuts' => l.allergyNuts,
  'peanut' => l.allergyPeanut,
  'soy' => l.allergySoy,
  'egg' => l.allergyEgg,
  'fish' => l.allergyFish,
  'shellfish' => l.allergyShellfish,
  _ => l.allergySesame,
};

String mealStatusLabel(AppLocalizations l, String s) => switch (s) {
  'eaten' => l.markEaten,
  'partly' => l.markPartly,
  'skipped' => l.markSkipped,
  _ => l.markSwapped,
};

String activityLabel(AppLocalizations l, ActivityLevel a) => switch (a) {
  ActivityLevel.sedentary => l.activitySedentary,
  ActivityLevel.light => l.activityLight,
  ActivityLevel.moderate => l.activityModerate,
  ActivityLevel.active => l.activityActive,
  ActivityLevel.athlete => l.activityAthlete,
};

String dietStatusLabel(AppLocalizations l, DietStatus s) => switch (s) {
  DietStatus.active => l.dietStatusActive,
  DietStatus.queued => l.dietStatusQueued,
  DietStatus.replaced => l.dietStatusReplaced,
  _ => l.dietStatusEnded,
};

String conflictLabel(AppLocalizations l, FoodConflict c) => switch (c.kind) {
  ConflictKind.preference => l.conflictPref(dietPrefLabel(l, c.detail)),
  ConflictKind.allergy => l.conflictAllergy(allergenLabel(l, c.detail)),
  ConflictKind.avoid => l.conflictAvoid(c.detail),
};

PopHue mealStatusHue(String s) => switch (s) {
  'eaten' => PopHue.lime,
  'partly' => PopHue.tangerine,
  'swapped' => PopHue.sky,
  _ => PopHue.coral,
};

IconData mealStatusIcon(String s) => switch (s) {
  'eaten' => PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
  'partly' => PhosphorIcons.circleHalf(PhosphorIconsStyle.fill),
  'swapped' => PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.bold),
  _ => PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
};

IconData mealSlotIcon(String slot) => switch (slot) {
  'early_morning' => PhosphorIcons.sunHorizon(PhosphorIconsStyle.bold),
  'breakfast' => PhosphorIcons.coffee(PhosphorIconsStyle.bold),
  'mid_morning' => PhosphorIcons.orangeSlice(PhosphorIconsStyle.bold),
  'lunch' => PhosphorIcons.bowlFood(PhosphorIconsStyle.bold),
  'evening_snack' => PhosphorIcons.cookie(PhosphorIconsStyle.bold),
  'pre_workout' => PhosphorIcons.lightning(PhosphorIconsStyle.bold),
  'post_workout' => PhosphorIcons.barbell(PhosphorIconsStyle.bold),
  'dinner' => PhosphorIcons.forkKnife(PhosphorIconsStyle.bold),
  _ => PhosphorIcons.moonStars(PhosphorIconsStyle.bold),
};

PopHue dietGoalHue(String? g) => switch (g) {
  'fat_loss' => PopHue.coral,
  'muscle_gain' => PopHue.grape,
  _ => PopHue.mint,
};

// ---------------------------------------------------------------------------
// Quantities
// ---------------------------------------------------------------------------
/// "2", "1½", "¼", "2.3".
String fmtQty(double q) {
  final whole = q.truncate();
  final frac = double.parse((q - whole).toStringAsFixed(2));
  final glyph = switch (frac) {
    0 => '',
    0.25 => '¼',
    0.5 => '½',
    0.75 => '¾',
    _ => null,
  };
  if (glyph == null) return q.toStringAsFixed(1);
  if (whole == 0 && glyph.isNotEmpty) return glyph;
  return '$whole$glyph';
}

String unitLabel(AppLocalizations l, String unit, double qty) {
  final n = qty <= 1 ? 1 : 2;
  return switch (unit) {
    'katori' => l.unitKatori(n),
    'roti' => l.unitRoti(n),
    'piece' => l.unitPiece(n),
    'glass' => l.unitGlass(n),
    'cup' => l.unitCup(n),
    'bowl' => l.unitBowl(n),
    'plate' => l.unitPlate(n),
    'slice' => l.unitSlice(n),
    'tbsp' => l.unitTbsp,
    'tsp' => l.unitTsp,
    'scoop' => l.unitScoop(n),
    'handful' => l.unitHandful(n),
    'ml' => 'ml',
    _ => 'g',
  };
}

/// "2 rotis", "1½ katori", "125 g".
String qtyText(AppLocalizations l, Food? f, double qty) {
  if (f == null) return fmtQty(qty);
  if (f.isWeighed) {
    final grams = f.servingG * qty;
    return '${grams % 1 == 0 ? grams.toInt() : grams.toStringAsFixed(1)} ${f.servingUnit == 'ml' ? 'ml' : 'g'}';
  }
  return '${fmtQty(qty)} ${unitLabel(l, f.servingUnit, qty)}';
}

/// One serving, e.g. "1 katori (150 g)".
String servingText(AppLocalizations l, Food f) => f.isWeighed
    ? qtyText(l, f, 1)
    : '${qtyText(l, f, 1)} (${f.servingG.round()} ${f.servingUnit == 'glass' ? 'ml' : 'g'})';

String kcalText(num kcal) => '${formatKcal(kcal.round())} kcal';

String grams(num g) => '${g.round()} g';

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------
/// A small veg / egg / non-veg mark: a dot in a rounded square.
class VegMark extends StatelessWidget {
  const VegMark({super.key, required this.vegType, this.size = 14});

  final String vegType;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(switch (vegType) {
      'non_veg' => PopHue.coral,
      'egg' => PopHue.tangerine,
      _ => PopHue.mint,
    });
    return Semantics(
      label: vegTypeLabel(context.l10n, vegType),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 4),
          border: Border.all(color: p.text, width: AbsSize.hairline * 1.5),
        ),
        child: Container(
          width: size / 2,
          height: size / 2,
          decoration: BoxDecoration(color: p.text, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/// Calories and the three macros against their targets (6.3, 6.8).
class MacroRings extends StatelessWidget {
  const MacroRings({super.key, required this.value, this.target, this.compact = false});

  final Macros value;
  final MacroTargets? target;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    double p(double v, int? goal) => goal == null || goal == 0 ? 0 : v / goal;
    final big = compact ? 72.0 : 104.0;
    final small = compact ? 44.0 : 58.0;
    Widget macro(String label, double v, int? goal, PopHue hue, Key key) => Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        ProgressRing(
          progress: p(v, goal),
          size: small,
          strokeWidth: compact ? 6 : 7,
          hue: hue,
          semanticsLabel: label,
          child: Text('${v.round()}', style: t.numericOf(t.caption).copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: AbsSpace.x1),
        Text(
          label,
          style: t.caption.copyWith(color: c.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (goal != null && goal > 0)
          Text('/ $goal g', style: t.numericOf(t.caption).copyWith(color: c.textSecondary), maxLines: 1),
      ],
    );
    return Row(
      children: [
        ProgressRing(
          key: const ValueKey('ring-kcal'),
          progress: p(value.kcal, target?.kcal),
          size: big,
          strokeWidth: compact ? 8 : AbsSize.ringStroke,
          hue: PopHue.lime,
          semanticsLabel: l.dietCalories,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatKcal(value.kcal.round()),
                key: const ValueKey('total-kcal'),
                style: t.numericOf(compact ? t.heading : t.title),
              ),
              Text(
                target == null ? 'kcal' : '/ ${formatKcal(target!.kcal)}',
                style: t.caption.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: AbsSpace.x3),
        Expanded(
          child: macro(l.dietProtein, value.protein, target?.protein, PopHue.bubblegum, const ValueKey('ring-p')),
        ),
        Expanded(child: macro(l.dietCarbs, value.carbs, target?.carbs, PopHue.sky, const ValueKey('ring-c'))),
        Expanded(child: macro(l.dietFat, value.fat, target?.fat, PopHue.tangerine, const ValueKey('ring-f'))),
      ],
    );
  }
}

MacroTargets? targetsOf(DietTemplate? t) => t == null
    ? null
    : MacroTargets(kcal: t.kcalTarget, protein: t.proteinG ?? 0, carbs: t.carbsG ?? 0, fat: t.fatG ?? 0);

/// "P 18 · C 22 · F 6".
String macroLine(AppLocalizations l, Macros m) =>
    '${l.dietP} ${m.protein.round()} · ${l.dietC} ${m.carbs.round()} · ${l.dietF} ${m.fat.round()}';

/// A food in the library or a picker.
class FoodTile extends StatelessWidget {
  const FoodTile({super.key, required this.food, required this.onTap, this.selected, this.conflicts = const []});

  final Food food;
  final VoidCallback onTap;
  final bool? selected;
  final List<FoodConflict> conflicts;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final f = food;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x2),
      child: AbsCard(
        key: ValueKey('food-${f.id}'),
        padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
        hue: selected == true ? PopHue.mint : null,
        onTap: onTap,
        child: Row(
          children: [
            VegMark(vegType: f.vegType),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f.localName == null ? f.name : '${f.name} · ${f.localName}',
                    style: t.heading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${servingText(l, f)} · ${kcalText(f.kcal)} · ${macroLine(l, f.macros)}',
                    style: t.caption.copyWith(color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!f.isReviewed || f.isCustom || conflicts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AbsSpace.x1),
                      child: Wrap(
                        spacing: AbsSpace.x1,
                        runSpacing: AbsSpace.x1,
                        children: [
                          for (final x in conflicts) PopSticker(label: conflictLabel(l, x), hue: PopHue.coral),
                          if (!f.isReviewed) PopSticker(label: l.foodNotReviewed, hue: PopHue.tangerine),
                          if (f.isCustom) PopSticker(label: l.foodCustom, hue: PopHue.grape),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (selected != null)
              Icon(
                selected!
                    ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                    : PhosphorIcons.plusCircle(PhosphorIconsStyle.bold),
                color: selected! ? c.pop(PopHue.mint).text : c.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Shown on every diet plan (F6 acceptance).
class DietDisclaimer extends StatelessWidget {
  const DietDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AbsSpace.x3),
      child: Row(
        key: const ValueKey('diet-disclaimer'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(PhosphorIcons.firstAidKit(PhosphorIconsStyle.bold), size: AbsSize.iconSmall, color: c.textSecondary),
          const SizedBox(width: AbsSpace.x2),
          Expanded(
            child: Text(context.l10n.dietDisclaimer, style: context.text.caption.copyWith(color: c.textSecondary)),
          ),
        ],
      ),
    );
  }
}

/// The member has medical conditions on their health form (F1 1.2).
class MedicalFlag extends StatelessWidget {
  const MedicalFlag({super.key, required this.name, this.conditions});

  final String name;
  final String? conditions;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        key: const ValueKey('medical-flag'),
        hue: PopHue.coral,
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconBubble(icon: PhosphorIcons.heartbeat(PhosphorIconsStyle.bold), hue: PopHue.coral, size: 36),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.medicalFlagTitle(name), style: context.text.heading),
                  if (conditions != null) Text(conditions!, style: context.text.body),
                  Text(l.medicalFlagBody, style: context.text.caption.copyWith(color: context.colors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Food preference, allergies and foods to avoid as stickers.
class PreferenceStickers extends StatelessWidget {
  const PreferenceStickers({super.key, required this.flags});

  final DietFlags flags;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Wrap(
      spacing: AbsSpace.x1,
      runSpacing: AbsSpace.x1,
      children: [
        PopSticker(label: dietPrefLabel(l, flags.dietPref), hue: PopHue.mint),
        for (final a in flags.allergies) PopSticker(label: l.allergicTo(allergenLabel(l, a)), hue: PopHue.coral),
        for (final a in flags.avoid) PopSticker(label: l.avoids(a), hue: PopHue.tangerine),
      ],
    );
  }
}

/// A diet plan in the library list.
class DietTemplateCard extends ConsumerWidget {
  const DietTemplateCard({super.key, required this.template, required this.onTap});

  final DietTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final x = template;
    final hue = dietGoalHue(x.goal);
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        key: ValueKey('diet-template-${x.id}'),
        hue: hue,
        onTap: onTap,
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Row(
          children: [
            IconBubble(icon: PhosphorIcons.bowlFood(PhosphorIconsStyle.bold), hue: hue),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(x.name, style: t.heading),
                  Text(
                    [
                      kcalText(x.kcalTarget),
                      l.dietMealsCount(x.meals.length),
                      l.dietFoodsCount(x.foodCount),
                    ].join(' · '),
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AbsSpace.x1),
                  Wrap(
                    spacing: AbsSpace.x1,
                    runSpacing: AbsSpace.x1,
                    children: [
                      if (x.isStarter) PopSticker(label: l.progStarter, hue: PopHue.lime),
                      if (x.dietPref != null) PopSticker(label: dietPrefLabel(l, x.dietPref), hue: PopHue.mint),
                      if (x.goal != null) PopSticker(label: dietGoalLabel(l, x.goal), hue: PopHue.sky),
                    ],
                  ),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
          ],
        ),
      ),
    );
  }
}

/// A meal of a plan: time, foods with amounts, "or" options and notes.
class MealPlanCard extends ConsumerWidget {
  const MealPlanCard({super.key, required this.meal, this.status, this.onTap, this.conflicts = const {}});

  final DietMeal meal;
  final MealLog? status;
  final VoidCallback? onTap;
  final Map<String, List<FoodConflict>> conflicts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    final total = mealTotals(meal, lookup);
    Widget row(DietItem i) {
      final f = foodOf(i, lookup);
      final warn = conflicts[i.foodId];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            if (f != null) ...[VegMark(vegType: f.vegType, size: 12), const SizedBox(width: AbsSpace.x2)],
            Expanded(
              child: Text(f?.name ?? '—', style: t.body, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            if (warn != null)
              Padding(
                padding: const EdgeInsets.only(right: AbsSpace.x1),
                child: Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill), size: AbsSize.iconSmall, color: c.danger),
              ),
            Text(qtyText(l, f, i.qty), style: t.numericOf(t.caption).copyWith(color: c.textSecondary)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        key: ValueKey('meal-${meal.slot}'),
        onTap: onTap,
        hue: status == null ? null : mealStatusHue(status!.status),
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(mealSlotIcon(meal.slot), size: AbsSize.iconSmall),
                const SizedBox(width: AbsSpace.x2),
                Expanded(child: Text([mealSlotLabel(l, meal.slot), ?meal.hhmm].join(' · '), style: t.heading)),
                if (status != null)
                  PopSticker(label: mealStatusLabel(l, status!.status), hue: mealStatusHue(status!.status))
                else
                  Text(kcalText(total.kcal), style: t.numericOf(t.label)),
              ],
            ),
            const SizedBox(height: AbsSpace.x2),
            for (final i in meal.main) row(i),
            for (final g in meal.options) ...[
              Padding(
                padding: const EdgeInsets.only(top: AbsSpace.x2, bottom: 2),
                child: Text(
                  '${l.dietOr(g)} · ${kcalText(mealTotals(meal, lookup, group: g).kcal)}',
                  style: t.label.copyWith(color: c.pop(PopHue.sky).text),
                ),
              ),
              for (final i in meal.group(g)) row(i),
            ],
            if (meal.notes != null)
              Padding(
                padding: const EdgeInsets.only(top: AbsSpace.x2),
                child: Text(meal.notes!, style: t.caption.copyWith(color: c.textSecondary)),
              ),
          ],
        ),
      ),
    );
  }
}
