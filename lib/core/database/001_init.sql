-- =====================================================================
-- Iqraa (اقرأ) — supabase/migrations/001_init.sql   (revision 4)
-- Supabase Dashboard > SQL Editor > New query > paste all > Run.
-- Assumes a FRESH project (no tables from the earlier draft were created).
-- Requires PostgreSQL 15+ (security_invoker views). Re-runnable.
-- Wrapped in one transaction: if any statement fails, nothing is applied.
-- =====================================================================
begin;

-- ---------------------------------------------------------------------
-- 1. TABLES
-- ---------------------------------------------------------------------

-- Settings screen: name, email (email stays in auth.users), avatar, and the GLOBAL
-- reminder defaults (daily reminder time tile + reminders switch; UI default 08:30 pm).
create table if not exists public.profiles (
  id                uuid primary key references auth.users (id) on delete cascade,
  name              text not null default '',
  avatar_url        text,
  reminders_enabled boolean not null default true,
  reminder_time     time not null default '20:30',
  created_at        timestamptz not null default now()
);

-- Library / book details / home. Catalog is read-only for app users.
create table if not exists public.books (
  id            uuid primary key default gen_random_uuid(),
  title         text not null,
  author        text not null,
  category      text not null,
  page_count    integer not null check (page_count > 0),
  rating        numeric(2,1) not null default 0 check (rating between 0 and 5),
  rating_count  integer not null default 0 check (rating_count >= 0),
  cover_url     text not null default '',
  summary       text,
  is_bestseller boolean not null default false,
  created_at    timestamptz not null default now(),
  unique (title, author)
);
create index if not exists books_category_idx on public.books (category);

-- AppController.ownedBooks (add to / remove from "my library").
create table if not exists public.user_library (
  user_id  uuid not null references public.profiles (id) on delete cascade,
  book_id  uuid not null references public.books (id) on delete cascade,
  added_at timestamptz not null default now(),
  primary key (user_id, book_id)
);

-- AppController.favoriteIds (heart button in library_screen).
create table if not exists public.favorites (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  book_id    uuid not null references public.books (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, book_id)
);

-- ReadingPlan model. "Deleting" a plan = is_active := false (archive), so its
-- logs and the user's statistics are kept. completed_pages / completed_at are
-- written only by triggers (clients cannot set them).
-- completed_at feeds the certificate card (completion date, days to finish).
create table if not exists public.reading_plans (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references public.profiles (id) on delete cascade,
  book_id           uuid not null references public.books (id) on delete restrict,
  start_date        date not null default current_date,
  target_date       date not null,
  target_pages      integer not null check (target_pages > 0),
  completed_pages   integer not null default 0,
  is_active         boolean not null default true,
  completed_at      timestamptz,
  reminders_enabled boolean,   -- NULL = inherit profiles.reminders_enabled
  reminder_time     time,      -- NULL = inherit profiles.reminder_time
  created_at        timestamptz not null default now(),
  constraint plans_dates_ok check (target_date >= start_date),
  constraint plans_pages_ok check (completed_pages between 0 and target_pages),
  unique (id, user_id)
);
-- At most one ACTIVE plan (not archived and not completed) per user per book.
-- Archived and completed plans are unlimited, so a new plan for the same book
-- can be created later while the old plan and its history stay intact.
create unique index if not exists reading_plans_one_active_per_book
  on public.reading_plans (user_id, book_id) where is_active and completed_at is null;
create index if not exists reading_plans_user_idx on public.reading_plans (user_id);

-- ReadingRecord model. One entry per plan per day (the app already refuses a
-- second save on the same day). pages_read = pages added by that save.
create table if not exists public.reading_logs (
  id         uuid primary key default gen_random_uuid(),
  plan_id    uuid not null,
  user_id    uuid not null,
  log_date   date not null default current_date,
  pages_read integer not null check (pages_read > 0),
  created_at timestamptz not null default now(),
  constraint reading_logs_plan_fk
    foreign key (plan_id, user_id)
    references public.reading_plans (id, user_id) on delete cascade,
  unique (plan_id, log_date)
);
create index if not exists reading_logs_user_date_idx on public.reading_logs (user_id, log_date);

