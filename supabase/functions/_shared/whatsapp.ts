// WhatsApp Cloud API helpers for API mode (F8). Pure functions are
// unit-tested; the two Edge Functions stay thin. Free mode never touches
// this file: staff send from their own phone with wa.me links.
import { hmacSha256Hex, safeEqual } from "./razorpay.ts";

export const GRAPH_VERSION = "v21.0";

/** One claimed row from `whatsapp_claim`. */
export interface QueueRow {
  id: string;
  member_id: string;
  phone: string | null;
  body: string;
  params: unknown;
  meta_template_name: string | null;
  language: string;
  category: "utility" | "marketing";
  in_window: boolean;
}

export interface SendOutcome {
  ok: boolean;
  waId?: string;
  error?: string;
  /** True when retrying through the API can never work (no template, bad number). */
  final?: boolean;
  /** True when the whole run should stop (the access token is refused). */
  abort?: boolean;
  /** True when sent as a free session message inside the 24-hour window. */
  free?: boolean;
}

/** Digits only, with the India country code added to a 10-digit number. */
export function toWaNumber(phone: string | null | undefined): string | null {
  let d = (phone ?? "").replace(/\D/g, "");
  if (d.length === 11 && d.startsWith("0")) d = d.slice(1);
  if (d.length === 10) return `91${d}`;
  if (d.length >= 11 && d.length <= 15) return d;
  return null;
}

/** Template parameters as strings, in order. */
export function templateParams(params: unknown): string[] {
  if (!Array.isArray(params)) return [];
  return params.map((p) => (p === null || p === undefined ? "" : String(p)));
}

/**
 * The Cloud API body for one row. Inside the 24-hour window a plain text
 * message is free and needs no template; outside it only an approved
 * template may be sent. Null when there is nothing we are allowed to send.
 */
export function buildMessage(row: QueueRow, to: string, asSession: boolean): Record<string, unknown> | null {
  if (asSession) {
    return {
      messaging_product: "whatsapp",
      recipient_type: "individual",
      to,
      type: "text",
      text: { preview_url: false, body: row.body },
    };
  }
  if (!row.meta_template_name) return null;
  const params = templateParams(row.params);
  return {
    messaging_product: "whatsapp",
    recipient_type: "individual",
    to,
    type: "template",
    template: {
      name: row.meta_template_name,
      language: { code: row.language === "hi" ? "hi" : "en" },
      ...(params.length
        ? { components: [{ type: "body", parameters: params.map((text) => ({ type: "text", text })) }] }
        : {}),
    },
  };
}

// Errors that will fail the same way however often we retry: template
// missing, paused or mismatched; number not on WhatsApp; bad parameters.
const FINAL_CODES = new Set([
  100,
  131008,
  131009,
  131021,
  131026,
  131030,
  131051,
  132000,
  132001,
  132005,
  132007,
  132012,
  132015,
  132016,
  132068,
  132069,
]);
// Rate limits and Meta-side hiccups: try again on the next run.
const RETRY_CODES = new Set([4, 80007, 130429, 131000, 131016, 131048, 131056, 133004]);
// The access token is wrong or expired: stop the run instead of failing
// every message one by one.
const AUTH_CODES = new Set([190, 10, 200]);
/** Sent free text outside the window: retry as a template. */
export const OUTSIDE_WINDOW = 131047;

export interface ApiError {
  code: number | null;
  message: string;
}

export function readApiError(body: unknown): ApiError {
  // deno-lint-ignore no-explicit-any
  const e = (body as any)?.error;
  const code = Number(e?.code);
  const detail = e?.error_data?.details ?? e?.message ?? "WhatsApp error";
  return { code: Number.isFinite(code) ? code : null, message: String(detail).slice(0, 300) };
}

