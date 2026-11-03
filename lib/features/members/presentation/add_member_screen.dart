import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
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
import '../../../core/utils/money.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/widgets.dart';
import '../application/members_providers.dart';
import '../data/members_repository.dart';
import '../domain/models.dart';
import 'member_form.dart';
import 'member_ui.dart';

/// Add member: Basics → Health → Membership (shared-axis steps, progress bar,
/// on-device draft so nothing is lost if the app closes).
class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  static const draftKey = 'add_member_draft';

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _data = MemberFormData();
  final _forms = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  int _step = 0;
  bool _forward = true;
  bool _busy = false;
  Timer? _saveDraft;

  @override
  void initState() {
    super.initState();
    final raw = ref.read(sharedPreferencesProvider).getString(AddMemberScreen.draftKey);
    if (raw != null) {
      try {
        _data.restoreDraft(jsonDecode(raw) as Map<String, dynamic>);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final l = context.l10n;
          showAbsSnackbar(context, l.draftRestored, onUndo: _discardDraft);
        });
      } catch (_) {
        // A corrupt draft is simply ignored.
      }
    }
    _data.addListener(_scheduleDraft);
  }

  void _scheduleDraft() {
    _saveDraft?.cancel();
    _saveDraft = Timer(const Duration(milliseconds: 600), () {
      ref.read(sharedPreferencesProvider).setString(AddMemberScreen.draftKey, jsonEncode(_data.toDraft()));
    });
  }

  void _discardDraft() {
    ref.read(sharedPreferencesProvider).remove(AddMemberScreen.draftKey);
    _data.removeListener(_scheduleDraft);
    setState(() {
      _data.restoreDraft(const {});
      _step = 0;
    });
    _data.addListener(_scheduleDraft);
  }

  @override
  void dispose() {
    _saveDraft?.cancel();
    _data.dispose();
    super.dispose();
  }

  void _go(int step) => setState(() {
    _forward = step > _step;
    _step = step;
  });

  Future<void> _next() async {
    final l = context.l10n;
    if (_busy || !(_forms[_step].currentState?.validate() ?? true)) return;
    FocusScope.of(context).unfocus();

    if (_step == 0) {
      // Duplicate check (1.18): same phone blocks; same name warns.
      setState(() => _busy = true);
      try {
        final phone = Phone.normalize(_data.phone.text)!;
        final dups = await ref
            .read(membersRepositoryProvider)
            .findDuplicates(phone: phone, name: _data.name.text.trim());
        if (!mounted) return;
        if (dups.any((m) => m.phone == phone)) {
          showAbsSnackbar(context, l.memberDuplicatePhone, tone: SnackTone.error);
          return;
        }
        if (dups.isNotEmpty) {
          final go = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l.duplicateWarning(dups.first.name, dups.first.memberCode)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.back)),
                TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.commonContinue)),
              ],
            ),
          );
          if (go != true) return;
        }
      } catch (_) {
        // Offline duplicate check is best-effort; the database enforces phone uniqueness.
      } finally {
        if (mounted) setState(() => _busy = false);
      }
      _go(1);
    } else if (_step == 1) {
      if (_data.hasHealth && !_data.consentHealth) {
        showAbsSnackbar(context, l.consentRequired, tone: SnackTone.error);
        return;
      }
      _go(2);
    } else {
      await _save();
    }
  }

  Future<void> _save() async {
    final l = context.l10n;
    final discount = Money.parse(_data.discount.text) ?? 0;
    if (discount > 0 && _data.discountReason.text.trim().isEmpty) {
      showAbsSnackbar(context, l.discountNeedsReason, tone: SnackTone.error);
      return;
    }
    setState(() => _busy = true);
    try {
      final repo = ref.read(membersRepositoryProvider);
      final id = await repo.add(
        NewMember(
          member: {
            ..._data.memberJson(),
            'consent_health': _data.consentHealth,
            'consent_whatsapp': _data.consentWhatsapp,
          },
          health: _data.consentHealth ? _data.healthJson() : null,
          planId: _data.planId,
          startDate: _data.startDate,
          discountPaise: discount,
          discountReason: _data.discountReason.text.trim().isEmpty ? null : _data.discountReason.text.trim(),
          addonIds: _data.addonIds.toList(),
        ),
      );
      if (_data.photo != null) {
        try {
          await repo.uploadPhoto(id, _data.photo!);
        } catch (_) {
          // The member is saved; the photo can be added again from Edit.
        }
      }
      _saveDraft?.cancel();
      await ref.read(sharedPreferencesProvider).remove(AddMemberScreen.draftKey);
      ref
        ..invalidate(memberListProvider)
        ..invalidate(dashboardProvider);
      if (!mounted) return;
      showAbsSnackbar(context, l.memberSaved(_data.name.text.trim()), tone: SnackTone.success);
      // With a plan, an invoice was raised: land on the member with Collect open.
      context.pushReplacement('${Routes.memberDetail(id)}${_data.planId == null ? '' : '?collect=1'}');
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final hues = [PopHue.sky, PopHue.mint, PopHue.tangerine];
    final titles = [l.stepBasics, l.stepHealth, l.stepMembership];
    final steps = [MemberBasicsFields(data: _data), MemberHealthFields(data: _data), _MembershipStep(data: _data)];

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _go(_step - 1);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.addMemberTitle),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Padding(
              padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(titles[_step], style: context.text.heading),
                      const Spacer(),
                      Text(l.stepOf(_step + 1), style: context.text.label.copyWith(color: c.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: AbsSpace.x1),
                  ClipRRect(
                    borderRadius: AbsRadius.pill,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: (_step + 1) / 3),
                      duration: AbsMotion.standard.duration,
                      curve: AbsMotion.standard.curve,
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        color: c.pop(hues[_step]).fill,
                        backgroundColor: c.border,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: PageTransitionSwitcher(
          duration: AbsMotion.standard.duration,
          reverse: !_forward,
          transitionBuilder: (child, primary, secondary) => SharedAxisTransition(
            animation: primary,
            secondaryAnimation: secondary,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          ),
          child: Form(
            key: _forms[_step],
            child: ListView(
              key: ValueKey(_step),
              padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x14 * 2),
              children: [steps[_step]],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x2),
            child: Row(
              children: [
                if (_step > 0) ...[
                  Expanded(
                    child: AbsButton.secondary(label: l.back, onPressed: _busy ? null : () => _go(_step - 1)),
                  ),
                  const SizedBox(width: AbsSpace.x3),
                ],
                Expanded(
                  flex: 2,
                  child: AbsButton(
                    label: _step == 2 ? l.saveMember : l.commonContinue,
                    hue: hues[_step],
                    icon: _step == 2
                        ? PhosphorIcons.check(PhosphorIconsStyle.bold)
                        : PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                    isLoading: _busy,
                    onPressed: _next,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Step 3 — plan, start date, add-ons, discount and a live price summary (1.6).
class _MembershipStep extends ConsumerWidget {
  const _MembershipStep({required this.data});

  final MemberFormData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final plans = ref.watch(plansProvider);
    final addons = ref.watch(addonsProvider).value ?? const <Addon>[];
    return ListenableBuilder(
      listenable: data,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.planSelect, style: t.heading),
          const SizedBox(height: AbsSpace.x3),
          AsyncView<List<Plan>>(
            value: plans,
            onRetry: () => ref.invalidate(plansProvider),
            loading: const SizedBox(height: 120, child: SkeletonList(itemCount: 2)),
            empty: EmptyState(
              title: l.plansEmptyTitle,
              message: l.plansEmptyBody,
              illustration: EmptyIllustration.dumbbell,
            ),
            data: (list) => Column(
              children: [
                for (final p in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                    child: PlanChoiceCard(
                      plan: p,
                      selected: data.planId == p.id,
                      onTap: () => data.set(() => data.planId = data.planId == p.id ? null : p.id),
                    ),
                  ),
                PopChip(
                  label: l.planNone,
                  hue: PopHue.grape,
                  selected: data.planId == null,
                  onTap: () => data.set(() => data.planId = null),
                ),
              ],
            ),
          ),
          if (data.planId != null) ...[
            const SizedBox(height: AbsSpace.x5),
            DateField(
              label: l.startDate,
              value: data.startDate ?? IstDates.today(),
              allowClear: false,
              first: IstDates.today().subtract(const Duration(days: 60)),
              onChanged: (d) => data.set(() => data.startDate = d),
            ),
            if (addons.isNotEmpty) ...[
              const SizedBox(height: AbsSpace.x5),
              Text(l.addonsTitle, style: t.heading),
              const SizedBox(height: AbsSpace.x2),
              PopChoiceChips<String>(
                options: [for (final a in addons) a.id],
                hue: PopHue.bubblegum,
                labelOf: (id) {
                  final a = addons.firstWhere((a) => a.id == id);
                  return '${a.name} · ${Money.format(a.pricePaise)}';
                },
                selected: data.addonIds,
                onChanged: (s) => data.set(() => data.addonIds = s),
              ),
            ],
            const SizedBox(height: AbsSpace.x5),
            Row(
              children: [
                Expanded(
                  child: AbsTextField(
                    label: l.discount,
                    controller: data.discount,
                    prefixText: '₹',
                    numeric: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (s) =>
                        (s == null || s.trim().isEmpty || Money.parse(s) != null) ? null : l.commonRequired,
                  ),
                ),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: AbsTextField(label: l.discountReason, controller: data.discountReason),
                ),
              ],
            ),
            const SizedBox(height: AbsSpace.x5),
            Builder(
              builder: (context) {
                final plan = plans.value?.where((p) => p.id == data.planId).firstOrNull;
                if (plan == null) return const SizedBox.shrink();
                final addonTotal = addons
                    .where((a) => data.addonIds.contains(a.id))
                    .fold(0, (s, a) => s + a.pricePaise);
                final discount = Money.parse(data.discount.text) ?? 0;
                final total = plan.pricePaise + plan.joiningFeePaise + addonTotal - discount;
                final start = data.startDate ?? IstDates.today();
                Widget row(String k, int paise, {bool bold = false}) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(child: Text(k, style: bold ? t.heading : t.body)),
                      Text(
                        paise < 0 ? '− ${Money.format(-paise)}' : Money.format(paise),
                        style: t.numericOf(bold ? t.title : t.body),
                      ),
                    ],
                  ),
                );
                return AbsCard(
                  hue: PopHue.tangerine,
                  child: Column(
                    children: [
                      row(l.summaryPlan, plan.pricePaise),
                      if (plan.joiningFeePaise > 0) row(l.summaryJoiningFee, plan.joiningFeePaise),
                      if (addonTotal > 0) row(l.summaryAddons, addonTotal),
                      if (discount > 0) row(l.summaryDiscount, -discount),
                      const Divider(),
                      row(l.summaryTotal, total < 0 ? 0 : total, bold: true),
                      const SizedBox(height: AbsSpace.x2),
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                            size: AbsSize.iconSmall,
                            color: c.textSecondary,
                          ),
                          const SizedBox(width: AbsSpace.x2),
                          Text(
                            l.endsOn(dateLabel(plan.endFor(start))),
                            style: t.label.copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                      if (total < 0) Text(l.discountTooBig, style: t.caption.copyWith(color: c.danger)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AbsSpace.x3),
            Text(l.paymentNote, style: t.caption.copyWith(color: c.textSecondary)),
          ],
        ],
      ),
    );
  }
}

/// Selectable plan card with colour, price and duration.
class PlanChoiceCard extends StatelessWidget {
  const PlanChoiceCard({super.key, required this.plan, required this.selected, required this.onTap});

  final Plan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final hue = PopHue.values.firstWhere((h) => h.name == plan.color, orElse: () => PopHue.lime);
    return AbsCard(
      hue: hue,
      solid: selected,
      onTap: onTap,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Row(
        children: [
          Icon(
            selected
                ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                : PhosphorIcons.circle(PhosphorIconsStyle.bold),
            color: selected ? context.colors.pop(hue).onFill : context.colors.textSecondary,
          ),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: t.heading.copyWith(color: selected ? context.colors.pop(hue).onFill : null)),
                Text(
                  plan.durationUnit == 'months'
                      ? l.planDurationMonths(plan.durationValue)
                      : l.planDurationDays(plan.durationValue),
                  style: t.caption.copyWith(
                    color: selected ? context.colors.pop(hue).onFill : context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Money.format(plan.pricePaise),
            style: t.numericOf(t.title).copyWith(color: selected ? context.colors.pop(hue).onFill : null),
          ),
        ],
      ),
    );
  }
}
