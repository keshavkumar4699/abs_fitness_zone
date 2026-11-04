-- ABS Fitness — Milestone M4: diet and nutrition (F6)
-- The food database (seeded in the next migration), diet templates (meals,
-- items and "or" options), plans assigned to members as copied snapshots,
-- meal, water and supplement logs written by the member's phone, food
-- preferences and allergies, trainer comments, adherence and the nutrition
-- overview for coaches.
--
-- Diet plans and logs are health data (DPDP): only the member, their
-- trainer and the owner see them. The front desk sees the gym's template
-- library, never a member's plan.

-- ---------------------------------------------------------------------------
-- Lists
-- ---------------------------------------------------------------------------
create or replace function public.meal_slots()
returns text[]
language sql
immutable
as $$
  select array['early_morning', 'breakfast', 'mid_morning', 'lunch', 'evening_snack', 'pre_workout',
               'post_workout', 'dinner', 'bedtime']::text[]
$$;

create or replace function public.food_allergens()
returns text[]
language sql
immutable
as $$
  select array['dairy', 'gluten', 'nuts', 'peanut', 'soy', 'egg', 'fish', 'shellfish', 'sesame']::text[]
$$;

create or replace function public._clean_list(p text[], p_len int)
returns text[]
language sql
immutable
as $$
  select coalesce(array_agg(distinct v order by v), '{}')
  from (select trim(x) v from unnest(coalesce(p, '{}')) x) s
  where v <> '' and length(v) <= p_len
$$;

alter table public.member_events drop constraint if exists member_events_kind_check;
alter table public.member_events add constraint member_events_kind_check check (kind in (
  'joined','membership_started','renewed','frozen','unfrozen','cancelled','transferred_in','transferred_out',
  'note','profile_updated','pin_set','imported','archived','restored',
  'invoice_created','payment','payment_voided','refund','invoice_voided',
  'program_assigned','program_ended','diet_assigned','diet_ended'));

-- Food preferences (6.4): allergies and foods to avoid sit with the rest of
-- the member's health data. Veg / egg / non-veg / vegan / Jain is
-- members.diet_pref (F1).
alter table public.member_health
  add column if not exists food_allergies text[] not null default '{}'
    check (food_allergies <@ public.food_allergens()),
  add column if not exists foods_to_avoid text[] not null default '{}'
    check (cardinality(foods_to_avoid) <= 20);

-- ---------------------------------------------------------------------------
-- Food database (6.1). Values are per serving; serving_g is the grams (or
-- ml) in one serving. qty_step is the smallest sensible amount when scaling:
-- half a roti, one egg, 25 g of paneer.
-- ---------------------------------------------------------------------------
create table public.foods (
  id           uuid primary key default gen_random_uuid(),
  seed_key     text unique,
  name         text not null check (length(trim(name)) between 2 and 80),
  local_name   text check (local_name is null or length(local_name) <= 80),
  category     text not null check (category in ('grains', 'pulses', 'vegetables', 'fruits', 'dairy', 'eggs',
                 'meat_fish', 'nuts_seeds', 'snacks', 'sweets', 'drinks', 'fats_oils', 'condiments', 'supplements')),
  serving_unit text not null check (serving_unit in ('g', 'ml', 'katori', 'roti', 'piece', 'glass', 'cup', 'bowl',
                 'plate', 'slice', 'tbsp', 'tsp', 'scoop', 'handful')),
  serving_g    numeric(7,1) not null check (serving_g > 0 and serving_g <= 2000),
  qty_step     numeric(4,2) not null default 0.5 check (qty_step in (0.25, 0.5, 1)),
  kcal         numeric(7,1) not null check (kcal between 0 and 3000),
  protein_g    numeric(6,1) not null default 0 check (protein_g between 0 and 300),
  carbs_g      numeric(6,1) not null default 0 check (carbs_g between 0 and 500),
  fat_g        numeric(6,1) not null default 0 check (fat_g between 0 and 300),
  fibre_g      numeric(6,1) not null default 0 check (fibre_g between 0 and 100),
  veg_type     text not null check (veg_type in ('vegan', 'veg', 'egg', 'non_veg')),
  jain_ok      boolean not null default false,
  allergens    text[] not null default '{}' check (allergens <@ public.food_allergens()),
  -- What to buy for one serving: [{ item, qty, unit: g | ml | pc }] (6.12).
  grocery      jsonb not null default '[]' check (jsonb_typeof(grocery) = 'array'),
  source       text not null default 'custom' check (source in ('gym_seed', 'usda', 'custom')),
  source_ref   text,
  is_custom    boolean generated always as (source = 'custom') stored,
  created_by   uuid references auth.users (id) on delete set null,
  reviewed_at  timestamptz,
  reviewed_by  uuid references auth.users (id) on delete set null,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  archived_at  timestamptz
);
create trigger foods_touch before update on public.foods
  for each row execute function public.touch_updated_at();
