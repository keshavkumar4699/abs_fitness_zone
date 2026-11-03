import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/payments_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'payment_ui.dart';

/// Day close (2.13): today's own totals by mode, the counted cash and the
/// difference, then lock. The owner sees recent closes and can reopen one.
class DayCloseScreen extends ConsumerStatefulWidget {
  const DayCloseScreen({super.key});

  @override
  ConsumerState<DayCloseScreen> createState() => _DayCloseScreenState();
}

class _DayCloseScreenState extends ConsumerState<DayCloseScreen> {
  final _counted = TextEditingController();
  final _note = TextEditingController();
  bool _busy = false;
  bool _done = false;

  @override
  void dispose() {
    _counted.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    final l = context.l10n;
    final counted = Money.parse(_counted.text);
    if (counted == null) {
      showAbsSnackbar(context, l.dayCloseCounted, tone: SnackTone.error);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(paymentsRepositoryProvider).closeDay(countedCashPaise: counted, note: _note.text.trim());
      ref.refreshPayments();
      if (!mounted) return;
      setState(() => _done = true);
      showAbsSnackbar(context, l.dayCloseDone, tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final day = ref.watch(myDayProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.dayCloseTitle)),
      body: AsyncView<DaySummary>(
        value: day,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(myDayProvider),
        loading: const SkeletonList(itemCount: 4),
        data: (d) => Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(
                context.screenPadding,
                AbsSpace.x2,
                context.screenPadding,
                MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
              ),
              children: [
                if (d.closed) _ClosedBanner(summary: d) else Text(l.dayCloseBody, style: context.text.body),
                const SizedBox(height: AbsSpace.x4),
                _Totals(summary: d),
                if (!d.closed) ...[
                  const SizedBox(height: AbsSpace.x4),
                  _CountedCash(controller: _counted, expected: d.cash),
                  const SizedBox(height: AbsSpace.x3),
                  AbsTextField(label: l.dayCloseNote, controller: _note),
                  const SizedBox(height: AbsSpace.x5),
                  AbsButton(
                    key: const ValueKey('day-close-confirm'),
                    label: l.dayCloseConfirm,
                    hue: PopHue.grape,
                    icon: PhosphorIcons.lockKey(PhosphorIconsStyle.bold),
                    isLoading: _busy,
                    isSuccess: _done,
                    onPressed: _close,
                  ),
                ],
                if (owner) ...[const SizedBox(height: AbsSpace.x6), const _RecentCloses()],
              ],
            ),
            if (_done) const Positioned.fill(child: ConfettiBurst()),
          ],
        ),
      ),
    );
  }
}

class _ClosedBanner extends StatelessWidget {
  const _ClosedBanner({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) => AbsCard(
    key: const ValueKey('day-closed-banner'),
    hue: PopHue.grape,
    solid: true,
    padding: const EdgeInsets.all(AbsSpace.x4),
    child: Row(
      children: [
        Icon(PhosphorIcons.lockKey(PhosphorIconsStyle.fill), color: context.colors.pop(PopHue.grape).onFill),
        const SizedBox(width: AbsSpace.x3),
        Expanded(
          child: Text(
            context.l10n.dayCloseLocked(summary.closedAt == null ? '' : IstDates.formatTime(summary.closedAt!)),
            style: context.text.body.copyWith(color: context.colors.pop(PopHue.grape).onFill),
          ),
        ),
      ],
    ),
  );
}

class _Totals extends StatelessWidget {
  const _Totals({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = summary;
    final modes = {
      PaymentMode.cash: d.cash,
      PaymentMode.upi: d.upi,
      PaymentMode.card: d.card,
      PaymentMode.bank: d.bank,
      PaymentMode.online: d.online,
    };
    return AbsCard(
      title: l.dayCloseByMode,
      hue: PopHue.tangerine,
      child: Column(
        children: [
          for (final e in modes.entries)
            if (e.value > 0 || e.key == PaymentMode.cash)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
                child: Row(
                  children: [
                    IconBubble(icon: modeIcon(e.key), hue: modeHue(e.key), size: 32),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(child: Text(modeName(l, e.key), style: context.text.body)),
                    Text(Money.format(e.value), style: context.text.numericOf(context.text.body)),
                  ],
                ),
              ),
          const Divider(),
          AmountRow(label: l.dayCloseTotal, paise: d.total, bold: true),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l.payPaymentsCount(d.count),
              style: context.text.caption.copyWith(color: context.colors.textSecondary),
            ),
          ),
          if (d.closed && d.countedCash != null) ...[
            const SizedBox(height: AbsSpace.x2),
            _Difference(difference: d.difference ?? 0),
          ],
        ],
      ),
    );
  }
}

class _CountedCash extends StatefulWidget {
  const _CountedCash({required this.controller, required this.expected});

  final TextEditingController controller;
  final int expected;

  @override
  State<_CountedCash> createState() => _CountedCashState();
}

class _CountedCashState extends State<_CountedCash> {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final counted = Money.parse(widget.controller.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AbsTextField(
          key: const ValueKey('counted-cash'),
          label: l.dayCloseCounted,
          controller: widget.controller,
          prefixText: '₹',
          numeric: true,
          helperText: l.dayCloseExpected(Money.format(widget.expected)),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        if (counted != null) ...[
          const SizedBox(height: AbsSpace.x2),
          _Difference(difference: counted - widget.expected),
        ],
      ],
    );
  }
}

class _Difference extends StatelessWidget {
  const _Difference({required this.difference});

  final int difference;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, hue) = switch (difference) {
      0 => (l.dayCloseExact, PopHue.mint),
      > 0 => (l.dayCloseOver(Money.format(difference)), PopHue.sky),
      _ => (l.dayCloseShort(Money.format(-difference)), PopHue.coral),
    };
    return PopSticker(key: const ValueKey('cash-difference'), label: label, hue: hue, dot: true, numeric: true);
  }
}

class _RecentCloses extends ConsumerWidget {
  const _RecentCloses();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(dayClosesProvider).value ?? const <DayClose>[];
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.dayCloseHistory, style: context.text.title),
        const SizedBox(height: AbsSpace.x2),
        for (final d in list)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x2),
            child: AbsCard(
              padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x3, AbsSpace.x2, AbsSpace.x3),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${d.staffName ?? ''} · ${dateLabel(d.day)}', style: context.text.heading),
                        Text(
                          l.dayCloseCountedLine(Money.format(d.countedCashPaise), Money.format(d.cashPaise)),
                          style: context.text
                              .numericOf(context.text.caption)
                              .copyWith(color: context.colors.textSecondary),
                        ),
                        const SizedBox(height: AbsSpace.x1),
                        if (d.isOpen)
                          PopSticker(label: l.dayCloseReopenedPill, hue: PopHue.sky)
                        else
                          _Difference(difference: d.differencePaise),
                      ],
                    ),
                  ),
                  Text(Money.format(d.totalPaise), style: context.text.numericOf(context.text.heading)),
                  if (!d.isOpen)
                    TextButton(
                      key: ValueKey('reopen-${d.id}'),
                      onPressed: () async {
                        try {
                          await ref.read(paymentsRepositoryProvider).reopenDay(d.id);
                          ref.refreshPayments();
                          if (context.mounted) showAbsSnackbar(context, l.dayCloseReopened, tone: SnackTone.success);
                        } catch (e) {
                          if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
                        }
                      },
                      child: Text(l.dayCloseReopen),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
