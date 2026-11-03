# ABS Fitness

Gym management app for **ABS Fitness Zone**: one Flutter codebase serving
Owner, Front desk, Trainer and Member on Android, iOS and web, backed by
Supabase (free tier). The implementation spec is the single source of truth.
Every judgement call is recorded in [DECISIONS.md](DECISIONS.md).

| Milestone | Scope | Status |
| --- | --- | --- |
| **M0 Foundations** | Theme tokens, core components + Gallery, staff & member auth, role-guarded router, CI, database foundations | ✅ Done ([report](docs/milestones/M0.md), [fixes + redesign](docs/milestones/M0.1.md)) |
| **M1 Members** | F1: members, plans, memberships, status engine, check-in, import/export, dashboard counts | ✅ Done ([report](docs/milestones/M1.md)) |
| **M2 Payments** | F2: invoices with GST, collect in every mode, credit, instalments, UPI link + QR, member "I've paid", optional Razorpay, PDF receipts, dues + reminders, day close, expenses, revenue on the dashboard | ✅ Done ([report](docs/milestones/M2.md), [Google sign-in](docs/milestones/M2.1.md)) |
| M3 Exercise library + Workouts | F4, F5, member app shell, workout player | Next |
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
    settings/               More, staff roster (add by Gmail), gym profile, appearance
    members/                members, plans, memberships, check-in data, import
    payments/               invoices, collect sheet, receipts (PDF), day close, expenses
    checkin/                desk scanner/search, member self check-in, gym QR
    member_home/            member onboarding, home, progress, my payments + pay
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

Generated code (Riverpod, freezed, localisation) is committed, so nothing else
is needed before running. After changing a `@riverpod` / `@freezed` class,
regenerate it:

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

3. **Google sign-in (the only way in).**
   1. In [Google Cloud Console](https://console.cloud.google.com/), set up
      the OAuth consent screen (External, app name "ABS Fitness"), then go to
      **APIs & Services → Credentials → Create credentials → OAuth client
      ID → Web application**. Add this **Authorized redirect URI**:
      `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`.
   2. In Supabase, under **Authentication → Sign In / Providers → Google**,
      turn Google on and paste the client ID and client secret.
   3. Under **Authentication → Sign In / Providers → Email**, turn the Email
      provider **off**, so password and magic-link logins aren't possible.
   4. Under **Authentication → URL Configuration**, set the **Site URL** to
      the web app's address and add
      `com.absfitnesszone.app://login-callback` to **Redirect URLs** (the
      Android and iOS apps come back there after Google).
   5. Optional but recommended: under **Authentication → Hooks**, add a
      **Before User Created** hook of type Postgres pointing at
      `public.hook_before_user_created`. It refuses sign-ups that aren't
      Google, or whose Gmail isn't on a staff or member record, so strangers
      never get an account.
4. Make the owner, in the SQL editor, with the owner's Gmail:

   ```sql
   select public.bootstrap_owner('owner@gmail.com', 'Owner Name');
   ```

   Then the owner taps **Continue with Google** in the app. (The order
   doesn't matter: signing in first and running this afterwards also works.)
5. The M1 and M2 migrations also set up these Supabase pieces when they're
   available:
   - The nightly status refresh at 00:05 IST and dues refresh at 00:10 IST
     (`pg_cron`). If `pg_cron` isn't enabled, enable it under **Database →
     Extensions** and run `supabase db push` again.
   - The live check-in feed (Realtime on `attendance` and `payments`).
   - A private `member-photos` storage bucket.
6. **Staff**: the owner uses **More → Staff → Add staff** with each person's
   Gmail and role. They sign in with **Continue with Google** using that
   Gmail; there are no passwords to share.
7. **Members**: the front desk enters the member's **Gmail** on their
   profile (when adding them, or with Edit). The member then signs in with
   **Continue with Google**. Each member needs their own Gmail; one Gmail on
   two members is refused at sign-in.
8. Upgrading a project that ran an older version? Delete the retired
   functions (phone + PIN and password invites):

   ```bash
   supabase functions delete member-login
   ```

   ```bash
   supabase functions delete set-member-pin
   ```

   ```bash
   supabase functions delete invite-staff
   ```

9. First-time setup on Home walks the owner through the gym profile,
   membership plans and inviting staff. To bring in an existing member list,
   use More → Import members with a CSV.
10. **Payments (M2).** In **More → Gym profile**, fill in the gym's **UPI ID**
    (used for member pay links and QR codes) and, if the gym is
    GST-registered, the **GSTIN** with **Charge GST** on. The M2 migration also
    schedules the nightly dues refresh at 00:10 IST (`pg_cron`) and adds
    Realtime on `payments`, when those are available.
11. **Razorpay (optional).** UPI links and QR codes work without it. To add
    payment links, set the secrets, then turn on **Razorpay payment links** in
    Gym profile:

    ```bash
    supabase secrets set RAZORPAY_KEY_ID=rzp_live_xxx RAZORPAY_KEY_SECRET=xxx RAZORPAY_WEBHOOK_SECRET=xxx
    ```

    In the Razorpay dashboard, add a webhook for the `payment_link.paid`
    event pointing at
    `https://YOUR_PROJECT_REF.supabase.co/functions/v1/razorpay-webhook`, using
    the same webhook secret. The keys stay on the server; the app never sees
    them.

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