create index foods_updated on public.foods (updated_at);
create index foods_name_trgm on public.foods using gin (name extensions.gin_trgm_ops);
create index foods_local_trgm on public.foods using gin (local_name extensions.gin_trgm_ops);

-- From the app: new foods are custom and vouched for by their author; any
-- coach may correct values (which counts as reviewing them) or mark a food
-- reviewed; only the owner or a custom food's author archives it. Seeds and
-- migrations (no signed-in user) are left alone.
create or replace function public.foods_guard()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then return new; end if;
  if tg_op = 'INSERT' then
    new.source := 'custom';
    new.seed_key := null;
    new.created_by := auth.uid();
    new.reviewed_at := now();
    new.reviewed_by := auth.uid();
    new.archived_at := null;
    return new;
  end if;
  new.seed_key := old.seed_key;
  new.source := old.source;
  new.source_ref := old.source_ref;
  new.created_by := old.created_by;
  if (new.kcal, new.protein_g, new.carbs_g, new.fat_g, new.fibre_g, new.serving_g, new.serving_unit)
     is distinct from (old.kcal, old.protein_g, old.carbs_g, old.fat_g, old.fibre_g, old.serving_g, old.serving_unit)
     or (new.reviewed_at is not null and old.reviewed_at is null) then
    new.reviewed_at := now();
    new.reviewed_by := auth.uid();
  elsif new.reviewed_at is null and old.reviewed_at is not null then
    new.reviewed_at := old.reviewed_at;
    new.reviewed_by := old.reviewed_by;
  end if;
  if new.archived_at is distinct from old.archived_at
     and not (public.is_owner() or (old.source = 'custom' and old.created_by = auth.uid())) then
    raise exception 'only the owner or its author can remove a food' using errcode = '42501';
  end if;
  return new;
end;
$$;
create trigger foods_guard before insert or update on public.foods
  for each row execute function public.foods_guard();

-- ---------------------------------------------------------------------------
-- Diet templates (6.3, 6.6). A library template belongs to the gym;
-- assigning copies it into a snapshot only that member's plan uses.
-- ---------------------------------------------------------------------------
create table public.diet_templates (
  id                 uuid primary key default gen_random_uuid(),
  name               text not null check (length(trim(name)) between 2 and 80),
  description        text check (description is null or length(description) <= 1000),
  goal               text check (goal in ('fat_loss', 'maintenance', 'muscle_gain')),
  diet_pref          text check (diet_pref in ('veg', 'eggetarian', 'non_veg', 'vegan', 'jain')),
  kcal_target        int not null check (kcal_target between 800 and 6000),
  protein_g          int check (protein_g between 0 and 500),
  carbs_g            int check (carbs_g between 0 and 1000),
  fat_g              int check (fat_g between 0 and 400),
  macro_preset       text check (macro_preset in ('high_protein', 'balanced', 'keto_light')),
  supplements        text[] not null default '{}' check (cardinality(supplements) <= 8),
  is_gym_template    boolean not null default true,
  is_starter         boolean not null default false,
  source_template_id uuid references public.diet_templates (id) on delete set null,
  created_by         uuid references auth.users (id) on delete set null,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  archived_at        timestamptz
);
create trigger diet_templates_touch before update on public.diet_templates
  for each row execute function public.touch_updated_at();

create table public.diet_meals (
  id          uuid primary key default gen_random_uuid(),
  template_id uuid not null references public.diet_templates (id) on delete cascade,
  meal_slot   text not null check (meal_slot = any (public.meal_slots())),
  time_of_day time,
  position    int not null check (position between 1 and 9),
  notes       text check (notes is null or length(notes) <= 300),
  unique (template_id, meal_slot)
);

-- alt_group 0 is the meal; 1 and 2 are its "or" options (6.5).
create table public.diet_meal_items (
  id        uuid primary key default gen_random_uuid(),
  meal_id   uuid not null references public.diet_meals (id) on delete cascade,
  food_id   uuid not null references public.foods (id),
  qty       numeric(6,2) not null check (qty > 0 and qty <= 50),
  alt_group smallint not null default 0 check (alt_group between 0 and 2),
  position  int not null check (position between 1 and 30),
  unique (meal_id, alt_group, position)
);
create index diet_meal_items_meal on public.diet_meal_items (meal_id, alt_group, position);

