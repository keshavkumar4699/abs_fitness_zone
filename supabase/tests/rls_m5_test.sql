-- M5 tests: templates and formatting, instant confirmations, the daily
-- queue (expiry, dues with the UPI link, birthdays, festivals), the
-- once-a-day marketing cap and the 24-hour rule, stopping reminders when
-- paid, broadcasts and segments, the free-mode queue, manual sends, opt-out,
-- the API-mode hand-off (claim, retry, move to free mode, receipts,
-- inbound STOP and the 24-hour window), the cost meter, and who sees what.

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
  ('30000000-0000-0000-0000-000000000001', 'Monthly', 1, 'months', 150000, 0, 0),
  ('30000000-0000-0000-0000-000000000002', 'Quarterly', 3, 'months', 400000, 0, 0);
insert into public.settings (key, value) values ('gym_name', '"ABS Fitness Zone"'), ('upi_id', '"absfit@okaxis"')
on conflict (key) do update set value = excluded.value;

set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
-- Riya: English, birthday today, monthly plan. Kabir: Hindi, morning batch,
-- quarterly. Meena: no WhatsApp consent. Sanjay: no plan.
select public.add_member(jsonb_build_object('name', 'Riya Sen', 'phone', '+919876500011',
  'trainer_id', '10000000-0000-0000-0000-00000000000c',
  'dob', to_char(public.ist_today() - interval '30 years', 'YYYY-MM-DD')),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001'));
select public.add_member(jsonb_build_object('name', 'Kabir Das', 'phone', '+919876500012', 'language', 'hi', 'batch', 'morning',
  'trainer_id', '10000000-0000-0000-0000-00000000000d'),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000002'));
select public.add_member(jsonb_build_object('name', 'Meena Iyer', 'phone', '+919876500013', 'consent_whatsapp', false),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001'));
select public.add_member(jsonb_build_object('name', 'Sanjay Rao', 'phone', '+919876500014'));
reset role;
create temp table ids as
select (select id from public.members where phone = '+919876500011') riya,
       (select id from public.members where phone = '+919876500012') kabir,
       (select id from public.members where phone = '+919876500013') meena,
       (select id from public.members where phone = '+919876500014') sanjay;
grant select on ids to authenticated, anon;
insert into public.profiles (id, role, member_id, name) values
  ('00000000-0000-0000-0000-00000000000e', 'member', (select riya from ids), 'Riya Sen'),
  ('00000000-0000-0000-0000-00000000000f', 'member', (select kabir from ids), 'Kabir Das');

-- ---------- seed and formatting (8.1) ----------
select pg_temp.check((select count(*) from public.message_templates where is_system) = 24, 'seed: 12 templates in English and Hindi');
select pg_temp.check((select count(distinct key) from public.message_templates where category = 'marketing') = 2, 'seed: birthday and festival are marketing');
select pg_temp.check((select count(*) filter (where is_enabled) = 10 and count(*) = 11 from public.festivals), 'seed: festival calendar, Eid off until its date is confirmed');
select pg_temp.check(public._inr(150000) = '₹1,500' and public._inr(12345678) = '₹1,23,456.78' and public._inr(150050) = '₹1,500.50',
                     'amounts in rupees with Indian grouping');
select pg_temp.check(public._day_label('2026-11-03') = '3 Nov 2026', 'dates read like the app');
select pg_temp.check(public._render('Hi {first_name}, {amount}{unknown}!', '{"first_name": "Riya", "amount": "₹1,500"}') = 'Hi Riya, ₹1,500!',
                     'templates fill variables and drop unknown ones');
select pg_temp.check(public._params('{first_name}: {amount} for {first_name}', '{"first_name": "Riya", "amount": "₹9"}') = '["Riya", "₹9", "Riya"]',
                     'API template parameters follow the order of the text');
-- The app's preview renderer (lib/features/whatsapp/domain/message_text.dart)
-- is tested with the same inputs: both must give the same text.
select pg_temp.check(public._render('Hi {first_name}, {first_name}! {unknown}See you at {gym_name}.',
                                   '{"first_name": "Riya", "gym_name": "ABS Fitness Zone"}')
                     = 'Hi Riya, Riya! See you at ABS Fitness Zone.', 'render: same result as the app preview');
select pg_temp.check(public._render('Price {₹500} or {A} or {}', '{}') = 'Price {₹500} or {A} or {}',
                     'render: braces that are not variables stay');
select pg_temp.check(public._upi_link(150000, 'ABS/26-27/0001') =
                     'upi://pay?pa=absfit@okaxis&pn=ABS%20Fitness%20Zone&am=1500.00&cu=INR&tn=ABS%20Fitness%20Zone%20ABS%2F26-27%2F0001&tr=ABS26270001',
                     'UPI pay link like the app''s');
select pg_temp.check(public._upi_link(0, 'X') is null, 'no pay link for nothing due');

-- ---------- instant confirmations (8.4) ----------
select pg_temp.check((select body like 'Welcome to ABS Fitness Zone, Riya! Your Monthly membership runs from %' and source = 'event'
                             and status = 'queued' and channel = 'link' and category = 'utility'
                      from public.message_queue where member_id = (select riya from ids) and template_key = 'membership_started'),
                     'joining with a plan queues a welcome in free mode');
select pg_temp.check((select language = 'hi' and body like '%स्वागत%Quarterly%'
                      from public.message_queue where member_id = (select kabir from ids) and template_key = 'membership_started'),
                     'members who prefer Hindi get Hindi');
select pg_temp.check(not exists (select 1 from public.message_queue where member_id = (select meena from ids)),
                     'no WhatsApp consent: no messages');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.collect_payment((select id from public.invoices where member_id = (select riya from ids)), 50000, 'cash');
reset role;
select pg_temp.check((select body like '%we''ve received ₹500 (receipt %' from public.message_queue
                      where member_id = (select riya from ids) and template_key = 'payment_received'),
                     'a payment queues a thank-you with the amount and receipt');
update public.settings set value = '{"expiry": true, "dues": true, "birthday": true, "festival": true, "payment": false, "membership": true, "plan": true}'
 where key = 'whatsapp_automations';
delete from public.message_queue where template_key = 'payment_received';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.collect_payment((select id from public.invoices where member_id = (select kabir from ids)), 10000, 'cash');
reset role;
select pg_temp.check(not exists (select 1 from public.message_queue where template_key = 'payment_received'),
                     'an automation switched off sends nothing');
update public.settings set value = '{"expiry": true, "dues": true, "birthday": true, "festival": true, "payment": true, "membership": true, "plan": true}'
 where key = 'whatsapp_automations';

-- ---------- the daily queue (8.2, 8.3, 8.5, 8.6) ----------
update public.memberships set end_date = public.ist_today() + 7 where member_id = (select riya from ids);
update public.memberships set start_date = public.ist_today() - 93, end_date = public.ist_today() - 3 where member_id = (select kabir from ids);
update public.invoices set next_due_date = public.ist_today() + 3 where member_id = (select riya from ids);
update public.invoices set next_due_date = public.ist_today() + 10 where member_id = (select kabir from ids);
insert into public.festivals (name, local_name, day) values ('Gym Day', 'जिम दिवस', public.ist_today());
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises('select public.build_message_queue()', 'trainer: cannot build the queue');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.raises('select public.build_message_queue()', 'member: cannot build the queue');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
create temp table run1 as select public.build_message_queue() as r;
reset role;
select pg_temp.check((select r = '{"dues": 1, "expiry": 2, "birthday": 1, "festival": 2}' from run1),
                     'desk: builds today''s queue');
select pg_temp.check((select body like '%ends on % (7 days left)%' and scheduled_for = (public.ist_today() + time '09:00') at time zone 'Asia/Kolkata'
                      from public.message_queue where member_id = (select riya from ids) and template_key = 'expiry_soon'),
                     'expiry: 7 days before, at 09:00 IST');
select pg_temp.check((select language = 'hi' from public.message_queue where member_id = (select kabir from ids) and template_key = 'expired'),
                     'expiry: 3 days after, in Hindi');
select pg_temp.check((select body like '%₹1,000 for % is due on %. Pay by UPI: upi://pay?pa=absfit@okaxis%am=1000.00%' and invoice_id is not null
                      from public.message_queue where member_id = (select riya from ids) and template_key = 'dues_reminder'),
                     'dues: the balance with the UPI pay link');
select pg_temp.check((select category = 'marketing' from public.message_queue where member_id = (select riya from ids) and template_key = 'birthday'),
                     'birthday wishes on the day');
select pg_temp.check(not exists (select 1 from public.message_queue where member_id = (select riya from ids) and template_key = 'festival'),
                     'one marketing message a day: Riya''s birthday beats the festival');
select pg_temp.check((select body like 'जिम दिवस की हार्दिक शुभकामनाएँ, Kabir!%' from public.message_queue
                      where member_id = (select kabir from ids) and template_key = 'festival'),
                     'festival wishes use the Hindi name for Hindi speakers');
select pg_temp.check((select body like 'Happy Gym Day, Sanjay!%' from public.message_queue
                      where member_id = (select sanjay from ids) and template_key = 'festival'),
                     'festival wishes reach members without a plan');
select pg_temp.check((select items = 6 and finished_at is not null from public.automation_runs where rule_key = 'build_message_queue'),
                     'the run is logged');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check(public.build_message_queue() = '{"dues": 0, "expiry": 0, "birthday": 0, "festival": 0}', 'running again adds nothing');
reset role;
update public.memberships set end_date = public.ist_today() + 3 where member_id = (select riya from ids);
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.build_message_queue() ->> 'expiry')::int = 0, 'the same reminder never goes twice within 24 hours');
reset role;
-- No UPI ID: the reminder asks them to pay at the desk.
delete from public.settings where key = 'upi_id';
update public.invoices set next_due_date = public.ist_today() where member_id = (select kabir from ids);
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.build_message_queue();
reset role;
select pg_temp.check((select body like '%डेस्क पर भुगतान%' from public.message_queue
                      where member_id = (select kabir from ids) and template_key = 'dues_reminder_desk'),
                     'dues without a UPI ID: pay at the desk');
insert into public.settings (key, value) values ('upi_id', '"absfit@okaxis"');
-- The next morning, yesterday's unsent automatic messages are dropped;
-- receipts stay.
update public.message_queue set scheduled_for = scheduled_for - interval '1 day'
 where member_id = (select kabir from ids) and template_key = 'dues_reminder_desk';
insert into public.message_queue (member_id, template_key, category, body, channel, source, scheduled_for)
values ((select kabir from ids), 'payment_received', 'utility', 'Thanks', 'link', 'event', now() - interval '1 day');
select public.build_message_queue();
select pg_temp.check((select status = 'cancelled' and error = 'not sent on the day' from public.message_queue
                      where member_id = (select kabir from ids) and template_key = 'dues_reminder_desk'),
                     'yesterday''s unsent reminder is dropped');
select pg_temp.check((select status = 'queued' from public.message_queue
                      where member_id = (select kabir from ids) and template_key = 'payment_received'),
                     'an unsent receipt stays');
delete from public.message_queue where member_id = (select kabir from ids) and template_key = 'payment_received';

-- Paying stops the reminder (8.3).
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.collect_payment((select id from public.invoices where member_id = (select riya from ids)), 100000, 'cash');
reset role;
select pg_temp.check((select status = 'cancelled' and error = 'paid' from public.message_queue
                      where member_id = (select riya from ids) and template_key = 'dues_reminder'),
                     'paying cancels the waiting reminder');

-- ---------- broadcasts and segments (8.8) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check(public.segment_count('{"kind": "all"}') = '{"total": 4, "reachable": 3}', 'segment preview: all, and who can get WhatsApp');
select pg_temp.check((public.segment_count('{"kind": "batch", "batch": "morning"}') ->> 'total')::int = 1, 'segment: batch');
select pg_temp.check((public.segment_count(jsonb_build_object('kind', 'trainer', 'trainer_id', '10000000-0000-0000-0000-00000000000c')) ->> 'total')::int = 1,
                     'segment: a trainer''s members');
select pg_temp.check((public.segment_count('{"kind": "expiring"}') ->> 'total')::int = 1, 'segment: expiring this week');
select pg_temp.check((public.segment_count('{"kind": "dues"}') ->> 'total')::int = 2, 'segment: members with dues');
select pg_temp.check((public.segment_count(jsonb_build_object('kind', 'members', 'member_ids', jsonb_build_array((select riya from ids), (select sanjay from ids)))) ->> 'total')::int = 2,
                     'segment: picked members (bulk WhatsApp)');
create temp table b1 as select public.create_broadcast('Closed Sunday', 'Hi {first_name}, the gym is closed this Sunday for maintenance.', 'utility', '{"kind": "all"}') as r;
select pg_temp.check((select (r ->> 'queued')::int = 3 and (r ->> 'skipped')::int = 1 from b1), 'broadcast: queued for everyone reachable');
select pg_temp.check((select body from public.message_queue where member_id = (select sanjay from ids) and source = 'broadcast')
                     = 'Hi Sanjay, the gym is closed this Sunday for maintenance.', 'broadcast text is personalised');
select pg_temp.check((select (r ->> 'queued')::int = 0 and (r ->> 'skipped')::int = 4
                      from (select public.create_broadcast('Offer', 'Hi {first_name}, 20% off this week!', 'marketing', '{"kind": "all"}') r) x),
                     'marketing broadcast skips anyone who already had marketing today');
select pg_temp.raises($$select public.create_broadcast('Bad', 'Hello there', 'utility', '{"kind": "everyone"}')$$, 'unknown segments are refused');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.create_broadcast('Trainer', 'Hello there', 'utility', '{"kind": "all"}')$$, 'trainer: cannot broadcast');
select pg_temp.raises($$select public.segment_count('{"kind": "all"}')$$, 'trainer: no segment counts');

