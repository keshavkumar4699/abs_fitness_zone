import { assert, assertFalse } from "jsr:@std/assert@1";
import { isUuid } from "./validate.ts";

Deno.test("isUuid accepts only UUIDs", () => {
  assert(isUuid("6f1c2d3e-4b5a-4c6d-8e9f-0a1b2c3d4e5f"));
  assert(isUuid("6F1C2D3E-4B5A-4C6D-8E9F-0A1B2C3D4E5F"));
  assertFalse(isUuid("6f1c2d3e4b5a4c6d8e9f0a1b2c3d4e5f"));
  assertFalse(isUuid("not-a-uuid"));
  assertFalse(isUuid(42));
  assertFalse(isUuid(null));
});
