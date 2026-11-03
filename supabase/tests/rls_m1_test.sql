-- M1 tests: status engine, membership RPCs, check-in, dashboard, import, RLS.
-- Run after supabase_stub.sql and all migrations, as a superuser.

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

-- ---------- status engine (pure function) ----------
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-12-31', false, false, '2026-06-01', 7, 90) = 'active', 'status: active mid-plan');
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-06-07', false, false, '2026-06-01', 7, 90) = 'expiring', 'status: expiring within 7 days');
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-06-08', false, false, '2026-06-01', 7, 90) = 'active', 'status: 8 days left is still active');
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-05-31', false, false, '2026-06-01', 7, 90) = 'expired', 'status: expired the day after end');
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-03-01', false, false, '2026-06-01', 7, 90) = 'inactive', 'status: inactive after 90 days');
select pg_temp.check(public.membership_status_for('2026-07-01', '2026-12-31', false, false, '2026-06-01', 7, 90) = 'upcoming', 'status: upcoming before start');
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-12-31', false, true, '2026-06-01', 7, 90) = 'frozen', 'status: frozen');
select pg_temp.check(public.membership_status_for('2026-01-01', '2026-12-31', true, true, '2026-06-01', 7, 90) = 'cancelled', 'status: cancelled wins');
select pg_temp.check(public.plan_end_date('2026-01-31', 1, 'months') = '2026-02-27', 'plan end: 1 month from 31 Jan');
select pg_temp.check(public.plan_end_date('2026-03-01', 3, 'months') = '2026-05-31', 'plan end: 3 months');
select pg_temp.check(public.plan_end_date('2026-03-01', 30, 'days') = '2026-03-30', 'plan end: 30 days');

-- ---------- fixtures ----------
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'owner@abs.test'),
  ('00000000-0000-0000-0000-00000000000b', 'desk@abs.test'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer1@abs.test'),
  ('00000000-0000-0000-0000-00000000000e', 'member1@abs.test');
select public.bootstrap_owner('owner@abs.test', 'Gym Owner');
insert into public.staff (id, name, email, role) values
  ('10000000-0000-0000-0000-00000000000b', 'Desk', 'desk@abs.test', 'front_desk'),
  ('10000000-0000-0000-0000-00000000000c', 'Trainer One', 'trainer1@abs.test', 'trainer');
insert into public.profiles (id, role, staff_id, name) values
  ('00000000-0000-0000-0000-00000000000b', 'front_desk', '10000000-0000-0000-0000-00000000000b', 'Desk'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer', '10000000-0000-0000-0000-00000000000c', 'Trainer One');

insert into public.plans (id, name, duration_value, duration_unit, price_paise, joining_fee_paise, freeze_days_allowed) values
  ('30000000-0000-0000-0000-000000000001', 'Monthly', 1, 'months', 150000, 50000, 7),
  ('30000000-0000-0000-0000-000000000002', 'Quarterly', 3, 'months', 400000, 50000, 15);
insert into public.addons (id, name, price_paise, kind) values
  ('40000000-0000-0000-0000-000000000001', 'Locker', 30000, 'locker');

-- ---------- desk adds a member with health + membership ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.add_member(
  jsonb_build_object('name', 'Riya Sen', 'phone', '+919876500011', 'trainer_id', '10000000-0000-0000-0000-00000000000c',
                     'consent_health', true, 'dob', to_char(public.ist_today() - interval '25 years', 'YYYY-MM-DD')),
  jsonb_build_object('height_cm', 165, 'weight_kg', 60, 'conditions', 'asthma'),
  jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001', 'addon_ids', jsonb_build_array('40000000-0000-0000-0000-000000000001')));
reset role;

select pg_temp.check((select status from public.members where phone = '+919876500011') = 'active', 'add_member: status active right away');
select pg_temp.check((select membership_end from public.members where phone = '+919876500011')
                     = public.plan_end_date(public.ist_today(), 1, 'months'), 'add_member: end date from plan');
select pg_temp.check((select joining_fee_paise + addons_paise from public.memberships m join public.members mb on mb.id = m.member_id
                      where mb.phone = '+919876500011') = 80000, 'first membership charges joining fee + add-ons');
select pg_temp.check((select count(*) from public.member_events e join public.members mb on mb.id = e.member_id
                      where mb.phone = '+919876500011' and e.kind in ('joined', 'membership_started')) = 2,
                     'timeline: joined + membership started');

-- Desk cannot read health; owner and the assigned trainer can.
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.member_health) = 0, 'desk: cannot read health data');
select pg_temp.check((select count(*) from public.memberships) = 1, 'desk: reads memberships');
select pg_temp.raises($$update public.members set status = 'expired' where phone = '+919876500011'$$, 'desk: cannot write computed status');
select pg_temp.raises($$select public.cancel_membership((select id from public.memberships limit 1), 'test')$$, 'desk: cannot cancel (owner only)');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check((select conditions from public.member_health) = 'asthma', 'trainer: reads own member health');
select pg_temp.check((select count(*) from public.memberships) = 1, 'trainer: reads own member memberships');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check((select count(*) from public.member_health) = 1, 'owner: reads health');
reset role;

-- Link the member to a login.
insert into public.profiles (id, role, member_id, name)
select '00000000-0000-0000-0000-00000000000e', 'member', id, name from public.members where phone = '+919876500011';

-- ---------- renewal keeps remaining days ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.renew_membership((select id from public.members where phone = '+919876500011'));
reset role;
select pg_temp.check((select count(*) from public.memberships m join public.members mb on mb.id = m.member_id
                      where mb.phone = '+919876500011') = 2, 'renew: second membership created');
select pg_temp.check((select min(m.start_date) filter (where m.source = 'renewal') from public.memberships m)
                     = public.plan_end_date(public.ist_today(), 1, 'months') + 1, 'renew: starts the day after current end');
select pg_temp.check((select joining_fee_paise from public.memberships where source = 'renewal') = 0, 'renew: no joining fee again');
select pg_temp.check((select membership_end from public.members where phone = '+919876500011')
                     = public.plan_end_date(public.ist_today(), 1, 'months'), 'member shows the current (not the future) membership');

-- ---------- freeze / unfreeze ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.freeze_membership((select id from public.memberships where source = 'new'), public.ist_today(), 10)$$,
                      'freeze: more than the plan allows is refused');
