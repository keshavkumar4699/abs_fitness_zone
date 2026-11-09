// WhatsApp Cloud API webhook (F8 API mode).
// GET: Meta's verification handshake (WHATSAPP_VERIFY_TOKEN).
// POST: delivery/read receipts and member replies, signed with the app
// secret (WHATSAPP_APP_SECRET). STOP/START from a member turns their
// messages off/on. A reply opens the free 24-hour window, so their due
// utility messages go out at once.
import { adminClient } from "../_shared/clients.ts";
import { corsHeaders, error, json } from "../_shared/http.ts";
import { parseWebhook, rpcDeps, runSend, verifyChallenge, verifyMetaSignature } from "../_shared/whatsapp.ts";

Deno.serve(async (req) => {
  try {
    if (req.method === "GET") {
      const challenge = verifyChallenge(new URL(req.url), Deno.env.get("WHATSAPP_VERIFY_TOKEN") ?? "");
      return challenge === null
        ? error(403, "verification failed")
        : new Response(challenge, { headers: { ...corsHeaders, "Content-Type": "text/plain" } });
    }
    if (req.method !== "POST") return error(405, "method not allowed");

    const raw = await req.text();
    const ok = await verifyMetaSignature(
      raw,
      req.headers.get("x-hub-signature-256"),
      Deno.env.get("WHATSAPP_APP_SECRET") ?? "",
    );
    if (!ok) return error(401, "bad signature");
    let payload: unknown;
    try {
      payload = JSON.parse(raw);
    } catch {
      return error(400, "bad json");
    }

    const phoneNumberId = Deno.env.get("WHATSAPP_PHONE_NUMBER_ID") ?? "";
    const events = parseWebhook(payload, phoneNumberId || undefined);
    const admin = adminClient();

    for (const s of events.statuses) {
      const { error: e } = await admin.rpc("whatsapp_status", {
        p_wa_id: s.waId,
        p_status: s.status,
        p_error: s.error,
      });
      if (e) console.error("whatsapp_status", e);
    }

    let windowOpened = false;
    for (const m of events.inbound) {
      const { data, error: e } = await admin.rpc("whatsapp_inbound", { p_phone: m.from, p_text: m.text });
      if (e) console.error("whatsapp_inbound", e);
      else if (Array.isArray(data?.send_now) && data.send_now.length > 0) windowOpened = true;
    }

    // Send what a reply made free right away; anything else waits for cron.
    const token = Deno.env.get("WHATSAPP_TOKEN");
    if (windowOpened && token && phoneNumberId) {
      const { data: settings } = await admin.rpc("whatsapp_settings");
      if (settings?.mode === "api") {
        await runSend(rpcDeps(admin, { token, phoneNumberId }), 20);
      }
    }
    // Always 200 for a signed call, so Meta does not retry what we handled.
    return json({ ok: true, statuses: events.statuses.length, inbound: events.inbound.length });
  } catch (e) {
    console.error(e);
    return error(500, "internal error");
  }
});
