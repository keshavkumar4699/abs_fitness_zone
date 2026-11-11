import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../members/application/members_providers.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../../shell/member_shell.dart' show MemberHues;
import '../application/diet_providers.dart';
import '../application/meal_reminders.dart';
import '../domain/diet_models.dart';
import '../domain/food.dart';
import '../domain/nutrition.dart';
import 'diet_share.dart';
import 'diet_tracking_ui.dart';
import 'diet_training_views.dart' show adherenceHue;
import 'diet_ui.dart';

/// The day's meal reminders for a plan (6.10).
List<MealReminder> remindersFor(AppLocalizations l, DietTemplate plan, FoodLookup lookup) => [
  for (final m in plan.orderedMeals)
    if (m.minutes case final mins?)
      MealReminder(
        index: kMealSlots.indexOf(m.slot),
        minutes: mins,
        title: l.reminderTitle(mealSlotLabel(l, m.slot)),
        body: m.main.map((i) => '${foodOf(i, lookup)?.name ?? ''} ${qtyText(l, foodOf(i, lookup), i.qty)}').join(', '),
      ),
];

/// Member app → Diet (6.8–6.10): pick today or the two days before, the
/// day's rings, the meal timeline (tap to mark), water, supplements, coach
/// notes, reminders, the grocery list and the PDF.
class MyDietScreen extends ConsumerStatefulWidget {
  const MyDietScreen({super.key});

  @override
  ConsumerState<MyDietScreen> createState() => _MyDietScreenState();
}

class _MyDietScreenState extends ConsumerState<MyDietScreen> {
  int _daysBack = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final memberId = ref.watch(currentUserProvider).value?.memberId;
    if (memberId == null) return const SizedBox.shrink();
    final today = IstDates.today(now: ref.watch(clockProvider)());
    final day = today.subtract(Duration(days: _daysBack));
    final diets = ref.watch(memberDietsProvider(memberId));
    final logsValue = ref.watch(memberDietLogsProvider(memberId));
    final logs = logsValue.value ?? const DietLogs();
    final stats = ref.watch(dietStatsProvider(memberId)).value;
    final comments = ref.watch(dietCommentsProvider(memberId)).value ?? const <DietComment>[];
    final flags = ref.watch(dietFlagsProvider(memberId)).value;
    final measurements = ref.watch(memberMeasurementsProvider(memberId)).value ?? const <Measurement>[];
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    final remindersOn = ref.watch(mealReminderSwitchProvider);
    final notifier = ref.read(memberDietLogsProvider(memberId).notifier);

    // Keep reminders in step with the plan.
    ref.listen(currentDietProvider(memberId), (_, next) {
      final plan = next.value?.template;
      if (plan != null) {
        ref
            .read(mealReminderSwitchProvider.notifier)
            .resync(
              remindersFor(l, plan, lookup),
              channelName: l.notifMealChannel,
              channelDescription: l.notifMealChannelBody,
            );
      }
    });

    final list = diets.value ?? const <MemberDiet>[];
    final onDay = dietOn(list, day);
    final current = list.where((d) => d.status == DietStatus.active).firstOrNull;
    final queued = list.where((d) => d.status == DietStatus.queued).firstOrNull;
    final plan = onDay?.template;
    final marks = logs.mealsOn(day);
    final eaten = marks.values.fold(Macros.zero, (a, m) => a + m.macros);
    final fresh = current?.assignedAt != null && ref.watch(clockProvider)().difference(current!.assignedAt!).inDays < 3;

