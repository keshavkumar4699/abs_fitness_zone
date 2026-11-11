-- M3 tests: exercise catalogue and seed, custom exercises, favourites,
-- templates, assigning programs (replace / queue), workout logs (idempotent,
-- 24 h edits), personal records, comments, adherence, coach overview, RLS.

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

-- A workout log payload: sets as (source_id, weight, reps) triples.
create or replace function pg_temp.log(p_client uuid, p_program uuid, p_minutes_ago int, p_sets jsonb) returns jsonb
language sql as $$
  select jsonb_build_object(
    'client_id', p_client, 'program_id', p_program, 'name', 'Test workout',
    'started_at', now() - make_interval(mins => p_minutes_ago),
    'finished_at', now() - make_interval(mins => greatest(p_minutes_ago - 45, 0)),
    'status', 'completed',
    'sets', (select jsonb_agg(jsonb_build_object(
               'exercise_id', (select id from public.exercises where source_id = s ->> 0),
               'set_no', n, 'weight', (s ->> 1)::numeric, 'reps', (s ->> 2)::int))
             from jsonb_array_elements(p_sets) with ordinality as t(s, n)))
$$;

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
insert into public.members (id, name, phone, trainer_id) values
  ('20000000-0000-0000-0000-000000000001', 'Riya Sen', '+919876500011', '10000000-0000-0000-0000-00000000000c'),
  ('20000000-0000-0000-0000-000000000002', 'Kabir Das', '+919876500012', '10000000-0000-0000-0000-00000000000d');
insert into public.profiles (id, role, member_id, name) values
  ('00000000-0000-0000-0000-00000000000e', 'member', '20000000-0000-0000-0000-000000000001', 'Riya Sen'),
  ('00000000-0000-0000-0000-00000000000f', 'member', '20000000-0000-0000-0000-000000000002', 'Kabir Das');

create temp table ids as
select '20000000-0000-0000-0000-000000000001'::uuid riya, '20000000-0000-0000-0000-000000000002'::uuid kabir,
       (select id from public.workout_templates where name = 'Push / Pull / Legs' and is_gym_template) ppl,
       (select id from public.workout_templates where name = 'Muscle gain 4-day' and is_gym_template) mg4;
grant select on ids to authenticated, anon;

-- ---------- seed (4.1, 5.3) ----------
select pg_temp.check((select count(*) from public.exercises where source_id is not null) = 876, 'seed: 876 exercises from free-exercise-db');
select pg_temp.check((select count(*) from public.exercises where cardinality(images) = 2) = 873, 'seed: two images per exercise (3 in the dataset have none)');
select pg_temp.check((select count(*) from public.exercises where cardinality(instructions) > 0) > 800, 'seed: instructions included');
select pg_temp.check((select tracking_type from public.exercises where source_id = 'Plank') = 'time', 'tracking: plank is timed');
select pg_temp.check((select tracking_type from public.exercises where source_id = 'Barbell_Squat') = 'reps_weight', 'tracking: squat is reps + weight');
select pg_temp.check((select tracking_type from public.exercises where source_id = 'Pushups') = 'reps', 'tracking: push-ups are reps only');
select pg_temp.check((select tracking_type from public.exercises where source_id = 'Running_Treadmill') = 'distance_time', 'tracking: treadmill is distance + time');
select pg_temp.check((select count(*) from public.workout_templates where is_starter) = 6, 'seed: six starter templates');
select pg_temp.check((select count(*) from public.workout_days where template_id = (select mg4 from ids)) = 4, 'seed: muscle gain has 4 days');
select pg_temp.check(not exists (select 1 from public.workout_days d where not exists (select 1 from public.workout_items i where i.day_id = d.id)),
                     'seed: every day has exercises');
select pg_temp.check((select count(*) from public.workout_items i join public.workout_days d on d.id = i.day_id
                      where d.template_id = (select mg4 from ids) and group_key = 'A') = 2, 'seed: supersets are grouped');

