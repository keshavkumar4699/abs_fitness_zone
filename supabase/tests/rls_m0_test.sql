-- RLS and RPC tests for migration M0. Run after supabase_stub.sql and the
-- migrations, as a superuser:  psql -v ON_ERROR_STOP=1 -f rls_m0_test.sql
-- Every check raises an exception on failure.

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

-- ---------- fixtures (as superuser) ----------
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'owner@abs.test'),
  ('00000000-0000-0000-0000-00000000000b', 'desk@abs.test'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer1@abs.test'),
  ('00000000-0000-0000-0000-00000000000d', 'trainer2@abs.test'),
  ('00000000-0000-0000-0000-00000000000e', 'member1@abs.test'),
  ('00000000-0000-0000-0000-00000000000f', 'member2@abs.test');

select public.bootstrap_owner('owner@abs.test', 'Gym Owner');

insert into public.staff (id, name, email, role) values
  ('10000000-0000-0000-0000-00000000000b', 'Desk', 'desk@abs.test', 'front_desk'),
  ('10000000-0000-0000-0000-00000000000c', 'Trainer One', 'trainer1@abs.test', 'trainer'),
  ('10000000-0000-0000-0000-00000000000d', 'Trainer Two', 'trainer2@abs.test', 'trainer');
insert into public.profiles (id, role, staff_id, name) values
  ('00000000-0000-0000-0000-00000000000b', 'front_desk', '10000000-0000-0000-0000-00000000000b', 'Desk'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer', '10000000-0000-0000-0000-00000000000c', 'Trainer One'),
  ('00000000-0000-0000-0000-00000000000d', 'trainer', '10000000-0000-0000-0000-00000000000d', 'Trainer Two');

insert into public.members (id, name, phone, trainer_id) values
  ('20000000-0000-0000-0000-000000000001', 'Member One', '+919876500001', '10000000-0000-0000-0000-00000000000c'),
  ('20000000-0000-0000-0000-000000000002', 'Member Two', '+919876500002', '10000000-0000-0000-0000-00000000000d');
insert into public.profiles (id, role, member_id, name) values
  ('00000000-0000-0000-0000-00000000000e', 'member', '20000000-0000-0000-0000-000000000001', 'Member One'),
  ('00000000-0000-0000-0000-00000000000f', 'member', '20000000-0000-0000-0000-000000000002', 'Member Two');

select pg_temp.check((select member_code from public.members where phone = '+919876500001') = 'ABS-0001', 'member codes are auto-assigned (ABS-0001)');
select pg_temp.check((select member_code from public.members where phone = '+919876500002') = 'ABS-0002', 'member codes are sequential');

-- ---------- owner ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check(public.is_owner(), 'owner: is_owner()');
select pg_temp.check((select count(*) from public.members) = 2, 'owner: sees all members');
select pg_temp.check((select count(*) from public.settings) > 0, 'owner: reads settings');
select pg_temp.check((select count(*) from public.profiles) = 6, 'owner: sees all profiles');
reset role;

-- ---------- front desk ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check(not public.is_owner() and public.is_desk(), 'desk: is_desk() but not owner');
select pg_temp.check((select count(*) from public.members) = 2, 'desk: sees all members');
select pg_temp.check((select count(*) from public.settings) = 0, 'desk: cannot read settings');
select pg_temp.check((select count(*) from public.audit_log) = 0, 'desk: cannot read audit log');
select pg_temp.check((select count(*) from public.member_credentials) = 0, 'desk: cannot read PIN hashes');
insert into public.members (name, phone) values ('Walk In', '+919876500003');
select pg_temp.check((select count(*) from public.members) = 3, 'desk: can add a member');
delete from public.members where phone = '+919876500003';
select pg_temp.check((select count(*) from public.members) = 3, 'desk: cannot delete members');
update public.profiles set role = 'owner' where id = '00000000-0000-0000-0000-00000000000b';
reset role;
select pg_temp.check((select role from public.profiles where id = '00000000-0000-0000-0000-00000000000b') = 'front_desk', 'desk: cannot escalate own role');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.set_member_pin('20000000-0000-0000-0000-000000000001', '4321');
reset role;
select pg_temp.check((select count(*) from public.member_credentials) = 1, 'desk: set_member_pin stores a hash');
select pg_temp.check((select pin_hash <> '4321' from public.member_credentials), 'PIN is stored hashed, not plain');

-- ---------- trainer ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check((select count(*) from public.members) = 1, 'trainer: sees only assigned members');
select pg_temp.check((select name from public.members) = 'Member One', 'trainer: sees the right member');
update public.members set notes = 'edited' where id = '20000000-0000-0000-0000-000000000001';
select pg_temp.check((select count(*) from public.staff) = 4, 'trainer: reads staff roster');
do $$ begin
  perform public.set_member_pin('20000000-0000-0000-0000-000000000001', '1111');
  raise exception 'FAILED: trainer could set a PIN';
exception when insufficient_privilege then raise notice 'ok - trainer: cannot set PINs';
end $$;
reset role;
select pg_temp.check((select notes from public.members where id = '20000000-0000-0000-0000-000000000001') is null, 'trainer: cannot edit members');

-- ---------- member ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) from public.members) = 1, 'member: sees only own record');
select pg_temp.check((select id from public.members) = '20000000-0000-0000-0000-000000000001', 'member: own record only');
select pg_temp.check((select count(*) from public.profiles) = 1, 'member: sees only own profile');
select pg_temp.check((select count(*) from public.staff) = 0, 'member: cannot read staff');
select pg_temp.check((select count(*) from public.settings) = 0, 'member: cannot read settings');
select pg_temp.check((public.public_gym_profile() ->> 'gym_name') = 'ABS Fitness Zone', 'member: reads public gym profile');
do $$ begin
  perform public.verify_member_pin('+919876500001', '4321');
  raise exception 'FAILED: member could call verify_member_pin';
