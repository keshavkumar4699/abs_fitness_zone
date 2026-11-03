-- M2 tests: invoices, GST, payments, credit, claims, day close, voids,
-- refunds, instalments, reminders, summaries, gateway idempotency, RLS.

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

-- Ids used throughout.
-- owner a, desk b, trainer c, member e (Riya), member f (Kabir)

-- ---------- pure helpers ----------
select pg_temp.check(public.fy_label('2026-03-31') = '25-26', 'FY label: March belongs to the previous year');
select pg_temp.check(public.fy_label('2026-04-01') = '26-27', 'FY label: April starts a new year');
select pg_temp.check((select taxable from public.gst_split(118000, 18, true)) = 100000, 'GST inclusive: ₹1,180 → ₹1,000 taxable');
select pg_temp.check((select gst from public.gst_split(118000, 18, true)) = 18000, 'GST inclusive: ₹180 GST');
select pg_temp.check((select gst from public.gst_split(100000, 18, false)) = 18000, 'GST exclusive: 18% on top');
select pg_temp.check((select gst from public.gst_split(100000, 0, true)) = 0, 'GST 0%: none');

-- ---------- fixtures ----------
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'owner@abs.test'),
  ('00000000-0000-0000-0000-00000000000b', 'desk@abs.test'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer@abs.test'),
  ('00000000-0000-0000-0000-00000000000e', 'riya@abs.test'),
  ('00000000-0000-0000-0000-00000000000f', 'kabir@abs.test');
select public.bootstrap_owner('owner@abs.test', 'Gym Owner');
insert into public.staff (id, name, email, role) values
  ('10000000-0000-0000-0000-00000000000b', 'Desk', 'desk@abs.test', 'front_desk'),
  ('10000000-0000-0000-0000-00000000000c', 'Trainer', 'trainer@abs.test', 'trainer');
insert into public.profiles (id, role, staff_id, name) values
  ('00000000-0000-0000-0000-00000000000b', 'front_desk', '10000000-0000-0000-0000-00000000000b', 'Desk'),
  ('00000000-0000-0000-0000-00000000000c', 'trainer', '10000000-0000-0000-0000-00000000000c', 'Trainer');
insert into public.plans (id, name, duration_value, duration_unit, price_paise, joining_fee_paise, gst_rate) values
  ('30000000-0000-0000-0000-000000000001', 'Monthly', 1, 'months', 150000, 50000, 18),
  ('30000000-0000-0000-0000-000000000002', 'Quarterly', 3, 'months', 400000, 0, 18);
insert into public.addons (id, name, price_paise) values ('40000000-0000-0000-0000-000000000001', 'Locker', 30000);

set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.add_member(jsonb_build_object('name', 'Riya Sen', 'phone', '+919876500011', 'trainer_id', '10000000-0000-0000-0000-00000000000c'),
  null, jsonb_build_object('plan_id', '30000000-0000-0000-0000-000000000001', 'discount_paise', 20000, 'discount_reason', 'Diwali offer',
                           'addon_ids', jsonb_build_array('40000000-0000-0000-0000-000000000001')));
select public.add_member(jsonb_build_object('name', 'Kabir Das', 'phone', '+919876500012'));
reset role;
insert into public.profiles (id, role, member_id, name)
select '00000000-0000-0000-0000-00000000000e', 'member', id, name from public.members where phone = '+919876500011';
insert into public.profiles (id, role, member_id, name)
select '00000000-0000-0000-0000-00000000000f', 'member', id, name from public.members where phone = '+919876500012';

create temp table ids as
select (select id from public.members where phone = '+919876500011') riya,
       (select id from public.members where phone = '+919876500012') kabir,
       (select id from public.invoices limit 1) inv;
grant select on ids to authenticated;

-- ---------- invoice auto-created from the membership (2.1) ----------
select pg_temp.check((select count(*) from public.invoices) = 1, 'membership start creates one invoice');
select pg_temp.check((select invoice_no from public.invoices) = 'ABS/' || public.fy_label(public.ist_today()) || '/0001',
                     'invoice number is sequential per financial year');
select pg_temp.check((select subtotal_paise from public.invoices) = 230000, 'invoice subtotal = plan + joining fee + add-on');
select pg_temp.check((select discount_paise from public.invoices) = 20000, 'invoice carries the discount');
select pg_temp.check((select total_paise from public.invoices) = 210000, 'invoice total after discount');
select pg_temp.check((select count(*) from public.invoice_items) = 3, 'three invoice lines');
select pg_temp.check((select cgst_paise + sgst_paise from public.invoices) = 0, 'GST off by default');
select pg_temp.check((select status from public.invoices) = 'unpaid', 'new invoice is unpaid');
select pg_temp.check((select dues_paise from public.members where phone = '+919876500011') = 210000, 'member dues snapshot');

-- GST on: an ad-hoc invoice splits CGST/SGST.
update public.settings set value = 'true' where key = 'gst_enabled';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.create_invoice((select kabir from ids),
  jsonb_build_array(jsonb_build_object('kind', 'addon', 'description', 'PT pack', 'unit_paise', 118000, 'gst_rate', 18)));
reset role;
select pg_temp.check((select taxable_paise from public.invoices where member_name = 'Kabir Das') = 100000, 'GST invoice taxable value');
select pg_temp.check((select cgst_paise from public.invoices where member_name = 'Kabir Das') = 9000, 'CGST half');
select pg_temp.check((select sgst_paise from public.invoices where member_name = 'Kabir Das') = 9000, 'SGST half');
select pg_temp.check((select total_paise from public.invoices where member_name = 'Kabir Das') = 118000, 'inclusive price unchanged');
update public.settings set value = 'false' where key = 'gst_enabled';

-- ---------- collecting (2.2) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.collect_payment((select inv from ids), 50000, 'upi')$$, 'UPI without UTR refused');
select pg_temp.raises($$select public.collect_payment((select inv from ids), 0, 'cash')$$, 'zero amount refused');
select pg_temp.raises($$insert into public.payments (member_name, amount_paise, mode) values ('x', 100, 'cash')$$,
                      'direct payment insert refused');