-- ReadingGroup model. book_* is the group's featured book (display only);
-- members may read different books (see group_members.plan_id).
create table if not exists public.groups (
  id             uuid primary key default gen_random_uuid(),
  owner_id       uuid not null references public.profiles (id) on delete cascade,
  name           text not null check (char_length(btrim(name)) > 0),
  description    text not null default '',
  join_code      text not null unique
                 default ('IQRA-' || upper(substr(md5(gen_random_uuid()::text), 1, 6))),
  book_title     text not null,
  book_cover_url text not null default '',
  total_pages    integer not null check (total_pages > 0),
  days_duration  integer not null check (days_duration > 0),
  privacy        text not null default 'private' check (privacy in ('private', 'public')),
  is_challenge   boolean generated always as (days_duration <= 30) stored,
  created_at     timestamptz not null default now()
);

-- GroupMember model. plan_id = the member's own ACTIVE reading plan (not archived,
-- not completed) that counts for this group (any book). progress_percent is
-- maintained by triggers.
create table if not exists public.group_members (
  group_id         uuid not null references public.groups (id) on delete cascade,
  user_id          uuid not null references public.profiles (id) on delete cascade,
  role             text not null default 'member' check (role in ('owner', 'member')),
  plan_id          uuid references public.reading_plans (id) on delete set null,
  progress_percent integer not null default 0 check (progress_percent between 0 and 100),
  joined_at        timestamptz not null default now(),
  primary key (group_id, user_id)
);
create index if not exists group_members_user_idx on public.group_members (user_id);
create index if not exists group_members_plan_idx on public.group_members (plan_id);

-- Group chat (group_details_screen, sendGroupMessage).
create table if not exists public.group_messages (
  id         uuid primary key default gen_random_uuid(),
  group_id   uuid not null references public.groups (id) on delete cascade,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  body       text not null check (char_length(btrim(body)) > 0),
  created_at timestamptz not null default now()
);
create index if not exists group_messages_group_idx on public.group_messages (group_id, created_at);

-- GroupVote model / castGroupVote (agree = extend). One vote per member.
create table if not exists public.group_votes (
  group_id   uuid not null references public.groups (id) on delete cascade,
  user_id    uuid not null references public.profiles (id) on delete cascade,
  agree      boolean not null,
  created_at timestamptz not null default now(),
  primary key (group_id, user_id)
);

-- ---------------------------------------------------------------------
-- 2. FUNCTIONS
-- ---------------------------------------------------------------------

-- RLS helpers (SECURITY DEFINER so policies do not recurse into RLS).
create or replace function public.is_group_member(p_group uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.group_members
    where group_id = p_group and user_id = auth.uid()
  );
$$;

create or replace function public.shares_group_with(p_user uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1
    from public.group_members a
    join public.group_members b on b.group_id = a.group_id
    where a.user_id = auth.uid() and b.user_id = p_user
  );
$$;

-- Join any group with its invite code (the only way to become a member).
create or replace function public.join_group_by_code(p_code text)
returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_group uuid;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = '28000';
  end if;

  select id into v_group
  from public.groups
  where upper(join_code) = upper(btrim(p_code));

  if v_group is null then
    raise exception 'invalid invite code' using errcode = 'P0002';
  end if;

  insert into public.group_members (group_id, user_id, role)
  values (v_group, auth.uid(), 'member')
  on conflict do nothing;

  return v_group;
end;
$$;

