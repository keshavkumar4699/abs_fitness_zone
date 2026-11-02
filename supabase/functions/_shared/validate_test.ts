import { assert, assertEquals, assertFalse } from "jsr:@std/assert@1";
import { isEmail, isMobile, isPin, isStaffRole, memberAuthEmail, tempPassword } from "./validate.ts";

Deno.test("isMobile accepts only +91 E.164 mobiles", () => {
  assert(isMobile("+919876543210"));
  assertFalse(isMobile("9876543210"));
  assertFalse(isMobile("+915876543210"));
  assertFalse(isMobile(9876543210));
});

Deno.test("isPin requires exactly four digits", () => {
  assert(isPin("0420"));
  assertFalse(isPin("123"));
  assertFalse(isPin("12a4"));
  assertFalse(isPin(1234));
});

Deno.test("isStaffRole rejects owner and member", () => {
  assert(isStaffRole("front_desk"));
  assert(isStaffRole("trainer"));
  assertFalse(isStaffRole("owner"));
  assertFalse(isStaffRole("member"));
});

Deno.test("isEmail", () => {
  assert(isEmail("desk@absfitness.in"));
  assertFalse(isEmail("not-an-email"));
});

Deno.test("memberAuthEmail prefers the real email", () => {
  assertEquals(memberAuthEmail("abc", "Riya@Mail.com"), "riya@mail.com");
  assertEquals(memberAuthEmail("abc", null), "member-abc@members.abs-fitness.invalid");
});

Deno.test("tempPassword length and alphabet", () => {
  const p = tempPassword();
  assertEquals(p.length, 12);
  assert(/^[A-HJ-NP-Za-km-z2-9]+$/.test(p));
});
