-- M4 tests: the food seed and starter diet templates, custom foods and
-- review, templates, assigning plans (replace / future start / end / nightly
-- refresh), meal, water and supplement logs, preferences and allergies,
-- trainer comments, adherence, the nutrition overview, and who sees what.

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

create or replace function pg_temp.food(p_key text) returns uuid
language sql as $$ select id from public.foods where seed_key = p_key $$;

-- A one-meal plan payload.
create or replace function pg_temp.plan(p_name text, p_items jsonb, p_extra jsonb default '{}') returns jsonb
language sql as $$
  select jsonb_build_object('name', p_name, 'kcal_target', 1600, 'diet_pref', 'veg', 'goal', 'fat_loss',
           'meals', jsonb_build_array(jsonb_build_object('meal_slot', 'lunch', 'time_of_day', '13:30', 'items', p_items)))
         || p_extra
$$;

-- Main-option totals of a template.
create or replace function pg_temp.kcal(p_template uuid) returns numeric
language sql as $$
  select sum(f.kcal * i.qty) from public.diet_meal_items i join public.diet_meals m on m.id = i.meal_id
  join public.foods f on f.id = i.food_id where m.template_id = p_template and i.alt_group = 0
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
insert into public.member_health (member_id, conditions) values ('20000000-0000-0000-0000-000000000002', 'Type 2 diabetes');

create temp table ids as
select '20000000-0000-0000-0000-000000000001'::uuid riya, '20000000-0000-0000-0000-000000000002'::uuid kabir,
       (select id from public.diet_templates where name = 'Veg fat loss 1,500 kcal' and is_gym_template) vfl,
       (select id from public.diet_templates where name = 'Non-veg muscle gain 2,500 kcal' and is_gym_template) nvm,
       (select id from public.diet_templates where name = 'Veg balanced 2,000 kcal' and is_gym_template) vb;
grant select on ids to authenticated, anon;

-- ---------- seed (6.1, 6.6) ----------
select pg_temp.check((select count(*) from public.foods where source = 'gym_seed') = 300, 'seed: 300 foods');
select pg_temp.check(not exists (select 1 from public.foods where reviewed_at is not null), 'seed: every food waits for review');
select pg_temp.check(not exists (select 1 from public.foods where abs(4 * protein_g + 4 * carbs_g + 9 * fat_g - kcal) > greatest(kcal * 0.15, 8)),
                     'seed: calories match protein, carbs and fat');
select pg_temp.check((select serving_unit = 'roti' and qty_step = 0.5 from public.foods where seed_key = 'roti'), 'seed: roti is counted in rotis, half a roti at a time');
select pg_temp.check((select serving_unit = 'g' and serving_g = 100 and qty_step = 0.25 from public.foods where seed_key = 'paneer'),
                     'seed: paneer is weighed in 25 g steps');
select pg_temp.check((select qty_step from public.foods where seed_key = 'boiled-egg') = 1, 'seed: eggs come whole');
select pg_temp.check((select local_name from public.foods where seed_key = 'toor-dal') = 'अरहर दाल', 'seed: Hindi names');
select pg_temp.check((select grocery -> 0 ->> 'item' from public.foods where seed_key = 'rajma') = 'Rajma (kidney beans)', 'seed: grocery items');
select pg_temp.check((select count(*) from public.diet_templates where is_starter) = 6, 'seed: six starter templates');
select pg_temp.check(not exists (select 1 from public.diet_templates t where t.is_starter
                                 and abs(pg_temp.kcal(t.id) - t.kcal_target) > t.kcal_target * 0.05),
                     'seed: starter plans are within 5% of their calorie target');
select pg_temp.check(not exists (
  select 1 from public.diet_templates t join public.diet_meals m on m.template_id = t.id
  join public.diet_meal_items i on i.meal_id = m.id join public.foods f on f.id = i.food_id
  where t.is_starter and not case t.diet_pref
    when 'veg' then f.veg_type in ('vegan', 'veg')
    when 'eggetarian' then f.veg_type in ('vegan', 'veg', 'egg')
    when 'vegan' then f.veg_type = 'vegan'
    when 'jain' then f.veg_type in ('vegan', 'veg') and f.jain_ok
    else true end), 'seed: every starter food (and option) fits its diet preference');
