import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../application/members_providers.dart';
import '../data/members_repository.dart';
import '../domain/models.dart';
import 'add_member_screen.dart' show PlanChoiceCard;
import 'member_form.dart';
import 'member_ui.dart';

/// Shared layout for the small action sheets: title, body, one main button.
class _ActionSheet extends StatelessWidget {
  const _ActionSheet({required this.controller, required this.title, required this.children, required this.action});

  final ScrollController controller;
  final String title;
  final List<Widget> children;
  final Widget action;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: ListView(
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
          children: [
            Text(title, style: context.text.title),
            const SizedBox(height: AbsSpace.x4),
            ...children,
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
        child: action,
      ),
    ],
  );
}

/// Runs [action], shows success or the explained failure, and closes.
Future<void> _run(BuildContext context, WidgetRef ref, String memberId, Future<String> Function() action) async {
  try {
    final message = await action();
    ref.refreshMember(memberId);
    if (!context.mounted) return;
    showAbsSnackbar(context, message, tone: SnackTone.success);
    Navigator.pop(context, true);
  } catch (e) {
    if (context.mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
  }
}

// ---------------------------------------------------------------------------
// Start / renew
// ---------------------------------------------------------------------------

Future<bool?> showPlanSheet(BuildContext context, {required Member member, required bool renew}) =>
    showAbsBottomSheet<bool>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _PlanSheet(member: member, renew: renew, controller: controller),
    );

class _PlanSheet extends ConsumerStatefulWidget {
  const _PlanSheet({required this.member, required this.renew, required this.controller});

  final Member member;
  final bool renew;
  final ScrollController controller;

  @override
  ConsumerState<_PlanSheet> createState() => _PlanSheetState();
}