/** Decides what a failed Cloud API call means for the message. */
export function classifyError(status: number, body: unknown): SendOutcome {
  const err = readApiError(body);
  const error = err.code ? `${err.code}: ${err.message}` : `HTTP ${status}: ${err.message}`;
  if (status === 401 || (err.code !== null && AUTH_CODES.has(err.code))) return { ok: false, error, abort: true };
  if (status === 429 || status >= 500 || (err.code !== null && RETRY_CODES.has(err.code))) return { ok: false, error };
  if (err.code !== null && FINAL_CODES.has(err.code)) return { ok: false, error, final: true };
  return { ok: false, error, final: status >= 400 && status < 500 };
}

export interface ApiConfig {
  token: string;
  phoneNumberId: string;
  fetch?: typeof fetch;
}

async function post(cfg: ApiConfig, payload: Record<string, unknown>): Promise<SendOutcome & { code?: number | null }> {
  const f = cfg.fetch ?? fetch;
  let res: Response;
  try {
    res = await f(`https://graph.facebook.com/${GRAPH_VERSION}/${cfg.phoneNumberId}/messages`, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${cfg.token}` },
      body: JSON.stringify(payload),
    });
  } catch (e) {
    return { ok: false, error: `network: ${String(e).slice(0, 200)}` };
  }
  let body: unknown = null;
  try {
    body = await res.json();
  } catch {
    body = null;
  }
  if (res.ok) {
    // deno-lint-ignore no-explicit-any
    const waId = (body as any)?.messages?.[0]?.id;
    if (typeof waId === "string" && waId) return { ok: true, waId };
    return { ok: false, error: "no message id in reply" };
  }
  return { ...classifyError(res.status, body), code: readApiError(body).code };
}

/**
 * Sends one row. Inside the window it tries free text first and falls back
 * to the template when Meta says the window has closed.
 */
export async function sendRow(cfg: ApiConfig, row: QueueRow): Promise<SendOutcome> {
  const to = toWaNumber(row.phone);
  if (!to) return { ok: false, error: "no valid phone number", final: true };
  if (row.in_window) {
    const r = await post(cfg, buildMessage(row, to, true)!);
    if (r.ok) return { ok: true, waId: r.waId, free: true };
    if (r.code !== OUTSIDE_WINDOW) return strip(r);
  }
  const payload = buildMessage(row, to, false);
  if (!payload) return { ok: false, error: "no approved WhatsApp template for this message", final: true };
  return strip(await post(cfg, payload));
}

function strip(r: SendOutcome & { code?: number | null }): SendOutcome {
  const { code: _code, ...rest } = r;
  return rest;
}

export interface SendDeps {
  claim(limit: number): Promise<QueueRow[]>;
  result(id: string, outcome: SendOutcome): Promise<string>;
  send(row: QueueRow): Promise<SendOutcome>;
}

export interface RunSummary {
  claimed: number;
  sent: number;
  retry: number;
  moved: number;
  aborted: boolean;
}

/** Claims due rows, sends them one at a time and records each outcome. */
export async function runSend(deps: SendDeps, limit: number): Promise<RunSummary> {
  const rows = await deps.claim(limit);
  const summary: RunSummary = { claimed: rows.length, sent: 0, retry: 0, moved: 0, aborted: false };
  for (const row of rows) {
    // After a refused token, the rest go back to the queue untouched by Meta.
    const outcome = summary.aborted ? { ok: false, error: "not sent: WhatsApp login failed" } : await deps.send(row);
    if (outcome.abort) summary.aborted = true;
    const r = await deps.result(row.id, outcome);
    if (r === "sent") summary.sent++;
    else if (r === "moved") summary.moved++;
    else if (r === "retry") summary.retry++;
  }
  return summary;
}

/** The slice of a Supabase client the send loop needs (easy to fake in tests). */
export interface RpcClient {
  rpc(fn: string, args?: Record<string, unknown>): PromiseLike<{ data: unknown; error: unknown }>;
}

/** Wires the send loop to the database RPCs and the Cloud API. */
export function rpcDeps(db: RpcClient, cfg: ApiConfig): SendDeps {
  return {
    claim: async (limit) => {
      const { data, error } = await db.rpc("whatsapp_claim", { p_limit: limit });
      if (error) throw error;
      return (data ?? []) as QueueRow[];
    },
    send: (row) => sendRow(cfg, row),
    result: async (id, o) => {
      const { data, error } = await db.rpc("whatsapp_result", {
        p_id: id,
        p_ok: o.ok,
        p_wa_id: o.waId ?? null,
        p_error: o.error ?? null,
        p_free: o.free ?? false,
        p_final: o.final ?? false,
      });
      if (error) {
        // The row stays 'sending' and goes back to the queue after 15 minutes.
        console.error("whatsapp_result", id, error);
        return "error";
      }
      return String(data);
    },
  };
}

/** Clamps the batch size a caller asks for. */
export function batchSize(v: unknown, fallback = 50): number {
  const n = Number(v);
  if (!Number.isInteger(n) || n < 1) return fallback;
  return Math.min(n, 200);
}

// ---------------------------------------------------------------------------
// Webhook
// ---------------------------------------------------------------------------

/** Meta signs the raw body with the app secret: `sha256=<hex>`. */
export async function verifyMetaSignature(raw: string, header: string | null, appSecret: string): Promise<boolean> {
  if (!header || !appSecret) return false;
  const [algo, sig] = header.trim().split("=", 2);
  if (algo !== "sha256" || !sig) return false;
  return safeEqual(await hmacSha256Hex(appSecret, raw), sig.toLowerCase());
}

/** The GET handshake Meta makes when the webhook URL is saved. */
export function verifyChallenge(url: URL, verifyToken: string): string | null {
  const mode = url.searchParams.get("hub.mode");
  const token = url.searchParams.get("hub.verify_token") ?? "";
  const challenge = url.searchParams.get("hub.challenge");
  if (mode !== "subscribe" || !verifyToken || !challenge) return null;
  if (token.length !== verifyToken.length || !safeEqual(token, verifyToken)) return null;
  return challenge;
}

export interface StatusEvent {
  waId: string;
  status: "sent" | "delivered" | "read" | "failed";
  error: string | null;
}

export interface InboundEvent {
  from: string;
  text: string;
}

export interface WebhookEvents {
  statuses: StatusEvent[];
  inbound: InboundEvent[];
}

const STATUSES = new Set(["sent", "delivered", "read", "failed"]);

/**
 * Receipts and incoming messages from a webhook call. Changes for another
 * phone number on the same business account are ignored.
 */
export function parseWebhook(payload: unknown, phoneNumberId?: string): WebhookEvents {
  const out: WebhookEvents = { statuses: [], inbound: [] };
  // deno-lint-ignore no-explicit-any
  const p = payload as any;
  if (!p || p.object !== "whatsapp_business_account" || !Array.isArray(p.entry)) return out;
  for (const entry of p.entry) {
    for (const change of Array.isArray(entry?.changes) ? entry.changes : []) {
      if (change?.field !== "messages") continue;
      const value = change.value ?? {};
      if (phoneNumberId && value.metadata?.phone_number_id && value.metadata.phone_number_id !== phoneNumberId) {
        continue;
      }
      for (const s of Array.isArray(value.statuses) ? value.statuses : []) {
        if (typeof s?.id !== "string" || !STATUSES.has(s.status)) continue;
        const e = Array.isArray(s.errors) ? s.errors[0] : null;
        const error = e
          ? `${e.code ?? ""}: ${e.error_data?.details ?? e.message ?? e.title ?? "failed"}`.slice(0, 300)
          : null;
        out.statuses.push({ waId: s.id, status: s.status, error });
      }
      for (const m of Array.isArray(value.messages) ? value.messages : []) {
        if (typeof m?.from !== "string") continue;
        const text = m.text?.body ?? m.button?.text ?? m.interactive?.button_reply?.title ?? "";
        out.inbound.push({ from: m.from, text: String(text).slice(0, 500) });
      }
    }
  }
  return out;
}