select pg_temp.check((select count(distinct i.alt_group) from public.diet_meal_items i join public.diet_meals m on m.id = i.meal_id
                      where m.template_id = (select vfl from ids) and m.meal_slot = 'breakfast') = 3,
                     'seed: breakfast has two "or" options');

set role authenticated;

-- ---------- who reads what ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) from public.foods) = 300, 'member: reads the food database');
select pg_temp.check((select count(*) from public.diet_templates) = 0, 'member: no template library');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.diet_templates) = 6, 'desk: reads the template library');
select pg_temp.check((select count(*) from public.diet_meal_items i join public.diet_meals m on m.id = i.meal_id
                      where m.template_id = (select vfl from ids)) > 10, 'desk: reads template meals and items');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Desk plan', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 2))))$$, 'desk: cannot build diet plans');
select pg_temp.raises($$insert into public.foods (name, category, serving_unit, serving_g, kcal, veg_type)
  values ('Desk snack', 'snacks', 'piece', 30, 100, 'veg')$$, 'desk: cannot add foods');

-- ---------- custom foods and review (6.1) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
insert into public.foods (name, local_name, category, serving_unit, serving_g, kcal, protein_g, carbs_g, fat_g, veg_type,
                          jain_ok, source, seed_key)
values ('Sattu paratha', 'सत्तू पराठा', 'grains', 'piece', 100, 260, 10, 38, 7.5, 'vegan', true, 'usda', 'hijack');
create temp table sattu as select id from public.foods where name = 'Sattu paratha';
grant select on sattu to authenticated;
select pg_temp.check((select source = 'custom' and is_custom and seed_key is null and reviewed_at is not null
                             and created_by = '00000000-0000-0000-0000-00000000000c'
                      from public.foods where id = (select id from sattu)), 'trainer: adds a custom food, counted as reviewed');
update public.foods set kcal = 110, protein_g = 3.6, seed_key = 'other', source = 'custom' where seed_key = 'roti';
select pg_temp.check((select kcal = 110 and seed_key = 'roti' and source = 'gym_seed'
                             and reviewed_by = '00000000-0000-0000-0000-00000000000c'
                      from public.foods where seed_key = 'roti'), 'trainer: corrects a seeded food, which marks it reviewed');
update public.foods set reviewed_at = now() where seed_key = 'toor-dal';
select pg_temp.check((select reviewed_by from public.foods where seed_key = 'toor-dal') = '00000000-0000-0000-0000-00000000000c',
                     'trainer: marks a food reviewed');
select pg_temp.raises($$update public.foods set archived_at = now() where seed_key = 'samosa'$$, 'trainer: cannot remove a seeded food');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.raises($$update public.foods set archived_at = now() where id = (select id from sattu)$$,
                      'trainer: cannot remove another trainer''s food');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.raises($$insert into public.foods (name, category, serving_unit, serving_g, kcal, veg_type)
  values ('My snack', 'snacks', 'piece', 30, 100, 'veg')$$, 'member: cannot add foods');
update public.foods set kcal = 1 where seed_key = 'samosa';
select pg_temp.check((select kcal from public.foods where seed_key = 'samosa') = 260, 'member: cannot change food values');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
update public.foods set archived_at = now() where seed_key = 'cola';
select pg_temp.check((select archived_at is not null from public.foods where seed_key = 'cola'), 'owner: removes a seeded food');
select pg_temp.raises($$insert into public.foods (name, category, serving_unit, serving_g, kcal, veg_type, allergens)
  values ('Odd', 'snacks', 'piece', 30, 100, 'veg', array['plastic'])$$, 'allergens come from the list');

