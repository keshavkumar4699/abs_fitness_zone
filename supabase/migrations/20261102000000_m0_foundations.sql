-- ABS Fitness — Milestone M0: foundations
-- Roles, profiles, staff, members (core record), member PIN credentials,
-- settings, audit log, helper functions and Row Level Security.
-- All timestamps are timestamptz (UTC). All money columns are integer paise.

create extension if not exists pgcrypto with schema extensions;
create extension if not exists pg_trgm with schema extensions;

-- ---------------------------------------------------------------------------
-- Shared trigger: keep updated_at current
-- ---------------------------------------------------------------------------
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Staff
-- ---------------------------------------------------------------------------
create table public.staff (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (length(trim(name)) between 1 and 120),
  phone       text check (phone is null or phone ~ '^\+91[6-9][0-9]{9}$'),
  email       text not null unique check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  role        text not null check (role in ('owner', 'front_desk', 'trainer')),
  is_active   boolean not null default true,
  photo_url   text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  archived_at timestamptz
);
create trigger staff_touch before update on public.staff
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Members (core record; membership/status engine arrives in M1)
-- ---------------------------------------------------------------------------
create sequence public.member_code_seq start 1;

create table public.members (
  id                  uuid primary key default gen_random_uuid(),
  member_code         text not null unique,
  name                text not null check (length(trim(name)) between 1 and 120),
  phone               text not null unique check (phone ~ '^\+91[6-9][0-9]{9}$'),
  alt_phone           text check (alt_phone is null or alt_phone ~ '^\+91[6-9][0-9]{9}$'),
  email               text check (email is null or email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  gender              text check (gender in ('male', 'female', 'other')),
  dob                 date,
  address             text,
  emergency_name      text,
  emergency_relation  text,
  emergency_phone     text check (emergency_phone is null or emergency_phone ~ '^\+91[6-9][0-9]{9}$'),
  blood_group         text check (blood_group in ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
  photo_url           text,
  goal                text check (goal in ('fat_loss','muscle_gain','strength','general_fitness','rehab')),
  level               text check (level in ('beginner','intermediate','advanced')),
  diet_pref           text check (diet_pref in ('veg','eggetarian','non_veg','vegan','jain')),
  medical_notes       text,
  consent_health_at   timestamptz,
  consent_whatsapp_at timestamptz,
  whatsapp_opt_out    boolean not null default false,
  language            text not null default 'en' check (language in ('en', 'hi')),
  trainer_id          uuid references public.staff (id) on delete set null,
  batch               text check (batch in ('morning', 'evening')),
  source              text,
  status              text not null default 'inactive'
                        check (status in ('active','expiring','expired','frozen','cancelled','inactive','pending')),
  joined_on           date not null default (now() at time zone 'Asia/Kolkata')::date,
  notes               text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  archived_at         timestamptz
);

create or replace function public.assign_member_code()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.member_code is null or new.member_code = '' then
    new.member_code := 'ABS-' || lpad(nextval('public.member_code_seq')::text, 4, '0');
  end if;
  return new;
end;
$$;

create trigger members_code before insert on public.members
  for each row execute function public.assign_member_code();
create trigger members_touch before update on public.members
  for each row execute function public.touch_updated_at();

create index members_name_trgm on public.members using gin (name extensions.gin_trgm_ops);
create index members_phone_prefix on public.members (phone text_pattern_ops);
create index members_trainer on public.members (trainer_id);
create index members_status on public.members (status) where archived_at is null;

-- PIN hashes live in their own table with no client policies at all, so a
-- member's hash can never be selected through the API (see DECISIONS.md).
create table public.member_credentials (
  member_id  uuid primary key references public.members (id) on delete cascade,
  pin_hash   text not null,
  pin_set_at timestamptz not null default now(),
  pin_set_by uuid references auth.users (id) on delete set null
);

create table public.member_login_attempts (
  phone          text primary key,
  failed_count   int not null default 0,
  locked_until   timestamptz,
  last_failed_at timestamptz
);

-- ---------------------------------------------------------------------------
-- Profiles: one row per auth user, carrying the role
-- ---------------------------------------------------------------------------
create table public.profiles (
  id                uuid primary key references auth.users (id) on delete cascade,
  role              text not null check (role in ('owner', 'front_desk', 'trainer', 'member')),
  member_id         uuid unique references public.members (id) on delete cascade,
  staff_id          uuid unique references public.staff (id) on delete cascade,
  name              text not null,
  phone             text,
  must_set_password boolean not null default false,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  archived_at       timestamptz,
  constraint profile_link check (
    (role = 'member' and member_id is not null and staff_id is null) or
    (role <> 'member' and staff_id is not null and member_id is null)
  )
);
create trigger profiles_touch before update on public.profiles
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Settings (owner only) and audit log
-- ---------------------------------------------------------------------------
create table public.settings (
  key        text primary key,
  value      jsonb not null,
  updated_at timestamptz not null default now()
);
create trigger settings_touch before update on public.settings
  for each row execute function public.touch_updated_at();

insert into public.settings (key, value) values
  ('gym_name', '"ABS Fitness Zone"'),
  ('gym_phone', 'null'),
  ('gym_address', 'null'),
  ('upi_id', 'null'),
  ('gstin', 'null'),
  ('working_hours', '{"open": "05:00", "close": "22:00"}'),
  ('expiring_window_days', '7');

create table public.audit_log (
  id         bigint generated always as identity primary key,
  actor_id   uuid,
  table_name text not null,
  row_id     uuid,
  action     text not null check (action in ('INSERT', 'UPDATE', 'DELETE')),
  old        jsonb,
  new        jsonb,
  at         timestamptz not null default now()
);
create index audit_log_row on public.audit_log (table_name, row_id);

-- Generic audit trigger; attached to money tables from M2 onwards.
create or replace function public.audit_row_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.audit_log (actor_id, table_name, row_id, action, old, new)
  values (
    auth.uid(),
    tg_table_name,
    coalesce((case when tg_op = 'DELETE' then old.id else new.id end), null),
    tg_op,
    case when tg_op in ('UPDATE', 'DELETE') then to_jsonb(old) end,
    case when tg_op in ('INSERT', 'UPDATE') then to_jsonb(new) end
  );
  return coalesce(new, old);
end;
$$;

-- ---------------------------------------------------------------------------
-- Helper functions used by every RLS policy
-- ---------------------------------------------------------------------------
create or replace function public.auth_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid() and archived_at is null
$$;

create or replace function public.auth_member_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select member_id from public.profiles where id = auth.uid() and archived_at is null
$$;

create or replace function public.auth_staff_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select p.staff_id
  from public.profiles p
  join public.staff s on s.id = p.staff_id
  where p.id = auth.uid() and p.archived_at is null and s.is_active
$$;

create or replace function public.is_owner()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.auth_role() = 'owner' and public.auth_staff_id() is not null, false)
$$;

create or replace function public.is_desk()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.auth_role() in ('owner', 'front_desk') and public.auth_staff_id() is not null, false)
$$;