-- Statistics of the signed-in user. p_today lets the app pass the device's
-- local date (avoids server time-zone errors).
--   current_streak: run of consecutive reading days that ends today or yesterday.
--   Level and "commitment %" are NOT computed: the app has no formula for them.
create or replace function public.get_my_stats(p_today date default current_date)
returns table (
  books_completed  integer,
  total_pages_read integer,
  reading_days     integer,
  current_streak   integer,
  longest_streak   integer
)
language sql stable set search_path = ''
as $$
  with days as (
    select distinct l.log_date
    from public.reading_logs l
    where l.user_id = auth.uid()
  ),
  islands as (
    select log_date,
           log_date - (row_number() over (order by log_date))::integer as grp
    from days
  ),
  runs as (
    select max(log_date) as end_date, count(*)::integer as len
    from islands
    group by grp
  )
  select
    (select count(distinct p.book_id)
       from public.reading_plans p
      where p.user_id = auth.uid()
        and p.completed_pages >= p.target_pages)::integer,
    coalesce((select sum(l.pages_read)
                from public.reading_logs l
               where l.user_id = auth.uid()), 0)::integer,
    (select count(*) from days)::integer,
    coalesce((select r.len from runs r
               where r.end_date >= p_today - 1
               order by r.end_date desc limit 1), 0),
    coalesce((select max(r.len) from runs r), 0);
$$;

revoke execute on function public.is_group_member(uuid)     from public, anon;
revoke execute on function public.shares_group_with(uuid)   from public, anon;
revoke execute on function public.join_group_by_code(text)  from public, anon;
revoke execute on function public.get_my_stats(date)        from public, anon;
grant  execute on function public.is_group_member(uuid)     to authenticated;
grant  execute on function public.shares_group_with(uuid)   to authenticated;
grant  execute on function public.join_group_by_code(text)  to authenticated;
grant  execute on function public.get_my_stats(date)        to authenticated;

-- ---------------------------------------------------------------------
-- 3. TRIGGER FUNCTIONS + TRIGGERS
-- ---------------------------------------------------------------------

