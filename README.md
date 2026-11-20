# TECHNIKA 6.0 — Independent Festival Experience

A premium, independently designed full-stack festival website built with React, TypeScript, Vite and Supabase. This is a student competition project and is **not** the official ARKA JAIN University website.

## Included
- Responsive editorial design system with custom motion, hover interactions, animated ticker, hero orbit, page transitions and reduced-motion support.
- Home, event directory, event details, schedule, about, FAQ and contact pages.
- Supabase-backed event/category/schedule/FAQ reads.
- Supabase Auth sign-up, sign-in, password reset, profile and user bookmark shortlist.
- Admin workspace for event CRUD, publish/unpublish, FAQ creation/deletion and message review.
- PostgreSQL schema, indexes, triggers, RLS, storage bucket policies and contact Edge Function.

## Local setup
1. Install Node.js 20+.
2. Run `npm install`.
3. Copy `.env.example` to `.env.local` and set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.
4. In Supabase SQL Editor, run `supabase/migrations/0001_schema.sql`.
5. Deploy the Edge Function: `supabase functions deploy contact-submit`.
6. Set Edge Function secrets `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, and optionally `ALLOWED_ORIGIN` using Supabase secrets. Never expose service-role credentials in Vite variables.
7. Run `npm run dev`; validate with `npm run typecheck` and `npm run build`.

## First admin
Sign up normally. Then in the Supabase SQL Editor, run the commented bootstrap statement in the migration with the exact administrator email. The role cannot be changed by a normal user through profile update policies. Admin authorization is checked by the database function `public.is_admin()`.

## Data policy
No fabricated official event names, event descriptions, schedules or rules are seeded. The public site displays a clear empty state until verified records are entered. Add verified event data in the admin workspace after creating an administrator. Use the `content_sources` table to record source URLs and verification notes.

## Contact function and abuse controls
The contact form calls an Edge Function; public direct inserts into `contact_messages` are blocked by RLS. The function validates input, uses a honeypot, and enforces an atomic limit of five messages per hashed IP in a ten-minute window. Before production launch, add CAPTCHA/Turnstile, configure `ALLOWED_ORIGIN` to the deployed domain, and monitor function logs.

## Deployment
- Deploy the Vite frontend to Vercel.
- Configure `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in Vercel project environment variables.
- Configure Supabase Auth redirect URLs for local and production domains.
- Deploy Edge Functions and set server-only secrets in Supabase.
- Ensure Storage and RLS policies are applied.

## Important limitations before production
A Supabase project and credentials must be supplied/configured by the owner. This environment cannot create or access your Supabase project, set production secrets, verify live authentication, deploy to your Vercel account, or certify production behavior. The admin workspace includes event CRUD and publishing, category creation/deletion, schedule slot creation/deletion, FAQ creation/deletion, contact-message review and event image upload. Category editing, schedule editing, FAQ editing, user moderation and audit logging remain follow-on work. The migration establishes schema and policies, but must be tested against real Supabase accounts before launch.

## Originality
The design system and component code are independently authored for this project. External factual event information must be verified and attributed. Google Fonts and Lucide React are third-party dependencies; review their current licenses. No automated plagiarism percentage or certified originality claim is made. Run a final manual side-by-side comparison with the official reference and any required institutional branding guidelines.

## Load sample events, schedule and FAQs
After applying `supabase/migrations/0001_schema.sql`, open Supabase **SQL Editor** and run `supabase/seed.sql`.

The seed script adds 10 illustrative demo events across four categories, 10 schedule entries across 20–21 November 2026, and 8 sample FAQs. It is safe to re-run for the event and schedule records. FAQ rows are inserted without deleting existing FAQ content.

**Important:** Event names, time slots, venues, descriptions and FAQ answers are sample/demo content, not verified official programme information. They are labelled as demo content in their copy. Replace or verify them with the organisers before publishing the website publicly.
