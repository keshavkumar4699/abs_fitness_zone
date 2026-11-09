import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/paging.dart';
import '../../../core/widgets/widgets.dart';
import '../application/exercise_providers.dart';
import '../data/exercise_repository.dart';
import '../domain/exercise.dart';
import 'exercise_ui.dart';

/// The library body (4.2, 4.3): search, a front/back body map, filters and
/// favourites over the cached catalogue. Used in the staff Training tab, the
/// member's library screen and the program builder's picker.
class ExerciseLibraryView extends ConsumerStatefulWidget {
  const ExerciseLibraryView({
    super.key,
    required this.onOpen,
    this.picking,
    this.onToggle,
    this.header = const [],
    this.footerPad = 0,
  });

  final ValueChanged<Exercise> onOpen;

  /// When set, rows are multi-select (ids picked so far).
  final Set<String>? picking;
  final ValueChanged<Exercise>? onToggle;
  final List<Widget> header;
  final double footerPad;

  @override
  ConsumerState<ExerciseLibraryView> createState() => _ExerciseLibraryViewState();
}

class _ExerciseLibraryViewState extends ConsumerState<ExerciseLibraryView> {
  final _search = TextEditingController();
  Timer? _debounce;
  ExerciseFilter _filter = const ExerciseFilter();
  bool _back = false;
  int _shown = kPageSize;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _setFilter(ExerciseFilter f) => setState(() {
    _filter = f;
    _shown = kPageSize;
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final catalogue = ref.watch(exerciseCatalogueProvider);
    final favs = ref.watch(favouriteExercisesProvider).value ?? const <String>{};
    final gym = ref.watch(trainingSettingsProvider).value?.equipment ?? const <String>{};
    final index = catalogue.value;
    final results = index == null ? const <Exercise>[] : index.query(_filter, favourites: favs, gymEquipment: gym);

    final List<Widget> list = switch (catalogue) {
      AsyncData() when results.isNotEmpty => [
        SliverList.builder(
          itemCount: results.length < _shown ? results.length : _shown,
          itemBuilder: (context, i) {
            final e = results[i];
            return ExerciseTile(
              key: ValueKey(e.id),
              exercise: e,
              selected: widget.picking?.contains(e.id),
              onTap: widget.picking != null ? () => widget.onToggle?.call(e) : () => widget.onOpen(e),
            );
          },
        ),
      ],
      AsyncData() => [
        SliverToBoxAdapter(
          child: _filter.favouritesOnly && _filter.search.isEmpty
              ? EmptyState(
                  title: l.exEmptyFavouritesTitle,
                  message: l.exEmptyFavouritesBody,
                  illustration: EmptyIllustration.trophy,
                  hue: PopHue.tangerine,
                )
              : EmptyState(
                  title: l.exEmptyTitle,
                  message: l.exEmptyBody,
                  illustration: EmptyIllustration.search,
                  actionLabel: l.exClearFilters,
                  onAction: () {
                    _search.clear();
                    _setFilter(const ExerciseFilter());
                  },
                ),
        ),
      ],
      AsyncError(:final error) => [
        SliverToBoxAdapter(
          child: ErrorState(message: friendlyError(l, error), onRetry: () => ref.invalidate(exerciseCatalogueProvider)),
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
          ref
            ..invalidate(exerciseCatalogueProvider)
            ..invalidate(favouriteExercisesProvider);
          await ref.read(exerciseCatalogueProvider.future);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
              sliver: SliverList.list(
                children: [
                  ...widget.header,
                  AbsTextField(
                    key: const ValueKey('exercise-search'),
                    label: l.exSearchHint(index?.length ?? 800),
                    controller: _search,
                    suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
                    onChanged: (v) {
                      _debounce?.cancel();
                      _debounce = Timer(AbsMotion.quick.duration, () => _setFilter(_filter.copyWith(search: v)));
                    },
                  ),
                  const SizedBox(height: AbsSpace.x3),
                  SizedBox(
                    height: AbsSize.touchTarget,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        PopChip(
                          label: l.exFavourites,
                          icon: PhosphorIcons.star(PhosphorIconsStyle.bold),
                          hue: PopHue.tangerine,
                          selected: _filter.favouritesOnly,
                          onTap: () => _setFilter(_filter.copyWith(favouritesOnly: !_filter.favouritesOnly)),
                        ),
                        const SizedBox(width: AbsSpace.x2),
                        PopChip(
                          label: l.exOurEquipment,
                          icon: PhosphorIcons.wrench(PhosphorIconsStyle.bold),
                          hue: PopHue.mint,
                          selected: _filter.ourEquipmentOnly,
                          onTap: () => _setFilter(_filter.copyWith(ourEquipmentOnly: !_filter.ourEquipmentOnly)),
                        ),
                        const SizedBox(width: AbsSpace.x2),
                        PopChip(
                          key: const ValueKey('exercise-filters'),
                          label: [l.exFilters, if (_otherFilters > 0) '$_otherFilters'].join(' · '),
                          icon: PhosphorIcons.slidersHorizontal(PhosphorIconsStyle.bold),
                          hue: PopHue.grape,
                          selected: _otherFilters > 0,
                          onTap: () async {
                            final f = await showExerciseFilters(context, _filter, index);
                            if (f != null) _setFilter(f);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AbsSpace.x3),
                  AbsCard(
                    padding: const EdgeInsets.all(AbsSpace.x3),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _filter.muscle == null ? l.exBodyMapHint : muscleLabel(l, _filter.muscle!),
                                style: context.text.label.copyWith(color: c.textSecondary),
                              ),
                            ),
                            if (_filter.muscle != null)
                              PopChip(
                                label: l.exAllMuscles,
                                icon: PhosphorIcons.x(PhosphorIconsStyle.bold),
                                selected: false,
                                onTap: () => _setFilter(_filter.copyWith(muscle: null)),
                              ),
                          ],
                        ),
                        const SizedBox(height: AbsSpace.x2),
                        SizedBox(
                          width: 180,
                          child: SegmentedTabs(
                            dense: true,
                            hue: PopHue.lime,
                            labels: [l.exFront, l.exBack],
                            selected: _back ? 1 : 0,
                            onChanged: (i) => setState(() => _back = i == 1),
                          ),
                        ),
                        const SizedBox(height: AbsSpace.x2),
                        BodyMap(
                          key: const ValueKey('body-map'),
                          height: 320,
                          back: _back,
                          selected: _filter.muscle,
                          onSelect: (m) => _setFilter(_filter.copyWith(muscle: m)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AbsSpace.x4),
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

  int get _otherFilters =>
      (_filter.equipment == null ? 0 : 1) + (_filter.level == null ? 0 : 1) + (_filter.category == null ? 0 : 1);
}

/// Equipment, level and type (4.3), with a live count.
Future<ExerciseFilter?> showExerciseFilters(BuildContext context, ExerciseFilter current, ExerciseIndex? index) =>
    showAbsBottomSheet<ExerciseFilter>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _FilterSheet(controller: controller, initial: current, index: index),
    );

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.controller, required this.initial, required this.index});

  final ScrollController controller;
  final ExerciseFilter initial;
  final ExerciseIndex? index;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ExerciseFilter _f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final count = widget.index?.query(_f.copyWith(favouritesOnly: false, ourEquipmentOnly: false)).length ?? 0;
    Widget title(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: t.label.copyWith(color: context.colors.textSecondary)),
    );
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.exFilters, style: t.title),
              title(l.exEquipment),
              PopSingleChips<String>(
                options: kEquipment,
                labelOf: (e) => equipmentLabel(l, e),
                value: _f.equipment,
                hue: PopHue.mint,
                onChanged: (v) => setState(() => _f = _f.copyWith(equipment: v)),
              ),
              title(l.exLevel),
              PopSingleChips<String>(
                options: kExerciseLevels,
                labelOf: (v) => exerciseLevelLabel(l, v),
                value: _f.level,
                hue: PopHue.sky,
                onChanged: (v) => setState(() => _f = _f.copyWith(level: v)),
              ),
              title(l.exCategory),
              PopSingleChips<String>(
                options: kExerciseCategories,
                labelOf: (v) => categoryLabel(l, v),
                value: _f.category,
                hue: PopHue.bubblegum,
                onChanged: (v) => setState(() => _f = _f.copyWith(category: v)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: Row(
            children: [
              AbsButton.ghost(
                label: l.exClearFilters,
                onPressed: () => setState(() => _f = _f.copyWith(equipment: null, level: null, category: null)),
              ),
              const SizedBox(width: AbsSpace.x2),
              Expanded(
                child: AbsButton(
                  key: const ValueKey('apply-filters'),
                  label: l.exShowResults(count),
                  hue: PopHue.grape,
                  onPressed: () => Navigator.pop(context, _f),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Owner: tick the equipment the gym has (4.3 "Equipment we have").
Future<void> showEquipmentSheet(BuildContext context) => showAbsBottomSheet<void>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _EquipmentSheet(controller: controller),
);

class _EquipmentSheet extends ConsumerStatefulWidget {
  const _EquipmentSheet({required this.controller});

  final ScrollController controller;

  @override
  ConsumerState<_EquipmentSheet> createState() => _EquipmentSheetState();
}

class _EquipmentSheetState extends ConsumerState<_EquipmentSheet> {
  Set<String>? _picked;
  bool _busy = false;

  Future<void> _save() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      await ref.read(exerciseRepositoryProvider).saveEquipment(_picked!);
      ref.invalidate(trainingSettingsProvider);
      if (!mounted) return;
      showAbsSnackbar(context, l.exEquipmentSaved, tone: SnackTone.success);
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
    final settings = ref.watch(trainingSettingsProvider).value;
    _picked ??= settings == null ? null : {...settings.equipment};
    final picked = _picked ?? {...kEquipment};
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.exEquipmentTitle, style: context.text.title),
              const SizedBox(height: AbsSpace.x1),
              Text(l.exEquipmentBody, style: context.text.caption.copyWith(color: context.colors.textSecondary)),
              const SizedBox(height: AbsSpace.x3),
              Material(
                type: MaterialType.transparency,
                child: Column(
                  children: [
                    for (final e in kEquipment)
                      CheckboxListTile(
                        title: Text(equipmentLabel(l, e)),
                        value: picked.contains(e),
                        onChanged: (v) => setState(() {
                          final next = {...picked};
                          v == true ? next.add(e) : next.remove(e);
                          _picked = next;
                        }),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(label: l.commonSave, hue: PopHue.mint, isLoading: _busy, onPressed: _save),
        ),
      ],
    );
  }
}

/// Multi-select picker for the program builder (5.1 "multi-select").
Future<List<Exercise>?> showExercisePicker(BuildContext context) => showAbsBottomSheet<List<Exercise>>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => const _Picker(),
);

class _Picker extends StatefulWidget {
  const _Picker();

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  final _picked = <String, Exercise>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        Expanded(
          child: ExerciseLibraryView(
            header: [
              Text(l.buildPickTitle, style: context.text.title),
              const SizedBox(height: AbsSpace.x3),
            ],
            picking: _picked.keys.toSet(),
            onToggle: (e) => setState(() => _picked.containsKey(e.id) ? _picked.remove(e.id) : _picked[e.id] = e),
            onOpen: (_) {},
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('picker-add'),
            label: l.buildPickAdd(_picked.length),
            hue: PopHue.lime,
            onPressed: _picked.isEmpty ? null : () => Navigator.pop(context, _picked.values.toList()),
          ),
        ),
      ],
    );
  }
}
