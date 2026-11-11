-- ABS Fitness — Milestone M5: WhatsApp automation (F8)
-- Templates (English and Hindi, utility and marketing), one queue for both
-- modes, the daily queue builder (expiry, dues with the UPI link, birthdays,
-- festivals), instant confirmations from member events, broadcasts to
-- segments, the festival calendar, opt-out, the message log, the API-mode
-- hand-off for the Edge Functions and the cost meter.
--
-- Free mode ("link"): staff send each queued message from the gym's own
-- WhatsApp with a pre-filled wa.me link. API mode ("api"): the
-- whatsapp-send Edge Function sends approved templates through the Meta
-- Cloud API. Both use the same templates, queue and log. Only official
-- channels: no unofficial automation libraries, ever.

-- ---------------------------------------------------------------------------
-- Settings (owner edits; everyone on staff reads through whatsapp_settings())
-- ---------------------------------------------------------------------------
insert into public.settings (key, value) values
  ('whatsapp_mode', '"link"'),
  -- Days before (+) / after (-) the membership end date (8.2).
  ('expiry_reminder_days', '[7, 3, 0, -3]'),
  ('whatsapp_automations', '{"expiry": true, "dues": true, "birthday": true, "festival": true, "payment": true, "membership": true, "plan": true}'),
  -- Meta's per-message price in India, per 100 messages, in paise (8.14).
  ('whatsapp_prices', '{"utility_per_100_paise": 1450, "marketing_per_100_paise": 7850}'),
  -- Monthly cap for API marketing spend, in paise; reaching it pauses
  -- marketing sends (0 = no cap).
  ('whatsapp_marketing_cap_paise', '20000')
on conflict (key) do nothing;