-- ---------- library access ----------
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) from public.exercises) >= 876, 'member: reads the catalogue');
select pg_temp.check(jsonb_array_length(public.training_settings() -> 'equipment') = 12, 'member: reads the equipment list');
select pg_temp.raises($$insert into public.exercises (name) values ('Member move')$$, 'member: cannot add exercises');
select pg_temp.check((select count(*) from public.workout_templates) = 0, 'member: cannot browse the template library');
insert into public.favourite_exercises (user_id, exercise_id)
select auth.uid(), id from public.exercises where source_id = 'Barbell_Squat';
select pg_temp.check((select count(*) from public.favourite_exercises) = 1, 'member: stars an exercise');
select pg_temp.raises($$insert into public.favourite_exercises (user_id, exercise_id)
  select '00000000-0000-0000-0000-00000000000f', id from public.exercises limit 1$$, 'member: cannot star for someone else');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((select count(*) from public.favourite_exercises) = 0, 'favourites are private');

-- Custom exercises (4.5).
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
insert into public.exercises (name, local_name, primary_muscles, equipment, tracking_type, source_id, is_custom, video_url)
values ('ABS band walk', 'बैंड वॉक', array['glutes'], 'bands', 'reps', 'Barbell_Squat_fake', false, 'https://youtu.be/abc123');
select pg_temp.check((select is_custom and created_by = '00000000-0000-0000-0000-00000000000c' and source_id is null
                      from public.exercises where name = 'ABS band walk'), 'trainer: custom exercises are marked and owned');
update public.exercises set tips = 'Knees out' where name = 'ABS band walk';
select pg_temp.check((select tips from public.exercises where name = 'ABS band walk') = 'Knees out', 'trainer: edits own exercise');
update public.exercises set name = 'Hacked' where source_id = 'Barbell_Squat';
select pg_temp.check((select name from public.exercises where source_id = 'Barbell_Squat') = 'Barbell Squat', 'trainer: cannot edit the seeded catalogue');
select pg_temp.raises($$insert into public.exercises (name, primary_muscles) values ('Bad', array['spleen'])$$, 'unknown muscles are refused');
select pg_temp.raises($$insert into public.exercises (name, video_url) values ('Bad link', 'https://example.com/v')$$, 'videos must be YouTube links');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
update public.exercises set tips = 'Mine now' where name = 'ABS band walk';
select pg_temp.check((select tips from public.exercises where name = 'ABS band walk') = 'Knees out', 'trainer: cannot edit another trainer''s exercise');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$insert into public.exercises (name) values ('Desk move')$$, 'desk: cannot add exercises');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
update public.exercises set local_name = 'बारबेल स्क्वाट', source_id = 'changed' where source_id = 'Barbell_Squat';
select pg_temp.check((select local_name from public.exercises where source_id = 'Barbell_Squat') = 'बारबेल स्क्वाट',
                     'owner: adds a Hindi name to a seeded exercise (and cannot change its origin)');

-- ---------- templates (5.1–5.3) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.workout_templates) >= 6, 'desk: reads the template library');
select pg_temp.raises($$select public.save_template('{"name": "Desk plan", "days": []}')$$, 'desk: cannot build programs');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
create temp table t_custom as
select public.save_template(jsonb_build_object(
  'name', 'Vikram 2-day', 'goal', 'strength', 'level', 'beginner', 'weeks', 4, 'progression', 'weight', 'progression_step', 2.5,
  'days', jsonb_build_array(
    jsonb_build_object('name', 'Lower', 'items', jsonb_build_array(
      jsonb_build_object('exercise_id', (select id from public.exercises where source_id = 'Barbell_Squat'), 'sets', 3, 'reps', 5, 'target_weight', 40, 'rest_s', 120),
      jsonb_build_object('exercise_id', (select id from public.exercises where source_id = 'Plank'), 'sets', 3, 'duration_s', 30))),
    jsonb_build_object('name', 'Upper', 'items', jsonb_build_array(
      jsonb_build_object('exercise_id', (select id from public.exercises where source_id = 'Pushups'), 'sets', 3, 'reps', 10, 'group_key', 'A'),
      jsonb_build_object('exercise_id', (select id from public.exercises where source_id = 'Pullups'), 'sets', 3, 'reps', 6, 'reps_max', 10, 'group_key', 'A')))))) as id;