-- ---------- templates (6.3, 6.5, 6.6) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
create temp table t_custom as
select public.save_diet_template(jsonb_build_object(
  'name', 'Vikram cut', 'kcal_target', 1700, 'protein_g', 120, 'carbs_g', 170, 'fat_g', 55, 'diet_pref', 'veg',
  'goal', 'fat_loss', 'macro_preset', 'high_protein', 'supplements', jsonb_build_array('Multivitamin', ' ', 'Creatine'),
  'meals', jsonb_build_array(
    jsonb_build_object('meal_slot', 'breakfast', 'time_of_day', '08:00', 'items', jsonb_build_array(
      jsonb_build_object('food_id', pg_temp.food('moong-chilla'), 'qty', 2),
      jsonb_build_object('food_id', pg_temp.food('poha'), 'qty', 1, 'alt_group', 1))),
    jsonb_build_object('meal_slot', 'lunch', 'time_of_day', '13:30', 'notes', 'Salad first', 'items', jsonb_build_array(
      jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 2),
      jsonb_build_object('food_id', pg_temp.food('toor-dal'), 'qty', 1),
      jsonb_build_object('food_id', (select id from sattu), 'qty', 1, 'alt_group', 1),
      jsonb_build_object('food_id', pg_temp.food('white-rice'), 'qty', 1, 'alt_group', 2)))))) as id;
grant select on t_custom to authenticated;
select pg_temp.check((select count(*) from public.diet_meals where template_id = (select id from t_custom)) = 2, 'trainer: builds a plan');
select pg_temp.check((select supplements = array['Creatine', 'Multivitamin'] from public.diet_templates where id = (select id from t_custom)),
                     'supplements are tidied');
select pg_temp.check((select string_agg(i.alt_group || ':' || i.position, ',' order by i.alt_group, i.position)
                      from public.diet_meal_items i join public.diet_meals m on m.id = i.meal_id
                      where m.template_id = (select id from t_custom) and m.meal_slot = 'lunch') = '0:1,0:2,1:1,2:1',
                     'items keep their order within each option');
select pg_temp.raises($$select public.save_diet_template(jsonb_build_object('name', 'Empty', 'kcal_target', 1500, 'meals', '[]'::jsonb))$$,
                      'a plan needs at least one meal');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('No foods', '[]'::jsonb))$$, 'each meal needs a food');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Ghost', jsonb_build_array(
  jsonb_build_object('food_id', gen_random_uuid(), 'qty', 1))))$$, 'unknown foods are refused');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Third option', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1),
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1, 'alt_group', 3))))$$, 'at most two options per meal');
select pg_temp.raises($$select public.save_diet_template(jsonb_build_object('name', 'Twice', 'kcal_target', 1500,
  'meals', jsonb_build_array(
    jsonb_build_object('meal_slot', 'lunch', 'items', jsonb_build_array(jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1))),
    jsonb_build_object('meal_slot', 'lunch', 'items', jsonb_build_array(jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1))))))$$,
  'each meal appears once');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Brunch', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1)), '{"meals": [{"meal_slot": "brunch", "items": []}]}'))$$,
  'meal slots come from the list');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Zero', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 0))))$$, 'quantities must be positive');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Tiny', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1)), '{"kcal_target": 200}'))$$, 'calorie targets are sensible');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Taken over', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1)), jsonb_build_object('id', (select id from t_custom))))$$,
  'trainer: cannot edit another trainer''s plan');
select pg_temp.raises($$select public.archive_diet_template((select id from t_custom))$$, 'trainer: cannot remove another trainer''s plan');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select public.save_diet_template(pg_temp.plan('Vikram cut (owner edit)', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 3)), jsonb_build_object('id', (select id from t_custom))));
select pg_temp.check((select name from public.diet_templates where id = (select id from t_custom)) = 'Vikram cut (owner edit)',
                     'owner: edits any library plan');

-- ---------- assigning (6.7) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.assign_diet((select vfl from ids), array[(select riya from ids)])$$, 'desk: cannot assign diets');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.assign_diet((select vfl from ids), array[(select kabir from ids)])$$,
                      'trainer: cannot assign to another trainer''s member');