    Widget body() {
      if (diets.isLoading && !diets.hasValue) return const SizedBox(height: 400, child: SkeletonList(itemCount: 4));
      if (diets.hasError && !diets.hasValue) {
        return ErrorState(
          message: friendlyError(l, diets.error!),
          onRetry: () => ref.invalidate(memberDietsProvider(memberId)),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (fresh && _daysBack == 0)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x3),
              child: AbsCard(
                key: const ValueKey('new-diet-banner'),
                hue: PopHue.lime,
                solid: true,
                padding: const EdgeInsets.all(AbsSpace.x4),
                child: Row(
                  children: [
                    Icon(PhosphorIcons.sparkle(PhosphorIconsStyle.fill), color: c.pop(PopHue.lime).onFill),
                    const SizedBox(width: AbsSpace.x2),
                    Expanded(
                      child: Text(
                        l.dietNewPlan(current.name),
                        style: t.heading.copyWith(color: c.pop(PopHue.lime).onFill),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (queued != null && current == null)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x3),
              child: InfoPill(label: l.dietStartsOn(queued.name, dateLabel(queued.startDate!)), hue: PopHue.sky),
            ),
          SizedBox(
            height: AbsSize.touchTarget,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final back in const [0, 1, 2]) ...[
                  PopChip(
                    key: ValueKey('diet-day-$back'),
                    label: switch (back) {
                      0 => l.dietDayToday,
                      1 => l.dietDayYesterday,
                      _ => dateLabel(today.subtract(const Duration(days: 2))),
                    },
                    hue: MemberHues.diet,
                    selected: _daysBack == back,
                    onTap: () => setState(() => _daysBack = back),
                  ),
                  const SizedBox(width: AbsSpace.x2),
                ],
              ],
            ),
          ),
          const SizedBox(height: AbsSpace.x3),
          if (plan == null)
            EmptyState(
              title: l.dietNoPlanTitle,
              message: _daysBack == 0 ? l.dietNoPlanBody : l.dietNoPlanThatDay,
              illustration: EmptyIllustration.rocket,
              hue: MemberHues.diet,
            )
          else ...[
            AbsCard(
              key: const ValueKey('day-rings'),
              hue: MemberHues.diet,
              padding: const EdgeInsets.all(AbsSpace.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(onDay!.name, style: t.heading)),
                      if (stats?.adherence7d case final a?)
                        PopSticker(label: l.dietWeekOnPlan((a * 100).round()), hue: adherenceHue(a)),
                    ],
                  ),
                  const SizedBox(height: AbsSpace.x3),
                  MacroRings(value: eaten, target: targetsOf(plan)),
                  const SizedBox(height: AbsSpace.x2),
                  Text(
                    l.dietMarkedOf(marks.length, plan.meals.length),
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AbsSpace.x4),
            Text(l.dietMeals, style: t.title),
            const SizedBox(height: AbsSpace.x2),
            MealTimeline(
              plan: plan,
              marks: marks,
              lookup: lookup,
              onTap: (m) => showMealSheet(
                context,
                meal: m,
                current: marks[m.slot],
                onMark: (status, alt) =>
                    notifier.markMeal(day: day, meal: m, status: status, alt: alt, lookup: lookup, dietId: onDay.id),
              ),
            ),
          ],
          const SizedBox(height: AbsSpace.x4),
          WaterTracker(
            glasses: logs.glassesOn(day),
            goal: stats?.waterGoal ?? 8,
            onChanged: (g) => notifier.setWater(day, g),
          ),
          if (plan != null && plan.supplements.isNotEmpty) ...[
            const SizedBox(height: AbsSpace.x4),
            SupplementChecklist(
              names: plan.supplements,
              taken: logs.supplementsOn(day),
              onChanged: (name, taken) => notifier.setSupplement(day, name, taken: taken),
            ),
          ],
          if (comments.isNotEmpty) ...[const SizedBox(height: AbsSpace.x4), DietCommentsCard(comments: comments)],
          if (stats != null && stats.weekly.isNotEmpty) ...[
            const SizedBox(height: AbsSpace.x4),
            AdherenceWeightChart(weeks: stats.weekly, measurements: measurements),
          ],
          const SizedBox(height: AbsSpace.x4),
          if (plan != null)
            AbsButton.secondary(
              key: const ValueKey('open-grocery'),
              label: l.groceryTitle,
              icon: PhosphorIcons.basket(PhosphorIconsStyle.bold),
              onPressed: () => showGrocerySheet(context, plan),
            ),
          const SizedBox(height: AbsSpace.x2),
          if (flags != null)
            AbsButton.ghost(
              key: const ValueKey('my-preferences'),
              label: l.prefsTitle,
              icon: PhosphorIcons.leaf(PhosphorIconsStyle.bold),
              onPressed: () => showPreferencesSheet(context, flags: flags),
            ),
          if (plan != null) const DietDisclaimer(),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AbsRefresh(
          onRefresh: () async {
            ref
              ..invalidate(syncDietProvider)
              ..refreshDiet(memberId);
            await ref.read(memberDietsProvider(memberId).future);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              context.screenPadding,
              AbsSpace.x4,
              context.screenPadding,
              MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.navDiet, style: t.displayL.copyWith(fontSize: t.title.fontSize! * 1.3)),
                  ),
                  if (current?.template case final p?) ...[
                    IconButton(
                      key: const ValueKey('meal-reminders'),
                      tooltip: remindersOn ? l.remindersOff : l.remindersOn,
                      icon: Icon(
                        remindersOn
                            ? PhosphorIcons.bellRinging(PhosphorIconsStyle.fill)
                            : PhosphorIcons.bellSlash(PhosphorIconsStyle.bold),
                      ),
                      onPressed: () async {
                        await ref
                            .read(mealReminderSwitchProvider.notifier)
                            .set(
                              !remindersOn,
                              remindersFor(l, p, lookup),
                              channelName: l.notifMealChannel,
                              channelDescription: l.notifMealChannelBody,
                            );
                        if (context.mounted) {
                          showAbsSnackbar(
                            context,
                            !remindersOn ? l.remindersOnDone : l.remindersOffDone,
                            tone: SnackTone.success,
                          );
                        }
                      },
                    ),
                    DietShareMenu(template: p),
                  ],
                ],
              ),
              const SizedBox(height: AbsSpace.x3),
              body(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Today's meals on the member home: what's next and the day's calories.
class TodayDietCard extends ConsumerWidget {
  const TodayDietCard({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final current = ref.watch(currentDietProvider(memberId)).value;
    final plan = current?.status == DietStatus.active ? current?.template : null;
    if (plan == null) return const SizedBox.shrink();
    final logs = ref.watch(memberDietLogsProvider(memberId)).value ?? const DietLogs();
    final now = ref.watch(clockProvider)();
    final today = IstDates.today(now: now);
    final marks = logs.mealsOn(today);
    final eaten = marks.values.fold(Macros.zero, (a, m) => a + m.macros);
    final next = plan.orderedMeals.where((m) => !marks.containsKey(m.slot)).firstOrNull;
    final p = c.pop(MemberHues.diet);
    return AbsCard(
      key: const ValueKey('today-diet'),
      hue: MemberHues.diet,
      onTap: () => context.go(Routes.meDiet),
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Row(
        children: [
          ProgressRing(
            progress: plan.kcalTarget == 0 ? 0 : eaten.kcal / plan.kcalTarget,
            size: 64,
            strokeWidth: 7,
            hue: MemberHues.diet,
            semanticsLabel: l.dietCalories,
            child: Text('${eaten.kcal.round()}', style: t.numericOf(t.label)),
          ),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.meTodayMeals, style: t.heading),
                Text(
                  next == null ? l.dietAllMarked : l.dietNextMeal(mealSlotLabel(l, next.slot), next.hhmm ?? ''),
                  style: t.body,
                ),
                Text(
                  l.dietMarkedOf(marks.length, plan.meals.length),
                  style: t.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), color: p.text),
        ],
      ),
    );
  }
}
