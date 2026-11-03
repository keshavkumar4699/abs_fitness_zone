import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/l10n/l10n.dart';
import '../../../core/services/contact_links.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../application/payments_providers.dart';
import '../application/receipt_pdf.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';

/// Builds the PDF receipt for one payment on the device (2.7).
Future<(Uint8List, String)> _receipt(WidgetRef ref, String invoiceId, String paymentId) async {
  final repo = ref.read(paymentsRepositoryProvider);
  final invoice = await repo.invoice(invoiceId);
  final payment = invoice.payments.firstWhere((p) => p.id == paymentId);
  final profile = await ref.read(billingProfileProvider.future);
  final bytes = await buildReceiptPdf(
    gym: ReceiptGym(name: profile.gymName, address: profile.address, phone: profile.phone, gstin: profile.gstin),
    invoice: invoice,
    payment: payment,
    fonts: await ReceiptFonts.load(),
  );
  final name = 'receipt-${(payment.receiptNo ?? payment.id).replaceAll(RegExp(r'[^A-Za-z0-9-]'), '-')}.pdf';
  return (bytes, name);
}

/// Opens the system share sheet with the receipt PDF.
Future<void> shareReceipt(
  BuildContext context,
  WidgetRef ref, {
  required String invoiceId,
  required String paymentId,
}) async {
  final l = context.l10n;
  try {
    final (bytes, name) = await _receipt(ref, invoiceId, paymentId);
    await Printing.sharePdf(bytes: bytes, filename: name);
  } catch (_) {
    if (context.mounted) showAbsSnackbar(context, l.receiptFailed, tone: SnackTone.error);
  }
}

/// Sends the receipt to the system print dialog.
Future<void> printReceipt(
  BuildContext context,
  WidgetRef ref, {
  required String invoiceId,
  required String paymentId,
}) async {
  final l = context.l10n;
  try {
    final (bytes, name) = await _receipt(ref, invoiceId, paymentId);
    await Printing.layoutPdf(name: name, onLayout: (_) async => bytes);
  } catch (_) {
    if (context.mounted) showAbsSnackbar(context, l.receiptFailed, tone: SnackTone.error);
  }
}

/// WhatsApp "thank you" with the receipt number (free mode).
Future<void> whatsappReceipt(
  BuildContext context,
  WidgetRef ref, {
  required String phone,
  required String name,
  required int amountPaise,
  required String receiptNo,
}) async {
  final l = context.l10n;
  final profile = await ref.read(billingProfileProvider.future);
  await ContactLinks.openWhatsApp(
    phone,
    text: l.receiptWhatsAppText(name.split(' ').first, Money.format(amountPaise), profile.gymName, receiptNo),
  );
}

/// Opens the right receipt for [payment] (on any invoice the user can read).
Future<void> sharePaymentReceipt(BuildContext context, WidgetRef ref, Payment payment) async {
  if (payment.invoiceId == null || payment.receiptNo == null) return;
  await shareReceipt(context, ref, invoiceId: payment.invoiceId!, paymentId: payment.id);
}
