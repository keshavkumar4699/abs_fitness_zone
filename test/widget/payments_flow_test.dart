import 'package:abs_fitness/app/router.dart';
import 'package:abs_fitness/features/payments/domain/payment_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/payment_fakes.dart';
import '../helpers/pump.dart';

Future<void> settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

const tall = Size(390, 1800);

Finder vis(String text) => find.text(text).hitTestable();

Future<void> go(WidgetTester tester, dynamic container, String route) async {
  container.read(routerProvider).go(route);
  await settle(tester);
}

/// Types an amount on the collect keypad after clearing it.
Future<void> typeAmount(WidgetTester tester, String digits) async {
  for (var i = 0; i < 10; i++) {
    await tester.tap(find.byKey(const ValueKey('key-Delete digit')));
    await tester.pump();
  }
  for (final d in digits.split('')) {
    await tester.tap(find.byKey(ValueKey('key-$d')));
    await tester.pump();
  }
}

void main() {
  testWidgets('desk collects a part payment in cash and sees the receipt', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: deskUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPayments);

    // Today's own collections: Priya's ₹1,000 UPI from this morning.
    expect(find.text('Your collections today'), findsOneWidget);
    await tester.tap(vis('Overdue 2'));
    await settle(tester);
    expect(vis('Sneha Kumari'), findsOneWidget);
    expect(vis('3 days overdue'), findsOneWidget);

    await tester.tap(vis('Collect').first);
    await settle(tester);
    expect(find.text('Collect payment'), findsOneWidget);
    // Opens on the full balance (₹1,000 for Priya, the most overdue).
    expect(find.text('Full ₹1,000'), findsOneWidget);
    await typeAmount(tester, '600');
    expect(find.text('₹400 will still be due'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('collect-confirm')));
    await settle(tester, 20);

    expect(find.text('Payment received!'), findsOneWidget);
    expect(find.textContaining('RCPT/26-27/0010'), findsOneWidget);
    expect(pay.calls, contains('collect:inv-2:60000:cash'));
    expect(pay.store.firstWhere((i) => i.id == 'inv-2').balancePaise, 40000);

    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.text('Payment received!'), findsNothing);
  });

  testWidgets('UPI needs a UTR, and paying more than due saves credit', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: deskUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.invoiceDetail('inv-4'));
    expect(find.text('Sneha Kumari'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('invoice-collect')));
    await settle(tester);

    await typeAmount(tester, '4500');
    expect(find.text('₹500 extra is saved as credit'), findsOneWidget);
    await tester.tap(find.text('UPI'));
    await settle(tester, 4);
    await tester.tap(find.byKey(const ValueKey('collect-confirm')));
    await settle(tester);
    expect(find.text('Enter the UPI / bank reference (at least 6 characters).'), findsOneWidget);
    expect(pay.calls, isEmpty);

    await tester.enterText(find.byKey(const ValueKey('collect-utr')).hitTestable(), '312345678901');
    await tester.tap(find.byKey(const ValueKey('collect-confirm')));
    await settle(tester, 20);
    expect(find.text('Payment received!'), findsOneWidget);
    expect(find.text('₹500 saved as credit'), findsOneWidget);
    expect(pay.credits['m-4'], 50000);
    expect(pay.store.firstWhere((i) => i.id == 'inv-4').status, InvoiceStatus.paid);
  });

  testWidgets('desk approves a member UPI claim; rejecting needs a reason', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: deskUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.staffPayments);
    await tester.tap(vis('To verify 1'));
    await settle(tester);
    expect(vis('Rohit Yadav'), findsOneWidget);
    expect(find.textContaining('UTR ROHITUPI1234'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('reject-pay-3')));
    await settle(tester);
    expect(find.text('Reject this payment?'), findsOneWidget);
    final confirm = tester.widget<TextButton>(find.byKey(const ValueKey('reason-confirm')));
    expect(confirm.onPressed, isNull, reason: 'a reason is required');
    await tester.tap(find.text('Cancel'));
    await settle(tester);

    await tester.tap(find.byKey(const ValueKey('approve-pay-3')));
    await settle(tester);
    expect(find.textContaining('Approved. Receipt RCPT/26-27/'), findsOneWidget);
    expect(pay.store.firstWhere((i) => i.id == 'inv-3').status, InvoiceStatus.paid);
    expect(vis('Nothing to verify'), findsOneWidget);
  });

  testWidgets('day close shows the cash difference, locks, and blocks collecting', (tester) async {
    final pay = FakePaymentsRepository();
    await pay.collect(invoiceId: 'inv-4', amountPaise: 150000, mode: PaymentMode.cash);
    final c = await pumpApp(tester, user: deskUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.dayClose);
    expect(find.text('Close the day'), findsOneWidget);
    expect(find.text('Expected cash ₹1,500'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('counted-cash')), '1400');
    await settle(tester, 2);
    expect(find.text('₹100 short'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('day-close-confirm')));
    await settle(tester, 20);
    expect(pay.calls, contains('closeDay:140000'));
    expect(find.byKey(const ValueKey('day-closed-banner')), findsOneWidget);

    await go(tester, c, Routes.invoiceDetail('inv-2'));
    await tester.tap(find.byKey(const ValueKey('invoice-collect')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('collect-confirm')));
    await settle(tester);
    expect(find.text('Your day is closed; ask the owner to reopen it.'), findsOneWidget);
  });

  testWidgets('owner dashboard shows revenue and overdue; trainers see no money', (tester) async {
    final c = await pumpApp(tester, user: ownerUser, size: tall);
    await settle(tester);
    expect(find.byKey(const ValueKey('revenue-hero')), findsOneWidget);
    expect(find.text('₹1,000'), findsWidgets); // Priya's UPI this morning.
    expect(find.byKey(const ValueKey('overdue-tile')), findsOneWidget);
    expect(find.textContaining('₹4,000 overdue since 31 Oct 2026'), findsOneWidget);
    await tester.tap(find.text('This month'));
    await settle(tester);
    expect(find.text('Collected'), findsOneWidget);
    c.dispose();
  });

  testWidgets('trainers get a friendly no-payments page and no dues tiles', (tester) async {
    final c = await pumpApp(tester, user: trainerUser, size: tall);
    await settle(tester);
    expect(find.byKey(const ValueKey('revenue-hero')), findsNothing);
    expect(find.byKey(const ValueKey('overdue-tile')), findsNothing);
    await go(tester, c, Routes.staffPayments);
    expect(find.text('Payments are with the desk'), findsOneWidget);
    await go(tester, c, Routes.invoiceDetail('inv-1'));
    expect(c.read(routerProvider).state.matchedLocation, Routes.staffPayments);
  });

  testWidgets('owner splits an invoice into instalments that must add up', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: ownerUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.invoiceDetail('inv-4'));
    await tester.tap(find.byKey(const ValueKey('split-invoice')));
    await settle(tester);
    expect(find.text('Up to 4 parts that add up to ₹4,000.'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('part-amount-1')), '1000');
    await tester.tap(find.byKey(const ValueKey('split-save')));
    await settle(tester);
    expect(find.byKey(const ValueKey('split-error')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('part-amount-1')), '2000');
    await tester.tap(find.byKey(const ValueKey('split-save')));
    await settle(tester);
    expect(pay.calls, contains('instalments:inv-4:2'));
    expect(find.text('Part 2'), findsOneWidget);
  });

  testWidgets('owner voids an unpaid invoice with a reason', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: ownerUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.invoiceDetail('inv-4'));
    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.text('Void invoice').last);
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('reason-field')), 'Billed twice');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('reason-confirm')));
    await settle(tester);
    expect(pay.calls, contains('voidInvoice:inv-4'));
    expect(find.text('Voided: Billed twice'), findsOneWidget);
  });

  testWidgets('member sees fees due, pays by UPI and taps "I\'ve paid"', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(
      tester,
      user: memberUser.copyWith(memberId: 'm-4', name: 'Sneha Kumari'),
      payments: pay,
      prefs: {'member_onboarding_done': true},
      size: tall,
    );
    await settle(tester);
    expect(find.text('Fees due'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('fees-card')));
    await settle(tester);
    expect(c.read(routerProvider).state.matchedLocation, Routes.mePayments);
    await tester.tap(vis('Pay now'));
    await settle(tester);
    expect(find.byKey(const ValueKey('pay-upi')), findsOneWidget);
    expect(find.text('absfitness@okhdfc'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('i-paid')));
    await settle(tester);
    await tester.enterText(find.byKey(const ValueKey('claim-utr')), '123');
    await tester.tap(find.byKey(const ValueKey('claim-send')));
    await settle(tester);
    expect(find.byKey(const ValueKey('claim-error')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('claim-utr')), 'SNEHAUPI4455');
    await tester.tap(find.byKey(const ValueKey('claim-send')));
    await settle(tester);
    expect(pay.calls, contains('claim:inv-4:400000:SNEHAUPI4455'));
    expect(find.text('₹4,000 waiting for the desk to check'), findsOneWidget);
  });

  testWidgets('owner adds an expense and the month total updates', (tester) async {
    final pay = FakePaymentsRepository();
    final c = await pumpApp(tester, user: ownerUser, payments: pay, size: tall);
    await settle(tester);
    await go(tester, c, Routes.expenses);
    expect(find.text('Spent in November 2026'), findsOneWidget);
    expect(find.text('₹9,700'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('add-expense')));
    await settle(tester);
    await tester.tap(find.text('Salaries'));
    await tester.enterText(find.byKey(const ValueKey('expense-amount')), '12000');
    await tester.tap(find.byKey(const ValueKey('expense-save')));
    await settle(tester, 20);
    expect(pay.calls, contains('expense:salaries:1200000'));
    expect(find.text('₹21,700'), findsOneWidget);
  });

  testWidgets('desk cannot open expenses; history filters by mode', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.expenses);
    expect(c.read(routerProvider).state.matchedLocation, Routes.staffMore);

    await go(tester, c, Routes.paymentHistory);
    expect(vis('Aarav Sharma'), findsOneWidget);
    expect(vis('Priya Verma'), findsOneWidget);
    await tester.tap(vis('Cash'));
    await settle(tester);
    expect(vis('Aarav Sharma'), findsOneWidget);
    expect(vis('Priya Verma'), findsNothing);
  });

  testWidgets('member detail has a Payments tab and dues sticker for the desk', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberDetail('m-2'));
    expect(find.byKey(const ValueKey('member-dues')), findsOneWidget);
    await tester.tap(vis('Payments'));
    await settle(tester);
    expect(vis('Monthly'), findsWidgets);
    expect(find.textContaining('RCPT/26-27/0002'), findsWidgets);
  });

  testWidgets('trainer member detail has no Collect and no Payments tab', (tester) async {
    final c = await pumpApp(tester, user: trainerUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.memberDetail('m-1'));
    expect(find.text('Collect'), findsNothing);
    expect(find.text('Payments'), findsNothing);
  });

  testWidgets('check-in mentions pending fees', (tester) async {
    final c = await pumpApp(tester, user: deskUser, size: tall);
    await settle(tester);
    await go(tester, c, Routes.checkIn);
    await tester.enterText(find.widgetWithText(TextFormField, 'Search member to check in'), 'priya');
    await settle(tester);
    await tester.tap(find.text('Priya Verma'));
    await settle(tester, 4);
    expect(find.byKey(const ValueKey('check-in-dues')), findsOneWidget);
    expect(find.text('₹1,000 fees pending'), findsOneWidget);
    await settle(tester, 30);
  });
}