create or replace function public.whatsapp_settings()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'mode', coalesce((select value #>> '{}' from public.settings where key = 'whatsapp_mode'), 'link'),
    'expiry_days', coalesce((select value from public.settings where key = 'expiry_reminder_days'), '[7, 3, 0, -3]'::jsonb),
    'due_days', to_jsonb(public.due_reminder_days()),
    'automations', coalesce((select value from public.settings where key = 'whatsapp_automations'), '{}'::jsonb),
    'prices', coalesce((select value from public.settings where key = 'whatsapp_prices'), '{}'::jsonb),
    'marketing_cap_paise', coalesce((select (value #>> '{}')::int from public.settings where key = 'whatsapp_marketing_cap_paise'), 0))
  where public.is_staff() or coalesce(current_setting('role', true), 'none') not in ('anon', 'authenticated')
$$;

create or replace function public._whatsapp_mode()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select value #>> '{}' from public.settings where key = 'whatsapp_mode'), 'link')
$$;

create or replace function public._automation_on(p_key text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select (value ->> p_key)::boolean from public.settings where key = 'whatsapp_automations'), true)
$$;

alter table public.member_events drop constraint if exists member_events_kind_check;
alter table public.member_events add constraint member_events_kind_check check (kind in (
  'joined','membership_started','renewed','frozen','unfrozen','cancelled','transferred_in','transferred_out',
  'note','profile_updated','pin_set','imported','archived','restored',
  'invoice_created','payment','payment_voided','refund','invoice_voided',
  'program_assigned','program_ended','diet_assigned','diet_ended',
  'whatsapp_opt_out','whatsapp_opt_in'));

-- When the member last wrote to the gym (API mode, 8.11).
alter table public.members add column if not exists whatsapp_last_inbound_at timestamptz;

-- The timeline (M1) ignores that timestamp and the dues total (derived,
-- like status; every invoice and payment used to log "Profile updated"),
-- and shows WhatsApp being turned off or on as its own entry.
create or replace function public.members_audit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_skip text[] := array['status','current_membership_id','plan_name','membership_start','membership_end','updated_at',
                         'whatsapp_last_inbound_at', 'dues_paise'];
  v_changed text[];
begin
  select array_agg(n.key order by n.key) into v_changed
  from jsonb_each(to_jsonb(new)) n
  join jsonb_each(to_jsonb(old)) o using (key)
  where n.value is distinct from o.value and not n.key = any (v_skip);
  if v_changed is not null then
    if 'archived_at' = any (v_changed) then
      perform public.log_member_event(new.id, case when new.archived_at is null then 'restored' else 'archived' end,
        case when new.archived_at is null then 'Restored' else 'Archived' end);
    elsif 'whatsapp_opt_out' = any (v_changed) and v_changed <@ array['whatsapp_opt_out', 'consent_whatsapp_at'] then
      perform public.log_member_event(new.id, case when new.whatsapp_opt_out then 'whatsapp_opt_out' else 'whatsapp_opt_in' end,
        case when new.whatsapp_opt_out then 'WhatsApp messages turned off' else 'WhatsApp messages turned on' end);
    else
      perform public.log_member_event(new.id, 'profile_updated', 'Profile updated', jsonb_build_object('fields', v_changed));
    end if;
  end if;
  return null;
end;
$$;

-- ---------------------------------------------------------------------------
-- Formatting helpers (match the app: ₹1,23,456 and "3 Nov 2026")
-- ---------------------------------------------------------------------------
create or replace function public._inr(p_paise bigint)
returns text
language sql
immutable
as $$
  with r as (select abs(p_paise) / 100 as whole, abs(p_paise) % 100 as frac)
  select case when p_paise < 0 then '-' else '' end || '₹'
         || case when length(whole::text) > 3
                 then regexp_replace(left(whole::text, length(whole::text) - 3), '(\d)(?=(\d\d)+$)', '\1,', 'g')
                      || ',' || right(whole::text, 3)
                 else whole::text end
         || case when frac > 0 then '.' || lpad(frac::text, 2, '0') else '' end
  from r
$$;

create or replace function public._day_label(p_day date)
returns text
language sql
immutable
as $$
  select to_char(p_day, 'FMDD Mon YYYY')
$$;

create or replace function public._urlencode(p text)
returns text
language sql
immutable
as $$
  select coalesce(string_agg(
    case when ch ~ '^[A-Za-z0-9_.~-]$' then ch
         else (select string_agg('%' || upper(lpad(to_hex(get_byte(convert_to(ch, 'UTF8'), i)), 2, '0')), '' order by i)
               from generate_series(0, octet_length(convert_to(ch, 'UTF8')) - 1) i) end,
    '' order by n), '')
  from regexp_split_to_table(p, '') with ordinality as t(ch, n)
$$;

-- The gym's UPI pay link for an amount (null without a valid UPI ID), like
-- the app's UpiLink.build.
create or replace function public._upi_link(p_amount_paise int, p_invoice_no text)
returns text
language sql
stable
security definer
set search_path = public
as $$
  with s as (
    select (select value #>> '{}' from public.settings where key = 'upi_id') as vpa,
           coalesce(nullif(trim((select value #>> '{}' from public.settings where key = 'gym_name')), ''), 'ABS Fitness') as gym
  )
  select case when vpa ~ '^[\w.\-]{2,255}@[a-zA-Z][a-zA-Z0-9]{1,63}$' and p_amount_paise > 0 then
    'upi://pay?pa=' || trim(vpa) || '&pn=' || public._urlencode(gym)
    || '&am=' || (p_amount_paise / 100) || '.' || lpad((p_amount_paise % 100)::text, 2, '0')
    || '&cu=INR&tn=' || public._urlencode(left(gym || ' ' || p_invoice_no, 50))
    || '&tr=' || regexp_replace(p_invoice_no, '[^A-Za-z0-9]', '', 'g')
  end
  from s
$$;

-- {name} placeholders filled from p_vars; unknown ones are removed.
create or replace function public._render(p_body text, p_vars jsonb)
returns text
language plpgsql
immutable
as $$
declare
  v_out text := p_body;
  v_kv record;
begin
  for v_kv in select * from jsonb_each_text(coalesce(p_vars, '{}')) loop
    v_out := replace(v_out, '{' || v_kv.key || '}', coalesce(v_kv.value, ''));
  end loop;
  return regexp_replace(v_out, '\{[a-z_]+\}', '', 'g');
end;
$$;

-- The placeholder values in the order they appear (Cloud API template
-- parameters {{1}}, {{2}}…).
create or replace function public._params(p_body text, p_vars jsonb)
returns jsonb
language sql
immutable
as $$
  select coalesce(jsonb_agg(coalesce(p_vars ->> m[1], '') order by n), '[]'::jsonb)
  from regexp_matches(p_body, '\{([a-z_]+)\}', 'g') with ordinality as t(m, n)
$$;

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------
-- Templates (8.1). System templates can be edited and switched off, not
-- deleted. meta_template_name is the approved template in Meta (API mode).
create table public.message_templates (
  id                 uuid primary key default gen_random_uuid(),
  key                text not null check (key ~ '^[a-z][a-z0-9_]{1,40}$'),
  language           text not null default 'en' check (language in ('en', 'hi')),
  category           text not null check (category in ('utility', 'marketing')),
  title              text not null check (length(trim(title)) between 2 and 60),
  body               text not null check (length(trim(body)) between 2 and 1000),
  meta_template_name text check (meta_template_name is null or meta_template_name ~ '^[a-z0-9_]{1,512}$'),
  is_system          boolean not null default false,
  is_enabled         boolean not null default true,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  unique (key, language)
);
create trigger message_templates_touch before update on public.message_templates
  for each row execute function public.touch_updated_at();

-- Broadcasts (8.8): composed once, queued for every member of a segment.
create table public.broadcasts (
  id            uuid primary key default gen_random_uuid(),
  title         text not null check (length(trim(title)) between 2 and 80),
  body          text not null check (length(trim(body)) between 2 and 1000),
  category      text not null check (category in ('utility', 'marketing')),
  segment       jsonb not null,
  scheduled_for timestamptz not null default now(),
  queued        int not null default 0,
  skipped       int not null default 0,
  created_by    uuid references auth.users (id) on delete set null,
  created_at    timestamptz not null default now()
);

-- The festival calendar (8.6). Lunar dates move every year: the owner checks
-- and edits them.
create table public.festivals (
  id         uuid primary key default gen_random_uuid(),
  name       text not null check (length(trim(name)) between 2 and 60),
  local_name text check (local_name is null or length(local_name) <= 60),
  day        date not null,
  message    text check (message is null or length(trim(message)) between 2 and 1000),
  segment    jsonb not null default '{"kind": "all"}',
  is_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (name, day)
);
create trigger festivals_touch before update on public.festivals
  for each row execute function public.touch_updated_at();

-- One queue for both modes (8.9, 8.10) and the message log (8.13).
create table public.message_queue (
  id                 uuid primary key default gen_random_uuid(),
  member_id          uuid not null references public.members (id) on delete cascade,
  template_key       text not null,
  language           text not null default 'en' check (language in ('en', 'hi')),
  category           text not null check (category in ('utility', 'marketing')),
  body               text not null check (length(body) between 1 and 4000),
  params             jsonb not null default '[]',
  meta_template_name text,
  channel            text not null check (channel in ('link', 'api')),
  scheduled_for      timestamptz not null default now(),
  status             text not null default 'queued'
                       check (status in ('queued', 'sending', 'sent', 'delivered', 'read', 'failed', 'skipped', 'cancelled')),
  source             text not null default 'auto' check (source in ('auto', 'event', 'broadcast', 'manual')),
  dedupe_key         text,
  invoice_id         uuid references public.invoices (id) on delete set null,
  broadcast_id       uuid references public.broadcasts (id) on delete set null,
  attempts           int not null default 0,
  wa_message_id      text unique,
  free_window        boolean not null default false,
  error              text,
  sent_at            timestamptz,
  sent_by            uuid references auth.users (id) on delete set null,
  delivered_at       timestamptz,
  read_at            timestamptz,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);
create trigger message_queue_touch before update on public.message_queue
  for each row execute function public.touch_updated_at();
create unique index message_queue_dedupe on public.message_queue (member_id, dedupe_key) where dedupe_key is not null;
create index message_queue_due on public.message_queue (status, scheduled_for);
create index message_queue_member on public.message_queue (member_id, created_at desc);
create index message_queue_invoice on public.message_queue (invoice_id) where invoice_id is not null;

-- What each automation did and when (7.10 will list these).
create table public.automation_runs (
  id          bigint generated always as identity primary key,
  rule_key    text not null,
  started_at  timestamptz not null default now(),
  finished_at timestamptz,
  items       int not null default 0,
  result      jsonb not null default '{}'
);

-- ---------------------------------------------------------------------------
-- Row Level Security: the owner and front desk run WhatsApp; members read
-- their own messages. Trainers stay out (messages carry fees).
-- ---------------------------------------------------------------------------
alter table public.message_templates enable row level security;
alter table public.broadcasts        enable row level security;
alter table public.festivals         enable row level security;
alter table public.message_queue     enable row level security;
alter table public.automation_runs   enable row level security;

create policy templates_desk_read on public.message_templates for select to authenticated using (public.is_desk());
create policy templates_owner_write on public.message_templates for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy festivals_desk_read on public.festivals for select to authenticated using (public.is_desk());
create policy festivals_owner_write on public.festivals for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy broadcasts_desk_read on public.broadcasts for select to authenticated using (public.is_desk());
create policy queue_read on public.message_queue for select to authenticated
  using (public.is_desk() or member_id = public.auth_member_id());
create policy runs_desk_read on public.automation_runs for select to authenticated using (public.is_desk());

-- System templates: edit or switch off, never delete (from the app;
-- migrations, with no signed-in user, are left alone).
create or replace function public.message_templates_guard()
returns trigger
language plpgsql
as $$
begin
  if auth.uid() is null then
    return case when tg_op = 'DELETE' then old else new end;
  end if;
  if tg_op = 'DELETE' then
    if old.is_system then raise exception 'built-in templates can be switched off, not deleted' using errcode = '42501'; end if;
    return old;
  end if;
  if tg_op = 'UPDATE' then
    new.key := old.key;
    new.language := old.language;
    new.is_system := old.is_system;
    if old.is_system then new.category := old.category; end if;
  end if;
  return new;
end;
$$;
create trigger message_templates_guard before update or delete on public.message_templates
  for each row execute function public.message_templates_guard();

-- ---------------------------------------------------------------------------
-- Queueing one message
-- ---------------------------------------------------------------------------
-- Adds a message for a member, or returns null when it must not be sent:
-- archived, opted out or no WhatsApp consent (8.12); the template is off;
-- the dedupe key was used before; the same template went to them in the
-- last 24 hours; or (marketing) they already have a marketing message that
-- day. The text is rendered now, in the member's language.
create or replace function public._enqueue(
  p_member_id uuid,
  p_key text,
  p_vars jsonb,
  p_scheduled timestamptz,
  p_source text,
  p_dedupe text default null,
  p_invoice_id uuid default null,
  p_broadcast_id uuid default null,
  p_body text default null,
  p_category text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_m     public.members%rowtype;
  v_t     public.message_templates%rowtype;
  v_body  text;
  v_cat   text;
  v_lang  text;
  v_vars  jsonb;
  v_id    uuid;
  v_day   date := (p_scheduled at time zone 'Asia/Kolkata')::date;
begin
  select * into v_m from public.members where id = p_member_id;
  if not found or v_m.archived_at is not null or v_m.whatsapp_opt_out or v_m.consent_whatsapp_at is null
     or coalesce(trim(v_m.phone), '') = '' then
    return null;
  end if;
  v_lang := case when v_m.language = 'hi' then 'hi' else 'en' end;
  if p_body is null then
    select * into v_t from public.message_templates where key = p_key and language = v_lang and is_enabled;
    if not found then
      select * into v_t from public.message_templates where key = p_key and language = 'en' and is_enabled;
      if not found then return null; end if;
      v_lang := 'en';
    end if;
    v_body := v_t.body;
    v_cat := v_t.category;
  else
    v_body := p_body;
    v_cat := coalesce(p_category, 'marketing');
  end if;
  if p_dedupe is not null and exists (select 1 from public.message_queue where member_id = p_member_id and dedupe_key = p_dedupe) then
    return null;
  end if;
  if exists (select 1 from public.message_queue
             where member_id = p_member_id and template_key = p_key and status not in ('cancelled', 'skipped')
               and created_at > now() - interval '24 hours') then
    return null;
  end if;
  if v_cat = 'marketing' and exists (
       select 1 from public.message_queue
       where member_id = p_member_id and category = 'marketing' and status not in ('cancelled', 'skipped', 'failed')
         and (scheduled_for at time zone 'Asia/Kolkata')::date = v_day) then
    return null;
  end if;
  v_vars := jsonb_build_object(
    'first_name', split_part(trim(v_m.name), ' ', 1),
    'name', trim(v_m.name),
    'gym_name', coalesce(nullif(trim((select value #>> '{}' from public.settings where key = 'gym_name')), ''), 'ABS Fitness'),
    'gym_phone', coalesce((select value #>> '{}' from public.settings where key = 'gym_phone'), '')
  ) || coalesce(p_vars, '{}');
  insert into public.message_queue (member_id, template_key, language, category, body, params, meta_template_name, channel,
                                    scheduled_for, source, dedupe_key, invoice_id, broadcast_id)
  values (p_member_id, p_key, v_lang, v_cat, left(public._render(v_body, v_vars), 4000), public._params(v_body, v_vars),
          case when p_body is null then v_t.meta_template_name end,
          case when public._whatsapp_mode() = 'api' then 'api' else 'link' end,
          p_scheduled, p_source, p_dedupe, p_invoice_id, p_broadcast_id)
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public._enqueue(uuid, text, jsonb, timestamptz, text, text, uuid, uuid, text, text)
  from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Segments (8.8)
-- ---------------------------------------------------------------------------
-- { kind: all | active | expiring | expired | dues | trainer | batch | members,
--   trainer_id?, batch?, member_ids? }
create or replace function public._segment_members(p_segment jsonb)
returns setof uuid
language sql
stable
security definer
set search_path = public
as $$
  select m.id from public.members m
  where m.archived_at is null
    and case p_segment ->> 'kind'
      when 'all' then true
      when 'active' then m.status in ('active', 'expiring')
      when 'expiring' then exists (select 1 from public.memberships ms where ms.member_id = m.id and ms.cancelled_at is null
                                     and ms.end_date between public.ist_today() and public.ist_today() + 7)
      when 'expired' then m.status in ('expired', 'inactive') and exists (
                            select 1 from public.memberships ms where ms.member_id = m.id and ms.cancelled_at is null
                            group by ms.member_id
                            having max(ms.end_date) between public.ist_today() - 90 and public.ist_today() - 30)
      when 'dues' then exists (select 1 from public.invoices i where i.member_id = m.id and i.status in ('unpaid', 'partial')
                                 and i.balance_paise > 0)
      when 'trainer' then m.trainer_id = (p_segment ->> 'trainer_id')::uuid
      when 'batch' then m.batch = p_segment ->> 'batch'
      when 'members' then m.id in (select (jsonb_array_elements_text(coalesce(p_segment -> 'member_ids', '[]'))) ::uuid)
      else false
    end
$$;
revoke execute on function public._segment_members(jsonb) from public, anon, authenticated;

-- How many members a segment has, and how many can get WhatsApp (preview).
create or replace function public.segment_count(p_segment jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  return (
    select jsonb_build_object('total', count(*),
             'reachable', count(*) filter (where not m.whatsapp_opt_out and m.consent_whatsapp_at is not null))
    from public.members m where m.id in (select public._segment_members(p_segment)));
end;
$$;

create or replace function public.create_broadcast(
  p_title text,
  p_body text,
  p_category text,
  p_segment jsonb,
  p_scheduled timestamptz default null
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id     uuid;
  v_member uuid;
  v_q      int := 0;
  v_s      int := 0;
  v_at     timestamptz := greatest(coalesce(p_scheduled, now()), now() - interval '1 minute');
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if p_category not in ('utility', 'marketing') then raise exception 'unknown category' using errcode = '22023'; end if;
  if p_segment ->> 'kind' not in ('all', 'active', 'expiring', 'expired', 'dues', 'trainer', 'batch', 'members') then
    raise exception 'unknown segment' using errcode = '22023';
  end if;
  if v_at > now() + interval '60 days' then raise exception 'schedule within 60 days' using errcode = '22023'; end if;
  insert into public.broadcasts (title, body, category, segment, scheduled_for, created_by)
  values (trim(p_title), trim(p_body), p_category, p_segment, v_at, auth.uid())
  returning id into v_id;
  for v_member in select public._segment_members(p_segment) loop
    if public._enqueue(v_member, 'broadcast_' || replace(v_id::text, '-', ''), '{}', v_at, 'broadcast',
                       'broadcast:' || v_id, null, v_id, trim(p_body), p_category) is null then
      v_s := v_s + 1;
    else
      v_q := v_q + 1;
    end if;
  end loop;
  update public.broadcasts set queued = v_q, skipped = v_s where id = v_id;
  return jsonb_build_object('broadcast_id', v_id, 'queued', v_q, 'skipped', v_s);
end;
$$;

-- ---------------------------------------------------------------------------
-- The daily queue (8.2, 8.3, 8.5, 8.6): 07:30 IST, or from the app. Safe to
-- run again: every message has a dedupe key.
-- ---------------------------------------------------------------------------
create or replace function public.build_message_queue(p_day date default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_day     date := coalesce(p_day, public.ist_today());
  v_at      timestamptz := (v_day + time '09:00') at time zone 'Asia/Kolkata';
  v_run     bigint;
  v_offsets int[];
  r         record;
  v_link    text;
  v_n       jsonb := '{"expiry": 0, "dues": 0, "birthday": 0, "festival": 0}';
  v_key     text;
begin
  -- The desk from the app, or the scheduled job. Security definer changes
  -- current_user, so the caller's role comes from the session's role setting.
  if not (public.is_desk() or coalesce(current_setting('role', true), 'none') not in ('anon', 'authenticated')) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  insert into public.automation_runs (rule_key) values ('build_message_queue') returning id into v_run;
  -- Automatic messages left unsent from an earlier day are out of date (a
  -- late birthday wish, a reminder about yesterday): today's run builds what
  -- is due now. Receipts and broadcasts stay until they are sent.
  update public.message_queue set status = 'cancelled', error = 'not sent on the day'
   where status = 'queued' and source = 'auto'
     and scheduled_for < (v_day::timestamp at time zone 'Asia/Kolkata');
  v_offsets := coalesce((select array(select (jsonb_array_elements_text(value))::int)
                         from public.settings where key = 'expiry_reminder_days'), array[7, 3, 0, -3]);

  -- Membership expiry: each member's latest membership.
  if public._automation_on('expiry') then
    for r in
      select distinct on (ms.member_id) ms.id, ms.member_id, ms.plan_name, ms.end_date
      from public.memberships ms join public.members m on m.id = ms.member_id
      where ms.cancelled_at is null and m.status <> 'frozen'
      order by ms.member_id, ms.end_date desc
    loop
      if (r.end_date - v_day) = any (v_offsets) then
        v_key := case when r.end_date > v_day then 'expiry_soon' when r.end_date = v_day then 'expiry_today' else 'expired' end;
        if public._enqueue(r.member_id, v_key,
             jsonb_build_object('plan', r.plan_name, 'end_date', public._day_label(r.end_date), 'days', r.end_date - v_day),
             v_at, 'auto', 'expiry:' || r.id || ':' || (r.end_date - v_day)) is not null then
          v_n := jsonb_set(v_n, '{expiry}', to_jsonb((v_n ->> 'expiry')::int + 1));
        end if;
      end if;
    end loop;
  end if;

  -- Fee reminders from the dues engine, with the UPI pay link.
  if public._automation_on('dues') then
    for r in
      select i.id, i.member_id, i.invoice_no, i.balance_paise, i.next_due_date from public.invoices i
      where i.status in ('unpaid', 'partial') and i.balance_paise > 0 and i.member_id is not null
        and (i.next_due_date - v_day) = any (public.due_reminder_days())
    loop
      v_link := public._upi_link(r.balance_paise, r.invoice_no);
      if public._enqueue(r.member_id, case when v_link is null then 'dues_reminder_desk' else 'dues_reminder' end,
           jsonb_build_object('amount', public._inr(r.balance_paise), 'invoice_no', r.invoice_no,
                              'due_date', public._day_label(r.next_due_date), 'pay_link', coalesce(v_link, '')),
           v_at, 'auto', 'dues:' || r.id || ':' || v_day, r.id) is not null then
        v_n := jsonb_set(v_n, '{dues}', to_jsonb((v_n ->> 'dues')::int + 1));
      end if;
    end loop;
  end if;

  -- Birthdays (29 Feb celebrates on 28 Feb in other years).
  if public._automation_on('birthday') then
    for r in
      select m.id from public.members m
      where m.archived_at is null and m.dob is not null
        and (to_char(m.dob, 'MM-DD') = to_char(v_day, 'MM-DD')
             or (to_char(m.dob, 'MM-DD') = '02-29' and to_char(v_day, 'MM-DD') = '02-28'
                 and extract(day from (date_trunc('year', v_day) + interval '1 month 28 days')) <> 29))
    loop
      if public._enqueue(r.id, 'birthday', '{}', v_at, 'auto', 'birthday:' || extract(year from v_day)) is not null then
        v_n := jsonb_set(v_n, '{birthday}', to_jsonb((v_n ->> 'birthday')::int + 1));
      end if;
    end loop;
  end if;

  -- Festivals.
  if public._automation_on('festival') then
    for r in select * from public.festivals where day = v_day and is_enabled loop
      declare
        v_member uuid;
      begin
        for v_member in select public._segment_members(r.segment) loop
          if public._enqueue(v_member, 'festival',
               jsonb_build_object('festival', case when (select language from public.members where id = v_member) = 'hi'
                                                   then coalesce(r.local_name, r.name) else r.name end),
               v_at, 'auto', 'festival:' || r.id, null, null,
               case when r.message is null then null
                    else public._render(r.message, jsonb_build_object('festival', r.name)) end,
               case when r.message is null then null else 'marketing' end) is not null then
            v_n := jsonb_set(v_n, '{festival}', to_jsonb((v_n ->> 'festival')::int + 1));
          end if;
        end loop;
      end;
    end loop;
  end if;

  update public.automation_runs
     set finished_at = now(),
         items = (v_n ->> 'expiry')::int + (v_n ->> 'dues')::int + (v_n ->> 'birthday')::int + (v_n ->> 'festival')::int,
         result = v_n || jsonb_build_object('day', v_day)
   where id = v_run;
  return v_n;
end;
$$;

-- ---------------------------------------------------------------------------
-- Instant confirmations (8.4) from member events. A failure here never
-- blocks the payment or membership that caused it.
-- ---------------------------------------------------------------------------
create or replace function public._message_on_event()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pay public.payments%rowtype;
  v_ms  public.memberships%rowtype;
begin
  begin
    if new.kind = 'payment' and public._automation_on('payment') then
      select * into v_pay from public.payments where id = (new.data ->> 'payment_id')::uuid;
      if found then
        perform public._enqueue(new.member_id, 'payment_received',
          jsonb_build_object('amount', public._inr(v_pay.amount_paise), 'receipt_no', coalesce(v_pay.receipt_no, '')),
          now(), 'event', 'event:' || new.id);
      end if;
    elsif new.kind in ('membership_started', 'renewed') and public._automation_on('membership') then
      -- Joining with a plan logs the event without the membership's id.
      select * into v_ms from public.memberships
       where id = (new.data ->> 'membership_id')::uuid
          or (new.data ->> 'membership_id' is null and member_id = new.member_id and cancelled_at is null)
       order by created_at desc limit 1;
      if found then
        perform public._enqueue(new.member_id, case when new.kind = 'renewed' then 'membership_renewed' else 'membership_started' end,
          jsonb_build_object('plan', v_ms.plan_name, 'start_date', public._day_label(v_ms.start_date),
                             'end_date', public._day_label(v_ms.end_date)),
          now(), 'event', 'event:' || new.id);
      end if;
    elsif new.kind in ('program_assigned', 'diet_assigned') and public._automation_on('plan') then
      perform public._enqueue(new.member_id, new.kind, '{}', now(), 'event', 'event:' || new.id);
    end if;
  exception when others then
    raise warning 'message for event % skipped: %', new.id, sqlerrm;
  end;
  return new;
end;
$$;
create trigger member_events_message after insert on public.member_events
  for each row execute function public._message_on_event();

-- Paid (or voided) invoices stop their reminders (8.3).
create or replace function public._cancel_paid_reminders()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status in ('paid', 'void') or new.balance_paise <= 0 then
    update public.message_queue set status = 'cancelled', error = 'paid'
     where invoice_id = new.id and status = 'queued';
  end if;
  return new;
end;
$$;
create trigger invoices_cancel_reminders after update of status, paid_paise on public.invoices
  for each row execute function public._cancel_paid_reminders();

-- Opting out cancels whatever is waiting (8.12).
create or replace function public._cancel_opted_out()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.whatsapp_opt_out and not old.whatsapp_opt_out then
    update public.message_queue set status = 'cancelled', error = 'opted out'
     where member_id = new.id and status in ('queued', 'sending');
  end if;
  return new;
end;
$$;
create trigger members_whatsapp_opt_out after update of whatsapp_opt_out on public.members
  for each row execute function public._cancel_opted_out();

-- ---------------------------------------------------------------------------
-- Free mode (8.9) and manual sends
-- ---------------------------------------------------------------------------
-- Staff tick a message sent (after WhatsApp opens), skip it, or undo.
create or replace function public.mark_message(p_id uuid, p_status text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_q public.message_queue%rowtype;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if p_status not in ('sent', 'skipped', 'queued') then raise exception 'unknown status' using errcode = '22023'; end if;
  select * into v_q from public.message_queue where id = p_id for update;
  if not found then raise exception 'message not found' using errcode = 'P0002'; end if;
  if v_q.channel <> 'link' or v_q.status not in ('queued', 'sent', 'skipped') then
    raise exception 'this message is sent by the API' using errcode = '22023';
  end if;
  if p_status = 'queued' and v_q.sent_at is not null and v_q.sent_at < now() - interval '1 day' then
    raise exception 'too late to undo' using errcode = '22023';
  end if;
  update public.message_queue
     set status = p_status,
         sent_at = case when p_status = 'sent' then now() end,
         sent_by = case when p_status = 'sent' then auth.uid() end
   where id = p_id;
end;
$$;

-- A one-off message sent from a member's page (logged, never capped).
create or replace function public.log_manual_message(p_member_id uuid, p_body text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if not coalesce(public.is_desk() or public.is_my_trainee(p_member_id), false) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  if length(trim(coalesce(p_body, ''))) not between 1 and 4000 then
    raise exception 'message is 1 to 4000 characters' using errcode = '22023';
  end if;
  insert into public.message_queue (member_id, template_key, category, body, channel, status, source, sent_at, sent_by)
  values (p_member_id, 'manual', 'utility', trim(p_body), 'link', 'sent', 'manual', now(), auth.uid())
  returning id into v_id;
  return v_id;
end;
$$;

-- Members switch WhatsApp off or on in the app; the desk can too.
create or replace function public.set_whatsapp_opt_out(p_opt_out boolean, p_member_id uuid default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid := coalesce(p_member_id, public.auth_member_id());
begin
  if v_member is null or not coalesce(v_member = public.auth_member_id() or public.is_desk(), false) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  update public.members
     set whatsapp_opt_out = p_opt_out,
         consent_whatsapp_at = case when p_opt_out then consent_whatsapp_at else coalesce(consent_whatsapp_at, now()) end
   where id = v_member;
end;
$$;

-- ---------------------------------------------------------------------------
-- API mode (8.10, 8.11): called by the Edge Functions with the service role
-- ---------------------------------------------------------------------------
-- Is API marketing spend this month at the cap (8.14)?
create or replace function public._marketing_paused()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  with cap as (select coalesce((select (value #>> '{}')::int from public.settings where key = 'whatsapp_marketing_cap_paise'), 0) as v),
       price as (select coalesce((select (value ->> 'marketing_per_100_paise')::int from public.settings where key = 'whatsapp_prices'), 0) as v),
       sent as (select count(*) as n from public.message_queue
                where channel = 'api' and category = 'marketing' and not free_window
                  and status in ('sent', 'delivered', 'read')
                  and sent_at >= date_trunc('month', now() at time zone 'Asia/Kolkata') at time zone 'Asia/Kolkata')
  select cap.v > 0 and (sent.n * price.v) / 100 >= cap.v from cap, price, sent
$$;

-- Claims up to p_limit due API messages (status → sending) so two runs
-- never send the same one. While the marketing cap is reached, marketing
-- goes to the free-mode list instead.
create or replace function public.whatsapp_claim(p_limit int default 50)
returns table (id uuid, member_id uuid, phone text, body text, params jsonb, meta_template_name text, language text,
               category text, in_window boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_paused boolean := public._marketing_paused();
begin
  -- Messages that were claimed but never finished go back to the queue.
  update public.message_queue q set status = 'queued'
   where q.status = 'sending' and q.updated_at < now() - interval '15 minutes';
  -- Paid invoices and opted-out members are dropped before sending.
  update public.message_queue q set status = 'cancelled', error = 'paid'
   where q.status = 'queued' and q.invoice_id is not null
     and exists (select 1 from public.invoices i where i.id = q.invoice_id and (i.status in ('paid', 'void') or i.balance_paise <= 0));
  -- Over the monthly marketing cap: marketing that is due moves to the
  -- free-mode list, where staff can still send it by hand on the day.
  if v_paused then
    update public.message_queue q set channel = 'link', error = 'monthly marketing cap reached'
     where q.channel = 'api' and q.status = 'queued' and q.category = 'marketing' and q.scheduled_for <= now();
  end if;
  return query
  with due as (
    select q.id from public.message_queue q join public.members m on m.id = q.member_id
    where q.channel = 'api' and q.status = 'queued' and q.scheduled_for <= now()
      and not m.whatsapp_opt_out and m.archived_at is null
      and (q.category = 'utility' or not v_paused)
    order by q.scheduled_for, q.created_at
    limit greatest(least(p_limit, 200), 1)
    for update of q skip locked
  ), claimed as (
    update public.message_queue q set status = 'sending' from due where q.id = due.id returning q.*
  )
  select c.id, c.member_id, m.phone, c.body, c.params, c.meta_template_name, c.language, c.category,
         coalesce(m.whatsapp_last_inbound_at > now() - interval '24 hours', false)
  from claimed c join public.members m on m.id = c.member_id;
end;
$$;

-- The outcome of one send. A failure is retried once; then the message
-- moves to the free-mode queue so staff can send it by hand. A failure that
-- can never succeed through the API (p_final: no approved template, a
-- refused number) moves at once.
create or replace function public.whatsapp_result(p_id uuid, p_ok boolean, p_wa_id text default null,
                                                  p_error text default null, p_free boolean default false,
                                                  p_final boolean default false)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_q public.message_queue%rowtype;
begin
  select * into v_q from public.message_queue where id = p_id for update;
  if not found then return 'missing'; end if;
  if p_ok then
    update public.message_queue
       set status = 'sent', sent_at = now(), wa_message_id = p_wa_id, free_window = p_free, error = null,
           attempts = attempts + 1
     where id = p_id;
    return 'sent';
  end if;
  if p_final or v_q.attempts + 1 >= 2 then
    update public.message_queue
       set status = 'queued', channel = 'link', attempts = attempts + 1, error = left(coalesce(p_error, 'failed'), 500)
     where id = p_id;
    return 'moved';
  end if;
  update public.message_queue set status = 'queued', attempts = attempts + 1, error = left(coalesce(p_error, 'failed'), 500)
   where id = p_id;
  return 'retry';
end;
$$;

-- Delivery and read receipts from the webhook. A late failure counts as a
-- failed attempt.
create or replace function public.whatsapp_status(p_wa_id text, p_status text, p_error text default null)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  select id into v_id from public.message_queue where wa_message_id = p_wa_id;
  if v_id is null then return 'unknown'; end if;
  case p_status
    when 'delivered' then
      update public.message_queue set status = case when status = 'read' then status else 'delivered' end,
                                      delivered_at = coalesce(delivered_at, now()) where id = v_id;
    when 'read' then
      update public.message_queue set status = 'read', read_at = coalesce(read_at, now()),
                                      delivered_at = coalesce(delivered_at, now()) where id = v_id;
    when 'failed' then
      update public.message_queue set wa_message_id = null where id = v_id;
      return public.whatsapp_result(v_id, false, null, p_error);
    else
      return 'ignored';
  end case;
  return p_status;
end;
$$;

-- A message from a member's number. STOP turns WhatsApp off, START turns it
-- back on. Returns the member and their utility messages due in the next 24
-- hours, which the webhook sends now while the window is open (8.11).
create or replace function public.whatsapp_inbound(p_phone text, p_text text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_digits text := right(regexp_replace(coalesce(p_phone, ''), '\D', '', 'g'), 10);
  v_m      public.members%rowtype;
  v_cmd    text := upper(trim(coalesce(p_text, '')));
begin
  if length(v_digits) <> 10 then return jsonb_build_object('member_id', null); end if;
  select * into v_m from public.members
   where right(regexp_replace(phone, '\D', '', 'g'), 10) = v_digits and archived_at is null
   order by created_at limit 1;
  if not found then return jsonb_build_object('member_id', null); end if;
  update public.members set whatsapp_last_inbound_at = now() where id = v_m.id;
  if v_cmd in ('STOP', 'UNSUBSCRIBE', 'STOP ALL', 'बंद') then
    if not v_m.whatsapp_opt_out then
      update public.members set whatsapp_opt_out = true where id = v_m.id;
    end if;
    return jsonb_build_object('member_id', v_m.id, 'opted_out', true, 'send_now', '[]'::jsonb);
  end if;
  if v_cmd in ('START', 'UNSTOP') and v_m.whatsapp_opt_out then
    update public.members set whatsapp_opt_out = false, consent_whatsapp_at = coalesce(consent_whatsapp_at, now())
     where id = v_m.id;
  end if;
  if v_m.whatsapp_opt_out and v_cmd not in ('START', 'UNSTOP') then
    return jsonb_build_object('member_id', v_m.id, 'opted_out', true, 'send_now', '[]'::jsonb);
  end if;
  update public.message_queue set scheduled_for = now()
   where member_id = v_m.id and channel = 'api' and status = 'queued' and category = 'utility'
     and scheduled_for between now() and now() + interval '24 hours';
  return jsonb_build_object('member_id', v_m.id, 'opted_out', false,
    'send_now', coalesce((select jsonb_agg(id) from public.message_queue
                          where member_id = v_m.id and channel = 'api' and status = 'queued' and category = 'utility'
                            and scheduled_for <= now()), '[]'::jsonb));
end;
$$;

-- ---------------------------------------------------------------------------
-- Cost meter (8.14): this month's API sends and estimated spend
-- ---------------------------------------------------------------------------
create or replace function public.whatsapp_cost_month()
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_from timestamptz := date_trunc('month', now() at time zone 'Asia/Kolkata') at time zone 'Asia/Kolkata';
  v_prices jsonb := coalesce((select value from public.settings where key = 'whatsapp_prices'), '{}');
  v_u int; v_m int; v_free int; v_link int;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  select count(*) filter (where category = 'utility' and not free_window),
         count(*) filter (where category = 'marketing' and not free_window),
         count(*) filter (where free_window)
    into v_u, v_m, v_free
    from public.message_queue
   where channel = 'api' and status in ('sent', 'delivered', 'read') and sent_at >= v_from;
  select count(*) into v_link from public.message_queue
   where channel = 'link' and status = 'sent' and sent_at >= v_from;
  return jsonb_build_object(
    'utility_sent', v_u,
    'marketing_sent', v_m,
    'free_window_sent', v_free,
    'link_sent', v_link,
    'utility_paise', (v_u * coalesce((v_prices ->> 'utility_per_100_paise')::int, 0)) / 100,
    'marketing_paise', (v_m * coalesce((v_prices ->> 'marketing_per_100_paise')::int, 0)) / 100,
    'cap_paise', coalesce((select (value #>> '{}')::int from public.settings where key = 'whatsapp_marketing_cap_paise'), 0),
    'marketing_paused', public._marketing_paused());
end;
$$;

-- ---------------------------------------------------------------------------
-- Seed: templates in English and Hindi (8.1)
-- ---------------------------------------------------------------------------
insert into public.message_templates (key, language, category, title, body) values
  ('expiry_soon', 'en', 'utility', 'Membership ending soon',
   'Hi {first_name}, your {plan} membership at {gym_name} ends on {end_date} ({days} days left). Renew at the desk or reply here to keep going 💪'),
  ('expiry_soon', 'hi', 'utility', 'मेंबरशिप ख़त्म होने वाली है',
   'नमस्ते {first_name}, {gym_name} में आपकी {plan} मेंबरशिप {end_date} को ख़त्म हो रही है ({days} दिन बाकी)। जारी रखने के लिए डेस्क पर रिन्यू करें या यहाँ जवाब दें 💪'),
  ('expiry_today', 'en', 'utility', 'Membership ends today',
   'Hi {first_name}, your {plan} membership at {gym_name} ends today. Renew now so your workouts don''t stop.'),
  ('expiry_today', 'hi', 'utility', 'मेंबरशिप आज ख़त्म',
   'नमस्ते {first_name}, {gym_name} में आपकी {plan} मेंबरशिप आज ख़त्म हो रही है। वर्कआउट जारी रखने के लिए आज ही रिन्यू करें।'),
  ('expired', 'en', 'utility', 'Membership ended',
   'Hi {first_name}, we miss you at {gym_name}! Your {plan} membership ended on {end_date}. Come back and renew, and we''ll help you pick up where you left off.'),
  ('expired', 'hi', 'utility', 'मेंबरशिप ख़त्म हो गई',
   'नमस्ते {first_name}, {gym_name} में हम आपको याद कर रहे हैं! आपकी {plan} मेंबरशिप {end_date} को ख़त्म हो गई। वापस आइए और रिन्यू कीजिए, हम फिर से शुरुआत में मदद करेंगे।'),
  ('dues_reminder', 'en', 'utility', 'Fee reminder with pay link',
   'Hi {first_name}, {amount} for {invoice_no} is due on {due_date} at {gym_name}. Pay by UPI: {pay_link} or at the desk. Thank you!'),
  ('dues_reminder', 'hi', 'utility', 'फ़ीस रिमाइंडर (पे लिंक के साथ)',
   'नमस्ते {first_name}, {gym_name} में {invoice_no} के {amount} {due_date} तक जमा करने हैं। UPI से भुगतान करें: {pay_link} या डेस्क पर। धन्यवाद!'),
  ('dues_reminder_desk', 'en', 'utility', 'Fee reminder',
   'Hi {first_name}, {amount} for {invoice_no} is due on {due_date} at {gym_name}. Please pay at the desk. Thank you!'),
  ('dues_reminder_desk', 'hi', 'utility', 'फ़ीस रिमाइंडर',
   'नमस्ते {first_name}, {gym_name} में {invoice_no} के {amount} {due_date} तक जमा करने हैं। कृपया डेस्क पर भुगतान करें। धन्यवाद!'),
  ('payment_received', 'en', 'utility', 'Payment received',
   'Hi {first_name}, we''ve received {amount} (receipt {receipt_no}). Thank you for training with {gym_name}!'),
  ('payment_received', 'hi', 'utility', 'भुगतान मिल गया',
   'नमस्ते {first_name}, हमें {amount} मिल गए (रसीद {receipt_no})। {gym_name} के साथ ट्रेनिंग के लिए धन्यवाद!'),
  ('membership_started', 'en', 'utility', 'Membership started',
   'Welcome to {gym_name}, {first_name}! Your {plan} membership runs from {start_date} to {end_date}. See you on the floor 💪'),
  ('membership_started', 'hi', 'utility', 'मेंबरशिप शुरू',
   '{gym_name} में आपका स्वागत है, {first_name}! आपकी {plan} मेंबरशिप {start_date} से {end_date} तक है। जिम में मिलते हैं 💪'),
  ('membership_renewed', 'en', 'utility', 'Membership renewed',
   'Thanks for renewing, {first_name}! Your {plan} membership at {gym_name} now runs until {end_date}.'),
  ('membership_renewed', 'hi', 'utility', 'मेंबरशिप रिन्यू',
   'रिन्यू करने के लिए धन्यवाद, {first_name}! {gym_name} में आपकी {plan} मेंबरशिप अब {end_date} तक है।'),
  ('program_assigned', 'en', 'utility', 'New workout program',
   'Hi {first_name}, your trainer has set up a new workout program for you. Open the {gym_name} app to see today''s workout.'),
  ('program_assigned', 'hi', 'utility', 'नया वर्कआउट प्रोग्राम',
   'नमस्ते {first_name}, आपके ट्रेनर ने आपके लिए नया वर्कआउट प्रोग्राम बनाया है। आज का वर्कआउट देखने के लिए {gym_name} ऐप खोलें।'),
  ('diet_assigned', 'en', 'utility', 'New diet plan',
   'Hi {first_name}, your trainer has shared a new diet plan with you. Open the {gym_name} app to see today''s meals.'),
  ('diet_assigned', 'hi', 'utility', 'नया डाइट प्लान',
   'नमस्ते {first_name}, आपके ट्रेनर ने आपके लिए नया डाइट प्लान भेजा है। आज के मील देखने के लिए {gym_name} ऐप खोलें।'),
  ('birthday', 'en', 'marketing', 'Birthday wishes',
   'Happy birthday, {first_name}! 🎂 Everyone at {gym_name} wishes you a strong, healthy year ahead.'),
  ('birthday', 'hi', 'marketing', 'जन्मदिन की शुभकामनाएँ',
   'जन्मदिन मुबारक हो, {first_name}! 🎂 {gym_name} की पूरी टीम की ओर से आपको स्वस्थ और ताक़तवर साल की शुभकामनाएँ।'),
  ('festival', 'en', 'marketing', 'Festival wishes',
   'Happy {festival}, {first_name}! Warm wishes from all of us at {gym_name}.'),
  ('festival', 'hi', 'marketing', 'त्योहार की शुभकामनाएँ',
   '{festival} की हार्दिक शुभकामनाएँ, {first_name}! {gym_name} की पूरी टीम की ओर से।')
on conflict (key, language) do nothing;
update public.message_templates set is_system = true where key in
  ('expiry_soon', 'expiry_today', 'expired', 'dues_reminder', 'dues_reminder_desk', 'payment_received',
   'membership_started', 'membership_renewed', 'program_assigned', 'diet_assigned', 'birthday', 'festival');

-- The festival calendar (8.6) for the coming year. Dates of lunar festivals
-- move every year and Eid depends on the moon (it starts switched off):
-- the owner checks them in Settings.
insert into public.festivals (name, local_name, day, is_enabled) values
  ('Chhath Puja', 'छठ पूजा', '2026-11-15', true),
  ('Guru Nanak Jayanti', 'गुरु नानक जयंती', '2026-11-24', true),
  ('Christmas', 'क्रिसमस', '2026-12-25', true),
  ('New Year', 'नया साल', '2027-01-01', true),
  ('Makar Sankranti', 'मकर संक्रांति', '2027-01-15', true),
  ('Republic Day', 'गणतंत्र दिवस', '2027-01-26', true),
  ('Eid ul-Fitr', 'ईद-उल-फ़ित्र', '2027-03-10', false),
  ('Holi', 'होली', '2027-03-22', true),
  ('Independence Day', 'स्वतंत्रता दिवस', '2027-08-15', true),
  ('Dussehra', 'दशहरा', '2027-10-09', true),
  ('Diwali', 'दीवाली', '2027-10-29', true)
on conflict (name, day) do nothing;

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------
grant execute on function
  public.whatsapp_settings(), public.segment_count(jsonb), public.create_broadcast(text, text, text, jsonb, timestamptz),
  public.build_message_queue(date), public.mark_message(uuid, text), public.log_manual_message(uuid, text),
  public.set_whatsapp_opt_out(boolean, uuid), public.whatsapp_cost_month()
to authenticated;
revoke execute on function
  public.whatsapp_settings(), public.segment_count(jsonb), public.create_broadcast(text, text, text, jsonb, timestamptz),
  public.build_message_queue(date), public.mark_message(uuid, text), public.log_manual_message(uuid, text),
  public.set_whatsapp_opt_out(boolean, uuid), public.whatsapp_cost_month()
from public, anon;
-- Service role only (the Edge Functions).
revoke execute on function
  public._whatsapp_mode(), public._automation_on(text), public._upi_link(int, text), public._marketing_paused(),
  public.whatsapp_claim(int), public.whatsapp_result(uuid, boolean, text, text, boolean, boolean),
  public.whatsapp_status(text, text, text), public.whatsapp_inbound(text, text)
from public, anon, authenticated;

-- Switching modes moves what is waiting (8.10): to API mode, the free-mode
-- messages the API never tried go out automatically; back to free mode,
-- nothing is left waiting on an API that is off.
create or replace function public._whatsapp_mode_changed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.key = 'whatsapp_mode' and new.value is distinct from old.value then
    if new.value #>> '{}' = 'api' then
      update public.message_queue set channel = 'api'
       where channel = 'link' and status = 'queued' and attempts = 0 and error is null;
    else
      update public.message_queue set channel = 'link'
       where channel = 'api' and status in ('queued', 'sending');
    end if;
  end if;
  return null;
end;
$$;
create trigger settings_whatsapp_mode after update on public.settings
  for each row execute function public._whatsapp_mode_changed();

-- Daily queue at 07:30 IST (02:00 UTC). API sending is scheduled separately
-- (README): it needs the project URL and a secret.
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.schedule('build_message_queue', '0 2 * * *', 'select public.build_message_queue()');
  end if;
end $$;