-- ---------- who sees the queue and the log (8.13) ----------
select pg_temp.check((select count(*) from public.message_queue) = 0, 'trainer: cannot see messages');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) > 0 and bool_and(member_id = (select riya from ids)) from public.message_queue),
                     'member: sees only their own messages');
select pg_temp.check((select count(*) from public.message_templates) = 0, 'member: no templates');
select pg_temp.check(public.whatsapp_settings() is null, 'member: no WhatsApp settings');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.message_queue) >= 10, 'desk: sees the whole queue');
select pg_temp.check((public.whatsapp_settings() ->> 'mode') = 'link', 'desk: reads the mode');

-- ---------- free mode (8.9) and manual sends ----------
create temp table q1 as select id from public.message_queue where member_id = (select sanjay from ids) and template_key = 'festival';
grant select on q1 to authenticated;
select public.mark_message((select id from q1), 'sent');
select pg_temp.check((select status = 'sent' and sent_by = '00000000-0000-0000-0000-00000000000b' and sent_at is not null
                      from public.message_queue where id = (select id from q1)), 'desk: ticks a message sent');
select public.mark_message((select id from q1), 'queued');
select pg_temp.check((select status = 'queued' and sent_at is null from public.message_queue where id = (select id from q1)), 'desk: undo');
select public.mark_message((select id from q1), 'skipped');
select pg_temp.check((select status from public.message_queue where id = (select id from q1)) = 'skipped', 'desk: skips one');
select pg_temp.raises($$select public.mark_message((select id from q1), 'read')$$, 'only sent, skipped or back to queued');
select pg_temp.check(public.log_manual_message((select riya from ids), 'Hi Riya, see you at 6!') is not null, 'desk: logs a one-off message');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.mark_message((select id from q1), 'sent')$$, 'trainer: cannot tick queue messages');
select pg_temp.check(public.log_manual_message((select riya from ids), 'Great session today!') is not null, 'trainer: logs a message to their member');
select pg_temp.raises($$select public.log_manual_message((select kabir from ids), 'Hello')$$, 'trainer: not to another trainer''s member');
reset role;
select pg_temp.check((select count(*) from public.message_queue where source = 'manual' and status = 'sent' and member_id = (select riya from ids)) = 2,
                     'manual messages land in the log as sent');

