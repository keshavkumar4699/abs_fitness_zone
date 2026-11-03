-- ABS Fitness — Milestone M3: exercise library (F4) and workouts (F5)
-- The exercise catalogue (seeded in the next migration), favourites, the
-- gym's "equipment we have", workout templates (days and items), programs
-- assigned to members as copied snapshots, workout and set logs saved by the
-- member's phone (idempotent, editable for 24 h), personal-record detection,
-- trainer comments and reactions, and the coach overview with adherence.

-- ---------------------------------------------------------------------------
-- Helpers and settings
-- ---------------------------------------------------------------------------
-- Owner or an active trainer: may build exercises and programs.
create or replace function public.is_coach()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.auth_role() in ('owner', 'trainer') and public.auth_staff_id() is not null, false)
$$;

-- Owner, or the member's own trainer.
create or replace function public.can_coach_member(p_member_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.is_owner() or public.is_my_trainee(p_member_id)
$$;

create or replace function public.muscle_list()
returns text[]
language sql
immutable
as $$
  select array['abdominals', 'abductors', 'adductors', 'biceps', 'calves', 'chest', 'forearms', 'glutes',
               'hamstrings', 'lats', 'lower back', 'middle back', 'neck', 'quadriceps', 'shoulders',
               'traps', 'triceps']::text[]
$$;

create or replace function public.equipment_list()
returns text[]
language sql
immutable
as $$
  select array['barbell', 'dumbbell', 'cable', 'machine', 'kettlebells', 'bands', 'medicine ball',
               'exercise ball', 'foam roll', 'e-z curl bar', 'body only', 'other']::text[]
$$;

insert into public.settings (key, value) values
  -- "Equipment we have" (4.3): the owner switches off what the gym lacks.
  ('gym_equipment', to_jsonb(public.equipment_list())),
  -- Optional base URL for seeded exercise images (null = the Supabase
  -- "exercises" storage bucket; see README).
  ('exercise_image_base', 'null')
on conflict (key) do nothing;

-- What every signed-in user needs for the library.
create or replace function public.training_settings()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'equipment', coalesce((select value from public.settings where key = 'gym_equipment'), to_jsonb(public.equipment_list())),
    'image_base', (select value from public.settings where key = 'exercise_image_base'))
$$;

alter table public.member_events drop constraint if exists member_events_kind_check;
alter table public.member_events add constraint member_events_kind_check check (kind in (
  'joined','membership_started','renewed','frozen','unfrozen','cancelled','transferred_in','transferred_out',
  'note','profile_updated','pin_set','imported','archived','restored',
  'invoice_created','payment','payment_voided','refund','invoice_voided',
  'program_assigned','program_ended'));

-- ---------------------------------------------------------------------------
-- Exercises (4.1–4.8)
-- ---------------------------------------------------------------------------
create table public.exercises (
  id                uuid primary key default gen_random_uuid(),
  source_id         text unique,                    -- free-exercise-db id for seeded rows
  name              text not null check (length(trim(name)) between 2 and 120),
  local_name        text check (local_name is null or length(trim(local_name)) between 1 and 120),
  primary_muscles   text[] not null default '{}' check (primary_muscles <@ public.muscle_list()),
  secondary_muscles text[] not null default '{}' check (secondary_muscles <@ public.muscle_list()),
  equipment         text check (equipment is null or equipment = any (public.equipment_list())),
  level             text check (level in ('beginner', 'intermediate', 'expert')),
  category          text check (category in ('strength', 'stretching', 'cardio', 'plyometrics', 'powerlifting',
                                             'olympic weightlifting', 'strongman')),
  mechanic          text check (mechanic in ('compound', 'isolation')),
  force             text check (force in ('push', 'pull', 'static')),
  tracking_type     text not null default 'reps_weight'
                      check (tracking_type in ('reps_weight', 'reps', 'time', 'distance_time')),
  instructions      text[] not null default '{}' check (cardinality(instructions) <= 30),
  tips              text check (tips is null or length(tips) <= 2000),
  mistakes          text check (mistakes is null or length(mistakes) <= 2000),
  images            text[] not null default '{}' check (cardinality(images) <= 4),
  video_url         text check (video_url is null or video_url ~* '^https://(www\.|m\.)?(youtube\.com|youtu\.be)/'),
  is_custom         boolean not null default false,
  created_by        uuid references auth.users (id) on delete set null,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  archived_at       timestamptz
);
create trigger exercises_touch before update on public.exercises
  for each row execute function public.touch_updated_at();
create index exercises_updated on public.exercises (updated_at);
create index exercises_name_trgm on public.exercises using gin (name extensions.gin_trgm_ops);
create index exercises_local_trgm on public.exercises using gin (local_name extensions.gin_trgm_ops);
create index exercises_primary on public.exercises using gin (primary_muscles);

-- From the app, new rows are always custom and owned by the caller, and the
-- origin of a row can never be rewritten.
create or replace function public.exercises_guard()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user not in ('authenticated', 'anon') then return new; end if;
  if tg_op = 'INSERT' then
    new.is_custom := true;
    new.created_by := auth.uid();
    new.source_id := null;
  else
    new.is_custom := old.is_custom;
    new.created_by := old.created_by;
    new.source_id := old.source_id;
    new.created_at := old.created_at;
  end if;
  return new;
