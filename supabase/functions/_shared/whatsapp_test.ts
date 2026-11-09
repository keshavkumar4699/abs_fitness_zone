import { assert, assertEquals, assertFalse } from "jsr:@std/assert@1";
import { hmacSha256Hex } from "./razorpay.ts";
import {
  batchSize,
  buildMessage,
  classifyError,
  parseWebhook,
  type QueueRow,
  rpcDeps,
  runSend,
  type SendOutcome,
  sendRow,
  toWaNumber,
  verifyChallenge,
  verifyMetaSignature,
} from "./whatsapp.ts";

const row = (over: Partial<QueueRow> = {}): QueueRow => ({
  id: "q1",
  member_id: "m1",
  phone: "+91 98765 43210",
  body: "Hi Riya, your plan ends on 10 Nov 2026.",
  params: ["Riya", "10 Nov 2026"],
  meta_template_name: "expiry_soon",
  language: "en",
  category: "utility",
  in_window: false,
  ...over,
});

Deno.test("phone numbers get the India code and lose punctuation", () => {
  assertEquals(toWaNumber("98765 43210"), "919876543210");
  assertEquals(toWaNumber("+91-98765-43210"), "919876543210");
  assertEquals(toWaNumber("09876543210"), "919876543210");
  assertEquals(toWaNumber("+1 415 555 0100"), "14155550100");
  assertEquals(toWaNumber("12345"), null);
  assertEquals(toWaNumber(null), null);
});

Deno.test("outside the window only a template is sent, with ordered parameters", () => {
  const m = buildMessage(row({ language: "hi" }), "919876543210", false);
  assertEquals(m, {
    messaging_product: "whatsapp",
    recipient_type: "individual",
    to: "919876543210",
    type: "template",
    template: {
      name: "expiry_soon",
      language: { code: "hi" },
      components: [{
        type: "body",
        parameters: [{ type: "text", text: "Riya" }, { type: "text", text: "10 Nov 2026" }],
      }],
    },
  });
  assertEquals(buildMessage(row({ meta_template_name: null }), "91", false), null);
  // A template without variables carries no components.
  // deno-lint-ignore no-explicit-any
  assertEquals((buildMessage(row({ params: [] }), "91", false) as any).template.components, undefined);
});

Deno.test("inside the window the rendered text goes as a free message", () => {
  const m = buildMessage(row({ meta_template_name: null }), "919876543210", true);
  assertEquals(m?.type, "text");
  assertEquals(m?.text, { preview_url: false, body: "Hi Riya, your plan ends on 10 Nov 2026." });
});

Deno.test("errors: final, retry and abort", () => {
  const meta = (code: number) => ({ error: { code, message: "x", error_data: { details: "detail" } } });
  assertEquals(classifyError(400, meta(132001)), { ok: false, error: "132001: detail", final: true });
  assert(classifyError(400, meta(131026)).final);
  assertFalse(classifyError(400, meta(130429)).final);
  assertFalse(classifyError(429, null).final);
  assertFalse(classifyError(503, null).final);
  assert(classifyError(401, meta(190)).abort);
  assert(classifyError(400, meta(190)).abort);
  // Unknown 4xx cannot be fixed by retrying the same request.
  assert(classifyError(400, meta(999999)).final);
});

function fakeFetch(replies: Array<[number, unknown]>) {
  const calls: Array<Record<string, unknown>> = [];
  const f = (_url: string | URL | Request, init?: RequestInit) => {
    calls.push(JSON.parse(String(init?.body)));
    const [status, body] = replies.shift() ?? [500, null];
    return Promise.resolve(new Response(JSON.stringify(body), { status }));
  };
  return { calls, fetch: f as typeof fetch };
}

Deno.test("sendRow: template outside the window", async () => {
  const { calls, fetch } = fakeFetch([[200, { messages: [{ id: "wamid.1" }] }]]);
  assertEquals(await sendRow({ token: "t", phoneNumberId: "p", fetch }, row()), { ok: true, waId: "wamid.1" });
  assertEquals(calls[0].type, "template");
});

Deno.test("sendRow: free text in the window, template when Meta says it closed", async () => {
  const open = fakeFetch([[200, { messages: [{ id: "wamid.2" }] }]]);
  assertEquals(await sendRow({ token: "t", phoneNumberId: "p", fetch: open.fetch }, row({ in_window: true })), {
    ok: true,
    waId: "wamid.2",
    free: true,
  });

  const closed = fakeFetch([[400, { error: { code: 131047, message: "re-engage" } }], [200, {
    messages: [{ id: "wamid.3" }],
  }]]);
  const r = await sendRow({ token: "t", phoneNumberId: "p", fetch: closed.fetch }, row({ in_window: true }));
  assertEquals(r, { ok: true, waId: "wamid.3" });
  assertEquals(closed.calls.map((c) => c.type), ["text", "template"]);
});

Deno.test("sendRow: no number or no template never reaches Meta", async () => {
  const { calls, fetch } = fakeFetch([]);
  const cfg = { token: "t", phoneNumberId: "p", fetch };
  assertEquals((await sendRow(cfg, row({ phone: "123" }))).final, true);
  assertEquals((await sendRow(cfg, row({ meta_template_name: null }))).final, true);
  assertEquals(calls.length, 0);
});

Deno.test("sendRow: a network failure is retried later", async () => {
  const fetch = (() => Promise.reject(new Error("offline"))) as typeof globalThis.fetch;
  const r = await sendRow({ token: "t", phoneNumberId: "p", fetch }, row());
  assertFalse(r.ok);
  assertFalse(r.final ?? false);
});

