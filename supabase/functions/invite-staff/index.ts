// POST { name, email, phone?, role: "front_desk" | "trainer" } — owner only.
// Creates the staff row, an auth login with a temporary password and the
// profile (must_set_password = true). Returns the temporary password once.
import { adminClient, callerClient } from "../_shared/clients.ts";
import { error, json, readJson, serve } from "../_shared/http.ts";
import { isEmail, isMobile, isName, isStaffRole, tempPassword } from "../_shared/validate.ts";

serve(async (req) => {
  const body = await readJson(req);
  if (
    !body || !isName(body.name) || !isEmail(body.email) || !isStaffRole(body.role) ||
    (body.phone != null && !isMobile(body.phone))
  ) {
    return error(400, "invalid input");
  }

  const { data: isOwner, error: ownerError } = await callerClient(req).rpc("is_owner");
  if (ownerError) throw ownerError;
  if (isOwner !== true) return error(403, "not allowed");

  const admin = adminClient();
  const email = (body.email as string).toLowerCase();
  const name = (body.name as string).trim();
  const phone = (body.phone as string | undefined) ?? null;

  const { data: staff, error: staffError } = await admin
    .from("staff")
    .insert({ name, email, phone, role: body.role })
    .select("id")
    .single();
  if (staffError) {
    if (staffError.code === "23505") return error(409, "a staff member with this email already exists");
    throw staffError;
  }

  const password = tempPassword();
  const { data: created, error: createError } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    user_metadata: { kind: "staff" },
  });
  if (createError) {
    await admin.from("staff").delete().eq("id", staff.id);
    if (createError.status === 422) return error(409, "this email already has a login");
    throw createError;
  }

  const { error: profileError } = await admin.from("profiles").insert({
    id: created.user.id,
    role: body.role,
    staff_id: staff.id,
    name,
    phone,
    must_set_password: true,
  });
  if (profileError) {
    await admin.auth.admin.deleteUser(created.user.id);
    await admin.from("staff").delete().eq("id", staff.id);
    throw profileError;
  }

  return json({ staff_id: staff.id, temp_password: password });
});
