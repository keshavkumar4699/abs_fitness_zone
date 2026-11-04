import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../members/application/members_providers.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../../members/presentation/widgets/member_photo.dart';
import '../../settings/data/staff_repository.dart';
import '../application/diet_providers.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/food.dart';
import '../domain/nutrition.dart';
import 'diet_ui.dart';

// ---------------------------------------------------------------------------
// Nutrition overview (6.11)
// ---------------------------------------------------------------------------
/// Coaches' members with their plan, this week's adherence, missed meals,
/// what's marked today and a health flag.
class DietMembersView extends ConsumerStatefulWidget {
  const DietMembersView({super.key, this.footerPad = 0});

  final double footerPad;

  @override
  ConsumerState<DietMembersView> createState() => _DietMembersViewState();
}

class _DietMembersViewState extends ConsumerState<DietMembersView> {
  String _search = '';
  String? _trainer;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final trainers = owner ? (ref.watch(trainersProvider).value ?? const <StaffMember>[]) : const <StaffMember>[];
    final list = ref.watch(dietOverviewListProvider(_trainer, _search));
    return AbsRefresh(
      onRefresh: () => ref.refresh(dietOverviewListProvider(_trainer, _search).future),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 500) ref.read(dietOverviewListProvider(_trainer, _search).notifier).loadMore();
          return false;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, widget.footerPad + AbsSpace.x6),
          children: [
            AbsTextField(
              label: l.trainSearchMembers,
              suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(AbsMotion.standard.duration, () => setState(() => _search = v.trim()));
              },
            ),
            if (owner && trainers.isNotEmpty) ...[
              const SizedBox(height: AbsSpace.x3),
              SizedBox(
                height: AbsSize.touchTarget,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PopChip(
                      label: l.trainAllTrainers,
                      selected: _trainer == null,
                      hue: PopHue.mint,
                      onTap: () => setState(() => _trainer = null),
                    ),
                    for (final t in trainers) ...[
                      const SizedBox(width: AbsSpace.x2),
                      PopChip(
                        label: t.name,
                        selected: _trainer == t.id,
                        hue: PopHue.mint,
                        onTap: () => setState(() => _trainer = t.id),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: AbsSpace.x4),
            switch (list) {
              AsyncData(:final value) when value.items.isNotEmpty => Column(
                children: [
                  for (final (i, r) in value.items.indexed)
                    Entrance(
                      index: i,
                      child: _DietMemberTile(row: r),
                    ),
                ],
              ),
              AsyncData() => EmptyState(
                title: l.trainEmptyMembersTitle,
                message: l.dietEmptyMembersBody,
                illustration: EmptyIllustration.people,
                hue: PopHue.mint,
              ),
              AsyncError(:final error) => ErrorState(
                message: friendlyError(l, error),
                onRetry: () => ref.invalidate(dietOverviewListProvider(_trainer, _search)),
              ),
              _ => const SizedBox(height: 400, child: SkeletonList(itemCount: 5)),
            },
          ],
        ),
      ),
    );
  }
}

PopHue adherenceHue(double? a) => a == null
    ? PopHue.sky
    : a >= 0.75
    ? PopHue.mint
    : a >= 0.5
    ? PopHue.tangerine
    : PopHue.coral;

class _DietMemberTile extends StatelessWidget {
  const _DietMemberTile({required this.row});

