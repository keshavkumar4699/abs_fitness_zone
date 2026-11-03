import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/money.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../application/members_providers.dart';
import '../data/plans_repository.dart';
import '../domain/models.dart';

/// Membership plans and add-ons (1.4, 1.5). Owner edits; staff read.
class MembershipPlansScreen extends ConsumerWidget {
  const MembershipPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.plansTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l.plansTab),
              Tab(text: l.addonsTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PlansTab(owner: owner),
            _AddonsTab(owner: owner),
          ],
        ),
      ),
    );
  }
}

PopHue planHue(Plan p) => PopHue.values.firstWhere((h) => h.name == p.color, orElse: () => PopHue.lime);

class _PlansTab extends ConsumerWidget {
  const _PlansTab({required this.owner});

  final bool owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final plans = ref.watch(allPlansProvider);
    final counts = ref.watch(planCountsProvider).value ?? const <String, int>{};
    Future<void> edit([Plan? p]) async {
      final saved = await showAbsBottomSheet<bool>(
        context: context,
        expandToFull: true,
        builder: (context, controller) => _PlanEditor(plan: p, controller: controller),
      );
      if (saved == true) {
        ref
          ..invalidate(allPlansProvider)
          ..invalidate(plansProvider);
      }
    }

    return AbsRefresh(
      onRefresh: () => ref.refresh(allPlansProvider.future),
      child: AsyncView<List<Plan>>(
        value: plans,
        onRetry: () => ref.invalidate(allPlansProvider),
        empty: EmptyState(
          title: l.plansEmptyTitle,
          message: l.plansEmptyBody,
          actionLabel: owner ? l.planNew : null,
          onAction: owner ? edit : null,
          illustration: EmptyIllustration.dumbbell,
          hue: PopHue.lime,
        ),
        data: (items) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x10),
          children: [
            if (owner)
              Align(
                alignment: Alignment.centerRight,
                child: AbsButton(
                  label: l.planNew,
                  icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                  hue: PopHue.lime,
                  expand: false,
                  onPressed: edit,
                ),
              ),
            const SizedBox(height: AbsSpace.x3),
            for (final (i, p) in items.indexed)
              Entrance(
                index: i,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                  child: Opacity(
                    opacity: p.isArchived ? AbsOpacity.disabled + 0.2 : 1,
                    child: AbsCard(
                      hue: planHue(p),
                      onTap: owner ? () => edit(p) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(p.name, style: context.text.title)),
                              Text(Money.format(p.pricePaise), style: context.text.numericOf(context.text.title)),
                            ],
                          ),
                          const SizedBox(height: AbsSpace.x2),
                          Wrap(
                            spacing: AbsSpace.x2,
                            runSpacing: AbsSpace.x2,
                            children: [
                              PopSticker(
                                label: p.durationUnit == 'months'
                                    ? l.planDurationMonths(p.durationValue)
                                    : l.planDurationDays(p.durationValue),
                                hue: planHue(p),
                              ),
                              PopSticker(label: l.planActive(counts[p.id] ?? 0), hue: PopHue.mint),
                              if (p.freezeDaysAllowed > 0)
                                PopSticker(label: l.planFreezeDays(p.freezeDaysAllowed), hue: PopHue.sky),
                              if (p.joiningFeePaise > 0)
                                PopSticker(
                                  label: '${l.summaryJoiningFee} ${Money.format(p.joiningFeePaise)}',
                                  hue: PopHue.tangerine,
                                ),
                              if (p.includesPt) PopSticker(label: l.planIncludesPt, hue: PopHue.bubblegum),
                              if (p.isArchived) PopSticker(label: l.planArchived, hue: PopHue.coral),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanEditor extends ConsumerStatefulWidget {
  const _PlanEditor({required this.plan, required this.controller});

  final Plan? plan;
  final ScrollController controller;

  @override
  ConsumerState<_PlanEditor> createState() => _PlanEditorState();
}

class _PlanEditorState extends ConsumerState<_PlanEditor> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.plan?.name);
  late final _duration = TextEditingController(text: '${widget.plan?.durationValue ?? 1}');
  late final _price = TextEditingController(
    text: widget.plan == null ? '' : '${widget.plan!.pricePaise / 100}'.replaceAll('.0', ''),
  );
  late final _joining = TextEditingController(
    text: widget.plan == null ? '' : '${widget.plan!.joiningFeePaise / 100}'.replaceAll('.0', ''),
  );
  late final _freeze = TextEditingController(text: '${widget.plan?.freezeDaysAllowed ?? 0}');
  late String _unit = widget.plan?.durationUnit ?? 'months';
  late num _gst = widget.plan?.gstRate ?? 0;
  late bool _pt = widget.plan?.includesPt ?? false;
  late String _color = widget.plan?.color ?? 'lime';
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _duration, _price, _joining, _freeze]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save({bool? archive}) async {
    final l = context.l10n;
    if (archive == null && !_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(plansRepositoryProvider);
      if (archive != null) {
        await repo.setPlanArchived(widget.plan!.id, archived: archive);
      } else {
        final plan = Plan(
          id: widget.plan?.id ?? '',
          name: _name.text.trim(),
          durationValue: int.parse(_duration.text.trim()),
          durationUnit: _unit,
          pricePaise: Money.parse(_price.text)!,
          joiningFeePaise: Money.parse(_joining.text) ?? 0,
          gstRate: _gst,
          includesPt: _pt,
          freezeDaysAllowed: int.tryParse(_freeze.text.trim()) ?? 0,
          color: _color,
          isArchived: widget.plan?.isArchived ?? false,
        );
        await repo.savePlan(plan, isNew: widget.plan == null);
      }
      if (!mounted) return;
      showAbsSnackbar(context, l.saved, tone: SnackTone.success);
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = Validators(l);
    String? money(String? s) => Money.parse(s ?? '') == null ? l.commonRequired : null;
    String? optionalMoney(String? s) =>
        (s == null || s.trim().isEmpty || Money.parse(s) != null) ? null : l.commonRequired;
    String? count(String? s, {int min = 0}) => (int.tryParse(s?.trim() ?? '') ?? -1) < min ? l.commonRequired : null;
    const gap = SizedBox(height: AbsSpace.x4);
    return Form(
      key: _form,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: widget.controller,
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
              children: [
                Text(widget.plan == null ? l.planNew : widget.plan!.name, style: context.text.title),
                gap,
                AbsTextField(label: l.planName, controller: _name, validator: v.required),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: AbsTextField(
                        label: l.planDuration,
                        controller: _duration,
                        numeric: true,
                        keyboardType: TextInputType.number,
                        validator: (s) => count(s, min: 1),
                      ),
                    ),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      flex: 2,
                      child: SegmentedTabs(
                        hue: PopHue.lime,
                        labels: [l.unitMonths, l.unitDays],
                        selected: _unit == 'months' ? 0 : 1,
                        onChanged: (i) => setState(() => _unit = i == 0 ? 'months' : 'days'),
                      ),
                    ),
                  ],
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: AbsTextField(
                        label: l.planPrice,
                        controller: _price,
                        prefixText: '₹',
                        numeric: true,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: money,
                      ),
                    ),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: AbsTextField(
                        label: l.planJoiningFee,
                        controller: _joining,
                        prefixText: '₹',
                        numeric: true,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: optionalMoney,
                      ),
                    ),
                  ],
                ),
                gap,
                AbsTextField(
                  label: l.planFreeze,
                  controller: _freeze,
                  numeric: true,
                  keyboardType: TextInputType.number,
                  validator: count,
                ),
                gap,
                Text(l.planGst, style: context.text.label),
                const SizedBox(height: AbsSpace.x2),
                PopSingleChips<num>(
                  options: const [0, 5, 12, 18],
                  allowEmpty: false,
                  hue: PopHue.tangerine,
                  labelOf: (g) => g == 0 ? l.noGst : '$g%',
                  value: _gst,
                  onChanged: (g) => setState(() => _gst = g ?? 0),
                ),
                gap,
                Text(l.planColor, style: context.text.label),
                const SizedBox(height: AbsSpace.x2),
                Wrap(
                  spacing: AbsSpace.x2,
                  children: [
                    for (final h in [
                      PopHue.lime,
                      PopHue.sky,
                      PopHue.tangerine,
                      PopHue.bubblegum,
                      PopHue.grape,
                      PopHue.mint,
                    ])
                      Semantics(
                        button: true,
                        selected: _color == h.name,
                        label: h.name,
                        child: GestureDetector(
                          onTap: () => setState(() => _color = h.name),
                          child: AnimatedContainer(
                            duration: AbsMotion.quick.duration,
                            width: AbsSize.touchTarget,
                            height: AbsSize.touchTarget,
                            decoration: BoxDecoration(
                              color: context.colors.pop(h).fill,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.colors.ink,
                                width: _color == h.name ? 4 : AbsDepth.outline,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.planIncludesPt),
                  value: _pt,
                  onChanged: (v) => setState(() => _pt = v),
                ),
                if (widget.plan != null)
                  AbsButton.ghost(
                    label: widget.plan!.isArchived ? l.planUnarchive : l.planArchive,
                    hue: PopHue.coral,
                    onPressed: () => _save(archive: !widget.plan!.isArchived),
                  ),
                const SizedBox(height: AbsSpace.x6),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
            child: AbsButton(label: l.commonSave, hue: PopHue.lime, isLoading: _busy, onPressed: _save),
          ),
        ],
      ),
    );
  }
}

