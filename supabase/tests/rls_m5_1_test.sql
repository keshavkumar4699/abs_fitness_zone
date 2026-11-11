-- After-M5 tests: optional check-out (desk, own trainer, the member; a
-- second call is a no-op; no visit today is refused).

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

create or replace function pg_temp.raises(p_sql text, p_what text) returns void
language plpgsql as $$
begin
  execute p_sql;
  raise exception 'FAILED: % (no error raised)', p_what;
exception when others then
  if sqlerrm like 'FAILED:%' then raise; end if;
  raise notice 'ok - %', p_what;
end $$;

-- ---------- fixtures ----------
-- owner a, desk b, trainer c (coaches Riya), trainer d (coaches Kabir), members e (Riya), f (Kabir)
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'owner@abs.test'),
  ('00000000-0000-0000-0000-00000000000b', 'desk@abs.test'),
  ('00000000-0000-0000-0000-00000000000c', 'vikram@abs.test'),
  ('00000000-0000-0000-0000-00000000000d', 'pooja@abs.test'),
  ('00000000-0000-0000-0000-00000000000e', 'riya@abs.test'),
  ('00000000-0000-0000-0000-00000000000f', 'kabir@abs.test');
select public.bootstrap_owner('owner@abs.test', 'Gym Owner');
insert into public.staff (id, name, email, role) values
  ('10000000-0000-0000-0000-00000000000b', 'Desk', 'desk@abs.test', 'front_desk'),
  ('10000000-0000-0000-0000-00000000000c', 'Vikram', 'vikram@abs.test', 'trainer'),
  ('10000000-0000-0000-0000-00000000000d', 'Pooja', 'pooja@abs.test', 'trainer');
insert into public.profiles (id, role, staff_id, name) values
  ('00000000-0000-0000-0000-00000000000b', 'front_desk', '10000000-0000-0000-0000-00000000000b', 'Desk'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer', '10000000-0000-0000-0000-00000000000c', 'Vikram'),
  ('00000000-0000-0000-0000-00000000000d', 'trainer', '10000000-0000-0000-0000-00000000000d', 'Pooja');
insert into public.plans (id, name, duration_value, duration_unit, price_paise, joining_fee_paise, gst_rate) values
  ('30000000-0000-0000-0000-000000000001', 'Monthly', 1, 'months', 150000, 0, 0);

set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.add_member(jsonb_build_object('name', 'Riya Sen', 'phone', '+919876500011',
  'trainer_id', '10000000-0000-0000-0000-00000000000c'),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001'));
select public.add_member(jsonb_build_object('name', 'Kabir Das', 'phone', '+919876500012',
  'trainer_id', '10000000-0000-0000-0000-00000000000d'),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001'));
select public.add_member(jsonb_build_object('name', 'Meena Iyer', 'phone', '+919876500013'),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001'));
reset role;
create temp table ids as
select (select id from public.members where phone = '+919876500011') riya,
       (select id from public.members where phone = '+919876500012') kabir,
       (select id from public.members where phone = '+919876500013') meena;
grant select on ids to authenticated, anon;
insert into public.profiles (id, role, member_id, name) values
  ('00000000-0000-0000-0000-00000000000e', 'member', (select riya from ids), 'Riya Sen'),
  ('00000000-0000-0000-0000-00000000000f', 'member', (select kabir from ids), 'Kabir Das');

-- ---------- check-out ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.check_in((select riya from ids)) ->> 'checked_out_at') is null, 'check-in: not checked out yet');
select public.check_in((select kabir from ids));
select pg_temp.raises($$select public.check_out((select meena from ids))$$, 'desk: no check-in today, nothing to end');

select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
create temp table out1 as select public.check_out() as r;
select pg_temp.check((select (r ->> 'checked_out_at') is not null and (r ->> 'minutes')::int >= 0 from out1), 'member: ends their own visit');
select pg_temp.raises($$select public.check_out((select kabir from ids))$$, 'member: cannot end someone else''s visit');

select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.check_out((select kabir from ids))$$, 'trainer: not another trainer''s member');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check((public.check_out((select kabir from ids)) ->> 'checked_out_at') is not null, 'trainer: ends their own member''s visit');

select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.check_out((select riya from ids)) ->> 'checked_out_at') = (select r ->> 'checked_out_at' from out1),
                     'desk: a second check-out changes nothing');
select pg_temp.check((public.check_in((select riya from ids)) ->> 'already')::boolean
                     and (public.check_in((select riya from ids)) ->> 'checked_out_at') is not null,
                     'check-in again: already in, and the visit shows as ended');
reset role;
select pg_temp.check((select count(*) from public.attendance where checked_out_at is not null) = 2, 'two visits ended');

set role anon;
select pg_temp.as_user(null);
select pg_temp.raises($$select public.check_out((select riya from ids))$$, 'anon: no check-out');
reset role;

select 'ALL M5.1 TESTS PASSED' as result;
