import 'dart:convert';

import 'package:abs_fitness/core/services/upi_link.dart';
import 'package:abs_fitness/features/payments/application/payments_providers.dart';
import 'package:abs_fitness/features/payments/application/receipt_pdf.dart';
import 'package:abs_fitness/features/payments/domain/payment_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/payment_fakes.dart';

void main() {
  group('UpiLink', () {
    test('builds a upi://pay link with rupees, INR and encoded text', () {
      final link = UpiLink.build(
        vpa: 'absfitness@okhdfc',
        payeeName: 'ABS Fitness Zone',
        amountPaise: 150050,
        note: 'ABS/26-27/0001',
        reference: 'ABS/26-27/0001',
      );
      expect(
        link,
        'upi://pay?pa=absfitness%40okhdfc&pn=ABS%20Fitness%20Zone&am=1500.50&cu=INR'
        '&tn=ABS%2F26-27%2F0001&tr=ABS26270001',
      );
      final uri = Uri.parse(link);
      expect(uri.scheme, 'upi');
      expect(uri.queryParameters['pa'], 'absfitness@okhdfc');
      expect(uri.queryParameters['am'], '1500.50');
    });

    test('pads paise and defaults the payee name', () {
      final uri = Uri.parse(UpiLink.build(vpa: 'gym@upi', payeeName: ' ', amountPaise: 100005, note: 'x'));
      expect(uri.queryParameters['am'], '1000.05');
      expect(uri.queryParameters['pn'], 'ABS Fitness');
      expect(uri.queryParameters.containsKey('tr'), isFalse);
    });

    test('validates the UPI ID and amount', () {
      expect(UpiLink.isValidVpa('name.surname@okicici'), isTrue);
      expect(UpiLink.isValidVpa('9876543210@ybl'), isTrue);
      expect(UpiLink.isValidVpa('no-at-sign'), isFalse);
      expect(UpiLink.isValidVpa('a@1bank'), isFalse);
      expect(() => UpiLink.build(vpa: 'bad', payeeName: 'x', amountPaise: 100, note: ''), throwsArgumentError);
      expect(() => UpiLink.build(vpa: 'ab@upi', payeeName: 'x', amountPaise: 0, note: ''), throwsArgumentError);
    });

    test('keeps the note within 50 characters', () {
      final uri = Uri.parse(UpiLink.build(vpa: 'ab@upi', payeeName: 'x', amountPaise: 100, note: 'n' * 80));
      expect(uri.queryParameters['tn'], hasLength(50));
    });
  });

  group('Invoice helpers', () {
    final invoices = sampleInvoices();
    final paid = invoices[0];
    final partial = invoices[1];
    final dueSoon = invoices[2];

    test('days overdue counts from the next due date in IST', () {
      // Priya's next due date was 14 Oct; the pinned clock is 3 Nov.
      expect(partial.daysOverdue(), 20);
      expect(partial.isOverdue(), isTrue);
      expect(dueSoon.daysOverdue(), 0);
      expect(paid.daysOverdue(), 0);
    });

    test('a void or paid invoice is never overdue', () {
      expect(partial.copyWith(status: InvoiceStatus.voided).isOverdue(), isFalse);
    });

    test('next instalment amount follows the plan and what is paid', () {
      final split = partial.copyWith(
        paidPaise: 50000,
        instalments: [
          Instalment(id: 'a', seq: 1, dueDate: DateTime.utc(2026, 10, 7), amountPaise: 100000),
          Instalment(id: 'b', seq: 2, dueDate: DateTime.utc(2026, 11, 7), amountPaise: 100000),
        ],
      );
      expect(split.nextInstalmentDuePaise(), 50000);
      expect(split.copyWith(paidPaise: 100000).nextInstalmentDuePaise(), 100000);
      expect(partial.nextInstalmentDuePaise(), partial.balancePaise);
    });

    test('parses the database row shape, including the "void" status', () {
      final inv = Invoice.fromJson(
        jsonDecode('''{
          "id": "i", "invoice_no": "ABS/26-27/0007", "member_id": null, "member_name": "Asha",
          "member_code": "ABS-0007", "issue_date": "2026-11-03", "due_date": "2026-11-03",
          "next_due_date": null, "total_paise": 118000, "cgst_paise": 9000, "sgst_paise": 9000,
          "status": "void", "invoice_items": [], "instalments": [], "payments": []
        }''') as Map<String, dynamic>,
      );
      expect(inv.status, InvoiceStatus.voided);
      expect(inv.gstPaise, 18000);
      expect(inv.issueDate, DateTime.utc(2026, 11, 3));
    });

    test('payment status and mode use the wire names', () {
      final p = Payment.fromJson({
        'id': 'p',
        'member_name': 'Asha',
        'amount_paise': 1000,
        'refunded_paise': 200,
        'mode': 'bank',
        'paid_at': '2026-11-03T05:00:00Z',
        'paid_on': '2026-11-03',
        'status': 'pending_verification',
      });
      expect(p.mode, PaymentMode.bank);
      expect(p.mode.needsReference, isTrue);
      expect(p.status, PaymentStatus.pendingVerification);
      expect(p.netPaise, 800);
    });

    test('billing profile reads JSON flags and blanks', () {
      const b = BillingProfile({'gym_name': 'ABS', 'upi_id': ' ', 'gst_enabled': true, 'razorpay_enabled': 'true'});
      expect(b.upiId, isNull);
      expect(b.gstEnabled, isTrue);
      expect(b.razorpayEnabled, isTrue);
      expect(b.gstInclusive, isTrue);
    });
  });

  group('Revenue periods', () {
    test('today, Monday-start week and calendar month in IST', () {
      // Tue 3 Nov 2026, 00:30 IST is still 2 Nov in UTC.
      final now = DateTime.utc(2026, 11, 2, 19);
      expect(periodRange(RevenuePeriod.today, now: now), (DateTime.utc(2026, 11, 3), DateTime.utc(2026, 11, 3)));
      expect(periodRange(RevenuePeriod.week, now: now), (DateTime.utc(2026, 11, 2), DateTime.utc(2026, 11, 3)));
      expect(periodRange(RevenuePeriod.month, now: now), (DateTime.utc(2026, 11), DateTime.utc(2026, 11, 3)));
    });
  });

  group('Fake payments behave like the database', () {
    test('partial, then overpayment becomes credit', () async {
      final repo = FakePaymentsRepository();
      final r1 = await repo.collect(invoiceId: 'inv-4', amountPaise: 100000, mode: PaymentMode.cash);
      expect(r1.balancePaise, 300000);
      expect((await repo.invoice('inv-4')).status, InvoiceStatus.partial);
      final r2 = await repo.collect(invoiceId: 'inv-4', amountPaise: 350000, mode: PaymentMode.cash);
      expect(r2.creditPaise, 50000);
      expect(r2.balancePaise, 0);
      expect(await repo.creditBalance('m-4'), 50000);
    });

    test('a closed day blocks collection', () async {
      final repo = FakePaymentsRepository();
      await repo.closeDay(countedCashPaise: 0);
      expect(repo.collect(invoiceId: 'inv-4', amountPaise: 100, mode: PaymentMode.cash), throwsA(anything));
    });
  });

  group('Receipt PDF', () {
    test('builds an A5 receipt under 150 KB in under a second', () async {
      final fonts = await ReceiptFonts.load();
      final invoice = sampleInvoices()[1];
      final sw = Stopwatch()..start();
      final bytes = await buildReceiptPdf(
        gym: const ReceiptGym(
          name: 'ABS Fitness Zone',
          address: 'Boring Road, Patna',
          phone: '+919812345678',
          gstin: '10ABCDE1234F1Z5',
        ),
        invoice: invoice,
        payment: invoice.payments.first,
        fonts: fonts,
      );
      sw.stop();
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, lessThan(150 * 1024));
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });
  });
}
