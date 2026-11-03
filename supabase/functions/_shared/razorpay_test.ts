import { assert, assertEquals, assertFalse } from "jsr:@std/assert@1";
import { hmacSha256Hex, parsePaidEvent, paymentLinkBody, safeEqual, verifyWebhookSignature } from "./razorpay.ts";

const INVOICE = "6f1c7f2e-1d2b-4c3a-9a8b-0c1d2e3f4a5b";

Deno.test("HMAC matches a known vector", async () => {
  // RFC 4231 test case 2.
  assertEquals(
    await hmacSha256Hex("Jefe", "what do ya want for nothing?"),
    "5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843",
  );
});

Deno.test("webhook signature: valid, tampered, missing", async () => {
  const body = JSON.stringify({ event: "payment_link.paid" });
  const sig = await hmacSha256Hex("whsec", body);
  assert(await verifyWebhookSignature(body, sig, "whsec"));
  assert(await verifyWebhookSignature(body, sig.toUpperCase(), "whsec"));
  assertFalse(await verifyWebhookSignature(body + " ", sig, "whsec"));
  assertFalse(await verifyWebhookSignature(body, sig, "other"));
  assertFalse(await verifyWebhookSignature(body, null, "whsec"));
  assertFalse(await verifyWebhookSignature(body, sig, ""));
});

Deno.test("safeEqual", () => {
  assert(safeEqual("abc", "abc"));
  assertFalse(safeEqual("abc", "abd"));
  assertFalse(safeEqual("abc", "ab"));
});

Deno.test("parsePaidEvent reads payment_link.paid", () => {
  const evt = parsePaidEvent({
    event: "payment_link.paid",
    payload: {
      payment_link: { entity: { id: "plink_1", reference_id: INVOICE, amount_paid: 150000 } },
      payment: { entity: { id: "pay_1", amount: 150000 } },
    },
  }, "evt_abc");
  assertEquals(evt, { eventId: "evt_abc", invoiceId: INVOICE, amountPaise: 150000, paymentId: "pay_1" });
});

Deno.test("parsePaidEvent ignores other events and bad data", () => {
  assertEquals(parsePaidEvent({ event: "payment.failed" }, "e"), null);
  assertEquals(parsePaidEvent({ event: "payment_link.paid", payload: {} }, "e"), null);
  assertEquals(
    parsePaidEvent({
      event: "payment_link.paid",
      payload: { payment_link: { entity: { reference_id: "not-a-uuid" } }, payment: { entity: { id: "p", amount: 1 } } },
    }, "e"),
    null,
  );
  // Without an event id header the payment id keeps retries idempotent.
  assertEquals(
    parsePaidEvent({
      event: "payment_link.paid",
      payload: { payment_link: { entity: { reference_id: INVOICE } }, payment: { entity: { id: "pay_9", amount: 500 } } },
    }, null)?.eventId,
    "payment:pay_9",
  );
});

Deno.test("payment link body", () => {
  const b = paymentLinkBody({ id: INVOICE, invoice_no: "ABS/26-27/0001", balance_paise: 99900, member_name: "Riya", member_phone: null });
  assertEquals(b.amount, 99900);
  assertEquals(b.reference_id, INVOICE);
  assertEquals(b.currency, "INR");
  assertFalse("contact" in b.customer);
});