-- ---------------------------------------------------------------------------
-- Plans assigned to members (6.7). Open-ended: a plan runs until it is
-- replaced or ended. 'dropped' is a queued plan replaced before it started.
-- ---------------------------------------------------------------------------
create table public.member_diets (
  id                 uuid primary key default gen_random_uuid(),
  member_id          uuid not null references public.members (id) on delete cascade,
  template_id        uuid not null unique references public.diet_templates (id),   -- the snapshot
  source_template_id uuid references public.diet_templates (id) on delete set null,
  name               text not null,
  start_date         date not null,
  end_date           date,
  status             text not null default 'active' check (status in ('active', 'queued', 'replaced', 'ended', 'dropped')),
  assigned_by        uuid references auth.users (id) on delete set null,
  assigned_at        timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  check (end_date is null or end_date >= start_date)
);
create trigger member_diets_touch before update on public.member_diets
  for each row execute function public.touch_updated_at();
create unique index member_diets_one_active on public.member_diets (member_id) where status = 'active';
create unique index member_diets_one_queued on public.member_diets (member_id) where status = 'queued';
create index member_diets_member on public.member_diets (member_id, start_date desc);

-- ---------------------------------------------------------------------------
-- Logs (6.8, 6.9). Meals are logged by slot, so editing a member's plan
-- never orphans what they already marked. kcal and macros are what was
-- eaten, worked out when the meal is marked.
-- ---------------------------------------------------------------------------
create table public.meal_logs (
  id             uuid primary key default gen_random_uuid(),
  member_id      uuid not null references public.members (id) on delete cascade,
  member_diet_id uuid references public.member_diets (id) on delete set null,
  day            date not null,
  meal_slot      text not null check (meal_slot = any (public.meal_slots())),
  status         text not null check (status in ('eaten', 'partly', 'skipped', 'swapped')),
  alt_group      smallint check (alt_group between 1 and 2),
  kcal           numeric(7,1) not null default 0,
  protein_g      numeric(6,1) not null default 0,
  carbs_g        numeric(6,1) not null default 0,
  fat_g          numeric(6,1) not null default 0,
  logged_at      timestamptz not null default now(),
  check ((status = 'swapped') = (alt_group is not null)),
  unique (member_id, day, meal_slot)
);
create index meal_logs_diet on public.meal_logs (member_diet_id, day);

create table public.water_logs (
  id         uuid primary key default gen_random_uuid(),
  member_id  uuid not null references public.members (id) on delete cascade,
  day        date not null,
  glasses    int not null check (glasses between 0 and 30),
  updated_at timestamptz not null default now(),
  unique (member_id, day)
);

create table public.supplement_logs (
  id        uuid primary key default gen_random_uuid(),
  member_id uuid not null references public.members (id) on delete cascade,
  day       date not null,
  name      text not null check (length(trim(name)) between 1 and 40),
  taken_at  timestamptz not null default now(),
  unique (member_id, day, name)
);

-- Trainer comments on a member's nutrition (6.11).
create table public.diet_comments (
  id             uuid primary key default gen_random_uuid(),
  member_id      uuid not null references public.members (id) on delete cascade,
  member_diet_id uuid references public.member_diets (id) on delete set null,
  author_id      uuid references auth.users (id) on delete set null,
  author_name    text not null,
  body           text not null check (length(trim(body)) between 1 and 500),
  created_at     timestamptz not null default now()
);
create index diet_comments_member on public.diet_comments (member_id, created_at desc);

-- ---------------------------------------------------------------------------
-- Row Level Security. Reads use policies; writes to templates, plans, logs
-- and comments go through the RPCs below.
-- ---------------------------------------------------------------------------
alter table public.foods           enable row level security;
alter table public.diet_templates  enable row level security;
alter table public.diet_meals      enable row level security;
alter table public.diet_meal_items enable row level security;
alter table public.member_diets    enable row level security;
alter table public.meal_logs       enable row level security;
alter table public.water_logs      enable row level security;
alter table public.supplement_logs enable row level security;
alter table public.diet_comments   enable row level security;

create policy foods_read on public.foods for select to authenticated using (true);
create policy foods_insert on public.foods for insert to authenticated with check (public.is_coach());
create policy foods_update on public.foods for update to authenticated
  using (public.is_coach()) with check (public.is_coach());

-- Library templates: all staff. A member's plan: the member, their trainer
-- and the owner.
create or replace function public.can_read_diet_template(p_template_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.diet_templates t where t.id = p_template_id and t.is_gym_template and public.is_staff())
      or exists (select 1 from public.member_diets md
                 where md.template_id = p_template_id
                   and (md.member_id = public.auth_member_id() or public.can_coach_member(md.member_id)))
$$;

create policy diet_templates_read on public.diet_templates for select to authenticated
  using (public.can_read_diet_template(id));
create policy diet_meals_read on public.diet_meals for select to authenticated
  using (public.can_read_diet_template(template_id));
create policy diet_items_read on public.diet_meal_items for select to authenticated
  using (exists (select 1 from public.diet_meals m where m.id = meal_id and public.can_read_diet_template(m.template_id)));
