import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/services/contact_links.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/payments_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'collect_sheet.dart';
import 'payment_ui.dart';
import 'payments_screen.dart' show askReason;
import 'receipt_actions.dart';

/// Invoice detail (2.1): items with discount and GST, instalments, the
/// payment timeline with receipts, UPI link / QR, and owner voids.
class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoice = ref.watch(invoiceDetailProvider(invoiceId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          invoice.value?.invoiceNo ?? context.l10n.invoiceTitle,
          style: context.text.numericOf(context.text.heading),
        ),
        actions: [if (invoice.value != null) _OwnerMenu(invoice: invoice.value!)],
      ),
      body: AsyncView<Invoice>(
        value: invoice,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(invoiceDetailProvider(invoiceId)),
        loading: const SkeletonList(itemCount: 5),
        data: (i) => _Body(invoice: i),
      ),
    );
  }
}

class _OwnerMenu extends ConsumerWidget {
  const _OwnerMenu({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    if (!owner || invoice.status == InvoiceStatus.voided || invoice.paidPaise > 0) return const SizedBox.shrink();
    return PopupMenuButton<String>(
      tooltip: l.actionMore,
      onSelected: (_) async {
        final reason = await askReason(
          context,
          title: l.invoiceVoidTitle(invoice.invoiceNo),
          body: l.invoiceVoidBody,
          label: l.invoiceReason,
          confirm: l.invoiceVoid,
        );
        if (reason == null || !context.mounted) return;
        try {
          await ref.read(paymentsRepositoryProvider).voidInvoice(invoiceId: invoice.id, reason: reason);
          ref.refreshPayments(memberId: invoice.memberId, invoiceId: invoice.id);
          if (context.mounted) showAbsSnackbar(context, l.invoiceVoided, tone: SnackTone.success);
        } catch (e) {
          if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'void',
          child: Text(l.invoiceVoid, style: TextStyle(color: context.colors.danger)),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final (label, hue) = invoiceLook(l, invoice);
    final open = invoice.status.isOpen;
    final profile = ref.watch(billingProfileProvider).value;
    final credit = open && invoice.memberId != null ? ref.watch(memberCreditProvider(invoice.memberId!)).value ?? 0 : 0;
    final p = c.pop(hue);

    return AbsRefresh(
      onRefresh: () => ref.refresh(invoiceDetailProvider(invoice.id).future),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AbsSpace.x5),
            decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: invoice.memberId == null
                            ? null
                            : () => context.push(Routes.memberDetail(invoice.memberId!)),
                        child: Text(
                          invoice.memberName,
                          style: t.title.copyWith(color: p.onFill),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    PopSticker(label: label, hue: PopHue.grape, dot: true),
                  ],
                ),
                Text(
                  '${invoice.memberCode} · ${l.invoiceIssued(dateLabel(invoice.issueDate))}',
                  style: t.numericOf(t.label).copyWith(color: p.onFill),
                ),
                const SizedBox(height: AbsSpace.x3),
                Text(open ? l.invoiceBalance : l.invoiceTotal, style: t.label.copyWith(color: p.onFill)),
                CountUp(
                  key: const ValueKey('invoice-balance'),
                  value: open ? invoice.balancePaise : invoice.totalPaise,
                  format: (v) => Money.format(v.round()),
                  style: t.numericOf(t.displayXL).copyWith(color: p.onFill, height: 1.1),
                ),
                if (invoice.status == InvoiceStatus.partial)
                  Text(
                    '${l.invoicePaid} ${Money.format(invoice.paidPaise)} / ${Money.format(invoice.totalPaise)}',
                    style: t.numericOf(t.label).copyWith(color: p.onFill),
                  ),
                if (invoice.status == InvoiceStatus.voided && invoice.voidedReason != null)
                  Text(l.invoiceVoidedReason(invoice.voidedReason!), style: t.label.copyWith(color: p.onFill)),
              ],
            ),
          ),
          if (open) ...[
            const SizedBox(height: AbsSpace.x4),
            AbsButton(
              key: const ValueKey('invoice-collect'),
              label: l.payCollect,
              hue: PopHue.tangerine,
              icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.bold),
              onPressed: () => showCollectSheet(context, invoice: invoice),
            ),
            const SizedBox(height: AbsSpace.x2),
            Row(
              children: [
                Expanded(
                  child: AbsButton.secondary(
                    label: l.invoiceShowQr,
                    icon: PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
                    onPressed: () => _showUpiSheet(context, invoice, profile),
                  ),
                ),
                const SizedBox(width: AbsSpace.x2),
                Expanded(
                  child: AbsButton.secondary(
                    label: l.invoiceSendLink,
                    icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
                    onPressed: () => _sendUpiLink(context, invoice, profile),
                  ),
                ),
              ],
            ),
            if (profile?.razorpayEnabled ?? false) ...[
              const SizedBox(height: AbsSpace.x2),
              AbsButton.ghost(
                label: l.invoiceGatewayLink,
                icon: PhosphorIcons.link(PhosphorIconsStyle.bold),
                expand: true,
                onPressed: () => _gatewayLink(context, ref, invoice, profile!),
              ),
            ],
            if (credit > 0) ...[
              const SizedBox(height: AbsSpace.x3),
              AbsCard(
                hue: PopHue.lime,
                padding: const EdgeInsets.all(AbsSpace.x4),
                child: Row(
                  children: [
                    IconBubble(icon: PhosphorIcons.piggyBank(PhosphorIconsStyle.bold), hue: PopHue.lime),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(child: Text(l.memberCredit(Money.format(credit)), style: t.heading)),
                    AbsButton.ghost(
                      label: l.invoiceApplyCredit(
                        Money.format(credit < invoice.balancePaise ? credit : invoice.balancePaise),
                      ),
                      hue: PopHue.lime,
                      onPressed: () => _applyCredit(context, ref, invoice, credit),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const SizedBox(height: AbsSpace.x5),
          AbsCard(
            title: l.invoiceItems,
            child: Column(
              children: [
                for (final item in invoice.items)
                  AmountRow(
                    label: item.qty > 1 ? '${item.description} × ${item.qty}' : item.description,
                    paise: item.grossPaise,
                  ),
                if (invoice.discountPaise > 0)
                  AmountRow(
                    label: invoice.discountReason == null
                        ? l.invoiceDiscount
                        : '${l.invoiceDiscount} · ${invoice.discountReason}',
                    paise: invoice.discountPaise,
                    negative: true,
                  ),
                if (invoice.gstPaise > 0) ...[
                  const Divider(),
                  AmountRow(label: l.invoiceTaxable, paise: invoice.taxablePaise),
                  AmountRow(label: l.invoiceCgst, paise: invoice.cgstPaise),
                  AmountRow(label: l.invoiceSgst, paise: invoice.sgstPaise),
                ],
                const Divider(),
                AmountRow(label: l.invoiceTotal, paise: invoice.totalPaise, bold: true),
                if (invoice.paidPaise > 0) AmountRow(label: l.invoicePaid, paise: invoice.paidPaise),
                if (open) AmountRow(label: l.invoiceBalance, paise: invoice.balancePaise, bold: true),
              ],
            ),
          ),
          if (invoice.instalments.isNotEmpty || open) ...[
            const SizedBox(height: AbsSpace.x4),
            AbsCard(
              title: l.invoiceInstalments,
              action: open && invoice.instalments.isNotEmpty
                  ? IconButton(
                      tooltip: l.invoiceSplit,
                      icon: Icon(PhosphorIcons.splitHorizontal(PhosphorIconsStyle.bold)),
                      onPressed: () => showInstalmentSheet(context, invoice),
                    )
                  : null,
              child: invoice.instalments.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: AbsButton.ghost(
                        key: const ValueKey('split-invoice'),
                        label: l.invoiceSplit,
                        icon: PhosphorIcons.splitHorizontal(PhosphorIconsStyle.bold),
                        onPressed: () => showInstalmentSheet(context, invoice),
                      ),
                    )
                  : Column(
                      children: [
                        for (final i in invoice.instalments)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
                            child: Row(
                              children: [
                                PopSticker(
                                  label: l.invoicePart(i.seq),
                                  hue: i.status == 'paid' ? PopHue.mint : PopHue.sky,
                                ),
                                const SizedBox(width: AbsSpace.x3),
                                Expanded(child: Text(dateLabel(i.dueDate), style: t.body)),
                                if (i.status == 'paid')
                                  Padding(
                                    padding: const EdgeInsets.only(right: AbsSpace.x2),
                                    child: Icon(
                                      PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                                      color: c.success,
                                      size: AbsSize.iconSmall,
                                    ),
                                  ),
                                Text(Money.format(i.amountPaise), style: t.numericOf(t.body)),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ],
          const SizedBox(height: AbsSpace.x5),
          Text(l.invoicePayments, style: t.title),
          const SizedBox(height: AbsSpace.x2),
          if (invoice.payments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AbsSpace.x4),
              child: Text(l.invoiceNoPayments, style: t.body.copyWith(color: c.textSecondary)),
            )
          else
            for (final pay in invoice.payments) _PaymentRow(invoice: invoice, payment: pay),
        ],
      ),
    );
  }

  Future<void> _applyCredit(BuildContext context, WidgetRef ref, Invoice i, int credit) async {
    final l = context.l10n;
    try {
      await ref
          .read(paymentsRepositoryProvider)
          .applyCredit(invoiceId: i.id, amountPaise: credit < i.balancePaise ? credit : i.balancePaise);
      ref.refreshPayments(memberId: i.memberId, invoiceId: i.id);
      if (context.mounted) showAbsSnackbar(context, l.invoiceCreditApplied, tone: SnackTone.success);
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }
}

Future<void> _sendUpiLink(BuildContext context, Invoice i, BillingProfile? profile) async {
  final l = context.l10n;
  final link = profile == null ? null : upiLinkFor(profile, i);
  if (link == null || i.memberPhone == null) {
    showAbsSnackbar(context, l.invoiceNoUpi);
    return;
  }
  await ContactLinks.openWhatsApp(
    i.memberPhone!,
    text: l.invoiceUpiText(
      i.memberName.split(' ').first,
      Money.format(i.nextInstalmentDuePaise()),
      profile!.gymName,
      i.invoiceNo,
      link,
    ),
  );
}

Future<void> _gatewayLink(BuildContext context, WidgetRef ref, Invoice i, BillingProfile profile) async {
  final l = context.l10n;
  try {
    final url = await ref.read(paymentsRepositoryProvider).gatewayLink(i.id);
    ref.invalidate(invoiceDetailProvider(i.id));
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    showAbsSnackbar(context, l.invoiceGatewayReady, tone: SnackTone.success);
    if (i.memberPhone != null) {
      await ContactLinks.openWhatsApp(
        i.memberPhone!,
        text: l.invoiceGatewayText(i.memberName.split(' ').first, Money.format(i.balancePaise), profile.gymName, url),
      );
    }
  } catch (e) {
    if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
  }
}

/// UPI QR for what is due now, scannable from any UPI app.
Future<void> _showUpiSheet(BuildContext context, Invoice i, BillingProfile? profile) =>
    showUpiQrSheet(context, profile: profile, invoice: i, amountPaise: i.nextInstalmentDuePaise());

Future<void> showUpiQrSheet(
  BuildContext context, {
  required BillingProfile? profile,
  required Invoice invoice,
  required int amountPaise,
}) => showAbsBottomSheet<void>(
  context: context,
  builder: (context, controller) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final link = profile == null ? null : upiLinkFor(profile, invoice, amountPaise: amountPaise);
    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x6),
      children: [
        Text(l.invoiceShowQr, style: t.title),
        const SizedBox(height: AbsSpace.x4),
        if (link == null)
          Text(l.invoiceNoUpi, style: t.body)
        else ...[
          Center(
            child: Container(
              padding: const EdgeInsets.all(AbsSpace.x4),
              decoration: stickerDecoration(c, color: Colors.white),
              child: QrImageView(
                key: const ValueKey('upi-qr'),
                data: link,
                size: 220,
                backgroundColor: Colors.white,
                semanticsLabel: l.invoiceQrBody(Money.format(amountPaise)),
              ),
            ),
          ),
          const SizedBox(height: AbsSpace.x4),
          Text(l.invoiceQrBody(Money.format(amountPaise)), style: t.heading, textAlign: TextAlign.center),
          Text(
            '${profile!.upiId} · ${invoice.invoiceNo}',
            style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AbsSpace.x4),
          AbsButton.secondary(
            label: l.commonCopy,
            icon: PhosphorIcons.copy(PhosphorIconsStyle.bold),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link));
              if (context.mounted) showAbsSnackbar(context, l.commonCopied, tone: SnackTone.success);
            },
          ),
        ],
      ],
    );
  },
);

