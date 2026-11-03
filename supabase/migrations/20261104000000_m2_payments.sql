-- ABS Fitness — Milestone M2: fees and payments (F2)
-- Invoices (auto from memberships, GST split), payments in every mode with
-- partial payments and member credit, member "I've paid" claims verified by
-- staff, instalments, voids and refunds (owner), the dues engine and reminder
-- schedule, day close with locking, expenses, collection summaries, audit.
-- Money is integer paise; days are IST calendar dates.

-- ---------------------------------------------------------------------------
-- Settings
-- ---------------------------------------------------------------------------
insert into public.settings (key, value) values
  ('gst_enabled', 'false'),
  ('gst_inclusive', 'true'),              -- plan prices already include GST
  ('razorpay_enabled', 'false'),
  ('due_reminder_days', '[3, 0, -3, -7]') -- days before (+) / after (-) due
on conflict (key) do nothing;

create or replace function public.setting_bool(p_key text, p_default boolean)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select (value #>> '{}')::boolean from public.settings where key = p_key), p_default)
$$;

-- What receipts and the pay screens need: the public profile plus GSTIN and
-- the payment switches. Signed-in users only (never the secrets).
create or replace function public.billing_profile()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_object_agg(key, value), '{}'::jsonb)
  from public.settings
  where key in ('gym_name', 'gym_phone', 'gym_address', 'upi_id', 'gstin',
                'gst_enabled', 'gst_inclusive', 'razorpay_enabled')
$$;
revoke execute on function public.billing_profile() from public, anon;
grant execute on function public.billing_profile() to authenticated;

-- ---------------------------------------------------------------------------
-- Sequential document numbers per financial year (April–March)
-- ---------------------------------------------------------------------------
create table public.doc_counters (
  kind text not null check (kind in ('invoice', 'receipt')),
  fy   text not null,
  last int  not null default 0,
  primary key (kind, fy)
);
alter table public.doc_counters enable row level security;

create or replace function public.fy_label(p_day date)
returns text
language sql
immutable
as $$
  select to_char(y, 'FM00') || '-' || to_char(y + 1, 'FM00')
  from (select (case when extract(month from p_day) >= 4 then extract(year from p_day)
                     else extract(year from p_day) - 1 end)::int % 100 as y) s
$$;

create or replace function public.next_doc_no(p_kind text, p_day date)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_fy  text := public.fy_label(p_day);
  v_n   int;
begin
  insert into public.doc_counters (kind, fy, last) values (p_kind, v_fy, 1)
  on conflict (kind, fy) do update set last = public.doc_counters.last + 1
  returning last into v_n;
  return case p_kind when 'invoice' then 'ABS/' else 'RCPT/' end || v_fy || '/' || lpad(v_n::text, 4, '0');
end;
$$;
revoke execute on function public.next_doc_no(text, date) from public, anon, authenticated;

-- GST on a net amount. Inclusive: taxable is backed out of the price.
-- Exclusive: GST is added on top. Returns {taxable, gst}.
create or replace function public.gst_split(p_net int, p_rate numeric, p_inclusive boolean)
returns table (taxable int, gst int)
language sql
immutable
as $$
  select case when p_rate <= 0 then p_net
              when p_inclusive then round(p_net * 100.0 / (100 + p_rate))::int
              else p_net end,
         case when p_rate <= 0 then 0
              when p_inclusive then p_net - round(p_net * 100.0 / (100 + p_rate))::int
              else round(p_net * p_rate / 100.0)::int end
$$;

-- ---------------------------------------------------------------------------
-- Members: dues snapshot (for list filter, check-in warning)
-- ---------------------------------------------------------------------------
alter table public.members add column if not exists dues_paise int not null default 0;

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
    or new.member_code is distinct from old.member_code
    or new.dues_paise is distinct from old.dues_paise) then
    raise exception 'computed member fields are read-only' using errcode = '42501';
  end if;
  return new;
end;
$$;

alter table public.member_events drop constraint if exists member_events_kind_check;
alter table public.member_events add constraint member_events_kind_check check (kind in (
  'joined','membership_started','renewed','frozen','unfrozen','cancelled','transferred_in','transferred_out',
  'note','profile_updated','pin_set','imported','archived','restored',
  'invoice_created','payment','payment_voided','refund','invoice_voided'));

-- ---------------------------------------------------------------------------
-- Invoices (2.1)
-- ---------------------------------------------------------------------------
create table public.invoices (
  id               uuid primary key default gen_random_uuid(),
  invoice_no       text not null unique,
  member_id        uuid references public.members (id) on delete set null,
  member_name      text not null,
  member_code      text not null,
  member_phone     text,
  membership_id    uuid references public.memberships (id) on delete set null,
  issue_date       date not null default public.ist_today(),
  due_date         date not null,
  next_due_date    date not null,
  subtotal_paise   int not null default 0 check (subtotal_paise >= 0),
  discount_paise   int not null default 0 check (discount_paise >= 0),
  discount_reason  text,
  taxable_paise    int not null default 0 check (taxable_paise >= 0),
  cgst_paise       int not null default 0 check (cgst_paise >= 0),
  sgst_paise       int not null default 0 check (sgst_paise >= 0),
  total_paise      int not null default 0 check (total_paise >= 0),
  paid_paise       int not null default 0,
  balance_paise    int generated always as (total_paise - paid_paise) stored,
  status           text not null default 'unpaid' check (status in ('unpaid', 'partial', 'paid', 'void')),
  overdue_days     int not null default 0,
  gateway_link_id  text,
  gateway_link_url text,
  notes            text,
  voided_reason    text,
  voided_at        timestamptz,
  voided_by        uuid,
  created_by       uuid,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  constraint invoice_paid_range check (paid_paise between 0 and total_paise),
  constraint invoice_void_unpaid check (status <> 'void' or paid_paise = 0)
);
create trigger invoices_touch before update on public.invoices
  for each row execute function public.touch_updated_at();
create index invoices_status_due on public.invoices (status, next_due_date);
create index invoices_member on public.invoices (member_id, issue_date desc);
create index invoices_membership on public.invoices (membership_id);

create table public.invoice_items (
  id             uuid primary key default gen_random_uuid(),
  invoice_id     uuid not null references public.invoices (id) on delete cascade,
  position       int not null,
  kind           text not null default 'other' check (kind in ('plan', 'joining_fee', 'addon', 'other')),
  description    text not null,
  qty            int not null default 1 check (qty > 0),
  unit_paise     int not null check (unit_paise >= 0),
  gross_paise    int not null check (gross_paise >= 0),
  discount_paise int not null default 0 check (discount_paise >= 0),
  net_paise      int not null check (net_paise >= 0),
  gst_rate       numeric(4, 2) not null default 0,
  taxable_paise  int not null default 0,
  gst_paise      int not null default 0
);
create index invoice_items_invoice on public.invoice_items (invoice_id, position);

