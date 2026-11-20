-- TECHNIKA 6.0 — SAMPLE / DEMO CONTENT
-- Run this AFTER supabase/migrations/0001_schema.sql in Supabase SQL Editor.
-- IMPORTANT: These event titles, descriptions, time slots, venues and FAQ answers
-- are illustrative demo content created for development. They are NOT verified
-- official Technika 6.0 programme details. Replace/confirm before public launch.

begin;

-- Categories (idempotent)
insert into public.event_categories (name, slug, description) values
  ('Technical', 'technical', 'Illustrative engineering, coding and maker challenges.'),
  ('Creative', 'creative', 'Illustrative design, media and creative technology sessions.'),
  ('Cultural', 'cultural', 'Illustrative performance and campus culture events.'),
  ('Gaming', 'gaming', 'Illustrative competitive and casual gaming events.')
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description;

-- Events (idempotent by slug)
insert into public.events
  (category_id, title, slug, description, event_date, start_time, end_time, venue, is_published)
select c.id, v.title, v.slug, v.description, v.event_date::date,
       v.start_time::time, v.end_time::time, v.venue, true
from (values
  ('technical','RoboRumble','roborumble-demo','DEMO EVENT — Build, tune and test a robot through a sequence of obstacle and precision challenges. Team size and rules are illustrative and must be confirmed.','2026-11-20','09:30','12:00','Demo venue — confirm'),
  ('technical','CodeSprint','codesprint-demo','DEMO EVENT — A timed programming challenge focused on logic, debugging and creative problem solving. Languages and eligibility are illustrative.','2026-11-20','10:00','12:00','Computer Lab — demo location'),
  ('creative','Pixel to Poster','pixel-to-poster-demo','DEMO EVENT — Create a visual identity for a surprise brief using digital design tools. Submission format and judging criteria require confirmation.','2026-11-20','13:00','15:00','Design Studio — demo location'),
  ('gaming','Arena Clash','arena-clash-demo','DEMO EVENT — A friendly esports bracket concept. Game title, platform, team size and tournament rules must be confirmed by organisers.','2026-11-20','14:00','17:00','Gaming Zone — demo location'),
  ('cultural','The Open Mic','the-open-mic-demo','DEMO EVENT — A live stage for music, poetry, stand-up and spoken word. Performance duration and registration rules are illustrative.','2026-11-20','16:00','18:00','Open Stage — demo location'),
  ('technical','Buildathon Lab','buildathon-lab-demo','DEMO EVENT — Small teams prototype a solution to a practical prompt and present their process. Theme, judging and deliverables require confirmation.','2026-11-21','09:00','13:00','Innovation Lab — demo location'),
  ('creative','Frame by Frame','frame-by-frame-demo','DEMO EVENT — A short-form filmmaking and editing challenge built around a creative prompt. Equipment and submission rules are illustrative.','2026-11-21','10:00','12:30','Media Room — demo location'),
  ('cultural','Rhythm Collective','rhythm-collective-demo','DEMO EVENT — A group performance showcase celebrating movement, music and collaboration. Format and stage timings require confirmation.','2026-11-21','14:00','16:00','Main Stage — demo location'),
  ('technical','Circuit Quest','circuit-quest-demo','DEMO EVENT — A hands-on electronics puzzle involving circuit reading, component selection and troubleshooting. Materials and safety rules require confirmation.','2026-11-21','13:00','15:00','Electronics Lab — demo location'),
  ('gaming','Final Boss Showdown','final-boss-showdown-demo','DEMO EVENT — A final-round gaming showcase for qualified participants. Game, format and qualification details are illustrative.','2026-11-21','16:00','18:00','Gaming Zone — demo location')
) as v(category_slug,title,slug,description,event_date,start_time,end_time,venue)
join public.event_categories c on c.slug = v.category_slug
on conflict (slug) do update set
  category_id = excluded.category_id,
  title = excluded.title,
  description = excluded.description,
  event_date = excluded.event_date,
  start_time = excluded.start_time,
  end_time = excluded.end_time,
  venue = excluded.venue,
  is_published = true,
  updated_at = now();

