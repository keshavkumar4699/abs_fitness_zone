// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

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
}
