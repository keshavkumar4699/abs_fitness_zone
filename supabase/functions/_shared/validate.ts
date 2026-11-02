// Input validation shared by Edge Functions (and unit-tested with `deno test`).

const MOBILE = /^\+91[6-9]\d{9}$/;
const EMAIL = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export const isMobile = (v: unknown): v is string => typeof v === "string" && MOBILE.test(v);
export const isEmail = (v: unknown): v is string => typeof v === "string" && v.length <= 254 && EMAIL.test(v);
export const isUuid = (v: unknown): v is string => typeof v === "string" && UUID.test(v);
export const isPin = (v: unknown): v is string => typeof v === "string" && /^\d{4}$/.test(v);
export const isName = (v: unknown): v is string =>
  typeof v === "string" && v.trim().length >= 1 && v.trim().length <= 120;

export const STAFF_ROLES = ["front_desk", "trainer"] as const;
export type StaffRole = typeof STAFF_ROLES[number];
export const isStaffRole = (v: unknown): v is StaffRole =>
  typeof v === "string" && (STAFF_ROLES as readonly string[]).includes(v);

/** 12-character temporary password from an unambiguous alphabet. */
export function tempPassword(length = 12): string {
  const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
  const bytes = crypto.getRandomValues(new Uint8Array(length));
  return Array.from(bytes, (b) => alphabet[b % alphabet.length]).join("");
}

/** Login email for a member's auth user. Uses their real email when on file
 *  (so magic links reach them), otherwise a non-deliverable placeholder. */
export function memberAuthEmail(memberId: string, email: string | null): string {
  return email && isEmail(email) ? email.toLowerCase() : `member-${memberId}@members.abs-fitness.invalid`;
}
