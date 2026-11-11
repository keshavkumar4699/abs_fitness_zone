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


## M3 Exercise library and workouts

67. **The catalogue is free-exercise-db**, pinned at commit `f00c92c`
    (public domain, 876 exercises; 3 of them have no images). The JSON is
    kept in `supabase/seed/`, and `scripts/gen_exercise_seed.py` turns it into
    a seed migration. No Hindi names are seeded; the owner can add them to
    any exercise, and trainers to their own.

68. **Tracking type (4.8) is derived from the dataset:**
    - stretching and foam rolling: time;
    - cardio: distance and time for treadmill, bike, rowing and elliptical
      exercises, otherwise time;
    - plyometrics: reps;
    - static bodyweight holds: time;
    - other bodyweight exercises: reps;
    - everything else: reps and weight.

69. **Exercise images** live in a public Supabase bucket, `exercises`.
    - `scripts/mirror_exercise_images.sh` copies the seeded images there
      once. It runs on the owner's computer because it needs the
      service-role key.
    - An optional `exercise_image_base` setting can point to another host
      instead.
    - Images are shown at the size on screen with a blurred placeholder, but
      not re-encoded to 400 px WebP. They are about 40–70 KB each, and
      re-encoding would mean an image pipeline outside the app.
    - A trainer's photo is resized on the phone to 1000 px JPEG (the bucket
      takes up to 5 MB).
    - Uploading their own short videos is not built; videos are YouTube
      links, opened in the YouTube app or browser. An embedded player would
      need a web view.

70. **The library works offline after the first sync.** The catalogue is
    kept as a JSON file on the phone (browser storage on the web) and synced
    by `updated_at`. Search runs in memory over a pre-folded index, in about
    a millisecond for 876 exercises. A general drift cache is still to come
    (DECISIONS 44).

71. **The body map is an original, chunky sticker figure**, front and back,
    covering the dataset's 17 muscle groups. Tapping a muscle filters the
    list and makes that muscle glow. Every muscle also has a labelled tap
    target for screen readers.

72. **"Equipment we have"** starts with everything ticked. The owner
    unticks what the gym lacks (Training → Exercises → wrench). The filter
    chip then hides exercises that need it.

73. **Programs.**
    - Library templates belong to the gym. Any coach (owner or trainer) can
      create one; the owner or its author can edit it.
    - Assigning a program copies it into a private snapshot for that member.
      Tuning a member's program never changes the library, and changing the
      library never changes a running program.
    - The weekly plan is one weekday per program day, picked when assigning.
      The defaults are Mon/Wed/Fri for 3 days, Mon/Tue/Thu/Fri for 4, and so
      on.
    - Progression adds the step to each item's target every week (kg or
      reps), from the program's start date.

74. **Replace or queue (5.4).**
    - Replace stops the running program today (or the day before a future
      start) and drops anything queued.
    - Queue starts the day after the running program ends.
    - A future start waits as "queued". A nightly job at 00:15 IST starts
      queued programs and completes finished ones.

75. **Who sees what.**
    - Everyone signed in reads the catalogue.
    - Staff read the template library. A member's program is visible to the
      member, the front desk and the member's trainer.
    - Workout logs, sets and comments are body data under the DPDP Act, so
      only the member, their trainer and the owner see them. The desk sees
      the program but not the logs.
    - Every write goes through a security-definer RPC.

76. **Workout logs.**
    - The phone makes a client id for each workout, so retries and edits
      replace the same log rather than adding another.
    - The player saves the session on the phone after every change.
    - A finished workout goes into an outbox first, then uploads. If the
      phone is offline it uploads on the next launch or pull-to-refresh.
      This is the spec's one offline-write exception.
    - A member can reopen and fix a workout for 24 hours. It keeps its
      original start and finish times.
    - The server refuses workouts longer than 6 hours or more than 30 days
      old.

77. **Personal records (5.9)** are the heaviest weight, the best estimated
    1RM (Epley, 1–30 reps), and more reps than ever at that weight or
    heavier (or more bodyweight reps). Only the best set of each kind is
    flagged, and the first time an exercise is logged sets the baseline. The
    database decides; the phone runs the same rules so the summary works
    offline.