class _PlanSheetState extends ConsumerState<_PlanSheet> {
  String? _planId;
  DateTime _start = IstDates.today();
  final _discount = TextEditingController();
  final _reason = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _discount.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final discount = Money.parse(_discount.text) ?? 0;
    if (discount > 0 && _reason.text.trim().isEmpty) {
      showAbsSnackbar(context, l.discountNeedsReason, tone: SnackTone.error);
      return;
    }
    if (!widget.renew && _planId == null) {
      showAbsSnackbar(context, l.planSelect, tone: SnackTone.error);
      return;
    }
    setState(() => _busy = true);
    final repo = ref.read(membersRepositoryProvider);
    final reason = _reason.text.trim().isEmpty ? null : _reason.text.trim();
    await _run(context, ref, widget.member.id, () async {
      if (widget.renew) {
        await repo.renew(memberId: widget.member.id, planId: _planId, discountPaise: discount, discountReason: reason);
        final list = await repo.memberships(widget.member.id);
        final latest = list.where((m) => m.cancelledReason == null).first;
        return l.renewDone(dateLabel(latest.endDate));
      }
      await repo.startMembership(
        memberId: widget.member.id,
        planId: _planId!,
        start: _start,
        discountPaise: discount,
        discountReason: reason,
      );
      return l.saved;
    });
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final plans = ref.watch(plansProvider).value ?? const <Plan>[];
    return _ActionSheet(
      controller: widget.controller,
      title: widget.renew ? l.renewTitle : l.membershipStart,
      action: AbsButton(
        label: widget.renew ? l.actionRenew : l.membershipStart,
        hue: PopHue.lime,
        icon: PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold),
        isLoading: _busy,
        onPressed: _submit,
      ),
      children: [
        if (widget.renew)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x3),
            child: PopChip(
              label: '${l.renewSamePlan}${widget.member.planName == null ? '' : ' · ${widget.member.planName}'}',
              hue: PopHue.lime,
              selected: _planId == null,
              onTap: () => setState(() => _planId = null),
            ),
          ),
        for (final p in plans)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x3),
            child: PlanChoiceCard(plan: p, selected: _planId == p.id, onTap: () => setState(() => _planId = p.id)),
          ),
        if (!widget.renew) ...[
          const SizedBox(height: AbsSpace.x2),
          DateField(
            label: l.startDate,
            value: _start,
            allowClear: false,
            first: IstDates.today().subtract(const Duration(days: 60)),
            onChanged: (d) => setState(() => _start = d ?? IstDates.today()),
          ),
        ],
        const SizedBox(height: AbsSpace.x4),
        Row(
          children: [
            Expanded(
              child: AbsTextField(
                label: l.discount,
                controller: _discount,
                prefixText: '₹',
                numeric: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: AbsTextField(label: l.discountReason, controller: _reason),
            ),
          ],
        ),
        const SizedBox(height: AbsSpace.x3),
        Text(l.paymentNote, style: context.text.caption.copyWith(color: context.colors.textSecondary)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Freeze
// ---------------------------------------------------------------------------

Future<bool?> showFreezeSheet(BuildContext context, {required Membership membership, required int allowedDays}) =>
    showAbsBottomSheet<bool>(
      context: context,
      builder: (context, controller) =>
          _FreezeSheet(membership: membership, allowed: allowedDays, controller: controller),
    );

class _FreezeSheet extends ConsumerStatefulWidget {
  const _FreezeSheet({required this.membership, required this.allowed, required this.controller});

  final Membership membership;
  final int allowed;
  final ScrollController controller;

  @override
  ConsumerState<_FreezeSheet> createState() => _FreezeSheetState();
}

class _FreezeSheetState extends ConsumerState<_FreezeSheet> {
  late int _days = widget.allowed - widget.membership.freezeDaysUsed >= 7 ? 7 : 1;
  DateTime _from = IstDates.today();
  final _reason = TextEditingController();
  bool _busy = false;

  int get _left => (widget.allowed - widget.membership.freezeDaysUsed).clamp(0, 365);

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    return _ActionSheet(
      controller: widget.controller,
      title: l.freezeTitle,
      action: AbsButton(
        label: l.freeze,
        hue: PopHue.sky,
        icon: PhosphorIcons.snowflake(PhosphorIconsStyle.bold),
        isLoading: _busy,
        onPressed: _left == 0
            ? null
            : () async {
                setState(() => _busy = true);
                await _run(context, ref, widget.membership.memberId, () async {
                  await ref
                      .read(membersRepositoryProvider)
                      .freeze(
                        membershipId: widget.membership.id,
                        from: _from,
                        days: _days,
                        reason: _reason.text.trim(),
                      );
                  return l.freezeDone(_days);
                });
                if (mounted) setState(() => _busy = false);
              },
      ),
      children: [
        PopSticker(label: l.freezeLeft(_left), hue: PopHue.sky),
        const SizedBox(height: AbsSpace.x4),
        if (_left > 0) ...[
          Text(l.freezeDays, style: t.label),
          Row(
            children: [
              IconButton(
                tooltip: '−',
                onPressed: _days > 1 ? () => setState(() => _days--) : null,
                icon: Icon(PhosphorIcons.minusCircle(PhosphorIconsStyle.bold)),
              ),
              Text('$_days', style: t.numericOf(t.displayL)),
              IconButton(
                tooltip: '+',
                onPressed: _days < _left ? () => setState(() => _days++) : null,
                icon: Icon(PhosphorIcons.plusCircle(PhosphorIconsStyle.bold)),
              ),
            ],
          ),
          const SizedBox(height: AbsSpace.x3),
          DateField(
            label: l.freezeFrom,
            value: _from,
            allowClear: false,
            first: IstDates.today(),
            last: widget.membership.endDate,
            onChanged: (d) => setState(() => _from = d ?? IstDates.today()),
          ),
          const SizedBox(height: AbsSpace.x3),
          AbsTextField(label: l.freezeReason, controller: _reason),
          const SizedBox(height: AbsSpace.x2),
          Text(
            l.endsOn(dateLabel(widget.membership.endDate?.add(Duration(days: _days)))),
            style: t.label.copyWith(color: context.colors.textSecondary),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cancel (owner)
// ---------------------------------------------------------------------------

Future<bool?> showCancelSheet(BuildContext context, {required Membership membership}) => showAbsBottomSheet<bool>(
  context: context,
  builder: (context, controller) => _CancelSheet(membership: membership, controller: controller),
);

class _CancelSheet extends ConsumerStatefulWidget {
  const _CancelSheet({required this.membership, required this.controller});

  final Membership membership;
  final ScrollController controller;

  @override
  ConsumerState<_CancelSheet> createState() => _CancelSheetState();
}

class _CancelSheetState extends ConsumerState<_CancelSheet> {
  final _reason = TextEditingController();
  final _refund = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _reason.dispose();
    _refund.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _ActionSheet(
      controller: widget.controller,
      title: l.cancelTitle,
      action: AbsButton.destructive(
        label: l.cancelMembership,
        icon: PhosphorIcons.prohibit(PhosphorIconsStyle.bold),
        isLoading: _busy,
        onPressed: () async {
          if (_reason.text.trim().isEmpty) {
            showAbsSnackbar(context, l.cancelReason, tone: SnackTone.error);
            return;
          }
          setState(() => _busy = true);
          await _run(context, ref, widget.membership.memberId, () async {
            await ref
                .read(membersRepositoryProvider)
                .cancel(
                  membershipId: widget.membership.id,
                  reason: _reason.text.trim(),
                  refundPaise: Money.parse(_refund.text) ?? 0,
                );
            return l.cancelDone;
          });
          if (mounted) setState(() => _busy = false);
        },
      ),
      children: [
        AbsTextField(label: l.cancelReason, controller: _reason, autofocus: true),
        const SizedBox(height: AbsSpace.x4),
        AbsTextField(
          label: l.refundAmount,
          controller: _refund,
          prefixText: '₹',
          numeric: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Transfer remaining days (owner)
// ---------------------------------------------------------------------------

Future<bool?> showTransferSheet(BuildContext context, {required Membership membership}) => showAbsBottomSheet<bool>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _TransferSheet(membership: membership, controller: controller),
);

class _TransferSheet extends ConsumerStatefulWidget {
  const _TransferSheet({required this.membership, required this.controller});

  final Membership membership;
  final ScrollController controller;

  @override
  ConsumerState<_TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends ConsumerState<_TransferSheet> {
  String _query = '';
  String? _to;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final results = _query.length < 2
        ? const AsyncData(<Member>[])
        : ref.watch(memberListProvider(MemberQuery(search: _query))).whenData((p) => p.items);
    return _ActionSheet(
      controller: widget.controller,
      title: l.transferTitle,
      action: AbsButton(
        label: l.transfer,
        hue: PopHue.grape,
        icon: PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.bold),
        isLoading: _busy,
        onPressed: _to == null
            ? null
            : () async {
                setState(() => _busy = true);
                await _run(context, ref, widget.membership.memberId, () async {
                  await ref
                      .read(membersRepositoryProvider)
                      .transfer(membershipId: widget.membership.id, toMemberId: _to!);
                  ref.refreshMember(_to!);
                  return l.transferDone;
                });
                if (mounted) setState(() => _busy = false);
              },
      ),
      children: [
        Text(l.transferPick, style: context.text.label),
        const SizedBox(height: AbsSpace.x2),
        AbsTextField(label: l.membersSearchHint, onChanged: (v) => setState(() => _query = v.trim())),
        const SizedBox(height: AbsSpace.x3),
        ...switch (results) {
          AsyncData(:final value) => [
            for (final m in value.where((m) => m.id != widget.membership.memberId))
              MemberTile(
                name: m.name,
                plan: m.memberCode,
                status: pillFor(m.status),
                selected: _to == m.id,
                onTap: () => setState(() => _to = m.id),
              ),
          ],
          _ => [const SizedBox(height: 120, child: SkeletonList(itemCount: 2))],
        },
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Measurements (owner / trainer)
// ---------------------------------------------------------------------------

Future<bool?> showMeasurementSheet(BuildContext context, {required String memberId}) => showAbsBottomSheet<bool>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _MeasurementSheet(memberId: memberId, controller: controller),
);

class _MeasurementSheet extends ConsumerStatefulWidget {
  const _MeasurementSheet({required this.memberId, required this.controller});

  final String memberId;
  final ScrollController controller;

  @override
  ConsumerState<_MeasurementSheet> createState() => _MeasurementSheetState();
}

class _MeasurementSheetState extends ConsumerState<_MeasurementSheet> {
  final _c = {
    for (final k in ['weight', 'fat', 'chest', 'waist', 'hips', 'arms', 'thighs']) k: TextEditingController(),
  };
  DateTime _on = IstDates.today();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  num? _n(String k) => num.tryParse(_c[k]!.text.trim());

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget field(String k, String label) => Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsTextField(
        label: label,
        controller: _c[k],
        numeric: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
    return _ActionSheet(
      controller: widget.controller,
      title: l.progressAdd,
      action: AbsButton(
        label: l.commonSave,
        hue: PopHue.mint,
        isLoading: _busy,
        onPressed: () async {
          if (_c.values.every((c) => c.text.trim().isEmpty)) return;
          setState(() => _busy = true);
          try {
            await ref
                .read(membersRepositoryProvider)
                .addMeasurement(
                  Measurement(
                    memberId: widget.memberId,
                    measuredOn: _on,
                    weightKg: _n('weight'),
                    bodyFat: _n('fat'),
                    chest: _n('chest'),
                    waist: _n('waist'),
                    hips: _n('hips'),
                    arms: _n('arms'),
                    thighs: _n('thighs'),
                  ),
                );
            ref.invalidate(memberMeasurementsProvider(widget.memberId));
            if (!context.mounted) return;
            showAbsSnackbar(context, l.measurementSaved, tone: SnackTone.success);
            Navigator.pop(context, true);
          } catch (e) {
            if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
          } finally {
            if (mounted) setState(() => _busy = false);
          }
        },
      ),
      children: [
        DateField(
          label: l.fieldMeasuredOn,
          value: _on,
          allowClear: false,
          last: IstDates.today(),
          onChanged: (d) => setState(() => _on = d ?? IstDates.today()),
        ),
        const SizedBox(height: AbsSpace.x3),
        field('weight', l.fieldWeight),
        field('fat', l.fieldBodyFat),
        field('chest', l.fieldChest),
        field('waist', l.fieldWaist),
        field('hips', l.fieldHips),
        field('arms', l.fieldArms),
        field('thighs', l.fieldThighs),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Health (owner / trainer)
// ---------------------------------------------------------------------------

Future<bool?> showHealthSheet(BuildContext context, {required String memberId, MemberHealth? current}) =>
    showAbsBottomSheet<bool>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _HealthSheet(memberId: memberId, current: current, controller: controller),
    );

class _HealthSheet extends ConsumerStatefulWidget {
  const _HealthSheet({required this.memberId, required this.current, required this.controller});

  final String memberId;
  final MemberHealth? current;
  final ScrollController controller;

  @override
  ConsumerState<_HealthSheet> createState() => _HealthSheetState();
}

class _HealthSheetState extends ConsumerState<_HealthSheet> {
  late final MemberFormData _data = () {
    final d = MemberFormData();
    final h = widget.current;
    if (h != null) {
      d.height.text = h.heightCm?.toString() ?? '';
      d.weight.text = h.weightKg?.toString() ?? '';
      d.conditions.text = h.conditions ?? '';
      d.injuries.text = h.injuries ?? '';
      d.medications.text = h.medications ?? '';
      d.parq = {for (final e in h.parq.entries) e.key: e.value == true};
      d.doctorClearance = h.doctorClearance;
    }
    return d;
  }();
  bool _busy = false;

  @override
  void dispose() {
    _data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _ActionSheet(
      controller: widget.controller,
      title: l.healthTitle,
      action: AbsButton(
        label: l.commonSave,
        hue: PopHue.mint,
        isLoading: _busy,
        onPressed: () async {
          setState(() => _busy = true);
          try {
            final j = _data.healthJson() ?? const <String, dynamic>{};
            await ref
                .read(membersRepositoryProvider)
                .saveHealth(
                  MemberHealth(
                    memberId: widget.memberId,
                    heightCm: j['height_cm'] as num?,
                    weightKg: j['weight_kg'] as num?,
                    conditions: j['conditions'] as String?,
                    injuries: j['injuries'] as String?,
                    medications: j['medications'] as String?,
                    parq: (j['parq'] as Map<String, bool>?) ?? const {},
                    doctorClearance: j['doctor_clearance'] == true,
                  ),
                );
            ref.invalidate(memberHealthProvider(widget.memberId));
            if (!context.mounted) return;
            showAbsSnackbar(context, l.saved, tone: SnackTone.success);
            Navigator.pop(context, true);
          } catch (e) {
            if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
          } finally {
            if (mounted) setState(() => _busy = false);
          }
        },
      ),
      children: [MemberHealthFields(data: _data, showConsent: false)],
    );
  }
}
