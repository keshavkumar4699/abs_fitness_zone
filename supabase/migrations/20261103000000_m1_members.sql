-- ABS Fitness — Milestone M1: members (F1)
-- Plans and add-ons, memberships with freeze/renew/cancel/transfer, the status
-- engine, health and body measurements, attendance (desk / QR / trainer),
-- member history timeline, dashboard counts, CSV import, and their RLS.
-- Money in integer paise; dates are IST calendar dates.

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
create or replace function public.ist_today()
returns date
language sql
stable
as $$
  select (now() at time zone 'Asia/Kolkata')::date
$$;

create or replace function public.setting_int(p_key text, p_default int)
returns int
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select (value #>> '{}')::int from public.settings where key = p_key), p_default)
$$;

create or replace function public.setting_text(p_key text, p_default text)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select value #>> '{}' from public.settings where key = p_key), p_default)
$$;

insert into public.settings (key, value) values
  ('lapsed_renew_from', '"today"'),        -- 'today' or 'end' (day after old end)
  ('absent_days', '7'),
  ('inactive_after_days', '90'),
  ('checkin_secret', to_jsonb(encode(extensions.gen_random_bytes(24), 'hex')))
on conflict (key) do nothing;

-- ---------------------------------------------------------------------------
-- Members: extra columns, computed snapshot of the current membership
-- ---------------------------------------------------------------------------
alter table public.members drop constraint if exists members_status_check;
alter table public.members add constraint members_status_check
  check (status in ('active','expiring','expired','frozen','cancelled','inactive','pending','upcoming'));

alter table public.members
  add column if not exists current_membership_id uuid,
  add column if not exists plan_name text,
  add column if not exists membership_start date,
  add column if not exists membership_end date;

alter table public.members
  add column if not exists dob_month smallint generated always as (extract(month from dob)::smallint) stored;

create index if not exists members_end on public.members (membership_end) where archived_at is null;
create index if not exists members_dob_month on public.members (dob_month) where archived_at is null;
create index if not exists members_code on public.members (member_code);

-- ---------------------------------------------------------------------------
-- Plans and add-ons (1.4, 1.5)
-- ---------------------------------------------------------------------------
create table public.plans (
  id                  uuid primary key default gen_random_uuid(),
  name                text not null check (length(trim(name)) between 1 and 80),
  duration_value      int not null check (duration_value between 1 and 3650),
  duration_unit       text not null default 'months' check (duration_unit in ('days', 'months')),
  price_paise         int not null check (price_paise >= 0),
  joining_fee_paise   int not null default 0 check (joining_fee_paise >= 0),
  gst_rate            numeric(4, 2) not null default 0 check (gst_rate in (0, 5, 12, 18)),
  includes_pt         boolean not null default false,
  sessions_limit      int check (sessions_limit is null or sessions_limit > 0),
  freeze_days_allowed int not null default 0 check (freeze_days_allowed between 0 and 365),
  color               text not null default 'lime'
                        check (color in ('lime','sky','tangerine','bubblegum','grape','mint')),
  description         text,
  is_archived         boolean not null default false,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create trigger plans_touch before update on public.plans
  for each row execute function public.touch_updated_at();

create table public.addons (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (length(trim(name)) between 1 and 80),
  price_paise int not null check (price_paise >= 0),
  kind        text not null default 'other' check (kind in ('pt', 'locker', 'diet', 'other')),
  is_archived boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create trigger addons_touch before update on public.addons
  for each row execute function public.touch_updated_at();

-- End date for a plan starting on p_start (inclusive range).
create or replace function public.plan_end_date(p_start date, p_value int, p_unit text)
returns date
language sql
immutable
as $$
  select case p_unit
    when 'months' then (p_start + make_interval(months => p_value))::date - 1
    else p_start + p_value - 1
  end
$$;

-- ---------------------------------------------------------------------------
-- Memberships (1.6 – 1.9)
-- ---------------------------------------------------------------------------
create table public.memberships (
  id                     uuid primary key default gen_random_uuid(),
  member_id              uuid not null references public.members (id) on delete cascade,
  plan_id                uuid not null references public.plans (id) on delete restrict,
  plan_name              text not null,
  start_date             date not null,
  end_date               date not null,
  status                 text not null default 'active'
                           check (status in ('upcoming','active','expiring','expired','frozen','cancelled','inactive')),
  price_paise            int not null check (price_paise >= 0),
  joining_fee_paise      int not null default 0 check (joining_fee_paise >= 0),
  addons_paise           int not null default 0 check (addons_paise >= 0),
  discount_paise         int not null default 0 check (discount_paise >= 0),
  discount_reason        text,
  freeze_days_used       int not null default 0 check (freeze_days_used >= 0),
  previous_membership_id uuid references public.memberships (id) on delete set null,
  source                 text not null default 'new' check (source in ('new','renewal','transfer','import')),
  cancelled_at           timestamptz,
  cancelled_reason       text,
  refund_paise           int not null default 0 check (refund_paise >= 0),
  created_by             uuid,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now(),
  constraint membership_dates check (end_date >= start_date),
  constraint membership_discount check (discount_paise <= price_paise + joining_fee_paise + addons_paise)
);
create trigger memberships_touch before update on public.memberships
  for each row execute function public.touch_updated_at();
create index memberships_member on public.memberships (member_id, end_date desc);
create index memberships_end_status on public.memberships (end_date, status);

create table public.membership_addons (
  id            uuid primary key default gen_random_uuid(),
  membership_id uuid not null references public.memberships (id) on delete cascade,
  addon_id      uuid not null references public.addons (id) on delete restrict,
  name          text not null,
  price_paise   int not null check (price_paise >= 0)
);
create index membership_addons_membership on public.membership_addons (membership_id);

create table public.membership_freezes (
  id            uuid primary key default gen_random_uuid(),
  membership_id uuid not null references public.memberships (id) on delete cascade,
  from_date     date not null,
  to_date       date not null,
  reason        text,
  created_by    uuid,
  ended_early_on date,
  created_at    timestamptz not null default now(),
  constraint freeze_dates check (to_date >= from_date)
);
create index membership_freezes_membership on public.membership_freezes (membership_id);

-- ---------------------------------------------------------------------------
-- Health (1.2), measurements (1.3): sensitive, member + owner + own trainer
-- ---------------------------------------------------------------------------
create table public.member_health (
  member_id        uuid primary key references public.members (id) on delete cascade,
  height_cm        numeric(5, 1) check (height_cm is null or height_cm between 50 and 260),
  weight_kg        numeric(5, 1) check (weight_kg is null or weight_kg between 20 and 350),
  conditions       text,
  injuries         text,
  medications      text,
  parq             jsonb not null default '{}'::jsonb,
  doctor_clearance boolean not null default false,
  updated_at       timestamptz not null default now(),
  updated_by       uuid
);
create trigger member_health_touch before update on public.member_health
  for each row execute function public.touch_updated_at();

create table public.member_measurements (
  id          uuid primary key default gen_random_uuid(),
  member_id   uuid not null references public.members (id) on delete cascade,
  measured_on date not null default public.ist_today(),
  weight_kg   numeric(5, 1) check (weight_kg is null or weight_kg between 20 and 350),
  body_fat    numeric(4, 1) check (body_fat is null or body_fat between 2 and 70),
  chest       numeric(5, 1),
  waist       numeric(5, 1),
  hips        numeric(5, 1),
  arms        numeric(5, 1),
  thighs      numeric(5, 1),
  notes       text,
  created_by  uuid,
  created_at  timestamptz not null default now()
);
create index member_measurements_member on public.member_measurements (member_id, measured_on desc);

-- ---------------------------------------------------------------------------
-- Attendance (1.12): one check-in per member per IST day
-- ---------------------------------------------------------------------------
create table public.attendance (
  id             uuid primary key default gen_random_uuid(),
  member_id      uuid not null references public.members (id) on delete cascade,
  day            date not null default public.ist_today(),
  checked_in_at  timestamptz not null default now(),
  checked_out_at timestamptz,
  method         text not null check (method in ('desk', 'qr', 'trainer')),
  marked_by      uuid,
  constraint attendance_once_per_day unique (member_id, day)
);
create index attendance_day on public.attendance (day);

-- ---------------------------------------------------------------------------
-- History timeline (1.11)
-- ---------------------------------------------------------------------------
create table public.member_events (
  id        bigint generated always as identity primary key,
  member_id uuid not null references public.members (id) on delete cascade,
  kind      text not null check (kind in (
              'joined','membership_started','renewed','frozen','unfrozen','cancelled',
              'transferred_in','transferred_out','note','profile_updated','pin_set','imported','archived','restored')),
  title     text not null,
  data      jsonb not null default '{}'::jsonb,
  actor_id  uuid,
  at        timestamptz not null default now()
);
create index member_events_member on public.member_events (member_id, at desc);

create or replace function public.log_member_event(p_member_id uuid, p_kind text, p_title text, p_data jsonb default '{}')
returns void
language sql
security definer
set search_path = public
as $$
  insert into public.member_events (member_id, kind, title, data, actor_id)
  values (p_member_id, p_kind, p_title, coalesce(p_data, '{}'::jsonb), auth.uid())
$$;
revoke execute on function public.log_member_event(uuid, text, text, jsonb) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Status engine (1.10)
-- ---------------------------------------------------------------------------
create or replace function public.membership_status_for(
  p_start date, p_end date, p_cancelled boolean, p_frozen boolean,
  p_today date, p_window int, p_inactive_after int)
returns text
language sql
immutable
as $$
  select case
    when p_cancelled then 'cancelled'
    when p_frozen then 'frozen'
    when p_today < p_start then 'upcoming'
    when p_today > p_end and p_today - p_end >= p_inactive_after then 'inactive'
    when p_today > p_end then 'expired'
    when p_end - p_today < p_window then 'expiring'
    else 'active'
  end
$$;

create or replace function public.refresh_member_status(p_member_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today    date := public.ist_today();
  v_window   int := public.setting_int('expiring_window_days', 7);
  v_inactive int := public.setting_int('inactive_after_days', 90);
  v_current  public.memberships%rowtype;
  v_status   text;
  v_any      boolean;
begin
  update public.memberships m
     set status = public.membership_status_for(
           m.start_date, m.end_date, m.cancelled_at is not null,
           exists (select 1 from public.membership_freezes f
                   where f.membership_id = m.id and v_today between f.from_date and f.to_date),
           v_today, v_window, v_inactive)
   where m.member_id = p_member_id
     and m.status is distinct from public.membership_status_for(
           m.start_date, m.end_date, m.cancelled_at is not null,
           exists (select 1 from public.membership_freezes f
                   where f.membership_id = m.id and v_today between f.from_date and f.to_date),
           v_today, v_window, v_inactive);

  -- Current = covering today, else the next upcoming, else the latest ended.
  select * into v_current
  from public.memberships m
  where m.member_id = p_member_id and m.cancelled_at is null
  order by
    case when m.start_date <= v_today and m.end_date >= v_today then 0
         when m.start_date > v_today then 1 else 2 end,
    case when m.start_date > v_today then m.start_date end asc,
    m.end_date desc
  limit 1;

  if found then
    v_status := v_current.status;
  else
    select exists (select 1 from public.memberships where member_id = p_member_id) into v_any;
    v_status := case when v_any then 'cancelled' else null end;
  end if;

  update public.members mb
     set status = coalesce(v_status, case when mb.status = 'pending' then 'pending' else 'inactive' end),
         current_membership_id = v_current.id,
         plan_name = v_current.plan_name,
         membership_start = v_current.start_date,
         membership_end = v_current.end_date
   where mb.id = p_member_id
     and (mb.status, mb.current_membership_id, mb.plan_name, mb.membership_start, mb.membership_end)
         is distinct from
         (coalesce(v_status, case when mb.status = 'pending' then 'pending' else 'inactive' end),
          v_current.id, v_current.plan_name, v_current.start_date, v_current.end_date);
end;
$$;
revoke execute on function public.refresh_member_status(uuid) from public, anon;

-- Nightly at 00:05 IST: statuses move with the calendar (expiring, expired,
-- inactive, auto-unfreeze).
create or replace function public.refresh_statuses()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_n  int := 0;
begin
  for v_id in select id from public.members where archived_at is null loop
    perform public.refresh_member_status(v_id);
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;
revoke execute on function public.refresh_statuses() from public, anon, authenticated;

create or replace function public.memberships_changed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.refresh_member_status(coalesce(new.member_id, old.member_id));
  return null;
end;
$$;
-- Only real changes (not the status column itself) re-run the engine.
create trigger memberships_refresh_ins_del after insert or delete on public.memberships
  for each row execute function public.memberships_changed();
create trigger memberships_refresh_upd after update of start_date, end_date, cancelled_at on public.memberships
  for each row execute function public.memberships_changed();

create or replace function public.freezes_changed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.refresh_member_status(
    (select member_id from public.memberships where id = coalesce(new.membership_id, old.membership_id)));
  return null;
end;
$$;
create trigger freezes_refresh after insert or update or delete on public.membership_freezes
  for each row execute function public.freezes_changed();

-- Computed member columns can only be changed by the engine, never by API calls.
create or replace function public.members_guard()
returns trigger
language plpgsql
as $$
begin
  if current_user in ('authenticated', 'anon') and (
       new.status is distinct from old.status
    or new.current_membership_id is distinct from old.current_membership_id
    or new.plan_name is distinct from old.plan_name
    or new.membership_start is distinct from old.membership_start
    or new.membership_end is distinct from old.membership_end
    or new.member_code is distinct from old.member_code) then
    raise exception 'computed member fields are read-only' using errcode = '42501';
  end if;
  return new;
end;
$$;
create trigger members_guard before update on public.members
  for each row execute function public.members_guard();

-- New members start without a status; the engine sets it.
create or replace function public.members_guard_insert()
returns trigger
language plpgsql
as $$
begin
  if current_user in ('authenticated', 'anon') then
    new.status := 'inactive';
    new.current_membership_id := null;
    new.plan_name := null;
    new.membership_start := null;
    new.membership_end := null;
  end if;
  return new;
end;
$$;
create trigger members_guard_insert before insert on public.members
  for each row execute function public.members_guard_insert();

-- Profile edits show up in the timeline.
create or replace function public.members_audit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_skip text[] := array['status','current_membership_id','plan_name','membership_start','membership_end','updated_at'];
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
    else
      perform public.log_member_event(new.id, 'profile_updated', 'Profile updated', jsonb_build_object('fields', v_changed));
    end if;
  end if;
  return null;
end;
$$;
create trigger members_audit after update on public.members
  for each row execute function public.members_audit();

-- ---------------------------------------------------------------------------
-- Membership RPCs
-- ---------------------------------------------------------------------------
create or replace function public._create_membership(
  p_member_id uuid, p_plan_id uuid, p_start date, p_discount_paise int, p_discount_reason text,
  p_addon_ids uuid[], p_source text, p_previous uuid, p_end date default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_plan    public.plans%rowtype;
  v_id      uuid;
  v_end     date;
  v_joining int;
  v_addons  int;
begin
  select * into v_plan from public.plans where id = p_plan_id;
  if not found then raise exception 'plan not found' using errcode = 'P0002'; end if;
  if v_plan.is_archived and p_source <> 'import' then
    raise exception 'this plan is archived' using errcode = '22023';
  end if;
  if not exists (select 1 from public.members where id = p_member_id and archived_at is null) then
    raise exception 'member not found' using errcode = 'P0002';
  end if;
  v_end := coalesce(p_end, public.plan_end_date(p_start, v_plan.duration_value, v_plan.duration_unit));
  if exists (
    select 1 from public.memberships m
    where m.member_id = p_member_id and m.cancelled_at is null
      and daterange(m.start_date, m.end_date, '[]') && daterange(p_start, v_end, '[]')) then
    raise exception 'dates overlap an existing membership; renew instead' using errcode = '23P01';
  end if;
  -- Joining fee only on a member's first membership.
  v_joining := case when p_source = 'new' and not exists (select 1 from public.memberships where member_id = p_member_id)
                    then v_plan.joining_fee_paise else 0 end;
  select coalesce(sum(price_paise), 0) into v_addons from public.addons where id = any (coalesce(p_addon_ids, '{}'));
  if coalesce(p_discount_paise, 0) > 0 and coalesce(trim(p_discount_reason), '') = '' then
    raise exception 'a discount needs a reason' using errcode = '22023';
  end if;

  insert into public.memberships (member_id, plan_id, plan_name, start_date, end_date, price_paise, joining_fee_paise,
                                  addons_paise, discount_paise, discount_reason, previous_membership_id, source, created_by)
  values (p_member_id, v_plan.id, v_plan.name, p_start, v_end,
          case when p_source = 'transfer' then 0 else v_plan.price_paise end, v_joining, v_addons,
          coalesce(p_discount_paise, 0), nullif(trim(p_discount_reason), ''), p_previous, p_source, auth.uid())
  returning id into v_id;

  insert into public.membership_addons (membership_id, addon_id, name, price_paise)
  select v_id, a.id, a.name, a.price_paise from public.addons a where a.id = any (coalesce(p_addon_ids, '{}'));
  return v_id;
end;
$$;
revoke execute on function public._create_membership(uuid, uuid, date, int, text, uuid[], text, uuid, date) from public, anon, authenticated;

create or replace function public.start_membership(
  p_member_id uuid, p_plan_id uuid, p_start date default null,
  p_discount_paise int default 0, p_discount_reason text default null, p_addon_ids uuid[] default '{}')
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  v_id := public._create_membership(p_member_id, p_plan_id, coalesce(p_start, public.ist_today()),
                                    p_discount_paise, p_discount_reason, p_addon_ids, 'new', null);
  perform public.log_member_event(p_member_id, 'membership_started',
    (select plan_name || ' started' from public.memberships where id = v_id), jsonb_build_object('membership_id', v_id));
  return v_id;
end;
$$;
revoke execute on function public.start_membership(uuid, uuid, date, int, text, uuid[]) from public, anon;

-- Renew with the same plan (or another): starts the day after the current end
-- (early renewal keeps remaining days) or today if lapsed (configurable).
create or replace function public.renew_membership(
  p_member_id uuid, p_plan_id uuid default null,
  p_discount_paise int default 0, p_discount_reason text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_last  public.memberships%rowtype;
  v_today date := public.ist_today();
  v_start date;
  v_id    uuid;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_last from public.memberships
  where member_id = p_member_id and cancelled_at is null
  order by end_date desc limit 1;
  if not found then raise exception 'no membership to renew; start one instead' using errcode = 'P0002'; end if;

  if v_last.end_date >= v_today then
    v_start := v_last.end_date + 1;
  elsif public.setting_text('lapsed_renew_from', 'today') = 'end' then
    v_start := v_last.end_date + 1;
  else
    v_start := v_today;
  end if;

  v_id := public._create_membership(p_member_id, coalesce(p_plan_id, v_last.plan_id), v_start,
                                    p_discount_paise, p_discount_reason, '{}', 'renewal', v_last.id);
  perform public.log_member_event(p_member_id, 'renewed',
    (select plan_name || ' renewed' from public.memberships where id = v_id),
    jsonb_build_object('membership_id', v_id, 'start', v_start));
  return v_id;
end;
$$;
revoke execute on function public.renew_membership(uuid, uuid, int, text) from public, anon;

create or replace function public.freeze_membership(p_membership_id uuid, p_from date, p_days int, p_reason text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_m       public.memberships%rowtype;
  v_allowed int;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_m from public.memberships where id = p_membership_id for update;
  if not found then raise exception 'membership not found' using errcode = 'P0002'; end if;
  if v_m.cancelled_at is not null then raise exception 'membership is cancelled' using errcode = '22023'; end if;
  if p_days is null or p_days < 1 then raise exception 'freeze needs at least 1 day' using errcode = '22023'; end if;
  select freeze_days_allowed into v_allowed from public.plans where id = v_m.plan_id;
  if v_m.freeze_days_used + p_days > v_allowed then
    raise exception 'only % freeze days left on this plan', greatest(v_allowed - v_m.freeze_days_used, 0)
      using errcode = '22023';
  end if;
  if p_from < greatest(v_m.start_date, public.ist_today()) or p_from > v_m.end_date then
    raise exception 'freeze must start between today and the membership end' using errcode = '22023';
  end if;
  if exists (select 1 from public.membership_freezes f where f.membership_id = v_m.id
             and daterange(f.from_date, f.to_date, '[]') && daterange(p_from, p_from + p_days - 1, '[]')) then
    raise exception 'overlaps another freeze' using errcode = '23P01';
  end if;

  update public.memberships
     set end_date = end_date + p_days, freeze_days_used = freeze_days_used + p_days
   where id = v_m.id;
  insert into public.membership_freezes (membership_id, from_date, to_date, reason, created_by)
  values (v_m.id, p_from, p_from + p_days - 1, nullif(trim(p_reason), ''), auth.uid());
  perform public.log_member_event(v_m.member_id, 'frozen', 'Frozen for ' || p_days || ' days',
    jsonb_build_object('from', p_from, 'days', p_days, 'reason', p_reason));
end;
$$;
revoke execute on function public.freeze_membership(uuid, date, int, text) from public, anon;

-- End the current (or a future) freeze today; unused days come back off the end date.
create or replace function public.unfreeze_membership(p_membership_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_f      public.membership_freezes%rowtype;
  v_today  date := public.ist_today();
  v_unused int;
  v_member uuid;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_f from public.membership_freezes
  where membership_id = p_membership_id and to_date >= v_today
  order by from_date limit 1 for update;
  if not found then raise exception 'no active freeze' using errcode = 'P0002'; end if;

  v_unused := v_f.to_date - greatest(v_f.from_date, v_today) + 1;
  update public.memberships
     set end_date = end_date - v_unused, freeze_days_used = greatest(freeze_days_used - v_unused, 0)
   where id = p_membership_id
  returning member_id into v_member;
  if v_f.from_date >= v_today then
    delete from public.membership_freezes where id = v_f.id;
  else
    update public.membership_freezes set to_date = v_today - 1, ended_early_on = v_today where id = v_f.id;
  end if;
  perform public.log_member_event(v_member, 'unfrozen', 'Unfrozen', jsonb_build_object('days_returned', v_unused));
end;
$$;
revoke execute on function public.unfreeze_membership(uuid) from public, anon;

create or replace function public.cancel_membership(p_membership_id uuid, p_reason text, p_refund_paise int default 0)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  if coalesce(trim(p_reason), '') = '' then raise exception 'a reason is required' using errcode = '22023'; end if;
  update public.memberships
     set cancelled_at = now(), cancelled_reason = trim(p_reason), refund_paise = greatest(coalesce(p_refund_paise, 0), 0)
   where id = p_membership_id and cancelled_at is null
  returning member_id into v_member;
  if v_member is null then raise exception 'membership not found or already cancelled' using errcode = 'P0002'; end if;
  perform public.log_member_event(v_member, 'cancelled', 'Membership cancelled',
    jsonb_build_object('reason', p_reason, 'refund_paise', p_refund_paise));
end;
$$;
revoke execute on function public.cancel_membership(uuid, text, int) from public, anon;

-- Owner: move the remaining days of a membership to another member.
create or replace function public.transfer_membership(p_membership_id uuid, p_to_member_id uuid)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_m      public.memberships%rowtype;
  v_today  date := public.ist_today();
  v_days   int;
  v_start  date;
  v_to     public.members%rowtype;
  v_from   public.members%rowtype;
  v_id     uuid;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_m from public.memberships where id = p_membership_id and cancelled_at is null for update;
  if not found then raise exception 'membership not found' using errcode = 'P0002'; end if;
  if v_m.member_id = p_to_member_id then raise exception 'pick a different member' using errcode = '22023'; end if;
  select * into v_to from public.members where id = p_to_member_id and archived_at is null;
  if not found then raise exception 'member not found' using errcode = 'P0002'; end if;
  select * into v_from from public.members where id = v_m.member_id;

  v_days := v_m.end_date - greatest(v_m.start_date, v_today) + 1;
  if v_days < 1 then raise exception 'no days left to transfer' using errcode = '22023'; end if;
  -- Start after the receiver's own current membership, if any.
  select greatest(v_today, coalesce(max(end_date) + 1, v_today)) into v_start
  from public.memberships where member_id = p_to_member_id and cancelled_at is null and end_date >= v_today;

  update public.memberships
     set cancelled_at = now(), cancelled_reason = 'Transferred to ' || v_to.member_code
   where id = v_m.id;
  v_id := public._create_membership(p_to_member_id, v_m.plan_id, v_start, 0, null, '{}', 'transfer', v_m.id,
                                    v_start + v_days - 1);
  perform public.log_member_event(v_m.member_id, 'transferred_out', v_days || ' days transferred to ' || v_to.name,
    jsonb_build_object('to', p_to_member_id, 'days', v_days));
  perform public.log_member_event(p_to_member_id, 'transferred_in', v_days || ' days received from ' || v_from.name,
    jsonb_build_object('from', v_m.member_id, 'days', v_days, 'membership_id', v_id));
  return v_id;
end;
$$;
revoke execute on function public.transfer_membership(uuid, uuid) from public, anon;

-- ---------------------------------------------------------------------------
-- Add member (3-step flow in one transaction)
-- ---------------------------------------------------------------------------
create or replace function public.add_member(p_member jsonb, p_health jsonb default null, p_membership jsonb default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;

  insert into public.members (name, phone, alt_phone, email, gender, dob, address, emergency_name, emergency_relation,
                              emergency_phone, blood_group, goal, level, diet_pref, language, trainer_id, batch, source,
                              joined_on, notes, photo_url, consent_health_at, consent_whatsapp_at, status)
  values (trim(p_member->>'name'), p_member->>'phone', nullif(p_member->>'alt_phone', ''), nullif(lower(p_member->>'email'), ''),
          nullif(p_member->>'gender', ''), nullif(p_member->>'dob', '')::date, nullif(p_member->>'address', ''),
          nullif(p_member->>'emergency_name', ''), nullif(p_member->>'emergency_relation', ''),
          nullif(p_member->>'emergency_phone', ''), nullif(p_member->>'blood_group', ''),
          nullif(p_member->>'goal', ''), nullif(p_member->>'level', ''), nullif(p_member->>'diet_pref', ''),
          coalesce(nullif(p_member->>'language', ''), 'en'), nullif(p_member->>'trainer_id', '')::uuid,
          nullif(p_member->>'batch', ''), nullif(p_member->>'source', ''),
          coalesce(nullif(p_member->>'joined_on', '')::date, public.ist_today()), nullif(p_member->>'notes', ''),
          nullif(p_member->>'photo_url', ''),
          case when (p_member->>'consent_health')::boolean then now() end,
          case when coalesce((p_member->>'consent_whatsapp')::boolean, true) then now() end,
          'inactive')
  returning id into v_id;

  if p_health is not null then
    insert into public.member_health (member_id, height_cm, weight_kg, conditions, injuries, medications, parq,
                                      doctor_clearance, updated_by)
    values (v_id, nullif(p_health->>'height_cm', '')::numeric, nullif(p_health->>'weight_kg', '')::numeric,
            nullif(p_health->>'conditions', ''), nullif(p_health->>'injuries', ''), nullif(p_health->>'medications', ''),
            coalesce(p_health->'parq', '{}'::jsonb), coalesce((p_health->>'doctor_clearance')::boolean, false), auth.uid());
  end if;

  perform public.log_member_event(v_id, 'joined', 'Joined the gym');

  if p_membership is not null and nullif(p_membership->>'plan_id', '') is not null then
    perform public._create_membership(v_id, (p_membership->>'plan_id')::uuid,
      coalesce(nullif(p_membership->>'start_date', '')::date, public.ist_today()),
      coalesce((p_membership->>'discount_paise')::int, 0), p_membership->>'discount_reason',
      coalesce(array(select jsonb_array_elements_text(p_membership->'addon_ids'))::uuid[], '{}'), 'new', null);
    perform public.log_member_event(v_id, 'membership_started',
      (select name || ' started' from public.plans where id = (p_membership->>'plan_id')::uuid));
  end if;
  return v_id;
end;
$$;
revoke execute on function public.add_member(jsonb, jsonb, jsonb) from public, anon;

create or replace function public.add_member_note(p_member_id uuid, p_text text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not (public.is_desk() or exists (
      select 1 from public.members where id = p_member_id and trainer_id = public.auth_staff_id())) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  if coalesce(trim(p_text), '') = '' then raise exception 'empty note' using errcode = '22023'; end if;
  perform public.log_member_event(p_member_id, 'note', left(trim(p_text), 2000));
end;
$$;
revoke execute on function public.add_member_note(uuid, text) from public, anon;

-- ---------------------------------------------------------------------------
-- Check-in (1.12)
-- ---------------------------------------------------------------------------
create or replace function public._check_in(p_member_id uuid, p_method text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_m       public.members%rowtype;
  v_row     public.attendance%rowtype;
  v_already boolean := false;
  v_today   date := public.ist_today();
begin
  select * into v_m from public.members where id = p_member_id and archived_at is null;
  if not found then raise exception 'member not found' using errcode = 'P0002'; end if;
  perform public.refresh_member_status(p_member_id);
  select * into v_m from public.members where id = p_member_id;

  insert into public.attendance (member_id, day, method, marked_by)
  values (p_member_id, v_today, p_method, auth.uid())
  on conflict (member_id, day) do nothing
  returning * into v_row;
  if v_row.id is null then
    v_already := true;
    select * into v_row from public.attendance where member_id = p_member_id and day = v_today;
  end if;

  return jsonb_build_object(
    'member_id', v_m.id, 'name', v_m.name, 'member_code', v_m.member_code, 'photo_url', v_m.photo_url,
    'status', v_m.status, 'plan_name', v_m.plan_name, 'membership_end', v_m.membership_end,
    'days_left', case when v_m.membership_end is null then null else v_m.membership_end - v_today end,
    'already', v_already, 'checked_in_at', v_row.checked_in_at);
end;
$$;
revoke execute on function public._check_in(uuid, text) from public, anon, authenticated;

-- Desk (search or QR scan) or a trainer for their own members.
create or replace function public.check_in(p_member_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.is_desk() then
    return public._check_in(p_member_id, 'desk');
  elsif public.auth_role() = 'trainer'
        and exists (select 1 from public.members where id = p_member_id and trainer_id = public.auth_staff_id()) then
    return public._check_in(p_member_id, 'trainer');
  end if;
  raise exception 'not allowed' using errcode = '42501';
end;
$$;
revoke execute on function public.check_in(uuid) from public, anon;

-- Today's gym code (rotates daily), derived from a secret: shown as a QR on
-- the desk screen, scanned by members to check themselves in.
create or replace function public._gym_code(p_day date)
returns text
language sql
stable
security definer
set search_path = public, extensions
as $$
  select 'ABSGYM-' || upper(substr(encode(extensions.hmac(p_day::text, public.setting_text('checkin_secret', ''), 'sha256'), 'hex'), 1, 10))
$$;
revoke execute on function public._gym_code(date) from public, anon, authenticated;

create or replace function public.todays_gym_code()
returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  return public._gym_code(public.ist_today());
end;
$$;
revoke execute on function public.todays_gym_code() from public, anon;

create or replace function public.self_check_in(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid := public.auth_member_id();
begin
  if v_member is null or public.auth_role() <> 'member' then raise exception 'not allowed' using errcode = '42501'; end if;
  if upper(trim(coalesce(p_code, ''))) <> public._gym_code(public.ist_today()) then
    raise exception 'this code is not valid today' using errcode = '22023';
  end if;
  return public._check_in(v_member, 'qr');
end;
$$;
revoke execute on function public.self_check_in(text) from public, anon;

-- ---------------------------------------------------------------------------
-- Dashboard (counts only in M1) and "needs action today"
-- These run as the caller, so RLS scopes trainers to their own members.
-- ---------------------------------------------------------------------------
create or replace function public.staff_dashboard()
returns jsonb
language sql
stable
security invoker
set search_path = public
as $$
  select jsonb_build_object(
    'active', count(*) filter (where status in ('active', 'expiring')),
    'expiring', count(*) filter (where status = 'expiring'),
    'expired', count(*) filter (where status = 'expired'),
    'frozen', count(*) filter (where status = 'frozen'),
    'total', count(*),
    'new_this_month', count(*) filter (where joined_on >= date_trunc('month', public.ist_today())::date),
    'checkins_today', (select count(*) from public.attendance a where a.day = public.ist_today()))
  from public.members
  where archived_at is null
$$;

create or replace function public.needs_action(p_limit int default 50)
returns table (member_id uuid, name text, phone text, photo_url text, reason text, detail text, sort_key int)
language sql
stable
security invoker
set search_path = public
as $$
  with t as (select public.ist_today() as today, public.setting_int('absent_days', 7) as absent)
  select * from (
    select m.id, m.name, m.phone, m.photo_url, 'renewal_due', m.membership_end::text, 1
    from public.members m, t
    where m.archived_at is null and m.status = 'expiring'
    union all
    select m.id, m.name, m.phone, m.photo_url, 'expired', m.membership_end::text, 2
    from public.members m, t
    where m.archived_at is null and m.status = 'expired' and m.membership_end >= t.today - 7
    union all
    select m.id, m.name, m.phone, m.photo_url, 'birthday', null, 3
    from public.members m, t
    where m.archived_at is null and m.dob is not null
      and extract(month from m.dob) = extract(month from t.today) and extract(day from m.dob) = extract(day from t.today)
    union all
    select m.id, m.name, m.phone, m.photo_url, 'absent',
           coalesce((select max(a.day) from public.attendance a where a.member_id = m.id)::text, ''), 4
    from public.members m, t
    where m.archived_at is null and m.status in ('active', 'expiring') and m.joined_on <= t.today - t.absent
      and not exists (select 1 from public.attendance a where a.member_id = m.id and a.day > t.today - t.absent)
  ) x(member_id, name, phone, photo_url, reason, detail, sort_key)
  order by sort_key, detail nulls last, name
  limit greatest(p_limit, 1)
$$;

-- ---------------------------------------------------------------------------
-- CSV import (1.15): validated row by row, duplicates by phone skipped
-- ---------------------------------------------------------------------------
create or replace function public.import_members(p_rows jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_row     jsonb;
  v_i       int := 0;
  v_out     jsonb := '[]'::jsonb;
  v_id      uuid;
  v_phone   text;
  v_plan    uuid;
  v_code    text;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if jsonb_array_length(p_rows) > 1000 then raise exception 'send at most 1000 rows per call' using errcode = '22023'; end if;

  for v_row in select * from jsonb_array_elements(p_rows) loop
    v_i := v_i + 1;
    v_phone := v_row->>'phone';
    begin
      if coalesce(trim(v_row->>'name'), '') = '' then
        raise exception 'name is missing' using errcode = '22023';
      end if;
      if v_phone is null or v_phone !~ '^\+91[6-9][0-9]{9}$' then
        raise exception 'phone is not a valid Indian mobile number' using errcode = '22023';
      end if;
      if exists (select 1 from public.members where phone = v_phone) then
        v_out := v_out || jsonb_build_object('row', coalesce((v_row->>'row')::int, v_i), 'status', 'duplicate',
                                             'message', 'phone already exists');
        continue;
      end if;

      insert into public.members (name, phone, email, gender, dob, address, joined_on, source, notes, status,
                                  consent_whatsapp_at)
      values (trim(v_row->>'name'), v_phone, nullif(lower(v_row->>'email'), ''), nullif(v_row->>'gender', ''),
              nullif(v_row->>'dob', '')::date, nullif(v_row->>'address', ''),
              coalesce(nullif(v_row->>'joined_on', '')::date, public.ist_today()), 'import',
              nullif(v_row->>'notes', ''), 'inactive', now())
      returning id, member_code into v_id, v_code;

      if nullif(v_row->>'plan', '') is not null then
        select id into v_plan from public.plans where lower(name) = lower(trim(v_row->>'plan')) limit 1;
        if v_plan is null then raise exception 'plan "%" not found', v_row->>'plan' using errcode = '22023'; end if;
        perform public._create_membership(v_id, v_plan,
          coalesce(nullif(v_row->>'start_date', '')::date, public.ist_today()), 0, null, '{}', 'import', null,
          nullif(v_row->>'end_date', '')::date);
      end if;
      perform public.log_member_event(v_id, 'imported', 'Imported from spreadsheet');
      v_out := v_out || jsonb_build_object('row', coalesce((v_row->>'row')::int, v_i), 'status', 'imported',
                                           'member_code', v_code);
    exception when others then
      v_out := v_out || jsonb_build_object('row', coalesce((v_row->>'row')::int, v_i), 'status', 'error',
                                           'message', sqlerrm);
    end;
  end loop;
  return v_out;
end;
$$;
revoke execute on function public.import_members(jsonb) from public, anon;

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
alter table public.plans               enable row level security;
alter table public.addons              enable row level security;
alter table public.memberships         enable row level security;
alter table public.membership_addons   enable row level security;
alter table public.membership_freezes  enable row level security;
alter table public.member_health       enable row level security;
alter table public.member_measurements enable row level security;
alter table public.attendance          enable row level security;
alter table public.member_events       enable row level security;

-- A member row the caller may see as their trainer.
create or replace function public.is_my_trainee(p_member_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.auth_role() = 'trainer'
     and exists (select 1 from public.members where id = p_member_id and trainer_id = public.auth_staff_id())
$$;

-- Catalogue: everyone signed in reads (members see what they can renew to).
create policy plans_read on public.plans for select to authenticated using (true);
create policy plans_owner on public.plans for all to authenticated using (public.is_owner()) with check (public.is_owner());
create policy addons_read on public.addons for select to authenticated using (true);
create policy addons_owner on public.addons for all to authenticated using (public.is_owner()) with check (public.is_owner());

-- Memberships: writes only through the RPCs above (owner may also edit).
create policy memberships_owner on public.memberships for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy memberships_read on public.memberships for select to authenticated
  using (public.is_desk() or public.is_my_trainee(member_id) or member_id = public.auth_member_id());
create policy membership_addons_read on public.membership_addons for select to authenticated
  using (exists (select 1 from public.memberships m where m.id = membership_id));
create policy membership_freezes_read on public.membership_freezes for select to authenticated
  using (exists (select 1 from public.memberships m where m.id = membership_id));

-- Health & measurements: member, owner and the assigned trainer only.
create policy health_owner on public.member_health for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy health_trainer on public.member_health for all to authenticated
  using (public.is_my_trainee(member_id)) with check (public.is_my_trainee(member_id));
create policy health_self on public.member_health for select to authenticated
  using (member_id = public.auth_member_id());

create policy measurements_owner on public.member_measurements for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy measurements_trainer on public.member_measurements for all to authenticated
  using (public.is_my_trainee(member_id)) with check (public.is_my_trainee(member_id));
create policy measurements_self on public.member_measurements for select to authenticated
  using (member_id = public.auth_member_id());

-- Attendance: written by the check-in RPCs; read by desk, own trainer, self.
create policy attendance_owner on public.attendance for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy attendance_read on public.attendance for select to authenticated
  using (public.is_desk() or public.is_my_trainee(member_id) or member_id = public.auth_member_id());

-- Timeline: staff only (it includes internal notes).
create policy events_read on public.member_events for select to authenticated
  using (public.is_desk() or public.is_my_trainee(member_id));

-- Members: let the assigned trainer read their members (M0 policy) — and let
-- front desk archive? No: archive and hard delete stay owner-only (M0 policy).

-- ---------------------------------------------------------------------------
-- Optional platform pieces (present on Supabase, skipped on plain Postgres)
-- ---------------------------------------------------------------------------
do $$
begin
  -- Nightly status refresh at 00:05 IST (18:35 UTC).
  if exists (select 1 from pg_available_extensions where name = 'pg_cron') then
    execute 'create extension if not exists pg_cron';
    perform cron.schedule('refresh_statuses', '35 18 * * *', 'select public.refresh_statuses()');
  end if;

  -- Live check-in feed on the dashboard.
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
     and not exists (select 1 from pg_publication_tables
                     where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'attendance') then
    execute 'alter publication supabase_realtime add table public.attendance';
  end if;

  -- Private bucket for member photos: <member_id>/photo.jpg
  if exists (select 1 from pg_namespace where nspname = 'storage') then
    insert into storage.buckets (id, name, public) values ('member-photos', 'member-photos', false)
    on conflict (id) do nothing;
    execute $p$create policy member_photos_read on storage.objects for select to authenticated
      using (bucket_id = 'member-photos' and (public.is_staff()
             or (storage.foldername(name))[1] = public.auth_member_id()::text))$p$;
    execute $p$create policy member_photos_write on storage.objects for insert to authenticated
      with check (bucket_id = 'member-photos' and public.is_desk())$p$;
    execute $p$create policy member_photos_update on storage.objects for update to authenticated
      using (bucket_id = 'member-photos' and public.is_desk())$p$;
    execute $p$create policy member_photos_delete on storage.objects for delete to authenticated
      using (bucket_id = 'member-photos' and public.is_owner())$p$;
  end if;
end $$;

-- Callable RPCs (Supabase grants these by default; explicit for clarity).
grant execute on function
  public.start_membership(uuid, uuid, date, int, text, uuid[]),
  public.renew_membership(uuid, uuid, int, text),
  public.freeze_membership(uuid, date, int, text),
  public.unfreeze_membership(uuid),
  public.cancel_membership(uuid, text, int),
  public.transfer_membership(uuid, uuid),
  public.add_member(jsonb, jsonb, jsonb),
  public.add_member_note(uuid, text),
  public.check_in(uuid),
  public.todays_gym_code(),
  public.self_check_in(text),
  public.staff_dashboard(),
  public.needs_action(int),
  public.import_members(jsonb),
  public.ist_today(),
  public.plan_end_date(date, int, text)
to authenticated;