select pg_temp.raises($$select public.assign_diet((select vfl from ids), '{}'::uuid[])$$, 'pick at least one member');
select pg_temp.raises($$select public.assign_diet((select vfl from ids), array[(select riya from ids)], public.ist_today() - 30)$$,
                      'start date cannot be long past');
select pg_temp.check(public.assign_diet((select vfl from ids), array[(select riya from ids)]) = 1, 'trainer: assigns a starter plan');
create temp table riya_diet as select id, template_id from public.member_diets where member_id = '20000000-0000-0000-0000-000000000001';
grant select on riya_diet to authenticated;
select pg_temp.check((select md.status = 'active' and md.start_date = public.ist_today() and md.end_date is null
                             and not t.is_gym_template and t.source_template_id = (select vfl from ids)
                      from public.member_diets md join public.diet_templates t on t.id = md.template_id
                      where md.id = (select id from riya_diet)), 'the plan is a private copy, running from today');
select pg_temp.check(pg_temp.kcal((select template_id from riya_diet)) = pg_temp.kcal((select vfl from ids)), 'the copy has every food');
select pg_temp.check((select kind from public.member_events where member_id = (select riya from ids) order by at desc limit 1) = 'diet_assigned',
                     'assigning shows in the member''s history');
-- Tuning the member's copy leaves the library alone.
select public.save_diet_template(jsonb_build_object('id', (select template_id from riya_diet), 'name', 'Veg fat loss 1,500 kcal',
  'kcal_target', 1500, 'diet_pref', 'veg',
  'meals', (select jsonb_agg(jsonb_build_object('meal_slot', m.meal_slot, 'time_of_day', m.time_of_day,
             'items', (select jsonb_agg(jsonb_build_object('food_id', i.food_id, 'qty', i.qty, 'alt_group', i.alt_group)
                                        order by i.alt_group, i.position)
                       from public.diet_meal_items i where i.meal_id = m.id)) order by m.position)
            from public.diet_meals m where m.template_id = (select template_id from riya_diet) and m.meal_slot <> 'bedtime')));
select pg_temp.check((select count(*) from public.diet_meals where template_id = (select template_id from riya_diet)) = 6
                     and (select count(*) from public.diet_meals where template_id = (select vfl from ids)) = 7,
                     'editing a member''s plan never changes the library');

select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.member_diets) = 0, 'desk: cannot see members'' diet plans');
select pg_temp.check((select count(*) from public.diet_meals where template_id = (select template_id from riya_diet)) = 0,
                     'desk: cannot read a member''s plan');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check((select count(*) from public.member_diets) = 0, 'trainer: cannot see another trainer''s member''s plan');
select pg_temp.raises($$select public.save_diet_template(pg_temp.plan('Hijack', jsonb_build_array(
  jsonb_build_object('food_id', pg_temp.food('roti'), 'qty', 1)), jsonb_build_object('id', (select template_id from riya_diet))))$$,
  'trainer: cannot edit another trainer''s member''s plan');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((select count(*) from public.member_diets) = 0, 'member: cannot see another member''s plan');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select count(*) from public.member_diets) = 1, 'member: sees their own plan');
select pg_temp.check((select count(*) from public.diet_meal_items i join public.diet_meals m on m.id = i.meal_id
                      where m.template_id = (select template_id from riya_diet)) > 10, 'member: reads their meals and foods');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check((select count(*) from public.member_diets) = 1, 'owner: sees every plan');

-- ---------- meal logs (6.8) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((public.log_meal(public.ist_today(), 'breakfast', 'eaten') ->> 'kcal')::numeric = 310,
                     'eaten: the meal''s calories count');
select pg_temp.check((public.log_meal(public.ist_today(), 'breakfast', 'partly') ->> 'kcal')::numeric = 155, 'partly: half');
select pg_temp.check((select (l ->> 'kcal')::numeric = 255 and (l ->> 'alt_group')::int = 1
                      from (select public.log_meal(public.ist_today(), 'breakfast', 'swapped', 1) l) x),
                     'swapped: the option''s calories count');
