// POST { member_id, pin } — caller must be owner or front desk.
// Stores the PIN hash (set_member_pin RPC runs as the caller, so the role
// check happens in Postgres) and makes sure the member has an auth login
// linked through `profiles`.
import { adminClient, callerClient } from "../_shared/clients.ts";
import { error, json, readJson, serve } from "../_shared/http.ts";
import { isPin, isUuid, memberAuthEmail } from "../_shared/validate.ts";

serve(async (req) => {
  const body = await readJson(req);
  if (!body || !isUuid(body.member_id) || !isPin(body.pin)) return error(400, "invalid input");

  const caller = callerClient(req);
  const { error: pinError } = await caller.rpc("set_member_pin", { p_member_id: body.member_id, p_pin: body.pin });
  if (pinError) {
    if (pinError.code === "42501") return error(403, "not allowed");
    if (pinError.code === "P0002") return error(404, "member not found");
    return error(400, pinError.message);
  }

  const admin = adminClient();
  const { data: existing, error: existingError } = await admin
    .from("profiles")
    .select("id")
    .eq("member_id", body.member_id)
    .maybeSingle();
  if (existingError) throw existingError;
  if (existing) return json({ ok: true });

  const { data: member, error: memberError } = await admin
    .from("members")
    .select("id, name, phone, email")
    .eq("id", body.member_id)
    .single();
  if (memberError) throw memberError;

  const { data: created, error: createError } = await admin.auth.admin.createUser({
    email: memberAuthEmail(member.id, member.email),
    email_confirm: true,
    user_metadata: { kind: "member" },
  });
  if (createError) throw createError;

  const { error: profileError } = await admin.from("profiles").insert({
    id: created.user.id,
    role: "member",
    member_id: member.id,
    name: member.name,
    phone: member.phone,
  });
  if (profileError) {
    await admin.auth.admin.deleteUser(created.user.id);
    throw profileError;
  }
  return json({ ok: true });
});