class _AddonsTab extends ConsumerWidget {
  const _AddonsTab({required this.owner});

  final bool owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final addons = ref.watch(allAddonsProvider);
    String kind(String k) => switch (k) {
      'pt' => l.kindPt,
      'locker' => l.kindLocker,
      'diet' => l.kindDiet,
      _ => l.kindOther,
    };
    Future<void> edit([Addon? a]) async {
      final saved = await showAbsBottomSheet<bool>(
        context: context,
        builder: (context, controller) => _AddonEditor(addon: a, controller: controller, kindLabel: kind),
      );
      if (saved == true) {
        ref
          ..invalidate(allAddonsProvider)
          ..invalidate(addonsProvider);
      }
    }

    return AsyncView<List<Addon>>(
      value: addons,
      onRetry: () => ref.invalidate(allAddonsProvider),
      empty: EmptyState(
        title: l.addonsEmpty,
        message: l.morePlansSubtitle,
        actionLabel: owner ? l.addonNew : null,
        onAction: owner ? edit : null,
        illustration: EmptyIllustration.dumbbell,
        hue: PopHue.bubblegum,
      ),
      data: (items) => ListView(
        padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x10),
        children: [
          if (owner)
            Align(
              alignment: Alignment.centerRight,
              child: AbsButton(label: l.addonNew, hue: PopHue.bubblegum, expand: false, onPressed: edit),
            ),
          const SizedBox(height: AbsSpace.x3),
          for (final a in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x3),
              child: AbsCard(
                onTap: owner ? () => edit(a) : null,
                padding: const EdgeInsets.all(AbsSpace.x4),
                child: Row(
                  children: [
                    IconBubble(icon: PhosphorIcons.puzzlePiece(PhosphorIconsStyle.bold), hue: PopHue.bubblegum),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: context.text.heading),
                          Text(
                            a.isArchived ? '${kind(a.kind)} · ${l.planArchived}' : kind(a.kind),
                            style: context.text.caption,
                          ),
                        ],
                      ),
                    ),
                    Text(Money.format(a.pricePaise), style: context.text.numericOf(context.text.heading)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddonEditor extends ConsumerStatefulWidget {
  const _AddonEditor({required this.addon, required this.controller, required this.kindLabel});

  final Addon? addon;
  final ScrollController controller;
  final String Function(String) kindLabel;

  @override
  ConsumerState<_AddonEditor> createState() => _AddonEditorState();
}

class _AddonEditorState extends ConsumerState<_AddonEditor> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.addon?.name);
  late final _price = TextEditingController(
    text: widget.addon == null ? '' : '${widget.addon!.pricePaise / 100}'.replaceAll('.0', ''),
  );
  late String _kind = widget.addon?.kind ?? 'other';
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _save({bool? archive}) async {
    final l = context.l10n;
    if (archive == null && !_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(plansRepositoryProvider);
      if (archive != null) {
        await repo.setAddonArchived(widget.addon!.id, archived: archive);
      } else {
        await repo.saveAddon(
          Addon(
            id: widget.addon?.id ?? '',
            name: _name.text.trim(),
            pricePaise: Money.parse(_price.text)!,
            kind: _kind,
            isArchived: widget.addon?.isArchived ?? false,
          ),
          isNew: widget.addon == null,
        );
      }
      if (!mounted) return;
      showAbsSnackbar(context, l.saved, tone: SnackTone.success);
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Form(
      key: _form,
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
        children: [
          Text(widget.addon == null ? l.addonNew : widget.addon!.name, style: context.text.title),
          const SizedBox(height: AbsSpace.x4),
          AbsTextField(label: l.addonName, controller: _name, validator: Validators(l).required),
          const SizedBox(height: AbsSpace.x4),
          AbsTextField(
            label: l.addonPrice,
            controller: _price,
            prefixText: '₹',
            numeric: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (s) => Money.parse(s ?? '') == null ? l.commonRequired : null,
          ),
          const SizedBox(height: AbsSpace.x4),
          PopSingleChips<String>(
            options: const ['pt', 'locker', 'diet', 'other'],
            allowEmpty: false,
            hue: PopHue.bubblegum,
            labelOf: widget.kindLabel,
            value: _kind,
            onChanged: (k) => setState(() => _kind = k ?? 'other'),
          ),
          const SizedBox(height: AbsSpace.x5),
          AbsButton(label: l.commonSave, hue: PopHue.bubblegum, isLoading: _busy, onPressed: _save),
          if (widget.addon != null)
            AbsButton.ghost(
              label: widget.addon!.isArchived ? l.planUnarchive : l.planArchive,
              hue: PopHue.coral,
              onPressed: () => _save(archive: !widget.addon!.isArchived),
            ),
          const SizedBox(height: AbsSpace.x6),
        ],
      ),
    );
  }
}