select public.freeze_membership((select id from public.memberships where source = 'new'), public.ist_today(), 5, 'travel');
reset role;
select pg_temp.check((select status from public.members where phone = '+919876500011') = 'frozen', 'freeze: member is frozen today');
select pg_temp.check((select end_date from public.memberships where source = 'new')
                     = public.plan_end_date(public.ist_today(), 1, 'months') + 5, 'freeze: end date extended by 5');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.unfreeze_membership((select id from public.memberships where source = 'new'));
reset role;
select pg_temp.check((select end_date from public.memberships where source = 'new')
                     = public.plan_end_date(public.ist_today(), 1, 'months'), 'unfreeze same day: all 5 days returned');
select pg_temp.check((select status from public.members where phone = '+919876500011') in ('active', 'expiring'), 'unfreeze: active again');
select pg_temp.check((select count(*) from public.membership_freezes) = 0, 'unfreeze on day one removes the freeze');

-- ---------- overlap guard ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.start_membership((select id from public.members where phone = '+919876500011'),
                       '30000000-0000-0000-0000-000000000002')$$, 'start: overlapping membership refused');
select pg_temp.raises($$select public.start_membership((select id from public.members where phone = '+919876500011'),
                       '30000000-0000-0000-0000-000000000002', public.ist_today() + 400, 5000)$$, 'start: discount without reason refused');
reset role;