create or replace function public.is_staff()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.auth_role() in ('owner', 'front_desk', 'trainer') and public.auth_staff_id() is not null, false)
$$;

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
alter table public.staff                 enable row level security;
alter table public.members               enable row level security;
alter table public.member_credentials    enable row level security;
alter table public.member_login_attempts enable row level security;
alter table public.profiles              enable row level security;
alter table public.settings              enable row level security;
alter table public.audit_log             enable row level security;

-- staff: every active staff member can read the roster (needed to pick a
-- trainer); only the owner writes it.
create policy staff_select on public.staff for select to authenticated
  using (public.is_staff());
create policy staff_owner_write on public.staff for all to authenticated
  using (public.is_owner()) with check (public.is_owner());

-- members
create policy members_owner_all on public.members for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy members_desk_select on public.members for select to authenticated
  using (public.auth_role() = 'front_desk' and public.is_desk());
create policy members_desk_insert on public.members for insert to authenticated
  with check (public.auth_role() = 'front_desk' and public.is_desk());
create policy members_desk_update on public.members for update to authenticated
  using (public.auth_role() = 'front_desk' and public.is_desk())
  with check (public.auth_role() = 'front_desk' and public.is_desk());
create policy members_trainer_select on public.members for select to authenticated
  using (public.auth_role() = 'trainer' and trainer_id = public.auth_staff_id());
create policy members_self_select on public.members for select to authenticated
  using (public.auth_role() = 'member' and id = public.auth_member_id());

-- member_credentials, member_login_attempts: no policies → no client access.

-- profiles: everyone reads their own; owner reads and manages all.
create policy profiles_self_select on public.profiles for select to authenticated
  using (id = auth.uid());
create policy profiles_owner_all on public.profiles for all to authenticated
  using (public.is_owner()) with check (public.is_owner());

-- settings and audit log: owner only
create policy settings_owner_all on public.settings for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy audit_owner_select on public.audit_log for select to authenticated
  using (public.is_owner());

-- ---------------------------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------------------------

-- Safe subset of settings for every client (member app, website).
create or replace function public.public_gym_profile()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_object_agg(key, value), '{}'::jsonb)
  from public.settings
  where key in ('gym_name', 'gym_phone', 'gym_address', 'upi_id', 'working_hours')