select pg_temp.check((public.log_meal(public.ist_today(), 'breakfast', 'skipped') ->> 'kcal')::numeric = 0, 'skipped: nothing');
select pg_temp.check((select count(*) from public.meal_logs where member_id = (select riya from ids)) = 1, 'one log per meal per day');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'breakfast', 'swapped')$$, 'swapped needs an option');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'mid_morning', 'swapped', 2)$$, 'only options that exist');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'bedtime', 'eaten')$$, 'only meals in the plan');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'lunch', 'devoured')$$, 'status comes from the list');
select pg_temp.raises($$select public.log_meal(public.ist_today() - 3, 'lunch', 'eaten')$$, 'cannot log more than two days back');
select pg_temp.raises($$select public.log_meal(public.ist_today() + 1, 'lunch', 'eaten')$$, 'cannot log tomorrow');
select pg_temp.raises($$select public.log_meal(public.ist_today() - 1, 'lunch', 'eaten')$$, 'cannot log before the plan started');
select pg_temp.check(public.log_meal(public.ist_today(), 'breakfast', null) is null, 'clearing a meal returns nothing');
select pg_temp.check(not exists (select 1 from public.meal_logs where member_id = (select riya from ids)), 'clearing a meal removes the log');
select public.log_meal(public.ist_today(), 'lunch', 'eaten');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'lunch', 'eaten')$$, 'member without a plan cannot log meals');
select pg_temp.check((select count(*) from public.meal_logs) = 0, 'member: cannot see another member''s meals');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'lunch', 'eaten')$$, 'trainer: cannot log meals');
select pg_temp.check((select count(*) from public.meal_logs) = 1, 'trainer: sees their member''s meals');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.meal_logs) = 0, 'desk: cannot see meal logs');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check((select count(*) from public.meal_logs) = 0, 'trainer: cannot see another trainer''s member''s meals');

-- ---------- water and supplements (6.9) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select public.set_water(public.ist_today(), 5);
select pg_temp.check(public.set_water(public.ist_today(), 6) = 6, 'water: returns the glasses');
select pg_temp.check((select glasses from public.water_logs where member_id = (select riya from ids)) = 6, 'water: one row per day, latest count');
select pg_temp.raises($$select public.set_water(public.ist_today(), 31)$$, 'water: at most 30 glasses');
select public.set_supplement(public.ist_today(), ' Multivitamin ', true);
select public.set_supplement(public.ist_today(), 'Multivitamin', true);
select pg_temp.check((select count(*) from public.supplement_logs where name = 'Multivitamin') = 1, 'supplements: ticked once');
select public.set_supplement(public.ist_today(), 'Multivitamin', false);
select pg_temp.check(not exists (select 1 from public.supplement_logs), 'supplements: unticked');
select pg_temp.raises($$select public.set_supplement(public.ist_today(), repeat('x', 41), true)$$, 'supplements: short names');
select public.set_supplement(public.ist_today(), 'Multivitamin', true);
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.raises($$select public.set_water(public.ist_today(), 2)$$, 'trainer: cannot log water');
select pg_temp.check((select count(*) from public.water_logs) = 1 and (select count(*) from public.supplement_logs) = 1,
                     'trainer: sees their member''s water and supplements');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.check((select count(*) from public.water_logs) = 0 and (select count(*) from public.supplement_logs) = 0,
                     'desk: cannot see water or supplements');

-- ---------- preferences and flags (6.4) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select public.set_diet_preferences((select riya from ids), 'veg', array['peanut'], array[' brinjal ', '', 'mushroom', 'mushroom']);
select pg_temp.check((select m.diet_pref = 'veg' and h.food_allergies = array['peanut'] and h.foods_to_avoid = array['brinjal', 'mushroom']
                      from public.members m join public.member_health h on h.member_id = m.id where m.id = (select riya from ids)),
                     'member: sets their own preference, allergies and foods to avoid');
