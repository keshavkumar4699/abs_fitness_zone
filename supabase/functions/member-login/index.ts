// POST { phone: "+91XXXXXXXXXX", pin: "1234" }
// → 200 { access_token, refresh_token, expires_in }
// → 401 { error, attempts_left }  wrong phone/PIN
// → 423 { error, locked_until }   5 wrong PINs → locked for 15 minutes
//
// The PIN is verified in Postgres (bcrypt + lockout, verify_member_pin), then
// a session for the member's auth user is minted with a one-time magic-link
// token that never leaves this function.
import { adminClient, anonClient } from "../_shared/clients.ts";
import { error, json, readJson, serve } from "../_shared/http.ts";
import { isMobile, isPin } from "../_shared/validate.ts";

serve(async (req) => {
  const body = await readJson(req);
  if (!body || !isMobile(body.phone) || !isPin(body.pin)) return error(400, "invalid input");

  const admin = adminClient();
  const { data: result, error: rpcError } = await admin.rpc("verify_member_pin", {
    p_phone: body.phone,
    p_pin: body.pin,
  });
  if (rpcError) throw rpcError;

  if (!result.ok) {
    if (result.reason === "locked") return error(423, "locked", { locked_until: result.locked_until });
    return error(401, "invalid credentials", { attempts_left: result.attempts_left });
  }

  const { data: profile, error: profileError } = await admin
    .from("profiles")
    .select("id")
    .eq("member_id", result.member_id)
    .is("archived_at", null)
    .maybeSingle();
  if (profileError) throw profileError;
  // A PIN without a linked login means set-member-pin was not completed.
  if (!profile) return error(401, "invalid credentials", { attempts_left: null });

  const { data: user, error: userError } = await admin.auth.admin.getUserById(profile.id);
  if (userError || !user.user?.email) throw userError ?? new Error("member auth user has no email");

  const { data: link, error: linkError } = await admin.auth.admin.generateLink({
    type: "magiclink",
    email: user.user.email,
  });
  if (linkError) throw linkError;

  // Separate client: verifyOtp stores the session on the client it runs on.
  const { data: verified, error: verifyError } = await anonClient().auth.verifyOtp({
    type: "email",
    token_hash: link.properties.hashed_token,
  });
  if (verifyError || !verified.session) throw verifyError ?? new Error("no session");

  return json({
    access_token: verified.session.access_token,
    refresh_token: verified.session.refresh_token,
    expires_in: verified.session.expires_in,
  });
});
