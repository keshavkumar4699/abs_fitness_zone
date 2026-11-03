-- M2.1 tests: Google sign-in only. Linking a verified Google login to its
-- staff or member record, owner setup in either order, adding staff, the
-- optional sign-up hook, and that the PIN / password pieces are gone.

create or replace function pg_temp.check(ok boolean, what text) returns void
language plpgsql as $$
begin
  if not coalesce(ok, false) then raise exception 'FAILED: %', what; end if;
  raise notice 'ok - %', what;
end $$;

create or replace function pg_temp.as_user(p_id uuid) returns void
language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', coalesce(p_id::text, ''), false);
end $$;

-- Runs p_sql and expects it to fail with SQLSTATE p_state.
create or replace function pg_temp.fails_with(p_sql text, p_state text, p_what text) returns void
language plpgsql as $$
begin
  execute p_sql;
  raise exception 'FAILED: % (no error raised)', p_what;
exception when others then
  if sqlerrm like 'FAILED:%' then raise; end if;
  if sqlstate <> p_state then raise exception 'FAILED: % (got % %)', p_what, sqlstate, sqlerrm; end if;
  raise notice 'ok - %', p_what;
end $$;

create or replace function pg_temp.google_user(p_id uuid, p_email text) returns void
language sql as $$
  insert into auth.users (id, email, email_confirmed_at, raw_app_meta_data)
  values (p_id, p_email, now(), '{"provider": "google", "providers": ["google"]}')
$$;

-- ---------- the old login pieces are gone ----------
select pg_temp.check(to_regclass('public.member_credentials') is null, 'PIN table removed');
select pg_temp.check(to_regclass('public.member_login_attempts') is null, 'PIN lockout table removed');
select pg_temp.check(to_regprocedure('public.verify_member_pin(text, text)') is null, 'PIN check removed');
select pg_temp.check(to_regprocedure('public.set_member_pin(uuid, text)') is null, 'set PIN removed');
select pg_temp.check(not exists (select 1 from information_schema.columns
                                 where table_name = 'profiles' and column_name = 'must_set_password'),
                     'forced-password flag removed');

-- ---------- owner setup before the first sign-in ----------
select public.bootstrap_owner('Owner@Gmail.test', 'Gym Owner');
select pg_temp.check((select count(*) from public.staff where role = 'owner' and email = 'owner@gmail.test') = 1,
                     'bootstrap works before the owner has signed in');
select pg_temp.check((select count(*) from public.profiles) = 0, 'no profile until the owner signs in');
select pg_temp.google_user('00000000-0000-0000-0000-00000000000a', 'owner@gmail.test');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check(public.link_my_account() = 'owner', 'owner: first Google sign-in links as owner');
select pg_temp.check(public.link_my_account() = 'owner', 'linking again is harmless');
select pg_temp.check(public.is_owner(), 'owner: role helpers work after linking');

-- ---------- owner adds staff by Gmail ----------
select public.add_staff('Neha Desk', 'Neha.Desk@gmail.test', '+919812300001', 'front_desk');
select public.add_staff('Vikram Rao', 'vikram@gmail.test', null, 'trainer');
select public.add_staff('Pooja Mehta', 'pooja@gmail.test', null, 'trainer');
select pg_temp.check((select email from public.staff where name = 'Neha Desk') = 'neha.desk@gmail.test', 'staff email is stored in lower case');
select pg_temp.fails_with($$select public.add_staff('Again', 'neha.desk@gmail.test', null, 'trainer')$$, '23505',
                          'the same email cannot be added twice');
select pg_temp.fails_with($$select public.add_staff('Boss', 'boss@gmail.test', null, 'owner')$$, '22023',
                          'a second owner cannot be added');
select pg_temp.fails_with($$select public.add_staff('X', 'not-an-email', null, 'trainer')$$, '22023',
                          'a valid email is required');
update public.staff set is_active = false where email = 'pooja@gmail.test';
insert into public.members (id, name, phone, email) values
  ('20000000-0000-0000-0000-000000000001', 'Aarav Sharma', '+919876500001', 'Aarav.S@gmail.test'),
  ('20000000-0000-0000-0000-000000000002', 'Riya Gupta', '+919876500002', 'family@gmail.test'),
  ('20000000-0000-0000-0000-000000000003', 'Kabir Gupta', '+919876500003', 'family@gmail.test'),
  ('20000000-0000-0000-0000-000000000004', 'Zoya Khan', '+919876500004', 'zoya@gmail.test');
update public.members set archived_at = now() where name = 'Zoya Khan';
reset role;

-- ---------- desk cannot add staff ----------
select pg_temp.google_user('00000000-0000-0000-0000-00000000000b', 'neha.desk@gmail.test');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check(public.link_my_account() = 'front_desk', 'desk: Google sign-in links to the staff record');
select pg_temp.check((select phone from public.profiles) = '+919812300001', 'desk: profile copies name and phone');
select pg_temp.fails_with($$select public.add_staff('Sneaky', 'sneaky@gmail.test', null, 'trainer')$$, '42501',
                          'desk: cannot add staff');