-- ---------- opt-out (8.12) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.raises($$select public.set_whatsapp_opt_out(true, (select riya from ids))$$, 'member: cannot opt someone else out');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select public.set_whatsapp_opt_out(true);
reset role;
select pg_temp.check((select whatsapp_opt_out from public.members where id = (select riya from ids)), 'member: turns WhatsApp off');
select pg_temp.check(not exists (select 1 from public.message_queue where member_id = (select riya from ids) and status = 'queued'),
                     'opting out cancels waiting messages');
select pg_temp.check((select count(*) from public.member_events where member_id = (select riya from ids) and kind = 'whatsapp_opt_out') = 1
                     and not exists (select 1 from public.member_events where member_id = (select riya from ids) and kind = 'profile_updated'),
                     'opting out shows once in their history');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select (r ->> 'skipped')::int = 2 from (select public.create_broadcast('Note', 'Hi {first_name}, new timings from Monday.', 'utility',
                       jsonb_build_object('kind', 'members', 'member_ids', jsonb_build_array((select riya from ids), (select meena from ids)))) r) x),
                     'opted-out and unconsented members are skipped');
select public.set_whatsapp_opt_out(false, (select riya from ids));
reset role;
select pg_temp.check((select not whatsapp_opt_out from public.members where id = (select riya from ids)), 'desk: turns it back on');