select pg_temp.raises($$select public.set_diet_preferences((select riya from ids), 'veg', array['plastic'])$$, 'allergies come from the list');
select pg_temp.raises($$select public.set_diet_preferences((select riya from ids), 'carnivore')$$, 'preferences come from the list');
select pg_temp.raises($$select public.set_diet_preferences((select kabir from ids), 'veg')$$, 'member: cannot set another member''s preferences');
select pg_temp.raises($$select * from public.diet_member_flags(array[(select riya from ids)])$$, 'member: no coach flags');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.raises($$select public.set_diet_preferences((select riya from ids), 'vegan')$$, 'trainer: cannot set another trainer''s member''s preferences');
select pg_temp.check((select count(*) from public.diet_member_flags(array[(select riya from ids), (select kabir from ids)])) = 1,
                     'flags: only members the coach looks after');
select pg_temp.check((select has_conditions and conditions = 'Type 2 diabetes' from public.diet_member_flags(array[(select kabir from ids)])),
                     'flags: medical conditions from the health form');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check((select diet_pref = 'veg' and food_allergies = array['peanut'] and not has_conditions
                      from public.diet_member_flags(array[(select riya from ids)])), 'flags: preference and allergies');
select public.set_diet_preferences((select riya from ids), 'eggetarian', '{}', '{}');
select pg_temp.check((select diet_pref from public.members where id = (select riya from ids)) = 'eggetarian', 'trainer: updates their member''s preference');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select * from public.diet_member_flags(array[(select riya from ids)])$$, 'desk: no health flags');

-- ---------- trainer comments (6.11) ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select pg_temp.check(public.comment_diet((select riya from ids), 'Great week, add one more glass of water') is not null, 'trainer: comments on nutrition');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.raises($$select public.comment_diet((select riya from ids), 'Hello')$$, 'trainer: cannot comment on another trainer''s member');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((select author_name = 'Vikram' and member_diet_id = (select id from riya_diet) from public.diet_comments),
                     'member: reads the comment');
select pg_temp.raises($$select public.comment_diet((select riya from ids), 'Me')$$, 'member: cannot comment');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((select count(*) from public.diet_comments) = 0, 'member: cannot read another member''s comments');

-- ---------- adherence and the nutrition overview (6.11) ----------
-- Kabir starts the 7-meal veg fat loss plan two days ago: day 1 all eaten,
-- day 2 three eaten, two partly, one swapped, one skipped; today two eaten.
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check(public.assign_diet((select vfl from ids), array[(select kabir from ids)], public.ist_today() - 2) = 1,
                     'a start up to a week back runs at once');
create temp table kabir_diet as select id from public.member_diets where member_id = '20000000-0000-0000-0000-000000000002';
grant select on kabir_diet to authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select public.log_meal(public.ist_today() - 2, s, 'eaten') from unnest(public.meal_slots()) s
 where s in ('early_morning', 'breakfast', 'mid_morning', 'lunch', 'evening_snack', 'dinner', 'bedtime');
select public.log_meal(public.ist_today() - 1, 'early_morning', 'eaten'), public.log_meal(public.ist_today() - 1, 'breakfast', 'eaten'),
       public.log_meal(public.ist_today() - 1, 'mid_morning', 'eaten'), public.log_meal(public.ist_today() - 1, 'lunch', 'partly'),
       public.log_meal(public.ist_today() - 1, 'evening_snack', 'partly'), public.log_meal(public.ist_today() - 1, 'dinner', 'swapped', 1),
       public.log_meal(public.ist_today() - 1, 'bedtime', 'skipped');
