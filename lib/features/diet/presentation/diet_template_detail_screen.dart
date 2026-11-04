import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../application/diet_providers.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/nutrition.dart';
import 'assign_diet_sheet.dart';
import 'diet_share.dart';
import 'diet_ui.dart';

/// A plan in the library (6.3, 6.6): targets and planned totals, meals with
/// their options, supplements and the disclaimer. Coaches assign it,
/// duplicate it scaled to a new calorie target, edit or remove it.
class DietTemplateDetailScreen extends ConsumerWidget {
  const DietTemplateDetailScreen({super.key, required this.templateId});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(dietTemplateDetailProvider(templateId));
    return Scaffold(
      appBar: AppBar(
        title: Text(value.value?.name ?? l.dietPlan),
        actions: [if (value.value case final t?) DietShareMenu(template: t)],
      ),
      body: AsyncView<DietTemplate>(
        value: value,
        onRetry: () => ref.invalidate(dietTemplateDetailProvider(templateId)),
        loading: const SkeletonList(itemCount: 5),
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        data: (t) => _Body(template: t),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.template});

  final DietTemplate template;

  Future<void> _duplicate(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final raw = await promptText(
      context,
      title: l.dietDuplicateTitle,
      label: l.dietDuplicateKcal,
      initial: '${template.kcalTarget}',
      numeric: true,
      keyboardType: TextInputType.number,
    );
    final kcal = int.tryParse(raw?.trim() ?? '');
    if (raw == null || !context.mounted) return;
    if (kcal == null || kcal < 800 || kcal > 6000) {
      showAbsSnackbar(context, l.dietKcalRange, tone: SnackTone.error);
      return;
    }
    final lookup = lookupIn(await ref.read(foodCatalogueProvider.future));
    final copy = scaleTemplate(template, kcal, lookup);
    if (!context.mounted) return;
    await context.push(
      Routes.dietNew,
      extra: copy.copyWith(name: copy.name == template.name ? l.progCopyName(template.name) : copy.name),
    );
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.dietRemoveTitle(template.name)),
        content: Text(l.dietRemoveBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.foodRemove, style: TextStyle(color: context.colors.danger)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(dietRepositoryProvider).archiveTemplate(template.id!);
      ref.invalidate(dietTemplateListProvider);
      if (!context.mounted) return;
      showAbsSnackbar(context, l.dietRemoved, tone: SnackTone.success);
      context.pop();
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final user = ref.watch(currentUserProvider).value;
    final coach = user?.role == UserRole.owner || user?.role == UserRole.trainer;
    final canEdit = user?.role == UserRole.owner || (coach && template.createdBy == user?.userId);
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    final total = dayTotals(template, lookup);
    final x = template;
    return ListView(
      padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x10),
      children: [
        AbsCard(
          hue: dietGoalHue(x.goal),
          padding: const EdgeInsets.all(AbsSpace.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AbsSpace.x1,
                runSpacing: AbsSpace.x1,
                children: [
                  if (x.isStarter) PopSticker(label: l.progStarter, hue: PopHue.lime),
                  if (x.dietPref != null) PopSticker(label: dietPrefLabel(l, x.dietPref), hue: PopHue.mint),
                  if (x.goal != null) PopSticker(label: dietGoalLabel(l, x.goal), hue: PopHue.sky),
                  if (x.macroPreset != null) PopSticker(label: macroPresetLabel(l, x.macroPreset), hue: PopHue.grape),
                ],
              ),
              if (x.description != null) ...[const SizedBox(height: AbsSpace.x2), Text(x.description!, style: t.body)],
              const SizedBox(height: AbsSpace.x4),
              Text(l.dietPlannedVsTarget, style: t.label.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x2),
              MacroRings(value: total, target: targetsOf(x)),
              if (x.supplements.isNotEmpty) ...[
                const SizedBox(height: AbsSpace.x3),
                Text(l.dietSupplements, style: t.label.copyWith(color: c.textSecondary)),
                const SizedBox(height: AbsSpace.x1),
                Wrap(
                  spacing: AbsSpace.x1,
                  runSpacing: AbsSpace.x1,
                  children: [for (final s in x.supplements) PopSticker(label: s, hue: PopHue.tangerine)],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AbsSpace.x3),
        if (coach)
          Wrap(
            spacing: AbsSpace.x2,
            runSpacing: AbsSpace.x2,
            children: [
              AbsButton(
                key: const ValueKey('diet-assign'),
                label: l.dietAssign,
                icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
                hue: PopHue.lime,
                expand: false,
                onPressed: () => showAssignDietSheet(context, template: x),
              ),
              AbsButton.secondary(
                key: const ValueKey('diet-duplicate'),
                label: l.dietDuplicate,
                icon: PhosphorIcons.copy(PhosphorIconsStyle.bold),
                expand: false,
                onPressed: () => _duplicate(context, ref),
              ),
              if (canEdit)
                AbsButton.secondary(
                  key: const ValueKey('diet-edit'),
                  label: l.progEdit,
                  icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                  expand: false,
                  onPressed: () async {
                    await context.push(Routes.dietEdit(x.id!));
                    ref
                      ..invalidate(dietTemplateDetailProvider(x.id!))
                      ..invalidate(dietTemplateListProvider);
                  },
                ),
              if (canEdit)
                AbsButton.ghost(
                  label: l.foodRemove,
                  icon: PhosphorIcons.trash(PhosphorIconsStyle.bold),
                  expand: false,
                  onPressed: () => _remove(context, ref),
                ),
            ],
          ),
        const SizedBox(height: AbsSpace.x4),
        Text(l.dietMeals, style: t.title),
        const SizedBox(height: AbsSpace.x2),
        for (final m in x.orderedMeals) MealPlanCard(meal: m),
        const DietDisclaimer(),
      ],
    );
  }
}