class _PaymentRow extends ConsumerWidget {
  const _PaymentRow({required this.invoice, required this.payment});

  final Invoice invoice;
  final Payment payment;

  Future<void> _void(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final reason = await askReason(
      context,
      title: l.paymentVoidTitle(payment.receiptNo ?? ''),
      label: l.invoiceReason,
      confirm: l.paymentVoid,
    );
    if (reason == null || !context.mounted) return;
    try {
      await ref.read(paymentsRepositoryProvider).voidPayment(paymentId: payment.id, reason: reason);
      ref.refreshPayments(memberId: invoice.memberId, invoiceId: invoice.id);
      if (context.mounted) showAbsSnackbar(context, l.paymentVoidDone, tone: SnackTone.success);
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final confirmed = payment.status == PaymentStatus.confirmed;
    final refundable = payment.appliedPaise - payment.refundedPaise;
    return PaymentTile(
      payment: payment,
      showMember: false,
      onTap: confirmed && payment.receiptNo != null ? () => sharePaymentReceipt(context, ref, payment) : null,
      trailing: !confirmed
          ? null
          : PopupMenuButton<String>(
              key: ValueKey('payment-menu-${payment.id}'),
              tooltip: l.actionMore,
              onSelected: (a) => switch (a) {
                'share' => sharePaymentReceipt(context, ref, payment),
                'print' => printReceipt(context, ref, invoiceId: invoice.id, paymentId: payment.id),
                'void' => _void(context, ref),
                _ => showRefundSheet(context, invoice: invoice, payment: payment),
              },
              itemBuilder: (_) => [
                if (payment.receiptNo != null) PopupMenuItem(value: 'share', child: Text(l.collectShareReceipt)),
                if (payment.receiptNo != null) PopupMenuItem(value: 'print', child: Text(l.collectPrint)),
                if (owner && payment.refundedPaise == 0 && payment.mode != PaymentMode.online)
                  PopupMenuItem(
                    value: 'void',
                    child: Text(l.paymentVoid, style: TextStyle(color: context.colors.danger)),
                  ),
                if (owner && refundable > 0 && payment.mode != PaymentMode.credit)
                  PopupMenuItem(value: 'refund', child: Text(l.paymentRefund)),
              ],
            ),
    );
  }
}

/// Owner refund: amount (≤ what the payment paid in), mode and reason.
Future<void> showRefundSheet(BuildContext context, {required Invoice invoice, required Payment payment}) =>
    showAbsBottomSheet<void>(
      context: context,
      builder: (context, controller) => _RefundSheet(controller: controller, invoice: invoice, payment: payment),
    );

class _RefundSheet extends ConsumerStatefulWidget {
  const _RefundSheet({required this.controller, required this.invoice, required this.payment});