end;
$$;
create trigger exercises_guard before insert or update on public.exercises
  for each row execute function public.exercises_guard();

create table public.favourite_exercises (
  user_id     uuid not null references auth.users (id) on delete cascade,
  exercise_id uuid not null references public.exercises (id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, exercise_id)
);

-- ---------------------------------------------------------------------------
-- Templates, days and items (5.1–5.3)
-- A library template (is_gym_template) belongs to the gym. Assigning copies
-- it into a snapshot that only that member's program uses, so later edits to
-- the library never change a running program (and vice versa).
-- ---------------------------------------------------------------------------
create table public.workout_templates (
  id                 uuid primary key default gen_random_uuid(),
  name               text not null check (length(trim(name)) between 2 and 80),
  description        text check (description is null or length(description) <= 1000),
  goal               text check (goal in ('fat_loss', 'muscle_gain', 'strength', 'general_fitness', 'rehab')),
  level              text check (level in ('beginner', 'intermediate', 'advanced')),
  weeks              int not null default 4 check (weeks between 1 and 52),
  progression        text not null default 'none' check (progression in ('none', 'weight', 'reps')),
  progression_step   numeric(4,1) not null default 0 check (progression_step between 0 and 20),
  is_gym_template    boolean not null default true,
  is_starter         boolean not null default false,
  source_template_id uuid references public.workout_templates (id) on delete set null,
  created_by         uuid references auth.users (id) on delete set null,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  archived_at        timestamptz
);
create trigger workout_templates_touch before update on public.workout_templates
  for each row execute function public.touch_updated_at();

create table public.workout_days (
  id          uuid primary key default gen_random_uuid(),
  template_id uuid not null references public.workout_templates (id) on delete cascade,
  day_index   int not null check (day_index between 1 and 7),
  name        text not null check (length(trim(name)) between 1 and 60),
  notes       text check (notes is null or length(notes) <= 500),
  unique (template_id, day_index)
);

create table public.workout_items (
  id            uuid primary key default gen_random_uuid(),
  day_id        uuid not null references public.workout_days (id) on delete cascade,
  exercise_id   uuid not null references public.exercises (id),
  position      int not null check (position between 1 and 60),
  block         text not null default 'main' check (block in ('warmup', 'main', 'cooldown')),
  group_key     text check (group_key is null or group_key ~ '^[A-Z]$'),   -- superset / circuit
  sets          int not null default 3 check (sets between 1 and 20),
  reps          int check (reps between 1 and 100),
  reps_max      int check (reps_max between 1 and 100),
  duration_s    int check (duration_s between 1 and 7200),
  distance_m    int check (distance_m between 1 and 100000),
  target_weight numeric(6,2) check (target_weight between 0 and 1000),
  rpe           numeric(3,1) check (rpe between 1 and 10),
  rest_s        int not null default 60 check (rest_s between 0 and 900),
  tempo         text check (tempo is null or tempo ~ '^[0-9X]-[0-9X]-[0-9X](-[0-9X])?$'),
  notes         text check (notes is null or length(notes) <= 300),
  check (reps_max is null or reps is null or reps_max >= reps),
  unique (day_id, position)
);
create index workout_items_day on public.workout_items (day_id, position);

-- ---------------------------------------------------------------------------
-- Programs assigned to members (5.4)
-- ---------------------------------------------------------------------------
create table public.member_programs (
  id                 uuid primary key default gen_random_uuid(),
  member_id          uuid not null references public.members (id) on delete cascade,
  template_id        uuid not null unique references public.workout_templates (id),   -- the snapshot
  source_template_id uuid references public.workout_templates (id) on delete set null,
  name               text not null,
  start_date         date not null,
  end_date           date not null,
  weekdays           int[] not null check (cardinality(weekdays) between 1 and 7 and weekdays <@ array[1,2,3,4,5,6,7]),
  status             text not null default 'active' check (status in ('active', 'queued', 'completed', 'replaced', 'cancelled')),
  assigned_by        uuid references auth.users (id) on delete set null,
  assigned_at        timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  check (end_date >= start_date)
);
create trigger member_programs_touch before update on public.member_programs
  for each row execute function public.touch_updated_at();
create unique index member_programs_one_active on public.member_programs (member_id) where status = 'active';
create index member_programs_member on public.member_programs (member_id, start_date desc);

-- ---------------------------------------------------------------------------
-- Logs (5.6–5.10)
-- ---------------------------------------------------------------------------
create table public.workout_logs (
  id           uuid primary key default gen_random_uuid(),
  client_id    uuid not null unique,                 -- from the phone, so retries never duplicate
  member_id    uuid not null references public.members (id) on delete cascade,
  program_id   uuid references public.member_programs (id) on delete set null,
  day_id       uuid references public.workout_days (id) on delete set null,
  name         text not null check (length(trim(name)) between 1 and 80),
  started_at   timestamptz not null,
  finished_at  timestamptz not null,
  day          date not null,                        -- IST date of the start
  duration_s   int not null default 0 check (duration_s >= 0),
  total_volume numeric(10,1) not null default 0,     -- kg moved (weight × reps)
  status       text not null default 'completed' check (status in ('completed', 'partial')),
  notes        text check (notes is null or length(notes) <= 500),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  check (finished_at >= started_at)
);
create trigger workout_logs_touch before update on public.workout_logs
  for each row execute function public.touch_updated_at();
