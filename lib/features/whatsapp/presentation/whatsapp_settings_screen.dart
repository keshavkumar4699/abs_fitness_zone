import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../application/whatsapp_providers.dart';
import '../data/whatsapp_repository.dart';
import '../domain/whatsapp_models.dart';

String reminderDayLabel(AppLocalizations l, int days) => switch (days) {
  0 => l.waOnTheDay,
  > 0 => l.waDaysBefore(days),
  _ => l.waDaysAfter(-days),
};

String automationLabel(AppLocalizations l, String key) => switch (key) {
  'expiry' => l.waAutoExpiry,
  'dues' => l.waAutoDues,
  'birthday' => l.waAutoBirthday,
  'festival' => l.waAutoFestival,
  'payment' => l.waAutoPayment,
  'membership' => l.waAutoMembership,
  _ => l.waAutoPlan,
};

/// Rupees per message, from Meta's price per 100 messages in paise.
String _perMessage(int per100Paise) => (per100Paise / 10000).toStringAsFixed(3);
int? _per100(String rupees) {
  final v = double.tryParse(rupees.trim());
  return v == null || v < 0 ? null : (v * 10000).round();
}

/// Owner-only WhatsApp settings: mode, reminder days, automations, and the
/// API cost meter with its marketing cap (8.2, 8.10, 8.14).
class WhatsAppSettingsScreen extends ConsumerWidget {
  const WhatsAppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(whatsAppSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.waSettingsTitle)),
      body: AsyncView<WhatsAppSettings>(
        value: settings,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(whatsAppSettingsProvider),
        loading: const SkeletonList(itemCount: 5),
        data: (s) => _SettingsForm(initial: s),
      ),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.initial});

  final WhatsAppSettings initial;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  final _form = GlobalKey<FormState>();
  late WhatsAppSettings _s = widget.initial;
  late final _cap = TextEditingController(text: Money.inputOf(widget.initial.marketingCapPaise));
  late final _utility = TextEditingController(text: _perMessage(widget.initial.utilityPer100Paise));
  late final _marketing = TextEditingController(text: _perMessage(widget.initial.marketingPer100Paise));
  bool _saving = false;

  @override
  void dispose() {
    _cap.dispose();
    _utility.dispose();
    _marketing.dispose();
    super.dispose();
  }

  Future<void> _addDay() async {
    final l = context.l10n;
    final v = await promptText(context, title: l.waAddDay, label: l.waDayPrompt, keyboardType: TextInputType.text);
    final n = int.tryParse(v?.trim() ?? '');
    if (n == null || n.abs() > 60 || _s.expiryDays.contains(n)) return;
    setState(() => _s = _s.copyWith(expiryDays: [..._s.expiryDays, n]..sort((a, b) => b.compareTo(a))));
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return;
    final next = _s.copyWith(
      marketingCapPaise: Money.parse(_cap.text) ?? 0,
      utilityPer100Paise: _per100(_utility.text),
      marketingPer100Paise: _per100(_marketing.text),
    );
    setState(() => _saving = true);
    try {
      await ref.read(whatsAppRepositoryProvider).saveSettings(next);
      ref
        ..invalidate(whatsAppSettingsProvider)
        ..invalidate(whatsAppCostProvider)
        ..refreshWhatsApp();
      if (mounted) showAbsSnackbar(context, l.waSaved, tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final api = _s.mode == WhatsAppMode.api;
    const gap = SizedBox(height: AbsSpace.x5);
    return Form(
      key: _form,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
        ),
        children: [
          Text(l.waModeTitle, style: t.title),
          const SizedBox(height: AbsSpace.x3),
          SegmentedTabs(
            key: const ValueKey('wa-mode-tabs'),
            labels: [l.waModeFree, l.waModeApi],
            selected: api ? 1 : 0,
            hue: PopHue.mint,
            onChanged: (i) => setState(() => _s = _s.copyWith(mode: i == 1 ? WhatsAppMode.api : WhatsAppMode.link)),
          ),
          const SizedBox(height: AbsSpace.x3),
          Text(api ? l.waModeApiHelp : l.waModeFreeHelp, style: t.body.copyWith(color: c.textSecondary)),
          gap,
          Text(l.waExpiryDays, style: t.title),
          const SizedBox(height: AbsSpace.x3),
          Wrap(
            spacing: AbsSpace.x2,
            runSpacing: AbsSpace.x2,
            children: [
              for (final d in _s.expiryDays)
                InputChip(
                  key: ValueKey('wa-day-$d'),
                  label: Text(reminderDayLabel(l, d)),
                  onDeleted: _s.expiryDays.length <= 1
                      ? null
                      : () => setState(() => _s = _s.copyWith(expiryDays: [..._s.expiryDays]..remove(d))),
                ),
              PopChip(
                key: const ValueKey('wa-add-day'),
                label: l.waAddDay,
                icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                selected: false,
                hue: PopHue.mint,
                onTap: _addDay,
              ),
            ],
          ),
          gap,
          Text(l.waAutomations, style: t.title),
          for (final k in kAutomations)
            SwitchListTile(
              key: ValueKey('wa-auto-$k'),
              contentPadding: EdgeInsets.zero,
              title: Text(automationLabel(l, k), style: t.body),
              value: _s.automation(k),
              onChanged: (v) => setState(() => _s = _s.copyWith(automations: {..._s.automations, k: v})),
            ),
          gap,
          const _CostMeter(),
          const SizedBox(height: AbsSpace.x4),
          AbsTextField(
            key: const ValueKey('wa-cap'),
            label: l.waCap,
            controller: _cap,
            prefixText: '₹',
            numeric: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
            helperText: l.waCapHelp,
            validator: (v) => Money.parse(v ?? '') == null && (v ?? '').trim().isNotEmpty ? l.waBadAmount : null,
          ),
          const SizedBox(height: AbsSpace.x4),
          Text(l.waPrices, style: t.heading),
          const SizedBox(height: AbsSpace.x2),
          Row(
            children: [
              Expanded(
                child: AbsTextField(
                  label: l.waPriceUtility,
                  controller: _utility,
                  numeric: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => _per100(v ?? '') == null ? l.waBadAmount : null,
                ),
              ),
              const SizedBox(width: AbsSpace.x3),
              Expanded(
                child: AbsTextField(
                  label: l.waPriceMarketing,
                  controller: _marketing,
                  numeric: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => _per100(v ?? '') == null ? l.waBadAmount : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AbsSpace.x2),
          Text(l.waPricesHelp, style: t.caption.copyWith(color: c.textSecondary)),
          gap,
          AbsButton(
            key: const ValueKey('wa-settings-save'),
            label: l.commonSave,
            hue: PopHue.mint,
            isLoading: _saving,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

/// This month's API messages and estimated spend (8.14).
class _CostMeter extends ConsumerWidget {
  const _CostMeter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final cost = ref.watch(whatsAppCostProvider);

    Widget line(String label, int count, int? paise) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
      child: Row(
        children: [
          Expanded(child: Text(label, style: t.body)),
          Text(l.waCostMessages(count), style: t.caption.copyWith(color: c.textSecondary)),
          if (paise != null) ...[
            const SizedBox(width: AbsSpace.x3),
            SizedBox(
              width: 72,
              child: Text(Money.format(paise), style: t.numericOf(t.body), textAlign: TextAlign.end),
            ),
          ],
        ],
      ),
    );

    return AsyncView<WhatsAppCost>(
      value: cost,
      isEmpty: (_) => false,
      empty: const SizedBox.shrink(),
      onRetry: () => ref.invalidate(whatsAppCostProvider),
      loading: const SkeletonBlock(child: SizedBox(height: 180, width: double.infinity)),
      data: (m) => AbsCard(
        key: const ValueKey('wa-cost'),
        hue: m.marketingPaused ? PopHue.coral : null,
        title: l.waCostTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            line(l.waCostUtility, m.utilitySent, m.utilityPaise),
            line(l.waCostMarketing, m.marketingSent, m.marketingPaise),
            line(l.waCostFree, m.freeWindowSent, 0),
            line(l.waCostLink, m.linkSent, 0),
            const Divider(),
            Row(
              children: [
                Expanded(child: Text(l.waCostTotal, style: t.heading)),
                Text(Money.format(m.totalPaise), style: t.numericOf(t.title)),
              ],
            ),
            if (m.capPaise > 0) ...[
              const SizedBox(height: AbsSpace.x3),
              ClipRRect(
                borderRadius: AbsRadius.pill,
                child: LinearProgressIndicator(
                  value: (m.marketingPaise / m.capPaise).clamp(0, 1).toDouble(),
                  minHeight: AbsSpace.x2,
                  color: c.pop(m.marketingPaused ? PopHue.coral : PopHue.mint).fill,
                  backgroundColor: c.pop(PopHue.mint).soft,
                ),
              ),
              const SizedBox(height: AbsSpace.x2),
              Text(
                m.marketingPaused
                    ? l.waCapPaused
                    : l.waCapUsed(Money.format(m.marketingPaise), Money.format(m.capPaise)),
                style: t.caption.copyWith(color: m.marketingPaused ? c.pop(PopHue.coral).text : c.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