grant select on t_custom to authenticated;
select pg_temp.check((select count(*) from public.workout_days where template_id = (select id from t_custom)) = 2, 'trainer: builds a 2-day template');
select pg_temp.check((select position from public.workout_items i join public.workout_days d on d.id = i.day_id
                      where d.template_id = (select id from t_custom) and d.day_index = 2
                        and i.exercise_id = (select id from public.exercises where source_id = 'Pullups')) = 2,
                     'items keep their order');
select pg_temp.raises($$select public.save_template('{"name": "Empty", "days": []}')$$, 'a template needs at least one day');
select pg_temp.raises($$select public.save_template(jsonb_build_object('name', 'Ghost', 'days', jsonb_build_array(
  jsonb_build_object('name', 'X', 'items', jsonb_build_array(jsonb_build_object('exercise_id', gen_random_uuid()))))))$$,
  'unknown exercises are refused');
select pg_temp.raises($$select public.save_template(jsonb_build_object('name', 'Too many sets', 'days', jsonb_build_array(
  jsonb_build_object('name', 'X', 'items', jsonb_build_array(jsonb_build_object(
    'exercise_id', (select id from public.exercises where source_id = 'Plank'), 'sets', 50))))))$$,
  'set counts are checked');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.raises($$select public.save_template(jsonb_build_object('id', (select id from t_custom), 'name', 'Taken over',
  'days', jsonb_build_array(jsonb_build_object('name', 'X', 'items', jsonb_build_array(jsonb_build_object(
    'exercise_id', (select id from public.exercises where source_id = 'Plank')))))))$$,
  'trainer: cannot edit another trainer''s template');
select pg_temp.check(public.duplicate_template((select id from t_custom), 'Pooja copy') is not null, 'trainer: duplicates any library template');
select pg_temp.check((select count(*) from public.workout_days d join public.workout_templates t on t.id = d.template_id
                      where t.name = 'Pooja copy') = 2, 'a duplicate copies the days');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select public.save_template(jsonb_build_object('id', (select id from t_custom), 'name', 'Vikram 2-day (owner edit)', 'weeks', 6,
  'days', jsonb_build_array(jsonb_build_object('name', 'Only', 'items', jsonb_build_array(jsonb_build_object(
    'exercise_id', (select id from public.exercises where source_id = 'Barbell_Squat'), 'sets', 5, 'reps', 5))))));
select pg_temp.check((select name from public.workout_templates where id = (select id from t_custom)) = 'Vikram 2-day (owner edit)',
                     'owner: edits any library template');

-- ---------- assigning programs (5.4) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.assign_program((select ppl from ids), array[(select riya from ids)])$$, 'desk: cannot assign programs');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.assign_program((select ppl from ids), array[(select kabir from ids)])$$,
                      'trainer: cannot assign to another trainer''s member');
select pg_temp.raises($$select public.assign_program((select ppl from ids), array[(select riya from ids)], null, array[1, 2])$$,
                      'weekdays must match the number of days');
select pg_temp.check(public.assign_program((select ppl from ids), array[(select riya from ids)]) = 1, 'trainer: assigns a starter template');
select pg_temp.check((select status = 'active' and weekdays = array[1, 3, 5] and end_date = start_date + 55
                      from public.member_programs where member_id = (select riya from ids)),
                     'program is active on Mon/Wed/Fri for 8 weeks');
select pg_temp.check((select not t.is_gym_template and t.source_template_id = (select ppl from ids)
                      from public.member_programs mp join public.workout_templates t on t.id = mp.template_id
                      where mp.member_id = (select riya from ids)), 'the program is a private copy of the template');