  final ScrollController controller;
  final Invoice invoice;
  final Payment payment;

  @override
  ConsumerState<_RefundSheet> createState() => _RefundSheetState();
}

class _RefundSheetState extends ConsumerState<_RefundSheet> {
  late final _amount = TextEditingController(
    text: Money.inputOf(widget.payment.appliedPaise - widget.payment.refundedPaise),
  );
  final _reason = TextEditingController();
  PaymentMode _mode = PaymentMode.cash;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final amount = Money.parse(_amount.text) ?? 0;
    if (amount <= 0) return setState(() => _error = l.amountRequired);
    if (_reason.text.trim().isEmpty) return setState(() => _error = l.reasonRequired);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(paymentsRepositoryProvider)
          .refund(paymentId: widget.payment.id, amountPaise: amount, mode: _mode, reason: _reason.text.trim());
      ref.refreshPayments(memberId: widget.invoice.memberId, invoiceId: widget.invoice.id);
      if (!mounted) return;
      showAbsSnackbar(context, l.paymentRefundDone, tone: SnackTone.success);
      Navigator.pop(context);
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
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x6),
      children: [
        Text(l.paymentRefundTitle(widget.payment.receiptNo ?? ''), style: context.text.title),
        const SizedBox(height: AbsSpace.x4),
        AbsTextField(
          label: l.paymentRefundAmount,
          controller: _amount,
          prefixText: '₹',
          numeric: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AbsSpace.x3),
        Text(l.paymentRefundMode, style: context.text.label.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: AbsSpace.x2),
        PopSingleChips<PaymentMode>(
          options: PaymentMode.collectable,
          labelOf: (m) => modeName(l, m),
          value: _mode,
          allowEmpty: false,
          onChanged: (m) => setState(() => _mode = m ?? PaymentMode.cash),
        ),
        const SizedBox(height: AbsSpace.x3),
        AbsTextField(label: l.invoiceReason, controller: _reason),
        if (_error != null) ...[
          const SizedBox(height: AbsSpace.x2),
          Text(_error!, style: context.text.label.copyWith(color: context.colors.danger)),
        ],
        const SizedBox(height: AbsSpace.x4),
        AbsButton.destructive(
          label: l.paymentRefund,
          icon: PhosphorIcons.arrowUDownLeft(PhosphorIconsStyle.bold),
          isLoading: _busy,
          onPressed: _save,
        ),
      ],
    );
  }
}

