-- ABS Fitness — M2.1: Google sign-in only
-- Everyone (owner, front desk, trainers, members) signs in with Google. A
-- Google account gets into the gym when its verified email matches a staff
-- record (added by the owner) or a member record (entered by the desk). The
-- first sign-in links the login to that record; nothing else can create a
-- profile. Phone + PIN and email/password logins are removed.

-- ---------------------------------------------------------------------------
-- The caller's verified Google email (null for any other kind of login)
-- ---------------------------------------------------------------------------
create or replace function public._auth_google_email()
returns text
language sql
stable
security definer
set search_path = public, auth
as $$
  select lower(trim(u.email))
  from auth.users u
  where u.id = auth.uid()
    and u.email is not null
    and u.email_confirmed_at is not null
    and coalesce(u.raw_app_meta_data -> 'providers', jsonb_build_array(u.raw_app_meta_data ->> 'provider')) ? 'google'
$$;
revoke execute on function public._auth_google_email() from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- First sign-in: link this Google login to its staff or member record.
-- Returns the role. Errors: P0002 no gym account for this email, AB001 staff
-- access switched off, AB002 the email is on more than one member.
-- ---------------------------------------------------------------------------
create or replace function public.link_my_account()
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid    uuid := auth.uid();
  v_email  text;
  v_role   text;
  v_staff  public.staff%rowtype;
  v_member public.members%rowtype;
  v_count  int;
begin
  if v_uid is null then raise exception 'not signed in' using errcode = '42501'; end if;

  select role into v_role from public.profiles where id = v_uid and archived_at is null;
  if found then return v_role; end if;
  if exists (select 1 from public.profiles where id = v_uid) then
    raise exception 'no gym account for this Google account' using errcode = 'P0002';
  end if;

  v_email := public._auth_google_email();
  if v_email is null then
    raise exception 'sign in with a verified Google account' using errcode = '42501';
  end if;

  -- Staff first: a staff member who is also a member signs in as staff.
  select * into v_staff from public.staff where lower(email) = v_email and archived_at is null;
  if found then
    if not v_staff.is_active then
      raise exception 'staff access is switched off' using errcode = 'AB001';
    end if;
    -- A login from before (e.g. the old email/password account) is replaced.
    delete from public.profiles where staff_id = v_staff.id and id <> v_uid;
    insert into public.profiles (id, role, staff_id, name, phone)
    values (v_uid, v_staff.role, v_staff.id, v_staff.name, v_staff.phone);
    return v_staff.role;
  end if;

  select count(*) into v_count from public.members where lower(email) = v_email and archived_at is null;
  if v_count > 1 then
    raise exception 'this Gmail is on more than one member; ask the front desk' using errcode = 'AB002';
  end if;
  if v_count = 0 then
    raise exception 'no gym account for this Google account' using errcode = 'P0002';
  end if;
  select * into v_member from public.members where lower(email) = v_email and archived_at is null;
  delete from public.profiles where member_id = v_member.id and id <> v_uid;
  insert into public.profiles (id, role, member_id, name, phone)
  values (v_uid, 'member', v_member.id, v_member.name, v_member.phone);
  return 'member';
end;
$$;
revoke execute on function public.link_my_account() from public, anon;
grant execute on function public.link_my_account() to authenticated;

-- ---------------------------------------------------------------------------
-- Owner adds staff by their Gmail; they sign in with Google, no password.
-- ---------------------------------------------------------------------------
create or replace function public.add_staff(p_name text, p_email text, p_phone text, p_role text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  if p_role not in ('front_desk', 'trainer') then raise exception 'role must be front desk or trainer' using errcode = '22023'; end if;
  if coalesce(trim(p_name), '') = '' then raise exception 'a name is required' using errcode = '22023'; end if;
  if lower(trim(coalesce(p_email, ''))) !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$' then
    raise exception 'enter a valid email' using errcode = '22023';
  end if;
  insert into public.staff (name, email, phone, role)
  values (trim(p_name), lower(trim(p_email)), nullif(trim(coalesce(p_phone, '')), ''), p_role)
  returning id into v_id;
  return v_id;
exception when unique_violation then
  raise exception 'a staff member with this email already exists' using errcode = '23505';
end;
$$;
revoke execute on function public.add_staff(text, text, text, text) from public, anon;
grant execute on function public.add_staff(text, text, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Owner setup works in either order: run this first and then sign in with
-- Google, or sign in first and then run it.
-- Run from the SQL editor: select public.bootstrap_owner('owner@gmail.com', 'Owner Name');
-- ---------------------------------------------------------------------------
create or replace function public.bootstrap_owner(p_email text, p_name text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id  uuid;
  v_staff_id uuid;
  v_email    text := lower(trim(p_email));
begin
  if exists (select 1 from public.staff where role = 'owner') then
    raise exception 'an owner already exists';
  end if;
  insert into public.staff (name, email, role) values (trim(p_name), v_email, 'owner')
  returning id into v_staff_id;
  select id into v_user_id from auth.users where lower(email) = v_email;
  if v_user_id is not null then
    insert into public.profiles (id, role, staff_id, name)
    values (v_user_id, 'owner', v_staff_id, trim(p_name))
    on conflict (id) do nothing;
  end if;
  return v_staff_id;
end;
$$;
revoke execute on function public.bootstrap_owner(text, text) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Optional Supabase Auth hook ("Before User Created"): refuse logins that are
-- not Google, or whose email the gym doesn't know, so no stray accounts are
-- created. Enable it under Authentication → Hooks (see README).
-- ---------------------------------------------------------------------------
create or replace function public.hook_before_user_created(event jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_email    text := lower(trim(coalesce(event #>> '{user,email}', '')));
  v_provider text := coalesce(event #>> '{user,app_metadata,provider}', '');
begin
  if v_provider <> 'google' then
    return jsonb_build_object('error', jsonb_build_object('http_code', 403, 'message', 'Sign in with Google.'));
  end if;
  if exists (select 1 from public.staff where lower(email) = v_email and archived_at is null)
     or exists (select 1 from public.members where lower(email) = v_email and archived_at is null) then
    return '{}'::jsonb;
  end if;
  return jsonb_build_object('error', jsonb_build_object(
    'http_code', 403,
    'message', 'This Google account is not registered at the gym. Ask the front desk to add your Gmail.'));
end;
$$;
revoke execute on function public.hook_before_user_created(jsonb) from public, anon, authenticated;
do $$
begin
  if exists (select 1 from pg_roles where rolname = 'supabase_auth_admin') then
    execute 'grant execute on function public.hook_before_user_created(jsonb) to supabase_auth_admin';
    execute 'grant usage on schema public to supabase_auth_admin';
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Remove the PIN and password login pieces
-- ---------------------------------------------------------------------------
drop function if exists public.verify_member_pin(text, text);
drop function if exists public.set_member_pin(uuid, text);
drop function if exists public.mark_password_set();
drop table if exists public.member_login_attempts;
drop table if exists public.member_credentials;
alter table public.profiles drop column if exists must_set_password;

-- Members sign in with the Gmail on their record: index it for the lookup.
create index if not exists members_email_lower on public.members (lower(email)) where email is not null;