-- Instalments (2.6): up to 4, amounts add up to the invoice total.
create table public.instalments (
  id           uuid primary key default gen_random_uuid(),
  invoice_id   uuid not null references public.invoices (id) on delete cascade,
  seq          int not null check (seq between 1 and 4),
  due_date     date not null,
  amount_paise int not null check (amount_paise > 0),
  status       text not null default 'due' check (status in ('due', 'paid')),
  unique (invoice_id, seq)
);

-- ---------------------------------------------------------------------------
-- Payments (2.2), credits, refunds (2.11)
-- ---------------------------------------------------------------------------
create table public.payments (
  id                 uuid primary key default gen_random_uuid(),
  receipt_no         text unique,
  invoice_id         uuid references public.invoices (id) on delete restrict,
  member_id          uuid references public.members (id) on delete set null,
  member_name        text not null,
  amount_paise       int not null check (amount_paise > 0),
  applied_paise      int not null default 0,
  refunded_paise     int not null default 0,
  mode               text not null check (mode in ('cash', 'upi', 'card', 'bank', 'online', 'credit')),
  utr                text,
  paid_at            timestamptz not null default now(),
  paid_on            date not null default public.ist_today(),
  collected_by       uuid references public.staff (id) on delete set null,
  status             text not null default 'confirmed'
                       check (status in ('confirmed', 'pending_verification', 'rejected', 'voided')),
  gateway_event_id   text unique,
  gateway_payment_id text,
  note               text,
  voided_reason      text,
  voided_at          timestamptz,
  voided_by          uuid,
  created_by         uuid,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  constraint payment_applied check (applied_paise between 0 and amount_paise),
  constraint payment_refunded check (refunded_paise between 0 and applied_paise)
);
create trigger payments_touch before update on public.payments
  for each row execute function public.touch_updated_at();
create index payments_paid_at on public.payments (paid_at);
create index payments_day_staff on public.payments (paid_on, collected_by) where status = 'confirmed';
create index payments_invoice on public.payments (invoice_id);
create index payments_member on public.payments (member_id, paid_at desc);
create index payments_pending on public.payments (status) where status = 'pending_verification';

create table public.member_credits (
  id           uuid primary key default gen_random_uuid(),
  member_id    uuid references public.members (id) on delete cascade,
  amount_paise int not null check (amount_paise <> 0),
  reason       text not null,
  payment_id   uuid references public.payments (id) on delete set null,
  invoice_id   uuid references public.invoices (id) on delete set null,
  created_by   uuid,
  created_at   timestamptz not null default now()
);
create index member_credits_member on public.member_credits (member_id);

