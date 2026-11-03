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

3. **Fonts.** *(Superseded in M0.1; see entry 20.)* Fonts are bundled as asset
   fonts declared in `pubspec.yaml`, never fetched at runtime.

4. **Member PIN storage.** *(Superseded in M2.1: Google sign-in only; see
   entry 61.)* The spec lists `members.pin_hash`. The hash lives in
   a separate `member_credentials` table that has RLS enabled and no client
   policies, so no API role can ever select it. Hashing is bcrypt (`pgcrypto`).
   Verification and lockout (5 wrong PINs → 15 minutes) run in
   `verify_member_pin()`, which only the service role can execute.

5. **Member sessions.** *(Superseded in M2.1; see entry 61.)* The `member-login` Edge Function verifies the PIN, then
   mints a normal Supabase session for the member's auth user. It does this with
   a one-time magic-link token (`generateLink` + `verifyOtp`) that never leaves
   the function. A member's auth user uses their real email when one is on file,
   so the email magic-link fallback works. Otherwise it uses a non-deliverable
   placeholder (`member-<id>@members.abs-fitness.invalid`).

6. **Member logins are created when the PIN is set.** *(Superseded in M2.1;
   see entry 63.)* `set-member-pin` stores
   the hash (the role check runs inside Postgres, as the caller) and creates the
   auth user and `profiles` link on first use.

7. **Staff invites use a temporary password.** *(Superseded in M2.1; see
   entry 62.)* The owner creates a staff
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

## M0.1 Fixes and redesign

18. **Design direction changed at the owner's request.** The spec's "quiet
    power" look (dark-first, one electric accent, "never decorative colour")
    was replaced with a playful, colourful **Pop** system, because the owner
    found it bland:
    - Six vivid hues (lime, sky, tangerine, bubblegum, grape, mint) plus coral
      for danger. Every section of the app owns one hue.
    - Ink-coloured text on every fill; all pairs meet WCAG AA.
    - Sticker cards with a bold outline and a hard offset "lip" instead of
      blurred shadows.
    - Candy buttons that squish onto their lip when pressed.
    - Bouncy springs, floating blobs and confetti for success moments.
    - Light mode is warm cream; dark mode is deep grape-night.

    The token architecture is unchanged: widgets still read only from
    `lib/app/theme/`.

19. **Status colours keep their meaning** inside the new palette: mint means
    paid/active, tangerine means due soon/expiring, coral means
    overdue/expired, sky means frozen. Every status still shows text, never
    colour alone.

20. **Fonts:** Baloo 2 (display and numbers: rounded and playful, with ₹,
    tabular figures, and Devanagari support available for the later Hindi
    work) and Nunito (rounded body text, with ₹). Both are SIL OFL. The
    earlier ₹ fallback font is no longer needed.

21. **Generated code is committed** (`*.g.dart`, `*.freezed.dart`,
    `lib/app/l10n/gen/`). A fresh clone now runs with plain `flutter run`.
    Forgetting `build_runner` caused dozens of confusing compile errors. CI
    regenerates the files and fails if the committed copies are stale.

22. **Offline start.** The last signed-in profile is cached on the device. If
    the app opens offline with a saved session, it uses the cached profile
    instead of blocking on an error screen. Writes still require a
    connection.

23. **Staff deactivation.** The owner can turn a staff member's access off
    and back on (Staff → tap a person). A deactivated account is signed out
    on its next start and cannot sign in. The owner account cannot be turned
    off.

24. **Email magic link on phones** *(now the Google sign-in return, M2.1)* returns to the app through
    `com.absfitnesszone.app://login-callback`. This is registered on Android
    and iOS and must be added to Supabase's allowed redirect URLs. Flutter's
    own deep-link routing is turned off so the router never receives auth
    callbacks.

25. **Placeholder configuration is treated as "no backend"**, and a failed
    `Supabase.initialize` no longer crashes the app on launch; the welcome
    screen explains the problem instead.

26. **Gradle heap** lowered from 8 GB to 4 GB so Android builds work on 8 GB
    laptops.

27. **Minimum Android version is 8.0 (API 26)**, because `sentry_flutter`
    (crash reporting, required by the spec) needs it. Every other plugin works
    from API 24. Android 7 phones are a very small share of devices in 2026.

28. **Kotlin incremental compilation is off** (`kotlin.incremental=false`). On
    Windows it fails when the project and the Pub cache are on different
    drives ("Could not close incremental caches").


## M1 Members

29. **Payments wait for M2.** Each membership stores a price snapshot (plan
    price, joining fee, add-ons, discount and reason), so M2 can create the
    invoice from it. Until then, the "Collect" button and swipe-right on a
    member explain that payments arrive in the next update.