select public.log_meal(public.ist_today(), 'early_morning', 'eaten'), public.log_meal(public.ist_today(), 'breakfast', 'eaten');
select pg_temp.check(public.diet_adherence((select id from kabir_diet), public.ist_today() - 6, public.ist_today()) = 0.88,
                     'adherence: 14 of 16 due meals (today counts what is marked)');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check(public.diet_adherence((select id from kabir_diet), public.ist_today() - 6, public.ist_today()) is null,
                     'adherence: hidden from other members');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select pg_temp.check((select count(*) from public.diet_overview()) = 1, 'trainer: overview lists only their members');
select pg_temp.check((select adherence_7d = 0.88 and missed_7d = 1 and logged_today = 2 and meals_per_day = 7 and kcal_target = 1500
                             and diet_name = 'Veg fat loss 1,500 kcal' and has_conditions
                      from public.diet_overview()), 'overview: plan, adherence, missed meals, today and the health flag');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select pg_temp.check((select count(*) from public.diet_overview()) = 2, 'owner: overview lists everyone');
select pg_temp.check((select name from public.diet_overview('10000000-0000-0000-0000-00000000000c')) = 'Riya Sen', 'owner: filters by trainer');
select pg_temp.check((select count(*) from public.diet_overview(null, 'kab')) = 1, 'overview: search by name');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises('select * from public.diet_overview()', 'desk: no nutrition overview');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.raises('select * from public.diet_overview()', 'member: no nutrition overview');

-- ---------- replace, future starts, end and the nightly refresh ----------
select pg_temp.as_user('00000000-0000-0000-0000-00000000000c');
select public.assign_diet((select nvm from ids), array[(select riya from ids)], public.ist_today() + 3);
select pg_temp.check((select status from public.member_diets where member_id = (select riya from ids) and source_template_id = (select nvm from ids)) = 'queued'
                     and (select status from public.member_diets where id = (select id from riya_diet)) = 'active',
                     'a future start waits; the current plan keeps running');
select public.assign_diet((select vb from ids), array[(select riya from ids)], public.ist_today() + 5);
select pg_temp.check((select status from public.member_diets where member_id = (select riya from ids) and source_template_id = (select nvm from ids)) = 'dropped',
                     'a newer assignment drops the older queued plan');
reset role;
update public.member_diets set start_date = public.ist_today() where member_id = (select riya from ids) and status = 'queued';
select pg_temp.check(public.refresh_diets() = 1, 'nightly refresh runs');
select pg_temp.check((select status from public.member_diets where id = (select id from riya_diet)) = 'replaced'
                     and (select status from public.member_diets where member_id = (select riya from ids) and source_template_id = (select vb from ids)) = 'active',
                     'refresh: a queued plan starts on its day and replaces the old one');
set role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-00000000000e');
select pg_temp.check((public.log_meal(public.ist_today(), 'lunch', 'eaten') ->> 'member_diet_id')::uuid
                     = (select id from public.member_diets where member_id = (select riya from ids) and status = 'active'),
                     'logs go to the plan running that day');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select pg_temp.raises($$select public.end_diet((select id from kabir_diet))$$, 'desk: cannot end a plan');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000d');
select public.end_diet((select id from kabir_diet));
select pg_temp.check((select status = 'ended' and end_date = public.ist_today() from public.member_diets where id = (select id from kabir_diet)),
                     'trainer: ends a plan today');
select pg_temp.check((select count(*) from public.member_diets where member_id = (select kabir from ids)) = 1, 'history: earlier plans are kept');
select pg_temp.as_user('00000000-0000-0000-0000-00000000000f');
select pg_temp.check((public.log_meal(public.ist_today(), 'lunch', 'eaten') ->> 'kcal')::numeric > 0, 'meals can still be marked on the last day');

-- ---------- anonymous ----------
set role anon;
select pg_temp.as_user(null);
select pg_temp.check((select count(*) from public.foods) = 0, 'anon: no food database');
select pg_temp.check((select count(*) from public.member_diets) = 0, 'anon: no plans');
select pg_temp.raises($$select public.log_meal(public.ist_today(), 'lunch', 'eaten')$$, 'anon: cannot log meals');
reset role;

select 'ALL M4 TESTS PASSED' as result;