$$;
grant execute on function public.public_gym_profile() to anon, authenticated;

-- Clears the forced-password flag after a staff member sets their password.
create or replace function public.mark_password_set()
returns void
language sql
security definer
set search_path = public
as $$
  update public.profiles set must_set_password = false where id = auth.uid()
$$;
revoke execute on function public.mark_password_set() from public, anon;
grant execute on function public.mark_password_set() to authenticated;

-- Front desk or owner sets a member's 4-digit PIN (stored as a bcrypt hash).
create or replace function public.set_member_pin(p_member_id uuid, p_pin text)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_phone text;
begin
  if not public.is_desk() then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  if p_pin !~ '^[0-9]{4}$' then
    raise exception 'PIN must be exactly 4 digits' using errcode = '22023';
  end if;
  select phone into v_phone from public.members where id = p_member_id and archived_at is null;
  if v_phone is null then
    raise exception 'member not found' using errcode = 'P0002';
  end if;

  insert into public.member_credentials (member_id, pin_hash, pin_set_at, pin_set_by)
  values (p_member_id, extensions.crypt(p_pin, extensions.gen_salt('bf', 8)), now(), auth.uid())
  on conflict (member_id) do update
    set pin_hash = excluded.pin_hash, pin_set_at = now(), pin_set_by = auth.uid();

  delete from public.member_login_attempts where phone = v_phone;
end;
$$;
revoke execute on function public.set_member_pin(uuid, text) from public, anon;
grant execute on function public.set_member_pin(uuid, text) to authenticated;

-- Verifies a member PIN with lockout (5 wrong attempts → 15 minutes).
-- Only the member-login Edge Function (service role) may call this.
create or replace function public.verify_member_pin(p_phone text, p_pin text)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_attempt   public.member_login_attempts%rowtype;
  v_member_id uuid;
  v_hash      text;
  v_failed    int;
begin
  select * into v_attempt from public.member_login_attempts where phone = p_phone for update;
  if found and v_attempt.locked_until is not null and v_attempt.locked_until > now() then
    return jsonb_build_object('ok', false, 'reason', 'locked', 'locked_until', v_attempt.locked_until);
  end if;

  select m.id, c.pin_hash into v_member_id, v_hash
  from public.members m
  join public.member_credentials c on c.member_id = m.id
  where m.phone = p_phone and m.archived_at is null;

  if v_hash is not null and extensions.crypt(p_pin, v_hash) = v_hash then
    delete from public.member_login_attempts where phone = p_phone;
    return jsonb_build_object('ok', true, 'member_id', v_member_id);
  end if;

  v_failed := coalesce(v_attempt.failed_count, 0) + 1;
  if v_failed >= 5 then
    insert into public.member_login_attempts (phone, failed_count, locked_until, last_failed_at)
    values (p_phone, 0, now() + interval '15 minutes', now())
    on conflict (phone) do update
      set failed_count = 0, locked_until = now() + interval '15 minutes', last_failed_at = now();
    return jsonb_build_object('ok', false, 'reason', 'locked',
                              'locked_until', now() + interval '15 minutes');
  end if;

  insert into public.member_login_attempts (phone, failed_count, locked_until, last_failed_at)
  values (p_phone, v_failed, null, now())
  on conflict (phone) do update
    set failed_count = v_failed, locked_until = null, last_failed_at = now();
  return jsonb_build_object('ok', false, 'reason', 'invalid', 'attempts_left', 5 - v_failed);
end;
$$;
revoke execute on function public.verify_member_pin(text, text) from public, anon, authenticated;
grant execute on function public.verify_member_pin(text, text) to service_role;

-- One-time bootstrap: make an existing auth user (created in the Supabase
-- dashboard) the gym owner. Refuses if an owner already exists.
-- Run from the SQL editor: select public.bootstrap_owner('owner@gmail.com', 'Owner Name');
create or replace function public.bootstrap_owner(p_email text, p_name text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id  uuid;
  v_staff_id uuid;
begin
  if exists (select 1 from public.profiles where role = 'owner') then
    raise exception 'an owner already exists';
  end if;
  select id into v_user_id from auth.users where lower(email) = lower(p_email);
  if v_user_id is null then
    raise exception 'no auth user with email %', p_email;
  end if;
  insert into public.staff (name, email, role) values (p_name, lower(p_email), 'owner')
  returning id into v_staff_id;
  insert into public.profiles (id, role, staff_id, name)
  values (v_user_id, 'owner', v_staff_id, p_name);
  return v_staff_id;
end;
$$;
revoke execute on function public.bootstrap_owner(text, text) from public, anon, authenticated;