78. **Adherence** is the share of planned sessions in the last 28 days (on
    the program's weekdays) that have a workout logged. **Streak** counts
    planned sessions done in a row; today does not break it until the day
    is over. **Workouts per week** use Monday-start weeks.

79. **The rest timer runs from an end time**, so it is correct after the
    screen locks.
    - A local notification fires at the end. It uses an exact alarm if the
      phone allows one, otherwise an inexact one. There is none on the web.
    - In the app, the end of rest gives a strong haptic.
    - Within a superset, there is no rest until its last exercise.

80. **No push notifications yet.** Firebase isn't set up, so "member
    notified by push" (5.4, 5.10) shows up in the app instead: the new
    program on the Workout tab, and coach comments and reactions on the
    workout.

81. **Trainer feedback** is a comment and/or one of five reactions (thumbs
    up, fire, fist, clap, star), drawn as icons rather than emoji so they
    look the same everywhere. Members read them; replies are not built.

82. **The Plans tab became "Training"**: My members (coaches only), the
    programs, and the exercise library. Trainers and the owner also get
    "Training today" on their home screen: who is planned today (ticked when
    done) and who missed sessions in the last week.

83. **Not built in M3, planned for later:**
    - push notifications;
    - members uploading their own exercise videos, and an embedded YouTube
      player;
    - members replying to comments;
    - trainers logging a workout on a member's behalf;
    - the general drift cache.

## M4 Diet

84. **The food database is the gym's own list of 300 foods** (6.1) in
    `supabase/seed/foods.csv`, so the dietitian can review it in a
    spreadsheet. `scripts/gen_food_seed.py` turns it into the seed
    migration, and CI checks the two match.
    - Values are typical home-style recipes and portions. Every food's
      calories are checked against protein, carbs and fat (within 15%).
    - Each food has a serving people use (1 katori = 150 g of dal or sabzi,
      1 roti, 1 glass = 250 ml, 100 g for weighed foods) and the smallest
      sensible step: half a roti, one egg, 25 g.
    - Seeded foods start **not reviewed**, as the spec asks. Coaches see a
      "Not reviewed" filter and mark foods reviewed; correcting a value
      also counts as reviewing it. Custom foods are reviewed by their
      author.
    - USDA FoodData Central can't be reached from the build machine, so
      `scripts/import_usda_foods.py` adds chosen USDA items from the
      official CSV download (per 100 g, "not reviewed", food group, veg
      type and allergens guessed for the dietitian to check).

85. **Food types and preferences.** A food is vegan, veg (dairy allowed),
    egg or non-veg, and may be Jain-friendly (no onion, garlic, root
    vegetables or honey). Vegetarian allows vegan and veg; eggetarian adds
    egg; vegan is vegan only; Jain is vegan or veg and Jain-friendly.
    Allergens come from a fixed list of nine.

86. **Allergies and foods to avoid live with the health form**
    (`member_health`), because they are health data: only the member,
    their trainer and the owner see them. The member or their coach edits
    them. "Foods to avoid" is free text matched against food names in
    English and Hindi.

87. **Diet data is private.** The spec lists diet as sensitive data, so a
    member's plan, meal, water and supplement logs and comments are visible
    only to the member, their trainer and the owner. The front desk browses
    the gym's plan library and foods but sees a note on a member's Diet
    tab. (Workout programs stay visible to the desk, as in M3.)

88. **A plan is one day of meals**, repeated daily. Meals are the nine
    slots in the spec, each at most once, with a time and notes. Each meal
    can have up to two "or" options (6.5).

89. **"Suggest an option"** builds a swap from the meal: each food becomes
    the food of the same group with the closest protein per calorie that
    suits the preference, sized to the same calories. Small items under 20
    kcal (chutney, black coffee) stay as they are. If nothing in the group
    suits (paneer for a vegan), any group is searched.

90. **Targets calculator (6.2).**
    - BMR: Mifflin-St Jeor, with the midpoint (−78) when sex isn't stated.
    - TDEE: activity factors 1.2, 1.375, 1.55, 1.725 and 1.9.
    - Calories: fat loss is 20% under maintenance (never below BMR or 1,200
      kcal), muscle gain is 300 kcal over, and everything rounds to 50.
    - Macros: protein is g per kg (2.0 high protein, 1.6 balanced, 1.8
      keto-light, adjustable), capped at 40% of calories. Fat is 25% (high
      protein) or 30% (balanced) with carbs taking the rest; keto-light caps
      carbs at 20% and fat takes the rest. Grams round to 5.
    - It starts from the member's profile (sex, age, height, latest weight).
      Activity isn't stored; it is picked in the calculator.

91. **Scaling (6.6)** moves every quantity, options included, by new ÷ old
    calorie target and rounds to the food's step, never below one step.
    The name's calorie figure and the macro targets follow. "Duplicate &
    scale" opens the builder on the unsaved copy. The builder also offers
    "Scale foods to target" when the plan is more than 5% off its target.

92. **Assigning (6.7)** copies the plan into the member's own snapshot, as
    programs do.
    - A start of today, or up to a week back, replaces the running plan at
      once.
    - A future start queues the new plan; the current one runs until the
      day before.
    - A newer assignment drops an older queued plan.
    - Plans have no end date; they run until replaced or ended. Earlier
      plans stay in the history.

93. **No push notifications yet** (as in M3). The member sees "New plan
    from your coach" on the Diet tab for three days after assigning.

94. **Meals are logged by slot, not by meal row**, so editing a member's
    plan never orphans what they marked.
    - Each log stores the calories and macros eaten at the time: eaten is
      the meal, partly is half, swapped is the chosen option, skipped is 0.
    - Members can log today and the two days before.
    - Marks, water and supplements go to an outbox first and upload when
      online. Like workout logs, they are personal and non-financial, and
      re-sending is safe because the RPCs upsert. The last tap wins.

95. **Adherence (6.11)** means the meals due that were eaten or swapped,
    with partly counting half. Past days count every meal in the plan;
    today counts only what's already marked, so the morning doesn't look
    bad. "Missed meals" are meals due in the last seven days (before today)
    that were skipped or never marked. The coach view shows the last 7
    days, and the chart shows Monday-start weeks with the weekly average
    weight from measurements on top.

96. **Water (6.9):** the goal is 35 ml per kg in 250 ml glasses, between 6
    and 16 a day (8 when the weight isn't known). The supplement checklist
    comes from the plan's supplements, ticked per day.

97. **The water wave runs once per change.** The spec keeps every animation
    between 120 and 450 ms, so the glass fills with one wave over the
    expressive token and settles, rather than looping.

98. **Meal reminders (6.10)** are local notifications that repeat daily at
    each meal's time (IST). Members turn them on from the bell on the Diet
    tab, and they follow plan changes. There are none on the web.

99. **The grocery list (6.12)** covers 7 days of the meals as written (not
    the options), using each food's "to buy" ingredients: 1 roti is 30 g of
    atta, 1 katori of dal is 35 g of dry dal. Amounts read naturally (650 g,
    1.2 kg, 14 eggs), and the list shares as WhatsApp text.

100. **The medical disclaimer** is on every plan view, the builder, the
     member's Diet tab, the shared text and the PDF. Members with health
     conditions (conditions or medicines on the health form, or a yes on
     the PAR-Q) are flagged in the builder, the assign sheet and the
     nutrition overview.

101. **Training has two areas.** A Workouts / Diet switch sits in the
     header. Diet has My members (the nutrition overview, coaches only),
     Diet plans and Foods.

102. **Hindi text uses a bundled Devanagari font** (Noto Sans Devanagari,
     OFL) as the fallback for every style. Baloo 2 and Nunito are Latin
     subsets, and the Hindi interface will need the font anyway.

103. **Not built in M4, planned for later:**
     - push notifications;
     - multi-day (weekday-varying) plans;
     - editing a custom food's grocery ingredients (it buys the food
       itself);
     - members logging foods outside their plan.

## After M4

104. **Exercise demonstrations stay as two photos, played like a GIF.** No
     free GIF set covers every exercise. ExerciseDB's GIFs are a commercial
     product under its own terms of use, and wger covers only some
     exercises, mostly with still photos. So the app plays free-exercise-db's
     two public-domain photos (start and end) as a loop: hold, a 450 ms
     cross-fade, hold, fade back. A tap pauses or plays it. With reduced
     motion it stays still, and a tap shows the other position.

105. **The body map is a smooth figure.** The silhouette and each muscle are
     traced as points and drawn as curves through them, with details
     (collarbones, six-pack, knee caps, spine), instead of rounded boxes.
     The muscles and their names are unchanged. A tap that lands just
     beside a small muscle still selects it, and the library shows the
     figure larger.

## M5 WhatsApp

106. **One queue, two ways to send.** Every WhatsApp message, automatic or
     by hand, is a row in `message_queue` with its channel: `link` (free
     mode: staff send it from the gym's phone with a wa.me link) or `api`
     (the Meta Cloud API sends it). Free mode is the default and needs no
     setup. Switching to API mode in Settings changes only where new
     messages go. The templates, the queue and the log stay the same.

107. **When messages are built and sent.** The daily job at 07:30 IST builds
     expiry and fee reminders, birthday wishes and festival wishes, all
     timed for 09:00 IST. Confirmations (payment received, welcome,
     renewal, a new workout or diet plan) are queued the moment the event
     happens. In API mode a scheduled call sends what is due every 15
     minutes between 08:30 and 20:30 IST (README), so nothing goes out at
     night. The front desk can also tap **Send now**.

108. **The spec's limits are enforced in one place (`_enqueue`).** A member
     gets the same template at most once in 24 hours, and at most one
     marketing message (wishes, offers) per IST day. The birthday is built
     before festivals, so on a festival birthday the member gets the
     birthday wish. Running the job again adds nothing, because every
     automatic message has a key.

109. **Who gets messages.** A member is messaged only with WhatsApp consent
     (`consent_whatsapp_at`, captured at signup), with WhatsApp not turned
     off, with a phone number, and when not archived. Members turn it off
     in their profile or by replying STOP (also UNSUBSCRIBE, STOP ALL or
     बंद); START turns it back on. The desk can switch it for a member.
     Turning it off cancels anything still waiting, and the member's
     history shows the change once.

110. **The free-mode tick is the staff member's word.** WhatsApp doesn't tell
     the app whether the message was really sent. Tapping **Send** opens
     WhatsApp with the text, and coming back to the app ticks the row as
     sent. Opening the next message also ticks the previous one, for
     computers where the app never leaves the screen. Each tick can be
     undone that day, and a row can be skipped instead.

111. **Messages sent by hand are logged, never doubled.** The WhatsApp
     buttons elsewhere in the app now record what they send. Those are
     the member detail, the member list, Needs action, receipts, fee
     reminders and sharing a plan. When a queued message for the same
     purpose is waiting (for example, today's fee reminder), that row is
     ticked instead of adding a second one.

112. **API mode sends only what Meta allows.** Outside the 24-hour window
     only an approved template can be sent. Each template has a **Meta
     template name** field, and its variables become {{1}}, {{2}}… in the
     order they appear, which the template editor shows for copying into
     WhatsApp Manager. A message with no approved template (a broadcast's
     own text, say) is sent as free text inside the window. Otherwise it
     moves to the free-mode list at once. Any other failure is retried
     once and then moved too. A refused access token stops the run and
     leaves the rest queued for the next one.

113. **The 24-hour window is used, not waited for (8.11).** When a member
     writes to the gym, the webhook records it and sends their utility
     messages due in the next 24 hours right away, as free text. Any
     message to a member inside the window goes as free text.

114. **The cost meter is an estimate.** It multiplies this month's API sends
     by per-message prices the owner can edit (defaults ₹0.145 utility,
     ₹0.785 marketing). Messages sent inside the window and by hand count
     as free. Once marketing spend reaches the monthly cap (default ₹200),
     marketing that is due moves to the free-mode list. Staff can still
     send it by hand that day, instead of it going out late next month.

115. **A message is for its day.** When the next morning's queue is built,
     automatic messages still unsent from earlier days are cancelled ("not
     sent on the day"). That way no late birthday wish or stale reminder
     sits beside today's. Receipts and broadcasts stay until sent or
     skipped.

116. **Templates are the twelve automatic messages, in English and Hindi.**
     The owner edits their text, Meta name and on/off. Each member gets
     the template in their own language, falling back to English. The
     front desk can read templates. Broadcasts carry their own text
     instead of a template.

117. **Segments (8.8)** are: everyone, active, ending in 7 days, expired
     30–90 days ago, with fees due, a trainer's members, a batch, or
     members picked in the list (bulk WhatsApp, 1.14). The composer shows
     how many members the message reaches before it is queued.

118. **Festival dates are the owner's to check.** The calendar is seeded
     with one year of festivals (Chhath Puja to Diwali 2027), with Hindi
     names for Hindi messages. Lunar dates move every year, and Eid
     depends on the moon, so Eid starts switched off. A festival can carry
     its own message and go to everyone or active members only.

119. **Trainers stay out of WhatsApp screens.** Messages carry fees and
     phone numbers, so the queue, log, broadcasts and templates are for the
     front desk and the owner. Settings and the cost meter are the
     owner's. Trainers can still send a member their plan from the plan's
     share menu, and it is logged.

120. **Not built in M5, planned for later:**
     - the personalised birthday image card (8.5 says optional);
     - the receipt PDF as a link (receipts send the text; the PDF is shared
       from the app);
     - Hindi translations of the app's own screens (the Hindi WhatsApp
       messages are done);
     - AI-drafted broadcast text (F7 7.9).

## After M5: review fixes

121. **Switching WhatsApp mode moves what is waiting.** Turning API mode on
     sends the free-mode messages the API never tried (no attempts, no
     error); turning it off moves everything still waiting on the API to
     the free-mode list, so nothing is stranded on a sender that is off. A
     database trigger on the setting does it, so it holds however the
     setting is changed.

122. **"Problems" instead of "Failed" in the log.** A message never ends in
     a failed state: a send that fails is retried once and then moved to
     the free-mode list, with the reason on the row. The log's filter shows
     rows that carry a reason, whatever their status, and the staff home
     card counts the ones still waiting.

123. **Platform configuration found in review.** The iOS property list had
     the URL-scheme block pasted into four nested dictionaries (an invalid
     plist) and no camera or photo-library usage text; Android lacked the
     notification permission for Android 13+, the boot receiver that keeps
     daily meal reminders after a restart, and the package-visibility
     queries for the links the app opens (wa.me, tel, upi). All fixed; none
     of it can be verified without a device, so the CI Android build is the
     check.

124. **Every string goes through l10n, including PDFs and notifications.**
     The receipt's labels and the notification channel names were English
     literals; they now come from the ARB file, with the notification text
     set by the screen that owns it.