/// Split an invoice into up to 4 dated parts that add up to the total.
Future<void> showInstalmentSheet(BuildContext context, Invoice invoice) => showAbsBottomSheet<void>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _InstalmentSheet(controller: controller, invoice: invoice),
);

class _InstalmentSheet extends ConsumerStatefulWidget {
  const _InstalmentSheet({required this.controller, required this.invoice});

  final ScrollController controller;
  final Invoice invoice;

  @override
  ConsumerState<_InstalmentSheet> createState() => _InstalmentSheetState();
}

class _InstalmentSheetState extends ConsumerState<_InstalmentSheet> {
  final List<(DateTime, TextEditingController)> _parts = [];
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final inv = widget.invoice;
    if (inv.instalments.isNotEmpty) {
      for (final i in inv.instalments) {
        _parts.add((i.dueDate ?? IstDates.today(), TextEditingController(text: Money.inputOf(i.amountPaise))));
      }
    } else {
      final start = inv.dueDate ?? IstDates.today();
      final first = inv.totalPaise - inv.totalPaise ~/ 2;
      _parts
        ..add((start, TextEditingController(text: Money.inputOf(first))))
        ..add((
          start.add(const Duration(days: 30)),
          TextEditingController(text: Money.inputOf(inv.totalPaise - first)),
        ));
    }
  }

  @override
  void dispose() {
    for (final (_, c) in _parts) {
      c.dispose();
    }
    super.dispose();
  }

  int get _sum => _parts.fold(0, (a, p) => a + (Money.parse(p.$2.text) ?? 0));

  Future<void> _save() async {
    final l = context.l10n;
    final total = widget.invoice.totalPaise;
    if (_sum != total) {
      return setState(() => _error = l.invoiceSplitMismatch(Money.format(_sum), Money.format(total)));
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(paymentsRepositoryProvider).setInstalments(widget.invoice.id, [
        for (final (d, c) in _parts) (d, Money.parse(c.text) ?? 0),
      ]);
      ref.refreshPayments(memberId: widget.invoice.memberId, invoiceId: widget.invoice.id);
      if (!mounted) return;
      showAbsSnackbar(context, l.invoiceSplitSaved, tone: SnackTone.success);
      Navigator.pop(context);
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
    final c = context.colors;
    final total = widget.invoice.totalPaise;
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.invoiceSplit, style: context.text.title),
              Text(
                l.invoiceSplitHelp(Money.format(total)),
                style: context.text.caption.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AbsSpace.x4),
              for (final (n, (day, ctrl)) in _parts.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: DateField(
                          label: l.invoicePart(n + 1),
                          value: day,
                          allowClear: false,
                          onChanged: (d) => setState(() => _parts[n] = (d ?? day, ctrl)),
                        ),
                      ),
                      const SizedBox(width: AbsSpace.x2),
                      Expanded(
                        flex: 4,
                        child: AbsTextField(
                          key: ValueKey('part-amount-$n'),
                          label: l.collectAmount,
                          controller: ctrl,
                          prefixText: '₹',
                          numeric: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() => _error = null),
                        ),
                      ),
                      if (_parts.length > 1)
                        IconButton(
                          tooltip: l.actionDelete,
                          icon: Icon(PhosphorIcons.minusCircle(PhosphorIconsStyle.bold)),
                          onPressed: () => setState(() => _parts.removeAt(n).$2.dispose()),
                        ),
                    ],
                  ),
                ),
              if (_parts.length < 4)
                Align(
                  alignment: Alignment.centerLeft,
                  child: AbsButton.ghost(
                    label: l.invoiceAddPart,
                    icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                    onPressed: () => setState(
                      () => _parts.add((_parts.last.$1.add(const Duration(days: 30)), TextEditingController())),
                    ),
                  ),
                ),
              const SizedBox(height: AbsSpace.x3),
              AmountRow(label: l.invoiceTotal, paise: _sum, bold: true),
              if (_error != null)
                Text(
                  _error!,
                  key: const ValueKey('split-error'),
                  style: context.text.label.copyWith(color: c.danger),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(key: const ValueKey('split-save'), label: l.commonSave, isLoading: _busy, onPressed: _save),
        ),
      ],
    );
  }
}
