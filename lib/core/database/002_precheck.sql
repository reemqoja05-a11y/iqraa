-- =====================================================================
-- Iqraa - supabase/tests/002_precheck.sql   (READ ONLY, changes nothing)
-- Run BEFORE 002_fixes.sql and send me the three result tables.
-- =====================================================================

-- A. Every distinct category stored in books (length helps spot hidden characters)
select category, length(category) as chars, count(*) as books
from public.books
group by category
order by books desc, category;

-- B. Every book with its category
select title, author, category
from public.books
order by category, title;

-- C. Plans whose logs already add up to MORE than target_pages (expected: no rows)
select p.id as plan_id, p.target_pages, sum(l.pages_read) as logged
from public.reading_plans p
join public.reading_logs l on l.plan_id = p.id
group by p.id, p.target_pages
having sum(l.pages_read) > p.target_pages;
