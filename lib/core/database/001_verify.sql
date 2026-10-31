-- =====================================================================
-- Iqraa — supabase/tests/001_verify.sql
-- Run in the SQL Editor AFTER 001_init.sql. Everything is rolled back at the
-- end (two throw-away test users; the script never commits, so nothing remains).
-- It prints one row per check plus a final SUMMARY row: every row must have
-- ok = true. This script has NOT been executed by the author; if it errors,
-- send me the error text.
--
-- Coverage of the last review round:
--   completed plans  : T13b (insert denied), T13c (edit denied)
--   group linking    : T16b (archived plan denied), T16c (completed plan denied), T19 (active plan OK)
--   future-dated logs: T6b, T13d, T13e, T13f (insert), T13g (edit)
-- =====================================================================
begin;

create temp table test_results (n serial, name text, ok boolean, detail text);

do $$
declare
  ua  uuid := '00000000-0000-4000-8000-0000000000a1';
  ub  uuid := '00000000-0000-4000-8000-0000000000b1';
  bk1 uuid; bk2 uuid; bk3 uuid;
  p1 uuid; p2 uuid; p3 uuid; p4 uuid; p5 uuid;
  g uuid; v_code text;
  n integer; v integer; v_ok boolean; st record; r record;
  v_min date; v_max date; v_other date;