create policy member_diets_read on public.member_diets for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));
create policy meal_logs_read on public.meal_logs for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));
create policy water_logs_read on public.water_logs for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));
create policy supplement_logs_read on public.supplement_logs for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));
create policy diet_comments_read on public.diet_comments for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));

-- ---------------------------------------------------------------------------
-- Templates: save (create or replace meals and items), archive
-- ---------------------------------------------------------------------------
create or replace function public._write_meals(p_template_id uuid, p_meals jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_meal    jsonb;
  v_item    jsonb;
  v_meal_id uuid;
  v_n       int := 0;
  v_group   int;
  v_pos     int[];
begin
  if jsonb_typeof(p_meals) <> 'array' or jsonb_array_length(p_meals) not between 1 and 9 then
    raise exception 'a plan needs 1 to 9 meals' using errcode = '22023';
  end if;
  delete from public.diet_meals where template_id = p_template_id;
  for v_meal in select * from jsonb_array_elements(p_meals) loop
    v_n := v_n + 1;
    if not coalesce(v_meal ->> 'meal_slot' = any (public.meal_slots()), false) then
      raise exception 'unknown meal' using errcode = '22023';
    end if;
    if exists (select 1 from public.diet_meals where template_id = p_template_id and meal_slot = v_meal ->> 'meal_slot') then
      raise exception 'each meal can appear once' using errcode = '22023';
    end if;
    if (select count(*) from jsonb_array_elements(coalesce(v_meal -> 'items', '[]')) i
        where coalesce((i ->> 'alt_group')::int, 0) = 0) not between 1 and 20 then
      raise exception 'each meal needs 1 to 20 foods' using errcode = '22023';
    end if;
    insert into public.diet_meals (template_id, meal_slot, time_of_day, position, notes)
    values (p_template_id, v_meal ->> 'meal_slot', nullif(v_meal ->> 'time_of_day', '')::time, v_n,
            nullif(trim(v_meal ->> 'notes'), ''))
    returning id into v_meal_id;
    v_pos := array[0, 0, 0];
    for v_item in select * from jsonb_array_elements(v_meal -> 'items') loop
      v_group := coalesce((v_item ->> 'alt_group')::int, 0);
      if v_group not between 0 and 2 then raise exception 'up to two options per meal' using errcode = '22023'; end if;
      if not exists (select 1 from public.foods where id = (v_item ->> 'food_id')::uuid) then
        raise exception 'unknown food' using errcode = '22023';
      end if;
      v_pos[v_group + 1] := v_pos[v_group + 1] + 1;
      insert into public.diet_meal_items (meal_id, food_id, qty, alt_group, position)
      values (v_meal_id, (v_item ->> 'food_id')::uuid, (v_item ->> 'qty')::numeric, v_group, v_pos[v_group + 1]);
    end loop;
  end loop;
end;
$$;
revoke execute on function public._write_meals(uuid, jsonb) from public, anon, authenticated;

-- Library: owner or its author. A member's plan: owner or their trainer.
create or replace function public._can_edit_diet_template(p_template_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.diet_templates t
                 where t.id = p_template_id and t.archived_at is null and t.is_gym_template
                   and (public.is_owner() or (public.is_coach() and t.created_by = auth.uid())))
      or exists (select 1 from public.member_diets md
                 where md.template_id = p_template_id and public.can_coach_member(md.member_id))
$$;

-- { id?, name, description, goal, diet_pref, kcal_target, protein_g,
--   carbs_g, fat_g, macro_preset, supplements: [..], meals: [{ meal_slot,
--   time_of_day, notes, items: [{ food_id, qty, alt_group }] }] }
create or replace function public.save_diet_template(p jsonb)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id   uuid := (p ->> 'id')::uuid;
  v_supp text[] := public._clean_list(array(select jsonb_array_elements_text(coalesce(p -> 'supplements', '[]'))), 40);
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  if cardinality(v_supp) > 8 then raise exception 'up to 8 supplements' using errcode = '22023'; end if;
  if v_id is null then
    insert into public.diet_templates (name, description, goal, diet_pref, kcal_target, protein_g, carbs_g, fat_g,
                                       macro_preset, supplements, is_gym_template, created_by)
    values (trim(p ->> 'name'), nullif(trim(p ->> 'description'), ''), p ->> 'goal', p ->> 'diet_pref',
            (p ->> 'kcal_target')::int, (p ->> 'protein_g')::int, (p ->> 'carbs_g')::int, (p ->> 'fat_g')::int,
            p ->> 'macro_preset', v_supp, true, auth.uid())
    returning id into v_id;
  else
    if not public._can_edit_diet_template(v_id) then raise exception 'not allowed' using errcode = '42501'; end if;
    update public.diet_templates
       set name = trim(p ->> 'name'), description = nullif(trim(p ->> 'description'), ''), goal = p ->> 'goal',
           diet_pref = p ->> 'diet_pref', kcal_target = (p ->> 'kcal_target')::int, protein_g = (p ->> 'protein_g')::int,
           carbs_g = (p ->> 'carbs_g')::int, fat_g = (p ->> 'fat_g')::int, macro_preset = p ->> 'macro_preset',
           supplements = v_supp
     where id = v_id;
    update public.member_diets set name = trim(p ->> 'name') where template_id = v_id;
  end if;
  perform public._write_meals(v_id, p -> 'meals');
  return v_id;
end;
$$;

create or replace function public.archive_diet_template(p_template_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (select 1 from public.diet_templates where id = p_template_id and is_gym_template)
     or not public._can_edit_diet_template(p_template_id) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  update public.diet_templates set archived_at = now() where id = p_template_id;
end;
$$;

create or replace function public._copy_diet_template(p_src uuid, p_library boolean)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_new  uuid;
  v_meal record;
  v_meal_id uuid;
begin
  insert into public.diet_templates (name, description, goal, diet_pref, kcal_target, protein_g, carbs_g, fat_g,
                                     macro_preset, supplements, is_gym_template, source_template_id, created_by)
  select t.name, t.description, t.goal, t.diet_pref, t.kcal_target, t.protein_g, t.carbs_g, t.fat_g, t.macro_preset,
         t.supplements, p_library, t.id, auth.uid()
  from public.diet_templates t where t.id = p_src
  returning id into v_new;
  for v_meal in select * from public.diet_meals where template_id = p_src order by position loop
    insert into public.diet_meals (template_id, meal_slot, time_of_day, position, notes)
    values (v_new, v_meal.meal_slot, v_meal.time_of_day, v_meal.position, v_meal.notes) returning id into v_meal_id;
    insert into public.diet_meal_items (meal_id, food_id, qty, alt_group, position)
    select v_meal_id, food_id, qty, alt_group, position from public.diet_meal_items where meal_id = v_meal.id;
  end loop;
  return v_new;
end;
$$;
revoke execute on function public._copy_diet_template(uuid, boolean) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Plans: assign, end, nightly refresh
-- ---------------------------------------------------------------------------
-- From today (or a past start within a week) the new plan replaces the
-- running one at once; a future start queues it and the running plan
-- continues until the day before. A newer assignment drops an older queued one.
create or replace function public.assign_diet(p_template_id uuid, p_member_ids uuid[], p_start date default null)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_t        public.diet_templates%rowtype;
  v_member   uuid;
  v_start    date := coalesce(p_start, public.ist_today());
  v_today    date := public.ist_today();
  v_current  public.member_diets%rowtype;
  v_status   text;
  v_n        int := 0;
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  select * into v_t from public.diet_templates where id = p_template_id and archived_at is null and is_gym_template;
  if not found or not public.can_read_diet_template(p_template_id) then
    raise exception 'diet plan not found' using errcode = 'P0002';
  end if;
  if not exists (select 1 from public.diet_meals where template_id = p_template_id) then
    raise exception 'this plan has no meals' using errcode = '22023';
  end if;
  if coalesce(cardinality(p_member_ids), 0) = 0 then raise exception 'pick at least one member' using errcode = '22023'; end if;
  if v_start < v_today - 7 then raise exception 'start date is too far in the past' using errcode = '22023'; end if;

  foreach v_member in array p_member_ids loop
    if not public.can_coach_member(v_member) then raise exception 'not allowed' using errcode = '42501'; end if;
    perform 1 from public.members where id = v_member and archived_at is null;
    if not found then raise exception 'member not found' using errcode = 'P0002'; end if;
    update public.member_diets set status = 'dropped' where member_id = v_member and status = 'queued';
    v_status := 'queued';
    if v_start <= v_today then
      select * into v_current from public.member_diets where member_id = v_member and status = 'active' for update;
      if found then
        update public.member_diets
           set status = 'replaced', end_date = greatest(start_date, least(v_start, v_today) - 1)
         where id = v_current.id;
        perform public.log_member_event(v_member, 'diet_ended', v_current.name || ' replaced',
                                        jsonb_build_object('member_diet_id', v_current.id));
      end if;
      v_status := 'active';
    end if;
    insert into public.member_diets (member_id, template_id, source_template_id, name, start_date, status, assigned_by)
    values (v_member, public._copy_diet_template(p_template_id, false), p_template_id, v_t.name, v_start, v_status, auth.uid());
    perform public.log_member_event(v_member, 'diet_assigned', v_t.name || ' from ' || to_char(v_start, 'DD Mon'),
                                    jsonb_build_object('template_id', p_template_id, 'start', v_start, 'status', v_status));
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;

create or replace function public.refresh_diets()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := public.ist_today();
  v_q     public.member_diets%rowtype;
  v_n     int := 0;
begin
  for v_q in select * from public.member_diets where status = 'queued' and start_date <= v_today order by start_date loop
    update public.member_diets set status = 'replaced', end_date = greatest(start_date, v_q.start_date - 1)
     where member_id = v_q.member_id and status = 'active';
    update public.member_diets set status = 'active' where id = v_q.id;
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;
revoke execute on function public.refresh_diets() from public, anon, authenticated;

create or replace function public.end_diet(p_diet_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_d public.member_diets%rowtype;
begin
  select * into v_d from public.member_diets where id = p_diet_id and status in ('active', 'queued') for update;
  if not found then raise exception 'diet plan not found' using errcode = 'P0002'; end if;
  if not public.can_coach_member(v_d.member_id) then raise exception 'not allowed' using errcode = '42501'; end if;
  update public.member_diets
     set status = case when v_d.status = 'queued' then 'dropped' else 'ended' end,
         end_date = case when v_d.status = 'active' then greatest(start_date, public.ist_today()) end
   where id = p_diet_id;
  perform public.log_member_event(v_d.member_id, 'diet_ended', v_d.name || ' ended',
                                  jsonb_build_object('member_diet_id', v_d.id));
end;
$$;

-- The plan a member followed on a day.
create or replace function public.diet_on(p_member_id uuid, p_day date)
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.member_diets
  where member_id = p_member_id and status in ('active', 'replaced', 'ended')
    and start_date <= p_day and (end_date is null or end_date >= p_day)
  order by start_date desc, assigned_at desc limit 1
$$;
revoke execute on function public.diet_on(uuid, date) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Member logging (6.8, 6.9): today and the two days before.
-- ---------------------------------------------------------------------------
create or replace function public._member_day(p_day date)
returns uuid
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_member uuid := public.auth_member_id();
begin
  if v_member is null or public.auth_role() <> 'member' then raise exception 'not allowed' using errcode = '42501'; end if;
  if p_day is null or p_day > public.ist_today() or p_day < public.ist_today() - 2 then
    raise exception 'you can log today and the two days before' using errcode = '22023';
  end if;
  return v_member;
end;
$$;
revoke execute on function public._member_day(date) from public, anon, authenticated;

-- Marks a meal Eaten / Partly / Skipped / Swapped (with option 1 or 2), or
-- clears it (null status). Returns the log, or null when cleared.
create or replace function public.log_meal(p_day date, p_slot text, p_status text, p_alt int default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid := public._member_day(p_day);
  v_diet   uuid := public.diet_on(v_member, p_day);
  v_meal   uuid;
  v_group  int;
  v_factor numeric;
  v_row    public.meal_logs%rowtype;
begin
  if v_diet is null then raise exception 'no diet plan on that day' using errcode = 'P0002'; end if;
  select m.id into v_meal from public.diet_meals m join public.member_diets md on md.template_id = m.template_id
   where md.id = v_diet and m.meal_slot = p_slot;
  if not found then raise exception 'that meal is not in your plan' using errcode = 'P0002'; end if;
  if p_status is null then
    delete from public.meal_logs where member_id = v_member and day = p_day and meal_slot = p_slot;
    return null;
  end if;
  if p_status not in ('eaten', 'partly', 'skipped', 'swapped') then
    raise exception 'unknown meal status' using errcode = '22023';
  end if;
  v_group := case when p_status = 'swapped' then p_alt else 0 end;
  if p_status = 'swapped' and (p_alt is null or not exists (
       select 1 from public.diet_meal_items where meal_id = v_meal and alt_group = p_alt)) then
    raise exception 'pick one of the options' using errcode = '22023';
  end if;
  v_factor := case p_status when 'partly' then 0.5 when 'skipped' then 0 else 1 end;
  insert into public.meal_logs as l (member_id, member_diet_id, day, meal_slot, status, alt_group,
                                     kcal, protein_g, carbs_g, fat_g, logged_at)
  select v_member, v_diet, p_day, p_slot, p_status, case when p_status = 'swapped' then p_alt end,
         round(coalesce(sum(f.kcal * i.qty), 0) * v_factor, 1), round(coalesce(sum(f.protein_g * i.qty), 0) * v_factor, 1),
         round(coalesce(sum(f.carbs_g * i.qty), 0) * v_factor, 1), round(coalesce(sum(f.fat_g * i.qty), 0) * v_factor, 1), now()
  from public.diet_meal_items i join public.foods f on f.id = i.food_id
  where i.meal_id = v_meal and i.alt_group = v_group
  on conflict (member_id, day, meal_slot) do update
    set member_diet_id = excluded.member_diet_id, status = excluded.status, alt_group = excluded.alt_group,
        kcal = excluded.kcal, protein_g = excluded.protein_g, carbs_g = excluded.carbs_g, fat_g = excluded.fat_g,
        logged_at = now()
  returning * into v_row;
  return to_jsonb(v_row);
end;
$$;

create or replace function public.set_water(p_day date, p_glasses int)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid := public._member_day(p_day);
begin
  if p_glasses is null or p_glasses not between 0 and 30 then
    raise exception 'glasses must be 0 to 30' using errcode = '22023';
  end if;
  insert into public.water_logs (member_id, day, glasses) values (v_member, p_day, p_glasses)
  on conflict (member_id, day) do update set glasses = excluded.glasses, updated_at = now();
  return p_glasses;
end;
$$;

create or replace function public.set_supplement(p_day date, p_name text, p_taken boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid := public._member_day(p_day);
begin
  if length(trim(coalesce(p_name, ''))) not between 1 and 40 then
    raise exception 'supplement name is 1 to 40 characters' using errcode = '22023';
  end if;
  if p_taken then
    insert into public.supplement_logs (member_id, day, name) values (v_member, p_day, trim(p_name))
    on conflict (member_id, day, name) do nothing;
  else
    delete from public.supplement_logs where member_id = v_member and day = p_day and name = trim(p_name);
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- Preferences (6.4) and trainer comments (6.11)
-- ---------------------------------------------------------------------------
create or replace function public.set_diet_preferences(
  p_member_id uuid,
  p_diet_pref text,
  p_allergies text[] default '{}',
  p_avoid text[] default '{}'
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_avoid text[] := public._clean_list(p_avoid, 40);
begin
  if not coalesce(p_member_id = public.auth_member_id() or public.can_coach_member(p_member_id), false) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  if p_diet_pref is not null and p_diet_pref not in ('veg', 'eggetarian', 'non_veg', 'vegan', 'jain') then
    raise exception 'unknown diet preference' using errcode = '22023';
  end if;
  if not (coalesce(p_allergies, '{}') <@ public.food_allergens()) then
    raise exception 'unknown allergy' using errcode = '22023';
  end if;
  if cardinality(v_avoid) > 20 then raise exception 'up to 20 foods to avoid' using errcode = '22023'; end if;
  update public.members set diet_pref = p_diet_pref where id = p_member_id;
  insert into public.member_health (member_id, food_allergies, foods_to_avoid, updated_by)
  values (p_member_id, public._clean_list(p_allergies, 20), v_avoid, auth.uid())
  on conflict (member_id) do update
    set food_allergies = excluded.food_allergies, foods_to_avoid = excluded.foods_to_avoid, updated_by = auth.uid();
end;
$$;

create or replace function public.comment_diet(p_member_id uuid, p_body text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
  v_id   uuid;
begin
  if not public.can_coach_member(p_member_id) then raise exception 'not allowed' using errcode = '42501'; end if;
  select name into v_name from public.profiles where id = auth.uid();
  insert into public.diet_comments (member_id, member_diet_id, author_id, author_name, body)
  values (p_member_id, (select id from public.member_diets where member_id = p_member_id and status = 'active'),
          auth.uid(), coalesce(v_name, 'Coach'), trim(p_body))
  returning id into v_id;
  return v_id;
end;
$$;

-- What the plan builder and assign sheet need to warn about (6.4 and the
-- medical-conditions flag): the member's preference, allergies, foods to
-- avoid and any health conditions from F1 1.2.
create or replace function public.diet_member_flags(p_member_ids uuid[])
returns table (
  member_id uuid, name text, diet_pref text, food_allergies text[], foods_to_avoid text[],
  conditions text, has_conditions boolean
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  return query
  select m.id, m.name, m.diet_pref, coalesce(h.food_allergies, '{}'), coalesce(h.foods_to_avoid, '{}'),
         nullif(concat_ws('; ', nullif(trim(h.conditions), ''), nullif(trim(h.medications), '')), ''),
         coalesce(nullif(trim(h.conditions), '') is not null or nullif(trim(h.medications), '') is not null
                  or exists (select 1 from jsonb_each(h.parq) e where e.value = 'true'::jsonb), false)
  from public.members m left join public.member_health h on h.member_id = m.id
  where m.id = any (p_member_ids) and public.can_coach_member(m.id);
end;
$$;

-- ---------------------------------------------------------------------------
-- Adherence (6.11) and the nutrition overview
-- ---------------------------------------------------------------------------
-- Eaten or swapped = 1, partly = ½, skipped or not marked = 0, over the
-- plan's meals on each day from p_from to p_to. Past days count every meal;
-- today counts only the meals already marked. Null when nothing was due.
create or replace function public.diet_adherence(p_diet_id uuid, p_from date, p_to date)
returns numeric
language sql
stable
security definer
set search_path = public
as $$
  with d as (
    select md.*, greatest(md.start_date, p_from) as w_from,
           least(coalesce(md.end_date, public.ist_today()), p_to, public.ist_today()) as w_to,
           (select count(*) from public.diet_meals m where m.template_id = md.template_id) as per_day
    from public.member_diets md
    where md.id = p_diet_id and (md.member_id = public.auth_member_id() or public.can_coach_member(md.member_id))
  ), logs as (
    select l.day, l.status from d join public.meal_logs l on l.member_diet_id = d.id and l.day between d.w_from and d.w_to
  ), planned as (
    select coalesce((select per_day * greatest((least(w_to, public.ist_today() - 1) - w_from) + 1, 0) from d), 0)
         + (select count(*) from logs where day = public.ist_today()) as n
  ), score as (
    select coalesce(sum(case status when 'eaten' then 1 when 'swapped' then 1 when 'partly' then 0.5 else 0 end), 0) as n
    from logs
  )
  select case when planned.n > 0 then round(least(score.n, planned.n) / planned.n, 2) end from planned, score
$$;
revoke execute on function public.diet_adherence(uuid, date, date) from public, anon;

create or replace function public.diet_overview(
  p_trainer_id uuid default null,
  p_search text default '',
  p_offset int default 0,
  p_limit int default 30
) returns table (
  member_id uuid, name text, member_code text, photo_url text, trainer_id uuid, status text,
  diet_id uuid, diet_name text, diet_status text, diet_start date, kcal_target int, meals_per_day int,
  adherence_7d numeric, missed_7d int, logged_today int, last_logged_at timestamptz, has_conditions boolean
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_today date := public.ist_today();
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  return query
  select m.id, m.name, m.member_code, m.photo_url, m.trainer_id, m.status,
         md.id, md.name, md.status, md.start_date, t.kcal_target,
         (select count(*)::int from public.diet_meals x where x.template_id = md.template_id),
         case when md.status = 'active' then public.diet_adherence(md.id, v_today - 6, v_today) end,
         -- Meals due in the last 7 days (before today) that were skipped or never marked.
         case when md.status = 'active' then
           greatest((select count(*)::int from public.diet_meals x where x.template_id = md.template_id)
                      * greatest(v_today - greatest(md.start_date, v_today - 7), 0)
                    - (select count(*)::int from public.meal_logs l
                       where l.member_diet_id = md.id and l.day between v_today - 7 and v_today - 1
                         and l.status <> 'skipped'), 0)
         else 0 end,
         (select count(*)::int from public.meal_logs l where l.member_id = m.id and l.day = v_today),
         (select max(l.logged_at) from public.meal_logs l where l.member_id = m.id),
         coalesce((select nullif(trim(h.conditions), '') is not null or nullif(trim(h.medications), '') is not null
                          or exists (select 1 from jsonb_each(h.parq) e where e.value = 'true'::jsonb)
                   from public.member_health h where h.member_id = m.id), false)
  from public.members m
  left join lateral (select * from public.member_diets x
                     where x.member_id = m.id and x.status in ('active', 'queued')
                     order by (x.status = 'active') desc, x.start_date limit 1) md on true
  left join public.diet_templates t on t.id = md.template_id
  where m.archived_at is null
    and (case when public.is_owner() then (p_trainer_id is null or m.trainer_id = p_trainer_id)
              else m.trainer_id = public.auth_staff_id() end)
    and (coalesce(trim(p_search), '') = '' or m.name ilike '%' || trim(p_search) || '%'
         or m.member_code ilike '%' || trim(p_search) || '%')
  order by (md.id is null) desc, m.name
  offset greatest(p_offset, 0) limit least(greatest(p_limit, 1), 100);
end;
$$;

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------
grant execute on function
  public.meal_slots(), public.food_allergens(), public.can_read_diet_template(uuid),
  public.save_diet_template(jsonb), public.archive_diet_template(uuid),
  public.assign_diet(uuid, uuid[], date), public.end_diet(uuid),
  public.log_meal(date, text, text, int), public.set_water(date, int), public.set_supplement(date, text, boolean),
  public.set_diet_preferences(uuid, text, text[], text[]), public.comment_diet(uuid, text),
  public.diet_member_flags(uuid[]), public.diet_adherence(uuid, date, date),
  public.diet_overview(uuid, text, int, int)
to authenticated;
revoke execute on function
  public.can_read_diet_template(uuid), public.save_diet_template(jsonb), public.archive_diet_template(uuid),
  public.assign_diet(uuid, uuid[], date), public.end_diet(uuid),
  public.log_meal(date, text, text, int), public.set_water(date, int), public.set_supplement(date, text, boolean),
  public.set_diet_preferences(uuid, text, text[], text[]), public.comment_diet(uuid, text),
  public.diet_member_flags(uuid[]), public.diet_overview(uuid, text, int, int)
from anon;

-- Nightly: queued plans start on their day (00:20 IST = 18:50 UTC).
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.schedule('refresh_diets', '50 18 * * *', 'select public.refresh_diets()');
  end if;
end $$;