create temp table riya_prog as select id, template_id from public.member_programs where member_id = '20000000-0000-0000-0000-000000000001';
grant select on riya_prog to authenticated;
-- Tuning the member's copy leaves the library alone.
select public.save_template(jsonb_build_object('id', (select template_id from riya_prog), 'name', 'Push / Pull / Legs', 'weeks', 8,
  'days', (select jsonb_agg(jsonb_build_object('name', d.name || ' (Riya)', 'items', (select jsonb_agg(jsonb_build_object(
             'exercise_id', i.exercise_id, 'sets', i.sets, 'reps', i.reps, 'target_weight', i.target_weight) order by i.position)
           from public.workout_items i where i.day_id = d.id)) order by d.day_index)
           from public.workout_days d where d.template_id = (select template_id from riya_prog))));
select pg_temp.check((select name from public.workout_days where template_id = (select ppl from ids) and day_index = 1) = 'Push',
                     'editing a member''s program never changes the library');
select pg_temp.check(public.assign_program((select mg4 from ids), array[(select riya from ids)], null, null, 'queue') = 1, 'trainer: queues the next program');
select pg_temp.check((select status = 'queued' and start_date = (select end_date + 1 from public.member_programs where id = (select id from riya_prog))
                      and weekdays = array[1, 2, 4, 5]
                      from public.member_programs where member_id = (select riya from ids) and source_template_id = (select mg4 from ids)),
                     'queued after the current one, 4 days on Mon/Tue/Thu/Fri');

select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) from public.member_programs) = 2, 'member: sees own programs');
select pg_temp.check((select count(*) from public.workout_days where template_id = (select template_id from riya_prog)) = 3,
                     'member: reads their program''s days');
select pg_temp.check((select count(*) from public.workout_items i join public.workout_days d on d.id = i.day_id
                      where d.template_id = (select template_id from riya_prog)) > 10, 'member: reads their program''s exercises');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((select count(*) from public.member_programs) = 0, 'member: cannot see another member''s programs');
select pg_temp.check((select count(*) from public.workout_days where template_id = (select template_id from riya_prog)) = 0,
                     'member: cannot read another member''s program days');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check((select count(*) from public.member_programs where member_id = (select riya from ids)) = 0,
                     'trainer: cannot see another trainer''s member programs');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.member_programs where member_id = (select riya from ids)) = 2, 'desk: sees programs');

-- ---------- workout logs (5.6, 5.7) and PRs (5.9) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.save_workout_log(pg_temp.log(gen_random_uuid(), null, 60, '[["Barbell_Squat", 40, 5]]'))$$,
                      'trainer: cannot log workouts for members');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.raises($$select public.save_workout_log(pg_temp.log(gen_random_uuid(), (select id from riya_prog), 60, '[["Barbell_Squat", 40, 5]]'))$$,
                      'member: cannot log against another member''s program');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((public.save_workout_log(pg_temp.log('50000000-0000-0000-0000-000000000001', (select id from riya_prog), 300,
  '[["Barbell_Squat", 40, 5], ["Barbell_Squat", 40, 5], ["Pushups", null, 10]]')) ->> 'total_volume')::numeric = 400,
  'member: logs a workout; volume is weight × reps');
select pg_temp.check((select count(*) from public.set_logs where is_pr) = 0, 'a first workout sets the baseline, no PRs');
select public.save_workout_log(pg_temp.log('50000000-0000-0000-0000-000000000001', (select id from riya_prog), 300,
  '[["Barbell_Squat", 40, 5], ["Barbell_Squat", 40, 6], ["Pushups", null, 10]]'));
select pg_temp.check((select count(*) from public.workout_logs) = 1 and (select count(*) from public.set_logs) = 3,
                     'saving the same workout again replaces it (no duplicates)');
