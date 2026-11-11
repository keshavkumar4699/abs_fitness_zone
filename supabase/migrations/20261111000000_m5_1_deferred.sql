-- ABS Fitness — after M5: items deferred from earlier milestones.
-- Optional check-out (M1, DECISIONS 44) and members replying to their
-- coach's comments (5.10, DECISIONS 83).

-- ---------------------------------------------------------------------------
-- Check-out (optional). The check-in result now also says whether the
-- member has already checked out today.
-- ---------------------------------------------------------------------------
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
    'already', v_already, 'checked_in_at', v_row.checked_in_at, 'checked_out_at', v_row.checked_out_at,
    'dues_paise', v_m.dues_paise);
end;
$$;

-- The desk, the member's own trainer, or the member themselves (no member
-- id) ends today's visit. A second call changes nothing.
create or replace function public.check_out(p_member_id uuid default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid := coalesce(p_member_id, public.auth_member_id());
  v_row    public.attendance%rowtype;
begin
  if v_member is null then raise exception 'not allowed' using errcode = '42501'; end if;
  if not coalesce(public.is_desk() or public.is_my_trainee(v_member)
                  or (public.auth_role() = 'member' and v_member = public.auth_member_id()), false) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  select * into v_row from public.attendance where member_id = v_member and day = public.ist_today() for update;
  if not found then raise exception 'no check-in today' using errcode = '22023'; end if;
  if v_row.checked_out_at is null then
    update public.attendance set checked_out_at = now() where id = v_row.id returning * into v_row;
  end if;
  return jsonb_build_object(
    'member_id', v_member, 'checked_in_at', v_row.checked_in_at, 'checked_out_at', v_row.checked_out_at,
    'minutes', greatest(0, floor(extract(epoch from (v_row.checked_out_at - v_row.checked_in_at)) / 60))::int);
end;
$$;
revoke execute on function public.check_out(uuid) from public, anon;
grant execute on function public.check_out(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Members reply to their coach (5.10). Words only: reactions stay the
-- coach's.
-- ---------------------------------------------------------------------------
create or replace function public.comment_workout(p_log_id uuid, p_body text default null, p_emoji text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member uuid;
  v_own    boolean;
  v_name   text;
  v_id     uuid;
begin
  select member_id into v_member from public.workout_logs where id = p_log_id;
  if not found then raise exception 'workout not found' using errcode = 'P0002'; end if;
  v_own := coalesce(v_member = public.auth_member_id(), false);
  if not coalesce(public.can_coach_member(v_member) or v_own, false) then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  if v_own and p_emoji is not null then raise exception 'reactions are for coaches' using errcode = '22023'; end if;
  if v_own and nullif(trim(coalesce(p_body, '')), '') is null then
    raise exception 'write a reply' using errcode = '22023';
  end if;
  select name into v_name from public.profiles where id = auth.uid();
  insert into public.workout_comments (workout_log_id, author_id, author_name, body, emoji)
  values (p_log_id, auth.uid(), coalesce(v_name, case when v_own then 'Member' else 'Coach' end),
          nullif(trim(p_body), ''), p_emoji)
  returning id into v_id;
  return v_id;
end;
$$;
