// POST { limit? } → { claimed, sent, retry, moved, aborted } or { skipped }.
// Sends due API-mode messages through the WhatsApp Cloud API (F8 API mode).
// Called by pg_cron with `x-cron-secret: <CRON_SECRET>`, or by front desk /
// owner from the app ("Send now"). In free mode it does nothing.
// Secrets: WHATSAPP_TOKEN, WHATSAPP_PHONE_NUMBER_ID, CRON_SECRET.
import { adminClient, callerClient } from "../_shared/clients.ts";
import { error, json, readJson, serve } from "../_shared/http.ts";
import { safeEqual } from "../_shared/razorpay.ts";
import { batchSize, rpcDeps, runSend } from "../_shared/whatsapp.ts";

async function allowed(req: Request): Promise<boolean> {
  const secret = Deno.env.get("CRON_SECRET") ?? "";
  const given = req.headers.get("x-cron-secret") ?? "";
  if (secret && given) return given.length === secret.length && safeEqual(given, secret);
  if (!req.headers.get("Authorization")) return false;
  const { data } = await callerClient(req).rpc("is_desk");
  return data === true;
}

serve(async (req) => {
  if (!(await allowed(req))) return error(401, "not allowed");
  const body = (await readJson(req)) ?? {};
  const admin = adminClient();

  const { data: settings, error: settingsError } = await admin.rpc("whatsapp_settings");
  if (settingsError) throw settingsError;
  if (settings?.mode !== "api") return json({ skipped: "free mode" });

  const token = Deno.env.get("WHATSAPP_TOKEN");
  const phoneNumberId = Deno.env.get("WHATSAPP_PHONE_NUMBER_ID");
  if (!token || !phoneNumberId) return error(503, "WhatsApp API not configured");

  const summary = await runSend(rpcDeps(admin, { token, phoneNumberId }), batchSize(body.limit));
  if (summary.aborted) console.error("whatsapp: access token refused; check WHATSAPP_TOKEN");
  return json(summary);
});