reset role;

-- ---------- members ----------
select pg_temp.google_user('00000000-0000-0000-0000-00000000000e', 'aarav.s@gmail.test');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check(public.link_my_account() = 'member', 'member: Gmail on the record links as member (case-insensitive)');
select pg_temp.check(public.auth_member_id() = '20000000-0000-0000-0000-000000000001', 'member: linked to the right record');
select pg_temp.check((select count(*) from public.members) = 1, 'member: sees only their own record');
reset role;

select pg_temp.google_user('00000000-0000-0000-0000-0000000000f1', 'family@gmail.test');
select pg_temp.google_user('00000000-0000-0000-0000-0000000000f2', 'zoya@gmail.test');
select pg_temp.google_user('00000000-0000-0000-0000-0000000000f3', 'stranger@gmail.test');
select pg_temp.google_user('00000000-0000-0000-0000-0000000000f4', 'pooja@gmail.test');
insert into auth.users (id, email, email_confirmed_at, raw_app_meta_data) values
  ('00000000-0000-0000-0000-0000000000f5', 'vikram@gmail.test', now(), '{"provider": "email", "providers": ["email"]}');
insert into auth.users (id, email, email_confirmed_at, raw_app_meta_data) values
  ('00000000-0000-0000-0000-0000000000f6', 'vikram2@gmail.test', null, '{"provider": "google", "providers": ["google"]}');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select pg_temp.fails_with('select public.link_my_account()', 'AB002', 'a Gmail shared by two members is refused');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f2');
select pg_temp.fails_with('select public.link_my_account()', 'P0002', 'archived members cannot sign in');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f3');
select pg_temp.fails_with('select public.link_my_account()', 'P0002', 'an unknown Google account gets nothing');
select pg_temp.check(public.auth_role() is null, 'unknown account: no role');
select pg_temp.check((select count(*) from public.members) = 0, 'unknown account: sees no members');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f4');
select pg_temp.fails_with('select public.link_my_account()', 'AB001', 'switched-off staff cannot link');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f5');
select pg_temp.fails_with('select public.link_my_account()', '42501', 'an email/password login is not accepted');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f6');
select pg_temp.fails_with('select public.link_my_account()', '42501', 'an unverified email is not accepted');
reset role;
select pg_temp.check((select count(*) from public.profiles) = 3, 'only the three valid logins got profiles');

-- ---------- a new Google login replaces an older one for the same person ----------
-- Vikram had an old email/password login linked to his staff record.
update auth.users set email = 'vikram-old@gmail.test' where id = '00000000-0000-0000-0000-0000000000f5';
insert into public.profiles (id, role, staff_id, name)
values ('00000000-0000-0000-0000-0000000000f5', 'trainer', (select id from public.staff where name = 'Vikram Rao'), 'Vikram Rao');
select pg_temp.google_user('00000000-0000-0000-0000-0000000000c1', 'vikram@gmail.test');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select pg_temp.check(public.link_my_account() = 'trainer', 'trainer: Google sign-in links even with an old login');
reset role;
select pg_temp.check((select id from public.profiles where staff_id = (select id from public.staff where name = 'Vikram Rao'))
                     = '00000000-0000-0000-0000-0000000000c1', 'the old login is replaced, one profile per person');

-- ---------- owner setup after the first sign-in ----------
delete from public.profiles;
delete from public.staff;
select pg_temp.google_user('00000000-0000-0000-0000-0000000000a2', 'second-owner@gmail.test');
select public.bootstrap_owner('second-owner@gmail.test', 'New Owner');
select pg_temp.check((select role from public.profiles where id = '00000000-0000-0000-0000-0000000000a2') = 'owner',
                     'bootstrap after sign-in links the owner straight away');
do $$ begin
  perform public.bootstrap_owner('third@gmail.test', 'Third');
  raise exception 'FAILED: a second owner was bootstrapped';
exception when others then
  if sqlerrm like 'FAILED:%' then raise; end if;
  raise notice 'ok - bootstrap refuses once an owner exists';
end $$;

-- ---------- anonymous ----------
set role anon;
select pg_temp.as_user(null);
select pg_temp.fails_with('select public.link_my_account()', '42501', 'anon: cannot link');
reset role;

-- ---------- optional sign-up hook ----------
insert into public.members (name, phone, email) values ('Hook Member', '+919876500009', 'hook@gmail.test');
select pg_temp.check(public.hook_before_user_created(
  '{"user": {"email": "Hook@gmail.test", "app_metadata": {"provider": "google"}}}') = '{}'::jsonb,
  'hook: a registered Gmail may sign up');
select pg_temp.check(public.hook_before_user_created(
  '{"user": {"email": "nobody@gmail.test", "app_metadata": {"provider": "google"}}}') ? 'error',
  'hook: an unknown Gmail is refused');
select pg_temp.check(public.hook_before_user_created(
  '{"user": {"email": "hook@gmail.test", "app_metadata": {"provider": "email"}}}') ? 'error',
  'hook: non-Google sign-ups are refused');

select 'ALL M2.1 TESTS PASSED' as result;
