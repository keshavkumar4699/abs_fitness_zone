import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../application/diet_providers.dart';
import '../data/diet_repository.dart';
import '../domain/diet_models.dart';
import '../domain/nutrition.dart';
import 'diet_training_views.dart';
import 'diet_ui.dart';

/// Assign a plan to one or many members (6.7) from a start date. Members
/// with health conditions, or whose preferences clash with the plan, are
/// flagged before assigning (6.4 and the F6 acceptance).
Future<int?> showAssignDietSheet(
  BuildContext context, {
  required DietTemplate template,
  Map<String, String> preset = const {},
}) => showAbsBottomSheet<int>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _AssignSheet(controller: controller, template: template, preset: preset),
);

/// From a member's page: pick a plan first, then assign it.
Future<int?> showPickAndAssignDiet(BuildContext context, {required String memberId, required String memberName}) async {
  final t = await showAbsBottomSheet<DietTemplate>(
    context: context,
    expandToFull: true,
    builder: (context, controller) => Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(context.l10n.dietPickPlan, style: context.text.title),
          ),
        ),
        Expanded(child: DietPlansView(onPick: (t) => Navigator.pop(context, t))),
      ],
    ),
  );
  if (t == null || !context.mounted) return null;
  return showAssignDietSheet(context, template: t, preset: {memberId: memberName});
}

class _AssignSheet extends ConsumerStatefulWidget {
  const _AssignSheet({required this.controller, required this.template, required this.preset});

  final ScrollController controller;
  final DietTemplate template;
  final Map<String, String> preset;

  @override
  ConsumerState<_AssignSheet> createState() => _AssignSheetState();
}

class _AssignSheetState extends ConsumerState<_AssignSheet> {
  late final Map<String, String> _members = {...widget.preset};
  final Map<String, DietFlags> _flags = {};
  DateTime _start = IstDates.today();
  String _search = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadFlags(_members.keys);
  }

  Future<void> _loadFlags(Iterable<String> ids) async {
    final need = ids.where((id) => !_flags.containsKey(id)).toList();
    if (need.isEmpty) return;
    try {
      final list = await ref.read(dietRepositoryProvider).flagsFor(need);
      if (mounted) setState(() => _flags.addAll({for (final f in list) f.memberId: f}));
    } catch (_) {
      // Warnings are a help, not a gate.
    }
  }

  void _toggle(String id, String name, bool on) {
    setState(() => on ? _members[id] = name : _members.remove(id));
    if (on) _loadFlags([id]);
  }

  Future<void> _assign() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final n = await ref
          .read(dietRepositoryProvider)
          .assign(templateId: widget.template.id!, memberIds: _members.keys.toList(), start: _start);
      for (final id in _members.keys) {
        ref.refreshDiet(id);
      }
      if (!mounted) return;
      showAbsSnackbar(context, l.assignDone(n), tone: SnackTone.success);
      Navigator.pop(context, n);
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
    final rows = ref.watch(dietOverviewListProvider(null, _search)).value?.items ?? const <DietRow>[];
    final lookup = lookupIn(ref.watch(foodCatalogueProvider).value);
    final warnings = <Widget>[
      for (final e in _members.entries)
        if (_flags[e.key] case final f?)
          ...() {
            final clashes = planConflicts(widget.template, lookup, member: f);
            return [
              if (f.hasConditions)
                _Warning(
                  key: ValueKey('assign-flag-health-${e.key}'),
                  text: l.assignHealthWarning(e.value, f.conditions ?? l.dietHealthFlag),
                ),
              if (clashes.isNotEmpty)
                _Warning(
                  key: ValueKey('assign-flag-foods-${e.key}'),
                  text: l.assignFoodsWarning(clashes.length, e.value),
                ),
            ];
          }(),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.assignTitle(widget.template.name), style: t.title),
              Text(
                '${kcalText(widget.template.kcalTarget)} · ${l.dietMealsCount(widget.template.meals.length)}',
                style: t.caption.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AbsSpace.x4),
              DateField(
                label: l.assignStart,
                value: _start,
                allowClear: false,
                first: IstDates.today().subtract(const Duration(days: 7)),
                onChanged: (d) => setState(() => _start = d ?? _start),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AbsSpace.x2),
                child: Text(l.dietAssignReplaces, style: t.caption.copyWith(color: c.textSecondary)),
              ),
              ...warnings,
              Padding(
                padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
                child: Text(l.assignMembers, style: t.label.copyWith(color: c.textSecondary)),
              ),
              if (_members.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                  child: Wrap(
                    spacing: AbsSpace.x2,
                    runSpacing: AbsSpace.x2,
                    children: [
                      for (final e in _members.entries)
                        PopChip(
                          label: e.value,
                          icon: PhosphorIcons.x(PhosphorIconsStyle.bold),
                          selected: true,
                          hue: PopHue.grape,
                          onTap: () => _toggle(e.key, e.value, false),
                        ),
                    ],
                  ),
                ),
              AbsTextField(
                label: l.assignSearch,
                onChanged: (v) => setState(() => _search = v.trim()),
                suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
              ),
              const SizedBox(height: AbsSpace.x2),
              Material(
                type: MaterialType.transparency,
                child: Column(
                  children: [
                    for (final r in rows.take(30))
                      CheckboxListTile(
                        key: ValueKey('assign-diet-member-${r.memberId}'),
                        value: _members.containsKey(r.memberId),
                        title: Text(r.name),
                        subtitle: Text(r.dietName ?? l.dietNoPlanShort),
                        secondary: r.hasConditions
                            ? Icon(PhosphorIcons.heartbeat(PhosphorIconsStyle.bold), color: c.danger)
                            : null,
                        onChanged: (v) => _toggle(r.memberId, r.name, v == true),
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
            key: const ValueKey('assign-diet-confirm'),
            label: l.assignConfirm(_members.length),
            hue: PopHue.lime,
            icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
            isLoading: _busy,
            onPressed: _members.isEmpty ? null : _assign,
          ),
        ),
      ],
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AbsSpace.x3),
    child: AbsCard(
      hue: PopHue.coral,
      padding: const EdgeInsets.all(AbsSpace.x3),
      child: Row(
        children: [
          Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill), color: context.colors.danger, size: AbsSize.iconSmall),
          const SizedBox(width: AbsSpace.x2),
          Expanded(child: Text(text, style: context.text.body)),
        ],
      ),
    ),
  );
}