-- ---------- API mode (8.10, 8.11) ----------
update public.settings set value = '"api"' where key = 'whatsapp_mode';
select pg_temp.check(not exists (select 1 from public.message_queue where channel = 'link' and status = 'queued' and attempts = 0 and error is null)
                     and exists (select 1 from public.message_queue where channel = 'api' and status = 'queued'),
                     'switching to API mode moves waiting messages to the API');
-- The checks below look only at the broadcast made in API mode.
update public.message_queue set status = 'skipped' where channel = 'api' and status = 'queued';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.create_broadcast('API test', 'Hi {first_name}, testing.', 'utility',
  jsonb_build_object('kind', 'members', 'member_ids', jsonb_build_array((select riya from ids), (select kabir from ids))));
select pg_temp.raises($$select * from public.whatsapp_claim(10)$$, 'the app cannot claim API messages');
reset role;
select pg_temp.check((select count(*) from public.message_queue where source = 'broadcast' and channel = 'api' and status = 'queued') = 2,
                     'API mode: new messages go to the API');
create temp table claimed as select * from public.whatsapp_claim(10);
select pg_temp.check((select count(*) from claimed) = 2 and (select bool_and(phone like '+91%') from claimed), 'claim: due API messages with phones');
select pg_temp.check((select count(*) from public.message_queue where status = 'sending') = 2, 'claimed messages are marked sending');
select pg_temp.check((select count(*) from public.whatsapp_claim(10)) = 0, 'a second run never claims them again');
select pg_temp.check(public.whatsapp_result((select id from claimed where member_id = (select riya from ids)), true, 'wamid.R1') = 'sent',
                     'result: sent with the WhatsApp message id');