begin
  -- the window of dates the policies accept (same expressions as in 001_init.sql)
  v_min := (timezone('utc', now()) - interval '12 hours')::date;
  v_max := (timezone('utc', now()) + interval '14 hours')::date;
  v_other := case when v_max > current_date then v_max else v_min end;   -- a valid date other than today

  select id into bk1 from public.books order by title limit 1;
  select id into bk2 from public.books order by title offset 1 limit 1;
  select id into bk3 from public.books order by title offset 2 limit 1;

  -- T0: sign-up trigger creates profiles
  insert into auth.users (id, email)
  values (ua, 'verify_a@example.test'), (ub, 'verify_b@example.test');
  select count(*) into n from public.profiles where id in (ua, ub);
  insert into test_results (name, ok, detail) values ('T0 profiles created by trigger', n = 2, n::text);

  -- ===== user A =====
  perform set_config('request.jwt.claims', json_build_object('sub', ua, 'role', 'authenticated')::text, true);

  -- T1: create a plan
  set local role authenticated;
  insert into public.reading_plans (user_id, book_id, start_date, target_date, target_pages)
  values (ua, bk1, current_date, current_date + 10, 100) returning id into p1;
  reset role;
  insert into test_results (name, ok, detail) values ('T1 plan created', p1 is not null, p1::text);

  -- T2: second ACTIVE plan for the same book is rejected
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_plans (user_id, book_id, start_date, target_date, target_pages)
    values (ua, bk1, current_date, current_date + 10, 100);
  exception when unique_violation then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T2 only one active plan per book', v_ok, null);

  -- T3: log today -> completed_pages = 30
  set local role authenticated;
  insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, current_date, 30);
  reset role;
  select completed_pages into v from public.reading_plans where id = p1;
  insert into test_results (name, ok, detail) values ('T3 log today updates completed_pages', v = 30, v::text);

  -- T4: duplicate log on the same day is rejected
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, current_date, 5);
  exception when unique_violation then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T4 duplicate daily log rejected', v_ok, null);

  -- T5: today's entry can be corrected
  set local role authenticated;
  update public.reading_logs set pages_read = 40 where plan_id = p1 and log_date = current_date;
  get diagnostics n = row_count;
  reset role;
  select completed_pages into v from public.reading_plans where id = p1;
  insert into test_results (name, ok, detail) values ('T5 correct today entry', n = 1 and v = 40, 'rows=' || n || ' completed=' || v);

  -- T6: a log dated 3 days ago cannot be added by the client
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, current_date - 3, 5);
  exception when insufficient_privilege then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T6 past-day insert denied', v_ok, null);

  -- T6b: a future date (beyond what any time zone has reached) is rejected
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, v_max + 1, 5);
  exception when insufficient_privilege then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T6b future-date insert denied', v_ok, (v_max + 1)::text);

  -- T7: an old entry (inserted by admin) cannot be edited by the client
  insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, current_date - 3, 5);
  set local role authenticated;
  update public.reading_logs set pages_read = 99 where plan_id = p1 and log_date = current_date - 3;
  get diagnostics n = row_count;
  reset role;
  select completed_pages into v from public.reading_plans where id = p1;
  insert into test_results (name, ok, detail) values ('T7 past-day edit denied', n = 0 and v = 45, 'rows=' || n || ' completed=' || v);

  -- T8: yesterday's log, inserted by the admin role to build the streak scenario
  --     (whether a client may write "yesterday UTC" depends on the time of day; see T13d/T13e)
  insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, current_date - 1, 10);
  select completed_pages into v from public.reading_plans where id = p1;
  insert into test_results (name, ok, detail) values ('T8 yesterday log recorded (admin)', v = 55, v::text);

  -- T9: statistics and streak rule
  set local role authenticated;
  select * into st from public.get_my_stats(current_date);
  reset role;
  insert into test_results (name, ok, detail) values
    ('T9a stats: days=3 pages=55 current=2 longest=2 books=0',
     st.reading_days = 3 and st.total_pages_read = 55 and st.current_streak = 2
       and st.longest_streak = 2 and st.books_completed = 0,
     row(st.books_completed, st.total_pages_read, st.reading_days, st.current_streak, st.longest_streak)::text);
  set local role authenticated;
  select current_streak into v from public.get_my_stats(current_date + 1);   -- next day, nothing logged yet
  reset role;
  insert into test_results (name, ok, detail) values ('T9b streak still alive the day after a log', v = 2, v::text);
  set local role authenticated;
  select current_streak into v from public.get_my_stats(current_date + 2);   -- a full day passed without a log
  reset role;
  insert into test_results (name, ok, detail) values ('T9c streak broken after a missed day', v = 0, v::text);

  -- T10: archiving keeps the logs and the statistics
  set local role authenticated;
  update public.reading_plans set is_active = false where id = p1;
  get diagnostics n = row_count;
  reset role;
  select count(*) into v from public.reading_logs where plan_id = p1;
  set local role authenticated;
  select * into st from public.get_my_stats(current_date);
  reset role;
  insert into test_results (name, ok, detail) values
    ('T10 archive keeps logs and stats', n = 1 and v = 3 and st.reading_days = 3 and st.total_pages_read = 55,
     'logs=' || v || ' days=' || st.reading_days);

  -- T11: a new plan for the same book is allowed after archiving
  set local role authenticated;
  insert into public.reading_plans (user_id, book_id, start_date, target_date, target_pages)
  values (ua, bk1, current_date, current_date + 10, 100) returning id into p2;
  reset role;
  insert into test_results (name, ok, detail) values ('T11 new plan after archive', p2 is not null, p2::text);

  -- T12: logging into an archived plan is denied
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p1, ua, current_date, 1);   -- RLS is checked before the unique index
  exception when insufficient_privilege then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T12 log into archived plan denied', v_ok, null);

  -- T13: a completed plan does not block a new plan for the same book
  set local role authenticated;
  insert into public.reading_plans (user_id, book_id, start_date, target_date, target_pages)
  values (ua, bk2, current_date, current_date + 5, 10) returning id into p3;
  insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p3, ua, current_date, 10);
  reset role;
  select count(*) into n from public.reading_plans where id = p3 and completed_at is not null;
  set local role authenticated;
  insert into public.reading_plans (user_id, book_id, start_date, target_date, target_pages)
  values (ua, bk2, current_date, current_date + 5, 10) returning id into p4;
  select * into st from public.get_my_stats(current_date);
  reset role;
  insert into test_results (name, ok, detail) values
    ('T13 completed plan + new plan for same book', n = 1 and p4 is not null and st.books_completed = 1,
     'completed=' || n || ' books_completed=' || st.books_completed);

  -- T13b: no new log can be added to a COMPLETED plan (p3)
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p3, ua, v_other, 1);
  exception when insufficient_privilege then v_ok := true;
  end;
  reset role;
  select count(*) into n from public.reading_logs where plan_id = p3;
  insert into test_results (name, ok, detail) values ('T13b log into completed plan denied', v_ok and n = 1, v_other::text || ' logs=' || n);

  -- T13c: the log that completed the plan can no longer be edited
  set local role authenticated;
  update public.reading_logs set pages_read = 5 where plan_id = p3 and log_date = current_date;
  get diagnostics n = row_count;
  reset role;
  select completed_pages into v from public.reading_plans where id = p3;
  select exists (select 1 from public.reading_logs
                  where plan_id = p3 and log_date = current_date and pages_read = 10) into v_ok;
  insert into test_results (name, ok, detail) values ('T13c completed plan logs are read-only', n = 0 and v = 10 and v_ok, 'rows=' || n || ' completed=' || v);

  -- T13d: on an active plan (p4, no logs yet) both edges of the window are accepted
  v_ok := true;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p4, ua, v_min, 1);
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p4, ua, v_max, 1);
  exception when others then v_ok := false;
  end;
  reset role;
  select count(*) into n from public.reading_logs where plan_id = p4;
  insert into test_results (name, ok, detail) values ('T13d earliest and latest valid dates accepted', v_ok and n = 2, v_min::text || ' / ' || v_max::text);

  -- T13e: one day beyond either edge is rejected
  v_ok := true;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p4, ua, v_min - 1, 1);
    v_ok := false;
  exception when insufficient_privilege then null;
  end;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p4, ua, v_max + 1, 1);
    v_ok := false;
  exception when insufficient_privilege then null;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T13e dates outside the window rejected', v_ok, (v_min - 1)::text || ' / ' || (v_max + 1)::text);

  -- T13f: a far-future date is rejected (dedicated active plan p5 on a third book)
  set local role authenticated;
  insert into public.reading_plans (user_id, book_id, start_date, target_date, target_pages)
  values (ua, bk3, current_date, current_date + 10, 100) returning id into p5;
  reset role;
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p5, ua, current_date + 30, 5);
  exception when insufficient_privilege then v_ok := true;
  end;
  reset role;
  select count(*) into n from public.reading_logs where plan_id = p5;
  insert into test_results (name, ok, detail) values ('T13f far-future insert denied', v_ok and n = 0, (current_date + 30)::text);

  -- T13g: a future-dated row outside the window (inserted by the admin role) cannot be edited by the client
  insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p5, ua, current_date + 30, 7);
  set local role authenticated;
  update public.reading_logs set pages_read = 99 where plan_id = p5 and log_date = current_date + 30;
  get diagnostics n = row_count;
  reset role;
  select pages_read into v from public.reading_logs where plan_id = p5 and log_date = current_date + 30;
  insert into test_results (name, ok, detail) values ('T13g out-of-window future log is read-only', n = 0 and v = 7, 'rows=' || n || ' pages=' || v);

  -- T14: reminders: plan value overrides the global default
  set local role authenticated;
  select * into r from public.plan_reminders where plan_id = p2;
  reset role;
  v_ok := r.reminders_enabled is true and r.reminder_time = time '20:30';
  set local role authenticated;
  update public.reading_plans set reminders_enabled = false, reminder_time = time '07:00' where id = p2;
  select * into r from public.plan_reminders where plan_id = p2;
  reset role;
  insert into test_results (name, ok, detail) values
    ('T14 plan reminder overrides global default', v_ok and r.reminders_enabled is false and r.reminder_time = time '07:00', r::text);

  -- ===== user B =====
  perform set_config('request.jwt.claims', json_build_object('sub', ub, 'role', 'authenticated')::text, true);

  -- T15: B cannot see or change A's plans or log into them
  set local role authenticated;
  select count(*) into n from public.reading_plans;
  update public.reading_plans set target_pages = 5 where id = p2;
  get diagnostics v = row_count;
  reset role;
  v_ok := false;
  begin
    set local role authenticated;
    insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p2, ub, current_date, 1);
  exception when insufficient_privilege or foreign_key_violation then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T15 other user is isolated', n = 0 and v = 0 and v_ok, 'visible=' || n || ' updated=' || v);

  -- ===== groups =====
  perform set_config('request.jwt.claims', json_build_object('sub', ua, 'role', 'authenticated')::text, true);
  set local role authenticated;
  insert into public.groups (owner_id, name, book_title, total_pages, days_duration, privacy)
  values (ua, 'verify group', 'x', 100, 30, 'private') returning id, join_code into g, v_code;
  reset role;
  select count(*) into n from public.group_members where group_id = g and user_id = ua and role = 'owner';
  insert into test_results (name, ok, detail) values ('T16 creator becomes owner member', n = 1, v_code);

  -- T16b: an ARCHIVED plan (p1) cannot be linked to a group member
  v_ok := false;
  begin
    set local role authenticated;
    update public.group_members set plan_id = p1 where group_id = g and user_id = ua;
  exception when check_violation then v_ok := true;
  end;
  reset role;
  select count(*) into n from public.group_members
   where group_id = g and user_id = ua and plan_id is null and progress_percent = 0;
  insert into test_results (name, ok, detail) values ('T16b archived plan cannot be linked', v_ok and n = 1, null);

  -- T16c: a COMPLETED plan (p3) cannot be linked either
  v_ok := false;
  begin
    set local role authenticated;
    update public.group_members set plan_id = p3 where group_id = g and user_id = ua;
  exception when check_violation then v_ok := true;
  end;
  reset role;
  select count(*) into n from public.group_members
   where group_id = g and user_id = ua and plan_id is null and progress_percent = 0;
  insert into test_results (name, ok, detail) values ('T16c completed plan cannot be linked', v_ok and n = 1, null);

  perform set_config('request.jwt.claims', json_build_object('sub', ub, 'role', 'authenticated')::text, true);
  set local role authenticated;
  select count(*) into n from public.groups where id = g;           -- private: hidden before joining
  perform public.join_group_by_code(v_code);
  select count(*) into v from public.groups where id = g;           -- visible after joining
  reset role;
  insert into test_results (name, ok, detail) values ('T17 private group hidden until joined by code', n = 0 and v = 1, 'before=' || n || ' after=' || v);

  -- T18: a member cannot link someone else's plan
  v_ok := false;
  begin
    set local role authenticated;
    update public.group_members set plan_id = p2 where group_id = g and user_id = ub;
  exception when insufficient_privilege then v_ok := true;
  end;
  reset role;
  insert into test_results (name, ok, detail) values ('T18 cannot link another user''s plan', v_ok, null);

  -- T19: member links own plan (any book); its progress flows to the group
  perform set_config('request.jwt.claims', json_build_object('sub', ua, 'role', 'authenticated')::text, true);
  set local role authenticated;
  update public.group_members set plan_id = p2 where group_id = g and user_id = ua;
  insert into public.reading_logs (plan_id, user_id, log_date, pages_read) values (p2, ua, current_date, 10);
  reset role;
  select progress_percent into v from public.group_members where group_id = g and user_id = ua;
  insert into test_results (name, ok, detail) values ('T19 member progress follows own plan', v = 10, v::text);

  -- T20: group_overview has a member count and no collective-progress column
  set local role authenticated;
  select member_count into v from public.group_overview where id = g;
  reset role;
  select count(*) into n from information_schema.columns
   where table_schema = 'public' and table_name = 'group_overview' and column_name = 'collective_progress';
  insert into test_results (name, ok, detail) values ('T20 member_count=2, no collective_progress', v = 2 and n = 0, 'members=' || v);
end;
$$;

select n, name, ok, detail from test_results
union all
select 9999, 'SUMMARY: every check passed',
       count(*) filter (where ok is not true) = 0,
       count(*) filter (where ok is not true)::text || ' failed of ' || count(*)::text
  from test_results
order by n;

rollback;