Deno.test("runSend records every outcome and stops calling Meta after a refused token", async () => {
  const outcomes: SendOutcome[] = [{ ok: true, waId: "w1" }, { ok: false, error: "190", abort: true }];
  const sent: string[] = [];
  const results: Array<[string, SendOutcome]> = [];
  const summary = await runSend({
    claim: () => Promise.resolve([row({ id: "a" }), row({ id: "b" }), row({ id: "c" })]),
    send: (r) => {
      sent.push(r.id);
      return Promise.resolve(outcomes.shift()!);
    },
    result: (id, o) => {
      results.push([id, o]);
      return Promise.resolve(o.ok ? "sent" : "retry");
    },
  }, 50);
  assertEquals(sent, ["a", "b"]);
  assertEquals(results.map(([id]) => id), ["a", "b", "c"]);
  assertEquals(summary, { claimed: 3, sent: 1, retry: 2, moved: 0, aborted: true });
});

Deno.test("rpcDeps passes the outcome to whatsapp_result", async () => {
  const calls: Array<[string, Record<string, unknown> | undefined]> = [];
  const db = {
    rpc: (fn: string, args?: Record<string, unknown>) => {
      calls.push([fn, args]);
      return Promise.resolve({ data: fn === "whatsapp_claim" ? [row()] : "moved", error: null });
    },
  };
  const deps = rpcDeps(db, { token: "t", phoneNumberId: "p", fetch: fakeFetch([]).fetch });
  assertEquals((await deps.claim(5)).length, 1);
  assertEquals(await deps.result("q1", { ok: false, error: "no template", final: true }), "moved");
  assertEquals(calls, [
    ["whatsapp_claim", { p_limit: 5 }],
    ["whatsapp_result", {
      p_id: "q1",
      p_ok: false,
      p_wa_id: null,
      p_error: "no template",
      p_free: false,
      p_final: true,
    }],
  ]);
});

Deno.test("batch size is clamped", () => {
  assertEquals(batchSize(undefined), 50);
  assertEquals(batchSize(0), 50);
  assertEquals(batchSize(500), 200);
  assertEquals(batchSize(20), 20);
  assertEquals(batchSize("x"), 50);
});

Deno.test("webhook signature uses the sha256= header", async () => {
  const raw = JSON.stringify({ object: "whatsapp_business_account" });
  const sig = `sha256=${await hmacSha256Hex("appsecret", raw)}`;
  assert(await verifyMetaSignature(raw, sig, "appsecret"));
  assertFalse(await verifyMetaSignature(raw + " ", sig, "appsecret"));
  assertFalse(await verifyMetaSignature(raw, sig, "other"));
  assertFalse(await verifyMetaSignature(raw, sig.replace("sha256", "sha1"), "appsecret"));
  assertFalse(await verifyMetaSignature(raw, null, "appsecret"));
  assertFalse(await verifyMetaSignature(raw, sig, ""));
});

Deno.test("verification handshake echoes the challenge only for our token", () => {
  const u = (q: string) => new URL(`https://x.supabase.co/functions/v1/whatsapp-webhook?${q}`);
  assertEquals(verifyChallenge(u("hub.mode=subscribe&hub.verify_token=abc&hub.challenge=42"), "abc"), "42");
  assertEquals(verifyChallenge(u("hub.mode=subscribe&hub.verify_token=abd&hub.challenge=42"), "abc"), null);
  assertEquals(verifyChallenge(u("hub.mode=subscribe&hub.verify_token=abc&hub.challenge=42"), ""), null);
  assertEquals(verifyChallenge(u("hub.mode=other&hub.verify_token=abc&hub.challenge=42"), "abc"), null);
});

Deno.test("webhook: receipts, replies and other numbers", () => {
  const payload = {
    object: "whatsapp_business_account",
    entry: [{
      id: "waba",
      changes: [
        {
          field: "messages",
          value: {
            metadata: { phone_number_id: "PN1" },
            statuses: [
              { id: "wamid.1", status: "delivered" },
              { id: "wamid.2", status: "read" },
              { id: "wamid.3", status: "failed", errors: [{ code: 131026, title: "Undeliverable" }] },
              { id: "wamid.4", status: "deleted" },
            ],
            messages: [
              { from: "919876543210", type: "text", text: { body: "STOP" } },
              { from: "919876500000", type: "button", button: { text: "Renew" } },
            ],
          },
        },
        { field: "messages", value: { metadata: { phone_number_id: "PN2" }, statuses: [{ id: "x", status: "read" }] } },
        { field: "account_update", value: {} },
      ],
    }],
  };
  const e = parseWebhook(payload, "PN1");
  assertEquals(e.statuses, [
    { waId: "wamid.1", status: "delivered", error: null },
    { waId: "wamid.2", status: "read", error: null },
    { waId: "wamid.3", status: "failed", error: "131026: Undeliverable" },
  ]);
  assertEquals(e.inbound, [{ from: "919876543210", text: "STOP" }, { from: "919876500000", text: "Renew" }]);
  // Without a configured number every change counts.
  assertEquals(parseWebhook(payload).statuses.length, 4);
  assertEquals(parseWebhook({ object: "page" }), { statuses: [], inbound: [] });
  assertEquals(parseWebhook(null), { statuses: [], inbound: [] });
});
