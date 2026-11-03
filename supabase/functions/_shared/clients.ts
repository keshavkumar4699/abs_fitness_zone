import { createClient, type SupabaseClient } from "npm:@supabase/supabase-js@2.49.4";

const url = () => Deno.env.get("SUPABASE_URL")!;

/** Service-role client. Bypasses RLS: use only after checking the caller. */
export function adminClient(): SupabaseClient {
  return createClient(url(), Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

/** Plain anon client with no caller identity (used to mint sessions). */
export function anonClient(): SupabaseClient {
  return createClient(url(), Deno.env.get("SUPABASE_ANON_KEY")!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

/** Client acting as the caller (their JWT), so RLS and auth.uid() apply. */
export function callerClient(req: Request): SupabaseClient {
  return createClient(url(), Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
}
