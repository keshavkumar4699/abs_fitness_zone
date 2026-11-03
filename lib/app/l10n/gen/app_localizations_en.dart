// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ABS Fitness';

  @override
  String get gymName => 'ABS Fitness Zone';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSave => 'Save';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonDone => 'Done';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get commonOfflineBanner => 'Offline, showing saved data';

  @override
  String get commonGenericError => 'Something went wrong. Please try again.';

  @override
  String get commonNetworkError => 'No connection. Check your internet and try again.';

  @override
  String get commonRequired => 'Required';

  @override
  String get welcomeTitle => 'Train. Track. Transform.';

  @override
  String get welcomeSubtitle => 'Your membership, workouts and diet, all in one happy place.';

  @override
  String get welcomeMember => 'I\'m a member';

  @override
  String get welcomeStaff => 'Staff login';

  @override
  String get welcomeNotConfigured =>
      'This build has no server configured. Sign-in is disabled; long-press the logo to open the component gallery.';

  @override
  String get staffLoginTitle => 'Staff login';

  @override
  String get staffLoginSubtitle => 'Use the email your gym owner invited you with.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPhone => 'Phone number';

  @override
  String get fieldPin => '4-digit PIN';

  @override
  String get fieldName => 'Full name';

  @override
  String get fieldRole => 'Role';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get fieldConfirmPassword => 'Confirm password';

  @override
  String get actionSignIn => 'Sign in';

  @override
  String get validationEmail => 'Enter a valid email address';

  @override
  String get validationPhone => 'Enter a 10-digit Indian mobile number';

  @override
  String get validationPin => 'PIN must be 4 digits';

  @override
  String get validationPasswordLength => 'Use at least 8 characters';

  @override
  String get validationPasswordMatch => 'Passwords don\'t match';

  @override
  String get memberLoginTitle => 'Member login';

  @override
  String get memberLoginSubtitle => 'Sign in with your phone number and the PIN set at the front desk.';

  @override
  String get memberForgotPin => 'Forgot PIN?';

  @override
  String get memberForgotPinTitle => 'Forgot your PIN?';

  @override
  String get memberForgotPinBody => 'Please contact the front desk. They can set a new PIN for you in a few seconds.';

  @override
  String get memberUseEmailLink => 'Use an email link instead';

  @override
  String get memberEmailLinkTitle => 'Sign in with email';

  @override
  String get memberEmailLinkBody => 'If your email is on file, we\'ll send you a sign-in link.';

  @override
  String get memberEmailLinkSend => 'Send link';

  @override
  String get memberEmailLinkSent => 'Check your inbox for the sign-in link.';

  @override
  String get authInvalidCredentials => 'Those details don\'t match. Please check and try again.';

  @override
  String authInvalidPin(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wrong PIN. $count attempts left before a 15-minute lock.',
      one: 'Wrong PIN. 1 attempt left before a 15-minute lock.',
    );
    return '$_temp0';
  }

  @override
  String authLocked(String time) {
    return 'Too many wrong attempts. Try again after $time.';
  }

  @override
  String get authNotConfigured => 'Sign-in is not available in this build.';

  @override
  String get authNoProfile => 'Your account isn\'t linked to the gym yet. Please contact the front desk.';

  @override
  String get setPasswordTitle => 'Set your password';

  @override
  String get setPasswordSubtitle => 'For your security, choose a new password before you continue.';

  @override
  String get setPasswordAction => 'Save password';

  @override
  String get onboardingTrackTitle => 'Your membership, at a glance';

  @override
  String get onboardingTrackBody => 'See days left, dues and your digital membership card anytime.';

  @override
  String get onboardingWorkoutTitle => 'Follow your workouts';

  @override
  String get onboardingWorkoutBody => 'Your trainer\'s plan, set by set, with a rest timer that keeps you moving.';

  @override
  String get onboardingDietTitle => 'Stay on track with your diet';

  @override
  String get onboardingDietBody => 'Meal-by-meal plans built around the food you actually eat.';

  @override
  String get onboardingStart => 'Let\'s go';

  @override
  String get navHome => 'Home';

  @override
  String get navMembers => 'Members';

  @override
  String get navPayments => 'Payments';

  @override
  String get navPlans => 'Plans';

  @override
  String get navMore => 'More';

  @override
  String get navWorkout => 'Workout';

  @override
  String get navDiet => 'Diet';

  @override
  String get navProgress => 'Progress';

  @override
  String get navProfile => 'Profile';

  @override
  String get comingSoonTitle => 'Warming up!';

  @override
  String get comingSoonBody => 'This section is doing its stretches and arrives in an upcoming update.';

  @override
  String get comingSoonAction => 'Back to home';

  @override
  String greeting(String name) {
    return 'Hey $name!';
  }

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleFrontDesk => 'Front desk';

  @override
  String get roleTrainer => 'Trainer';

  @override
  String get roleMember => 'Member';

  @override
  String get moreTitle => 'More';

  @override
  String get moreAppearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get moreStaff => 'Staff';

  @override
  String get moreStaffSubtitle => 'Invite and manage your team';

  @override
  String get moreMemberPin => 'Member PIN';

  @override
  String get moreMemberPinSubtitle => 'Set or reset a member\'s app PIN';

  @override
  String get moreGallery => 'Component gallery';

  @override
  String get moreGallerySubtitle => 'Every design-system component and state';

  @override
  String get staffTitle => 'Staff';

  @override
  String get staffSearchHint => 'Search by name or email';

  @override
  String get staffEmptyTitle => 'No staff yet';

  @override
  String get staffEmptyBody => 'Invite your trainers and front desk so they can sign in.';

  @override
  String get staffInvite => 'Invite staff';

  @override
  String get staffInviteTitle => 'Invite a team member';

  @override
  String get staffInviteAction => 'Create account';

  @override
  String get staffInactive => 'Inactive';

  @override
  String get staffTempPasswordTitle => 'Account created';

  @override
  String staffTempPasswordBody(String name) {
    return 'Share this temporary password with $name. They\'ll set their own password on first sign-in. It won\'t be shown again.';
  }

  @override
  String get memberPinTitle => 'Member PIN';

  @override
  String get memberPinSubtitle => 'Look up a member by phone, then set a new 4-digit PIN for the app.';

  @override
  String get memberPinFind => 'Find member';

  @override
  String get memberPinNotFound => 'No member with this phone number.';

  @override
  String get memberPinSet => 'Set PIN';

  @override
  String memberPinDone(String name) {
    return 'PIN updated for $name.';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileMemberCode => 'Member ID';

  @override
  String get galleryTitle => 'Component gallery';

  @override
  String get galleryTextScale => 'Text 1.3×';

  @override
  String get galleryButtons => 'Buttons';

  @override
  String get galleryCards => 'Cards and stats';

  @override
  String get galleryPills => 'Status pills';

  @override
  String get galleryRings => 'Progress rings';

  @override
  String get galleryFields => 'Text fields';

  @override
  String get galleryTabs => 'Segmented tabs';

  @override
  String get galleryTiles => 'Member tiles';

  @override
  String get galleryStates => 'Screen states';

  @override
  String get galleryCharts => 'Charts';

  @override
  String get galleryFeedback => 'Sheets and snackbars';

  @override
  String get galleryPrimary => 'Primary';

  @override
  String get gallerySecondary => 'Secondary';

  @override
  String get galleryGhost => 'Ghost';

  @override
  String get galleryDestructive => 'Delete';

  @override
  String get galleryLoading => 'Loading';

  @override
  String get gallerySuccess => 'Success';

  @override
  String get galleryOpenSheet => 'Open bottom sheet';

  @override
  String get galleryShowSnackbar => 'Show snackbar';

  @override
  String get gallerySnackbarMessage => 'Reminder queued';

  @override
  String get gallerySheetBody => 'Quick actions open in sheets like this instead of new screens.';

  @override
  String get gallerySampleError => 'Couldn\'t load members.';

  @override
  String get galleryEmptyBody => 'No members match these filters.';

  @override
  String get galleryEmptyAction => 'Clear filters';

  @override
  String get galleryDaysUsed => 'Days used';

  @override
  String get galleryWorkout => 'Workout';

  @override
  String get galleryMacros => 'Protein';

  @override
  String get galleryDisabled => 'Disabled';

  @override
  String get galleryStateLoading => 'Screen states · loading';

  @override
  String get galleryStateEmpty => 'Screen states · empty';

  @override
  String get galleryStateError => 'Screen states · error';

  @override
  String get fieldAmount => 'Amount';

  @override
  String get statActiveMembers => 'Active members';

  @override
  String get statTodayCollections => 'Collected today';

  @override
  String get statCheckIns => 'Today\'s check-ins';

  @override
  String get chartRevenue => 'Revenue';

  @override
  String get statusActive => 'Active';

  @override
  String statusExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expiring · $days days',
      one: 'Expiring · 1 day',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusFrozen => 'Frozen';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusPartial => 'Partial';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusLead => 'Lead';

  @override
  String daysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '$days days left', one: '1 day left');
    return '$_temp0';
  }

  @override
  String get swipeCollect => 'Collect';

  @override
  String get swipeRemind => 'Remind';

  @override
  String get period7d => '7D';

  @override
  String get period30d => '30D';

  @override
  String get period3m => '3M';

  @override
  String get period12m => '12M';

  @override
  String get fabNewMember => 'New member';

  @override
  String get fabCollect => 'Collect';

  @override
  String get fabCheckIn => 'Check-in';

  @override
  String get fabEnquiry => 'Enquiry';

  @override
  String get fabOpen => 'Quick actions';

  @override
  String get searchMembersHint => 'Search name, phone or ID';

  @override
  String get commonNotAllowed => 'You don\'t have permission to do that.';

  @override
  String get authStaffDeactivated => 'This staff account has been turned off. Please speak to the gym owner.';

  @override
  String get authSamePassword => 'Pick a password you haven\'t used before.';

  @override
  String get authWeakPassword => 'That password is too easy to guess. Try a longer one with numbers or symbols.';

  @override
  String get authRateLimited => 'Too many attempts. Please wait a minute and try again.';

  @override
  String get authBackendError => 'Couldn\'t connect to the gym server. Check the app\'s Supabase URL and key.';

  @override
  String get staffInviteEmailTaken => 'Someone already uses this email. Try a different one.';

  @override
  String get welcomeTitle1 => 'Train.';

  @override
  String get welcomeTitle2 => 'Track.';

  @override
  String get welcomeTitle3 => 'Transform.';

  @override
  String get welcomeChipWorkouts => 'Workouts';

  @override
  String get welcomeChipDiet => 'Diet';

  @override
  String get welcomeChipProgress => 'Progress';

  @override
  String get notFoundTitle => 'Lost your way?';

  @override
  String get notFoundBody => 'That page doesn\'t exist. Let\'s get you back home.';

  @override
  String get homeToday => 'Today';

  @override
  String get homeGetStarted => 'Get started';

  @override
  String get homeStepInvite => 'Invite your team';

  @override
  String get homeStepInviteBody => 'Add front desk and trainers so they can sign in.';

  @override
  String get homeStepPin => 'Give members app access';

  @override
  String get homeStepPinBody => 'Set a 4-digit PIN for each member at the desk.';

  @override
  String get homeStepLook => 'Make it yours';

  @override
  String get homeStepLookBody => 'Pick light, dark or follow the phone.';

  @override
  String get homeComingTitle => 'More muscle on the way';

  @override
  String get homeComingBody => 'Members, payments, plans and reports arrive in the next updates.';

  @override
  String get homeTrainerBody => 'Your assigned members, sessions and plans will show up here.';

  @override
  String get memberCardTitle => 'Member card';

  @override
  String get memberHomeComingBody => 'Your workouts, diet and progress land here soon.';

  @override
  String get staffManage => 'Manage';

  @override
  String get staffDeactivate => 'Turn off access';

  @override
  String get staffReactivate => 'Turn access back on';

  @override
  String staffDeactivated(String name) {
    return '$name can no longer sign in.';
  }

  @override
  String staffReactivated(String name) {
    return '$name can sign in again.';
  }

  @override
  String get staffOwnerLocked => 'The owner account is always on.';

  @override
  String get staffYou => 'You';

  @override
  String get goHome => 'Go home';

  @override
  String get memberDuplicatePhone => 'Another member already uses this phone number.';

  @override
  String get membersTitle => 'Members';

  @override
  String get membersSearchHint => 'Search name, phone or ID';

  @override
  String get membersEmptyTitle => 'No members yet';

  @override
  String get membersEmptyBody => 'Add your first member or import your existing list.';

  @override
  String get membersNoMatchTitle => 'No matches';

  @override
  String get membersNoMatchBody => 'No members match this search or these filters.';

  @override
  String get membersClearFilters => 'Clear filters';

  @override
  String get membersAdd => 'Add member';

  @override
  String get membersImport => 'Import';

  @override
  String get membersExport => 'Export CSV';

  @override
  String get membersFilters => 'Filters';

  @override
  String get membersSort => 'Sort';

  @override
  String get sortName => 'Name';

  @override
  String get sortEndDate => 'Ending soonest';

  @override
  String get sortJoined => 'Newest';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterPlan => 'Plan';

  @override
  String get filterTrainer => 'Trainer';

  @override
  String get filterBatch => 'Batch';

  @override
  String get filterGender => 'Gender';

  @override
  String get filterBirthday => 'Birthday this month';

  @override
  String get filterJoined => 'Joined between';

  @override
  String get filterArchived => 'Show archived';

  @override
  String get filterApply => 'Show results';

  @override
  String get filterSave => 'Save filter';

  @override
  String get filterSaveName => 'Filter name';

  @override
  String get filterSaved => 'Saved filters';

  @override
  String get filterAny => 'Any';

  @override
  String get filterFrom => 'From';

  @override
  String get filterTo => 'To';

  @override
  String get batchMorning => 'Morning';

  @override
  String get batchEvening => 'Evening';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get bulkAssignTrainer => 'Assign trainer';

  @override
  String get bulkExport => 'Export';

  @override
  String get bulkNoTrainer => 'No trainer';

  @override
  String get remindWhatsApp => 'Remind';

  @override
  String get selectAll => 'Select all';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get statusUpcoming => 'Starts soon';

  @override
  String get statusPending => 'Pending';

  @override
  String get noPlan => 'No plan';

  @override
  String get addMemberTitle => 'New member';

  @override
  String get stepBasics => 'Basics';

  @override
  String get stepHealth => 'Health';

  @override
  String get stepMembership => 'Membership';

  @override
  String get fieldAltPhone => 'Alternate phone';

  @override
  String get fieldGender => 'Gender';

  @override
  String get fieldDob => 'Date of birth';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldEmergencyName => 'Emergency contact name';

  @override
  String get fieldEmergencyRelation => 'Relation';

  @override
  String get fieldEmergencyPhone => 'Emergency phone';

  @override
  String get fieldBloodGroup => 'Blood group';

  @override
  String get fieldBatch => 'Batch';

  @override
  String get fieldTrainer => 'Trainer';

  @override
  String get fieldSource => 'How did they hear about us?';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldPhoto => 'Photo';

  @override
  String get fieldPhotoAdd => 'Add photo';

  @override
  String get fieldPhotoChange => 'Change photo';

  @override
  String get fieldHeight => 'Height (cm)';

  @override
  String get fieldWeight => 'Weight (kg)';

  @override
  String get fieldGoal => 'Goal';

  @override
  String get fieldLevel => 'Experience';

  @override
  String get fieldConditions => 'Medical conditions';

  @override
  String get fieldInjuries => 'Injuries';

  @override
  String get fieldMedications => 'Medications';

  @override
  String get fieldDoctorClearance => 'A doctor has cleared them for exercise';

  @override
  String get fieldConsentHealth => 'Member agrees to share health details with the gym';

  @override
  String get fieldConsentWhatsapp => 'Member agrees to receive WhatsApp updates';

  @override
  String get goalFatLoss => 'Fat loss';

  @override
  String get goalMuscleGain => 'Muscle gain';

  @override
  String get goalStrength => 'Strength';

  @override
  String get goalGeneral => 'General fitness';

  @override
  String get goalRehab => 'Rehab';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get parqTitle => 'Health questions';

  @override
  String get parqHeart => 'Has a doctor ever said they have a heart condition?';

  @override
  String get parqChestPain => 'Do they feel chest pain during physical activity?';

  @override
  String get parqDizzy => 'Do they lose balance from dizziness, or ever faint?';

  @override
  String get parqBone => 'Do they have a bone or joint problem that exercise could make worse?';

  @override
  String get parqBp => 'Are they taking medicine for blood pressure or the heart?';

  @override
  String get parqPregnant => 'Are they pregnant, or did they give birth in the last 6 months?';

  @override
  String get parqOther => 'Is there any other reason they should not exercise?';

  @override
  String get parqWarning => 'Answered yes: ask for a doctor\'s clearance before training.';

  @override
  String get planSelect => 'Choose a plan';

  @override
  String get planNone => 'Skip for now';

  @override
  String get startDate => 'Start date';

  @override
  String get startToday => 'Today';

  @override
  String get addonsTitle => 'Add-ons';

  @override
  String get discount => 'Discount (₹)';

  @override
  String get discountReason => 'Reason for discount';

  @override
  String get summaryTotal => 'Total';

  @override
  String get summaryJoiningFee => 'Joining fee';

  @override
  String get summaryPlan => 'Plan';

  @override
  String get summaryAddons => 'Add-ons';

  @override
  String get summaryDiscount => 'Discount';

  @override
  String get saveMember => 'Save member';

  @override
  String get draftRestored => 'We kept your unsaved draft.';

  @override
  String get discardDraft => 'Start fresh';

  @override
  String get back => 'Back';

  @override
  String get paymentNote => 'Payment is collected in the Payments update, coming next.';

  @override
  String get consentRequired => 'Tick the consent box to save health details.';

  @override
  String get discountNeedsReason => 'Add a reason for the discount.';

  @override
  String get discountTooBig => 'Discount can\'t be more than the total.';

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabMembership => 'Membership';

  @override
  String get tabPayments => 'Payments';

  @override
  String get tabWorkouts => 'Workouts';

  @override
  String get tabDiet => 'Diet';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabAttendance => 'Attendance';

  @override
  String get tabNotes => 'Notes';

  @override
  String get actionCollect => 'Collect';

  @override
  String get actionRenew => 'Renew';

  @override
  String get actionWhatsApp => 'WhatsApp';

  @override
  String get actionCall => 'Call';

  @override
  String get actionEdit => 'Edit profile';

  @override
  String get actionSetPin => 'Set app PIN';

  @override
  String get actionArchive => 'Archive';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionDelete => 'Delete forever';

  @override
  String get actionMore => 'More actions';

  @override
  String get deleteConfirmBody => 'Only do this when the member asks in writing. Type their name to confirm.';

  @override
  String get deleted => 'Member deleted';

  @override
  String get archivedDone => 'Member archived';

  @override
  String get restoredDone => 'Member restored';

  @override
  String get infoPhone => 'Phone';

  @override
  String get infoEmail => 'Email';

  @override
  String get infoDob => 'Birthday';

  @override
  String get infoAddress => 'Address';

  @override
  String get infoEmergency => 'Emergency';

  @override
  String get infoBatch => 'Batch';

  @override
  String get infoTrainer => 'Trainer';

  @override
  String get infoJoined => 'Joined';

  @override
  String get infoSource => 'Source';

  @override
  String get infoBlood => 'Blood group';

  @override
  String get healthTitle => 'Health';

  @override
  String get healthNone => 'No health details yet.';

  @override
  String get healthPrivate => 'Health details are visible only to the owner, the member and their trainer.';

  @override
  String get membershipCurrent => 'Current membership';

  @override
  String get membershipHistory => 'History';

  @override
  String get membershipNone => 'No membership yet';

  @override
  String get membershipStart => 'Start membership';

  @override
  String get freeze => 'Freeze';

  @override
  String get unfreeze => 'Unfreeze';

  @override
  String get cancelMembership => 'Cancel';

  @override
  String get transfer => 'Transfer';

  @override
  String get freezeTitle => 'Freeze membership';

  @override
  String get freezeDays => 'Number of days';

  @override
  String get freezeFrom => 'Starting';

  @override
  String get freezeReason => 'Reason';

  @override
  String get unfreezeDone => 'Welcome back! Membership unfrozen.';

  @override
  String get renewTitle => 'Renew membership';

  @override
  String get renewSamePlan => 'Same plan';

  @override
  String get cancelTitle => 'Cancel this membership?';

  @override
  String get cancelReason => 'Reason';

  @override
  String get refundAmount => 'Refund given (₹)';

  @override
  String get cancelDone => 'Membership cancelled';

  @override
  String get transferTitle => 'Transfer remaining days';

  @override
  String get transferPick => 'Who gets the days?';

  @override
  String get transferDone => 'Days transferred';

  @override
  String get paymentsSoon => 'Invoices and payments arrive in the Payments update, coming next.';

  @override
  String get workoutsSoon => 'Workout plans arrive with the Workouts update.';

  @override
  String get dietSoon => 'Diet plans arrive with the Diet update.';

  @override
  String get progressAdd => 'Add measurement';

  @override
  String get progressEmpty => 'No measurements yet';

  @override
  String get weightTrend => 'Weight trend (kg)';

  @override
  String get measurementSaved => 'Measurement saved';

  @override
  String get fieldBodyFat => 'Body fat %';

  @override
  String get fieldChest => 'Chest (cm)';

  @override
  String get fieldWaist => 'Waist (cm)';

  @override
  String get fieldHips => 'Hips (cm)';

  @override
  String get fieldArms => 'Arms (cm)';

  @override
  String get fieldThighs => 'Thighs (cm)';

  @override
  String get fieldMeasuredOn => 'Date';

  @override
  String get attendanceMark => 'Mark present today';

  @override
  String get attendanceMarked => 'Marked present';

  @override
  String get attendanceAlready => 'Already checked in today';

  @override
  String get attendanceLast12 => 'Last 12 weeks';

  @override
  String get attendanceEmpty => 'No visits yet';

  @override
  String get notesHint => 'Add a note…';

  @override
  String get notesAdd => 'Add';

  @override
  String get notesEmpty => 'Nothing here yet';

  @override
  String get collectSoon => 'Collecting payments arrives in the Payments update, coming next.';

  @override
  String get pickDate => 'Pick a date';

  @override
  String get dateNotSet => 'Not set';

  @override
  String get plansTitle => 'Membership plans';

  @override
  String get plansTab => 'Plans';

  @override
  String get addonsTab => 'Add-ons';

  @override
  String get planNew => 'New plan';

  @override
  String get addonNew => 'New add-on';

  @override
  String get planName => 'Plan name';

  @override
  String get planDuration => 'Duration';

  @override
  String get unitMonths => 'Months';

  @override
  String get unitDays => 'Days';

  @override
  String get planPrice => 'Price (₹)';

  @override
  String get planJoiningFee => 'Joining fee (₹)';

  @override
  String get planGst => 'GST';

  @override
  String get planFreeze => 'Freeze days allowed';

  @override
  String get planIncludesPt => 'Includes personal training';

  @override
  String get planColor => 'Colour';

  @override
  String get planArchived => 'Archived';

  @override
  String get planArchive => 'Archive';

  @override
  String get planUnarchive => 'Bring back';

  @override
  String get plansEmptyTitle => 'No plans yet';

  @override
  String get plansEmptyBody => 'Create your first membership plan so members can join.';

  @override
  String get addonsEmpty => 'No add-ons yet';

  @override
  String get addonName => 'Add-on name';

  @override
  String get addonPrice => 'Price (₹)';

  @override
  String get addonKind => 'Type';

  @override
  String get kindPt => 'Personal training';

  @override
  String get kindLocker => 'Locker';

  @override
  String get kindDiet => 'Diet consultation';

  @override
  String get kindOther => 'Other';

  @override
  String get saved => 'Saved';

  @override
  String get morePlans => 'Membership plans';

  @override
  String get morePlansSubtitle => 'Plans, prices and add-ons';

  @override
  String get moreGymQr => 'Check-in QR';

  @override
  String get moreGymQrSubtitle => 'Show today\'s code for member self check-in';

  @override
  String get moreGymProfile => 'Gym profile';

  @override
  String get moreGymProfileSubtitle => 'Name, address, UPI ID and rules';

  @override
  String get moreImport => 'Import members';

  @override
  String get moreImportSubtitle => 'Bring in your existing list from a spreadsheet';

  @override
  String get noGst => 'None';

  @override
  String get checkInTitle => 'Check-in';

  @override
  String get checkInSearch => 'Search member to check in';

  @override
  String get checkInScanHint => 'Point at the member\'s QR code';

  @override
  String get checkInAlready => 'Already checked in today';

  @override
  String get checkInWarnExpired => 'Membership expired';

  @override
  String get checkInWarnInactive => 'No active membership';

  @override
  String get checkInWarnFrozen => 'Membership is frozen';

  @override
  String get checkInWarnCancelled => 'Membership cancelled';

  @override
  String get checkInOk => 'OK';

  @override
  String get checkInCameraOff => 'Camera unavailable. Search by name instead.';

  @override
  String get checkInUnknownCode => 'That QR code isn\'t an ABS Fitness member card.';

  @override
  String get gymQrTitle => 'Today\'s check-in code';

  @override
  String get gymQrBody => 'Members scan this with the ABS Fitness app to check in. It changes every day.';

  @override
  String get memberCheckIn => 'Check in';

  @override
  String get memberCheckInTitle => 'Scan the gym code';

  @override
  String get memberCheckInHint => 'Point at the QR code at the front desk.';

  @override
  String get memberQrTitle => 'My check-in code';

  @override
  String get memberQrBody => 'Show this at the front desk to check in.';

  @override
  String get importTitle => 'Import members';

  @override
  String get importPick => 'Choose a CSV file';

  @override
  String get importPickBody =>
      'Save your existing sheet as CSV (File → Download → CSV), then pick it here. The first row should have the column names.';

  @override
  String get importMapTitle => 'Match your columns';

  @override
  String get importNotMapped => 'Not in file';

  @override
  String get importPreview => 'Preview';

  @override
  String get importDone => 'Import finished';

  @override
  String get importShareReport => 'Share error report';

  @override
  String get importAnother => 'Import another file';

  @override
  String get importFileError => 'Couldn\'t read that file. Make sure it\'s a CSV.';

  @override
  String get importNeedNamePhone => 'Pick the name and phone columns to continue.';

  @override
  String get importRequired => 'required';

  @override
  String get gymProfileTitle => 'Gym profile';

  @override
  String get fieldGymName => 'Gym name';

  @override
  String get fieldGymPhone => 'Gym phone';

  @override
  String get fieldGymAddress => 'Address';

  @override
  String get fieldUpi => 'UPI ID';

  @override
  String get fieldGstin => 'GSTIN (optional)';

  @override
  String get fieldExpiringWindow => 'Warn this many days before a plan ends';

  @override
  String get fieldAbsentDays => 'Flag members absent for this many days';

  @override
  String get fieldLapsedRenew => 'When a lapsed member renews, start from';

  @override
  String get lapsedToday => 'Today';

  @override
  String get lapsedEnd => 'Day after old end';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get dashActive => 'Active members';

  @override
  String get dashExpiring => 'Expiring soon';

  @override
  String get dashCheckIns => 'Today\'s check-ins';

  @override
  String get dashNew => 'New this month';

  @override
  String get dashNeedsAction => 'Needs action today';

  @override
  String get dashAllClear => 'All clear! Nothing needs you right now.';

  @override
  String get dashLiveFeed => 'Live check-ins';

  @override
  String get dashNoCheckIns => 'No check-ins yet today';

  @override
  String get reasonBirthday => 'Birthday today';

  @override
  String get reasonAbsent => 'Not seen for a while';

  @override
  String get dashSetupPlans => 'Create membership plans';

  @override
  String get dashSetupPlansBody => 'Plans and prices members can join.';

  @override
  String get dashSetupGym => 'Fill in your gym profile';

  @override
  String get dashSetupGymBody => 'Name, address and UPI ID for receipts and links.';

  @override
  String get myProgressTitle => 'My progress';

  @override
  String get myProgressEmpty => 'Your trainer will record your measurements here.';

  @override
  String get myVisitsTitle => 'Visits this month';

  @override
  String membersSelected(int count) {
    return '$count selected';
  }

  @override
  String bulkTrainerAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count members', one: '1 member');
    return 'Trainer updated for $_temp0';
  }

  @override
  String exportReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members exported',
      one: '1 member exported',
    );
    return '$_temp0';
  }

  @override
  String whatsappReminderText(String name, String plan, String gym, String date) {
    return 'Hi $name, your $plan membership at $gym ends on $date. Renew at the front desk to keep going!';
  }

  @override
  String whatsappExpiredText(String name, String gym, String date) {
    return 'Hi $name, we miss you at $gym! Your membership ended on $date. Come back and renew any time.';
  }

  @override
  String whatsappBirthdayText(String name, String gym) {
    return 'Happy birthday $name! Wishing you a strong year ahead from all of us at $gym.';
  }

  @override
  String whatsappAbsentText(String name, String gym) {
    return 'Hi $name, we haven\'t seen you at $gym for a few days. Everything okay? Your next workout is waiting!';
  }

  @override
  String stepOf(int count) {
    return 'Step $count of 3';
  }

  @override
  String endsOn(String date) {
    return 'Ends $date';
  }

  @override
  String startsOn(String date) {
    return 'Starts $date';
  }

  @override
  String memberSaved(String name) {
    return '$name added';
  }

  @override
  String duplicateWarning(String name, String code) {
    return 'Possible duplicate: $name ($code)';
  }

  @override
  String deleteConfirmTitle(String name) {
    return 'Delete $name forever?';
  }

  @override
  String freezeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count freeze days left on this plan',
      one: '1 freeze day left on this plan',
      zero: 'No freeze days left on this plan',
    );
    return '$_temp0';
  }

  @override
  String freezeDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Frozen for $count days',
      one: 'Frozen for 1 day',
    );
    return '$_temp0';
  }

  @override
  String renewDone(String date) {
    return 'Renewed until $date';
  }

  @override
  String attendanceVisits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visits',
      one: '1 visit',
      zero: 'No visits',
    );
    return '$_temp0';
  }

  @override
  String planActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active members',
      one: '1 active member',
      zero: 'No active members',
    );
    return '$_temp0';
  }

  @override
  String planDurationMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count months', one: '1 month');
    return '$_temp0';
  }

  @override
  String planDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count days', one: '1 day');
    return '$_temp0';
  }

  @override
  String planFreezeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count freeze days',
      one: '1 freeze day',
      zero: 'No freezes',
    );
    return '$_temp0';
  }

  @override
  String checkInWelcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String checkInDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'Last day today',
    );
    return '$_temp0';
  }

  @override
  String importReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows ready to import',
      one: '1 row ready to import',
    );
    return '$_temp0';
  }

  @override
  String importProblems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows have problems',
      one: '1 row has problems',
    );
    return '$_temp0';
  }

  @override
  String importStart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count members',
      one: 'Import 1 member',
    );
    return '$_temp0';
  }

  @override
  String importRunning(int done, int total) {
    return 'Importing… $done of $total';
  }

  @override
  String importImported(int count) {
    return '$count imported';
  }

  @override
  String importDuplicates(int count) {
    return '$count duplicates skipped';
  }

  @override
  String importErrors(int count) {
    return '$count not imported';
  }

  @override
  String reasonRenewal(String date) {
    return 'Renewal due $date';
  }

  @override
  String reasonExpired(String date) {
    return 'Expired $date';
  }

  @override
  String reasonAbsentSince(String date) {
    return 'Last visit $date';
  }

  @override
  String visitedAt(String time) {
    return 'Checked in $time';
  }

  @override
  String get daysShort => 'days';
}