create temp table second as select public.save_workout_log(pg_temp.log('50000000-0000-0000-0000-000000000002', (select id from riya_prog), 120,
  '[["Barbell_Squat", 42.5, 5], ["Barbell_Squat", 40, 8], ["Pushups", null, 12], ["Pushups", null, 11]]')) as r;
grant select on second to authenticated;
select pg_temp.check((select 'weight' = any (pr_kinds) from public.set_logs where weight = 42.5), 'PR: heavier weight');
select pg_temp.check((select 'reps' = any (pr_kinds) from public.set_logs s join public.workout_logs l on l.id = s.workout_log_id
                      where l.client_id = '50000000-0000-0000-0000-000000000002' and s.weight = 40),
                     'PR: more reps at the same weight');
select pg_temp.check((select count(*) from public.set_logs s join public.workout_logs l on l.id = s.workout_log_id
                      where l.client_id = '50000000-0000-0000-0000-000000000002' and 'e1rm' = any (pr_kinds)) = 1,
                     'PR: best estimated 1RM, once per exercise');
select pg_temp.check((select count(*) from public.set_logs s join public.workout_logs l on l.id = s.workout_log_id
                      where l.client_id = '50000000-0000-0000-0000-000000000002' and s.weight is null and 'reps' = any (pr_kinds)) = 1,
                     'PR: more bodyweight reps, flagged on one set');
select pg_temp.check(jsonb_array_length((select r from second) -> 'prs') >= 3, 'the save returns the PRs for the celebration');
reset role;
update public.workout_logs set finished_at = now() - interval '2 days', started_at = now() - interval '2 days 1 hour'
 where client_id = '50000000-0000-0000-0000-000000000001';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.raises($$select public.save_workout_log(pg_temp.log('50000000-0000-0000-0000-000000000001', (select id from riya_prog), 300, '[]'))$$,
                      'workouts can only be edited for 24 hours');
select pg_temp.raises($$select public.save_workout_log(jsonb_build_object('client_id', gen_random_uuid(),
  'started_at', now(), 'finished_at', now() - interval '1 hour'))$$, 'impossible times are refused');

-- Who sees logs: the member, their trainer, the owner.
select pg_temp.check((select count(*) from public.workout_logs) = 2, 'member: sees own logs');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check((select count(*) from public.workout_logs) = 2 and (select count(*) from public.set_logs) = 7,
                     'trainer: sees their member''s logs and sets');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check((select count(*) from public.workout_logs) = 0, 'trainer: cannot see another trainer''s member logs');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.workout_logs) = 0, 'desk: cannot see workout logs (body data)');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((select count(*) from public.set_logs) = 0, 'member: cannot see another member''s sets');

-- ---------- trainer feedback (5.10) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select public.comment_workout((select id from public.workout_logs where client_id = '50000000-0000-0000-0000-000000000002'), 'Great depth!', 'fire');
select public.comment_workout((select id from public.workout_logs where client_id = '50000000-0000-0000-0000-000000000002'), null, 'thumbs_up');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.raises($$select public.comment_workout((select id from public.workout_logs limit 1), 'Hi')$$,
                      'trainer: cannot comment on another trainer''s member');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) from public.workout_comments) = 2 and
                     (select author_name from public.workout_comments where body is not null) = 'Vikram',
                     'member: reads the trainer''s comment and reaction');
select public.comment_workout((select id from public.workout_logs where client_id = '50000000-0000-0000-0000-000000000002'), 'Thanks coach!');
select pg_temp.check((select author_name from public.workout_comments where body = 'Thanks coach!') = 'Riya Sen',
                     'member: replies to their coach in their own name');
select pg_temp.raises($$select public.comment_workout((select id from public.workout_logs where client_id = '50000000-0000-0000-0000-000000000002'), null, 'fire')$$,
                      'member: reactions are for coaches');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.raises($$select public.comment_workout((select id from public.workout_logs limit 1), 'Me too')$$,
                      'member: cannot comment on another member''s workout');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');

