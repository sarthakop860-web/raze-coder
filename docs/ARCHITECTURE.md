# Architecture and implementation notes

```text
React + TypeScript + Vite
  ├─ Public pages: home / events / event detail / schedule / about / FAQ / contact
  ├─ Auth pages: sign in / sign up / password reset
  ├─ User dashboard: profile / bookmarks
  ├─ Admin workspace: event CRUD / publish / FAQ / message review
  └─ Supabase JS client
       ├─ Supabase Auth
       ├─ PostgreSQL + RLS
       ├─ Storage: event-media bucket
       └─ Edge Function: contact-submit (server-side service role)
```

## Trust boundaries
- Browser only receives Supabase anon key.
- `profiles.role` is not included in self-update policy. Bootstrap admin role through trusted SQL.
- `public.is_admin()` checks the role in PostgreSQL and is used by admin policies.
- Contact form insert is performed by an Edge Function using server-side service-role secret; never expose that secret to the browser.
- Storage writes are restricted to database-authorized admins.

## Known next tasks
1. Add category and schedule edit flows; create/delete flows are implemented.
2. Add secure rate limiting and CAPTCHA to contact function.
3. Add tests (Vitest/RTL and Playwright) for auth, RLS, admin and responsive behavior.
4. Add image upload with file MIME/size validation and storage path handling.
5. Add admin audit log, user moderation and pagination.