create index workout_logs_member on public.workout_logs (member_id, started_at desc);
create index workout_logs_program on public.workout_logs (program_id, day);

create table public.set_logs (
  id             uuid primary key default gen_random_uuid(),
  workout_log_id uuid not null references public.workout_logs (id) on delete cascade,
  member_id      uuid not null references public.members (id) on delete cascade,
  exercise_id    uuid not null references public.exercises (id),
  set_no         int not null check (set_no between 1 and 50),
  weight         numeric(6,2) check (weight between 0 and 1000),
  reps           int check (reps between 0 and 500),
  duration_s     int check (duration_s between 0 and 36000),
  distance_m     int check (distance_m between 0 and 200000),
  -- Estimated one-rep max (Epley), for PRs and the progress chart.
  e1rm           numeric(7,1) generated always as (
                   case when weight > 0 and reps between 1 and 30 then round(weight * (1 + reps / 30.0), 1) end) stored,
  is_pr          boolean not null default false,
  pr_kinds       text[] not null default '{}' check (pr_kinds <@ array['weight', 'reps', 'e1rm']),
  done_at        timestamptz not null default now(),
  unique (workout_log_id, exercise_id, set_no)
);
create index set_logs_member_exercise on public.set_logs (member_id, exercise_id);

create table public.workout_comments (
  id             uuid primary key default gen_random_uuid(),
  workout_log_id uuid not null references public.workout_logs (id) on delete cascade,
  author_id      uuid references auth.users (id) on delete set null,
  author_name    text not null,
  body           text check (body is null or length(trim(body)) between 1 and 500),
  emoji          text check (emoji in ('thumbs_up', 'fire', 'muscle', 'clap', 'star')),
  created_at     timestamptz not null default now(),
  check (body is not null or emoji is not null)
);
create index workout_comments_log on public.workout_comments (workout_log_id, created_at);

-- ---------------------------------------------------------------------------
-- Row Level Security. Reads use policies; every write to templates,
-- programs, logs and comments goes through the RPCs below.
-- ---------------------------------------------------------------------------
alter table public.exercises           enable row level security;
alter table public.favourite_exercises enable row level security;
alter table public.workout_templates   enable row level security;
alter table public.workout_days        enable row level security;
alter table public.workout_items       enable row level security;
alter table public.member_programs     enable row level security;
alter table public.workout_logs        enable row level security;
alter table public.set_logs            enable row level security;
alter table public.workout_comments    enable row level security;

create policy exercises_read on public.exercises for select to authenticated using (true);
create policy exercises_insert on public.exercises for insert to authenticated with check (public.is_coach());
create policy exercises_update on public.exercises for update to authenticated
  using (public.is_owner() or (public.is_coach() and is_custom and created_by = auth.uid()))
  with check (public.is_owner() or (public.is_coach() and is_custom and created_by = auth.uid()));

create policy favourites_own on public.favourite_exercises for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Who may read a template: staff for the library; for a program snapshot, the
-- member, the desk, and the member's trainer.
create or replace function public.can_read_template(p_template_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.workout_templates t where t.id = p_template_id and t.is_gym_template and public.is_staff())
      or exists (select 1 from public.member_programs mp
                 where mp.template_id = p_template_id
                   and (mp.member_id = public.auth_member_id() or public.is_desk() or public.is_my_trainee(mp.member_id)))
$$;

create policy templates_read on public.workout_templates for select to authenticated
  using (public.can_read_template(id));
create policy days_read on public.workout_days for select to authenticated
  using (public.can_read_template(template_id));
create policy items_read on public.workout_items for select to authenticated
  using (exists (select 1 from public.workout_days d where d.id = day_id and public.can_read_template(d.template_id)));
create policy programs_read on public.member_programs for select to authenticated
  using (member_id = public.auth_member_id() or public.is_desk() or public.is_my_trainee(member_id));
-- Logs are body data (DPDP): the member, the owner and their trainer only.
create policy logs_read on public.workout_logs for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));
create policy set_logs_read on public.set_logs for select to authenticated
  using (member_id = public.auth_member_id() or public.can_coach_member(member_id));
create policy comments_read on public.workout_comments for select to authenticated
  using (exists (select 1 from public.workout_logs l where l.id = workout_log_id
                 and (l.member_id = public.auth_member_id() or public.can_coach_member(l.member_id))));

