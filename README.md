# ABS Fitness

Gym management app for **ABS Fitness Zone**: one Flutter codebase serving
Owner, Front desk, Trainer and Member on Android, iOS and web, backed by
Supabase (free tier). The implementation spec is the single source of truth.
Every judgement call is recorded in [DECISIONS.md](DECISIONS.md).

| Milestone | Scope | Status |
| --- | --- | --- |
| **M0 Foundations** | Theme tokens, core components + Gallery, staff & member auth, role-guarded router, CI, database foundations | ✅ Done ([report](docs/milestones/M0.md)) |
| M1 Members | F1 complete, import, check-in, status engine, dashboard counts | Next |
| M2 Payments | F2, receipts, UPI QR, day close, dues engine | — |
| M3 Exercise library + Workouts | F4, F5, member app shell, workout player | — |
| M4 Diet | F6 | — |
| M5 WhatsApp | F8 | — |
| M6 AI automation | F7 | — |
| M7 Reports | F15 | — |
| M8 Website + launch | F14, launch checklist | — |

## Project layout

```
lib/
  main.dart                 env, Sentry, Supabase init, ProviderScope
  app/                      app.dart, router.dart + routes.dart (role guards), env.dart
    theme/                  tokens, colors, typography, motion, theme
    l10n/                   app_en.arb, app_hi.arb (Hindi added later, no code changes)
  core/
    widgets/                design-system components (see the Gallery)
    utils/                  money.dart (paise), dates.dart (IST), phone.dart (+91)
  features/
    auth/                   data / domain / application / presentation
    settings/               More, staff roster + invite, member PIN, appearance
    member_home/            member onboarding + profile
    gallery/                hidden component gallery
    shell/                  adaptive staff/member shells
supabase/
  migrations/               SQL, one per milestone
  functions/                Edge Functions (Deno/TypeScript)
  tests/                    RLS tests (plain SQL) + local Supabase stub
test/                       unit, widget, golden (screenshots) tests
.github/workflows/          ci.yml, release.yml, backup.yml, keepalive.yml
```

## Run the app

Requirements: Flutter **3.47.9** (stable), Java 17 and the Android SDK for
Android builds.

```bash
flutter pub get
```

```bash
dart run build_runner build --delete-conflicting-outputs
```

Create `env/dev.json` from `env/example.json` with your Supabase project URL and
anon (publishable) key. Files in `env/` are git-ignored, except the example.

```bash
flutter run --dart-define-from-file=env/dev.json
```

Without a backend (`flutter run` with no env file) the app opens on the welcome
screen with sign-in disabled. Long-press the **ABS** logo to open the component
gallery.

Build an Android APK:

```bash
flutter build apk --release --dart-define-from-file=env/prod.json
```

## Supabase setup (once per environment: dev and prod)

1. Create a free Supabase project with the gym's Gmail ID.
2. Apply the migrations and deploy the functions with the Supabase CLI:

   ```bash
   supabase link --project-ref YOUR_PROJECT_REF
   ```

   ```bash
   supabase db push
   ```

   ```bash
   supabase functions deploy
   ```

3. Under **Authentication → Providers → Email**, turn off public sign-ups. Staff
   accounts are created by the owner, and member logins by the front desk.
4. Create the owner's login under **Authentication → Users → Add user** (email
   and password), then make it the owner in the SQL editor:

   ```sql
   select public.bootstrap_owner('owner@gmail.com', 'Owner Name');
   ```

5. The owner signs in, then uses **More → Staff → Invite staff** to add front
   desk and trainers. Each person gets a one-time temporary password and must
   set their own password on first sign-in.
6. To let a member sign in, front desk uses **More → Member PIN** to set a
   4-digit PIN. This also creates the member's app login. Members are added in
   M1; until then, insert one in the SQL editor:

   ```sql
   insert into public.members (name, phone) values ('Test Member', '+919876543210');
   ```

## Tests

```bash
flutter test
```

Runs unit, widget and golden tests. Goldens double as the light/dark
screenshots in `test/goldens/`. To regenerate them after an intended UI
change:

```bash
flutter test --update-goldens --tags golden
```

Edge Function tests:

```bash
cd supabase/functions && deno test --allow-env
```

Database migrations and RLS tests, against any Postgres 16. CI uses a
`postgres:16` service:

```bash
PGHOST=localhost PGUSER=postgres PGPASSWORD=postgres scripts/test_db.sh
```

## CI/CD (GitHub Actions)

- **ci.yml**: on every pull request: format, analyze, Flutter tests, Edge
  Function type-check and tests, migrations and RLS tests. On every push to
  `main` it also builds an installable APK (downloadable from the run's
  artifacts).
- **release.yml**: on a `v*` tag: builds the APK, AAB and web app, attaches the
  APK to a GitHub release, and, when secrets are present, deploys web to
  Cloudflare Pages and pushes migrations and functions to Supabase.
- **backup.yml**: nightly `pg_dump` to Google Drive at 02:00 IST (keeps 30
  daily and 12 monthly).
- **keepalive.yml**: pings Supabase every 6 hours so the free project never
  pauses.

Repository secrets used by these workflows (all optional; each step skips
cleanly when its secret is absent): `ENV_PROD_JSON`,
`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`,
`ANDROID_KEY_PASSWORD`, `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`,
`SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_PASSWORD`, `SUPABASE_PROJECT_REF`,
`SUPABASE_DB_URL`, `RCLONE_CONFIG_B64`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `ENV_DEV_JSON`.

No secret ever ships in the app. The service-role key exists only inside Edge
Functions.
