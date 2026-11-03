import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/services/upi_link.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../domain/payment_models.dart';

String modeName(AppLocalizations l, PaymentMode m) => switch (m) {
  PaymentMode.cash => l.modeCash,
  PaymentMode.upi => l.modeUpi,
  PaymentMode.card => l.modeCard,
  PaymentMode.bank => l.modeBank,
  PaymentMode.online => l.modeOnline,
  PaymentMode.credit => l.modeCredit,
};

IconData modeIcon(PaymentMode m) => switch (m) {
  PaymentMode.cash => PhosphorIcons.money(PhosphorIconsStyle.bold),
  PaymentMode.upi => PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
  PaymentMode.card => PhosphorIcons.creditCard(PhosphorIconsStyle.bold),
  PaymentMode.bank => PhosphorIcons.bank(PhosphorIconsStyle.bold),
  PaymentMode.online => PhosphorIcons.globe(PhosphorIconsStyle.bold),
  PaymentMode.credit => PhosphorIcons.piggyBank(PhosphorIconsStyle.bold),
};

PopHue modeHue(PaymentMode m) => switch (m) {
  PaymentMode.cash => PopHue.mint,
  PaymentMode.upi => PopHue.grape,
  PaymentMode.card => PopHue.sky,
  PaymentMode.bank => PopHue.tangerine,
  PaymentMode.online => PopHue.bubblegum,
  PaymentMode.credit => PopHue.lime,
};

String expenseCategoryName(AppLocalizations l, String c) => switch (c) {
  'rent' => l.expenseRent,
  'salaries' => l.expenseSalaries,
  'electricity' => l.expenseElectricity,
  'equipment' => l.expenseEquipment,
  'maintenance' => l.expenseMaintenance,
  'marketing' => l.expenseMarketing,
  'supplies' => l.expenseSupplies,
  _ => l.expenseOther,
};

IconData expenseIcon(String c) => switch (c) {
  'rent' => PhosphorIcons.buildings(PhosphorIconsStyle.bold),
  'salaries' => PhosphorIcons.usersThree(PhosphorIconsStyle.bold),
  'electricity' => PhosphorIcons.lightning(PhosphorIconsStyle.bold),
  'equipment' => PhosphorIcons.barbell(PhosphorIconsStyle.bold),
  'maintenance' => PhosphorIcons.wrench(PhosphorIconsStyle.bold),
  'marketing' => PhosphorIcons.megaphone(PhosphorIconsStyle.bold),
  'supplies' => PhosphorIcons.package(PhosphorIconsStyle.bold),
  _ => PhosphorIcons.receipt(PhosphorIconsStyle.bold),
};

/// Status sticker text and colour for an invoice, overdue first.
(String, PopHue) invoiceLook(AppLocalizations l, Invoice i) {
  if (i.status == InvoiceStatus.voided) return (l.invoiceStatusVoid, PopHue.grape);
  if (i.status == InvoiceStatus.paid) return (l.invoiceStatusPaid, PopHue.mint);
  final overdue = i.daysOverdue();
  if (overdue > 0) return (l.payOverdueBy(overdue), PopHue.coral);
  final days = i.nextDueDate == null ? 0 : IstDates.daysUntil(i.nextDueDate!);
  return (l.payDueIn(days < 0 ? 0 : days), days <= 3 ? PopHue.tangerine : PopHue.sky);
}

(String, PopHue)? paymentStatusLook(AppLocalizations l, Payment p) => switch (p.status) {
  PaymentStatus.confirmed => null,
  PaymentStatus.pendingVerification => (l.paymentStatusPending, PopHue.tangerine),
  PaymentStatus.rejected => (l.paymentStatusRejected, PopHue.coral),
  PaymentStatus.voided => (l.paymentStatusVoided, PopHue.grape),
};

/// UPI deep link for what is due now on an invoice (null without a UPI ID).
String? upiLinkFor(BillingProfile profile, Invoice i, {int? amountPaise}) {
  final vpa = profile.upiId;
  final amount = amountPaise ?? i.nextInstalmentDuePaise();
  if (vpa == null || !UpiLink.isValidVpa(vpa) || amount <= 0) return null;
  return UpiLink.build(
    vpa: vpa,
    payeeName: profile.gymName,
    amountPaise: amount,
    note: '${profile.gymName} ${i.invoiceNo}',
    reference: i.invoiceNo,
  );
}

/// Pre-filled WhatsApp fee reminder for the 3-before / on / 3,7-after schedule.
String duesReminderText(
  AppLocalizations l, {
  required String name,
  required int balancePaise,
  required DateTime? dueDate,
  required String gym,
  String? upiLink,
}) {
  final first = name.split(' ').first;
  final amount = Money.format(balancePaise);
  final days = dueDate == null ? 0 : IstDates.daysUntil(dueDate);
  final text = switch (days) {
    > 0 => l.whatsappDueSoonText(first, amount, gym, dateLabel(dueDate)),
    0 => l.whatsappDueTodayText(first, amount, gym),
    _ => l.whatsappDuesText(first, amount, gym, dateLabel(dueDate)),
  };
  return upiLink == null ? text : '$text\n${l.whatsappPayLine(upiLink)}';
}

