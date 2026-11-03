import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../application/members_providers.dart';
import '../domain/models.dart';
import 'member_ui.dart';

/// Full filter + sort sheet for the members list. Returns the new query.
Future<MemberQuery?> showMemberFilters(BuildContext context, MemberQuery current) => showAbsBottomSheet<MemberQuery>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _FiltersSheet(current: current, controller: controller),
);

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet({required this.current, required this.controller});

  final MemberQuery current;
  final ScrollController controller;

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  late MemberQuery _q = widget.current;

  Future<void> _save() async {
    final l = context.l10n;
    final name = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.filterSave),
        content: AbsTextField(label: l.filterSaveName, controller: name, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.commonSave)),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      await ref.read(savedFiltersProvider.notifier).save(name.text, _q);
      if (mounted) showAbsSnackbar(context, l.saved, tone: SnackTone.success);
    }
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final plans = ref.watch(plansProvider).value ?? const [];
    final trainers = ref.watch(trainersProvider).value ?? const [];
    final saved = ref.watch(savedFiltersProvider);

    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.label.copyWith(color: context.colors.textSecondary)),
          const SizedBox(height: AbsSpace.x2),
          child,
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.membersFilters, style: t.title)),
                  TextButton(
                    onPressed: () => setState(() => _q = MemberQuery(search: _q.search)),
                    child: Text(l.membersClearFilters),
                  ),
                ],
              ),
              const SizedBox(height: AbsSpace.x3),
              section(
                l.membersSort,
                PopSingleChips<MemberSort>(
                  options: MemberSort.values,
                  allowEmpty: false,
                  hue: PopHue.grape,
                  labelOf: (s) => switch (s) {
                    MemberSort.name => l.sortName,
                    MemberSort.endDate => l.sortEndDate,
                    MemberSort.joined => l.sortJoined,
                  },
                  value: _q.sort,
                  onChanged: (s) => setState(() => _q = _q.copyWith(sort: s ?? MemberSort.name)),
                ),
              ),
              section(
                l.filterStatus,
                PopChoiceChips<MemberStatus>(
                  options: const [
                    MemberStatus.active,
                    MemberStatus.expiring,
                    MemberStatus.expired,
                    MemberStatus.frozen,
                    MemberStatus.upcoming,
                    MemberStatus.inactive,
                    MemberStatus.cancelled,
                  ],
                  hue: PopHue.sky,
                  labelOf: (s) => statusLabel(l, s, days: 7).split('·').first.trim(),
                  selected: {for (final s in _q.statuses) MemberStatus.parse(s)},
                  onChanged: (s) => setState(() => _q = _q.copyWith(statuses: [for (final x in s) x.name])),
                ),
              ),
              if (plans.isNotEmpty)
                section(
                  l.filterPlan,
                  PopSingleChips<String>(
                    options: [for (final p in plans) p.name],
                    hue: PopHue.tangerine,
                    labelOf: (s) => s,
                    value: _q.planName,
                    onChanged: (v) => setState(() => _q = _q.copyWith(planName: v)),
                  ),
                ),
              if (trainers.isNotEmpty)
                section(
                  l.filterTrainer,
                  PopSingleChips<String>(
                    options: [for (final tr in trainers) tr.id],
                    hue: PopHue.bubblegum,
                    labelOf: (id) => trainers.firstWhere((tr) => tr.id == id).name,
                    value: _q.trainerId,
                    onChanged: (v) => setState(() => _q = _q.copyWith(trainerId: v)),
                  ),
                ),
              section(
                l.filterBatch,
                PopSingleChips<String>(
                  options: const ['morning', 'evening'],
                  hue: PopHue.lime,
                  labelOf: (b) => batchLabel(l, b),
                  value: _q.batch,
                  onChanged: (v) => setState(() => _q = _q.copyWith(batch: v)),
                ),
              ),
              section(
                l.filterGender,
                PopSingleChips<String>(
                  options: const ['male', 'female', 'other'],
                  hue: PopHue.mint,
                  labelOf: (g) => genderLabel(l, g),
                  value: _q.gender,
                  onChanged: (v) => setState(() => _q = _q.copyWith(gender: v)),
                ),
              ),
              section(
                l.filterJoined,
                Row(
                  children: [
                    Expanded(
                      child: DateField(
                        label: l.filterFrom,
                        value: _q.joinedFrom,
                        onChanged: (d) => setState(() => _q = _q.copyWith(joinedFrom: d)),
                      ),
                    ),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: DateField(
                        label: l.filterTo,
                        value: _q.joinedTo,
                        onChanged: (d) => setState(() => _q = _q.copyWith(joinedTo: d)),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: AbsSpace.x2,
                runSpacing: AbsSpace.x2,
                children: [
                  PopChip(
                    label: l.filterBirthday,
                    hue: PopHue.bubblegum,
                    selected: _q.birthdayThisMonth,
                    onTap: () => setState(() => _q = _q.copyWith(birthdayThisMonth: !_q.birthdayThisMonth)),
                  ),
                  PopChip(
                    label: l.filterArchived,
                    hue: PopHue.coral,
                    selected: _q.includeArchived,
                    onTap: () => setState(() => _q = _q.copyWith(includeArchived: !_q.includeArchived)),
                  ),
                ],
              ),
              if (saved.isNotEmpty) ...[
                const SizedBox(height: AbsSpace.x5),
                section(
                  l.filterSaved,
                  Wrap(
                    spacing: AbsSpace.x2,
                    runSpacing: AbsSpace.x2,
                    children: [
                      for (final name in saved.keys)
                        InputChip(
                          label: Text(name),
                          onPressed: () => setState(() => _q = saved[name]!.copyWith(search: _q.search)),
                          onDeleted: () => ref.read(savedFiltersProvider.notifier).remove(name),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AbsSpace.x6),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: Row(
            children: [
              Expanded(
                child: AbsButton.secondary(label: l.filterSave, onPressed: _save),
              ),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                child: AbsButton(label: l.filterApply, hue: PopHue.sky, onPressed: () => Navigator.pop(context, _q)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