-- ---------- check-in ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.check_in((select id from public.members where phone = '+919876500011')) ->> 'already')::boolean = false, 'check-in: first today');
select pg_temp.check((public.check_in((select id from public.members where phone = '+919876500011')) ->> 'already')::boolean = true, 'check-in: second is "already checked in"');
select pg_temp.check((select count(*) from public.attendance) = 1, 'check-in: one row per day');
select pg_temp.check((public.staff_dashboard() ->> 'checkins_today')::int = 1, 'dashboard: today''s check-ins');
select pg_temp.check((public.staff_dashboard() ->> 'active')::int = 1, 'dashboard: active members');
select pg_temp.check(public.todays_gym_code() like 'ABSGYM-%', 'desk: sees today''s gym code');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.raises($$select public.todays_gym_code()$$, 'member: cannot read the gym code');
select pg_temp.raises($$select public.self_check_in('ABSGYM-WRONG')$$, 'member: wrong code refused');
select pg_temp.raises($$select public.check_in((select id from public.members limit 1))$$, 'member: cannot use desk check-in');
select pg_temp.check((select count(*) from public.member_events) = 0, 'member: cannot read the staff timeline');
select pg_temp.check((select count(*) from public.memberships) = 2, 'member: reads own memberships');
select pg_temp.check((select count(*) from public.member_health) = 1, 'member: reads own health');
reset role;
select set_config('test.code', public._gym_code(public.ist_today()), false);
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((public.self_check_in(lower(current_setting('test.code'))) ->> 'already')::boolean,
                     'member: self check-in with today''s code works (already in today)');
reset role;

-- ---------- needs action ----------
update public.members set dob = (public.ist_today() - interval '30 years')::date where phone = '+919876500011';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check(exists (select 1 from public.needs_action() where reason = 'birthday'), 'needs action: birthday today');
reset role;

-- ---------- transfer and cancel (owner) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.add_member(jsonb_build_object('name', 'Kabir Das', 'phone', '+919876500012'));
reset role;
select pg_temp.check((select status from public.members where phone = '+919876500012') = 'inactive', 'member without plan is inactive');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select public.transfer_membership((select id from public.memberships where source = 'renewal'),
                                  (select id from public.members where phone = '+919876500012'));
reset role;
select pg_temp.check((select status from public.members where phone = '+919876500012') = 'active', 'transfer: receiver becomes active');
select pg_temp.check((select cancelled_reason from public.memberships where source = 'renewal') like 'Transferred to ABS-%', 'transfer: source cancelled with reason');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select public.cancel_membership((select id from public.memberships where source = 'transfer'), 'Moved city', 0);
reset role;
select pg_temp.check((select status from public.members where phone = '+919876500012') = 'cancelled', 'cancel: member shows cancelled');

-- ---------- import ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
create temp table import_result as
select public.import_members(jsonb_build_array(
  jsonb_build_object('row', 2, 'name', 'Imported One', 'phone', '+919876500021', 'plan', 'quarterly',
                     'start_date', (public.ist_today() - 30)::text),
  jsonb_build_object('row', 3, 'name', 'Duplicate', 'phone', '+919876500011'),
  jsonb_build_object('row', 4, 'name', '', 'phone', '+919876500022'),
  jsonb_build_object('row', 5, 'name', 'Bad Plan', 'phone', '+919876500023', 'plan', 'Platinum'),
  jsonb_build_object('row', 6, 'name', 'Bad Phone', 'phone', '12345'))) as r;
reset role;
select pg_temp.check((select r -> 0 ->> 'status' from import_result) = 'imported', 'import: valid row imported (plan matched case-insensitively)');
select pg_temp.check((select r -> 1 ->> 'status' from import_result) = 'duplicate', 'import: duplicate phone skipped');
select pg_temp.check((select r -> 2 ->> 'status' from import_result) = 'error', 'import: missing name rejected');
select pg_temp.check((select r -> 3 ->> 'status' from import_result) = 'error', 'import: unknown plan rejected');
select pg_temp.check((select r -> 4 ->> 'status' from import_result) = 'error', 'import: bad phone rejected');
select pg_temp.check(not exists (select 1 from public.members where phone = '+919876500023'), 'import: failed row left nothing behind');
select pg_temp.check((select status from public.members where phone = '+919876500021') = 'active', 'import: membership dates honoured');

-- ---------- nightly refresh ----------
update public.memberships set end_date = public.ist_today() - 1
where member_id = (select id from public.members where phone = '+919876500021');
select pg_temp.check((select status from public.members where phone = '+919876500021') = 'expired', 'status recalculated immediately on change');
select pg_temp.check(public.refresh_statuses() >= 3, 'refresh_statuses runs over all members');

select 'ALL M1 TESTS PASSED' as result;