create table public.refunds (
  id           uuid primary key default gen_random_uuid(),
  payment_id   uuid not null references public.payments (id) on delete restrict,
  amount_paise int not null check (amount_paise > 0),
  mode         text not null check (mode in ('cash', 'upi', 'card', 'bank', 'online')),
  reason       text not null,
  refunded_on  date not null default public.ist_today(),
  created_by   uuid,
  created_at   timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Expenses (2.12) and day close (2.13)
-- ---------------------------------------------------------------------------
create table public.expenses (
  id           uuid primary key default gen_random_uuid(),
  category     text not null check (category in
                 ('rent', 'salaries', 'electricity', 'equipment', 'maintenance', 'marketing', 'supplies', 'other')),
  amount_paise int not null check (amount_paise > 0),
  spent_on     date not null default public.ist_today(),
  note         text,
  created_by   uuid,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create trigger expenses_touch before update on public.expenses
  for each row execute function public.touch_updated_at();
create index expenses_spent_on on public.expenses (spent_on desc);

create table public.day_closes (
  id                 uuid primary key default gen_random_uuid(),
  staff_id           uuid not null references public.staff (id) on delete cascade,
  day                date not null,
  cash_paise         int not null default 0,
  upi_paise          int not null default 0,
  card_paise         int not null default 0,
  bank_paise         int not null default 0,
  online_paise       int not null default 0,
  credit_paise       int not null default 0,
  total_paise        int not null default 0,
  payments_count     int not null default 0,
  counted_cash_paise int not null default 0,
  difference_paise   int not null default 0,
  note               text,
  closed_at          timestamptz not null default now(),
  reopened_at        timestamptz,
  unique (staff_id, day)
);

-- A staff member's day is locked once closed (until the owner reopens it).
create or replace function public.day_is_closed(p_staff_id uuid, p_day date)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.day_closes
                 where staff_id = p_staff_id and day = p_day and reopened_at is null)
$$;

-- ---------------------------------------------------------------------------
-- Invoice engine: paid amount, status, next due date, overdue days, dues
-- ---------------------------------------------------------------------------
create or replace function public.refresh_invoice(p_invoice_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv    public.invoices%rowtype;
  v_paid   int;
  v_next   date;
  v_today  date := public.ist_today();
  v_status text;
begin
  select * into v_inv from public.invoices where id = p_invoice_id for update;
  if not found then return; end if;

  select coalesce(sum(applied_paise - refunded_paise), 0) into v_paid
  from public.payments where invoice_id = p_invoice_id and status = 'confirmed';

  -- Instalments are paid in order as money comes in.
  update public.instalments i
     set status = case when (select sum(amount_paise) from public.instalments j
                             where j.invoice_id = i.invoice_id and j.seq <= i.seq) <= v_paid
                       then 'paid' else 'due' end
   where i.invoice_id = p_invoice_id;
  select min(due_date) into v_next from public.instalments where invoice_id = p_invoice_id and status = 'due';
  v_next := coalesce(v_next, v_inv.due_date);

  v_status := case
    when v_inv.status = 'void' then 'void'
    when v_paid >= v_inv.total_paise then 'paid'
    when v_paid > 0 then 'partial'
    else 'unpaid' end;

  update public.invoices
     set paid_paise = v_paid,
         status = v_status,
         next_due_date = v_next,
         overdue_days = case when v_status in ('unpaid', 'partial') then greatest(v_today - v_next, 0) else 0 end
   where id = p_invoice_id;

  if v_inv.member_id is not null then
    update public.members m
       set dues_paise = coalesce((select sum(balance_paise) from public.invoices
                                  where member_id = m.id and status in ('unpaid', 'partial')), 0)
     where m.id = v_inv.member_id;
  end if;
end;
$$;
revoke execute on function public.refresh_invoice(uuid) from public, anon, authenticated;

create or replace function public.payments_changed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op in ('UPDATE', 'DELETE') and old.invoice_id is not null then
    perform public.refresh_invoice(old.invoice_id);
  end if;
  if tg_op in ('INSERT', 'UPDATE') and new.invoice_id is not null
     and (tg_op = 'INSERT' or new.invoice_id is distinct from old.invoice_id
          or new.status is distinct from old.status or new.applied_paise is distinct from old.applied_paise
          or new.refunded_paise is distinct from old.refunded_paise) then
    perform public.refresh_invoice(new.invoice_id);
  end if;
  return null;
end;
$$;
create trigger payments_refresh after insert or update or delete on public.payments
  for each row execute function public.payments_changed();

create or replace function public.instalments_changed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if pg_trigger_depth() > 1 then return null; end if;  -- refresh_invoice updates statuses itself
  perform public.refresh_invoice(coalesce(new.invoice_id, old.invoice_id));
  return null;
end;
$$;
create trigger instalments_refresh after insert or delete on public.instalments
  for each row execute function public.instalments_changed();

-- Belt and braces: whatever happens, paid = sum of confirmed payments.
create or replace function public.invoices_check_paid()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_sum int;
begin
  select coalesce(sum(applied_paise - refunded_paise), 0) into v_sum
  from public.payments where invoice_id = new.id and status = 'confirmed';
  if v_sum <> new.paid_paise then
    raise exception 'invoice % paid (%) does not match its payments (%)', new.invoice_no, new.paid_paise, v_sum
      using errcode = '23514';
  end if;
  return null;
end;
$$;
create constraint trigger invoices_paid_matches after insert or update on public.invoices
  deferrable initially deferred
  for each row execute function public.invoices_check_paid();

-- API roles never write money columns directly; everything goes through RPCs.
create or replace function public.money_guard()
returns trigger
language plpgsql
as $$
begin
  if current_user in ('authenticated', 'anon') then
    raise exception '% can only be changed through the app''s payment actions', tg_table_name using errcode = '42501';
  end if;
  return coalesce(new, old);
end;
$$;
create trigger invoices_guard before insert or update or delete on public.invoices
  for each row execute function public.money_guard();
create trigger invoice_items_guard before insert or update or delete on public.invoice_items
  for each row execute function public.money_guard();
create trigger instalments_guard before insert or update or delete on public.instalments
  for each row execute function public.money_guard();
create trigger payments_guard before insert or update or delete on public.payments
  for each row execute function public.money_guard();
create trigger member_credits_guard before insert or update or delete on public.member_credits
  for each row execute function public.money_guard();
create trigger refunds_guard before insert or update or delete on public.refunds
  for each row execute function public.money_guard();
create trigger day_closes_guard before insert or update or delete on public.day_closes
  for each row execute function public.money_guard();

-- Every change on money tables is written to the audit log (old and new).
create trigger invoices_audit after insert or update or delete on public.invoices
  for each row execute function public.audit_row_change();
create trigger invoice_items_audit after insert or update or delete on public.invoice_items
  for each row execute function public.audit_row_change();
create trigger instalments_audit after insert or update or delete on public.instalments
  for each row execute function public.audit_row_change();
create trigger payments_audit after insert or update or delete on public.payments
  for each row execute function public.audit_row_change();
create trigger member_credits_audit after insert or update or delete on public.member_credits
  for each row execute function public.audit_row_change();
create trigger refunds_audit after insert or update or delete on public.refunds
  for each row execute function public.audit_row_change();
create trigger expenses_audit after insert or update or delete on public.expenses
  for each row execute function public.audit_row_change();
create trigger day_closes_audit after insert or update or delete on public.day_closes
  for each row execute function public.audit_row_change();

-- ---------------------------------------------------------------------------
-- Building invoices
-- ---------------------------------------------------------------------------
-- p_lines: [{kind, description, qty, unit_paise, gst_rate}]; the discount is
-- taken off the lines in order (plan first).
create or replace function public._create_invoice(
  p_member_id uuid, p_membership_id uuid, p_lines jsonb, p_discount_paise int, p_discount_reason text, p_due date)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member    public.members%rowtype;
  v_id        uuid;
  v_line      jsonb;
  v_pos       int := 0;
  v_left      int := greatest(coalesce(p_discount_paise, 0), 0);
  v_gross     int;
  v_disc      int;
  v_net       int;
  v_rate      numeric;
  v_split     record;
  v_inclusive boolean := public.setting_bool('gst_inclusive', true);
  v_gst_on    boolean := public.setting_bool('gst_enabled', false);
  v_today     date := public.ist_today();
  v_sub int := 0; v_dsum int := 0; v_tax int := 0; v_gst int := 0; v_total int := 0;
begin
  select * into v_member from public.members where id = p_member_id;
  if not found then raise exception 'member not found' using errcode = 'P0002'; end if;
  if jsonb_typeof(p_lines) <> 'array' or jsonb_array_length(p_lines) = 0 then
    raise exception 'an invoice needs at least one line' using errcode = '22023';
  end if;

  insert into public.invoices (invoice_no, member_id, member_name, member_code, member_phone, membership_id,
                               issue_date, due_date, next_due_date, discount_reason, created_by)
  values (public.next_doc_no('invoice', v_today), p_member_id, v_member.name, v_member.member_code, v_member.phone,
          p_membership_id, v_today, greatest(coalesce(p_due, v_today), v_today),
          greatest(coalesce(p_due, v_today), v_today), nullif(trim(p_discount_reason), ''), auth.uid())
  returning id into v_id;

  for v_line in select * from jsonb_array_elements(p_lines) loop
    v_pos := v_pos + 1;
    v_gross := coalesce((v_line->>'qty')::int, 1) * (v_line->>'unit_paise')::int;
    if v_gross < 0 then raise exception 'line amounts cannot be negative' using errcode = '22023'; end if;
    v_disc := least(v_left, v_gross);
    v_left := v_left - v_disc;
    v_net := v_gross - v_disc;
    v_rate := case when v_gst_on then coalesce((v_line->>'gst_rate')::numeric, 0) else 0 end;
    select * into v_split from public.gst_split(v_net, v_rate, v_inclusive);
    insert into public.invoice_items (invoice_id, position, kind, description, qty, unit_paise, gross_paise,
                                      discount_paise, net_paise, gst_rate, taxable_paise, gst_paise)
    values (v_id, v_pos, coalesce(v_line->>'kind', 'other'), v_line->>'description', coalesce((v_line->>'qty')::int, 1),
            (v_line->>'unit_paise')::int, v_gross, v_disc, v_net, v_rate, v_split.taxable, v_split.gst);
    v_sub := v_sub + v_gross;
    v_dsum := v_dsum + v_disc;
    v_tax := v_tax + v_split.taxable;
    v_gst := v_gst + v_split.gst;
    v_total := v_total + v_split.taxable + v_split.gst;
  end loop;
  if v_left > 0 then raise exception 'discount is more than the invoice' using errcode = '22023'; end if;

  update public.invoices
     set subtotal_paise = v_sub, discount_paise = v_dsum, taxable_paise = v_tax,
         cgst_paise = v_gst / 2, sgst_paise = v_gst - v_gst / 2, total_paise = v_total
   where id = v_id;
  perform public.refresh_invoice(v_id);
  perform public.log_member_event(p_member_id, 'invoice_created',
    (select invoice_no || ' · ₹' || to_char(total_paise / 100.0, 'FM99G99G99G990D00') from public.invoices where id = v_id),
    jsonb_build_object('invoice_id', v_id));
  return v_id;
end;
$$;
revoke execute on function public._create_invoice(uuid, uuid, jsonb, int, text, date) from public, anon, authenticated;

-- Invoice from a membership's price snapshot (start / renewal), at the end of
-- the transaction so add-on rows already exist.
create or replace function public.invoice_for_membership()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lines jsonb;
  v_rate  numeric;
begin
  if new.source not in ('new', 'renewal') then return null; end if;
  if new.price_paise + new.joining_fee_paise + new.addons_paise = 0 then return null; end if;
  if exists (select 1 from public.invoices where membership_id = new.id) then return null; end if;
  select gst_rate into v_rate from public.plans where id = new.plan_id;
  v_lines := jsonb_build_array(jsonb_build_object(
    'kind', 'plan', 'description', new.plan_name || ' (' || to_char(new.start_date, 'DD Mon YYYY') || ' – '
                                    || to_char(new.end_date, 'DD Mon YYYY') || ')',
    'unit_paise', new.price_paise, 'gst_rate', v_rate));
  if new.joining_fee_paise > 0 then
    v_lines := v_lines || jsonb_build_object('kind', 'joining_fee', 'description', 'Joining fee',
                                              'unit_paise', new.joining_fee_paise, 'gst_rate', v_rate);
  end if;
  v_lines := v_lines || coalesce((select jsonb_agg(jsonb_build_object('kind', 'addon', 'description', name,
                                   'unit_paise', price_paise, 'gst_rate', v_rate))
                                  from public.membership_addons where membership_id = new.id), '[]'::jsonb);
  perform public._create_invoice(new.member_id, new.id, v_lines, new.discount_paise, new.discount_reason,
                                 greatest(new.start_date, public.ist_today()));
  return null;
end;
$$;
create constraint trigger memberships_invoice after insert on public.memberships
  deferrable initially deferred
  for each row execute function public.invoice_for_membership();

-- Ad-hoc invoice (add-on bought later, PT pack, merchandise).
create or replace function public.create_invoice(
  p_member_id uuid, p_lines jsonb, p_due_date date default null,
  p_discount_paise int default 0, p_discount_reason text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if coalesce(p_discount_paise, 0) > 0 and coalesce(trim(p_discount_reason), '') = '' then
    raise exception 'a discount needs a reason' using errcode = '22023';
  end if;
  return public._create_invoice(p_member_id, null, p_lines, p_discount_paise, p_discount_reason, p_due_date);
end;
$$;

-- Split an open invoice into up to 4 dated instalments (2.6). An empty plan
-- removes the split.
create or replace function public.set_instalments(p_invoice_id uuid, p_plan jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv  public.invoices%rowtype;
  v_sum  int;
  v_n    int := coalesce(jsonb_array_length(p_plan), 0);
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_inv from public.invoices where id = p_invoice_id;
  if not found then raise exception 'invoice not found' using errcode = 'P0002'; end if;
  if v_inv.status in ('paid', 'void') then raise exception 'this invoice is already %', v_inv.status using errcode = '22023'; end if;
  if v_n > 4 then raise exception 'at most 4 instalments' using errcode = '22023'; end if;

  delete from public.instalments where invoice_id = p_invoice_id;
  if v_n > 0 then
    select sum((e->>'amount_paise')::int) into v_sum from jsonb_array_elements(p_plan) e;
    if v_sum <> v_inv.total_paise then
      raise exception 'instalments must add up to the invoice total' using errcode = '22023';
    end if;
    if exists (select 1 from jsonb_array_elements(p_plan) with ordinality a(e, i)
               join jsonb_array_elements(p_plan) with ordinality b(e, i) on b.i = a.i + 1
               where (b.e->>'due_date')::date <= (a.e->>'due_date')::date) then
      raise exception 'instalment dates must be in order' using errcode = '22023';
    end if;
    insert into public.instalments (invoice_id, seq, due_date, amount_paise)
    select p_invoice_id, i, (e->>'due_date')::date, (e->>'amount_paise')::int
    from jsonb_array_elements(p_plan) with ordinality t(e, i);
  end if;
  perform public.refresh_invoice(p_invoice_id);
end;
$$;

-- ---------------------------------------------------------------------------
-- Collecting money
-- ---------------------------------------------------------------------------
create or replace function public._record_payment(
  p_invoice public.invoices, p_amount int, p_mode text, p_utr text, p_paid_on date,
  p_staff uuid, p_status text, p_note text, p_event text default null, p_gateway_payment text default null)
returns public.payments
language plpgsql
security definer
set search_path = public
as $$
declare
  v_applied int := least(p_amount, p_invoice.balance_paise);
  v_row     public.payments%rowtype;
begin
  insert into public.payments (receipt_no, invoice_id, member_id, member_name, amount_paise, applied_paise, mode, utr,
                               paid_on, collected_by, status, note, gateway_event_id, gateway_payment_id, created_by)
  values (case when p_status = 'confirmed' then public.next_doc_no('receipt', p_paid_on) end,
          p_invoice.id, p_invoice.member_id, p_invoice.member_name, p_amount,
          case when p_status = 'confirmed' then v_applied else 0 end, p_mode, nullif(trim(p_utr), ''), p_paid_on,
          p_staff, p_status, nullif(trim(p_note), ''), p_event, p_gateway_payment, auth.uid())
  returning * into v_row;

  -- Overpayment becomes member credit (2.2).
  if p_status = 'confirmed' and p_amount > v_applied and p_mode <> 'credit' and p_invoice.member_id is not null then
    insert into public.member_credits (member_id, amount_paise, reason, payment_id, invoice_id, created_by)
    values (p_invoice.member_id, p_amount - v_applied, 'Overpayment on ' || p_invoice.invoice_no, v_row.id, p_invoice.id, auth.uid());
  end if;
  if p_status = 'confirmed' and p_invoice.member_id is not null then
    perform public.log_member_event(p_invoice.member_id, 'payment',
      '₹' || to_char(p_amount / 100.0, 'FM99G99G99G990D00') || ' received (' || p_mode || ') · ' || v_row.receipt_no,
      jsonb_build_object('payment_id', v_row.id, 'invoice_id', p_invoice.id));
  end if;
  return v_row;
end;
$$;
revoke execute on function public._record_payment(public.invoices, int, text, text, date, uuid, text, text, text, text)
  from public, anon, authenticated;

create or replace function public._payment_result(p public.payments)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'payment_id', p.id, 'receipt_no', p.receipt_no, 'amount_paise', p.amount_paise, 'applied_paise', p.applied_paise,
    'credit_paise', case when p.mode = 'credit' then 0 else p.amount_paise - p.applied_paise end,
    'balance_paise', (select balance_paise from public.invoices where id = p.invoice_id),
    'status', p.status)
$$;
revoke execute on function public._payment_result(public.payments) from public, anon, authenticated;

create or replace function public.collect_payment(
  p_invoice_id uuid, p_amount_paise int, p_mode text, p_utr text default null,
  p_paid_on date default null, p_note text default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_staff uuid := public.auth_staff_id();
  v_day   date := coalesce(p_paid_on, public.ist_today());
  v_inv   public.invoices%rowtype;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if p_mode not in ('cash', 'upi', 'card', 'bank') then raise exception 'unknown payment mode' using errcode = '22023'; end if;
  if p_amount_paise is null or p_amount_paise <= 0 then raise exception 'amount must be more than zero' using errcode = '22023'; end if;
  if p_amount_paise > 100000000 then raise exception 'amount looks too large' using errcode = '22023'; end if;
  if p_mode in ('upi', 'bank') and coalesce(length(trim(p_utr)), 0) < 6 then
    raise exception 'enter the UPI / bank reference (UTR)' using errcode = '22023';
  end if;
  if v_day > public.ist_today() or v_day < public.ist_today() - 30 then
    raise exception 'payment date must be within the last 30 days' using errcode = '22023';
  end if;
  if public.day_is_closed(v_staff, v_day) and not public.is_owner() then
    raise exception 'your day is closed; ask the owner to reopen it' using errcode = '22023';
  end if;
  select * into v_inv from public.invoices where id = p_invoice_id for update;
  if not found then raise exception 'invoice not found' using errcode = 'P0002'; end if;
  if v_inv.status = 'void' then raise exception 'this invoice is void' using errcode = '22023'; end if;
  if v_inv.balance_paise <= 0 then raise exception 'this invoice is already paid' using errcode = '22023'; end if;

  return public._payment_result(public._record_payment(v_inv, p_amount_paise, p_mode, p_utr, v_day, v_staff,
                                                       'confirmed', p_note));
end;
$$;

create or replace function public.member_credit_balance(p_member_id uuid)
returns int
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not (public.is_desk() or p_member_id = public.auth_member_id()) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  return coalesce((select sum(amount_paise) from public.member_credits where member_id = p_member_id), 0);
end;
$$;

-- Pay (part of) an invoice from the member's credit balance.
create or replace function public.apply_credit(p_invoice_id uuid, p_amount_paise int)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv    public.invoices%rowtype;
  v_credit int;
  v_row    public.payments%rowtype;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_inv from public.invoices where id = p_invoice_id for update;
  if not found or v_inv.status = 'void' then raise exception 'invoice not found' using errcode = 'P0002'; end if;
  select coalesce(sum(amount_paise), 0) into v_credit from public.member_credits where member_id = v_inv.member_id;
  if p_amount_paise <= 0 or p_amount_paise > least(v_credit, v_inv.balance_paise) then
    raise exception 'only ₹% of credit can be used here', to_char(least(v_credit, v_inv.balance_paise) / 100.0, 'FM99G99G990D00')
      using errcode = '22023';
  end if;
  v_row := public._record_payment(v_inv, p_amount_paise, 'credit', null, public.ist_today(), public.auth_staff_id(),
                                  'confirmed', 'Paid from credit');
  insert into public.member_credits (member_id, amount_paise, reason, payment_id, invoice_id, created_by)
  values (v_inv.member_id, -p_amount_paise, 'Used on ' || v_inv.invoice_no, v_row.id, v_inv.id, auth.uid());
  return public._payment_result(v_row);
end;
$$;

-- Member self-pay (2.5): "I've paid" with the UPI reference; waits for staff.
create or replace function public.claim_payment(p_invoice_id uuid, p_amount_paise int, p_utr text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv public.invoices%rowtype;
  v_row public.payments%rowtype;
begin
  if coalesce(public.auth_role(), '') <> 'member' then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_inv from public.invoices where id = p_invoice_id and member_id = public.auth_member_id();
  if not found then raise exception 'invoice not found' using errcode = 'P0002'; end if;
  if v_inv.status in ('paid', 'void') then raise exception 'this invoice is already %', v_inv.status using errcode = '22023'; end if;
  if p_amount_paise is null or p_amount_paise <= 0 or p_amount_paise > v_inv.balance_paise then
    raise exception 'amount must be between ₹1 and the amount due' using errcode = '22023';
  end if;
  if coalesce(trim(p_utr), '') !~ '^[A-Za-z0-9]{6,30}$' then
    raise exception 'enter the UPI reference (UTR) from your payment app' using errcode = '22023';
  end if;
  if exists (select 1 from public.payments where utr = trim(p_utr) and status in ('pending_verification', 'confirmed')) then
    raise exception 'this reference was already used' using errcode = '23505';
  end if;
  v_row := public._record_payment(v_inv, p_amount_paise, 'upi', p_utr, public.ist_today(), null,
                                  'pending_verification', 'Member self-pay');
  return v_row.id;
end;
$$;

create or replace function public.verify_payment(p_payment_id uuid, p_approve boolean, p_reason text default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pay     public.payments%rowtype;
  v_inv     public.invoices%rowtype;
  v_applied int;
  v_staff   uuid := public.auth_staff_id();
  v_today   date := public.ist_today();
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_pay from public.payments where id = p_payment_id and status = 'pending_verification' for update;
  if not found then raise exception 'no pending payment to verify' using errcode = 'P0002'; end if;

  if not p_approve then
    if coalesce(trim(p_reason), '') = '' then raise exception 'a reason is required' using errcode = '22023'; end if;
    update public.payments set status = 'rejected', voided_reason = trim(p_reason), voided_at = now(), voided_by = auth.uid()
     where id = v_pay.id returning * into v_pay;
    return public._payment_result(v_pay);
  end if;

  if public.day_is_closed(v_staff, v_today) and not public.is_owner() then
    raise exception 'your day is closed; ask the owner to reopen it' using errcode = '22023';
  end if;
  select * into v_inv from public.invoices where id = v_pay.invoice_id for update;
  v_applied := least(v_pay.amount_paise, greatest(v_inv.balance_paise, 0));
  update public.payments
     set status = 'confirmed', applied_paise = v_applied, collected_by = v_staff, paid_on = v_today,
         receipt_no = public.next_doc_no('receipt', v_today)
   where id = v_pay.id
  returning * into v_pay;
  if v_pay.amount_paise > v_applied and v_inv.member_id is not null then
    insert into public.member_credits (member_id, amount_paise, reason, payment_id, invoice_id, created_by)
    values (v_inv.member_id, v_pay.amount_paise - v_applied, 'Overpayment on ' || v_inv.invoice_no, v_pay.id, v_inv.id, auth.uid());
  end if;
  if v_inv.member_id is not null then
    perform public.log_member_event(v_inv.member_id, 'payment',
      '₹' || to_char(v_pay.amount_paise / 100.0, 'FM99G99G99G990D00') || ' received (upi, verified) · ' || v_pay.receipt_no,
      jsonb_build_object('payment_id', v_pay.id, 'invoice_id', v_inv.id));
  end if;
  return public._payment_result(v_pay);
end;
$$;

-- Razorpay webhook (service role only); idempotent on the event id.
create or replace function public.record_gateway_payment(
  p_invoice_id uuid, p_amount_paise int, p_event_id text, p_gateway_payment_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv public.invoices%rowtype;
  v_row public.payments%rowtype;
begin
  if exists (select 1 from public.payments where gateway_event_id = p_event_id) then
    return jsonb_build_object('duplicate', true);
  end if;
  select * into v_inv from public.invoices where id = p_invoice_id for update;
  if not found or v_inv.status = 'void' then raise exception 'invoice not found' using errcode = 'P0002'; end if;
  if v_inv.balance_paise <= 0 then
    -- Paid some other way meanwhile: keep the money as member credit.
    v_inv.balance_paise := 0;
  end if;
  v_row := public._record_payment(v_inv, p_amount_paise, 'online', p_gateway_payment_id, public.ist_today(), null,
                                  'confirmed', 'Razorpay', p_event_id, p_gateway_payment_id);
  return jsonb_build_object('duplicate', false) || public._payment_result(v_row);
end;
$$;
revoke execute on function public.record_gateway_payment(uuid, int, text, text) from public, anon, authenticated;
grant execute on function public.record_gateway_payment(uuid, int, text, text) to service_role;

create or replace function public.set_gateway_link(p_invoice_id uuid, p_link_id text, p_url text)
returns void
language sql
security definer
set search_path = public
as $$
  update public.invoices set gateway_link_id = p_link_id, gateway_link_url = p_url where id = p_invoice_id
$$;
revoke execute on function public.set_gateway_link(uuid, text, text) from public, anon, authenticated;
grant execute on function public.set_gateway_link(uuid, text, text) to service_role;

-- ---------------------------------------------------------------------------
-- Voids and refunds (2.11): owner only, reason required, never deleted
-- ---------------------------------------------------------------------------
create or replace function public.void_payment(p_payment_id uuid, p_reason text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pay public.payments%rowtype;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  if coalesce(trim(p_reason), '') = '' then raise exception 'a reason is required' using errcode = '22023'; end if;
  select * into v_pay from public.payments where id = p_payment_id and status = 'confirmed' for update;
  if not found then raise exception 'payment not found or not confirmed' using errcode = 'P0002'; end if;
  if v_pay.refunded_paise > 0 then raise exception 'this payment has refunds; it cannot be voided' using errcode = '22023'; end if;

  update public.payments set status = 'voided', voided_reason = trim(p_reason), voided_at = now(), voided_by = auth.uid()
   where id = v_pay.id;
  -- Undo the credit side effects.
  if v_pay.mode = 'credit' then
    insert into public.member_credits (member_id, amount_paise, reason, payment_id, invoice_id, created_by)
    values (v_pay.member_id, v_pay.applied_paise, 'Credit returned (void)', v_pay.id, v_pay.invoice_id, auth.uid());
  elsif v_pay.amount_paise > v_pay.applied_paise then
    insert into public.member_credits (member_id, amount_paise, reason, payment_id, invoice_id, created_by)
    values (v_pay.member_id, -(v_pay.amount_paise - v_pay.applied_paise), 'Overpayment reversed (void)', v_pay.id,
            v_pay.invoice_id, auth.uid());
  end if;
  if v_pay.member_id is not null then
    perform public.log_member_event(v_pay.member_id, 'payment_voided', 'Payment ' || v_pay.receipt_no || ' voided',
      jsonb_build_object('payment_id', v_pay.id, 'reason', p_reason));
  end if;
end;
$$;

create or replace function public.refund_payment(p_payment_id uuid, p_amount_paise int, p_mode text, p_reason text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pay public.payments%rowtype;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  if coalesce(trim(p_reason), '') = '' then raise exception 'a reason is required' using errcode = '22023'; end if;
  select * into v_pay from public.payments where id = p_payment_id and status = 'confirmed' for update;
  if not found then raise exception 'payment not found or not confirmed' using errcode = 'P0002'; end if;
  if p_amount_paise <= 0 or p_amount_paise > v_pay.applied_paise - v_pay.refunded_paise then
    raise exception 'refund can be at most ₹%', to_char((v_pay.applied_paise - v_pay.refunded_paise) / 100.0, 'FM99G99G990D00')
      using errcode = '22023';
  end if;
  insert into public.refunds (payment_id, amount_paise, mode, reason, created_by)
  values (v_pay.id, p_amount_paise, p_mode, trim(p_reason), auth.uid());
  update public.payments set refunded_paise = refunded_paise + p_amount_paise where id = v_pay.id;
  if v_pay.member_id is not null then
    perform public.log_member_event(v_pay.member_id, 'refund',
      '₹' || to_char(p_amount_paise / 100.0, 'FM99G99G99G990D00') || ' refunded on ' || v_pay.receipt_no,
      jsonb_build_object('payment_id', v_pay.id, 'reason', p_reason));
  end if;
end;
$$;

create or replace function public.void_invoice(p_invoice_id uuid, p_reason text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv public.invoices%rowtype;
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  if coalesce(trim(p_reason), '') = '' then raise exception 'a reason is required' using errcode = '22023'; end if;
  select * into v_inv from public.invoices where id = p_invoice_id for update;
  if not found or v_inv.status = 'void' then raise exception 'invoice not found or already void' using errcode = 'P0002'; end if;
  if v_inv.paid_paise > 0 then
    raise exception 'void or refund its payments first' using errcode = '22023';
  end if;
  update public.payments set status = 'rejected', voided_reason = 'Invoice voided', voided_at = now(), voided_by = auth.uid()
   where invoice_id = p_invoice_id and status = 'pending_verification';
  delete from public.instalments where invoice_id = p_invoice_id;
  update public.invoices set status = 'void', voided_reason = trim(p_reason), voided_at = now(), voided_by = auth.uid(),
                             overdue_days = 0
   where id = p_invoice_id;
  perform public.refresh_invoice(p_invoice_id);
  if v_inv.member_id is not null then
    perform public.log_member_event(v_inv.member_id, 'invoice_voided', v_inv.invoice_no || ' voided',
      jsonb_build_object('invoice_id', v_inv.id, 'reason', p_reason));
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- Day close (2.13)
-- ---------------------------------------------------------------------------
create or replace function public._day_totals(p_staff uuid, p_day date)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'cash', coalesce(sum(amount_paise) filter (where mode = 'cash'), 0),
    'upi', coalesce(sum(amount_paise) filter (where mode = 'upi'), 0),
    'card', coalesce(sum(amount_paise) filter (where mode = 'card'), 0),
    'bank', coalesce(sum(amount_paise) filter (where mode = 'bank'), 0),
    'online', coalesce(sum(amount_paise) filter (where mode = 'online'), 0),
    'credit', coalesce(sum(amount_paise) filter (where mode = 'credit'), 0),
    'total', coalesce(sum(amount_paise) filter (where mode <> 'credit'), 0),
    'count', count(*))
  from public.payments
  where status = 'confirmed' and paid_on = p_day and (p_staff is null or collected_by = p_staff)
$$;
revoke execute on function public._day_totals(uuid, date) from public, anon, authenticated;

-- Desk: own totals; owner: anyone's (null = whole gym).
create or replace function public.day_summary(p_day date default null, p_staff_id uuid default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_day   date := coalesce(p_day, public.ist_today());
  v_staff uuid := coalesce(p_staff_id, public.auth_staff_id());
  v_close public.day_closes%rowtype;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if not public.is_owner() and v_staff <> public.auth_staff_id() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_close from public.day_closes where staff_id = v_staff and day = v_day;
  return public._day_totals(v_staff, v_day) || jsonb_build_object(
    'day', v_day, 'closed', v_close.id is not null and v_close.reopened_at is null,
    'closed_at', v_close.closed_at, 'counted_cash', v_close.counted_cash_paise, 'difference', v_close.difference_paise);
end;
$$;

create or replace function public.close_day(p_counted_cash_paise int, p_note text default null, p_day date default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_staff  uuid := public.auth_staff_id();
  v_day    date := coalesce(p_day, public.ist_today());
  v_t      jsonb;
begin
  if not public.is_desk() then raise exception 'not allowed' using errcode = '42501'; end if;
  if v_day > public.ist_today() then raise exception 'you can only close today or an earlier day' using errcode = '22023'; end if;
  if public.day_is_closed(v_staff, v_day) then raise exception 'this day is already closed' using errcode = '22023'; end if;
  if p_counted_cash_paise is null or p_counted_cash_paise < 0 then
    raise exception 'enter the cash you counted' using errcode = '22023';
  end if;
  v_t := public._day_totals(v_staff, v_day);
  insert into public.day_closes (staff_id, day, cash_paise, upi_paise, card_paise, bank_paise, online_paise, credit_paise,
                                 total_paise, payments_count, counted_cash_paise, difference_paise, note)
  values (v_staff, v_day, (v_t->>'cash')::int, (v_t->>'upi')::int, (v_t->>'card')::int, (v_t->>'bank')::int,
          (v_t->>'online')::int, (v_t->>'credit')::int, (v_t->>'total')::int, (v_t->>'count')::int,
          p_counted_cash_paise, p_counted_cash_paise - (v_t->>'cash')::int, nullif(trim(p_note), ''))
  on conflict (staff_id, day) do update
    set cash_paise = excluded.cash_paise, upi_paise = excluded.upi_paise, card_paise = excluded.card_paise,
        bank_paise = excluded.bank_paise, online_paise = excluded.online_paise, credit_paise = excluded.credit_paise,
        total_paise = excluded.total_paise, payments_count = excluded.payments_count,
        counted_cash_paise = excluded.counted_cash_paise, difference_paise = excluded.difference_paise,
        note = excluded.note, closed_at = now(), reopened_at = null;
  return public.day_summary(v_day);
end;
$$;

create or replace function public.reopen_day(p_day_close_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  update public.day_closes set reopened_at = now() where id = p_day_close_id and reopened_at is null;
  if not found then raise exception 'day close not found or already open' using errcode = 'P0002'; end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- Dues engine (2.8), reminders (2.9) and summaries (2.14)
-- ---------------------------------------------------------------------------
create or replace function public.refresh_dues()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_n  int := 0;
begin
  for v_id in select id from public.invoices where status in ('unpaid', 'partial') loop
    perform public.refresh_invoice(v_id);
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;
revoke execute on function public.refresh_dues() from public, anon, authenticated;

-- Reminder offsets from settings (readable by desk through this helper).
create or replace function public.due_reminder_days()
returns int[]
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select array(select (jsonb_array_elements_text(value))::int)
                   from public.settings where key = 'due_reminder_days'), array[3, 0, -3, -7])
$$;

-- Invoices whose reminder falls today (3 days before, on the day, 3 and 7
-- days after by default). Paid invoices drop out automatically.
create or replace function public.dues_reminders_today()
returns table (invoice_id uuid, invoice_no text, member_id uuid, member_name text, member_phone text,
               balance_paise int, next_due_date date, days_to_due int)
language sql
stable
security invoker
set search_path = public
as $$
  select i.id, i.invoice_no, i.member_id, i.member_name, i.member_phone, i.balance_paise, i.next_due_date,
         i.next_due_date - public.ist_today()
  from public.invoices i
  where i.status in ('unpaid', 'partial') and i.balance_paise > 0
    and (i.next_due_date - public.ist_today()) = any (public.due_reminder_days())
  order by i.next_due_date, i.member_name
$$;

-- Front desk and owner: dues numbers (not revenue).
create or replace function public.dues_summary()
returns jsonb
language sql
stable
security invoker
set search_path = public
as $$
  select jsonb_build_object(
    'overdue_count', count(*) filter (where next_due_date < public.ist_today()),
    'overdue_paise', coalesce(sum(balance_paise) filter (where next_due_date < public.ist_today()), 0),
    'due_count', count(*) filter (where next_due_date >= public.ist_today()),
    'due_paise', coalesce(sum(balance_paise) filter (where next_due_date >= public.ist_today()), 0),
    'pending_claims', (select count(*) from public.payments where status = 'pending_verification'))
  from public.invoices
  where status in ('unpaid', 'partial')
$$;

-- Owner: collected money for a period, by mode and by day, plus invoiced,
-- outstanding, refunds and expenses (dashboard hero + F15 hooks).
create or replace function public.collections_summary(p_from date, p_to date)
returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_owner() then raise exception 'not allowed' using errcode = '42501'; end if;
  return jsonb_build_object(
    'collected', coalesce((select sum(amount_paise - refunded_paise) from public.payments
                           where status = 'confirmed' and mode <> 'credit' and paid_on between p_from and p_to), 0),
    'by_mode', coalesce((select jsonb_object_agg(mode, s) from (
                           select mode, sum(amount_paise - refunded_paise) s from public.payments
                           where status = 'confirmed' and mode <> 'credit' and paid_on between p_from and p_to
                           group by mode) m), '{}'::jsonb),
    'by_day', coalesce((select jsonb_agg(jsonb_build_object('day', d, 'paise', coalesce(s, 0)) order by d)
                        from generate_series(p_from, p_to, interval '1 day') d
                        left join (select paid_on, sum(amount_paise - refunded_paise) s from public.payments
                                   where status = 'confirmed' and mode <> 'credit' and paid_on between p_from and p_to
                                   group by paid_on) x on x.paid_on = d::date), '[]'::jsonb),
    'invoiced', coalesce((select sum(total_paise) from public.invoices
                          where status <> 'void' and issue_date between p_from and p_to), 0),
    'outstanding', coalesce((select sum(balance_paise) from public.invoices where status in ('unpaid', 'partial')), 0),
    'refunds', coalesce((select sum(amount_paise) from public.refunds where refunded_on between p_from and p_to), 0),
    'expenses', coalesce((select sum(amount_paise) from public.expenses where spent_on between p_from and p_to), 0),
    'payments_count', (select count(*) from public.payments
                       where status = 'confirmed' and mode <> 'credit' and paid_on between p_from and p_to));
end;
$$;

-- Needs action now includes overdue dues (spec "overdue payments").
create or replace function public.needs_action(p_limit int default 50)
returns table (member_id uuid, name text, phone text, photo_url text, reason text, detail text, sort_key int)
language sql
stable
security invoker
set search_path = public
as $$
  with t as (select public.ist_today() as today, public.setting_int('absent_days', 7) as absent)
  select * from (
    select m.id, m.name, m.phone, m.photo_url, 'overdue', i.next_due_date::text || '|' || i.balance_paise, 0
    from public.invoices i join public.members m on m.id = i.member_id, t
    where i.status in ('unpaid', 'partial') and i.next_due_date < t.today and m.archived_at is null
    union all
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

-- Check-in now also reports dues so the desk sees "dues pending".
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
    'dues_paise', v_m.dues_paise, 'already', v_already, 'checked_in_at', v_row.checked_in_at);
end;
$$;
revoke execute on function public._check_in(uuid, text) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
alter table public.invoices       enable row level security;
alter table public.invoice_items  enable row level security;
alter table public.instalments    enable row level security;
alter table public.payments       enable row level security;
alter table public.member_credits enable row level security;
alter table public.refunds        enable row level security;
alter table public.expenses       enable row level security;
alter table public.day_closes     enable row level security;

-- Invoices & payments: front desk and owner, and the member for their own.
-- Trainers have no access (spec). Writes only through the RPCs above.
create policy invoices_read on public.invoices for select to authenticated
  using (public.is_desk() or member_id = public.auth_member_id());
create policy invoice_items_read on public.invoice_items for select to authenticated
  using (exists (select 1 from public.invoices i where i.id = invoice_id));
create policy instalments_read on public.instalments for select to authenticated
  using (exists (select 1 from public.invoices i where i.id = invoice_id));
create policy payments_read on public.payments for select to authenticated
  using (public.is_desk() or member_id = public.auth_member_id());
create policy credits_read on public.member_credits for select to authenticated
  using (public.is_desk() or member_id = public.auth_member_id());
create policy refunds_read on public.refunds for select to authenticated
  using (public.is_desk());

-- Expenses: owner only. Day closes: owner all, desk their own.
create policy expenses_owner on public.expenses for all to authenticated
  using (public.is_owner()) with check (public.is_owner());
create policy day_closes_read on public.day_closes for select to authenticated
  using (public.is_owner() or staff_id = public.auth_staff_id());

grant execute on function
  public.create_invoice(uuid, jsonb, date, int, text),
  public.set_instalments(uuid, jsonb),
  public.collect_payment(uuid, int, text, text, date, text),
  public.member_credit_balance(uuid),
  public.apply_credit(uuid, int),
  public.claim_payment(uuid, int, text),
  public.verify_payment(uuid, boolean, text),
  public.void_payment(uuid, text),
  public.refund_payment(uuid, int, text, text),
  public.void_invoice(uuid, text),
  public.day_summary(date, uuid),
  public.close_day(int, text, date),
  public.reopen_day(uuid),
  public.dues_reminders_today(),
  public.dues_summary(),
  public.collections_summary(date, date),
  public.fy_label(date),
  public.due_reminder_days()
to authenticated;

-- Nothing here is for signed-out users.
revoke execute on function
  public.create_invoice(uuid, jsonb, date, int, text),
  public.set_instalments(uuid, jsonb),
  public.collect_payment(uuid, int, text, text, date, text),
  public.member_credit_balance(uuid),
  public.apply_credit(uuid, int),
  public.claim_payment(uuid, int, text),
  public.verify_payment(uuid, boolean, text),
  public.void_payment(uuid, text),
  public.refund_payment(uuid, int, text, text),
  public.void_invoice(uuid, text),
  public.day_summary(date, uuid),
  public.close_day(int, text, date),
  public.reopen_day(uuid),
  public.dues_reminders_today(),
  public.dues_summary(),
  public.collections_summary(date, date),
  public.due_reminder_days()
from anon;

-- ---------------------------------------------------------------------------
-- Nightly dues refresh at 00:10 IST (18:40 UTC) when pg_cron is available
-- ---------------------------------------------------------------------------
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.schedule('refresh_dues', '40 18 * * *', 'select public.refresh_dues()');
  end if;
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
     and not exists (select 1 from pg_publication_tables
                     where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'payments') then
    execute 'alter publication supabase_realtime add table public.payments';
  end if;
end $$;