update public.invoices set paid_paise = total_paise;
select pg_temp.check((select paid_paise from public.invoices where id = (select inv from ids)) = 0, 'direct invoice update changes nothing');
select pg_temp.check((public.collect_payment((select inv from ids), 100000, 'cash') ->> 'receipt_no')
                     = 'RCPT/' || public.fy_label(public.ist_today()) || '/0001', 'cash payment gets receipt 0001');
reset role;
select pg_temp.check((select status from public.invoices where id = (select inv from ids)) = 'partial', 'partial payment → partial');
select pg_temp.check((select balance_paise from public.invoices where id = (select inv from ids)) = 110000, 'balance after partial');

set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.collect_payment((select inv from ids), 150000, 'upi', 'UTR123456789') ->> 'credit_paise')::int = 40000,
                     'overpayment of ₹400 becomes credit');
select pg_temp.check(public.member_credit_balance((select riya from ids)) = 40000, 'credit balance');
reset role;
select pg_temp.check((select status from public.invoices where id = (select inv from ids)) = 'paid', 'fully paid → paid');
select pg_temp.check((select paid_paise from public.invoices where id = (select inv from ids)) = 210000, 'paid equals the total');
select pg_temp.check((select dues_paise from public.members where phone = '+919876500011') = 0, 'dues cleared');
do $$
begin
  set constraints all immediate;
  update public.invoices set paid_paise = 1 where id = (select inv from ids);
  raise exception 'FAILED: paid that does not match the payments was accepted';
exception when others then
  if sqlerrm like 'FAILED:%' then raise; end if;
  raise notice 'ok - paid that does not match the payments is rejected (%)', sqlerrm;
end $$;
select pg_temp.check((select count(*) from public.audit_log where table_name = 'payments') >= 2, 'payments are audit-logged');

-- ---------- trainer and member access ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check((select count(*) from public.invoices) = 0, 'trainer: no invoices');
select pg_temp.check((select count(*) from public.payments) = 0, 'trainer: no payments');
select pg_temp.raises($$select public.collect_payment((select inv from ids), 100, 'cash')$$, 'trainer: cannot collect');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((select count(*) from public.invoices) = 1, 'member: sees only own invoice');
select pg_temp.check((select count(*) from public.payments) = 0, 'member: sees none of another member''s payments');
select pg_temp.raises($$select public.claim_payment((select inv from ids), 100, 'UTR999999')$$, 'member: cannot claim on another''s invoice');
select pg_temp.raises($$select public.collections_summary(public.ist_today(), public.ist_today())$$, 'member: no revenue summary');
select pg_temp.check(public.billing_profile() ? 'upi_id' and public.billing_profile() ? 'gst_enabled',
                     'member: reads the billing profile for pay screens');