  final DietRow row;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final r = row;
    final adh = r.adherence;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        key: ValueKey('diet-member-${r.memberId}'),
        onTap: () => context.push('${Routes.memberDetail(r.memberId)}?tab=diet'),
        padding: const EdgeInsets.all(AbsSpace.x3),
        child: Row(
          children: [
            MemberPhoto(name: r.name, path: r.photoPath, size: 46),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    r.lastLoggedAt == null
                        ? l.dietNeverLogged
                        : l.dietLastLogged(dateLabel(IstDates.istDate(r.lastLoggedAt!))),
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AbsSpace.x1),
                  Wrap(
                    spacing: AbsSpace.x1,
                    runSpacing: AbsSpace.x1,
                    children: [
                      PopSticker(
                        label: r.dietName ?? l.dietNoPlanShort,
                        hue: r.dietName == null ? PopHue.coral : PopHue.lime,
                      ),
                      if (r.dietStatus == DietStatus.queued) PopSticker(label: l.dietStatusQueued, hue: PopHue.sky),
                      if (r.dietStatus == DietStatus.active)
                        PopSticker(label: l.dietTodayMarked(r.loggedToday, r.mealsPerDay), hue: PopHue.grape),
                      if (r.missed7d > 0) PopSticker(label: l.dietMissedMeals(r.missed7d), hue: PopHue.tangerine),
                      if (r.hasConditions) PopSticker(label: l.dietHealthFlag, hue: PopHue.coral),
                    ],
                  ),
                ],
              ),
            ),
            if (adh != null)
              ProgressRing(
                progress: adh,
                size: 54,
                strokeWidth: 6,
                hue: adherenceHue(adh),
                semanticsLabel: l.trainAdherence((adh * 100).round()),
                child: Text('${(adh * 100).round()}%', style: t.numericOf(t.label)),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Plan library (6.6)
// ---------------------------------------------------------------------------
class DietPlansView extends ConsumerStatefulWidget {
  const DietPlansView({super.key, this.footerPad = 0, this.onPick});

  final double footerPad;

  /// When set, tapping a plan picks it instead of opening it.
  final ValueChanged<DietTemplate>? onPick;

  @override
  ConsumerState<DietPlansView> createState() => _DietPlansViewState();
}

class _DietPlansViewState extends ConsumerState<DietPlansView> {
  String _search = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = ref.watch(dietTemplateListProvider(_search));
    return AbsRefresh(
      onRefresh: () => ref.refresh(dietTemplateListProvider(_search).future),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 500) ref.read(dietTemplateListProvider(_search).notifier).loadMore();
          return false;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, widget.footerPad + AbsSpace.x6),
          children: [
            AbsTextField(
              label: l.dietSearchPlans,
              suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(AbsMotion.standard.duration, () => setState(() => _search = v.trim()));
              },
            ),
            const SizedBox(height: AbsSpace.x4),
            switch (list) {
              AsyncData(:final value) when value.items.isNotEmpty => Column(
                children: [
                  for (final (i, t) in value.items.indexed)
                    Entrance(
                      index: i,
                      child: DietTemplateCard(
                        template: t,
                        onTap: () => widget.onPick != null ? widget.onPick!(t) : context.push(Routes.dietDetail(t.id!)),
                      ),
                    ),
                ],
              ),
              AsyncData() => EmptyState(
                title: l.dietPlansEmptyTitle,
                message: l.dietPlansEmptyBody,
                illustration: EmptyIllustration.search,
                hue: PopHue.mint,
              ),
              AsyncError(:final error) => ErrorState(
                message: friendlyError(l, error),
                onRetry: () => ref.invalidate(dietTemplateListProvider(_search)),
              ),
              _ => const SizedBox(height: 400, child: SkeletonList(itemCount: 4)),
            },
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Food database (6.1)
// ---------------------------------------------------------------------------
/// Search, food groups, "not reviewed" and custom foods. Also the body of
/// the builder's food picker ([picking] set).
class FoodsView extends ConsumerStatefulWidget {
  const FoodsView({
    super.key,
    this.footerPad = 0,
    this.picking,
    this.onToggle,
    this.dietPref,
    this.conflictsOf,
    this.controller,
  });

  final double footerPad;
  final Set<String>? picking;
  final ValueChanged<Food>? onToggle;

  /// Shows only foods that suit this preference (picker).
  final String? dietPref;
  final List<FoodConflict> Function(Food)? conflictsOf;
  final ScrollController? controller;

  @override
  ConsumerState<FoodsView> createState() => _FoodsViewState();
}

class _FoodsViewState extends ConsumerState<FoodsView> {
  final _searchCtl = TextEditingController();
  Timer? _debounce;
  String _search = '';
  String? _category;
  bool _unreviewed = false;
  bool _custom = false;
  bool _suitOnly = true;
  int _shown = kPageSize;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtl.dispose();
    super.dispose();
  }

  void _reset(VoidCallback change) => setState(() {
    change();
    _shown = kPageSize;
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider).value;
    final coach = user?.role == UserRole.owner || user?.role == UserRole.trainer;
    final catalogue = ref.watch(foodCatalogueProvider);
    final index = catalogue.value;
    final picking = widget.picking != null;
    final results = index == null
        ? const <Food>[]
        : index.query(
            search: _search,
            category: _category,
            dietPref: picking && _suitOnly ? widget.dietPref : null,
            unreviewedOnly: _unreviewed,
            customOnly: _custom,
          );

    final List<Widget> list = switch (catalogue) {
      AsyncData() when results.isNotEmpty => [
        SliverList.builder(
          itemCount: results.length < _shown ? results.length : _shown,
          itemBuilder: (context, i) {
            final f = results[i];
            return FoodTile(
              key: ValueKey('food-row-${f.id}'),
              food: f,
              selected: widget.picking?.contains(f.id),
              conflicts: widget.conflictsOf?.call(f) ?? const [],
              onTap: picking ? () => widget.onToggle?.call(f) : () => showFoodSheet(context, f),
            );
          },
        ),
      ],
      AsyncData() => [
        SliverToBoxAdapter(
          child: EmptyState(
            title: l.foodEmptyTitle,
            message: l.foodEmptyBody,
            illustration: EmptyIllustration.search,
            actionLabel: l.exClearFilters,
            onAction: () => _reset(() {
              _searchCtl.clear();
              _search = '';
              _category = null;
              _unreviewed = false;
              _custom = false;
            }),
          ),
        ),
      ],
      AsyncError(:final error) => [
        SliverToBoxAdapter(
          child: ErrorState(message: friendlyError(l, error), onRetry: () => ref.invalidate(foodCatalogueProvider)),
        ),
      ],
      _ => [const SliverToBoxAdapter(child: SizedBox(height: 480, child: SkeletonList(itemCount: 6)))],
    };

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 500 && _shown < results.length) setState(() => _shown += kPageSize);
        return false;
      },
      child: AbsRefresh(
        onRefresh: () async {
          ref.invalidate(foodCatalogueProvider);
          await ref.read(foodCatalogueProvider.future);
        },
        child: CustomScrollView(
          controller: widget.controller,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
              sliver: SliverList.list(
                children: [
                  AbsTextField(
                    key: const ValueKey('food-search'),
                    label: l.foodSearchHint(index?.length ?? 300),
                    controller: _searchCtl,
                    suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
                    onChanged: (v) {
                      _debounce?.cancel();
                      _debounce = Timer(AbsMotion.quick.duration, () => _reset(() => _search = v));
                    },
                  ),
                  const SizedBox(height: AbsSpace.x3),
                  SizedBox(
                    height: AbsSize.touchTarget,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (picking && widget.dietPref != null) ...[
                          PopChip(
                            key: const ValueKey('food-suits'),
                            label: l.foodSuits(dietPrefLabel(l, widget.dietPref)),
                            icon: PhosphorIcons.leaf(PhosphorIconsStyle.bold),
                            hue: PopHue.mint,
                            selected: _suitOnly,
                            onTap: () => _reset(() => _suitOnly = !_suitOnly),
                          ),
                          const SizedBox(width: AbsSpace.x2),
                        ],
                        if (coach && !picking) ...[
                          PopChip(
                            key: const ValueKey('food-unreviewed'),
                            label: l.foodNotReviewedCount(index?.unreviewed ?? 0),
                            icon: PhosphorIcons.sealQuestion(PhosphorIconsStyle.bold),
                            hue: PopHue.tangerine,
                            selected: _unreviewed,
                            onTap: () => _reset(() => _unreviewed = !_unreviewed),
                          ),
                          const SizedBox(width: AbsSpace.x2),
                          PopChip(
                            label: l.foodCustom,
                            icon: PhosphorIcons.userCircle(PhosphorIconsStyle.bold),
                            hue: PopHue.grape,
                            selected: _custom,
                            onTap: () => _reset(() => _custom = !_custom),
                          ),
                          const SizedBox(width: AbsSpace.x2),
                        ],
                        for (final cat in kFoodCategories) ...[
                          PopChip(
                            key: ValueKey('food-cat-$cat'),
                            label: foodCategoryLabel(l, cat),
                            hue: PopHue.sky,
                            selected: _category == cat,
                            onTap: () => _reset(() => _category = _category == cat ? null : cat),
                          ),
                          const SizedBox(width: AbsSpace.x2),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AbsSpace.x3),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
              sliver: SliverMainAxisGroup(slivers: list),
            ),
            SliverToBoxAdapter(child: SizedBox(height: widget.footerPad + AbsSpace.x6)),
          ],
        ),
      ),
    );
  }
}

