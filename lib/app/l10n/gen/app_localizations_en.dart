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
  String get welcomeNotConfigured =>
      'This build has no server configured. Sign-in is disabled; long-press the logo to open the component gallery.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhone => 'Phone number';

  @override
  String get fieldName => 'Full name';

  @override
  String get fieldRole => 'Role';

  @override
  String get validationEmail => 'Enter a valid email address';

  @override
  String get validationPhone => 'Enter a 10-digit Indian mobile number';

  @override
  String get authNotConfigured => 'Sign-in is not available in this build.';

  @override
  String get authNoProfile =>
      'This Google account isn\'t registered at the gym. Ask the front desk to add your Gmail to your profile, then try again.';

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
  String get moreStaffSubtitle => 'Add and manage your team';

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
  String get staffEmptyBody => 'Add your trainers and front desk by their Gmail so they can sign in.';

  @override
  String get staffInvite => 'Add staff';

  @override
  String get staffInviteTitle => 'Add a team member';

  @override
  String get staffInviteAction => 'Add to team';

  @override
  String get staffInactive => 'Inactive';

  @override
  String get commonNotFound => 'We couldn\'t find that. It may have been removed.';

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
  String get authRateLimited => 'Too many attempts. Please wait a minute and try again.';

  @override
  String get authBackendError => 'Couldn\'t connect to the gym server. Check the app\'s Supabase URL and key.';

  @override
  String get staffInviteEmailTaken => 'This Gmail is already on the team.';

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
  String get paymentNote => 'An invoice is created for this plan. Collect now or later from Payments.';

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

  @override
  String get payTitle => 'Payments';

  @override
  String get paySearchHint => 'Search name, invoice or receipt';

  @override
  String get payCollectedToday => 'Collected today';

  @override
  String get payMyCollections => 'Your collections today';

  @override
  String payPaymentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments',
      one: '1 payment',
      zero: 'No payments yet',
    );
    return '$_temp0';
  }

  @override
  String get payDayClosed => 'Day closed';

  @override
  String get payCloseDay => 'Close day';

  @override
  String get payTabDue => 'Due';

  @override
  String get payTabOverdue => 'Overdue';

  @override
  String get payTabPaid => 'Paid';

  @override
  String get payTabPending => 'To verify';

  @override
  String get payEmptyDueTitle => 'Nothing due';

  @override
  String get payEmptyDueBody => 'No open invoices right now.';

  @override
  String get payEmptyOverdueTitle => 'No overdue fees';

  @override
  String get payEmptyOverdueBody => 'Everyone is paid up. High five!';

  @override
  String get payEmptyPaidTitle => 'No paid invoices yet';

  @override
  String get payEmptyPaidBody => 'Paid invoices show up here.';

  @override
  String get payEmptyPendingTitle => 'Nothing to verify';

  @override
  String get payEmptyPendingBody =>
      'When a member taps \"I\'ve paid\", their UPI reference waits here for a quick check.';

  @override
  String get payEmptySearchTitle => 'No matches';

  @override
  String get payEmptySearchBody => 'Try another name, invoice or receipt number.';

  @override
  String payDueIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days',
      one: 'Due tomorrow',
      zero: 'Due today',
    );
    return '$_temp0';
  }

  @override
  String payOverdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '$days days overdue', one: '1 day overdue');
    return '$_temp0';
  }

  @override
  String payBalance(String amount) {
    return '$amount due';
  }

  @override
  String get payHistory => 'History';

  @override
  String get payReminders => 'Fee reminders today';

  @override
  String payRemindersBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members to nudge',
      one: '1 member to nudge',
    );
    return '$_temp0';
  }

  @override
  String get payCollect => 'Collect';

  @override
  String get payTrainerTitle => 'Payments are with the desk';

  @override
  String get payTrainerBody => 'Fees and receipts are handled by the front desk and the owner.';

  @override
  String get payApprove => 'Approve';

  @override
  String get payReject => 'Reject';

  @override
  String get payRejectTitle => 'Reject this payment?';

  @override
  String get payRejectReason => 'Why? (the member sees this)';

  @override
  String payUtr(String utr) {
    return 'UTR $utr';
  }

  @override
  String payApproved(String receipt) {
    return 'Approved. Receipt $receipt';
  }

  @override
  String get payRejected => 'Payment rejected';

  @override
  String payClaimedAt(String time) {
    return 'Sent $time';
  }

  @override
  String get modeCash => 'Cash';

  @override
  String get modeUpi => 'UPI';

  @override
  String get modeCard => 'Card';

  @override
  String get modeBank => 'Bank transfer';

  @override
  String get modeOnline => 'Online';

  @override
  String get modeCredit => 'Credit';

  @override
  String get invoiceStatusPartial => 'Part paid';

  @override
  String get invoiceStatusPaid => 'Paid';

  @override
  String get invoiceStatusVoid => 'Void';

  @override
  String get paymentStatusPending => 'Waiting for check';

  @override
  String get paymentStatusRejected => 'Rejected';

  @override
  String get paymentStatusVoided => 'Voided';

  @override
  String get collectTitle => 'Collect payment';

  @override
  String get collectSearchHint => 'Member name, phone or ID';

  @override
  String get collectNoMembers => 'No members match';

  @override
  String get collectPickInvoice => 'Which invoice?';

  @override
  String get collectNothingDueTitle => 'Nothing due';

  @override
  String collectNothingDueBody(String name) {
    return '$name has no open invoices.';
  }

  @override
  String get collectAmount => 'Amount';

  @override
  String collectFull(String amount) {
    return 'Full $amount';
  }

  @override
  String collectInstalment(String amount) {
    return 'Instalment $amount';
  }

  @override
  String get collectMode => 'Paid by';

  @override
  String get collectUtr => 'UPI / bank reference (UTR)';

  @override
  String get collectUtrHelp => 'The 12-digit reference from the payment app';

  @override
  String get collectUtrMissing => 'Enter the UPI / bank reference (at least 6 characters).';

  @override
  String collectExtraCredit(String amount) {
    return '$amount extra is saved as credit';
  }

  @override
  String collectStillDue(String amount) {
    return '$amount will still be due';
  }

  @override
  String collectConfirm(String amount) {
    return 'Collect $amount';
  }

  @override
  String get collectEnterAmount => 'Enter an amount';

  @override
  String collectUseCredit(String amount) {
    return 'Use credit $amount';
  }

  @override
  String get collectDone => 'Payment received!';

  @override
  String collectCreditSaved(String amount) {
    return '$amount saved as credit';
  }

  @override
  String collectReceiptNo(String receipt) {
    return 'Receipt $receipt';
  }

  @override
  String get collectShareReceipt => 'Share receipt';

  @override
  String get collectShare => 'Share';

  @override
  String get collectPrint => 'Print';

  @override
  String get collectWhatsApp => 'Send on WhatsApp';

  @override
  String get collectAnother => 'Done';

  @override
  String get collectChangeMember => 'Change';

  @override
  String get keypadBackspace => 'Delete digit';

  @override
  String receiptWhatsAppText(String name, String amount, String gym, String receipt) {
    return 'Hi $name, we received $amount at $gym. Receipt $receipt. Thank you!';
  }

  @override
  String get receiptFailed => 'Could not make the receipt. Try again.';

  @override
  String get invoiceTitle => 'Invoice';

  @override
  String get invoiceItems => 'Items';

  @override
  String get invoiceDiscount => 'Discount';

  @override
  String get invoiceTaxable => 'Taxable value';

  @override
  String get invoiceCgst => 'CGST';

  @override
  String get invoiceSgst => 'SGST';

  @override
  String get invoiceTotal => 'Total';

  @override
  String get invoicePaid => 'Paid';

  @override
  String get invoiceBalance => 'Balance';

  @override
  String invoiceIssued(String date) {
    return 'Issued $date';
  }

  @override
  String get invoicePayments => 'Payments';

  @override
  String get invoiceNoPayments => 'No payments yet';

  @override
  String get invoiceInstalments => 'Instalments';

  @override
  String get invoiceSplit => 'Split into instalments';

  @override
  String invoiceSplitHelp(String total) {
    return 'Up to 4 parts that add up to $total.';
  }

  @override
  String get invoiceAddPart => 'Add part';

  @override
  String invoicePart(int n) {
    return 'Part $n';
  }

  @override
  String invoiceSplitMismatch(String sum, String total) {
    return 'Parts add up to $sum; they must equal $total.';
  }

  @override
  String get invoiceSplitSaved => 'Instalments saved';

  @override
  String get invoiceSendLink => 'Send link';

  @override
  String get invoiceShowQr => 'UPI QR';

  @override
  String invoiceQrBody(String amount) {
    return 'Scan with any UPI app to pay $amount';
  }

  @override
  String get invoiceNoUpi => 'Add the gym\'s UPI ID in Gym profile to share payment links.';

  @override
  String get invoiceGatewayLink => 'Razorpay link';

  @override
  String get invoiceGatewayReady => 'Payment link ready';

  @override
  String invoiceUpiText(String name, String amount, String gym, String invoice, String link) {
    return 'Hi $name, your fees of $amount at $gym are due ($invoice). Pay by UPI: $link';
  }

  @override
  String invoiceGatewayText(String name, String amount, String gym, String link) {
    return 'Hi $name, pay your fees of $amount at $gym here: $link';
  }

  @override
  String get invoiceVoid => 'Void invoice';

  @override
  String invoiceVoidTitle(String invoice) {
    return 'Void $invoice?';
  }

  @override
  String get invoiceVoidBody => 'The invoice stays on record marked void. This cannot be undone.';

  @override
  String get invoiceVoided => 'Invoice voided';

  @override
  String invoiceVoidedReason(String reason) {
    return 'Voided: $reason';
  }

  @override
  String get invoiceReason => 'Reason';

  @override
  String invoiceApplyCredit(String amount) {
    return 'Use $amount credit';
  }

  @override
  String get invoiceCreditApplied => 'Credit applied';

  @override
  String get paymentVoid => 'Void payment';

  @override
  String paymentVoidTitle(String receipt) {
    return 'Void receipt $receipt?';
  }

  @override
  String get paymentVoidDone => 'Payment voided';

  @override
  String get paymentRefund => 'Refund';

  @override
  String paymentRefundTitle(String receipt) {
    return 'Refund from $receipt';
  }

  @override
  String get paymentRefundAmount => 'Refund amount';

  @override
  String get paymentRefundMode => 'Refund by';

  @override
  String get paymentRefundDone => 'Refund recorded';

  @override
  String paymentRefunded(String amount) {
    return 'Refunded $amount';
  }

  @override
  String get reasonRequired => 'Add a reason.';

  @override
  String get amountRequired => 'Enter an amount more than zero.';

  @override
  String get dayCloseTitle => 'Close the day';

  @override
  String get dayCloseBody => 'Count the cash drawer, then lock today\'s collections.';

  @override
  String get dayCloseByMode => 'Today\'s collections';

  @override
  String get dayCloseTotal => 'Total';

  @override
  String get dayCloseCounted => 'Cash you counted';

  @override
  String dayCloseExpected(String amount) {
    return 'Expected cash $amount';
  }

  @override
  String dayCloseOver(String amount) {
    return '$amount over';
  }

  @override
  String dayCloseShort(String amount) {
    return '$amount short';
  }

  @override
  String get dayCloseExact => 'Matches exactly';

  @override
  String get dayCloseNote => 'Note (optional)';

  @override
  String get dayCloseConfirm => 'Close day';

  @override
  String get dayCloseDone => 'Day closed. Nice work!';

  @override
  String dayCloseLocked(String time) {
    return 'Closed at $time. New collections need the owner to reopen your day.';
  }

  @override
  String get dayCloseHistory => 'Recent closes';

  @override
  String get dayCloseReopen => 'Reopen';

  @override
  String get dayCloseReopened => 'Day reopened';

  @override
  String get dayCloseReopenedPill => 'Reopened';

  @override
  String dayCloseCountedLine(String counted, String expected) {
    return 'Counted $counted · expected $expected';
  }

  @override
  String get expensesTitle => 'Expenses';

  @override
  String expensesTotal(String month) {
    return 'Spent in $month';
  }

  @override
  String get expensesEmptyTitle => 'No expenses this month';

  @override
  String get expensesEmptyBody => 'Add rent, salaries and bills to see what the gym really earns.';

  @override
  String get expenseAdd => 'Add expense';

  @override
  String get expenseCategory => 'Category';

  @override
  String get expenseAmount => 'Amount';

  @override
  String get expenseDate => 'Date';

  @override
  String get expenseNote => 'Note (optional)';

  @override
  String get expenseSaved => 'Expense saved';

  @override
  String get expenseDeleted => 'Expense deleted';

  @override
  String get expenseDelete => 'Delete expense';

  @override
  String get expenseRent => 'Rent';

  @override
  String get expenseSalaries => 'Salaries';

  @override
  String get expenseElectricity => 'Electricity';

  @override
  String get expenseEquipment => 'Equipment';

  @override
  String get expenseMaintenance => 'Maintenance';

  @override
  String get expenseMarketing => 'Marketing';

  @override
  String get expenseSupplies => 'Supplies';

  @override
  String get expenseOther => 'Other';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get historyTitle => 'Payment history';

  @override
  String get historySearchHint => 'Name, receipt or UTR';

  @override
  String get historyAllModes => 'All modes';

  @override
  String get historyDates => 'Dates';

  @override
  String get historyClear => 'Clear filters';

  @override
  String get historyEmptyTitle => 'No payments found';

  @override
  String get historyEmptyBody => 'Try another search or filter.';

  @override
  String get dashRevenue => 'Collected';

  @override
  String get dashToday => 'Today';

  @override
  String get dashWeek => 'This week';

  @override
  String get dashMonth => 'This month';

  @override
  String get dashOverdue => 'Overdue fees';

  @override
  String get dashToVerify => 'Payments to verify';

  @override
  String dashOutstanding(String amount) {
    return '$amount outstanding';
  }

  @override
  String get dashLast30 => 'Last 30 days';

  @override
  String dashInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invoices',
      one: '1 invoice',
      zero: 'No invoices',
    );
    return '$_temp0';
  }

  @override
  String reasonOverdue(String amount, String date) {
    return '$amount overdue since $date';
  }

  @override
  String whatsappDuesText(String name, String amount, String gym, String date) {
    return 'Hi $name, a friendly reminder: $amount is due at $gym (since $date).';
  }

  @override
  String whatsappDueSoonText(String name, String amount, String gym, String date) {
    return 'Hi $name, your fees of $amount at $gym are due on $date.';
  }

  @override
  String whatsappDueTodayText(String name, String amount, String gym) {
    return 'Hi $name, your fees of $amount at $gym are due today.';
  }

  @override
  String whatsappPayLine(String link) {
    return 'Pay by UPI: $link';
  }

  @override
  String get meDuesTitle => 'Fees due';

  @override
  String meDueBy(String date) {
    return 'Due $date';
  }

  @override
  String get mePayNow => 'Pay now';

  @override
  String get meAllPaid => 'All paid up. Thank you!';

  @override
  String get mePayTitle => 'Pay fees';

  @override
  String get mePayUpi => 'Pay with a UPI app';

  @override
  String get mePayScan => 'Or scan this QR from another phone';

  @override
  String get mePaid => 'I\'ve paid';

  @override
  String get mePaidTitle => 'Tell us you\'ve paid';

  @override
  String get mePaidBody =>
      'Enter the UPI reference (UTR) from your payment app. The desk checks it and your receipt appears here.';

  @override
  String get mePaidAmount => 'Amount you paid';

  @override
  String get mePaidSubmit => 'Send for check';

  @override
  String get mePaidSent => 'Sent! We\'ll confirm it soon.';

  @override
  String mePaidPending(String amount) {
    return '$amount waiting for the desk to check';
  }

  @override
  String get mePayments => 'My payments';

  @override
  String get mePaymentsSubtitle => 'Invoices and receipts';

  @override
  String get meNoUpi => 'The gym hasn\'t set up UPI yet. Please pay at the front desk.';

  @override
  String get meNoInvoicesTitle => 'No invoices yet';

  @override
  String get meNoInvoicesBody => 'Your invoices and receipts will show up here.';

  @override
  String get mePayAtDesk => 'You can also pay at the front desk.';

  @override
  String meRejected(String reason) {
    return 'Not confirmed: $reason';
  }

  @override
  String get noUpiApp => 'No UPI app opened. Scan the QR instead.';

  @override
  String checkInDues(String amount) {
    return '$amount fees pending';
  }

  @override
  String memberCredit(String amount) {
    return 'Credit $amount';
  }

  @override
  String memberDues(String amount) {
    return '$amount due';
  }

  @override
  String get memberNoInvoicesTitle => 'No invoices yet';

  @override
  String get memberNoInvoicesBody => 'An invoice is created when a plan starts or renews.';

  @override
  String get gymPaymentsSection => 'Payments';

  @override
  String get gymGstEnabled => 'Charge GST';

  @override
  String get gymGstEnabledBody => 'Shows CGST and SGST on invoices (needs a GSTIN).';

  @override
  String get gymGstInclusive => 'Prices include GST';

  @override
  String get gymGstInclusiveBody => 'Off: GST is added on top of plan prices.';

  @override
  String get gymRazorpay => 'Razorpay payment links';

  @override
  String get gymRazorpayBody => 'Needs Razorpay keys on the server. UPI links work without it.';

  @override
  String get moreDayClose => 'Day close';

  @override
  String get moreDayCloseSubtitle => 'Count cash and lock the day';

  @override
  String get moreExpenses => 'Expenses';

  @override
  String get moreExpensesSubtitle => 'Rent, salaries and bills';

  @override
  String get morePaymentHistory => 'Payment history';

  @override
  String get morePaymentHistorySubtitle => 'Every receipt, with filters';

  @override
  String get welcomeGoogle => 'Continue with Google';

  @override
  String get welcomeGoogleHint => 'Staff and members: use the Gmail the gym has on your record.';

  @override
  String get authSharedEmail =>
      'This Gmail is on more than one member. Ask the front desk to give each member their own Gmail.';

  @override
  String get authGoogleOnly => 'Please sign in with your Google account.';

  @override
  String get authCancelled => 'Google sign-in didn\'t open. Please try again.';

  @override
  String get fieldGmail => 'Gmail';

  @override
  String get staffGmailHelp => 'They sign in with Google using this address.';

  @override
  String get memberGmailHelp => 'Used to sign in to the member app with Google.';

  @override
  String memberNoGmail(String name) {
    return 'Add a Gmail so $name can sign in to the member app.';
  }

  @override
  String get staffAddedTitle => 'Added to the team';

  @override
  String staffAddedBody(String name) {
    return '$name can now sign in with Google using:';
  }

  @override
  String get trainTitle => 'Training';

  @override
  String get trainTabMembers => 'My members';

  @override
  String get trainTabPrograms => 'Programs';

  @override
  String get trainTabExercises => 'Exercises';

  @override
  String get trainAllTrainers => 'All trainers';

  @override
  String get trainNoProgram => 'No program';

  @override
  String trainLastWorkout(String date) {
    return 'Last workout $date';
  }

  @override
  String get trainNeverWorkedOut => 'No workouts yet';

  @override
  String trainThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count this week',
      one: '1 this week',
      zero: 'None this week',
    );
    return '$_temp0';
  }

  @override
  String trainAdherence(int percent) {
    return '$percent% on plan';
  }

  @override
  String get trainEmptyMembersTitle => 'No members yet';

  @override
  String get trainEmptyMembersBody => 'Members assigned to you show up here with their program and progress.';

  @override
  String get trainSearchMembers => 'Search members';

  @override
  String get exTitle => 'Exercises';

  @override
  String exSearchHint(int count) {
    return 'Search $count exercises';
  }

  @override
  String get exFront => 'Front';

  @override
  String get exBack => 'Back';

  @override
  String get exBodyMapHint => 'Tap a muscle to see its exercises';

  @override
  String get exAllMuscles => 'All muscles';

  @override
  String get exFavourites => 'Favourites';

  @override
  String get exFilters => 'Filters';

  @override
  String get exOurEquipment => 'Equipment we have';

  @override
  String get exEquipment => 'Equipment';

  @override
  String get exLevel => 'Level';

  @override
  String get exCategory => 'Type';

  @override
  String get exClearFilters => 'Clear filters';

  @override
  String exShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count exercises',
      one: 'Show 1 exercise',
      zero: 'No exercises',
    );
    return '$_temp0';
  }

  @override
  String get exEmptyTitle => 'No exercises match';

  @override
  String get exEmptyBody => 'Try another muscle, search or filter.';

  @override
  String get exEmptyFavouritesTitle => 'No favourites yet';

  @override
  String get exEmptyFavouritesBody => 'Tap the star on any exercise to keep it here.';

  @override
  String get exAdd => 'Add exercise';

  @override
  String get exStar => 'Add to favourites';

  @override
  String get exUnstar => 'Remove from favourites';

  @override
  String get exCustom => 'Gym exercise';

  @override
  String get exInstructions => 'How to do it';

  @override
  String get exTips => 'Tips';

  @override
  String get exMistakes => 'Common mistakes';

  @override
  String get exMuscles => 'Muscles worked';

  @override
  String get exPrimary => 'Main';

  @override
  String get exSecondary => 'Also works';

  @override
  String get exAlternatives => 'Alternatives';

  @override
  String get exWatchVideo => 'Watch on YouTube';

  @override
  String get exYourProgress => 'Your progress';

  @override
  String get exBestWeight => 'Best weight';

  @override
  String get exBestE1rm => 'Est. 1-rep max';

  @override
  String exSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count sessions', one: '1 session');
    return '$_temp0';
  }

  @override
  String get exNoHistory => 'Log this exercise in a workout to see your progress.';

  @override
  String get exEdit => 'Edit exercise';

  @override
  String get exArchive => 'Remove from library';

  @override
  String get exArchived => 'Exercise removed';

  @override
  String get exSaved => 'Exercise saved';

  @override
  String get exEquipmentTitle => 'Equipment we have';

  @override
  String get exEquipmentBody =>
      'Untick what the gym doesn\'t have. Members and trainers can hide exercises that need it.';

  @override
  String get exEquipmentSaved => 'Equipment saved';

  @override
  String get exNewTitle => 'New exercise';

  @override
  String get exEditTitle => 'Edit exercise';

  @override
  String get exFieldName => 'Name';

  @override
  String get exFieldLocalName => 'Hindi name (optional)';

  @override
  String get exFieldPrimary => 'Main muscles';

  @override
  String get exFieldSecondary => 'Other muscles';

  @override
  String get exFieldTracking => 'Log as';

  @override
  String get exFieldInstructions => 'Steps (one per line)';

  @override
  String get exFieldTips => 'Tips (optional)';

  @override
  String get exFieldMistakes => 'Common mistakes (optional)';

  @override
  String get exFieldVideo => 'YouTube link (optional)';

  @override
  String get exFieldPhoto => 'Photo';

  @override
  String get exPhotoAdd => 'Add a photo';

  @override
  String get exPhotoChange => 'Change photo';

  @override
  String get exNeedsMuscle => 'Pick at least one main muscle.';

  @override
  String get exBadVideo => 'Use a YouTube link (youtube.com or youtu.be).';

  @override
  String get trackRepsWeight => 'Reps and weight';

  @override
  String get trackReps => 'Reps only';

  @override
  String get trackTime => 'Time';

  @override
  String get trackDistanceTime => 'Distance and time';

  @override
  String get levelExpert => 'Expert';

  @override
  String get catStrength => 'Strength';

  @override
  String get catStretching => 'Stretching';

  @override
  String get catCardio => 'Cardio';

  @override
  String get catPlyometrics => 'Plyometrics';

  @override
  String get catPowerlifting => 'Powerlifting';

  @override
  String get catOlympic => 'Olympic lifting';

  @override
  String get catStrongman => 'Strongman';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleForearms => 'Forearms';

  @override
  String get muscleAbdominals => 'Abs';

  @override
  String get muscleQuadriceps => 'Quads';

  @override
  String get muscleAdductors => 'Inner thighs';

  @override
  String get muscleAbductors => 'Outer thighs';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleNeck => 'Neck';

  @override
  String get muscleTraps => 'Traps';

  @override
  String get muscleLats => 'Lats';

  @override
  String get muscleMiddleBack => 'Middle back';

  @override
  String get muscleLowerBack => 'Lower back';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get equipBarbell => 'Barbell';

  @override
  String get equipDumbbell => 'Dumbbell';

  @override
  String get equipCable => 'Cable';

  @override
  String get equipMachine => 'Machine';

  @override
  String get equipKettlebells => 'Kettlebell';

  @override
  String get equipBands => 'Bands';

  @override
  String get equipMedicineBall => 'Medicine ball';

  @override
  String get equipExerciseBall => 'Exercise ball';

  @override
  String get equipFoamRoll => 'Foam roller';

  @override
  String get equipEzBar => 'EZ curl bar';

  @override
  String get equipBodyOnly => 'Bodyweight';

  @override
  String get equipOther => 'Other';

  @override
  String get progEmptyTitle => 'No programs yet';

  @override
  String get progEmptyBody => 'Start from a gym template or build your own.';

  @override
  String get progSearch => 'Search programs';

  @override
  String get progStarter => 'Starter';

  @override
  String progWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(weeks, locale: localeName, other: '$weeks weeks', one: '1 week');
    return '$_temp0';
  }

  @override
  String progDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count days a week', one: '1 day a week');
    return '$_temp0';
  }

  @override
  String progExercises(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count exercises', one: '1 exercise');
    return '$_temp0';
  }

  @override
  String get progNew => 'New program';

  @override
  String get progAssign => 'Assign';

  @override
  String get progDuplicate => 'Duplicate';

  @override
  String progDuplicated(String name) {
    return 'Copy saved as \"$name\"';
  }

  @override
  String get progEdit => 'Edit';

  @override
  String get progShare => 'Share plan';

  @override
  String get progSharePdf => 'PDF';

  @override
  String get progShareText => 'WhatsApp text';

  @override
  String get progArchive => 'Remove program';

  @override
  String get progArchived => 'Program removed';

  @override
  String get progProgressionNone => 'Same each week';

  @override
  String progProgressionWeight(String step) {
    return '+$step kg a week';
  }

  @override
  String progProgressionReps(String step) {
    return '+$step rep a week';
  }

  @override
  String progCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get goalFatLossShort => 'Fat loss';

  @override
  String get goalMuscleGainShort => 'Muscle gain';

  @override
  String get goalStrengthShort => 'Strength';

  @override
  String get goalGeneralShort => 'General fitness';

  @override
  String get goalRehabShort => 'Rehab';

  @override
  String get blockWarmup => 'Warm-up';

  @override
  String get blockMain => 'Main';

  @override
  String get blockCooldown => 'Cool-down';

  @override
  String superset(String key) {
    return 'Superset $key';
  }

  @override
  String itemSetsReps(int sets, String reps) {
    return '$sets × $reps';
  }

  @override
  String itemSetsTime(int sets, String time) {
    return '$sets × $time';
  }

  @override
  String itemAt(String weight) {
    return '@ $weight';
  }

  @override
  String itemRest(String time) {
    return 'rest $time';
  }

  @override
  String itemRpe(String rpe) {
    return 'RPE $rpe';
  }

  @override
  String itemTempo(String tempo) {
    return 'tempo $tempo';
  }

  @override
  String get buildNewTitle => 'New program';

  @override
  String get buildEditTitle => 'Edit program';

  @override
  String get buildName => 'Program name';

  @override
  String get buildDescription => 'Description (optional)';

  @override
  String get buildGoal => 'Goal';

  @override
  String get buildLevel => 'Level';

  @override
  String get buildWeeks => 'Weeks';

  @override
  String get buildProgression => 'Each week';

  @override
  String get buildStep => 'Step';

  @override
  String get buildAddDay => 'Add day';

  @override
  String get buildDayName => 'Day name';

  @override
  String buildDay(int n) {
    return 'Day $n';
  }

  @override
  String get buildRemoveDay => 'Remove day';

  @override
  String get buildRenameDay => 'Rename day';

  @override
  String get buildAddExercises => 'Add exercises';

  @override
  String get buildEmptyDay => 'Add exercises to this day.';

  @override
  String get buildSaved => 'Program saved';

  @override
  String get buildNeedsName => 'Give the program a name.';

  @override
  String get buildNeedsExercises => 'Every day needs at least one exercise.';

  @override
  String get buildItemTitle => 'Sets and targets';

  @override
  String get buildSets => 'Sets';

  @override
  String get buildReps => 'Reps';

  @override
  String get buildRepsMax => 'Up to (optional)';

  @override
  String get buildSeconds => 'Seconds';

  @override
  String get buildMetres => 'Metres (optional)';

  @override
  String get buildWeight => 'Target kg (optional)';

  @override
  String get buildRpe => 'RPE 1–10 (optional)';

  @override
  String get buildRestSeconds => 'Rest (seconds)';

  @override
  String get buildTempo => 'Tempo, e.g. 3-1-1 (optional)';

  @override
  String get buildNotes => 'Notes (optional)';

  @override
  String get buildBlock => 'Part of the workout';

  @override
  String get buildGroup => 'Superset with';

  @override
  String get buildRemoveItem => 'Remove exercise';

  @override
  String get buildDragHint => 'Hold and drag to reorder';

  @override
  String get buildPickTitle => 'Add exercises';

  @override
  String buildPickAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count exercises',
      one: 'Add 1 exercise',
      zero: 'Pick exercises',
    );
    return '$_temp0';
  }

  @override
  String get buildDiscardTitle => 'Discard changes?';

  @override
  String get buildDiscardBody => 'Your edits to this program will be lost.';

  @override
  String get buildDiscard => 'Discard';

  @override
  String get buildKeepEditing => 'Keep editing';

  @override
  String assignTitle(String name) {
    return 'Assign \"$name\"';
  }

  @override
  String get assignMembers => 'Members';

  @override
  String get assignSearch => 'Search your members';

  @override
  String get assignStart => 'Start date';

  @override
  String assignWeekdays(int count) {
    return 'Training days ($count a week)';
  }

  @override
  String assignPickWeekdays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'Pick $count days', one: 'Pick 1 day');
    return '$_temp0';
  }

  @override
  String get assignMode => 'If they already have a program';

  @override
  String get assignReplace => 'Replace it';

  @override
  String get assignQueue => 'Start after it';

  @override
  String assignConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Assign to $count members',
      one: 'Assign to 1 member',
      zero: 'Pick members',
    );
    return '$_temp0';
  }

  @override
  String assignDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Assigned to $count members',
      one: 'Assigned to 1 member',
    );
    return '$_temp0';
  }

  @override
  String get assignPickProgram => 'Pick a program';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get wkProgram => 'Program';

  @override
  String wkWeekOf(int week, int total) {
    return 'Week $week of $total';
  }

  @override
  String wkStartsOn(String date) {
    return 'Starts $date';
  }

  @override
  String get wkQueued => 'Up next';

  @override
  String wkEnds(String date) {
    return 'Ends $date';
  }

  @override
  String get wkStreak => 'Streak';

  @override
  String get wkAdherence => 'On plan';

  @override
  String get wkThisWeek => 'This week';

  @override
  String get wkCalendar => 'Plan vs done';

  @override
  String get wkPlanned => 'Planned';

  @override
  String get wkDone => 'Done';

  @override
  String get wkMissed => 'Missed';

  @override
  String get wkHistory => 'Workouts';

  @override
  String get wkNoWorkoutsTitle => 'No workouts yet';

  @override
  String get wkNoWorkoutsBody => 'Finished workouts show up here with PRs and coach comments.';

  @override
  String get wkNoProgramTitle => 'No program yet';

  @override
  String get wkNoProgramBody => 'Your trainer will set one up for you. Meanwhile, browse the exercise library.';

  @override
  String get wkNoProgramStaffBody => 'Assign a program to get them started.';

  @override
  String get wkAssign => 'Assign program';

  @override
  String get wkEditProgram => 'Tune program';

  @override
  String get wkEndProgram => 'End program';

  @override
  String wkEndTitle(String name) {
    return 'End \"$name\"?';
  }

  @override
  String get wkEndBody => 'The program stops today. Logged workouts stay.';

  @override
  String get wkEnded => 'Program ended';

  @override
  String wkTodayWorkout(String name) {
    return 'Today: $name';
  }

  @override
  String get wkRestDay => 'Rest day';

  @override
  String wkRestDayBody(String name, String date) {
    return 'Next: $name on $date';
  }

  @override
  String get wkDoneToday => 'Done for today. Great work!';

  @override
  String get wkStart => 'Start workout';

  @override
  String get wkResume => 'Resume workout';

  @override
  String wkStartNext(String name) {
    return 'Start $name instead';
  }

  @override
  String wkDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String wkVolume(String kg) {
    return '$kg kg lifted';
  }

  @override
  String wkPrs(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count PRs', one: '1 PR');
    return '$_temp0';
  }

  @override
  String get wkPartial => 'Partial';

  @override
  String get wkComments => 'Coach notes';

  @override
  String get wkCommentHint => 'Say something encouraging';

  @override
  String get wkSend => 'Send';

  @override
  String get wkReacted => 'Sent';

  @override
  String get wkLibrary => 'Exercise library';

  @override
  String get wkDays => 'Days';

  @override
  String wkLogTitle(String name, String date) {
    return '$name · $date';
  }

  @override
  String wkEditable(String time) {
    return 'You can change this workout until $time.';
  }

  @override
  String get playExitTitle => 'Leave the workout?';

  @override
  String get playExitBody => 'Your sets are saved on this phone. Resume any time from Workout.';

  @override
  String get playExitSave => 'Save as partial';

  @override
  String get playExitKeep => 'Keep it for later';

  @override
  String get playExitDiscard => 'Discard workout';

  @override
  String get playSet => 'Set';

  @override
  String get playTarget => 'Target';

  @override
  String get playKg => 'kg';

  @override
  String get playReps => 'reps';

  @override
  String get playSec => 'sec';

  @override
  String get playMetres => 'm';

  @override
  String get playAddSet => 'Add set';

  @override
  String get playTick => 'Done';

  @override
  String get playUntick => 'Not done';

  @override
  String playNext(String name) {
    return 'Next: $name';
  }

  @override
  String get playLastExercise => 'Last exercise';

  @override
  String get playRest => 'Rest';

  @override
  String get playRestSkip => 'Skip';

  @override
  String get playRestAdd => '+15 s';

  @override
  String get playFinish => 'Finish';

  @override
  String get playFinishEarlyTitle => 'Finish early?';

  @override
  String playFinishEarlyBody(int done, int total) {
    return '$done of $total sets done. It is saved as a partial workout.';
  }

  @override
  String get playFinishAnyway => 'Finish';

  @override
  String get playSummaryTitle => 'Workout done!';

  @override
  String get playSummaryPartial => 'Workout saved';

  @override
  String get playSummaryDuration => 'Time';

  @override
  String get playSummaryVolume => 'Lifted';

  @override
  String get playSummarySets => 'Sets';

  @override
  String get playSummaryPrs => 'New personal records';

  @override
  String get playPrWeight => 'Heaviest';

  @override
  String get playPrReps => 'Most reps';

  @override
  String get playPrE1rm => 'Best 1-rep max';

  @override
  String get playSynced => 'Saved';

  @override
  String get playQueued => 'Saved on this phone. It uploads when you are back online.';

  @override
  String get playDone => 'Done';

  @override
  String playElapsed(String time) {
    return '$time elapsed';
  }

  @override
  String get playOfflineHint => 'Works offline: your sets are saved on this phone.';

  @override
  String get meTodayWorkout => 'Today\'s workout';

  @override
  String get meProgressWorkouts => 'Workouts per week';

  @override
  String get meProgressPrs => 'Personal records';

  @override
  String get meNoPrs => 'Lift a little more than last time to set your first record.';

  @override
  String playSetsDone(int done, int total) {
    return '$done of $total sets done';
  }

  @override
  String get dashTrainingToday => 'Training today';

  @override
  String get dashMissedWorkouts => 'Missed workouts';

  @override
  String get dashNoSessionsToday => 'No sessions planned today.';

  @override
  String dashMissedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missed this week',
      one: '1 missed this week',
    );
    return '$_temp0';
  }

  @override
  String get wkEditWorkout => 'Edit workout';

  @override
  String get trainAreaWorkouts => 'Workouts';

  @override
  String get trainAreaDiet => 'Diet';

  @override
  String get trainTabDiets => 'Diet plans';

  @override
  String get trainTabFoods => 'Foods';

  @override
  String get dietNew => 'New diet plan';

  @override
  String get foodAdd => 'Add food';

  @override
  String get dietEmptyMembersBody =>
      'Members assigned to you show up here with their diet plan and how closely they follow it.';

  @override
  String get dietNeverLogged => 'No meals marked yet';

  @override
  String dietLastLogged(String date) {
    return 'Last marked $date';
  }

  @override
  String dietTodayMarked(int done, int total) {
    return '$done of $total today';
  }

  @override
  String dietMissedMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missed meals',
      one: '1 missed meal',
    );
    return '$_temp0';
  }

  @override
  String get dietHealthFlag => 'Health condition';

  @override
  String get dietNoPlanShort => 'No diet plan';

  @override
  String get dietSearchPlans => 'Search diet plans';

  @override
  String get dietPlansEmptyTitle => 'No diet plans';

  @override
  String get dietPlansEmptyBody => 'Try another search, or build the gym\'s first plan.';

  @override
  String get mealEarlyMorning => 'Early morning';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealMidMorning => 'Mid-morning';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealEveningSnack => 'Evening snack';

  @override
  String get mealPreWorkout => 'Pre-workout';

  @override
  String get mealPostWorkout => 'Post-workout';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealBedtime => 'Bedtime';

  @override
  String get foodCatGrains => 'Grains & breads';

  @override
  String get foodCatPulses => 'Dals & pulses';

  @override
  String get foodCatVegetables => 'Vegetables';

  @override
  String get foodCatFruits => 'Fruits';

  @override
  String get foodCatDairy => 'Dairy';

  @override
  String get foodCatEggs => 'Eggs';

  @override
  String get foodCatMeatFish => 'Meat & fish';

  @override
  String get foodCatNuts => 'Nuts & seeds';

  @override
  String get foodCatSnacks => 'Snacks';

  @override
  String get foodCatSweets => 'Sweets';

  @override
  String get foodCatDrinks => 'Drinks';

  @override
  String get foodCatFats => 'Ghee & oils';

  @override
  String get foodCatCondiments => 'Chutneys & extras';

  @override
  String get foodCatSupplements => 'Supplements';

  @override
  String get vegVegan => 'Vegan';

  @override
  String get vegVeg => 'Veg';

  @override
  String get vegEgg => 'Egg';

  @override
  String get vegNonVeg => 'Non-veg';

  @override
  String get prefVeg => 'Vegetarian';

  @override
  String get prefEggetarian => 'Eggetarian';

  @override
  String get prefNonVeg => 'Non-vegetarian';

  @override
  String get prefVegan => 'Vegan';

  @override
  String get prefJain => 'Jain';

  @override
  String get prefAny => 'No preference';

  @override
  String get dietGoalFatLoss => 'Fat loss';

  @override
  String get dietGoalMuscleGain => 'Muscle gain';

  @override
  String get dietGoalMaintenance => 'Maintenance';

  @override
  String get presetHighProtein => 'High protein';

  @override
  String get presetKetoLight => 'Keto-light';

  @override
  String get presetBalanced => 'Balanced';

  @override
  String get allergyDairy => 'Dairy';

  @override
  String get allergyGluten => 'Gluten';

  @override
  String get allergyNuts => 'Tree nuts';

  @override
  String get allergyPeanut => 'Peanuts';

  @override
  String get allergySoy => 'Soy';

  @override
  String get allergyEgg => 'Egg';

  @override
  String get allergyFish => 'Fish';

  @override
  String get allergyShellfish => 'Shellfish';

  @override
  String get allergySesame => 'Sesame';

  @override
  String conflictPref(String pref) {
    return 'Not $pref';
  }

  @override
  String conflictAllergy(String allergen) {
    return 'Contains $allergen';
  }

  @override
  String conflictAvoid(String word) {
    return 'Avoids $word';
  }

  @override
  String allergicTo(String allergen) {
    return 'Allergic to $allergen';
  }

  @override
  String avoids(String food) {
    return 'Avoids $food';
  }

  @override
  String unitKatori(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'katori', one: 'katori');
    return '$_temp0';
  }

  @override
  String unitRoti(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'rotis', one: 'roti');
    return '$_temp0';
  }

  @override
  String unitPiece(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'pieces', one: 'piece');
    return '$_temp0';
  }

  @override
  String unitGlass(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'glasses', one: 'glass');
    return '$_temp0';
  }

  @override
  String unitCup(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'cups', one: 'cup');
    return '$_temp0';
  }

  @override
  String unitBowl(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'bowls', one: 'bowl');
    return '$_temp0';
  }

  @override
  String unitPlate(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'plates', one: 'plate');
    return '$_temp0';
  }

  @override
  String unitSlice(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'slices', one: 'slice');
    return '$_temp0';
  }

  @override
  String get unitTbsp => 'tbsp';

  @override
  String get unitTsp => 'tsp';

  @override
  String unitScoop(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'scoops', one: 'scoop');
    return '$_temp0';
  }

  @override
  String unitHandful(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'handfuls', one: 'handful');
    return '$_temp0';
  }

  @override
  String get dietCalories => 'Calories';

  @override
  String get dietProtein => 'Protein';

  @override
  String get dietCarbs => 'Carbs';

  @override
  String get dietFat => 'Fat';

  @override
  String get dietP => 'P';

  @override
  String get dietC => 'C';

  @override
  String get dietF => 'F';

  @override
  String get dietProteinG => 'Protein (g)';

  @override
  String get dietCarbsG => 'Carbs (g)';

  @override
  String get dietFatG => 'Fat (g)';

  @override
  String get dietFibreG => 'Fibre (g)';

  @override
  String foodSearchHint(int count) {
    return 'Search $count foods';
  }

  @override
  String foodSuits(String pref) {
    return 'Suits $pref';
  }

  @override
  String get foodNotReviewed => 'Not reviewed';

  @override
  String foodNotReviewedCount(int count) {
    return 'Not reviewed ($count)';
  }

  @override
  String get foodReviewed => 'Reviewed';

  @override
  String get foodCustom => 'Gym\'s own';

  @override
  String get foodEmptyTitle => 'No foods match';

  @override
  String get foodEmptyBody => 'Try another word or clear the filters.';

  @override
  String foodPerServing(String serving) {
    return 'Per $serving';
  }

  @override
  String foodFibre(String grams) {
    return 'Fibre $grams g';
  }

  @override
  String foodPer100(int kcal, String protein) {
    return 'Per 100 g: $kcal kcal, $protein g protein';
  }

  @override
  String get foodAllergens => 'Allergens';

  @override
  String get foodToBuy => 'To buy for one serving';

  @override
  String get foodJainOk => 'Jain-friendly';

  @override
  String get foodJainHint => 'No onion, garlic or root vegetables';

  @override
  String get foodMarkReviewed => 'Mark as reviewed';

  @override
  String get foodReviewedDone => 'Marked as reviewed';

  @override
  String get foodEdit => 'Edit values';

  @override
  String get foodRemove => 'Remove';

  @override
  String get foodRemoved => 'Food removed';

  @override
  String get foodNewTitle => 'New food';

  @override
  String get foodEditTitle => 'Edit food';

  @override
  String get foodSaved => 'Food saved';

  @override
  String get foodSaveReviewed => 'Save and mark reviewed';

  @override
  String get foodReviewHint =>
      'These values came with the app and haven\'t been checked yet. Correct anything that\'s off for how the gym\'s members cook it, then save to mark it reviewed.';

  @override
  String get foodFieldName => 'Name';

  @override
  String get foodFieldLocalName => 'Hindi name';

  @override
  String get foodFieldCategory => 'Food group';

  @override
  String get foodFieldServing => 'Measured in';

  @override
  String foodFieldGrams(String unit) {
    return 'Grams in one $unit';
  }

  @override
  String get foodFieldVeg => 'Type';

  @override
  String foodValuesPer100(String unit) {
    return 'Values per 100 $unit';
  }

  @override
  String foodValuesPerServing(String unit) {
    return 'Values per $unit';
  }

  @override
  String get foodBadNumber => 'Enter a number in range';

  @override
  String foodMismatch(int kcal) {
    return 'Protein, carbs and fat add up to about $kcal kcal. Check the calories.';
  }

  @override
  String get dietPlan => 'Diet plan';

  @override
  String get dietMeals => 'Meals';

  @override
  String dietMealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count meals', one: '1 meal');
    return '$_temp0';
  }

  @override
  String dietFoodsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count foods', one: '1 food');
    return '$_temp0';
  }

  @override
  String dietOr(int group) {
    return 'Or option $group';
  }

  @override
  String get dietSupplements => 'Supplements';

  @override
  String get dietDisclaimer =>
      'This plan is general guidance, not medical advice. If you have a medical condition, are pregnant or take medicines, check with your doctor before changing what you eat.';

  @override
  String get dietPlannedVsTarget => 'Planned vs target';

  @override
  String get dietAssign => 'Assign diet';

  @override
  String get dietDuplicate => 'Duplicate & scale';

  @override
  String get dietDuplicateTitle => 'Duplicate and scale';

  @override
  String get dietDuplicateKcal => 'Calories a day for the copy';

  @override
  String get dietKcalRange => 'Calories must be between 800 and 6,000 a day';

  @override
  String dietRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get dietRemoveBody => 'It disappears from the library. Members already on it keep their own copy.';

  @override
  String get dietRemoved => 'Plan removed';

  @override
  String medicalFlagTitle(String name) {
    return '$name has a health condition';
  }

  @override
  String get medicalFlagBody => 'Check the plan suits them, and ask them to clear diet changes with their doctor.';

  @override
  String get dietNewTitle => 'New diet plan';

  @override
  String get dietEditTitle => 'Edit diet plan';

  @override
  String dietEditFor(String name) {
    return '$name\'s plan';
  }

  @override
  String get dietSaved => 'Diet plan saved';

  @override
  String get dietNeedsFoods => 'Add a food to each meal, or remove the empty ones.';

  @override
  String dietConflictsPlan(int count, String pref) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foods aren\'t $pref',
      one: '1 food isn\'t $pref',
    );
    return '$_temp0';
  }

  @override
  String dietConflictsMember(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foods don\'t suit $name',
      one: '1 food doesn\'t suit $name',
    );
    return '$_temp0';
  }

  @override
  String get dietTargets => 'Daily targets';

  @override
  String dietScaleToTarget(String kcal) {
    return 'Scale foods to $kcal kcal';
  }

  @override
  String get dietPreference => 'Diet';

  @override
  String get dietAddSupplement => 'Add';

  @override
  String get dietSupplementName => 'Supplement name';

  @override
  String get dietAddMeal => 'Add a meal';

  @override
  String get dietAddFood => 'Add food';

  @override
  String dietAddFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count foods',
      one: 'Add 1 food',
      zero: 'Pick foods',
    );
    return '$_temp0';
  }

  @override
  String get dietLess => 'Less';

  @override
  String get dietMore => 'More';

  @override
  String get dietAmountGrams => 'Amount in grams';

  @override
  String get dietAmountServings => 'Number of servings';

  @override
  String get dietSetTime => 'Set time';

  @override
  String get dietRemoveMeal => 'Remove meal';

  @override
  String get dietRemoveOption => 'Remove option';

  @override
  String get dietSuggestOption => 'Suggest an option';

  @override
  String get dietAddOption => 'Add an option';

  @override
  String get dietMealNotes => 'Notes for this meal';

  @override
  String get targetsTitle => 'Targets calculator';

  @override
  String get targetsBody =>
      'From BMR (Mifflin-St Jeor) and daily activity: a starting point to adjust as they progress.';

  @override
  String get targetsCalculate => 'Calculate';

  @override
  String get targetsGender => 'Sex';

  @override
  String get targetsAge => 'Age';

  @override
  String get targetsHeight => 'Height (cm)';

  @override
  String get targetsWeight => 'Weight (kg)';

  @override
  String get targetsActivity => 'Activity';

  @override
  String get targetsGoal => 'Goal';

  @override
  String get targetsPreset => 'Macro split';

  @override
  String get targetsProteinPerKg => 'Protein per kg body weight';

  @override
  String get targetsNeedProfile => 'Enter age, height and weight to calculate.';

  @override
  String targetsBmrTdee(String bmr, String tdee) {
    return 'BMR $bmr kcal · maintenance $tdee kcal';
  }

  @override
  String get targetsUse => 'Use these targets';

  @override
  String get activitySedentary => 'Sedentary';

  @override
  String get activityLight => 'Lightly active';

  @override
  String get activityModerate => 'Moderately active';

  @override
  String get activityActive => 'Very active';

  @override
  String get activityAthlete => 'Athlete';

  @override
  String get dietPickPlan => 'Pick a diet plan';

  @override
  String get dietAssignReplaces =>
      'From the start date it replaces their current diet plan. Earlier plans stay in their history.';

  @override
  String assignHealthWarning(String name, String conditions) {
    return '$name: $conditions. Check the plan suits them.';
  }

  @override
  String assignFoodsWarning(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name: $count foods don\'t suit their preferences',
      one: '$name: 1 food doesn\'t suit their preferences',
    );
    return '$_temp0';
  }

  @override
  String get dietPrivate => 'Diet plans and logs are private: only the member\'s trainer and the owner can see them.';

  @override
  String get dietNoPlanTitle => 'No diet plan yet';

  @override
  String get dietNoPlanStaffBody => 'Pick a plan from the library and adjust it to their targets.';

  @override
  String get dietNoPlanBody => 'Your trainer will add one. You can still track water.';

  @override
  String get dietNoPlanThatDay => 'There was no plan on this day.';

  @override
  String get dietStatusActive => 'Running';

  @override
  String get dietStatusQueued => 'Starts later';

  @override
  String get dietStatusReplaced => 'Replaced';

  @override
  String get dietStatusEnded => 'Ended';

  @override
  String dietStarts(String date) {
    return 'Starts $date';
  }

  @override
  String dietSince(String date) {
    return 'Since $date';
  }

  @override
  String get dietTune => 'Adjust their plan';

  @override
  String get dietEnd => 'End plan';

  @override
  String dietEndTitle(String name) {
    return 'End $name?';
  }

  @override
  String get dietEndBody => 'The member stops seeing this plan. What they logged stays.';

  @override
  String get dietEnded => 'Plan ended';

  @override
  String get dietToday => 'Today';

  @override
  String get dietHistory => 'Earlier plans';

  @override
  String get dietWeeklyAdherence => 'On plan, week by week';

  @override
  String get dietThisWeek => 'This week';

  @override
  String get dietAdherence => 'Meals on plan';

  @override
  String dietWeightRange(String min, String max) {
    return 'Weight $min–$max kg';
  }

  @override
  String get dietCoachNotes => 'Coach notes';

  @override
  String get dietNoNotes => 'No notes yet.';

  @override
  String get dietAddNote => 'Add a note for the member';

  @override
  String waterAverage(String avg, int goal) {
    return 'Water $avg of $goal a day';
  }

  @override
  String get prefsTitle => 'Food preferences';

  @override
  String get prefsAllergies => 'Allergies';

  @override
  String get prefsAvoid => 'Foods to avoid';

  @override
  String get prefsAvoidHint => 'Foods to avoid, separated by commas';

  @override
  String get prefsSaved => 'Preferences saved';

  @override
  String get dietDayToday => 'Today';

  @override
  String get dietDayYesterday => 'Yesterday';

  @override
  String dietNewPlan(String name) {
    return 'New plan from your coach: $name';
  }

  @override
  String dietStartsOn(String name, String date) {
    return '$name starts $date';
  }

  @override
  String dietWeekOnPlan(int percent) {
    return '$percent% this week';
  }

  @override
  String dietMarkedOf(int done, int total) {
    return '$done of $total meals marked';
  }

  @override
  String get dietAllMarked => 'All meals marked today';

  @override
  String dietNextMeal(String meal, String time) {
    return 'Next: $meal at $time';
  }

  @override
  String get meTodayMeals => 'Today\'s meals';

  @override
  String get markEaten => 'Eaten';

  @override
  String get markPartly => 'Partly';

  @override
  String get markSkipped => 'Skipped';

  @override
  String get markSwapped => 'Swapped';

  @override
  String markSwappedTo(String option) {
    return 'Swapped: $option';
  }

  @override
  String get markClear => 'Clear';

  @override
  String get waterTitle => 'Water';

  @override
  String waterGlasses(int glasses, int goal) {
    return '$glasses of $goal glasses';
  }

  @override
  String get waterGoalHint => 'One glass is 250 ml. Your goal comes from your weight.';

  @override
  String get waterAdd => 'Add a glass';

  @override
  String get waterRemove => 'Remove a glass';

  @override
  String get remindersOn => 'Remind me at meal times';

  @override
  String get remindersOff => 'Turn off meal reminders';

  @override
  String get remindersOnDone => 'Meal reminders on';

  @override
  String get remindersOffDone => 'Meal reminders off';

  @override
  String reminderTitle(String meal) {
    return 'Time for $meal';
  }

  @override
  String get groceryTitle => 'Grocery list';

  @override
  String get groceryFor7Days => 'For 7 days of the plan as written (not the \"or\" options).';

  @override
  String get groceryShare => 'Share on WhatsApp';

  @override
  String get dietPlanName => 'Plan name';

  @override
  String get exPauseMotion => 'Tap to pause';

  @override
  String get exPlayMotion => 'Tap to play';

  @override
  String get bulkWhatsApp => 'WhatsApp';

  @override
  String get waTitle => 'WhatsApp';

  @override
  String get waMoreSubtitle => 'Today\'s messages, broadcasts and templates';

  @override
  String get waTabQueue => 'To send';

  @override
  String get waTabLog => 'Log';

  @override
  String get waTabBroadcasts => 'Broadcasts';

  @override
  String get waModeFree => 'Free mode';

  @override
  String get waModeApi => 'API mode';

  @override
  String get waModeFreeBody => 'Each message opens in your WhatsApp, ready to send.';

  @override
  String get waModeApiBody => 'Approved templates send automatically.';

  @override
  String get waNewBroadcast => 'Broadcast';

  @override
  String waQueueLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count to send',
      one: '1 to send',
      zero: 'All sent',
    );
    return '$_temp0';
  }

  @override
  String waQueueLeftMore(int count) {
    return '$count+ to send';
  }

  @override
  String waSendNext(String name, int left) {
    return 'Send to $name · $left left';
  }

  @override
  String get waSend => 'Send';

  @override
  String get waSkip => 'Skip';

  @override
  String get waMarkSent => 'Mark sent';

  @override
  String waMarkedSent(String name) {
    return 'Ticked: sent to $name';
  }

  @override
  String waMarkedSkipped(String name) {
    return 'Skipped $name';
  }

  @override
  String get waQueueEmptyTitle => 'Nothing to send';

  @override
  String get waQueueEmptyBody => 'Today\'s reminders, wishes and receipts show up here, ready to send one by one.';

  @override
  String get waBuildToday => 'Check for today\'s reminders';

  @override
  String waBuilt(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new reminders',
      one: '1 new reminder',
      zero: 'No new reminders',
    );
    return '$_temp0';
  }

  @override
  String get waNoWhatsApp => 'Couldn\'t open WhatsApp on this device.';

  @override
  String get waApiQueueNote => 'API mode is on. These are messages the API couldn\'t send: send them by hand.';

  @override
  String get waSendNow => 'Send now';

  @override
  String get waSendNowDone => 'Sending the due messages';

  @override
  String get waLogAll => 'All';

  @override
  String get waLogQueued => 'Queued';

  @override
  String get waLogSent => 'Sent';

  @override
  String get waLogFailed => 'Failed';

  @override
  String get waLogSkipped => 'Skipped';

  @override
  String get waStatusQueued => 'Queued';

  @override
  String get waStatusSending => 'Sending';

  @override
  String get waStatusSent => 'Sent';

  @override
  String get waStatusDelivered => 'Delivered';

  @override
  String get waStatusRead => 'Read';

  @override
  String get waStatusFailed => 'Failed';

  @override
  String get waStatusSkipped => 'Skipped';

  @override
  String get waStatusCancelled => 'Cancelled';

  @override
  String get waChannelLink => 'By hand';

  @override
  String get waChannelApi => 'API';

  @override
  String get waFreeWindow => 'Free: the member wrote in the last 24 hours';

  @override
  String get waLogEmptyTitle => 'No messages yet';

  @override
  String get waLogEmptyBody => 'Every WhatsApp message to members is listed here with its status.';

  @override
  String get waMemberMessages => 'Message log';

  @override
  String waMemberMessagesOf(String name) {
    return '$name\'s messages';
  }

  @override
  String get waKeyExpirySoon => 'Membership ending soon';

  @override
  String get waKeyExpiryToday => 'Membership ends today';

  @override
  String get waKeyExpired => 'Membership ended';

  @override
  String get waKeyDues => 'Fee reminder';

  @override
  String get waKeyPayment => 'Payment received';

  @override
  String get waKeyMembershipStarted => 'Welcome';

  @override
  String get waKeyMembershipRenewed => 'Renewal thanks';

  @override
  String get waKeyProgram => 'New workout program';

  @override
  String get waKeyDiet => 'New diet plan';

  @override
  String get waKeyBirthday => 'Birthday wishes';

  @override
  String get waKeyFestival => 'Festival wishes';

  @override
  String get waKeyManual => 'Sent by hand';

  @override
  String get waKeyBroadcast => 'Broadcast';

  @override
  String get waTodayTitle => 'WhatsApp today';

  @override
  String waTodayBody(int toSend, int sent) {
    return '$toSend to send · $sent sent';
  }

  @override
  String get waTodayAllDone => 'All of today\'s messages are sent.';

  @override
  String get waBroadcastTitle => 'New broadcast';

  @override
  String get waBroadcastName => 'Title (only staff see it)';

  @override
  String get waBroadcastMessage => 'Message';

  @override
  String get waInsertVariable => 'Tap to add a detail that changes per member:';

  @override
  String get waCategory => 'Type';

  @override
  String get waCategoryMarketing => 'Offer or wishes';

  @override
  String get waCategoryUtility => 'Gym update';

  @override
  String get waCategoryHelp =>
      'Gym updates (timings, closures) are utility messages. Offers and wishes are marketing: each member gets at most one a day.';

  @override
  String get waSegment => 'Send to';

  @override
  String get waSegAll => 'Everyone';

  @override
  String get waSegActive => 'Active members';

  @override
  String get waSegExpiring => 'Ending in 7 days';

  @override
  String get waSegExpired => 'Expired 30–90 days ago';

  @override
  String get waSegDues => 'With fees due';

  @override
  String get waSegTrainer => 'A trainer\'s members';

  @override
  String waSegTrainerNamed(String name) {
    return '$name\'s members';
  }

  @override
  String get waSegBatch => 'A batch';

  @override
  String waSegMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected members',
      one: '1 selected member',
    );
    return '$_temp0';
  }

  @override
  String waReach(int reachable, int total) {
    return '$reachable of $total members get it';
  }

  @override
  String get waReachNote => 'Members who turned WhatsApp off, or never agreed to it, are skipped.';

  @override
  String get waSchedule => 'When';

  @override
  String get waScheduleNow => 'Now';

  @override
  String get waSchedulePick => 'Pick a day';

  @override
  String waScheduleOn(String date) {
    return '$date, 9:00 am';
  }

  @override
  String get waPreview => 'Preview';

  @override
  String get waPreviewEmpty => 'Your message shows here as members will see it.';

  @override
  String get waSampleName => 'Riya';

  @override
  String get waQueueBroadcast => 'Queue messages';

  @override
  String waQueueBroadcastN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Queue $count messages',
      one: 'Queue 1 message',
      zero: 'No one to send to',
    );
    return '$_temp0';
  }

  @override
  String waBroadcastQueued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages queued',
      one: '1 message queued',
      zero: 'No one to send to',
    );
    return '$_temp0';
  }

  @override
  String waBroadcastSkipped(int count) {
    return '$count skipped';
  }

  @override
  String waBroadcastDone(int queued, int skipped) {
    return '$queued queued · $skipped skipped';
  }

  @override
  String get waBroadcastsEmptyTitle => 'No broadcasts yet';

  @override
  String get waBroadcastsEmptyBody => 'Send one message to a group: new timings, a holiday, an offer.';

  @override
  String get waNeedTitle => 'Add a name';

  @override
  String get waNeedMessage => 'Write the message';

  @override
  String get waTemplatesTitle => 'Templates';

  @override
  String get waTemplatesEmptyTitle => 'No templates';

  @override
  String get waTemplatesEmptyBody => 'The automatic messages appear here once the database is set up.';

  @override
  String get waTemplateReadOnly => 'Only the owner can change templates.';

  @override
  String get waTemplateEnglish => 'English';

  @override
  String get waTemplateHindi => 'Hindi';

  @override
  String get waTemplateOff => 'Off';

  @override
  String get waTemplateUtility => 'Utility';

  @override
  String get waTemplateMarketing => 'Marketing';

  @override
  String get waTemplateTitle => 'Name';

  @override
  String get waTemplateText => 'Message';

  @override
  String get waTemplatePreview => 'Preview with a sample member';

  @override
  String get waTemplateEnabled => 'Send this message';

  @override
  String get waTemplateMetaName => 'Meta template name (API mode)';

  @override
  String get waTemplateMetaHelp =>
      'The approved template\'s name in WhatsApp Manager. Register it with this text (tap to copy):';

  @override
  String get waTemplateSaved => 'Template saved';

  @override
  String get waCopied => 'Copied';

  @override
  String get waFestivalsTitle => 'Festival calendar';

  @override
  String get waFestivalsNote =>
      'Wishes go out at 9:00 am on the day. Lunar festivals move every year: check the dates.';

  @override
  String get waFestivalAdd => 'Add festival';

  @override
  String get waFestivalName => 'Festival';

  @override
  String get waFestivalLocalName => 'Hindi name (for Hindi messages)';

  @override
  String get waFestivalDate => 'Date';

  @override
  String get waFestivalMessage => 'Own message (optional)';

  @override
  String get waFestivalMessageHelp => 'Leave empty to use the festival wishes template.';

  @override
  String get waFestivalOn => 'Send wishes';

  @override
  String get waFestivalMarketingNote =>
      'Festival wishes are marketing messages: a member who already got one that day is skipped.';

  @override
  String get waFestivalDelete => 'Remove festival';

  @override
  String get waFestivalSaved => 'Festival saved';

  @override
  String get waFestivalPast => 'Done';

  @override
  String waFestivalIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String get waFestivalsEmptyTitle => 'No festivals';

  @override
  String get waFestivalsEmptyBody => 'Add the festivals your members celebrate.';

  @override
  String get waSettingsTitle => 'WhatsApp settings';

  @override
  String get waModeTitle => 'How messages are sent';

  @override
  String get waModeFreeHelp =>
      'Free: each message opens in the gym\'s WhatsApp with the text ready, and staff tap send. Nothing to set up.';

  @override
  String get waModeApiHelp =>
      'API: approved templates go out automatically through Meta\'s WhatsApp Cloud API. Needs the API keys in Supabase (see the README). Anything the API can\'t send moves to the To send list.';

  @override
  String get waExpiryDays => 'Membership reminders';

  @override
  String get waOnTheDay => 'On the day';

  @override
  String waDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '$days days before', one: '1 day before');
    return '$_temp0';
  }

  @override
  String waDaysAfter(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '$days days after', one: '1 day after');
    return '$_temp0';
  }

  @override
  String get waAddDay => 'Add a day';

  @override
  String get waDayPrompt => 'Days before the end date (use a minus for after, e.g. -5)';

  @override
  String get waAutomations => 'Automatic messages';

  @override
  String get waAutoExpiry => 'Membership reminders';

  @override
  String get waAutoDues => 'Fee reminders with the pay link';

  @override
  String get waAutoBirthday => 'Birthday wishes';

  @override
  String get waAutoFestival => 'Festival wishes';

  @override
  String get waAutoPayment => 'Payment received';

  @override
  String get waAutoMembership => 'Welcome and renewal thanks';

  @override
  String get waAutoPlan => 'New workout and diet plans';

  @override
  String get waCostTitle => 'This month';

  @override
  String get waCostUtility => 'Utility (API)';

  @override
  String get waCostMarketing => 'Marketing (API)';

  @override
  String get waCostFree => 'Free in the 24-hour window';

  @override
  String get waCostLink => 'Sent by hand (free)';

  @override
  String waCostMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count messages', one: '1 message');
    return '$_temp0';
  }

  @override
  String get waCostTotal => 'Estimated spend';

  @override
  String get waCap => 'Monthly marketing cap';

  @override
  String get waCapHelp =>
      'Marketing messages pause for the rest of the month once their spend reaches this. 0 = no cap.';

  @override
  String get waCapPaused => 'Cap reached: marketing messages are paused until next month.';

  @override
  String waCapUsed(String used, String cap) {
    return '$used of $cap marketing cap used';
  }

  @override
  String get waPrices => 'Meta\'s price per message';

  @override
  String get waPriceUtility => 'Utility (₹)';

  @override
  String get waPriceMarketing => 'Marketing (₹)';

  @override
  String get waPricesHelp => 'Used only for the estimate. Check Meta\'s current prices for India.';

  @override
  String get waBadAmount => 'Enter an amount';

  @override
  String get waSaved => 'WhatsApp settings saved';

  @override
  String get waOptIn => 'WhatsApp messages';

  @override
  String get waOptInBody => 'Reminders, receipts and wishes from the gym';

  @override
  String get waOptedOut => 'Turned off: no WhatsApp messages from the gym.';

  @override
  String get waOptInDone => 'WhatsApp messages turned on';

  @override
  String get waOptOutDone => 'WhatsApp messages turned off';

  @override
  String waSendTo(String name) {
    return 'Send on WhatsApp to $name';
  }
}