select pg_temp.check(not (public.billing_profile() ? 'checkin_secret') and not (public.billing_profile() ? 'expiring_window_days'), 'billing profile hides secrets');

-- ---------- member self-pay claim + verification (2.5) ----------
select public.claim_payment((select id from public.invoices where member_name = 'Kabir Das'), 50000, 'KABIRUPI0001');
select pg_temp.raises($$select public.claim_payment((select id from public.invoices where member_name = 'Kabir Das'), 100, 'KABIRUPI0001')$$,
                      'member: the same UTR cannot be claimed twice');
reset role;
select pg_temp.check((select status from public.payments where utr = 'KABIRUPI0001') = 'pending_verification', 'claim waits for staff');
select pg_temp.check((select status from public.invoices where member_name = 'Kabir Das') = 'unpaid', 'claim does not count yet');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.dues_summary() ->> 'pending_claims')::int = 1, 'desk sees one pending claim');
select pg_temp.raises($$select public.verify_payment((select id from public.payments where utr = 'KABIRUPI0001'), false)$$,
                      'rejecting needs a reason');
select public.verify_payment((select id from public.payments where utr = 'KABIRUPI0001'), true);
reset role;
select pg_temp.check((select status from public.payments where utr = 'KABIRUPI0001') = 'confirmed', 'approved claim is confirmed');
select pg_temp.check((select receipt_no from public.payments where utr = 'KABIRUPI0001') is not null, 'approved claim gets a receipt');
select pg_temp.check((select status from public.invoices where member_name = 'Kabir Das') = 'partial', 'approved claim counts');

-- ---------- credit used on another invoice ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.renew_membership((select riya from ids));
reset role;
select pg_temp.check((select count(*) from public.invoices where member_id = (select riya from ids)) = 2, 'renewal creates an invoice');
select pg_temp.check((select joining_fee_paise from public.memberships where source = 'renewal') = 0
                     and (select total_paise from public.invoices where member_id = (select riya from ids) order by created_at desc limit 1) = 150000,
                     'renewal invoice has no joining fee');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.apply_credit((select id from public.invoices where member_id = (select riya from ids) and status = 'unpaid'), 50000)$$,
                      'cannot use more credit than available');
select public.apply_credit((select id from public.invoices where member_id = (select riya from ids) and status = 'unpaid'), 40000);
select pg_temp.check(public.member_credit_balance((select riya from ids)) = 0, 'credit used up');
reset role;
select pg_temp.check((select balance_paise from public.invoices where member_id = (select riya from ids) order by created_at desc limit 1) = 110000,
                     'credit reduces the renewal balance');

-- ---------- instalments (2.6) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.set_instalments((select id from public.invoices where member_id = (select riya from ids) order by created_at desc limit 1),
  jsonb_build_array(jsonb_build_object('due_date', public.ist_today() + 1, 'amount_paise', 1000)))$$, 'instalments must add up to the total');
select public.set_instalments((select id from public.invoices where member_id = (select riya from ids) order by created_at desc limit 1),
  jsonb_build_array(jsonb_build_object('due_date', public.ist_today(), 'amount_paise', 75000),
                    jsonb_build_object('due_date', public.ist_today() + 15, 'amount_paise', 75000)));
select public.collect_payment((select id from public.invoices where member_id = (select riya from ids) order by created_at desc limit 1), 35000, 'card');
reset role;
select pg_temp.check((select count(*) from public.instalments where status = 'paid') = 1, 'first instalment paid (credit + card = ₹750)');
select pg_temp.check((select next_due_date from public.invoices where member_id = (select riya from ids) order by created_at desc limit 1)
                     = public.ist_today() + 15, 'next due date moves to the second instalment');

-- ---------- reminders and summaries ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check(exists (select 1 from public.dues_reminders_today() where member_name = 'Kabir Das'), 'reminder due today for Kabir');
select pg_temp.check((public.dues_summary() ->> 'due_count')::int = 2, 'dues summary counts open invoices');
select pg_temp.raises($$select public.collections_summary(public.ist_today(), public.ist_today())$$, 'desk: no revenue summary');
select pg_temp.check((select count(*) from public.expenses) = 0, 'desk: cannot read expenses');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check((public.collections_summary(public.ist_today(), public.ist_today()) ->> 'collected')::int = 335000,
                     'owner: collected today (credit not double-counted)');