/// A food's details: per serving and per 100 g, allergens, what to buy,
/// review status; coaches edit and review, the owner (or its author) removes.
Future<void> showFoodSheet(BuildContext context, Food food) => showAbsBottomSheet<void>(
  context: context,
  builder: (context, controller) => _FoodSheet(food: food, controller: controller),
);

class _FoodSheet extends ConsumerWidget {
  const _FoodSheet({required this.food, required this.controller});

  final Food food;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final user = ref.watch(currentUserProvider).value;
    final coach = user?.role == UserRole.owner || user?.role == UserRole.trainer;
    final f = ref.watch(foodCatalogueProvider).value?[food.id] ?? food;
    final canRemove = user?.role == UserRole.owner || (coach && f.isCustom && f.createdBy == user?.userId);
    final per100 = f.servingG == 0 ? null : f.macros * (100 / f.servingG);

    Future<void> run(Future<void> Function() action, String done) async {
      try {
        await action();
        ref.invalidate(foodCatalogueProvider);
        if (context.mounted) showAbsSnackbar(context, done, tone: SnackTone.success);
      } catch (e) {
        if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
      }
    }

    Widget stat(String label, String value, PopHue hue) => Expanded(
      child: AbsCard(
        hue: hue,
        padding: const EdgeInsets.symmetric(vertical: AbsSpace.x3, horizontal: AbsSpace.x2),
        child: Column(
          children: [
            Text(value, style: t.numericOf(t.heading)),
            Text(label, style: t.caption.copyWith(color: c.textSecondary)),
          ],
        ),
      ),
    );

    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x6),
      children: [
        Row(
          children: [
            VegMark(vegType: f.vegType, size: 18),
            const SizedBox(width: AbsSpace.x2),
            Expanded(child: Text(f.name, style: t.title)),
          ],
        ),
        if (f.localName != null) Text(f.localName!, style: t.body.copyWith(color: c.textSecondary)),
        const SizedBox(height: AbsSpace.x2),
        Wrap(
          spacing: AbsSpace.x1,
          runSpacing: AbsSpace.x1,
          children: [
            PopSticker(label: foodCategoryLabel(l, f.category), hue: PopHue.sky),
            PopSticker(label: vegTypeLabel(l, f.vegType), hue: PopHue.mint),
            if (f.jainOk) PopSticker(label: l.foodJainOk, hue: PopHue.lime),
            PopSticker(
              label: f.isReviewed ? l.foodReviewed : l.foodNotReviewed,
              hue: f.isReviewed ? PopHue.lime : PopHue.tangerine,
            ),
            if (f.isCustom) PopSticker(label: l.foodCustom, hue: PopHue.grape),
          ],
        ),
        const SizedBox(height: AbsSpace.x4),
        Text(l.foodPerServing(servingText(l, f)), style: t.label.copyWith(color: c.textSecondary)),
        const SizedBox(height: AbsSpace.x2),
        Row(
          children: [
            stat(l.dietCalories, '${f.kcal.round()}', PopHue.lime),
            const SizedBox(width: AbsSpace.x2),
            stat(l.dietProtein, grams(f.protein), PopHue.bubblegum),
            const SizedBox(width: AbsSpace.x2),
            stat(l.dietCarbs, grams(f.carbs), PopHue.sky),
            const SizedBox(width: AbsSpace.x2),
            stat(l.dietFat, grams(f.fat), PopHue.tangerine),
          ],
        ),
        const SizedBox(height: AbsSpace.x2),
        Text(
          [
            l.foodFibre(f.fibre.toStringAsFixed(1)),
            if (per100 != null && !f.isWeighed) l.foodPer100(per100.kcal.round(), per100.protein.toStringAsFixed(1)),
          ].join(' · '),
          style: t.caption.copyWith(color: c.textSecondary),
        ),
        if (f.allergens.isNotEmpty) ...[
          const SizedBox(height: AbsSpace.x4),
          Text(l.foodAllergens, style: t.label.copyWith(color: c.textSecondary)),
          const SizedBox(height: AbsSpace.x1),
          Wrap(
            spacing: AbsSpace.x1,
            runSpacing: AbsSpace.x1,
            children: [for (final a in f.allergens) PopSticker(label: allergenLabel(l, a), hue: PopHue.coral)],
          ),
        ],
        if (f.grocery.isNotEmpty) ...[
          const SizedBox(height: AbsSpace.x4),
          Text(l.foodToBuy, style: t.label.copyWith(color: c.textSecondary)),
          Text(
            f.grocery
                .map((g) => '${g.item} ${g.unit == 'pc' ? '×${fmtQty(g.qty)}' : '${fmtQty(g.qty)} ${g.unit}'}')
                .join(', '),
            style: t.body,
          ),
        ],
        const SizedBox(height: AbsSpace.x5),
        if (coach) ...[
          if (!f.isReviewed)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x2),
              child: AbsButton(
                key: const ValueKey('food-mark-reviewed'),
                label: l.foodMarkReviewed,
                icon: PhosphorIcons.sealCheck(PhosphorIconsStyle.bold),
                hue: PopHue.lime,
                onPressed: () => run(() => ref.read(dietRepositoryProvider).markReviewed(f.id), l.foodReviewedDone),
              ),
            ),
          AbsButton.secondary(
            key: const ValueKey('food-edit'),
            label: l.foodEdit,
            icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
            onPressed: () {
              final router = GoRouter.of(context);
              Navigator.pop(context);
              router.push(Routes.foodEdit(f.id));
            },
          ),
          if (canRemove) ...[
            const SizedBox(height: AbsSpace.x2),
            AbsButton.ghost(
              label: l.foodRemove,
              icon: PhosphorIcons.trash(PhosphorIconsStyle.bold),
              onPressed: () async {
                await run(() => ref.read(dietRepositoryProvider).archiveFood(f.id), l.foodRemoved);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ],
      ],
    );
  }
}
