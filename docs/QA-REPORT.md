# QA report — rebuild milestone

Date: 20 November 2026

## Checks completed in this environment
- TypeScript/TSX transpilation syntax pass: zero parser diagnostics across source `.ts` and `.tsx` files.
- Relative source import scan: all local TypeScript imports resolve; CSS import is intentionally handled by Vite.
- CSS parser validation: passed.
- JSON validation: `package.json`, `tsconfig.json`, `tsconfig.app.json`, and `tsconfig.node.json` parsed successfully.
- Import-use scan: no likely unused imports found.
- Security review of the authored migration: user profile role changes are blocked by a database trigger; admin operations rely on a database-side `is_admin()` function; contact submissions are server-side; service-role credentials are not used by frontend code.

## Checks not completed
- `npm install` could not complete because the package registry was not reachable from this execution environment. Offline installation also failed because the dependencies were not cached.
- Consequently, `tsc -b`, Vite production build, browser rendering, Lighthouse, and end-to-end tests could not be completed here.
- Supabase SQL was authored but could not be executed against a live project. RLS, Edge Function deployment, auth emails, Storage policies and database CRUD still require validation in the owner's Supabase project.
- Vercel deployment was not performed.

## Release gate
Do not call this production-ready until dependencies install, the production build passes, the migration is applied to a test Supabase project, RLS tests pass for anonymous/user/admin accounts, and the deployed site is smoke-tested on mobile and desktop.

## Sample content addition
- Added `supabase/seed.sql` with 10 illustrative events, 10 schedule rows across the two demo dates, and 8 sample FAQs.
- The script uses stable event/category slugs and can be re-run without duplicating the seeded event and schedule records.
- Sample FAQ answers explicitly warn that official registration, participation rules, venue details and certificates must be confirmed.
- Database execution has not been performed against the user's Supabase project; run the seed file in Supabase SQL Editor and check the count queries at the end.