30. **Membership status "upcoming".** A member whose only plan starts in the
    future shows "Starts soon" instead of "Inactive".

31. **Joining fee** is charged on a member's first membership only.
    Renewals and transfers never charge it.

32. **Renewal start date.**
    - A current member renews from the day after their current end, so early
      renewal keeps the remaining days.
    - A lapsed member starts today by default; the owner can switch this to
      "day after old end" in Gym profile.

33. **Expired, frozen or cancelled members can still be checked in.** The
    visit is recorded and the desk sees a warning screen. Whether the person
    may train is the desk's decision, and the owner still sees that they came.

34. **Member self check-in uses a daily code** shown as a QR on a desk
    tablet (More → Check-in QR). A printed poster can't "rotate daily", so the
    code is `HMAC(secret, IST date)` and is never sent to members' phones.

35. **The member card QR** encodes `ABSM:<member id>`. Desk scanning checks
    the person in; the card contains no personal data.

36. **Health data (DPDP).** Front desk can enter health details while adding
    a member (with ticked consent) but cannot read them afterwards. The owner,
    the member and their assigned trainer can read them. The owner and the
    assigned trainer can edit them.

37. **Who can do what.**
    - Front desk can start, renew and freeze memberships, check members in,
      import, export and assign trainers.
    - The owner alone can cancel memberships, transfer days, archive members,
      delete members forever and edit plans.
    - Trainers can check in their own members and record measurements.

38. **Bulk actions in M1** are "assign trainer" and "export CSV". Bulk
    WhatsApp joins the free-mode send queue in M5. Single reminders already
    work: swipe left on a member, or use the WhatsApp button, to open a
    pre-filled wa.me link.

39. **Delete forever** removes the member's records (cascade) and their app
    profile, so they can no longer sign in. Removing the orphaned login itself
    needs an Edge Function, planned for the DPDP export/delete tools.

40. **Import is CSV-only.** Excel and Google Sheets both save as CSV. The
    database accepts up to 1,000 rows per call and the app sends 500 at a
    time. Duplicate phones are skipped, never merged.