-- 3.1 profile row on sign-up (name comes from signUp data: {'name': ...}).
create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, name)
  values (
    new.id,
    coalesce(nullif(btrim(new.raw_user_meta_data ->> 'name'), ''),
             split_part(coalesce(new.email, ''), '@', 1))
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 3.2 completed_pages = min(target_pages, sum of the plan's logs).
create or replace function public.apply_reading_log()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  update public.reading_plans p
     set completed_pages = least(
           p.target_pages,
           coalesce((select sum(l.pages_read) from public.reading_logs l where l.plan_id = p.id), 0)
         )::integer
   where p.id = new.plan_id;
  return new;
end;
$$;

drop trigger if exists reading_logs_apply on public.reading_logs;
create trigger reading_logs_apply
  after insert or update of pages_read on public.reading_logs
  for each row execute function public.apply_reading_log();

-- 3.3 plan consistency on every update: clamp pages (like editReadingPlan)
--     and keep completed_at in step with completion.
create or replace function public.plan_before_update()
returns trigger
language plpgsql set search_path = ''
as $$
begin
  new.completed_pages := least(new.completed_pages, new.target_pages);
  if new.completed_pages >= new.target_pages then
    new.completed_at := coalesce(old.completed_at, now());
  else
    new.completed_at := null;
  end if;
  return new;
end;
$$;

drop trigger if exists reading_plans_before_update on public.reading_plans;
create trigger reading_plans_before_update
  before update on public.reading_plans
  for each row execute function public.plan_before_update();

-- 3.4 a plan's progress flows to the groups that count it.
create or replace function public.plan_sync_groups()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  update public.group_members
     set progress_percent = least(100, floor(100.0 * new.completed_pages / new.target_pages))::integer
   where plan_id = new.id;
  return new;
end;
$$;

drop trigger if exists reading_plans_sync_groups on public.reading_plans;
create trigger reading_plans_sync_groups
  after update of completed_pages, target_pages on public.reading_plans
  for each row execute function public.plan_sync_groups();

-- 3.5 creating a plan adds the book to the library (createReadingPlan does this).
create or replace function public.plan_add_to_library()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.user_library (user_id, book_id)
  values (new.user_id, new.book_id)
  on conflict do nothing;
  return new;
end;
$$;

drop trigger if exists reading_plans_add_library on public.reading_plans;
create trigger reading_plans_add_library
  after insert on public.reading_plans
  for each row execute function public.plan_add_to_library();

-- 3.6 removing a book from the library archives its plan (removeFromLibrary
--     deletes it today); logs and statistics are kept.
create or replace function public.library_archive_plan()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  update public.reading_plans
     set is_active = false
   where user_id = old.user_id
     and book_id = old.book_id
     and is_active;
  return old;
end;
$$;

drop trigger if exists user_library_archive_plan on public.user_library;
create trigger user_library_archive_plan
  after delete on public.user_library
  for each row execute function public.library_archive_plan();

-- 3.7 the creator is the first member of a new group.
create or replace function public.groups_add_owner()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.group_members (group_id, user_id, role)
  values (new.id, new.owner_id, 'owner')
  on conflict do nothing;
  return new;
end;
$$;

drop trigger if exists groups_add_owner on public.groups;
create trigger groups_add_owner
  after insert on public.groups
  for each row execute function public.groups_add_owner();

-- 3.8 linking a plan to a group: the plan must belong to that member and must be
--     active (not archived, not completed).
create or replace function public.member_sync_progress()
returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_completed integer;
  v_target    integer;
  v_active    boolean;
  v_done_at   timestamptz;
begin
  if new.plan_id is null then
    new.progress_percent := 0;
    return new;
  end if;

  select p.completed_pages, p.target_pages, p.is_active, p.completed_at
    into v_completed, v_target, v_active, v_done_at
    from public.reading_plans p
   where p.id = new.plan_id
     and p.user_id = new.user_id;

  if not found then
    raise exception 'plan does not belong to this member' using errcode = '42501';
  end if;

  if not v_active or v_done_at is not null then
    raise exception 'plan is archived or completed' using errcode = '23514';
  end if;

  new.progress_percent := least(100, floor(100.0 * v_completed / v_target))::integer;
  return new;
end;
$$;

drop trigger if exists group_members_sync_progress on public.group_members;
create trigger group_members_sync_progress
  before insert or update of plan_id on public.group_members
  for each row execute function public.member_sync_progress();

-- Trigger functions are never meant to be called by clients.
revoke execute on function public.handle_new_user()       from public, anon, authenticated;
revoke execute on function public.apply_reading_log()     from public, anon, authenticated;
revoke execute on function public.plan_before_update()    from public, anon, authenticated;
revoke execute on function public.plan_sync_groups()      from public, anon, authenticated;
revoke execute on function public.plan_add_to_library()   from public, anon, authenticated;
revoke execute on function public.library_archive_plan()  from public, anon, authenticated;
revoke execute on function public.groups_add_owner()      from public, anon, authenticated;
revoke execute on function public.member_sync_progress()  from public, anon, authenticated;

-- ---------------------------------------------------------------------
-- 4. VIEWS (security_invoker: they obey the caller's RLS)
-- ---------------------------------------------------------------------

-- groups_screen: memberCount. A collective progress value is intentionally NOT
-- computed here (no defined rule yet); per-member progress is in group_member_details.
create or replace view public.group_overview
with (security_invoker = true) as
select
  g.id, g.owner_id, g.name, g.description, g.join_code,
  g.book_title, g.book_cover_url, g.total_pages, g.days_duration,
  g.privacy, g.is_challenge, g.created_at,
  count(m.user_id)::integer as member_count
from public.groups g
left join public.group_members m on m.group_id = g.id
group by g.id;

-- group_details_screen: member tiles (name, avatar, role, progress).
create or replace view public.group_member_details
with (security_invoker = true) as
select
  m.group_id, m.user_id, m.role, m.plan_id, m.progress_percent, m.joined_at,
  coalesce(nullif(p.name, ''), 'قارئ') as name,
  p.avatar_url
from public.group_members m
left join public.profiles p on p.id = m.user_id;

-- Effective reminder settings of the user's active plans:
-- the plan's own value if set, otherwise the global default from profiles.
create or replace view public.plan_reminders
with (security_invoker = true) as
select
  p.id as plan_id,
  p.user_id,
  coalesce(p.reminders_enabled, pr.reminders_enabled) as reminders_enabled,
  coalesce(p.reminder_time, pr.reminder_time)         as reminder_time
from public.reading_plans p
join public.profiles pr on pr.id = p.user_id
where p.is_active and p.completed_at is null;

-- ---------------------------------------------------------------------
-- 5. ROW LEVEL SECURITY
-- ---------------------------------------------------------------------

alter table public.profiles       enable row level security;
alter table public.books          enable row level security;
alter table public.user_library   enable row level security;
alter table public.favorites      enable row level security;
alter table public.reading_plans  enable row level security;
alter table public.reading_logs   enable row level security;
alter table public.groups         enable row level security;
alter table public.group_members  enable row level security;
alter table public.group_messages enable row level security;
alter table public.group_votes    enable row level security;

-- profiles: yourself + people who share a group with you.
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles for select to authenticated
  using (id = auth.uid() or public.shares_group_with(id));
drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- books: read-only catalog.
drop policy if exists books_select on public.books;
create policy books_select on public.books for select to authenticated using (true);

-- user_library
drop policy if exists user_library_select on public.user_library;
create policy user_library_select on public.user_library for select to authenticated
  using (user_id = auth.uid());
drop policy if exists user_library_insert on public.user_library;
create policy user_library_insert on public.user_library for insert to authenticated
  with check (user_id = auth.uid());
drop policy if exists user_library_delete on public.user_library;
create policy user_library_delete on public.user_library for delete to authenticated
  using (user_id = auth.uid());

-- favorites
drop policy if exists favorites_select on public.favorites;
create policy favorites_select on public.favorites for select to authenticated
  using (user_id = auth.uid());
drop policy if exists favorites_insert on public.favorites;
create policy favorites_insert on public.favorites for insert to authenticated
  with check (user_id = auth.uid());
drop policy if exists favorites_delete on public.favorites;
create policy favorites_delete on public.favorites for delete to authenticated
  using (user_id = auth.uid());

-- reading_plans: owner only. No DELETE policy: plans are archived, never removed.
drop policy if exists reading_plans_select on public.reading_plans;
create policy reading_plans_select on public.reading_plans for select to authenticated
  using (user_id = auth.uid());
drop policy if exists reading_plans_insert on public.reading_plans;
create policy reading_plans_insert on public.reading_plans for insert to authenticated
  with check (user_id = auth.uid()
              and is_active
              and completed_pages = 0
              and completed_at is null);
drop policy if exists reading_plans_update on public.reading_plans;
create policy reading_plans_update on public.reading_plans for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- reading_logs: owner reads, adds (to own ACTIVE, non-completed plan) and corrects
-- pages_read (only while the plan is not completed). No DELETE policy.
-- Date rule: the device's local date is accepted only if some time zone on Earth is
-- currently on that date (UTC-12 .. UTC+14). Future dates and old dates are rejected,
-- while a reader at any local time (e.g. 1 am in UTC+3) is never refused.
drop policy if exists reading_logs_select on public.reading_logs;
create policy reading_logs_select on public.reading_logs for select to authenticated
  using (user_id = auth.uid());
drop policy if exists reading_logs_insert on public.reading_logs;
create policy reading_logs_insert on public.reading_logs for insert to authenticated
  with check (user_id = auth.uid()
              and log_date between (timezone('utc', now()) - interval '12 hours')::date
                               and (timezone('utc', now()) + interval '14 hours')::date
              and exists (select 1 from public.reading_plans p
                          where p.id = reading_logs.plan_id
                            and p.user_id = auth.uid()
                            and p.is_active
                            and p.completed_at is null));
drop policy if exists reading_logs_update on public.reading_logs;
create policy reading_logs_update on public.reading_logs for update to authenticated
  using (user_id = auth.uid()
         and log_date between (timezone('utc', now()) - interval '12 hours')::date
                          and (timezone('utc', now()) + interval '14 hours')::date
         and exists (select 1 from public.reading_plans p
                     where p.id = reading_logs.plan_id
                       and p.user_id = auth.uid()
                       and p.completed_at is null))
  with check (user_id = auth.uid()
              and log_date between (timezone('utc', now()) - interval '12 hours')::date
                               and (timezone('utc', now()) + interval '14 hours')::date
              and exists (select 1 from public.reading_plans p
                          where p.id = reading_logs.plan_id
                            and p.user_id = auth.uid()
                            and p.completed_at is null));

-- groups: public ones visible to everyone, private ones to members/owner.
drop policy if exists groups_select on public.groups;
create policy groups_select on public.groups for select to authenticated
  using (privacy = 'public' or owner_id = auth.uid() or public.is_group_member(id));
drop policy if exists groups_insert on public.groups;
create policy groups_insert on public.groups for insert to authenticated
  with check (owner_id = auth.uid());

-- group_members: no INSERT policy (joining goes through join_group_by_code and
-- the group-creation trigger). Members may change only their own plan_id.
drop policy if exists group_members_select on public.group_members;
create policy group_members_select on public.group_members for select to authenticated
  using (public.is_group_member(group_id)
         or exists (select 1 from public.groups g
                    where g.id = group_members.group_id and g.privacy = 'public'));
drop policy if exists group_members_update on public.group_members;
create policy group_members_update on public.group_members for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- group_messages: members only; messages cannot be edited or deleted.
drop policy if exists group_messages_select on public.group_messages;
create policy group_messages_select on public.group_messages for select to authenticated
  using (public.is_group_member(group_id));
drop policy if exists group_messages_insert on public.group_messages;
create policy group_messages_insert on public.group_messages for insert to authenticated
  with check (user_id = auth.uid() and public.is_group_member(group_id));

-- group_votes: members only; one own vote that can be changed.
drop policy if exists group_votes_select on public.group_votes;
create policy group_votes_select on public.group_votes for select to authenticated
  using (public.is_group_member(group_id));
drop policy if exists group_votes_insert on public.group_votes;
create policy group_votes_insert on public.group_votes for insert to authenticated
  with check (user_id = auth.uid() and public.is_group_member(group_id));
drop policy if exists group_votes_update on public.group_votes;
create policy group_votes_update on public.group_votes for update to authenticated
  using (user_id = auth.uid() and public.is_group_member(group_id))
  with check (user_id = auth.uid() and public.is_group_member(group_id));

-- Column-level protection: the client may update ONLY these columns.
revoke update on public.profiles, public.reading_plans, public.reading_logs, public.group_members
  from authenticated, anon;
grant update (name, avatar_url, reminders_enabled, reminder_time)
  on public.profiles to authenticated;
grant update (target_date, target_pages, is_active, reminders_enabled, reminder_time)
  on public.reading_plans to authenticated;
grant update (pages_read)
  on public.reading_logs to authenticated;

-- reading_logs least privilege: no anonymous access, no delete/truncate, and clients
-- may only fill the four business columns on insert (id and created_at stay server-made).
revoke all on public.reading_logs from anon;
revoke insert, delete, truncate, references, trigger on public.reading_logs from authenticated;
grant insert (plan_id, user_id, log_date, pages_read)
  on public.reading_logs to authenticated;
grant update (plan_id)
  on public.group_members to authenticated;

-- ---------------------------------------------------------------------
-- 6. SEED DATA (the 8 books of the existing mock data)
-- ---------------------------------------------------------------------

insert into public.books
  (title, author, category, page_count, rating, rating_count, cover_url, summary, is_bestseller)
values
  ('قوة العادات', 'تشارلز دوهيج', 'تطوير الذات', 280, 4.8, 1850, 'https://lh3.googleusercontent.com/aida-public/AB6AXuA-rpoaZ3jEjWgWkz_RGrnrD6zgvwB7rVXzmkznbWOZwkN3gIpKMyql6EVy04wGgcvk4zxtnMmXn2ZgMsO1GHpvTrjKCGUV6Vh0Z4cdewtGGCuGZ0iA64F74PnoQ8uWmTDnKo7dNyhP0PAmOU4pjNbWtUuScKN4jpXuVpDgSv6ZaeCZD7oW_28hhUApKw_mLilQcJIVFERtvkSIpTn7Smua1_c2W6PCPCO6uMCodYZEaHowcs0bfslWpw', 'يستكشف الكتاب الطبيعة العلمية للعادة، وكيف يمكن لتغيير بسيط في نمطنا اليومي وحلقات الإشارات والمكافآت أن يصنع تحولاً جذرياً في مسارات حياتنا ومؤسساتنا.', true),
  ('طريق الحكمة', 'د. طارق السويدان', 'تطوير الذات', 240, 4.6, 940, 'https://lh3.googleusercontent.com/aida-public/AB6AXuDJm5ZgXSbLSJYbnrQzUWNtS-9_zywxgfh6QN4BHHva01LOVvMfwfqxCaF8Crxty8iTmOQGHmoO11xniuON9JpanX2QGz7zyN-FjYoXgUXmTZP0ltg_jvsMtctX9iA6EUpkrZRVUxFBSVi7j3wNFXfbsWMHuIKlRxFcxD-6_S9I6DTcAaBlGiAjswpQpyoWWH07hZFdPqx1U6bEnP6HlqgOKtQHlzIXhCX6WSN9iz8hXsmiFHOrFYss4w', 'رحلة في مفاتيح الحكمة العملية والتأمل الذاتي لبناء حياة متوازنة قائمة على التفكير العميق والعمل الواعي.', false),
  ('رجال حول الرسول', 'خالد محمد خالد', 'تاريخي', 312, 4.9, 2310, 'https://lh3.googleusercontent.com/aida-public/AB6AXuA63U8Sr7JToyNgdzVTdJDQcMcbLIqQl6Iz0t-7a5IyScRCixRBxa3N-cnJVmy0cvGrYth9WVV8rlCeXLXr5wUaP-eG0mu0ZMcjFCtepcEm3YYKJ2SPyXrS8D8o3gAnW6Y3f2w38SYzUTrysU2ZqRBQy5bJWpXdxbNwuE9C0X7XKME_9u9CXQ2ydRtUmkCG6kPiai-UDONZ9CFH9XCE46M_ICvdlxiX7lvY832xyUF0Ckq9Emso82OmpA', 'سير ذاتية موجزة لأبرز صحابة الرسول صلى الله عليه وسلم ودورهم في تأسيس الحضارة الإسلامية.', false),
  ('أريد أن أعيش', 'مهدي الموسوي', 'علم النفس', 196, 4.4, 720, 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4upggKpCHO5trFbV62qphzm6wyEvdNejad4wIZF5vtJf0SxTC9BeSfflKktzy4L52UN5jKVhfAGoVJSZy_HNLIQNCNbBdgBtH-fWQJyoOXG66a81dkWhZPxqaNbPUeqFSTstQP1LZdPGXZR8jmE1ghYPeWcyf9azSmEQvwe9GRNxfJWl9Dwl2lNk41cIj-1VIoh_jRAp1g3WQdGjGgF5DgjhQKUXZopKQJk5oqhlxwQZ6xeqmWUoP2A', 'كتاب نفسي ملهم يتناول السعادة الداخلية، والتغلب على القلق، وصناعة الأمل في أصعب الظروف.', false),
  ('لأنك الله: رحلة إلى السماء السابعة', 'علي بن جابر الفيفي', 'تاريخي', 224, 4.7, 1560, 'https://lh3.googleusercontent.com/aida-public/AB6AXuD2pqWxilujJLlXIkDNQ3ZsENmhzPqcDbrJYgaWov1yohNRcoSFSPUKAYbahH0mzoyom5sK8A7-wDKUmdHDLXFGGFDjDSgqwcnrYHJqnDxcEwhjri714qaAmoTMzHkIZ88B0hMg_GWoTKDU3sRCOVD3GjNPQfKYVV4-qB7D42A7qZ2jqYttun7zOCDebJh2kTYds3QdFJy2aZDlB4m7lq8RVHcLK0XHiz3ASCK7iShpY1iKBm6gxX3OQw', 'رحلة إيمانية عميقة إلى أسماء الله الحسنى ومعانيها في حياة المسلم.', false),
  ('العادات الذرية', 'جيمس كلير', 'تطوير الذات', 320, 4.7, 4120, 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDO1_18BpKomOjqk7R7RN4hfrbsUxwPUyMiqH38DiwzzJxazQNd-IJvd7nyW9BgfS5Ioam6Se0hLa-KxvXtli27T57mqa2x-KXn4DnN3rqm5u45kgbyZJG0xtxKP5jw_P7pnO4bT7soR_xVC9ShoTMNbQJ36vWLB8X-_tu5EsxtI9oYLvs7S8ptPaLbi9B289qKnmI5BOyEcwbM9oMJwS0Eh0piVrP1HjOZGa7AGny8H0gMw2kqOfo1Q', 'دليل عملي لبناء العادات الجيدة والتخلص من السيئة من خلال تغييرات صغيرة ومتراكمة.', false),
  ('مقدمة ابن خلدون', 'عبد الرحمن بن محمد ابن خلدون', 'تاريخي', 420, 4.9, 3340, 'https://lh3.googleusercontent.com/aida-public/AB6AXuASugR8EYr9Og9IyCMGh_ohFWV-Bg6w2jHQEasCmpuzbuirRI0bazlESqAYOxoezxIXXR2sbAm9QSn4WvqK3p4bWccCqGcwo5n8ZGc4jo2f03K9AyOJzJzUl1L65SF7HzfGyZSmSCfSCwqoNJNCribyFb3DfMUUZYVM48fkfHxgn_rD1cJp_cYxYfsC3gG5i2YRt4mmDQbnFFBZy5vCGhE-u6kUZlDYcrg_ild-s5fOli3Ga3bw5uLh2Q', 'مقدمة تاريخية فلسفية في علوم العمران، وتُعتبر إحدى أهم المؤلفات في الفكر الإنساني والتاريخ.', false),
  ('طريق الحكمة وفنون العيش', 'د. عبد الرحمن الفهد', 'فلسفة وتأمل', 320, 4.5, 610, 'https://lh3.googleusercontent.com/aida-public/AB6AXuAs4GnVO8FGUn8CqMs1GYNO51s35RegbTg9E6zCz6iuYKSp5WOTyfQ9jpSCenv1HLinyVFBRVLXEWD2nPXXPEe5iD-HMy6s9Be_ooc0f1DDlbTisqNpLjUyP8RTmYEx0A_gQq3HmkZE7jm_nFgDEIUNajxeSDq5yrTjOGuvT-19jStlplxarx2L5PkWsH7ZM-f3ft3YVUfADHc3UfbyzAf2YvVsRJeXAyO3OHXSXzRXlZ3aT1TMHXU5TQ', 'قراءة معمقة لمناهج الفلسفة والتأمل الإنساني من أجل حياة أكثر وعياً وإحساساً بالمعنى.', false)
on conflict (title, author) do nothing;

-- Profiles for users who signed up before this migration ran.
insert into public.profiles (id, name)
select u.id,
       coalesce(nullif(btrim(u.raw_user_meta_data ->> 'name'), ''),
                split_part(coalesce(u.email, ''), '@', 1))
from auth.users u
on conflict (id) do nothing;

commit;
