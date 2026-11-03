// Razorpay webhook (payment_link.paid). Verifies the signature on the raw
// body with RAZORPAY_WEBHOOK_SECRET, then records the payment. Recording is
// idempotent on the event id, so retries never double-credit.
import { adminClient } from "../_shared/clients.ts";
import { error, json } from "../_shared/http.ts";
import { parsePaidEvent, verifyWebhookSignature } from "../_shared/razorpay.ts";

Deno.serve(async (req) => {
  if (req.method !== "POST") return error(405, "method not allowed");
  const raw = await req.text();
  const ok = await verifyWebhookSignature(
    raw,
    req.headers.get("x-razorpay-signature"),
    Deno.env.get("RAZORPAY_WEBHOOK_SECRET") ?? "",
  );
  if (!ok) return error(400, "bad signature");

  let payload: unknown;
  try {
    payload = JSON.parse(raw);
  } catch {
    return error(400, "bad json");
  }
  const event = parsePaidEvent(payload, req.headers.get("x-razorpay-event-id"));
  if (!event) return json({ ignored: true }); // Other events are acknowledged.

  const { data, error: rpcError } = await adminClient().rpc("record_gateway_payment", {
    p_invoice_id: event.invoiceId,
    p_amount_paise: event.amountPaise,
    p_event_id: event.eventId,
    p_gateway_payment_id: event.paymentId,
  });
  if (rpcError) {
    console.error(rpcError);
    // 5xx makes Razorpay retry later; the retry is safe (idempotent).
    return error(500, "could not record");
  }
  return json({ ok: true, duplicate: data?.duplicate ?? false });
});