-- ---------------------------------------------------------------------------
-- Templates: save (create or replace days and items), duplicate, archive
-- ---------------------------------------------------------------------------
create or replace function public._write_days(p_template_id uuid, p_days jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_day   jsonb;
  v_item  jsonb;
  v_day_id uuid;
  v_n     int := 0;
  v_pos   int;
begin
  if jsonb_typeof(p_days) <> 'array' or jsonb_array_length(p_days) not between 1 and 7 then
    raise exception 'a program needs 1 to 7 days' using errcode = '22023';
  end if;
  delete from public.workout_days where template_id = p_template_id;
  for v_day in select * from jsonb_array_elements(p_days) loop
    v_n := v_n + 1;
    if jsonb_array_length(coalesce(v_day -> 'items', '[]')) not between 1 and 40 then
      raise exception 'each day needs 1 to 40 exercises' using errcode = '22023';
    end if;
    insert into public.workout_days (template_id, day_index, name, notes)
    values (p_template_id, v_n, coalesce(nullif(trim(v_day ->> 'name'), ''), 'Day ' || v_n), nullif(trim(v_day ->> 'notes'), ''))
    returning id into v_day_id;
    v_pos := 0;
    for v_item in select * from jsonb_array_elements(v_day -> 'items') loop
      v_pos := v_pos + 1;
      if not exists (select 1 from public.exercises where id = (v_item ->> 'exercise_id')::uuid) then
        raise exception 'unknown exercise' using errcode = '22023';
      end if;
      insert into public.workout_items (day_id, exercise_id, position, block, group_key, sets, reps, reps_max,
                                        duration_s, distance_m, target_weight, rpe, rest_s, tempo, notes)
      values (v_day_id, (v_item ->> 'exercise_id')::uuid, v_pos, coalesce(v_item ->> 'block', 'main'),
              nullif(v_item ->> 'group_key', ''), coalesce((v_item ->> 'sets')::int, 3), (v_item ->> 'reps')::int,
              (v_item ->> 'reps_max')::int, (v_item ->> 'duration_s')::int, (v_item ->> 'distance_m')::int,
              (v_item ->> 'target_weight')::numeric, (v_item ->> 'rpe')::numeric, coalesce((v_item ->> 'rest_s')::int, 60),
              nullif(v_item ->> 'tempo', ''), nullif(trim(v_item ->> 'notes'), ''));
    end loop;
  end loop;
end;
$$;
revoke execute on function public._write_days(uuid, jsonb) from public, anon, authenticated;

-- May the caller edit this template? Library: owner or its author.
-- Snapshot: owner or the member's trainer.
create or replace function public._can_edit_template(p_template_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.workout_templates t
                 where t.id = p_template_id and t.archived_at is null and t.is_gym_template
                   and (public.is_owner() or (public.is_coach() and t.created_by = auth.uid())))
      or exists (select 1 from public.member_programs mp
                 where mp.template_id = p_template_id and public.can_coach_member(mp.member_id))
$$;

-- { id?, name, description, goal, level, weeks, progression, progression_step,
--   days: [{ name, notes, items: [{ exercise_id, block, group_key, sets, reps,
--   reps_max, duration_s, distance_m, target_weight, rpe, rest_s, tempo, notes }] }] }
create or replace function public.save_template(p jsonb)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid := (p ->> 'id')::uuid;
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  if v_id is null then
    insert into public.workout_templates (name, description, goal, level, weeks, progression, progression_step,
                                          is_gym_template, created_by)
    values (trim(p ->> 'name'), nullif(trim(p ->> 'description'), ''), p ->> 'goal', p ->> 'level',
            coalesce((p ->> 'weeks')::int, 4), coalesce(p ->> 'progression', 'none'),
            coalesce((p ->> 'progression_step')::numeric, 0), true, auth.uid())
    returning id into v_id;
  else
    if not public._can_edit_template(v_id) then raise exception 'not allowed' using errcode = '42501'; end if;
    update public.workout_templates
       set name = trim(p ->> 'name'), description = nullif(trim(p ->> 'description'), ''), goal = p ->> 'goal',
           level = p ->> 'level', weeks = coalesce((p ->> 'weeks')::int, weeks),
           progression = coalesce(p ->> 'progression', progression),
           progression_step = coalesce((p ->> 'progression_step')::numeric, progression_step)
     where id = v_id;
    -- A running program's end date follows its new length.
    update public.member_programs set end_date = start_date + (coalesce((p ->> 'weeks')::int, 4) * 7 - 1)
     where template_id = v_id;
  end if;
  perform public._write_days(v_id, p -> 'days');
  -- A snapshot keeps its weekday plan aligned with its number of days.
  update public.member_programs mp
     set weekdays = public.default_weekdays(jsonb_array_length(p -> 'days'))
   where mp.template_id = v_id and cardinality(mp.weekdays) <> jsonb_array_length(p -> 'days');
  return v_id;
end;
$$;

-- Mon/Wed/Fri for 3 days, Mon/Tue/Thu/Fri for 4, and so on.
create or replace function public.default_weekdays(p_days int)
returns int[]
language sql
immutable
as $$
  select case p_days
    when 1 then array[1] when 2 then array[1, 4] when 3 then array[1, 3, 5] when 4 then array[1, 2, 4, 5]
    when 5 then array[1, 2, 3, 4, 5] when 6 then array[1, 2, 3, 4, 5, 6] else array[1, 2, 3, 4, 5, 6, 7] end
$$;

create or replace function public._copy_template(p_src uuid, p_name text, p_library boolean)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_new uuid;
  v_day record;
  v_day_id uuid;
begin
  insert into public.workout_templates (name, description, goal, level, weeks, progression, progression_step,
                                        is_gym_template, source_template_id, created_by)
  select coalesce(nullif(trim(p_name), ''), t.name), t.description, t.goal, t.level, t.weeks, t.progression,
         t.progression_step, p_library, t.id, auth.uid()
  from public.workout_templates t where t.id = p_src
  returning id into v_new;
  for v_day in select * from public.workout_days where template_id = p_src order by day_index loop
    insert into public.workout_days (template_id, day_index, name, notes)
    values (v_new, v_day.day_index, v_day.name, v_day.notes) returning id into v_day_id;
    insert into public.workout_items (day_id, exercise_id, position, block, group_key, sets, reps, reps_max,
                                      duration_s, distance_m, target_weight, rpe, rest_s, tempo, notes)
    select v_day_id, exercise_id, position, block, group_key, sets, reps, reps_max, duration_s, distance_m,
           target_weight, rpe, rest_s, tempo, notes
    from public.workout_items where day_id = v_day.id;
  end loop;
  return v_new;
end;
$$;
revoke execute on function public._copy_template(uuid, text, boolean) from public, anon, authenticated;

-- Duplicate a library template, or save a member's tuned program back to the
-- library.
create or replace function public.duplicate_template(p_template_id uuid, p_name text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_coach() or not public.can_read_template(p_template_id) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  return public._copy_template(p_template_id, p_name, true);
end;
$$;

create or replace function public.archive_template(p_template_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (select 1 from public.workout_templates where id = p_template_id and is_gym_template)
     or not public._can_edit_template(p_template_id) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  update public.workout_templates set archived_at = now() where id = p_template_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Programs: assign (replace or queue), end, nightly refresh
-- ---------------------------------------------------------------------------
create or replace function public.refresh_programs()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := public.ist_today();
  v_n int := 0;
  v_c int;
begin
  update public.member_programs set status = 'completed' where status = 'active' and end_date < v_today;
  get diagnostics v_c = row_count; v_n := v_n + v_c;
  -- A queued program starts on its day, once nothing else is running.
  update public.member_programs q set status = 'active'
   where q.status = 'queued' and q.start_date <= v_today
     and not exists (select 1 from public.member_programs a where a.member_id = q.member_id and a.status = 'active')
     and q.id = (select q2.id from public.member_programs q2 where q2.member_id = q.member_id and q2.status = 'queued'
                 order by q2.start_date, q2.assigned_at limit 1);
  get diagnostics v_c = row_count; v_n := v_n + v_c;
  return v_n;
end;
$$;
revoke execute on function public.refresh_programs() from public, anon, authenticated;

-- p_mode 'replace': the current program stops (now, or the day before the new
-- start). 'queue': the new one starts the day after the current one ends.
create or replace function public.assign_program(
  p_template_id uuid,
  p_member_ids uuid[],
  p_start date default null,
  p_weekdays int[] default null,
  p_mode text default 'replace'
) returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_t        public.workout_templates%rowtype;
  v_days     int;
  v_weekdays int[];
  v_member   uuid;
  v_current  public.member_programs%rowtype;
  v_start    date;
  v_status   text;
  v_snapshot uuid;
  v_today    date := public.ist_today();
  v_n        int := 0;
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  if p_mode not in ('replace', 'queue') then raise exception 'mode must be replace or queue' using errcode = '22023'; end if;
  select * into v_t from public.workout_templates where id = p_template_id and archived_at is null;
  if not found or not public.can_read_template(p_template_id) then
    raise exception 'template not found' using errcode = 'P0002';
  end if;
  select count(*) into v_days from public.workout_days where template_id = p_template_id;
  if v_days = 0 then raise exception 'this template has no days' using errcode = '22023'; end if;
  v_weekdays := coalesce(p_weekdays, public.default_weekdays(v_days));
  if cardinality(v_weekdays) <> v_days
     or (select count(distinct w) from unnest(v_weekdays) w) <> v_days
     or not (v_weekdays <@ array[1,2,3,4,5,6,7]) then
    raise exception 'pick % different weekdays', v_days using errcode = '22023';
  end if;
  if coalesce(cardinality(p_member_ids), 0) = 0 then raise exception 'pick at least one member' using errcode = '22023'; end if;
  if p_start is not null and p_start < v_today - 7 then
    raise exception 'start date is too far in the past' using errcode = '22023';
  end if;

  foreach v_member in array p_member_ids loop
    if not public.can_coach_member(v_member) then raise exception 'not allowed' using errcode = '42501'; end if;
    perform 1 from public.members where id = v_member and archived_at is null;
    if not found then raise exception 'member not found' using errcode = 'P0002'; end if;
    v_start := coalesce(p_start, v_today);
    select * into v_current from public.member_programs
     where member_id = v_member and status = 'active' for update;
    if found then
      if p_mode = 'queue' then
        v_start := greatest(v_start, v_current.end_date + 1);
      elsif v_start <= v_today then
        update public.member_programs set status = 'replaced', end_date = greatest(start_date, v_today - 1)
         where id = v_current.id;
        perform public.log_member_event(v_member, 'program_ended', v_current.name || ' replaced',
                                        jsonb_build_object('program_id', v_current.id));
      else
        update public.member_programs set end_date = greatest(start_date, v_start - 1) where id = v_current.id;
      end if;
    end if;
    -- Replacing a queued program too, when not queueing.
    if p_mode = 'replace' then
      update public.member_programs set status = 'cancelled' where member_id = v_member and status = 'queued';
    end if;
    v_status := case when v_start <= v_today
                      and not exists (select 1 from public.member_programs where member_id = v_member and status = 'active')
                     then 'active' else 'queued' end;
    v_snapshot := public._copy_template(p_template_id, v_t.name, false);
    insert into public.member_programs (member_id, template_id, source_template_id, name, start_date, end_date,
                                        weekdays, status, assigned_by)
    values (v_member, v_snapshot, p_template_id, v_t.name, v_start, v_start + (v_t.weeks * 7 - 1),
            v_weekdays, v_status, auth.uid());
    perform public.log_member_event(v_member, 'program_assigned', v_t.name || ' from ' || to_char(v_start, 'DD Mon'),
                                    jsonb_build_object('template_id', p_template_id, 'start', v_start, 'status', v_status));
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;

create or replace function public.end_program(p_program_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_p public.member_programs%rowtype;
begin
  select * into v_p from public.member_programs where id = p_program_id and status in ('active', 'queued') for update;
  if not found then raise exception 'program not found' using errcode = 'P0002'; end if;
  if not public.can_coach_member(v_p.member_id) then raise exception 'not allowed' using errcode = '42501'; end if;
  update public.member_programs
     set status = 'cancelled', end_date = greatest(start_date, least(end_date, public.ist_today()))
   where id = p_program_id;
  perform public.log_member_event(v_p.member_id, 'program_ended', v_p.name || ' ended', jsonb_build_object('program_id', v_p.id));
  perform public.refresh_programs();
end;
$$;

-- ---------------------------------------------------------------------------
-- Workout logs: saved from the phone (5.6, 5.7), PRs (5.9)
-- ---------------------------------------------------------------------------
-- Marks the best set per kind for each exercise in a log when it beats every
-- earlier workout: heaviest weight, best estimated 1RM, and more reps than
-- ever at that weight or heavier (or more reps for a bodyweight exercise).
-- A first-ever log of an exercise sets the baseline (no PR).
create or replace function public._detect_prs(p_log_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_log  public.workout_logs%rowtype;
  v_ex   uuid;
  v_prev record;
  v_id   uuid;
begin
  select * into v_log from public.workout_logs where id = p_log_id;
  update public.set_logs set is_pr = false, pr_kinds = '{}' where workout_log_id = p_log_id;
  for v_ex in select distinct exercise_id from public.set_logs where workout_log_id = p_log_id loop
    select max(s.weight) as weight, max(s.e1rm) as e1rm, count(*) as n
      into v_prev
      from public.set_logs s join public.workout_logs l on l.id = s.workout_log_id
     where s.member_id = v_log.member_id and s.exercise_id = v_ex and s.workout_log_id <> p_log_id
       and l.started_at < v_log.started_at;
    continue when v_prev.n = 0;

    select id into v_id from public.set_logs
     where workout_log_id = p_log_id and exercise_id = v_ex and weight > 0 and reps > 0
       and weight > coalesce(v_prev.weight, 0)
     order by weight desc, reps desc, set_no limit 1;
    if v_id is not null then
      update public.set_logs set is_pr = true, pr_kinds = array_append(pr_kinds, 'weight') where id = v_id;
    end if;

    v_id := null;
    select id into v_id from public.set_logs
     where workout_log_id = p_log_id and exercise_id = v_ex and e1rm > coalesce(v_prev.e1rm, 0)
     order by e1rm desc, set_no limit 1;
    if v_id is not null then
      update public.set_logs set is_pr = true, pr_kinds = array_append(pr_kinds, 'e1rm') where id = v_id;
    end if;

    v_id := null;
    select s.id into v_id from public.set_logs s
     where s.workout_log_id = p_log_id and s.exercise_id = v_ex and s.reps > 0
       and s.reps > (select max(p.reps) from public.set_logs p join public.workout_logs l on l.id = p.workout_log_id
                     where p.member_id = v_log.member_id and p.exercise_id = v_ex and p.workout_log_id <> p_log_id
                       and l.started_at < v_log.started_at and coalesce(p.weight, 0) >= coalesce(s.weight, 0))
     order by coalesce(s.weight, 0) desc, s.reps desc, s.set_no limit 1;
    if v_id is not null then
      update public.set_logs set is_pr = true, pr_kinds = array_append(pr_kinds, 'reps') where id = v_id;
    end if;
  end loop;
end;
$$;
revoke execute on function public._detect_prs(uuid) from public, anon, authenticated;

-- { client_id, program_id?, day_id?, name, started_at, finished_at, status,
--   notes, sets: [{ exercise_id, set_no, weight, reps, duration_s,
--   distance_m, done_at }] }  → { log_id, total_volume, prs: [...] }
-- The same client_id again replaces the log (retries, edits within 24 h).
create or replace function public.save_workout_log(p jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member   uuid := public.auth_member_id();
  v_client   uuid := (p ->> 'client_id')::uuid;
  v_program  uuid := (p ->> 'program_id')::uuid;
  v_day      uuid := (p ->> 'day_id')::uuid;
  v_started  timestamptz := (p ->> 'started_at')::timestamptz;
  v_finished timestamptz := (p ->> 'finished_at')::timestamptz;
  v_existing public.workout_logs%rowtype;
  v_log      uuid;
  v_set      jsonb;
  v_volume   numeric;
begin
  if v_member is null or public.auth_role() <> 'member' then raise exception 'not allowed' using errcode = '42501'; end if;
  if v_client is null or v_started is null or v_finished is null then
    raise exception 'missing workout details' using errcode = '22023';
  end if;
  if v_finished < v_started or v_finished > now() + interval '1 hour' or v_started < now() - interval '30 days'
     or v_finished - v_started > interval '6 hours' then
    raise exception 'workout times look wrong' using errcode = '22023';
  end if;
  if jsonb_array_length(coalesce(p -> 'sets', '[]')) > 300 then
    raise exception 'too many sets' using errcode = '22023';
  end if;
  if v_program is not null and not exists (select 1 from public.member_programs where id = v_program and member_id = v_member) then
    raise exception 'program not found' using errcode = 'P0002';
  end if;
  if v_day is not null and not exists (select 1 from public.workout_days d join public.member_programs mp on mp.template_id = d.template_id
                                       where d.id = v_day and mp.id = v_program) then
    raise exception 'workout day not found' using errcode = 'P0002';
  end if;

  select * into v_existing from public.workout_logs where client_id = v_client for update;
  if found then
    if v_existing.member_id <> v_member then raise exception 'not allowed' using errcode = '42501'; end if;
    if v_existing.finished_at < now() - interval '24 hours' then
      raise exception 'workouts can be edited for 24 hours' using errcode = '22023';
    end if;
    v_log := v_existing.id;
    delete from public.set_logs where workout_log_id = v_log;
    update public.workout_logs
       set program_id = v_program, day_id = v_day, name = coalesce(nullif(trim(p ->> 'name'), ''), name),
           started_at = v_started, finished_at = v_finished, day = (v_started at time zone 'Asia/Kolkata')::date,
           duration_s = extract(epoch from v_finished - v_started)::int,
           status = coalesce(p ->> 'status', 'completed'), notes = nullif(trim(p ->> 'notes'), '')
     where id = v_log;
  else
    insert into public.workout_logs (client_id, member_id, program_id, day_id, name, started_at, finished_at, day,
                                     duration_s, status, notes)
    values (v_client, v_member, v_program, v_day, coalesce(nullif(trim(p ->> 'name'), ''), 'Workout'), v_started, v_finished,
            (v_started at time zone 'Asia/Kolkata')::date, extract(epoch from v_finished - v_started)::int,
            coalesce(p ->> 'status', 'completed'), nullif(trim(p ->> 'notes'), ''))
    returning id into v_log;
  end if;

  for v_set in select * from jsonb_array_elements(coalesce(p -> 'sets', '[]')) loop
    insert into public.set_logs (workout_log_id, member_id, exercise_id, set_no, weight, reps, duration_s, distance_m, done_at)
    values (v_log, v_member, (v_set ->> 'exercise_id')::uuid, (v_set ->> 'set_no')::int, (v_set ->> 'weight')::numeric,
            (v_set ->> 'reps')::int, (v_set ->> 'duration_s')::int, (v_set ->> 'distance_m')::int,
            coalesce((v_set ->> 'done_at')::timestamptz, v_finished));
  end loop;

  select coalesce(sum(weight * reps), 0) into v_volume from public.set_logs where workout_log_id = v_log;
  update public.workout_logs set total_volume = v_volume where id = v_log;
  perform public._detect_prs(v_log);

  return jsonb_build_object(
    'log_id', v_log,
    'total_volume', v_volume,
    'prs', coalesce((select jsonb_agg(jsonb_build_object('exercise_id', exercise_id, 'set_no', set_no, 'kinds', pr_kinds,
                                                         'weight', weight, 'reps', reps, 'e1rm', e1rm))
                     from public.set_logs where workout_log_id = v_log and is_pr), '[]'::jsonb));
end;
$$;

-- Trainer feedback (5.10): a comment and/or a reaction.
create or replace function public.comment_workout(p_log_id uuid, p_body text default null, p_emoji text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid;
  v_name   text;
  v_id     uuid;
begin
  select member_id into v_member from public.workout_logs where id = p_log_id;
  if not found then raise exception 'workout not found' using errcode = 'P0002'; end if;
  if not public.can_coach_member(v_member) then raise exception 'not allowed' using errcode = '42501'; end if;
  select name into v_name from public.profiles where id = auth.uid();
  insert into public.workout_comments (workout_log_id, author_id, author_name, body, emoji)
  values (p_log_id, auth.uid(), coalesce(v_name, 'Coach'), nullif(trim(p_body), ''), p_emoji)
  returning id into v_id;
  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Adherence and the coach overview (5.5)
-- ---------------------------------------------------------------------------
-- Share of planned sessions (on the program's weekdays) in the last p_days
-- that have a workout logged. Null when nothing was planned yet.
create or replace function public.program_adherence(p_program_id uuid, p_days int default 28)
returns numeric
language sql
stable
security definer
set search_path = public
as $$
  with p as (
    select mp.*, greatest(mp.start_date, public.ist_today() - (p_days - 1)) as w_from,
           least(mp.end_date, public.ist_today()) as w_to
    from public.member_programs mp where mp.id = p_program_id
  ), planned as (
    select count(*)::numeric as n from p, generate_series(p.w_from, p.w_to, interval '1 day') d
    where extract(isodow from d)::int = any (p.weekdays)
  ), done as (
    select count(distinct l.day)::numeric as n from p join public.workout_logs l on l.program_id = p.id
    where l.day between p.w_from and p.w_to
  )
  select case when planned.n > 0 then round(least(done.n, planned.n) / planned.n, 2) end from planned, done
$$;
revoke execute on function public.program_adherence(uuid, int) from public, anon;

create or replace function public.coach_overview(
  p_trainer_id uuid default null,
  p_search text default '',
  p_offset int default 0,
  p_limit int default 30
) returns table (
  member_id uuid, name text, member_code text, photo_url text, trainer_id uuid, status text,
  program_id uuid, program_name text, program_status text, program_start date, program_end date,
  last_workout_at timestamptz, workouts_7d int, adherence numeric,
  planned_today boolean, done_today boolean, missed_7d int
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_coach() then raise exception 'not allowed' using errcode = '42501'; end if;
  return query
  select m.id, m.name, m.member_code, m.photo_url, m.trainer_id, m.status,
         mp.id, mp.name, mp.status, mp.start_date, mp.end_date,
         (select max(l.finished_at) from public.workout_logs l where l.member_id = m.id),
         (select count(*)::int from public.workout_logs l where l.member_id = m.id and l.day > public.ist_today() - 7),
         case when mp.id is null then null else public.program_adherence(mp.id) end,
         coalesce(mp.status = 'active' and public.ist_today() between mp.start_date and mp.end_date
                  and extract(isodow from public.ist_today())::int = any (mp.weekdays), false),
         exists (select 1 from public.workout_logs l where l.member_id = m.id and l.day = public.ist_today()),
         -- Planned sessions in the last 7 days (before today) with no workout.
         case when mp.status = 'active' then
           (select count(*)::int from generate_series(greatest(mp.start_date, public.ist_today() - 7), public.ist_today() - 1,
                                                       interval '1 day') d
            where extract(isodow from d)::int = any (mp.weekdays)
              and not exists (select 1 from public.workout_logs l where l.member_id = m.id and l.day = d::date))
         else 0 end
  from public.members m
  left join lateral (select * from public.member_programs x
                     where x.member_id = m.id and x.status in ('active', 'queued')
                     order by (x.status = 'active') desc, x.start_date limit 1) mp on true
  where m.archived_at is null
    and (case when public.is_owner() then (p_trainer_id is null or m.trainer_id = p_trainer_id)
              else m.trainer_id = public.auth_staff_id() end)
    and (coalesce(trim(p_search), '') = '' or m.name ilike '%' || trim(p_search) || '%'
         or m.member_code ilike '%' || trim(p_search) || '%')
  order by (mp.id is null) desc, m.name
  offset greatest(p_offset, 0) limit least(greatest(p_limit, 1), 100);
end;
$$;

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------
grant execute on function
  public.is_coach(), public.training_settings(), public.can_read_template(uuid),
  public.save_template(jsonb), public.duplicate_template(uuid, text), public.archive_template(uuid),
  public.assign_program(uuid, uuid[], date, int[], text), public.end_program(uuid),
  public.save_workout_log(jsonb), public.comment_workout(uuid, text, text),
  public.program_adherence(uuid, int), public.coach_overview(uuid, text, int, int), public.default_weekdays(int)
to authenticated;
revoke execute on function
  public.is_coach(), public.training_settings(), public.can_read_template(uuid), public.save_template(jsonb),
  public.duplicate_template(uuid, text), public.archive_template(uuid),
  public.assign_program(uuid, uuid[], date, int[], text), public.end_program(uuid),
  public.save_workout_log(jsonb), public.comment_workout(uuid, text, text), public.coach_overview(uuid, text, int, int)
from anon;

-- ---------------------------------------------------------------------------
-- Platform pieces when available: nightly program refresh (00:15 IST =
-- 18:45 UTC) and a public bucket for exercise images:
--   <source_id>/0.jpg (seeded, mirrored by scripts/mirror_exercise_images.sh)
--   custom/<exercise_id>/0.jpg (trainer photos)
-- ---------------------------------------------------------------------------
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.schedule('refresh_programs', '45 18 * * *', 'select public.refresh_programs()');
  end if;
  if exists (select 1 from pg_namespace where nspname = 'storage') then
    insert into storage.buckets (id, name, public) values ('exercises', 'exercises', true)
    on conflict (id) do nothing;
    if exists (select 1 from information_schema.columns
               where table_schema = 'storage' and table_name = 'buckets' and column_name = 'file_size_limit') then
      execute $u$update storage.buckets set file_size_limit = 5242880,
                 allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp'] where id = 'exercises'$u$;
    end if;
    execute $p$create policy exercises_media_write on storage.objects for insert to authenticated
      with check (bucket_id = 'exercises' and public.is_coach() and (storage.foldername(name))[1] = 'custom')$p$;
    execute $p$create policy exercises_media_update on storage.objects for update to authenticated
      using (bucket_id = 'exercises' and public.is_coach() and (storage.foldername(name))[1] = 'custom')$p$;
    execute $p$create policy exercises_media_delete on storage.objects for delete to authenticated
      using (bucket_id = 'exercises' and public.is_owner())$p$;
  end if;
end $$;