select pg_temp.check((public.collections_summary(public.ist_today(), public.ist_today()) -> 'by_mode' ->> 'upi')::int = 200000,
                     'owner: collections by mode');
insert into public.expenses (category, amount_paise, note) values ('electricity', 450000, 'October bill');
select pg_temp.check((public.collections_summary(public.ist_today(), public.ist_today()) ->> 'expenses')::int = 450000, 'owner: expenses');
reset role;

-- ---------- day close locks the desk (2.13) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((public.day_summary() ->> 'cash')::int = 100000, 'day summary: own cash');
select pg_temp.check((public.close_day(95000, 'short by 50') ->> 'difference')::int = -5000, 'day close records the cash difference');
select pg_temp.raises($$select public.collect_payment((select id from public.invoices where member_name = 'Kabir Das'), 1000, 'cash')$$,
                      'closed day: no more payments by that staff member');
select pg_temp.raises($$select public.close_day(0)$$, 'cannot close the same day twice');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select public.reopen_day((select id from public.day_closes limit 1));
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select public.collect_payment((select id from public.invoices where member_name = 'Kabir Das'), 1000, 'cash');
select pg_temp.check((public.day_summary() ->> 'closed')::boolean = false, 'owner reopened the day');
reset role;

-- ---------- voids and refunds (2.11) ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.void_payment((select id from public.payments where mode = 'card'), 'mistake')$$, 'desk: cannot void');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.raises($$select public.void_payment((select id from public.payments where mode = 'card'), '')$$, 'void needs a reason');
select public.void_payment((select id from public.payments where mode = 'card'), 'Card machine error');
select pg_temp.check((select status from public.payments where mode = 'card') = 'voided', 'payment voided, not deleted');
select public.refund_payment((select id from public.payments where utr = 'KABIRUPI0001'), 10000, 'cash', 'Partial refund');
reset role;
select pg_temp.check((select paid_paise from public.invoices where member_name = 'Kabir Das') = 41000, 'refund reduces paid (₹500 + ₹10 − ₹100)');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.raises($$select public.void_invoice((select id from public.invoices where member_name = 'Kabir Das'), 'wrong')$$,
                      'cannot void an invoice that has payments');
select public.create_invoice((select kabir from ids), jsonb_build_array(jsonb_build_object('description', 'Water bottle', 'unit_paise', 25000)));
select public.void_invoice((select id from public.invoices where member_name = 'Kabir Das' and total_paise = 25000), 'Entered by mistake');
reset role;
select pg_temp.check((select status from public.invoices where total_paise = 25000) = 'void', 'unpaid invoice voided');

-- ---------- gateway webhook is idempotent (2.4) ----------
set role service_role;
select public.record_gateway_payment((select id from public.invoices where member_name = 'Kabir Das' and status <> 'void'), 5000, 'evt_1', 'pay_1');
select pg_temp.check((public.record_gateway_payment((select id from public.invoices where member_name = 'Kabir Das' and status <> 'void'),
                      5000, 'evt_1', 'pay_1') ->> 'duplicate')::boolean, 'same webhook event twice → recorded once');
reset role;
select pg_temp.check((select count(*) from public.payments where gateway_event_id = 'evt_1') = 1, 'one gateway payment');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.record_gateway_payment((select inv from ids), 100, 'evt_x', 'pay_x')$$,
                      'desk: cannot call the webhook function');
select pg_temp.check((public.check_in((select kabir from ids)) ->> 'dues_paise')::int > 0, 'check-in reports dues pending');
reset role;

-- ---------- nightly + member deletion keeps financial records ----------
select pg_temp.check(public.refresh_dues() >= 1, 'refresh_dues runs');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
delete from public.members where id = (select kabir from ids);
reset role;
select pg_temp.check((select count(*) from public.invoices where member_name = 'Kabir Das') >= 2 and
                     (select bool_and(member_id is null) from public.invoices where member_name = 'Kabir Das'),
                     'deleting a member keeps invoices with the name snapshot');

select 'ALL M2 TESTS PASSED' as result;
