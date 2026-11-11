import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../app/l10n/l10n.dart';

import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/phone.dart';
import '../domain/payment_models.dart';

/// Gym details printed on receipts.
class ReceiptGym {
  const ReceiptGym({required this.name, this.address, this.phone, this.gstin});

  final String name;
  final String? address;
  final String? phone;
  final String? gstin;
}

/// Loads the bundled fonts once (Nunito has ₹).
class ReceiptFonts {
  ReceiptFonts(this.regular, this.bold);

  final pw.Font regular;
  final pw.Font bold;

  static ReceiptFonts? _cached;

  static Future<ReceiptFonts> load() async => _cached ??= ReceiptFonts(
    pw.Font.ttf(await rootBundle.load('assets/fonts/Nunito-Regular.ttf')),
    pw.Font.ttf(await rootBundle.load('assets/fonts/Nunito-Bold.ttf')),
  );
}

/// On-device PDF receipt (2.7): gym, GSTIN, member, items, GST split, mode,
/// UTR and balance. A5, about 13 KB in about 0.1 s (spec: under 150 KB, under 1 s).
Future<Uint8List> buildReceiptPdf({
  required AppLocalizations l,
  required ReceiptGym gym,
  required String modeLabel,
  required Invoice invoice,
  required Payment payment,
  required ReceiptFonts fonts,
}) async {
  const ink = PdfColor.fromInt(0xFF1D1638);
  const soft = PdfColor.fromInt(0xFF675E83);
  const lime = PdfColor.fromInt(0xFFC6F432);
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold),
    title: l.receiptDocTitle(payment.receiptNo ?? ''),
    author: gym.name,
    compress: true,
  );
  pw.Widget row(String k, String v, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(k, style: const pw.TextStyle(color: soft, fontSize: 9)),
        ),
        pw.Text(
          v,
          style: pw.TextStyle(fontSize: bold ? 12 : 10, fontWeight: bold ? pw.FontWeight.bold : null),
        ),
      ],
    ),
  );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 40,
                height: 40,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: lime,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: ink, width: 1.5),
                ),
                child: pw.Text(
                  'ABS',
                  style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, color: ink, fontSize: 12),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      gym.name,
                      style: const pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: ink),
                    ),
                    if (gym.address != null) pw.Text(gym.address!, style: const pw.TextStyle(fontSize: 8, color: soft)),
                    if (gym.phone != null)
                      pw.Text(Phone.display(gym.phone!), style: const pw.TextStyle(fontSize: 8, color: soft)),
                    if (gym.gstin != null)
                      pw.Text(l.receiptGstin(gym.gstin!), style: const pw.TextStyle(fontSize: 8, color: soft)),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    l.receiptHeading,
                    style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: ink),
                  ),
                  pw.Text(payment.receiptNo ?? '', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(IstDates.formatDateTime(payment.paidAt), style: const pw.TextStyle(fontSize: 8, color: soft)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(l.receiptReceivedFrom, style: const pw.TextStyle(fontSize: 8, color: soft)),
          pw.Text(
            '${invoice.memberName} (${invoice.memberCode})',
            style: const pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          if (invoice.memberPhone != null)
            pw.Text(Phone.display(invoice.memberPhone!), style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 12),
          pw.Text(l.receiptAgainstInvoice(invoice.invoiceNo), style: const pw.TextStyle(fontSize: 9, color: soft)),
          pw.Divider(color: soft, thickness: 0.5),
          for (final item in invoice.items) row(item.description, Money.format(item.grossPaise)),
          if (invoice.discountPaise > 0) row(l.receiptDiscount, '- ${Money.format(invoice.discountPaise)}'),
          if (invoice.gstPaise > 0) ...[
            row(l.receiptTaxable, Money.format(invoice.taxablePaise)),
            row(l.receiptCgst, Money.format(invoice.cgstPaise)),
            row(l.receiptSgst, Money.format(invoice.sgstPaise)),
          ],
          row(l.receiptInvoiceTotal, Money.format(invoice.totalPaise), bold: true),
          pw.Divider(color: soft, thickness: 0.5),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(color: lime, borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    l.receiptAmountReceived,
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, color: ink),
                  ),
                ),
                pw.Text(
                  Money.format(payment.amountPaise),
                  style: const pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: ink),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 6),
          row(l.receiptMode, modeLabel),
          if (payment.utr != null) row(l.receiptUtr, payment.utr!),
          row(l.receiptBalanceDue, Money.format(invoice.balancePaise), bold: true),
          pw.Spacer(),
          pw.Center(
            child: pw.Text(l.receiptThanks, style: const pw.TextStyle(fontSize: 9, color: soft)),
          ),
          pw.Center(
            child: pw.Text(l.receiptGenerated, style: const pw.TextStyle(fontSize: 7, color: soft)),
          ),
        ],
      ),
    ),
  );
  return doc.save();
}