/// Money in the display face with tabular figures.
class MoneyText extends StatelessWidget {
  const MoneyText(this.paise, {super.key, this.style, this.color});

  final int paise;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return Text(
      Money.format(paise),
      style: t.numericOf(style ?? t.heading).copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// One invoice row: member, number, status sticker and what is due.
class InvoiceTile extends StatelessWidget {
  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.onTap,
    this.onCollect,
    this.actionLabel,
    this.showMember = true,
  });

  final Invoice invoice;
  final VoidCallback onTap;
  final VoidCallback? onCollect;

  /// Defaults to "Collect" (staff); the member app says "Pay now".
  final String? actionLabel;
  final bool showMember;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final (label, hue) = invoiceLook(l, invoice);
    final paid = invoice.status == InvoiceStatus.paid;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x3, AbsSpace.x3, AbsSpace.x3),
        child: Row(
          children: [
            if (showMember) ...[AbsAvatar(name: invoice.memberName, hue: hue), const SizedBox(width: AbsSpace.x3)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showMember ? invoice.memberName : invoice.items.firstOrNull?.description ?? invoice.invoiceNo,
                    style: t.heading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    paid
                        ? '${invoice.invoiceNo} · ${l.invoiceIssued(dateLabel(invoice.issueDate))}'
                        : invoice.invoiceNo,
                    style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AbsSpace.x1),
                  PopSticker(label: label, hue: hue, dot: true),
                ],
              ),
            ),
            const SizedBox(width: AbsSpace.x2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MoneyText(paid || invoice.status == InvoiceStatus.voided ? invoice.totalPaise : invoice.balancePaise),
                if (invoice.status == InvoiceStatus.partial)
                  Text(l.invoiceStatusPartial, style: t.caption.copyWith(color: c.textSecondary)),
                if (onCollect != null && invoice.status.isOpen) ...[
                  const SizedBox(height: AbsSpace.x1),
                  _MiniButton(label: actionLabel ?? l.payCollect, hue: PopHue.tangerine, onTap: onCollect!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One payment row: mode bubble, member or receipt, time, amount.
class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.payment, this.onTap, this.trailing, this.showMember = true});

  final Payment payment;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showMember;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final look = paymentStatusLook(l, payment);
    final struck = payment.status == PaymentStatus.voided || payment.status == PaymentStatus.rejected;
    final sub = [
      if (payment.receiptNo != null) payment.receiptNo!,
      modeName(l, payment.mode),
      IstDates.formatDateTime(payment.paidAt),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x3, AbsSpace.x3, AbsSpace.x3),
        child: Row(
          children: [
            IconBubble(icon: modeIcon(payment.mode), hue: modeHue(payment.mode), size: 40),
            const SizedBox(width: AbsSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showMember ? payment.memberName : (payment.receiptNo ?? modeName(l, payment.mode)),
                    style: t.heading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sub,
                    style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (payment.utr != null)
                    Text(
                      l.payUtr(payment.utr!),
                      style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (look != null) ...[
                    const SizedBox(height: AbsSpace.x1),
                    PopSticker(label: look.$1, hue: look.$2, dot: true),
                  ],
                  if (payment.refundedPaise > 0) ...[
                    const SizedBox(height: AbsSpace.x1),
                    PopSticker(label: l.paymentRefunded(Money.format(payment.refundedPaise)), hue: PopHue.coral),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AbsSpace.x2),
            Text(
              Money.format(payment.amountPaise),
              style: t
                  .numericOf(t.heading)
                  .copyWith(
                    decoration: struck ? TextDecoration.lineThrough : null,
                    color: struck ? c.textSecondary : null,
                  ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({required this.label, required this.hue, required this.onTap});

  final String label;
  final PopHue hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.colors.pop(hue);
    return Semantics(
      button: true,
      child: Material(
        color: p.fill,
        shape: RoundedRectangleBorder(
          borderRadius: AbsRadius.pill,
          side: BorderSide(color: context.colors.isDark ? p.deep : context.colors.ink, width: 1.5),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32, minWidth: AbsSize.touchTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3, vertical: AbsSpace.x1),
              child: Center(
                widthFactor: 1,
                child: Text(label, style: context.text.label.copyWith(color: p.onFill)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Label / amount line used on invoices, day close and receipts.
class AmountRow extends StatelessWidget {
  const AmountRow({super.key, required this.label, required this.paise, this.bold = false, this.negative = false});

  final String label;
  final int paise;
  final bool bold;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: bold ? t.heading : t.body)),
          Text(
            negative ? '− ${Money.format(paise)}' : Money.format(paise),
            style: t.numericOf(bold ? t.title : t.body),
          ),
        ],
      ),
    );
  }
}