-- ---------- adherence and the coach overview (5.5) ----------
reset role;
update public.member_programs set start_date = public.ist_today() - 6, end_date = public.ist_today() + 30, weekdays = array[1,2,3,4,5,6,7]
 where id = (select id from riya_prog);
update public.workout_logs set day = public.ist_today() - 2, started_at = now() - interval '1 hour', finished_at = now()
 where client_id = '50000000-0000-0000-0000-000000000001';
-- Pin the second workout to today (it was logged "2 hours ago", which can be
-- yesterday just after midnight IST).
update public.workout_logs set day = public.ist_today() where client_id = '50000000-0000-0000-0000-000000000002';
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check(public.program_adherence((select id from riya_prog)) = 0.29, 'adherence: 2 of 7 planned days done');
select pg_temp.check((select count(*) from public.coach_overview()) = 1, 'trainer: overview lists only their members');
select pg_temp.check((select adherence = 0.29 and workouts_7d = 2 and program_name = 'Push / Pull / Legs'
                      from public.coach_overview()), 'overview: program, workouts this week and adherence');
select pg_temp.check((select planned_today and done_today and missed_7d = 5 from public.coach_overview()),
                     'overview: planned today, done today, 5 missed in the last week');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check((select count(*) from public.coach_overview()) = 2, 'owner: overview lists everyone');
select pg_temp.check((select name from public.coach_overview('10000000-0000-0000-0000-00000000000d')) = 'Kabir Das',
                     'owner: overview filters by trainer');
select pg_temp.check((select count(*) from public.coach_overview(null, 'riya')) = 1, 'overview: search by name');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises('select * from public.coach_overview()', 'desk: no coach overview');

-- ---------- replace, end and the nightly refresh ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select public.assign_program((select id from t_custom), array[(select riya from ids)], null, array[2]);
select pg_temp.check((select status from public.member_programs where id = (select id from riya_prog)) = 'replaced',
                     'replace: the running program stops');
select pg_temp.check((select count(*) from public.member_programs where member_id = (select riya from ids) and status = 'cancelled') = 1,
                     'replace: the queued program is dropped');
select pg_temp.check((select status from public.member_programs where member_id = (select riya from ids)
                      and source_template_id = (select id from t_custom)) = 'active', 'replace: the new program runs');
select public.end_program((select id from public.member_programs where member_id = (select riya from ids) and status = 'active'));
select pg_temp.check(not exists (select 1 from public.member_programs where member_id = (select riya from ids) and status = 'active'),
                     'trainer: ends a program');
select public.assign_program((select ppl from ids), array[(select riya from ids)], public.ist_today() + 3);
select pg_temp.check((select status from public.member_programs where member_id = (select riya from ids)
                      and start_date = public.ist_today() + 3) = 'queued', 'a future start waits in the queue');
reset role;
update public.member_programs set start_date = public.ist_today(), end_date = public.ist_today() + 55
 where member_id = (select riya from ids) and status = 'queued';
select pg_temp.check(public.refresh_programs() >= 1, 'nightly refresh runs');
select pg_temp.check((select count(*) from public.member_programs where member_id = (select riya from ids) and status = 'active') = 1,
                     'refresh: a queued program starts on its day');
update public.member_programs set end_date = public.ist_today() - 1, start_date = public.ist_today() - 10
 where member_id = (select riya from ids) and status = 'active';
select public.refresh_programs();
select pg_temp.check(not exists (select 1 from public.member_programs where member_id = (select riya from ids) and status = 'active'),
                     'refresh: a finished program is completed');

-- ---------- anonymous ----------
set role anon;
select pg_temp.as_user(null);
select pg_temp.check((select count(*) from public.exercises) = 0, 'anon: no catalogue');
select pg_temp.raises($$select public.save_workout_log('{}')$$, 'anon: cannot log workouts');
reset role;

select 'ALL M3 TESTS PASSED' as result;
