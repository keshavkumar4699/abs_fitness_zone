import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../../payments/application/payments_providers.dart';
import '../../payments/data/payments_repository.dart';
import '../../payments/domain/payment_models.dart';
import '../../payments/presentation/payment_ui.dart';
import '../../payments/presentation/receipt_actions.dart';
import '../data/my_member_repository.dart';

/// Member app: my invoices (what's due first) and my receipts (2.5, 2.7).
class MyPaymentsScreen extends ConsumerWidget {
  const MyPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final me = ref.watch(myMemberProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.mePayments)),
      body: AsyncView<Member?>(
        value: me,
        onRetry: () => ref.invalidate(myMemberProvider),
        isEmpty: (m) => m == null,
        empty: const SizedBox.shrink(),
        loading: const SkeletonList(itemCount: 4),
        data: (m) => _MyPayments(memberId: m!.id),
      ),
    );
  }
}

class _MyPayments extends ConsumerWidget {
  const _MyPayments({required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.text;
    final invoices = ref.watch(memberInvoicesProvider(memberId));
    final receipts = ref.watch(memberPaymentsProvider(memberId)).value ?? const <Payment>[];
    final pending = ref.watch(memberPendingClaimsProvider(memberId)).value ?? const <Payment>[];
    return AbsRefresh(
      onRefresh: () async {
        ref.refreshPayments(memberId: memberId);
        await ref.read(memberInvoicesProvider(memberId).future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
        ),
        children: [
          AsyncView<List<Invoice>>(
            value: invoices,
            onRetry: () => ref.invalidate(memberInvoicesProvider(memberId)),
            loading: const SizedBox(height: 200, child: SkeletonList(itemCount: 2)),
            isEmpty: (list) => list.isEmpty,
            empty: EmptyState(
              title: l.meNoInvoicesTitle,
              message: l.meNoInvoicesBody,
              illustration: EmptyIllustration.receipt,
              hue: PopHue.tangerine,
            ),
            data: (list) {
              final open = list.where((i) => i.status.isOpen).toList();
              final rest = list.where((i) => !i.status.isOpen).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (open.isEmpty)
                    AbsCard(
                      hue: PopHue.mint,
                      child: Row(
                        children: [
                          IconBubble(icon: PhosphorIcons.confetti(PhosphorIconsStyle.bold), hue: PopHue.mint),
                          const SizedBox(width: AbsSpace.x3),
                          Expanded(child: Text(l.meAllPaid, style: t.heading)),
                        ],
                      ),
                    ),
                  for (final i in open)
                    InvoiceTile(
                      invoice: i,
                      showMember: false,
                      onTap: () => context.push(Routes.mePay(i.id)),
                      onCollect: () => context.push(Routes.mePay(i.id)),
                      actionLabel: l.mePayNow,
                    ),
                  for (final p in pending)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                      child: PopSticker(
                        label: l.mePaidPending(Money.format(p.amountPaise)),
                        hue: PopHue.tangerine,
                        dot: true,
                      ),
                    ),
                  if (receipts.isNotEmpty) ...[
                    const SizedBox(height: AbsSpace.x3),
                    Text(l.collectShareReceipt, style: t.title),
                    const SizedBox(height: AbsSpace.x2),
                    for (final p in receipts)
                      PaymentTile(
                        payment: p,
                        showMember: false,
                        onTap: p.receiptNo == null ? null : () => sharePaymentReceipt(context, ref, p),
                        trailing: p.receiptNo == null
                            ? null
                            : IconButton(
                                tooltip: l.collectShareReceipt,
                                icon: Icon(PhosphorIcons.shareNetwork(PhosphorIconsStyle.bold)),
                                onPressed: () => sharePaymentReceipt(context, ref, p),
                              ),
                      ),
                  ],
                  if (rest.isNotEmpty) ...[
                    const SizedBox(height: AbsSpace.x3),
                    for (final i in rest) InvoiceTile(invoice: i, showMember: false, onTap: () {}),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Pay one invoice: UPI app deep link (or QR), then "I've paid" with the UTR.
class MemberPayScreen extends ConsumerWidget {
  const MemberPayScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final invoice = ref.watch(invoiceDetailProvider(invoiceId));
    return Scaffold(
      appBar: AppBar(title: Text(l.mePayTitle)),
      body: AsyncView<Invoice>(
        value: invoice,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(invoiceDetailProvider(invoiceId)),
        loading: const SkeletonList(itemCount: 4),
        data: (i) => _PayBody(invoice: i),
      ),
    );
  }
}

class _PayBody extends ConsumerWidget {
  const _PayBody({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final profile = ref.watch(billingProfileProvider).value;
    final due = invoice.nextInstalmentDuePaise();
    final link = profile == null || !invoice.status.isOpen ? null : upiLinkFor(profile, invoice, amountPaise: due);
    final pending = invoice.payments.where((p) => p.status == PaymentStatus.pendingVerification).toList();
    final rejected = invoice.payments.where((p) => p.status == PaymentStatus.rejected).toList();
    final p = c.pop(PopHue.tangerine);
    return ListView(
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
              Text(l.meDuesTitle, style: t.label.copyWith(color: p.onFill)),
              Text(
                Money.format(due),
                key: const ValueKey('pay-amount'),
                style: t.numericOf(t.displayXL).copyWith(color: p.onFill, height: 1.1),
              ),
              Text(
                '${invoice.invoiceNo} · ${l.meDueBy(dateLabel(invoice.nextDueDate))}',
                style: t.numericOf(t.label).copyWith(color: p.onFill),
              ),
            ],
          ),
        ),
        const SizedBox(height: AbsSpace.x4),
        for (final pay in pending)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x3),
            child: AbsCard(
              hue: PopHue.grape,
              padding: const EdgeInsets.all(AbsSpace.x4),
              child: Row(
                children: [
                  IconBubble(icon: PhosphorIcons.hourglassMedium(PhosphorIconsStyle.bold), hue: PopHue.grape),
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(child: Text(l.mePaidPending(Money.format(pay.amountPaise)), style: t.body)),
                ],
              ),
            ),
          ),
        for (final pay in rejected.take(1))
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x3),
            child: Text(l.meRejected(pay.voidedReason ?? ''), style: t.label.copyWith(color: c.danger)),
          ),
        if (!invoice.status.isOpen)
          Text(l.meAllPaid, style: t.heading)
        else if (link == null)
          AbsCard(
            hue: PopHue.sky,
            child: Text(l.meNoUpi, style: t.body),
          )
        else ...[
          AbsButton(
            key: const ValueKey('pay-upi'),
            label: l.mePayUpi,
            hue: PopHue.grape,
            icon: PhosphorIcons.deviceMobile(PhosphorIconsStyle.bold),
            onPressed: () async {
              var opened = false;
              try {
                opened = await launchUrl(Uri.parse(link), mode: LaunchMode.externalNonBrowserApplication);
              } catch (_) {
                opened = false;
              }
              if (!opened && context.mounted) showAbsSnackbar(context, l.noUpiApp);
            },
          ),
          const SizedBox(height: AbsSpace.x5),
          Text(
            l.mePayScan,
            style: t.label.copyWith(color: c.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AbsSpace.x3),
          Center(
            child: Container(
              padding: const EdgeInsets.all(AbsSpace.x3),
              decoration: stickerDecoration(c, color: Colors.white),
              child: QrImageView(data: link, size: 200, backgroundColor: Colors.white),
            ),
          ),
          const SizedBox(height: AbsSpace.x2),
          Text(
            profile!.upiId!,
            style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
        if (invoice.status.isOpen) ...[
          const SizedBox(height: AbsSpace.x5),
          AbsButton.secondary(
            key: const ValueKey('i-paid'),
            label: l.mePaid,
            icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
            onPressed: () => showClaimSheet(context, invoice: invoice, amountPaise: due),
          ),
          const SizedBox(height: AbsSpace.x3),
          Text(
            l.mePayAtDesk,
            style: t.caption.copyWith(color: c.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// "I've paid": amount + UTR, sent for the desk to verify.
Future<bool?> showClaimSheet(BuildContext context, {required Invoice invoice, required int amountPaise}) =>
    showAbsBottomSheet<bool>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _ClaimSheet(controller: controller, invoice: invoice, amountPaise: amountPaise),
    );

class _ClaimSheet extends ConsumerStatefulWidget {
  const _ClaimSheet({required this.controller, required this.invoice, required this.amountPaise});

  final ScrollController controller;
  final Invoice invoice;
  final int amountPaise;

  @override
  ConsumerState<_ClaimSheet> createState() => _ClaimSheetState();
}

class _ClaimSheetState extends ConsumerState<_ClaimSheet> {
  late final _amount = TextEditingController(text: Money.inputOf(widget.amountPaise));
  final _utr = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _utr.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l = context.l10n;
    final amount = Money.parse(_amount.text) ?? 0;
    if (amount <= 0) return setState(() => _error = l.amountRequired);
    if (_utr.text.trim().length < 6) return setState(() => _error = l.collectUtrMissing);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(paymentsRepositoryProvider)
          .claim(invoiceId: widget.invoice.id, amountPaise: amount, utr: _utr.text.trim());
      ref.refreshPayments(memberId: widget.invoice.memberId, invoiceId: widget.invoice.id);
      if (!mounted) return;
      showAbsSnackbar(context, l.mePaidSent, tone: SnackTone.success);
      Navigator.pop(context, true);
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.mePaidTitle, style: context.text.title),
              const SizedBox(height: AbsSpace.x2),
              Text(l.mePaidBody, style: context.text.body.copyWith(color: context.colors.textSecondary)),
              const SizedBox(height: AbsSpace.x4),
              AbsTextField(
                key: const ValueKey('claim-amount'),
                label: l.mePaidAmount,
                controller: _amount,
                prefixText: '₹',
                numeric: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AbsSpace.x3),
              AbsTextField(
                key: const ValueKey('claim-utr'),
                label: l.collectUtr,
                helperText: l.collectUtrHelp,
                controller: _utr,
                numeric: true,
                maxLength: 30,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))],
              ),
              if (_error != null)
                Text(
                  _error!,
                  key: const ValueKey('claim-error'),
                  style: context.text.label.copyWith(color: context.colors.danger),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('claim-send'),
            label: l.mePaidSubmit,
            hue: PopHue.grape,
            isLoading: _busy,
            onPressed: _send,
          ),
        ),
      ],
    );
  }
}
