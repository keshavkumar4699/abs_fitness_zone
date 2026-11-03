// POST { invoice_id } → { url }. Creates a Razorpay Payment Link for the
// invoice balance. Caller must be front desk / owner, or the member who owns
// the invoice (checked by reading the invoice with the caller's own RLS).
// Keys live only in Edge Function secrets: RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET.
import { adminClient, callerClient } from "../_shared/clients.ts";
import { error, json, readJson, serve } from "../_shared/http.ts";
import { paymentLinkBody } from "../_shared/razorpay.ts";
import { isUuid } from "../_shared/validate.ts";

serve(async (req) => {
  const body = await readJson(req);
  if (!body || !isUuid(body.invoice_id)) return error(400, "invalid input");

  const admin = adminClient();
  const { data: enabled } = await admin.from("settings").select("value").eq("key", "razorpay_enabled").maybeSingle();
  if (enabled?.value !== true) return error(409, "online payments are turned off");

  const keyId = Deno.env.get("RAZORPAY_KEY_ID");
  const keySecret = Deno.env.get("RAZORPAY_KEY_SECRET");
  if (!keyId || !keySecret) return error(503, "gateway not configured");

  // RLS decides whether this caller may see the invoice.
  const { data: invoice } = await callerClient(req)
    .from("invoices")
    .select("id, invoice_no, balance_paise, member_name, member_phone, status")
    .eq("id", body.invoice_id)
    .maybeSingle();
  if (!invoice) return error(404, "invoice not found");
  if (invoice.status === "paid" || invoice.status === "void" || invoice.balance_paise <= 0) {
    return error(409, "nothing to pay");
  }

  const res = await fetch("https://api.razorpay.com/v1/payment_links", {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Basic ${btoa(`${keyId}:${keySecret}`)}` },
    body: JSON.stringify(paymentLinkBody(invoice)),
  });
  if (!res.ok) {
    console.error("razorpay", res.status, await res.text());
    return error(502, "gateway error");
  }
  const link = await res.json();
  await admin.rpc("set_gateway_link", { p_invoice_id: invoice.id, p_link_id: link.id, p_url: link.short_url });
  return json({ url: link.short_url });
});