select pg_temp.check(public.whatsapp_result((select id from claimed where member_id = (select kabir from ids)), false, null, 'timeout') = 'retry',
                     'result: the first failure is retried');
select pg_temp.check((select status = 'queued' and channel = 'api' and attempts = 1 from public.message_queue
                      where id = (select id from claimed where member_id = (select kabir from ids))), 'retry stays in API mode');
select public.whatsapp_claim(10);
select pg_temp.check(public.whatsapp_result((select id from claimed where member_id = (select kabir from ids)), false, null, 'timeout') = 'moved',
                     'result: the second failure moves it to free mode');
select pg_temp.check((select status = 'queued' and channel = 'link' from public.message_queue
                      where id = (select id from claimed where member_id = (select kabir from ids))), 'moved messages wait in the free-mode queue');
select pg_temp.check(public.whatsapp_result((select id from public.message_queue where member_id = (select sanjay from ids) and template_key = 'festival'),
                                            false, null, 'no approved template', false, true) = 'moved',
                     'result: a failure that can never succeed moves at once');
select pg_temp.check(public.whatsapp_status('wamid.R1', 'delivered') = 'delivered' and public.whatsapp_status('wamid.R1', 'read') = 'read',
                     'receipts: delivered, then read');
select pg_temp.check((select status = 'read' and delivered_at is not null and read_at is not null from public.message_queue where wa_message_id = 'wamid.R1'),
                     'receipts are logged');
select pg_temp.check(public.whatsapp_status('wamid.unknown', 'read') = 'unknown', 'receipts for unknown messages are ignored');

-- The 24-hour window (8.11) and STOP (8.12).
update public.message_queue set scheduled_for = now() + interval '20 hours', status = 'queued', channel = 'api'
 where member_id = (select riya from ids) and template_key = 'expiry_soon';
create temp table inbound as select public.whatsapp_inbound('919876500011', 'Hi, what are the timings?') as r;
select pg_temp.check((select (r ->> 'member_id')::uuid = (select riya from ids) and jsonb_array_length(r -> 'send_now') = 1 from inbound),
                     'inbound: finds the member and the utility messages to send now, free');
select pg_temp.check((select whatsapp_last_inbound_at is not null from public.members where id = (select riya from ids)), 'inbound: the window opens');
select pg_temp.check(not exists (select 1 from public.member_events where member_id = (select riya from ids) and kind = 'profile_updated'),
                     'messages from a member don''t clutter their history');
