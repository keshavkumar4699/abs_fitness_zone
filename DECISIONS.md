# Decisions

Spec hard rule 2: when something is ambiguous, pick the simplest option, write
it here, and continue. Newest entries go at the bottom of each milestone.

## M0 Foundations

1. **Milestone gating.** Only M0 is built, per hard rule 1 (finish, test and
   demo each milestone before starting the next). Tabs for later features
   (Members, Payments, Plans, Workout, Diet, Progress, member Home) show an
   "On its way" empty state until their milestone lands.

2. **Icon package.** `phosphor_flutter` 2.1.0, the latest release, does not
   compile on Flutter ≥ 3.43 because `IconData` became a `final` class. We use
   `phosphor_icons` 3.x instead: a maintained fork with the same Phosphor glyphs
   and API. Outlined (regular) icons are used everywhere; the filled variant is
   used only for the selected navigation item.

3. **Fonts.** Sora and Inter are bundled as asset fonts declared in
   `pubspec.yaml`, not loaded through the `google_fonts` package. This meets the
   spec's "bundled at build, not fetched at runtime" requirement without another
   dependency. Sora has no ₹ glyph, so a tiny `AbsRupee` fallback family (Inter's
   ₹ only) is registered on every text style. The OFL licences ship in
   `assets/fonts/` and appear on the app's licence page.

4. **Member PIN storage.** The spec lists `members.pin_hash`. The hash lives in
   a separate `member_credentials` table that has RLS enabled and no client
   policies, so no API role can ever select it. Hashing is bcrypt (`pgcrypto`).
   Verification and lockout (5 wrong PINs → 15 minutes) run in
   `verify_member_pin()`, which only the service role can execute.

5. **Member sessions.** The `member-login` Edge Function verifies the PIN, then
   mints a normal Supabase session for the member's auth user. It does this with
   a one-time magic-link token (`generateLink` + `verifyOtp`) that never leaves
   the function. A member's auth user uses their real email when one is on file,
   so the email magic-link fallback works. Otherwise it uses a non-deliverable
   placeholder (`member-<id>@members.abs-fitness.invalid`).

6. **Member logins are created when the PIN is set.** `set-member-pin` stores
   the hash (the role check runs inside Postgres, as the caller) and creates the
   auth user and `profiles` link on first use.

7. **Staff invites use a temporary password.** The owner creates a staff
   account and sees a one-time temporary password to hand over. The
   `must_set_password` flag forces a new password on first sign-in. This meets
   "forced password set on first login" without depending on deep links or
   SMTP being configured on day one. From the app the owner invites front desk
   and trainers; the owner account itself is created with `bootstrap_owner()`.

8. **Settings visibility.** The `settings` table is owner-only, as the spec's
   RLS table requires for front desk. Members still need the gym's UPI ID and
   name, and the website will need them too. `public_gym_profile()` exposes only
   a whitelist: name, phone, address, UPI ID and working hours.

9. **No automatic retry.** Riverpod 3 retries failing providers by default,
   which would hide the required "message + retry" error state. Automatic retry
   is off app-wide (`noAutoRetry`), and screens retry when the user taps
   **Try again**.

10. **Routing.** go_router with central path constants (`Routes`) and a pure,
    unit-tested `authRedirect()` for role guards, rather than
    `go_router_builder` typed routes. This avoids a second code generator on a
    brand-new go_router major version. Deep links work the same way.

11. **Golden tests.** `golden_toolkit` is discontinued. Goldens use
    `flutter_test`'s `matchesGoldenFile` with a small font loader
    (`test/helpers/fonts.dart`), so text renders with the real fonts.

12. **Dark-mode depth.** The 1 px top highlight (white at 4%) is drawn as a
    hard gradient stop, because Flutter cannot combine a one-sided `Border` with
    rounded corners.

13. **Date formatting** uses `en_US` date symbols (identical English month
    names). These are always available, unlike `en_IN`, which needs locale data
    loaded at startup. All dates are still computed and shown in IST.

14. **Member status values** also include `pending`, which is needed for
    website online joining (F14 14.5, members awaiting front-desk approval).

15. **Hidden gallery access.** Long-press the logo on the welcome screen
    (signed out), or **More → Component gallery** for the owner.

16. **Text scaling** is clamped at 1.3×, the maximum the spec requires every
    screen to support.

17. **Deferred to the milestone that needs them:**
    - Optional biometric unlock and the 5-minute app lock (with M1, once staff
      handle member data daily).
    - The push-notification permission prompt at the end of onboarding (M3,
      when Firebase Cloud Messaging is added).
    - The owner setup wizard (M1, because it includes membership plans).
    - The drift offline cache (M1, with the first lists worth caching).
    - Lottie celebrations (M2/M3).
    - "Content behind scales to 0.96" under bottom sheets (a custom modal
      route; the sheet itself already snaps at 50% / 92%).