exception when insufficient_privilege then raise notice 'ok - member: cannot call verify_member_pin';
end $$;
reset role;

-- ---------- anonymous ----------
set role anon;
select pg_temp.as_user(null);
select pg_temp.check((select count(*) from public.members) = 0, 'anon: sees no members');
select pg_temp.check((select count(*) from public.profiles) = 0, 'anon: sees no profiles');
select pg_temp.check((public.public_gym_profile() ? 'gym_name'), 'anon: reads public gym profile');
select pg_temp.check(not (public.public_gym_profile() ? 'gstin'), 'public gym profile hides private settings');
reset role;

-- ---------- PIN verification + lockout (service role) ----------
set role service_role;
select pg_temp.check((public.verify_member_pin('+919876500001', '4321') ->> 'ok')::boolean, 'correct PIN verifies');
select pg_temp.check((public.verify_member_pin('+919876500001', '0000') ->> 'attempts_left')::int = 4, 'wrong PIN #1 → 4 left');
select public.verify_member_pin('+919876500001', '0000');
select public.verify_member_pin('+919876500001', '0000');
select pg_temp.check((public.verify_member_pin('+919876500001', '0000') ->> 'attempts_left')::int = 1, 'wrong PIN #4 → 1 left');
select pg_temp.check((public.verify_member_pin('+919876500001', '0000') ->> 'reason') = 'locked', 'wrong PIN #5 → locked');
select pg_temp.check((public.verify_member_pin('+919876500001', '4321') ->> 'reason') = 'locked', 'correct PIN while locked is refused');
select pg_temp.check((public.verify_member_pin('+919999999999', '4321') ->> 'reason') = 'invalid', 'unknown phone is just "invalid"');
reset role;
update public.member_login_attempts set locked_until = now() - interval '1 minute' where phone = '+919876500001';
set role service_role;
select pg_temp.check((public.verify_member_pin('+919876500001', '4321') ->> 'ok')::boolean, 'login works again after the lock expires');
reset role;

select 'ALL M0 RLS TESTS PASSED' as result;
