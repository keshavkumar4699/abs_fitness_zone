import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/data/members_repository.dart';
import '../../members/domain/models.dart';
import '../application/payments_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'amount_keypad.dart';
import 'payment_ui.dart';
import 'receipt_actions.dart';

/// Who is paying (enough to show and to send the receipt).
class CollectTarget {
  const CollectTarget({required this.memberId, required this.name, this.phone});

  factory CollectTarget.of(Member m) => CollectTarget(memberId: m.id, name: m.name, phone: m.phone);

  final String memberId;
  final String name;
  final String? phone;
}

/// Collect sheet (2.2): member → invoice → amount on the keypad → mode →
/// UTR for UPI/bank → confirm, then the receipt flips in with confetti.
Future<PaymentResult?> showCollectSheet(BuildContext context, {CollectTarget? member, Invoice? invoice}) =>
    showAbsBottomSheet<PaymentResult>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _CollectSheet(
        controller: controller,
        initialMember:
            member ??
            (invoice?.memberId == null
                ? null
                : CollectTarget(memberId: invoice!.memberId!, name: invoice.memberName, phone: invoice.memberPhone)),
        initialInvoice: invoice,
      ),
    );

class _CollectSheet extends ConsumerStatefulWidget {
  const _CollectSheet({required this.controller, this.initialMember, this.initialInvoice});

  final ScrollController controller;
  final CollectTarget? initialMember;
  final Invoice? initialInvoice;

  @override
  ConsumerState<_CollectSheet> createState() => _CollectSheetState();
}

class _CollectSheetState extends ConsumerState<_CollectSheet> {
  CollectTarget? _member;
  Invoice? _invoice;
  String _amount = '';
  PaymentMode _mode = PaymentMode.cash;
  final _utr = TextEditingController();
  final _search = TextEditingController();
  Timer? _debounce;
  List<Member>? _results;
  bool _busy = false;
  bool _success = false;
  String? _error;
  PaymentResult? _result;

  @override
  void initState() {
    super.initState();
    _member = widget.initialMember;
    if (widget.initialInvoice != null) _pickInvoice(widget.initialInvoice!);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _utr.dispose();
    _search.dispose();
    super.dispose();
  }

