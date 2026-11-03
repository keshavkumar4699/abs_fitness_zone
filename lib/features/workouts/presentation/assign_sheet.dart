import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../exercises/presentation/exercise_ui.dart' show weekdayShort;
import '../application/workouts_providers.dart';
import '../data/workouts_repository.dart';
import '../domain/workout_logic.dart';
import '../domain/workout_models.dart';
import 'workout_ui.dart';

/// Assign a program to one or many members (5.4): start date, the weekdays
/// to train, and whether it replaces or queues after a current program.
Future<int?> showAssignSheet(
  BuildContext context, {
  required WorkoutTemplate template,
  Map<String, String> preset = const {},
}) => showAbsBottomSheet<int>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _AssignSheet(controller: controller, template: template, preset: preset),
);

/// From a member's page: pick a program first, then assign it.
Future<int?> showPickAndAssign(BuildContext context, {required String memberId, required String memberName}) async {
  final t = await showAbsBottomSheet<WorkoutTemplate>(
    context: context,
    expandToFull: true,
    builder: (context, controller) => _TemplatePicker(controller: controller),
  );
  if (t == null || !context.mounted) return null;
  return showAssignSheet(context, template: t, preset: {memberId: memberName});
}

class _TemplatePicker extends ConsumerWidget {
  const _TemplatePicker({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(templateListProvider(''));
    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x6),
      children: [
        Text(l.assignPickProgram, style: context.text.title),
        const SizedBox(height: AbsSpace.x3),
        AsyncView(
          value: list,
          onRetry: () => ref.invalidate(templateListProvider('')),
          loading: const SizedBox(height: 300, child: SkeletonList(itemCount: 4)),
          isEmpty: (v) => v.items.isEmpty,
          empty: EmptyState(
            title: l.progEmptyTitle,
            message: l.progEmptyBody,
            illustration: EmptyIllustration.dumbbell,
          ),
          data: (page) => Column(
            children: [for (final t in page.items) TemplateCard(template: t, onTap: () => Navigator.pop(context, t))],
          ),
        ),
      ],
    );
  }
}

/// A program in the library list.
class TemplateCard extends StatelessWidget {
  const TemplateCard({super.key, required this.template, required this.onTap});

  final WorkoutTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final x = template;
    final hue = switch (x.goal) {
      'fat_loss' => PopHue.coral,
      'muscle_gain' => PopHue.grape,
      'strength' => PopHue.tangerine,
      'rehab' => PopHue.sky,
      _ => PopHue.mint,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        key: ValueKey('template-${x.id}'),
        hue: hue,
        onTap: onTap,
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Row(
          children: [
            IconBubble(icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold), hue: hue),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(x.name, style: t.heading),
                  Text(
                    [l.progDays(x.days.length), l.progWeeks(x.weeks), l.progExercises(x.exerciseCount)].join(' · '),
                    style: t.caption.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: AbsSpace.x1),
                  Wrap(
                    spacing: AbsSpace.x1,
                    runSpacing: AbsSpace.x1,
                    children: [
                      if (x.isStarter) PopSticker(label: l.progStarter, hue: PopHue.lime),
                      PopSticker(label: progressionLabel(l, x), hue: PopHue.sky),
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

class _AssignSheet extends ConsumerStatefulWidget {
  const _AssignSheet({required this.controller, required this.template, required this.preset});

  final ScrollController controller;
  final WorkoutTemplate template;
  final Map<String, String> preset;

  @override
  ConsumerState<_AssignSheet> createState() => _AssignSheetState();
}

class _AssignSheetState extends ConsumerState<_AssignSheet> {
  late final Map<String, String> _members = {...widget.preset};
  late Set<int> _weekdays = defaultWeekdays(widget.template.days.length).toSet();
  DateTime _start = IstDates.today();
  AssignMode _mode = AssignMode.replace;
  String _search = '';
  bool _busy = false;

  int get _days => widget.template.days.length;

  Future<void> _assign() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final n = await ref
          .read(workoutsRepositoryProvider)
          .assign(
            templateId: widget.template.id!,
            memberIds: _members.keys.toList(),
            start: _start,
            weekdays: (_weekdays.toList()..sort()),
            mode: _mode,
          );
      for (final id in _members.keys) {
        ref.refreshWorkouts(id);
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
    final rows = ref.watch(coachListProvider(null, _search)).value?.items ?? const [];
    final ready = _members.isNotEmpty && _weekdays.length == _days;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: AbsSpace.x4, bottom: AbsSpace.x2),
      child: Text(s, style: t.label.copyWith(color: c.textSecondary)),
    );
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.assignTitle(widget.template.name), style: t.title),
              label(l.assignWeekdays(_days)),
              PopChoiceChips<int>(
                key: const ValueKey('assign-weekdays'),
                options: const [1, 2, 3, 4, 5, 6, 7],
                labelOf: (d) => weekdayShort(l, d),
                selected: _weekdays,
                hue: PopHue.lime,
                onChanged: (v) => setState(() => _weekdays = v),
              ),
              if (_weekdays.length != _days)
                Padding(
                  padding: const EdgeInsets.only(top: AbsSpace.x1),
                  child: Text(l.assignPickWeekdays(_days), style: t.caption.copyWith(color: c.danger)),
                ),
              const SizedBox(height: AbsSpace.x4),
              DateField(
                label: l.assignStart,
                value: _start,
                allowClear: false,
                first: IstDates.today().subtract(const Duration(days: 7)),
                onChanged: (d) => setState(() => _start = d ?? _start),
              ),
              label(l.assignMode),
              SegmentedTabs(
                hue: PopHue.sky,
                dense: true,
                labels: [l.assignReplace, l.assignQueue],
                selected: _mode == AssignMode.replace ? 0 : 1,
                onChanged: (i) => setState(() => _mode = i == 0 ? AssignMode.replace : AssignMode.queue),
              ),
              label(l.assignMembers),
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
                          onTap: () => setState(() => _members.remove(e.key)),
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
                        key: ValueKey('assign-member-${r.memberId}'),
                        value: _members.containsKey(r.memberId),
                        title: Text(r.name),
                        subtitle: Text(r.programName ?? l.trainNoProgram),
                        onChanged: (v) =>
                            setState(() => v == true ? _members[r.memberId] = r.name : _members.remove(r.memberId)),
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
            key: const ValueKey('assign-confirm'),
            label: l.assignConfirm(_members.length),
            hue: PopHue.lime,
            icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
            isLoading: _busy,
            onPressed: ready ? _assign : null,
          ),
        ),
      ],
    );
  }
}