41. **Rule messages** raised by the database ("only 3 freeze days left on
    this plan") are shown as written, in English. They will move to
    localisation keys when Hindi is added.

42. **One clock for dates.** All IST calendar logic reads `IstDates.clock`,
    which tests pin to 3 Nov 2026, so days-left and screenshots are stable.

43. **Bottom sheets open above the tab bar** (root navigator). Otherwise the
    floating tab bar covered their bottom buttons.

44. **Not built in M1, planned for a later milestone:**
    - Document uploads (1.17) and progress photos (1.3).
    - Merging duplicate members (1.18).
    - Optional check-out.
    - The drift offline cache: lists show error + retry when offline.
    - Biometric unlock and app lock.

## M2 Payments

45. **Money rules live in the database.** Every payment, void, refund,
    instalment plan and day close goes through a security-definer RPC.
    Direct writes to money tables are blocked by a guard trigger, and a
    deferred check makes sure an invoice's paid amount always equals its
    confirmed payments. Nothing financial is ever deleted: voids and refunds
    are new rows, with a reason, and every change lands in the audit log.

46. **Invoice and receipt numbers** run per financial year (April–March):
    `ABS/26-27/0001` for invoices and `RCPT/26-27/0001` for receipts. They are
    allocated from a counter table inside the same transaction, so they are
    sequential and never reused. A voided invoice keeps its number.

47. **Invoices are created automatically** when a membership starts or
    renews, at the end of the same transaction. Lines are the plan, the
    joining fee (first membership only) and add-ons. A discount is spread over
    the lines in order. Transfers and ₹0 memberships raise no invoice. The
    desk can also raise an ad-hoc invoice through `create_invoice` (the app
    screen for that comes with the shop/PT work later).

48. **GST is off by default.** When the owner turns it on (a GSTIN is
    required), plan prices are treated as **GST-inclusive** by default, which
    matches how Indian gyms quote prices. Switching "Prices include GST" off
    adds GST on top. GST is split into equal CGST and SGST (intra-state); an
    odd paisa goes to SGST. Only new invoices are affected.

49. **Partial payments and overpayments.** Any amount can be collected. If it
    is more than the balance, the extra becomes **member credit** (a ledger),
    and the receipt says so. Credit is used only when the desk chooses
    "Use credit", so it never silently pays an invoice. Credit applications
    are not counted as revenue a second time.

50. **Instalments**: up to 4 dated parts that must add up to the invoice
    total. Payments fill them in order; the first unpaid part's date is the
    invoice's "next due date", which drives Due / Overdue and reminders.

51. **Member self-pay in free mode.** The member app opens the UPI app with a
    `upi://pay` link (gym UPI ID, amount, invoice number) or shows the same
    link as a QR. After paying, the member taps "I've paid" and enters the
    UTR. The claim is **pending** until the desk approves it; nothing counts
    until then. On approval the receipt is numbered and the payment counts on
    the approval day (that is when the desk confirmed the money arrived).
    A UTR can be used once.

52. **Razorpay is optional and off by default.** With keys set as Edge
    Function secrets and the switch on in Gym profile, the desk can create a
    payment link for an invoice and share it. The webhook checks the
    `x-razorpay-signature` HMAC and is idempotent on the event ID, so retries
    never double-count. Refunds through Razorpay itself are recorded in the
    app by the owner as a manual refund.

53. **Who can do what with money.**
    - Front desk: collect, verify claims, split into instalments, share links,
      apply credit, close their own day.
    - Owner only: void a payment, refund, void an invoice (only when nothing
      is paid on it), reopen a closed day, expenses, revenue figures.
    - Trainers never see payments: the Payments tab shows a friendly page,
      the routes redirect, and RLS returns no rows.
    - Members see only their own invoices, payments and receipts.

54. **Day close** is per staff member per IST day. It records totals by mode,
    the cash counted and the difference, then locks that person's collecting
    and verifying for the day until the owner reopens it. The owner is never
    locked out.

55. **Dues engine and reminders.** Open invoices are refreshed nightly at
    00:10 IST and whenever a payment changes. The reminder schedule is 3 days
    before, on the day, and 3 and 7 days after the due date
    (`due_reminder_days` setting). In M2 the Payments tab lists today's
    reminders with one-tap WhatsApp (pre-filled, including the UPI link).
    Automatic sending arrives with the WhatsApp milestone (M5).

56. **Receipts are made on the phone** (A5 PDF, Nunito font for ₹, about
    13 KB, built in about 0.1 s). They are shared or printed through the
    system sheet. Receipt text is English for now.

57. **Overdue members at check-in.** The welcome screen shows "₹X fees
    pending" and stays up for 2.4 s instead of 1.2 s so the desk notices.
    Check-in is never blocked for dues.

58. **Payment dates.** The app always collects for today. The RPC accepts a
    date up to 30 days back for corrections, which the desk UI doesn't expose.

59. **Deleting a member keeps their invoices and payments** with the name,
    code and phone snapshot; only the link to the member is cleared.

60. **Not built in M2, planned for later:** automatic WhatsApp fee reminders
    (M5), full revenue reports and exports (M7; M2 adds the
    `collections_summary` hook used by the dashboard), the ad-hoc invoice
    screen, Razorpay checkout inside the member app, and offline collection.

## M2.1 Google sign-in

61. **Google is the only way to sign in**, for the owner, front desk,
    trainers and members (owner's request, replacing the spec's staff
    email + password and member phone + PIN). The welcome screen has one
    button, Continue with Google. Phone + PIN, email/password, magic links,
    temporary passwords and "set your password" are removed from the app,
    the database (`member_credentials`, `verify_member_pin`,
    `set_member_pin`, `must_set_password`) and the Edge Functions
    (`member-login`, `set-member-pin`, `invite-staff`). Turning off the
    Supabase Email provider closes the door on the server side too.

62. **A Google account gets in by its verified email.** On the first
    sign-in, `link_my_account()` looks up the Google email (verified, and
    only from a Google login) and links the login to:
    - an active staff record with that email first (a staff member who is
      also a member signs in as staff), otherwise
    - the one member record with that Gmail.

    Nothing else can create a profile. An unknown Gmail, a switched-off
    staff member, or a Gmail on two members is signed straight out with a
    plain explanation on the welcome screen.

63. **Adding people.** The owner adds staff by Gmail and role (More →
    Staff → Add staff); there is nothing to hand over. The desk puts a
    member's Gmail on their profile; a member page without one shows "Add a
    Gmail so … can sign in". Each member needs their own Gmail, so family
    members sharing one are told to ask the desk.

64. **Owner setup works in either order.** `bootstrap_owner()` creates the
    owner's staff record; the profile is linked at the owner's first Google
    sign-in, or straight away if they signed in already.

65. **Strangers.** Sign-ups must stay enabled for Google (new staff and
    members have no login until their first sign-in), so anyone can reach
    the Google screen. Without the optional hook, an unknown Gmail gets an
    empty login with no role: RLS shows it nothing and the app signs it out.
    With the **Before User Created** hook (`hook_before_user_created`) such
    sign-ups are refused outright.

66. **The Google account picker always shows** (`prompt=select_account`),
    because desk phones are shared and the wrong Google account is the most
    likely mistake. On Android Supabase opens Google in the browser and
    returns through `com.absfitnesszone.app://login-callback`.

