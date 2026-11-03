// Razorpay helpers (optional gateway, F2 2.4). Pure functions are unit-tested.

const encoder = new TextEncoder();

function toHex(buf: ArrayBuffer): string {
  return Array.from(new Uint8Array(buf), (b) => b.toString(16).padStart(2, "0")).join("");
}

/** Constant-time comparison of two hex strings. */
export function safeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

export async function hmacSha256Hex(secret: string, body: string): Promise<string> {
  const key = await crypto.subtle.importKey("raw", encoder.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, [
    "sign",
  ]);
  return toHex(await crypto.subtle.sign("HMAC", key, encoder.encode(body)));
}

/** Razorpay signs the raw webhook body with the webhook secret (hex HMAC-SHA256). */
export async function verifyWebhookSignature(body: string, signature: string | null, secret: string): Promise<boolean> {
  if (!signature || !secret) return false;
  return safeEqual(await hmacSha256Hex(secret, body), signature.trim().toLowerCase());
}

export interface PaidEvent {
  eventId: string;
  invoiceId: string;
  amountPaise: number;
  paymentId: string;
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Pulls what we need from a `payment_link.paid` event; null for anything else. */
export function parsePaidEvent(payload: unknown, headerEventId: string | null): PaidEvent | null {
  // deno-lint-ignore no-explicit-any
  const p = payload as any;
  if (!p || p.event !== "payment_link.paid") return null;
  const link = p.payload?.payment_link?.entity;
  const payment = p.payload?.payment?.entity;
  const invoiceId = link?.reference_id ?? link?.notes?.invoice_id;
  const amount = Number(payment?.amount ?? link?.amount_paid);
  const paymentId = String(payment?.id ?? "");
  if (typeof invoiceId !== "string" || !UUID.test(invoiceId)) return null;
  if (!Number.isInteger(amount) || amount <= 0 || !paymentId) return null;
  return { eventId: headerEventId?.trim() || `payment:${paymentId}`, invoiceId, amountPaise: amount, paymentId };
}

/** Body for POST /v1/payment_links. */
export function paymentLinkBody(invoice: {
  id: string;
  invoice_no: string;
  balance_paise: number;
  member_name: string;
  member_phone: string | null;
}) {
  return {
    amount: invoice.balance_paise,
    currency: "INR",
    accept_partial: false,
    reference_id: invoice.id,
    description: `ABS Fitness ${invoice.invoice_no}`,
    customer: { name: invoice.member_name, ...(invoice.member_phone ? { contact: invoice.member_phone } : {}) },
    notify: { sms: false, email: false },
    reminder_enable: false,
    notes: { invoice_id: invoice.id },
  };
}