-- Replace only this demo dataset's schedule rows, then recreate them.
delete from public.event_schedules s
using public.events e
where s.event_id = e.id
  and e.slug in (
    'roborumble-demo','codesprint-demo','pixel-to-poster-demo','arena-clash-demo',
    'the-open-mic-demo','buildathon-lab-demo','frame-by-frame-demo',
    'rhythm-collective-demo','circuit-quest-demo','final-boss-showdown-demo'
  );

insert into public.event_schedules (event_id, starts_at, ends_at, venue)
select e.id, v.starts_at::timestamptz, v.ends_at::timestamptz, v.venue
from (values
  ('roborumble-demo','2026-11-20 09:30:00+05:30','2026-11-20 12:00:00+05:30','Demo venue — confirm'),
  ('codesprint-demo','2026-11-20 10:00:00+05:30','2026-11-20 12:00:00+05:30','Computer Lab — demo location'),
  ('pixel-to-poster-demo','2026-11-20 13:00:00+05:30','2026-11-20 15:00:00+05:30','Design Studio — demo location'),
  ('arena-clash-demo','2026-11-20 14:00:00+05:30','2026-11-20 17:00:00+05:30','Gaming Zone — demo location'),
  ('the-open-mic-demo','2026-11-20 16:00:00+05:30','2026-11-20 18:00:00+05:30','Open Stage — demo location'),
  ('buildathon-lab-demo','2026-11-21 09:00:00+05:30','2026-11-21 13:00:00+05:30','Innovation Lab — demo location'),
  ('frame-by-frame-demo','2026-11-21 10:00:00+05:30','2026-11-21 12:30:00+05:30','Media Room — demo location'),
  ('circuit-quest-demo','2026-11-21 13:00:00+05:30','2026-11-21 15:00:00+05:30','Electronics Lab — demo location'),
  ('rhythm-collective-demo','2026-11-21 14:00:00+05:30','2026-11-21 16:00:00+05:30','Main Stage — demo location'),
  ('final-boss-showdown-demo','2026-11-21 16:00:00+05:30','2026-11-21 18:00:00+05:30','Gaming Zone — demo location')
) as v(event_slug,starts_at,ends_at,venue)
join public.events e on e.slug = v.event_slug;

-- FAQs: sample answers are intentionally cautious and do not invent official rules.
insert into public.faqs (question, answer, category, sort_order, is_published) values
  ('How do I register for an event?','DEMO ANSWER — Registration instructions have not been verified. Check the official Technika 6.0 website and organiser announcements for the confirmed registration process.','Registration',1,true),
  ('Can I participate in more than one event?','DEMO ANSWER — The participation limit may differ by event. Please confirm eligibility, schedule clashes and registration limits with the event organisers before signing up.','Participation',2,true),
  ('Where will the events take place?','DEMO ANSWER — The venues shown in this demo schedule are placeholders. Confirm the final venue and room details through official event communications.','Venue',3,true),
  ('Will certificates be provided?','DEMO ANSWER — Certificate availability and eligibility have not been confirmed in this demo. Please ask the organisers for the official policy.','General',4,true),
  ('What should I bring on the day?','DEMO ANSWER — Requirements depend on the event. Wait for the official participant instructions; do not assume that equipment, laptops or materials will be provided.','Preparation',5,true),
  ('Who can I contact for event-specific questions?','DEMO ANSWER — Use the verified contact details published by the university or event organisers. This independent demo website is not an official support channel.','Contact',6,true),
  ('Are the timings on this website final?','No. The current entries are illustrative sample data for demonstrating the website. They are not an official timetable and must be replaced with confirmed timings before publication.','Schedule',7,true),
  ('Is this the official Technika 6.0 website?','No. This is an independently developed student competition project. It is not operated by ARKA JAIN University and does not imply university endorsement.','About this website',8,true)
on conflict do nothing;

commit;

-- Quick verification queries. Expected demo counts: 10 events, 10 schedule rows, 8 FAQs.
select 'published_demo_events' as check_name, count(*) as total
from public.events where slug like '%-demo' and is_published = true;
select 'demo_schedule_rows' as check_name, count(*) as total
from public.event_schedules s join public.events e on e.id=s.event_id where e.slug like '%-demo';
select 'published_faqs' as check_name, count(*) as total
from public.faqs where is_published = true;