select pg_temp.check((select in_window from public.whatsapp_claim(10) where member_id = (select riya from ids)), 'claim knows the window is open');
select pg_temp.check((public.whatsapp_inbound('+91 98765 00012', 'STOP') ->> 'opted_out')::boolean, 'inbound STOP is recognised');
select pg_temp.check((select whatsapp_opt_out from public.members where id = (select kabir from ids)), 'inbound STOP opts the member out');
select pg_temp.check(not (public.whatsapp_inbound('9876500012', 'start') ->> 'opted_out')::boolean, 'START is recognised');
select pg_temp.check((select not whatsapp_opt_out from public.members where id = (select kabir from ids)), 'START turns it back on');
select pg_temp.check(public.whatsapp_inbound('9999999999', 'hello') ->> 'member_id' is null, 'strangers are ignored');

-- ---------- cost meter (8.14) ----------
update public.message_queue set channel = 'api', status = 'sent', sent_at = now(), category = 'marketing', free_window = false
 where member_id = (select sanjay from ids) and template_key = 'broadcast_' || replace((select r ->> 'broadcast_id' from b1), '-', '');
update public.settings set value = '1' where key = 'whatsapp_marketing_cap_paise';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check((select (c ->> 'marketing_sent')::int = 1 and (c ->> 'marketing_paise')::int = 78 and (c ->> 'utility_sent')::int = 1
                             and (c ->> 'utility_paise')::int = 14 and (c ->> 'marketing_paused')::boolean
                      from (select public.whatsapp_cost_month() c) x), 'owner: this month''s API spend, and the cap pauses marketing');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises('select public.whatsapp_cost_month()', 'desk: no cost meter');
reset role;
update public.message_queue set status = 'queued', channel = 'api', category = 'marketing', scheduled_for = now() - interval '1 minute'
 where member_id = (select kabir from ids) and template_key = 'festival';
select pg_temp.check(not exists (select 1 from public.whatsapp_claim(10) where category = 'marketing'), 'claim holds marketing while paused');
select pg_temp.check((select channel = 'link' and status = 'queued' and error = 'monthly marketing cap reached' from public.message_queue
                      where member_id = (select kabir from ids) and template_key = 'festival'),
                     'over the cap, marketing moves to the free-mode list');
update public.message_queue set channel = 'api', error = null where member_id = (select kabir from ids) and template_key = 'festival';
update public.settings set value = '0' where key = 'whatsapp_marketing_cap_paise';
select pg_temp.check(exists (select 1 from public.whatsapp_claim(10) where category = 'marketing'), 'no cap: marketing goes out');

-- ---------- templates and festivals (8.1, 8.6) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
update public.message_templates set body = 'Hello {first_name}! {plan} ends {end_date}.', key = 'hijack'
 where key = 'expiry_today' and language = 'en';
select pg_temp.check((select body = 'Hello {first_name}! {plan} ends {end_date}.' from public.message_templates
                      where key = 'expiry_today' and language = 'en'), 'owner: edits a template (its key stays)');
select pg_temp.raises($$delete from public.message_templates where key = 'birthday' and language = 'en'$$, 'built-in templates cannot be deleted');
insert into public.message_templates (key, language, category, title, body) values ('offer_monsoon', 'en', 'marketing', 'Monsoon offer', 'Hi {first_name}!');
delete from public.message_templates where key = 'offer_monsoon';
select pg_temp.check(not exists (select 1 from public.message_templates where key = 'offer_monsoon'), 'owner: adds and removes their own templates');
update public.festivals set day = '2027-03-09', is_enabled = true where name = 'Eid ul-Fitr';
select pg_temp.check((select is_enabled from public.festivals where name = 'Eid ul-Fitr'), 'owner: confirms a festival date');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
update public.message_templates set body = 'Desk edit' where key = 'birthday';
select pg_temp.check((select count(*) from public.message_templates where body = 'Desk edit') = 0, 'desk: reads templates but cannot change them');
select pg_temp.check((select count(*) from public.festivals) = 12, 'desk: reads the festival calendar');
update public.settings set value = '"link"' where key = 'whatsapp_mode';
select pg_temp.check((public.whatsapp_settings() ->> 'mode') = 'api', 'desk: cannot change the mode (owner setting)');
reset role;
update public.settings set value = '"link"' where key = 'whatsapp_mode';
select pg_temp.check(not exists (select 1 from public.message_queue where channel = 'api' and status in ('queued', 'sending')),
                     'back in free mode, nothing waits on the API');

-- ---------- anonymous ----------
set role anon;
select pg_temp.as_user(null);
select pg_temp.check((select count(*) from public.message_queue) = 0, 'anon: no messages');
select pg_temp.raises('select public.build_message_queue()', 'anon: cannot build the queue');
reset role;

select 'ALL M5 TESTS PASSED' as result;