  void _pickInvoice(Invoice i) {
    _invoice = i;
    final due = i.nextInstalmentDuePaise();
    _amount = due > 0 ? Money.inputOf(due) : '';
    _error = null;
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final s = text.trim();
      if (s.isEmpty) {
        if (mounted) setState(() => _results = null);
        return;
      }
      try {
        final page = await ref.read(membersRepositoryProvider).list(offset: 0, query: MemberQuery(search: s));
        if (mounted && _search.text.trim() == s) setState(() => _results = page.items.take(8).toList());
      } catch (_) {
        if (mounted) setState(() => _results = const []);
      }
    });
  }

  int? get _paise => AmountKeypad.paiseOf(_amount);

  Future<void> _confirm() async {
    final l = context.l10n;
    final invoice = _invoice!;
    final amount = _paise;
    if (amount == null || amount <= 0) return setState(() => _error = l.collectEnterAmount);
    final utr = _utr.text.trim();
    if (_mode.needsReference && utr.length < 6) return setState(() => _error = l.collectUtrMissing);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(paymentsRepositoryProvider)
          .collect(invoiceId: invoice.id, amountPaise: amount, mode: _mode, utr: _mode.needsReference ? utr : null);
      unawaited(HapticFeedback.mediumImpact());
      ref.refreshPayments(memberId: _member?.memberId, invoiceId: invoice.id);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _success = true;
      });
      // Let the button morph to a tick, then flip in the receipt.
      await Future<void>.delayed(AbsMotion.standard.duration);
      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(l, e);
        });
      }
    }
  }

  Future<void> _useCredit(int credit) async {
    final l = context.l10n;
    final invoice = _invoice!;
    final amount = math.min(credit, invoice.balancePaise);
    setState(() => _busy = true);
    try {
      final result = await ref.read(paymentsRepositoryProvider).applyCredit(invoiceId: invoice.id, amountPaise: amount);
      ref.refreshPayments(memberId: _member?.memberId, invoiceId: invoice.id);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _result = result;
        _mode = PaymentMode.credit;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(l, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final Widget body;
    final Widget? action;
    if (_result != null) {
      body = _Success(result: _result!, member: _member!, invoice: _invoice!, mode: _mode);
      action = AbsButton(label: l.collectAnother, onPressed: () => Navigator.pop(context, _result));
    } else if (_member == null) {
      body = _searchStep(context);
      action = null;
    } else if (_invoice == null) {
      body = _InvoicePicker(
        member: _member!,
        onPick: (i) => setState(() => _pickInvoice(i)),
        onChange: () => setState(() => _member = null),
      );
      action = null;
    } else {
      body = _amountStep(context);
      final amount = _paise ?? 0;
      action = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x2),
              child: Text(
                _error!,
                key: const ValueKey('collect-error'),
                style: context.text.label.copyWith(color: context.colors.danger),
                textAlign: TextAlign.center,
              ),
            ),
          AbsButton(
            key: const ValueKey('collect-confirm'),
            label: amount > 0 ? l.collectConfirm(Money.format(amount)) : l.collectEnterAmount,
            hue: PopHue.tangerine,
            icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.bold),
            isLoading: _busy,
            isSuccess: _success,
            onPressed: amount > 0 && !_success ? _confirm : null,
          ),
        ],
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                controller: widget.controller,
                padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
                children: [
                  if (_result == null) ...[
                    Text(l.collectTitle, style: context.text.title),
                    const SizedBox(height: AbsSpace.x4),
                  ],
                  AnimatedSwitcher(
                    duration: AbsMotion.standard.duration,
                    switchInCurve: AbsMotion.standard.curve,
                    child: KeyedSubtree(
                      key: ValueKey('${_member?.memberId}-${_invoice?.id}-${_result != null}'),
                      child: body,
                    ),
                  ),
                ],
              ),
            ),
            if (action != null)
              Padding(
                padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
                child: action,
              ),
          ],
        ),
        if (_result != null) const Positioned.fill(child: ConfettiBurst()),
      ],
    );
  }

  Widget _searchStep(BuildContext context) {
    final l = context.l10n;
    final results = _results;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AbsTextField(
          key: const ValueKey('collect-search'),
          label: l.collectSearchHint,
          controller: _search,
          autofocus: true,
          onChanged: _onSearch,
          suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
        ),
        const SizedBox(height: AbsSpace.x4),
        if (results == null)
          _OpenInvoices(
            onPick: (i) => setState(() {
              _member = CollectTarget(memberId: i.memberId!, name: i.memberName, phone: i.memberPhone);
              _pickInvoice(i);
            }),
          )
        else if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AbsSpace.x6),
            child: Text(l.collectNoMembers, textAlign: TextAlign.center, style: context.text.body),
          )
        else
          for (final m in results)
            Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x2),
              child: AbsCard(
                onTap: () => setState(() => _member = CollectTarget.of(m)),
                padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
                child: Row(
                  children: [
                    AbsAvatar(name: m.name, size: 40),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name, style: context.text.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(
                            m.memberCode,
                            style: context.text
                                .numericOf(context.text.caption)
                                .copyWith(color: context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (m.duesPaise > 0) PopSticker(label: l.memberDues(Money.format(m.duesPaise)), hue: PopHue.coral),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _amountStep(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final invoice = _invoice!;
    final amount = _paise ?? 0;
    final balance = invoice.balancePaise;
    final next = invoice.nextInstalmentDuePaise();
    final credit = ref.watch(memberCreditProvider(_member!.memberId)).value ?? 0;
    final p = c.pop(PopHue.tangerine);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AbsAvatar(name: _member!.name, size: 40, hue: PopHue.tangerine),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_member!.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    '${invoice.invoiceNo} · ${l.payBalance(Money.format(balance))}',
                    style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            if (widget.initialInvoice == null)
              AbsButton.ghost(
                label: l.collectChangeMember,
                // Back to the member search (a single open invoice would
                // otherwise be picked again straight away).
                onPressed: () => setState(() {
                  _invoice = null;
                  _member = null;
                  _amount = '';
                  _error = null;
                }),
              ),
          ],
        ),
        const SizedBox(height: AbsSpace.x4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AbsSpace.x4, horizontal: AbsSpace.x4),
          decoration: stickerDecoration(c, color: p.soft, borderRadius: AbsRadius.cardAll),
          child: Column(
            children: [
              Text(l.collectAmount, style: t.label.copyWith(color: c.textSecondary)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '₹${_amount.isEmpty ? '0' : Money.groupInput(_amount)}',
                  key: const ValueKey('collect-amount'),
                  style: t.numericOf(t.displayXL).copyWith(color: c.textPrimary),
                ),
              ),
              AnimatedSwitcher(
                duration: AbsMotion.quick.duration,
                child: Text(
                  key: ValueKey(amount.compareTo(balance)),
                  amount > balance
                      ? l.collectExtraCredit(Money.format(amount - balance))
                      : amount > 0 && amount < balance
                      ? l.collectStillDue(Money.format(balance - amount))
                      : ' ',
                  style: t.label.copyWith(color: amount > balance ? c.pop(PopHue.mint).text : c.textSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AbsSpace.x3),
        Wrap(
          spacing: AbsSpace.x2,
          runSpacing: AbsSpace.x2,
          children: [
            PopChip(
              label: l.collectFull(Money.format(balance)),
              hue: PopHue.tangerine,
              selected: amount == balance,
              onTap: () => setState(() => _amount = Money.inputOf(balance)),
            ),
            if (invoice.instalments.isNotEmpty && next != balance)
              PopChip(
                label: l.collectInstalment(Money.format(next)),
                hue: PopHue.sky,
                selected: amount == next,
                onTap: () => setState(() => _amount = Money.inputOf(next)),
              ),
            if (credit > 0)
              PopChip(
                label: l.collectUseCredit(Money.format(math.min(credit, balance))),
                hue: PopHue.lime,
                icon: PhosphorIcons.piggyBank(PhosphorIconsStyle.bold),
                selected: false,
                onTap: _busy ? () {} : () => _useCredit(credit),
              ),
          ],
        ),
        const SizedBox(height: AbsSpace.x4),
        Text(l.collectMode, style: t.label.copyWith(color: c.textSecondary)),
        const SizedBox(height: AbsSpace.x2),
        PopSingleChips<PaymentMode>(
          options: PaymentMode.collectable,
          labelOf: (m) => modeName(l, m),
          value: _mode,
          allowEmpty: false,
          hue: PopHue.grape,
          onChanged: (m) => setState(() {
            _mode = m ?? PaymentMode.cash;
            _error = null;
          }),
        ),
        AnimatedSize(
          duration: AbsMotion.quick.duration,
          child: _mode.needsReference
              ? Padding(
                  padding: const EdgeInsets.only(top: AbsSpace.x3),
                  child: AbsTextField(
                    key: const ValueKey('collect-utr'),
                    label: l.collectUtr,
                    helperText: l.collectUtrHelp,
                    controller: _utr,
                    numeric: true,
                    maxLength: 30,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        const SizedBox(height: AbsSpace.x4),
        AmountKeypad(
          text: _amount,
          onChanged: (v) => setState(() {
            _amount = v;
            _error = null;
          }),
        ),
        const SizedBox(height: AbsSpace.x2),
      ],
    );
  }
}

/// With an empty search: overdue and due invoices to pick from directly.
class _OpenInvoices extends ConsumerWidget {
  const _OpenInvoices({required this.onPick});

  final ValueChanged<Invoice> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdue = ref.watch(invoiceListProvider(InvoiceTab.overdue, '')).value?.items ?? const [];
    final due = ref.watch(invoiceListProvider(InvoiceTab.due, '')).value?.items ?? const [];
    final list = [...overdue, ...due].where((i) => i.memberId != null).take(8).toList();
    return Column(
      children: [for (final i in list) InvoiceTile(invoice: i, onTap: () => onPick(i))],
    );
  }
}

class _InvoicePicker extends ConsumerWidget {
  const _InvoicePicker({required this.member, required this.onPick, required this.onChange});

  final CollectTarget member;
  final ValueChanged<Invoice> onPick;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final invoices = ref.watch(memberInvoicesProvider(member.memberId));
    return AsyncView<List<Invoice>>(
      value: invoices.whenData((list) => list.where((i) => i.status.isOpen).toList()),
      onRetry: () => ref.invalidate(memberInvoicesProvider(member.memberId)),
      loading: const SizedBox(height: 200, child: SkeletonList(itemCount: 2)),
      isEmpty: (list) => list.isEmpty,
      empty: EmptyState(
        title: l.collectNothingDueTitle,
        message: l.collectNothingDueBody(member.name.split(' ').first),
        illustration: EmptyIllustration.trophy,
        hue: PopHue.mint,
        actionLabel: l.collectChangeMember,
        onAction: onChange,
      ),
      data: (list) {
        // One open invoice: go straight to the amount.
        if (list.length == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onPick(list.first));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.collectPickInvoice, style: context.text.heading),
            const SizedBox(height: AbsSpace.x3),
            for (final i in list) InvoiceTile(invoice: i, showMember: false, onTap: () => onPick(i)),
          ],
        );
      },
    );
  }
}

/// Big tick that flips over into the receipt card.
class _Success extends ConsumerWidget {
  const _Success({required this.result, required this.member, required this.invoice, required this.mode});

  final PaymentResult result;
  final CollectTarget member;
  final Invoice invoice;
  final PaymentMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final mint = c.pop(PopHue.mint);
    final receipt = result.receiptNo ?? '';
    final card = Container(
      padding: const EdgeInsets.all(AbsSpace.x5),
      decoration: stickerDecoration(c, color: c.surfaceRaised, borderRadius: AbsRadius.cardAll),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBubble(icon: PhosphorIcons.receipt(PhosphorIconsStyle.bold), hue: PopHue.mint),
              const SizedBox(width: AbsSpace.x3),
              Expanded(child: Text(l.collectReceiptNo(receipt), style: t.numericOf(t.heading))),
            ],
          ),
          const SizedBox(height: AbsSpace.x4),
          Text(member.name, style: t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(invoice.invoiceNo, style: t.numericOf(t.caption).copyWith(color: c.textSecondary)),
          const Divider(height: AbsSpace.x6),
          AmountRow(label: modeName(l, mode), paise: result.amountPaise, bold: true),
          if (result.creditPaise > 0)
            Text(
              l.collectCreditSaved(Money.format(result.creditPaise)),
              style: t.label.copyWith(color: c.pop(PopHue.mint).text),
            ),
          AmountRow(label: l.invoiceBalance, paise: result.balancePaise),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AbsSpace.x4),
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: AbsMotion.reduced(context) ? 1 : 0, end: 1),
            duration: AbsMotion.bouncy.duration,
            curve: AbsMotion.bouncy.curve,
            builder: (context, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 84,
              height: 84,
              decoration: stickerDecoration(c, color: mint.fill, borderRadius: AbsRadius.pill),
              child: Icon(PhosphorIcons.check(PhosphorIconsStyle.bold), size: 44, color: mint.onFill),
            ),
          ),
        ),
        const SizedBox(height: AbsSpace.x3),
        Text(l.collectDone, style: t.displayL, textAlign: TextAlign.center),
        const SizedBox(height: AbsSpace.x5),
        // Receipt card flips in (rotateY 90° → 0°).
        TweenAnimationBuilder<double>(
          tween: Tween(begin: AbsMotion.reduced(context) ? 0 : math.pi / 2, end: 0),
          duration: AbsMotion.expressive.duration,
          curve: Curves.easeOutBack,
          builder: (context, angle, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: child,
          ),
          child: card,
        ),
        const SizedBox(height: AbsSpace.x4),
        if (receipt.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: AbsButton.secondary(
                  label: l.collectShare,
                  icon: PhosphorIcons.shareNetwork(PhosphorIconsStyle.bold),
                  onPressed: () => shareReceipt(context, ref, invoiceId: invoice.id, paymentId: result.paymentId),
                ),
              ),
              const SizedBox(width: AbsSpace.x2),
              Expanded(
                child: AbsButton.secondary(
                  label: l.collectPrint,
                  icon: PhosphorIcons.printer(PhosphorIconsStyle.bold),
                  onPressed: () => printReceipt(context, ref, invoiceId: invoice.id, paymentId: result.paymentId),
                ),
              ),
            ],
          ),
        if (receipt.isNotEmpty && member.phone != null) ...[
          const SizedBox(height: AbsSpace.x2),
          AbsButton.secondary(
            label: l.collectWhatsApp,
            icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
            onPressed: () => whatsappReceipt(
              context,
              ref,
              phone: member.phone!,
              name: member.name,
              amountPaise: result.amountPaise,
              receiptNo: receipt,
              memberId: member.memberId,
            ),
          ),
        ],
      ],
    );
  }
}
