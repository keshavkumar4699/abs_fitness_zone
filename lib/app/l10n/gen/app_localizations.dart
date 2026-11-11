import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('hi')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ABS Fitness'**
  String get appName;

  /// No description provided for @gymName.
  ///
  /// In en, this message translates to:
  /// **'ABS Fitness Zone'**
  String get gymName;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get commonCopied;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @commonOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline, showing saved data'**
  String get commonOfflineBanner;

  /// No description provided for @commonGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonGenericError;

  /// No description provided for @commonNetworkError.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get commonNetworkError;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Train. Track. Transform.'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your membership, workouts and diet, all in one happy place.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'This build has no server configured. Sign-in is disabled; long-press the logo to open the component gallery.'**
  String get welcomeNotConfigured;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get fieldPhone;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldName;

  /// No description provided for @fieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get fieldRole;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmail;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit Indian mobile number'**
  String get validationPhone;

  /// No description provided for @authNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is not available in this build.'**
  String get authNotConfigured;

  /// No description provided for @authNoProfile.
  ///
  /// In en, this message translates to:
  /// **'This Google account isn\'t registered at the gym. Ask the front desk to add your Gmail to your profile, then try again.'**
  String get authNoProfile;

  /// No description provided for @onboardingTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Your membership, at a glance'**
  String get onboardingTrackTitle;

  /// No description provided for @onboardingTrackBody.
  ///
  /// In en, this message translates to:
  /// **'See days left, dues and your digital membership card anytime.'**
  String get onboardingTrackBody;

  /// No description provided for @onboardingWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow your workouts'**
  String get onboardingWorkoutTitle;

  /// No description provided for @onboardingWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Your trainer\'s plan, set by set, with a rest timer that keeps you moving.'**
  String get onboardingWorkoutBody;

  /// No description provided for @onboardingDietTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on track with your diet'**
  String get onboardingDietTitle;

  /// No description provided for @onboardingDietBody.
  ///
  /// In en, this message translates to:
  /// **'Meal-by-meal plans built around the food you actually eat.'**
  String get onboardingDietBody;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onboardingStart;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get navMembers;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get navPlans;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navWorkout;

  /// No description provided for @navDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get navDiet;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}!'**
  String greeting(String name);

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleFrontDesk.
  ///
  /// In en, this message translates to:
  /// **'Front desk'**
  String get roleFrontDesk;

  /// No description provided for @roleTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get roleTrainer;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get moreAppearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @moreStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get moreStaff;

  /// No description provided for @moreStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add and manage your team'**
  String get moreStaffSubtitle;

  /// No description provided for @moreGallery.
  ///
  /// In en, this message translates to:
  /// **'Component gallery'**
  String get moreGallery;

  /// No description provided for @moreGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every design-system component and state'**
  String get moreGallerySubtitle;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// No description provided for @staffSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get staffSearchHint;

  /// No description provided for @staffEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No staff yet'**
  String get staffEmptyTitle;

  /// No description provided for @staffEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your trainers and front desk by their Gmail so they can sign in.'**
  String get staffEmptyBody;

  /// No description provided for @staffInvite.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get staffInvite;

  /// No description provided for @staffInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a team member'**
  String get staffInviteTitle;

  /// No description provided for @staffInviteAction.
  ///
  /// In en, this message translates to:
  /// **'Add to team'**
  String get staffInviteAction;

  /// No description provided for @staffInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get staffInactive;

  /// No description provided for @commonNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that. It may have been removed.'**
  String get commonNotFound;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileMemberCode.
  ///
  /// In en, this message translates to:
  /// **'Member ID'**
  String get profileMemberCode;

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Component gallery'**
  String get galleryTitle;

  /// No description provided for @galleryTextScale.
  ///
  /// In en, this message translates to:
  /// **'Text 1.3×'**
  String get galleryTextScale;

  /// No description provided for @galleryButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get galleryButtons;

  /// No description provided for @galleryCards.
  ///
  /// In en, this message translates to:
  /// **'Cards and stats'**
  String get galleryCards;

  /// No description provided for @galleryPills.
  ///
  /// In en, this message translates to:
  /// **'Status pills'**
  String get galleryPills;

  /// No description provided for @galleryRings.
  ///
  /// In en, this message translates to:
  /// **'Progress rings'**
  String get galleryRings;

  /// No description provided for @galleryFields.
  ///
  /// In en, this message translates to:
  /// **'Text fields'**
  String get galleryFields;

  /// No description provided for @galleryTabs.
  ///
  /// In en, this message translates to:
  /// **'Segmented tabs'**
  String get galleryTabs;

  /// No description provided for @galleryTiles.
  ///
  /// In en, this message translates to:
  /// **'Member tiles'**
  String get galleryTiles;

  /// No description provided for @galleryStates.
  ///
  /// In en, this message translates to:
  /// **'Screen states'**
  String get galleryStates;

  /// No description provided for @galleryCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get galleryCharts;

  /// No description provided for @galleryFeedback.
  ///
  /// In en, this message translates to:
  /// **'Sheets and snackbars'**
  String get galleryFeedback;

  /// No description provided for @galleryPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get galleryPrimary;

  /// No description provided for @gallerySecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get gallerySecondary;

  /// No description provided for @galleryGhost.
  ///
  /// In en, this message translates to:
  /// **'Ghost'**
  String get galleryGhost;

  /// No description provided for @galleryDestructive.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get galleryDestructive;

  /// No description provided for @galleryLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get galleryLoading;

  /// No description provided for @gallerySuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get gallerySuccess;

  /// No description provided for @galleryOpenSheet.
  ///
  /// In en, this message translates to:
  /// **'Open bottom sheet'**
  String get galleryOpenSheet;

  /// No description provided for @galleryShowSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Show snackbar'**
  String get galleryShowSnackbar;

  /// No description provided for @gallerySnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'Reminder queued'**
  String get gallerySnackbarMessage;

  /// No description provided for @gallerySheetBody.
  ///
  /// In en, this message translates to:
  /// **'Quick actions open in sheets like this instead of new screens.'**
  String get gallerySheetBody;

  /// No description provided for @gallerySampleError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load members.'**
  String get gallerySampleError;

  /// No description provided for @galleryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No members match these filters.'**
  String get galleryEmptyBody;

  /// No description provided for @galleryEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get galleryEmptyAction;

  /// No description provided for @galleryDaysUsed.
  ///
  /// In en, this message translates to:
  /// **'Days used'**
  String get galleryDaysUsed;

  /// No description provided for @galleryWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get galleryWorkout;

  /// No description provided for @galleryMacros.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get galleryMacros;

  /// No description provided for @galleryDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get galleryDisabled;

  /// No description provided for @galleryStateLoading.
  ///
  /// In en, this message translates to:
  /// **'Screen states · loading'**
  String get galleryStateLoading;

  /// No description provided for @galleryStateEmpty.
  ///
  /// In en, this message translates to:
  /// **'Screen states · empty'**
  String get galleryStateEmpty;

  /// No description provided for @galleryStateError.
  ///
  /// In en, this message translates to:
  /// **'Screen states · error'**
  String get galleryStateError;

  /// No description provided for @fieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmount;

  /// No description provided for @statActiveMembers.
  ///
  /// In en, this message translates to:
  /// **'Active members'**
  String get statActiveMembers;

  /// No description provided for @statTodayCollections.
  ///
  /// In en, this message translates to:
  /// **'Collected today'**
  String get statTodayCollections;

  /// No description provided for @statCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-ins'**
  String get statCheckIns;

  /// No description provided for @chartRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get chartRevenue;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusExpiring.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Expires today} =1{Expiring · 1 day} other{Expiring · {days} days}}'**
  String statusExpiring(int days);

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @statusFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get statusFrozen;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get statusPartial;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get statusLead;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day left} other{{days} days left}}'**
  String daysLeft(int days);

  /// No description provided for @swipeCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get swipeCollect;

  /// No description provided for @swipeRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get swipeRemind;

  /// No description provided for @period7d.
  ///
  /// In en, this message translates to:
  /// **'7D'**
  String get period7d;

  /// No description provided for @period30d.
  ///
  /// In en, this message translates to:
  /// **'30D'**
  String get period30d;

  /// No description provided for @period3m.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get period3m;

  /// No description provided for @period12m.
  ///
  /// In en, this message translates to:
  /// **'12M'**
  String get period12m;

  /// No description provided for @fabNewMember.
  ///
  /// In en, this message translates to:
  /// **'New member'**
  String get fabNewMember;

  /// No description provided for @fabCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get fabCollect;

  /// No description provided for @fabCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get fabCheckIn;

  /// No description provided for @fabEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Enquiry'**
  String get fabEnquiry;

  /// No description provided for @fabOpen.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get fabOpen;

  /// No description provided for @searchMembersHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, phone or ID'**
  String get searchMembersHint;

  /// No description provided for @commonNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do that.'**
  String get commonNotAllowed;

  /// No description provided for @authStaffDeactivated.
  ///
  /// In en, this message translates to:
  /// **'This staff account has been turned off. Please speak to the gym owner.'**
  String get authStaffDeactivated;

  /// No description provided for @authRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a minute and try again.'**
  String get authRateLimited;

  /// No description provided for @authBackendError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect to the gym server. Check the app\'s Supabase URL and key.'**
  String get authBackendError;

  /// No description provided for @staffInviteEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This Gmail is already on the team.'**
  String get staffInviteEmailTaken;

  /// No description provided for @welcomeTitle1.
  ///
  /// In en, this message translates to:
  /// **'Train.'**
  String get welcomeTitle1;

  /// No description provided for @welcomeTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track.'**
  String get welcomeTitle2;

  /// No description provided for @welcomeTitle3.
  ///
  /// In en, this message translates to:
  /// **'Transform.'**
  String get welcomeTitle3;

  /// No description provided for @welcomeChipWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get welcomeChipWorkouts;

  /// No description provided for @welcomeChipDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get welcomeChipDiet;

  /// No description provided for @welcomeChipProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get welcomeChipProgress;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Lost your way?'**
  String get notFoundTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In en, this message translates to:
  /// **'That page doesn\'t exist. Let\'s get you back home.'**
  String get notFoundBody;

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// No description provided for @homeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get homeGetStarted;

  /// No description provided for @homeStepInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite your team'**
  String get homeStepInvite;

  /// No description provided for @homeStepInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Add front desk and trainers so they can sign in.'**
  String get homeStepInviteBody;

  /// No description provided for @homeStepPin.
  ///
  /// In en, this message translates to:
  /// **'Give members app access'**
  String get homeStepPin;

  /// No description provided for @homeStepPinBody.
  ///
  /// In en, this message translates to:
  /// **'Set a 4-digit PIN for each member at the desk.'**
  String get homeStepPinBody;

  /// No description provided for @homeStepLook.
  ///
  /// In en, this message translates to:
  /// **'Make it yours'**
  String get homeStepLook;

  /// No description provided for @homeStepLookBody.
  ///
  /// In en, this message translates to:
  /// **'Pick light, dark or follow the phone.'**
  String get homeStepLookBody;

  /// No description provided for @homeComingTitle.
  ///
  /// In en, this message translates to:
  /// **'More muscle on the way'**
  String get homeComingTitle;

  /// No description provided for @homeComingBody.
  ///
  /// In en, this message translates to:
  /// **'Members, payments, plans and reports arrive in the next updates.'**
  String get homeComingBody;

  /// No description provided for @homeTrainerBody.
  ///
  /// In en, this message translates to:
  /// **'Your assigned members, sessions and plans will show up here.'**
  String get homeTrainerBody;

  /// No description provided for @memberCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Member card'**
  String get memberCardTitle;

  /// No description provided for @staffManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get staffManage;

  /// No description provided for @staffDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Turn off access'**
  String get staffDeactivate;

  /// No description provided for @staffReactivate.
  ///
  /// In en, this message translates to:
  /// **'Turn access back on'**
  String get staffReactivate;

  /// No description provided for @staffDeactivated.
  ///
  /// In en, this message translates to:
  /// **'{name} can no longer sign in.'**
  String staffDeactivated(String name);

  /// No description provided for @staffReactivated.
  ///
  /// In en, this message translates to:
  /// **'{name} can sign in again.'**
  String staffReactivated(String name);

  /// No description provided for @staffOwnerLocked.
  ///
  /// In en, this message translates to:
  /// **'The owner account is always on.'**
  String get staffOwnerLocked;

  /// No description provided for @staffYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get staffYou;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get goHome;

  /// No description provided for @memberDuplicatePhone.
  ///
  /// In en, this message translates to:
  /// **'Another member already uses this phone number.'**
  String get memberDuplicatePhone;

  /// No description provided for @membersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTitle;

  /// No description provided for @membersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, phone or ID'**
  String get membersSearchHint;

  /// No description provided for @membersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get membersEmptyTitle;

  /// No description provided for @membersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first member or import your existing list.'**
  String get membersEmptyBody;

  /// No description provided for @membersNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get membersNoMatchTitle;

  /// No description provided for @membersNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'No members match this search or these filters.'**
  String get membersNoMatchBody;

  /// No description provided for @membersClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get membersClearFilters;

  /// No description provided for @membersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get membersAdd;

  /// No description provided for @membersImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get membersImport;

  /// No description provided for @membersExport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get membersExport;

  /// No description provided for @membersFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get membersFilters;

  /// No description provided for @membersSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get membersSort;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortEndDate.
  ///
  /// In en, this message translates to:
  /// **'Ending soonest'**
  String get sortEndDate;

  /// No description provided for @sortJoined.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortJoined;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @filterPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get filterPlan;

  /// No description provided for @filterTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get filterTrainer;

  /// No description provided for @filterBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get filterBatch;

  /// No description provided for @filterGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get filterGender;

  /// No description provided for @filterBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday this month'**
  String get filterBirthday;

  /// No description provided for @filterJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined between'**
  String get filterJoined;

  /// No description provided for @filterArchived.
  ///
  /// In en, this message translates to:
  /// **'Show archived'**
  String get filterArchived;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get filterApply;

  /// No description provided for @filterSave.
  ///
  /// In en, this message translates to:
  /// **'Save filter'**
  String get filterSave;

  /// No description provided for @filterSaveName.
  ///
  /// In en, this message translates to:
  /// **'Filter name'**
  String get filterSaveName;

  /// No description provided for @filterSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved filters'**
  String get filterSaved;

  /// No description provided for @filterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @filterFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get filterFrom;

  /// No description provided for @filterTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get filterTo;

  /// No description provided for @batchMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get batchMorning;

  /// No description provided for @batchEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get batchEvening;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @bulkAssignTrainer.
  ///
  /// In en, this message translates to:
  /// **'Assign trainer'**
  String get bulkAssignTrainer;

  /// No description provided for @bulkExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get bulkExport;

  /// No description provided for @bulkNoTrainer.
  ///
  /// In en, this message translates to:
  /// **'No trainer'**
  String get bulkNoTrainer;

  /// No description provided for @remindWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remindWhatsApp;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Starts soon'**
  String get statusUpcoming;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @noPlan.
  ///
  /// In en, this message translates to:
  /// **'No plan'**
  String get noPlan;

  /// No description provided for @addMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'New member'**
  String get addMemberTitle;

  /// No description provided for @stepBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get stepBasics;

  /// No description provided for @stepHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get stepHealth;

  /// No description provided for @stepMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get stepMembership;

  /// No description provided for @fieldAltPhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate phone'**
  String get fieldAltPhone;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get fieldGender;

  /// No description provided for @fieldDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get fieldDob;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @fieldEmergencyName.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact name'**
  String get fieldEmergencyName;

  /// No description provided for @fieldEmergencyRelation.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get fieldEmergencyRelation;

  /// No description provided for @fieldEmergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency phone'**
  String get fieldEmergencyPhone;

  /// No description provided for @fieldBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get fieldBloodGroup;

  /// No description provided for @fieldBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get fieldBatch;

  /// No description provided for @fieldTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get fieldTrainer;

  /// No description provided for @fieldSource.
  ///
  /// In en, this message translates to:
  /// **'How did they hear about us?'**
  String get fieldSource;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get fieldPhoto;

  /// No description provided for @fieldPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get fieldPhotoAdd;

  /// No description provided for @fieldPhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get fieldPhotoChange;

  /// No description provided for @fieldHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get fieldHeight;

  /// No description provided for @fieldWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get fieldWeight;

  /// No description provided for @fieldGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get fieldGoal;

  /// No description provided for @fieldLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get fieldLevel;

  /// No description provided for @fieldConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical conditions'**
  String get fieldConditions;

  /// No description provided for @fieldInjuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries'**
  String get fieldInjuries;

  /// No description provided for @fieldMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get fieldMedications;

  /// No description provided for @fieldDoctorClearance.
  ///
  /// In en, this message translates to:
  /// **'A doctor has cleared them for exercise'**
  String get fieldDoctorClearance;

  /// No description provided for @fieldConsentHealth.
  ///
  /// In en, this message translates to:
  /// **'Member agrees to share health details with the gym'**
  String get fieldConsentHealth;

  /// No description provided for @fieldConsentWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Member agrees to receive WhatsApp updates'**
  String get fieldConsentWhatsapp;

  /// No description provided for @goalFatLoss.
  ///
  /// In en, this message translates to:
  /// **'Fat loss'**
  String get goalFatLoss;

  /// No description provided for @goalMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get goalMuscleGain;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get goalStrength;

  /// No description provided for @goalGeneral.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get goalGeneral;

  /// No description provided for @goalRehab.
  ///
  /// In en, this message translates to:
  /// **'Rehab'**
  String get goalRehab;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @parqTitle.
  ///
  /// In en, this message translates to:
  /// **'Health questions'**
  String get parqTitle;

  /// No description provided for @parqHeart.
  ///
  /// In en, this message translates to:
  /// **'Has a doctor ever said they have a heart condition?'**
  String get parqHeart;

  /// No description provided for @parqChestPain.
  ///
  /// In en, this message translates to:
  /// **'Do they feel chest pain during physical activity?'**
  String get parqChestPain;

  /// No description provided for @parqDizzy.
  ///
  /// In en, this message translates to:
  /// **'Do they lose balance from dizziness, or ever faint?'**
  String get parqDizzy;

  /// No description provided for @parqBone.
  ///
  /// In en, this message translates to:
  /// **'Do they have a bone or joint problem that exercise could make worse?'**
  String get parqBone;

  /// No description provided for @parqBp.
  ///
  /// In en, this message translates to:
  /// **'Are they taking medicine for blood pressure or the heart?'**
  String get parqBp;

  /// No description provided for @parqPregnant.
  ///
  /// In en, this message translates to:
  /// **'Are they pregnant, or did they give birth in the last 6 months?'**
  String get parqPregnant;

  /// No description provided for @parqOther.
  ///
  /// In en, this message translates to:
  /// **'Is there any other reason they should not exercise?'**
  String get parqOther;

  /// No description provided for @parqWarning.
  ///
  /// In en, this message translates to:
  /// **'Answered yes: ask for a doctor\'s clearance before training.'**
  String get parqWarning;

  /// No description provided for @planSelect.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get planSelect;

  /// No description provided for @planNone.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get planNone;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @startToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get startToday;

  /// No description provided for @addonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get addonsTitle;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount (₹)'**
  String get discount;

  /// No description provided for @discountReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for discount'**
  String get discountReason;

  /// No description provided for @summaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get summaryTotal;

  /// No description provided for @summaryJoiningFee.
  ///
  /// In en, this message translates to:
  /// **'Joining fee'**
  String get summaryJoiningFee;

  /// No description provided for @summaryPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get summaryPlan;

  /// No description provided for @summaryAddons.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get summaryAddons;

  /// No description provided for @summaryDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get summaryDiscount;

  /// No description provided for @saveMember.
  ///
  /// In en, this message translates to:
  /// **'Save member'**
  String get saveMember;

  /// No description provided for @draftRestored.
  ///
  /// In en, this message translates to:
  /// **'We kept your unsaved draft.'**
  String get draftRestored;

  /// No description provided for @discardDraft.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get discardDraft;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @paymentNote.
  ///
  /// In en, this message translates to:
  /// **'An invoice is created for this plan. Collect now or later from Payments.'**
  String get paymentNote;

  /// No description provided for @consentRequired.
  ///
  /// In en, this message translates to:
  /// **'Tick the consent box to save health details.'**
  String get consentRequired;

  /// No description provided for @discountNeedsReason.
  ///
  /// In en, this message translates to:
  /// **'Add a reason for the discount.'**
  String get discountNeedsReason;

  /// No description provided for @discountTooBig.
  ///
  /// In en, this message translates to:
  /// **'Discount can\'t be more than the total.'**
  String get discountTooBig;

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get tabMembership;

  /// No description provided for @tabPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get tabPayments;

  /// No description provided for @tabWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get tabWorkouts;

  /// No description provided for @tabDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get tabDiet;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @tabAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get tabAttendance;

  /// No description provided for @tabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabNotes;

  /// No description provided for @actionCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get actionCollect;

  /// No description provided for @actionRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get actionRenew;

  /// No description provided for @actionWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get actionWhatsApp;

  /// No description provided for @actionCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get actionCall;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get actionEdit;

  /// No description provided for @actionArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get actionArchive;

  /// No description provided for @actionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get actionDelete;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get actionMore;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Only do this when the member asks in writing. Type their name to confirm.'**
  String get deleteConfirmBody;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Member deleted'**
  String get deleted;

  /// No description provided for @archivedDone.
  ///
  /// In en, this message translates to:
  /// **'Member archived'**
  String get archivedDone;

  /// No description provided for @restoredDone.
  ///
  /// In en, this message translates to:
  /// **'Member restored'**
  String get restoredDone;

  /// No description provided for @infoPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get infoPhone;

  /// No description provided for @infoEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get infoEmail;

  /// No description provided for @infoDob.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get infoDob;

  /// No description provided for @infoAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get infoAddress;

  /// No description provided for @infoEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get infoEmergency;

  /// No description provided for @infoBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get infoBatch;

  /// No description provided for @infoTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get infoTrainer;

  /// No description provided for @infoJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get infoJoined;

  /// No description provided for @infoSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get infoSource;

  /// No description provided for @infoBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get infoBlood;

  /// No description provided for @healthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthTitle;

  /// No description provided for @healthNone.
  ///
  /// In en, this message translates to:
  /// **'No health details yet.'**
  String get healthNone;

  /// No description provided for @healthPrivate.
  ///
  /// In en, this message translates to:
  /// **'Health details are visible only to the owner, the member and their trainer.'**
  String get healthPrivate;

  /// No description provided for @membershipCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current membership'**
  String get membershipCurrent;

  /// No description provided for @membershipHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get membershipHistory;

  /// No description provided for @membershipNone.
  ///
  /// In en, this message translates to:
  /// **'No membership yet'**
  String get membershipNone;

  /// No description provided for @membershipStart.
  ///
  /// In en, this message translates to:
  /// **'Start membership'**
  String get membershipStart;

  /// No description provided for @freeze.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get freeze;

  /// No description provided for @unfreeze.
  ///
  /// In en, this message translates to:
  /// **'Unfreeze'**
  String get unfreeze;

  /// No description provided for @cancelMembership.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelMembership;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @freezeTitle.
  ///
  /// In en, this message translates to:
  /// **'Freeze membership'**
  String get freezeTitle;

  /// No description provided for @freezeDays.
  ///
  /// In en, this message translates to:
  /// **'Number of days'**
  String get freezeDays;

  /// No description provided for @freezeFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get freezeFrom;

  /// No description provided for @freezeReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get freezeReason;

  /// No description provided for @unfreezeDone.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Membership unfrozen.'**
  String get unfreezeDone;

  /// No description provided for @renewTitle.
  ///
  /// In en, this message translates to:
  /// **'Renew membership'**
  String get renewTitle;

  /// No description provided for @renewSamePlan.
  ///
  /// In en, this message translates to:
  /// **'Same plan'**
  String get renewSamePlan;

  /// No description provided for @cancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this membership?'**
  String get cancelTitle;

  /// No description provided for @cancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get cancelReason;

  /// No description provided for @refundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund given (₹)'**
  String get refundAmount;

  /// No description provided for @cancelDone.
  ///
  /// In en, this message translates to:
  /// **'Membership cancelled'**
  String get cancelDone;

  /// No description provided for @transferTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer remaining days'**
  String get transferTitle;

  /// No description provided for @transferPick.
  ///
  /// In en, this message translates to:
  /// **'Who gets the days?'**
  String get transferPick;

  /// No description provided for @transferDone.
  ///
  /// In en, this message translates to:
  /// **'Days transferred'**
  String get transferDone;

  /// No description provided for @progressAdd.
  ///
  /// In en, this message translates to:
  /// **'Add measurement'**
  String get progressAdd;

  /// No description provided for @progressEmpty.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet'**
  String get progressEmpty;

  /// No description provided for @weightTrend.
  ///
  /// In en, this message translates to:
  /// **'Weight trend (kg)'**
  String get weightTrend;

  /// No description provided for @measurementSaved.
  ///
  /// In en, this message translates to:
  /// **'Measurement saved'**
  String get measurementSaved;

  /// No description provided for @fieldBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get fieldBodyFat;

  /// No description provided for @fieldChest.
  ///
  /// In en, this message translates to:
  /// **'Chest (cm)'**
  String get fieldChest;

  /// No description provided for @fieldWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist (cm)'**
  String get fieldWaist;

  /// No description provided for @fieldHips.
  ///
  /// In en, this message translates to:
  /// **'Hips (cm)'**
  String get fieldHips;

  /// No description provided for @fieldArms.
  ///
  /// In en, this message translates to:
  /// **'Arms (cm)'**
  String get fieldArms;

  /// No description provided for @fieldThighs.
  ///
  /// In en, this message translates to:
  /// **'Thighs (cm)'**
  String get fieldThighs;

  /// No description provided for @fieldMeasuredOn.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldMeasuredOn;

  /// No description provided for @attendanceMark.
  ///
  /// In en, this message translates to:
  /// **'Mark present today'**
  String get attendanceMark;

  /// No description provided for @attendanceMarked.
  ///
  /// In en, this message translates to:
  /// **'Marked present'**
  String get attendanceMarked;

  /// No description provided for @attendanceAlready.
  ///
  /// In en, this message translates to:
  /// **'Already checked in today'**
  String get attendanceAlready;

  /// No description provided for @attendanceLast12.
  ///
  /// In en, this message translates to:
  /// **'Last 12 weeks'**
  String get attendanceLast12;

  /// No description provided for @attendanceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No visits yet'**
  String get attendanceEmpty;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note…'**
  String get notesHint;

  /// No description provided for @notesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get notesAdd;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get notesEmpty;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickDate;

  /// No description provided for @dateNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get dateNotSet;

  /// No description provided for @plansTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership plans'**
  String get plansTitle;

  /// No description provided for @plansTab.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plansTab;

  /// No description provided for @addonsTab.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get addonsTab;

  /// No description provided for @planNew.
  ///
  /// In en, this message translates to:
  /// **'New plan'**
  String get planNew;

  /// No description provided for @addonNew.
  ///
  /// In en, this message translates to:
  /// **'New add-on'**
  String get addonNew;

  /// No description provided for @planName.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get planName;

  /// No description provided for @planDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get planDuration;

  /// No description provided for @unitMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get unitMonths;

  /// No description provided for @unitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get unitDays;

  /// No description provided for @planPrice.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get planPrice;

  /// No description provided for @planJoiningFee.
  ///
  /// In en, this message translates to:
  /// **'Joining fee (₹)'**
  String get planJoiningFee;

  /// No description provided for @planGst.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get planGst;

  /// No description provided for @planFreeze.
  ///
  /// In en, this message translates to:
  /// **'Freeze days allowed'**
  String get planFreeze;

  /// No description provided for @planIncludesPt.
  ///
  /// In en, this message translates to:
  /// **'Includes personal training'**
  String get planIncludesPt;

  /// No description provided for @planColor.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get planColor;

  /// No description provided for @planArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get planArchived;

  /// No description provided for @planArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get planArchive;

  /// No description provided for @planUnarchive.
  ///
  /// In en, this message translates to:
  /// **'Bring back'**
  String get planUnarchive;

  /// No description provided for @plansEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No plans yet'**
  String get plansEmptyTitle;

  /// No description provided for @plansEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create your first membership plan so members can join.'**
  String get plansEmptyBody;

  /// No description provided for @addonsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No add-ons yet'**
  String get addonsEmpty;

  /// No description provided for @addonName.
  ///
  /// In en, this message translates to:
  /// **'Add-on name'**
  String get addonName;

  /// No description provided for @addonPrice.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get addonPrice;

  /// No description provided for @addonKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get addonKind;

  /// No description provided for @kindPt.
  ///
  /// In en, this message translates to:
  /// **'Personal training'**
  String get kindPt;

  /// No description provided for @kindLocker.
  ///
  /// In en, this message translates to:
  /// **'Locker'**
  String get kindLocker;

  /// No description provided for @kindDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet consultation'**
  String get kindDiet;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kindOther;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @morePlans.
  ///
  /// In en, this message translates to:
  /// **'Membership plans'**
  String get morePlans;

  /// No description provided for @morePlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plans, prices and add-ons'**
  String get morePlansSubtitle;

  /// No description provided for @moreGymQr.
  ///
  /// In en, this message translates to:
  /// **'Check-in QR'**
  String get moreGymQr;

  /// No description provided for @moreGymQrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show today\'s code for member self check-in'**
  String get moreGymQrSubtitle;

  /// No description provided for @moreGymProfile.
  ///
  /// In en, this message translates to:
  /// **'Gym profile'**
  String get moreGymProfile;

  /// No description provided for @moreGymProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, address, UPI ID and rules'**
  String get moreGymProfileSubtitle;

  /// No description provided for @moreImport.
  ///
  /// In en, this message translates to:
  /// **'Import members'**
  String get moreImport;

  /// No description provided for @moreImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring in your existing list from a spreadsheet'**
  String get moreImportSubtitle;

  /// No description provided for @noGst.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noGst;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInTitle;

  /// No description provided for @checkInSearch.
  ///
  /// In en, this message translates to:
  /// **'Search member to check in'**
  String get checkInSearch;

  /// No description provided for @checkInScanHint.
  ///
  /// In en, this message translates to:
  /// **'Point at the member\'s QR code'**
  String get checkInScanHint;

  /// No description provided for @checkInAlready.
  ///
  /// In en, this message translates to:
  /// **'Already checked in today'**
  String get checkInAlready;

  /// No description provided for @checkInWarnExpired.
  ///
  /// In en, this message translates to:
  /// **'Membership expired'**
  String get checkInWarnExpired;

  /// No description provided for @checkInWarnInactive.
  ///
  /// In en, this message translates to:
  /// **'No active membership'**
  String get checkInWarnInactive;

  /// No description provided for @checkInWarnFrozen.
  ///
  /// In en, this message translates to:
  /// **'Membership is frozen'**
  String get checkInWarnFrozen;

  /// No description provided for @checkInWarnCancelled.
  ///
  /// In en, this message translates to:
  /// **'Membership cancelled'**
  String get checkInWarnCancelled;

  /// No description provided for @checkInOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get checkInOk;

  /// No description provided for @checkInCameraOff.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable. Search by name instead.'**
  String get checkInCameraOff;

  /// No description provided for @checkInUnknownCode.
  ///
  /// In en, this message translates to:
  /// **'That QR code isn\'t an ABS Fitness member card.'**
  String get checkInUnknownCode;

  /// No description provided for @gymQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in code'**
  String get gymQrTitle;

  /// No description provided for @gymQrBody.
  ///
  /// In en, this message translates to:
  /// **'Members scan this with the ABS Fitness app to check in. It changes every day.'**
  String get gymQrBody;

  /// No description provided for @memberCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get memberCheckIn;

  /// No description provided for @memberCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the gym code'**
  String get memberCheckInTitle;

  /// No description provided for @memberCheckInHint.
  ///
  /// In en, this message translates to:
  /// **'Point at the QR code at the front desk.'**
  String get memberCheckInHint;

  /// No description provided for @memberQrTitle.
  ///
  /// In en, this message translates to:
  /// **'My check-in code'**
  String get memberQrTitle;

  /// No description provided for @memberQrBody.
  ///
  /// In en, this message translates to:
  /// **'Show this at the front desk to check in.'**
  String get memberQrBody;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import members'**
  String get importTitle;

  /// No description provided for @importPick.
  ///
  /// In en, this message translates to:
  /// **'Choose a CSV file'**
  String get importPick;

  /// No description provided for @importPickBody.
  ///
  /// In en, this message translates to:
  /// **'Save your existing sheet as CSV (File → Download → CSV), then pick it here. The first row should have the column names.'**
  String get importPickBody;

  /// No description provided for @importMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Match your columns'**
  String get importMapTitle;

  /// No description provided for @importNotMapped.
  ///
  /// In en, this message translates to:
  /// **'Not in file'**
  String get importNotMapped;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get importPreview;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Import finished'**
  String get importDone;

  /// No description provided for @importShareReport.
  ///
  /// In en, this message translates to:
  /// **'Share error report'**
  String get importShareReport;

  /// No description provided for @importAnother.
  ///
  /// In en, this message translates to:
  /// **'Import another file'**
  String get importAnother;

  /// No description provided for @importFileError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read that file. Make sure it\'s a CSV.'**
  String get importFileError;

  /// No description provided for @importNeedNamePhone.
  ///
  /// In en, this message translates to:
  /// **'Pick the name and phone columns to continue.'**
  String get importNeedNamePhone;

  /// No description provided for @importRequired.
  ///
  /// In en, this message translates to:
  /// **'required'**
  String get importRequired;

  /// No description provided for @gymProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Gym profile'**
  String get gymProfileTitle;

  /// No description provided for @fieldGymName.
  ///
  /// In en, this message translates to:
  /// **'Gym name'**
  String get fieldGymName;

  /// No description provided for @fieldGymPhone.
  ///
  /// In en, this message translates to:
  /// **'Gym phone'**
  String get fieldGymPhone;

  /// No description provided for @fieldGymAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldGymAddress;

  /// No description provided for @fieldUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get fieldUpi;

  /// No description provided for @fieldGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN (optional)'**
  String get fieldGstin;

  /// No description provided for @fieldExpiringWindow.
  ///
  /// In en, this message translates to:
  /// **'Warn this many days before a plan ends'**
  String get fieldExpiringWindow;

  /// No description provided for @fieldAbsentDays.
  ///
  /// In en, this message translates to:
  /// **'Flag members absent for this many days'**
  String get fieldAbsentDays;

  /// No description provided for @fieldLapsedRenew.
  ///
  /// In en, this message translates to:
  /// **'When a lapsed member renews, start from'**
  String get fieldLapsedRenew;

  /// No description provided for @lapsedToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get lapsedToday;

  /// No description provided for @lapsedEnd.
  ///
  /// In en, this message translates to:
  /// **'Day after old end'**
  String get lapsedEnd;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @dashActive.
  ///
  /// In en, this message translates to:
  /// **'Active members'**
  String get dashActive;

  /// No description provided for @dashExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get dashExpiring;

  /// No description provided for @dashCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-ins'**
  String get dashCheckIns;

  /// No description provided for @dashNew.
  ///
  /// In en, this message translates to:
  /// **'New this month'**
  String get dashNew;

  /// No description provided for @dashNeedsAction.
  ///
  /// In en, this message translates to:
  /// **'Needs action today'**
  String get dashNeedsAction;

  /// No description provided for @dashAllClear.
  ///
  /// In en, this message translates to:
  /// **'All clear! Nothing needs you right now.'**
  String get dashAllClear;

  /// No description provided for @dashLiveFeed.
  ///
  /// In en, this message translates to:
  /// **'Live check-ins'**
  String get dashLiveFeed;

  /// No description provided for @dashNoCheckIns.
  ///
  /// In en, this message translates to:
  /// **'No check-ins yet today'**
  String get dashNoCheckIns;

  /// No description provided for @reasonBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday today'**
  String get reasonBirthday;

  /// No description provided for @reasonAbsent.
  ///
  /// In en, this message translates to:
  /// **'Not seen for a while'**
  String get reasonAbsent;

  /// No description provided for @dashSetupPlans.
  ///
  /// In en, this message translates to:
  /// **'Create membership plans'**
  String get dashSetupPlans;

  /// No description provided for @dashSetupPlansBody.
  ///
  /// In en, this message translates to:
  /// **'Plans and prices members can join.'**
  String get dashSetupPlansBody;

  /// No description provided for @dashSetupGym.
  ///
  /// In en, this message translates to:
  /// **'Fill in your gym profile'**
  String get dashSetupGym;

  /// No description provided for @dashSetupGymBody.
  ///
  /// In en, this message translates to:
  /// **'Name, address and UPI ID for receipts and links.'**
  String get dashSetupGymBody;

  /// No description provided for @myProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get myProgressTitle;

  /// No description provided for @myProgressEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your trainer will record your measurements here.'**
  String get myProgressEmpty;

  /// No description provided for @myVisitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visits this month'**
  String get myVisitsTitle;

  /// No description provided for @membersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String membersSelected(int count);

  /// No description provided for @bulkTrainerAssigned.
  ///
  /// In en, this message translates to:
  /// **'Trainer updated for {count, plural, =1{1 member} other{{count} members}}'**
  String bulkTrainerAssigned(int count);

  /// No description provided for @exportReady.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member exported} other{{count} members exported}}'**
  String exportReady(int count);

  /// No description provided for @whatsappReminderText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, your {plan} membership at {gym} ends on {date}. Renew at the front desk to keep going!'**
  String whatsappReminderText(String name, String plan, String gym, String date);

  /// No description provided for @whatsappExpiredText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, we miss you at {gym}! Your membership ended on {date}. Come back and renew any time.'**
  String whatsappExpiredText(String name, String gym, String date);

  /// No description provided for @whatsappBirthdayText.
  ///
  /// In en, this message translates to:
  /// **'Happy birthday {name}! Wishing you a strong year ahead from all of us at {gym}.'**
  String whatsappBirthdayText(String name, String gym);

  /// No description provided for @whatsappAbsentText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, we haven\'t seen you at {gym} for a few days. Everything okay? Your next workout is waiting!'**
  String whatsappAbsentText(String name, String gym);

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {count} of 3'**
  String stepOf(int count);

  /// No description provided for @endsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String endsOn(String date);

  /// No description provided for @startsOn.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String startsOn(String date);

  /// No description provided for @memberSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String memberSaved(String name);

  /// No description provided for @duplicateWarning.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate: {name} ({code})'**
  String duplicateWarning(String name, String code);

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name} forever?'**
  String deleteConfirmTitle(String name);

  /// No description provided for @freezeLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No freeze days left on this plan} =1{1 freeze day left on this plan} other{{count} freeze days left on this plan}}'**
  String freezeLeft(int count);

  /// No description provided for @freezeDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Frozen for 1 day} other{Frozen for {count} days}}'**
  String freezeDone(int count);

  /// No description provided for @renewDone.
  ///
  /// In en, this message translates to:
  /// **'Renewed until {date}'**
  String renewDone(String date);

  /// No description provided for @attendanceVisits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No visits} =1{1 visit} other{{count} visits}}'**
  String attendanceVisits(int count);

  /// No description provided for @planActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No active members} =1{1 active member} other{{count} active members}}'**
  String planActive(int count);

  /// No description provided for @planDurationMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String planDurationMonths(int count);

  /// No description provided for @planDurationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String planDurationDays(int count);

  /// No description provided for @planFreezeDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No freezes} =1{1 freeze day} other{{count} freeze days}}'**
  String planFreezeDays(int count);

  /// No description provided for @checkInWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String checkInWelcome(String name);

  /// No description provided for @checkInDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Last day today} =1{1 day left} other{{count} days left}}'**
  String checkInDaysLeft(int count);

  /// No description provided for @importReady.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 row ready to import} other{{count} rows ready to import}}'**
  String importReady(int count);

  /// No description provided for @importProblems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 row has problems} other{{count} rows have problems}}'**
  String importProblems(int count);

  /// No description provided for @importStart.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 member} other{Import {count} members}}'**
  String importStart(int count);

  /// No description provided for @importRunning.
  ///
  /// In en, this message translates to:
  /// **'Importing… {done} of {total}'**
  String importRunning(int done, int total);

  /// No description provided for @importImported.
  ///
  /// In en, this message translates to:
  /// **'{count} imported'**
  String importImported(int count);

  /// No description provided for @importDuplicates.
  ///
  /// In en, this message translates to:
  /// **'{count} duplicates skipped'**
  String importDuplicates(int count);

  /// No description provided for @importErrors.
  ///
  /// In en, this message translates to:
  /// **'{count} not imported'**
  String importErrors(int count);

  /// No description provided for @reasonRenewal.
  ///
  /// In en, this message translates to:
  /// **'Renewal due {date}'**
  String reasonRenewal(String date);

  /// No description provided for @reasonExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired {date}'**
  String reasonExpired(String date);

  /// No description provided for @reasonAbsentSince.
  ///
  /// In en, this message translates to:
  /// **'Last visit {date}'**
  String reasonAbsentSince(String date);

  /// No description provided for @visitedAt.
  ///
  /// In en, this message translates to:
  /// **'Checked in {time}'**
  String visitedAt(String time);

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysShort;

  /// No description provided for @payTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payTitle;

  /// No description provided for @paySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, invoice or receipt'**
  String get paySearchHint;

  /// No description provided for @payCollectedToday.
  ///
  /// In en, this message translates to:
  /// **'Collected today'**
  String get payCollectedToday;

  /// No description provided for @payMyCollections.
  ///
  /// In en, this message translates to:
  /// **'Your collections today'**
  String get payMyCollections;

  /// No description provided for @payPaymentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No payments yet} =1{1 payment} other{{count} payments}}'**
  String payPaymentsCount(int count);

  /// No description provided for @payDayClosed.
  ///
  /// In en, this message translates to:
  /// **'Day closed'**
  String get payDayClosed;

  /// No description provided for @payCloseDay.
  ///
  /// In en, this message translates to:
  /// **'Close day'**
  String get payCloseDay;

  /// No description provided for @payTabDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get payTabDue;

  /// No description provided for @payTabOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get payTabOverdue;

  /// No description provided for @payTabPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payTabPaid;

  /// No description provided for @payTabPending.
  ///
  /// In en, this message translates to:
  /// **'To verify'**
  String get payTabPending;

  /// No description provided for @payEmptyDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing due'**
  String get payEmptyDueTitle;

  /// No description provided for @payEmptyDueBody.
  ///
  /// In en, this message translates to:
  /// **'No open invoices right now.'**
  String get payEmptyDueBody;

  /// No description provided for @payEmptyOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'No overdue fees'**
  String get payEmptyOverdueTitle;

  /// No description provided for @payEmptyOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone is paid up. High five!'**
  String get payEmptyOverdueBody;

  /// No description provided for @payEmptyPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'No paid invoices yet'**
  String get payEmptyPaidTitle;

  /// No description provided for @payEmptyPaidBody.
  ///
  /// In en, this message translates to:
  /// **'Paid invoices show up here.'**
  String get payEmptyPaidBody;

  /// No description provided for @payEmptyPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to verify'**
  String get payEmptyPendingTitle;

  /// No description provided for @payEmptyPendingBody.
  ///
  /// In en, this message translates to:
  /// **'When a member taps \"I\'ve paid\", their UPI reference waits here for a quick check.'**
  String get payEmptyPendingBody;

  /// No description provided for @payEmptySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get payEmptySearchTitle;

  /// No description provided for @payEmptySearchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another name, invoice or receipt number.'**
  String get payEmptySearchBody;

  /// No description provided for @payDueIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Due today} =1{Due tomorrow} other{Due in {days} days}}'**
  String payDueIn(int days);

  /// No description provided for @payOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day overdue} other{{days} days overdue}}'**
  String payOverdueBy(int days);

  /// No description provided for @payBalance.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String payBalance(String amount);

  /// No description provided for @payHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get payHistory;

  /// No description provided for @payReminders.
  ///
  /// In en, this message translates to:
  /// **'Fee reminders today'**
  String get payReminders;

  /// No description provided for @payRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member to nudge} other{{count} members to nudge}}'**
  String payRemindersBody(int count);

  /// No description provided for @payCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get payCollect;

  /// No description provided for @payTrainerTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments are with the desk'**
  String get payTrainerTitle;

  /// No description provided for @payTrainerBody.
  ///
  /// In en, this message translates to:
  /// **'Fees and receipts are handled by the front desk and the owner.'**
  String get payTrainerBody;

  /// No description provided for @payApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get payApprove;

  /// No description provided for @payReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get payReject;

  /// No description provided for @payRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this payment?'**
  String get payRejectTitle;

  /// No description provided for @payRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Why? (the member sees this)'**
  String get payRejectReason;

  /// No description provided for @payUtr.
  ///
  /// In en, this message translates to:
  /// **'UTR {utr}'**
  String payUtr(String utr);

  /// No description provided for @payApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved. Receipt {receipt}'**
  String payApproved(String receipt);

  /// No description provided for @payRejected.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected'**
  String get payRejected;

  /// No description provided for @payClaimedAt.
  ///
  /// In en, this message translates to:
  /// **'Sent {time}'**
  String payClaimedAt(String time);

  /// No description provided for @modeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get modeCash;

  /// No description provided for @modeUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get modeUpi;

  /// No description provided for @modeCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get modeCard;

  /// No description provided for @modeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get modeBank;

  /// No description provided for @modeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get modeOnline;

  /// No description provided for @modeCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get modeCredit;

  /// No description provided for @invoiceStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Part paid'**
  String get invoiceStatusPartial;

  /// No description provided for @invoiceStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoiceStatusPaid;

  /// No description provided for @invoiceStatusVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get invoiceStatusVoid;

  /// No description provided for @paymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for check'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get paymentStatusRejected;

  /// No description provided for @paymentStatusVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get paymentStatusVoided;

  /// No description provided for @collectTitle.
  ///
  /// In en, this message translates to:
  /// **'Collect payment'**
  String get collectTitle;

  /// No description provided for @collectSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Member name, phone or ID'**
  String get collectSearchHint;

  /// No description provided for @collectNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No members match'**
  String get collectNoMembers;

  /// No description provided for @collectPickInvoice.
  ///
  /// In en, this message translates to:
  /// **'Which invoice?'**
  String get collectPickInvoice;

  /// No description provided for @collectNothingDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing due'**
  String get collectNothingDueTitle;

  /// No description provided for @collectNothingDueBody.
  ///
  /// In en, this message translates to:
  /// **'{name} has no open invoices.'**
  String collectNothingDueBody(String name);

  /// No description provided for @collectAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get collectAmount;

  /// No description provided for @collectFull.
  ///
  /// In en, this message translates to:
  /// **'Full {amount}'**
  String collectFull(String amount);

  /// No description provided for @collectInstalment.
  ///
  /// In en, this message translates to:
  /// **'Instalment {amount}'**
  String collectInstalment(String amount);

  /// No description provided for @collectMode.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get collectMode;

  /// No description provided for @collectUtr.
  ///
  /// In en, this message translates to:
  /// **'UPI / bank reference (UTR)'**
  String get collectUtr;

  /// No description provided for @collectUtrHelp.
  ///
  /// In en, this message translates to:
  /// **'The 12-digit reference from the payment app'**
  String get collectUtrHelp;

  /// No description provided for @collectUtrMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter the UPI / bank reference (at least 6 characters).'**
  String get collectUtrMissing;

  /// No description provided for @collectExtraCredit.
  ///
  /// In en, this message translates to:
  /// **'{amount} extra is saved as credit'**
  String collectExtraCredit(String amount);

  /// No description provided for @collectStillDue.
  ///
  /// In en, this message translates to:
  /// **'{amount} will still be due'**
  String collectStillDue(String amount);

  /// No description provided for @collectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Collect {amount}'**
  String collectConfirm(String amount);

  /// No description provided for @collectEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get collectEnterAmount;

  /// No description provided for @collectUseCredit.
  ///
  /// In en, this message translates to:
  /// **'Use credit {amount}'**
  String collectUseCredit(String amount);

  /// No description provided for @collectDone.
  ///
  /// In en, this message translates to:
  /// **'Payment received!'**
  String get collectDone;

  /// No description provided for @collectCreditSaved.
  ///
  /// In en, this message translates to:
  /// **'{amount} saved as credit'**
  String collectCreditSaved(String amount);

  /// No description provided for @collectReceiptNo.
  ///
  /// In en, this message translates to:
  /// **'Receipt {receipt}'**
  String collectReceiptNo(String receipt);

  /// No description provided for @collectShareReceipt.
  ///
  /// In en, this message translates to:
  /// **'Share receipt'**
  String get collectShareReceipt;

  /// No description provided for @collectShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get collectShare;

  /// No description provided for @collectPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get collectPrint;

  /// No description provided for @collectWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp'**
  String get collectWhatsApp;

  /// No description provided for @collectAnother.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get collectAnother;

  /// No description provided for @collectChangeMember.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get collectChangeMember;

  /// No description provided for @keypadBackspace.
  ///
  /// In en, this message translates to:
  /// **'Delete digit'**
  String get keypadBackspace;

  /// No description provided for @receiptWhatsAppText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, we received {amount} at {gym}. Receipt {receipt}. Thank you!'**
  String receiptWhatsAppText(String name, String amount, String gym, String receipt);

  /// No description provided for @receiptFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not make the receipt. Try again.'**
  String get receiptFailed;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceTitle;

  /// No description provided for @invoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get invoiceItems;

  /// No description provided for @invoiceDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get invoiceDiscount;

  /// No description provided for @invoiceTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable value'**
  String get invoiceTaxable;

  /// No description provided for @invoiceCgst.
  ///
  /// In en, this message translates to:
  /// **'CGST'**
  String get invoiceCgst;

  /// No description provided for @invoiceSgst.
  ///
  /// In en, this message translates to:
  /// **'SGST'**
  String get invoiceSgst;

  /// No description provided for @invoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get invoiceTotal;

  /// No description provided for @invoicePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoicePaid;

  /// No description provided for @invoiceBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get invoiceBalance;

  /// No description provided for @invoiceIssued.
  ///
  /// In en, this message translates to:
  /// **'Issued {date}'**
  String invoiceIssued(String date);

  /// No description provided for @invoicePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get invoicePayments;

  /// No description provided for @invoiceNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get invoiceNoPayments;

  /// No description provided for @invoiceInstalments.
  ///
  /// In en, this message translates to:
  /// **'Instalments'**
  String get invoiceInstalments;

  /// No description provided for @invoiceSplit.
  ///
  /// In en, this message translates to:
  /// **'Split into instalments'**
  String get invoiceSplit;

  /// No description provided for @invoiceSplitHelp.
  ///
  /// In en, this message translates to:
  /// **'Up to 4 parts that add up to {total}.'**
  String invoiceSplitHelp(String total);

  /// No description provided for @invoiceAddPart.
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get invoiceAddPart;

  /// No description provided for @invoicePart.
  ///
  /// In en, this message translates to:
  /// **'Part {n}'**
  String invoicePart(int n);

  /// No description provided for @invoiceSplitMismatch.
  ///
  /// In en, this message translates to:
  /// **'Parts add up to {sum}; they must equal {total}.'**
  String invoiceSplitMismatch(String sum, String total);

  /// No description provided for @invoiceSplitSaved.
  ///
  /// In en, this message translates to:
  /// **'Instalments saved'**
  String get invoiceSplitSaved;

  /// No description provided for @invoiceSendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get invoiceSendLink;

  /// No description provided for @invoiceShowQr.
  ///
  /// In en, this message translates to:
  /// **'UPI QR'**
  String get invoiceShowQr;

  /// No description provided for @invoiceQrBody.
  ///
  /// In en, this message translates to:
  /// **'Scan with any UPI app to pay {amount}'**
  String invoiceQrBody(String amount);

  /// No description provided for @invoiceNoUpi.
  ///
  /// In en, this message translates to:
  /// **'Add the gym\'s UPI ID in Gym profile to share payment links.'**
  String get invoiceNoUpi;

  /// No description provided for @invoiceGatewayLink.
  ///
  /// In en, this message translates to:
  /// **'Razorpay link'**
  String get invoiceGatewayLink;

  /// No description provided for @invoiceGatewayReady.
  ///
  /// In en, this message translates to:
  /// **'Payment link ready'**
  String get invoiceGatewayReady;

  /// No description provided for @invoiceUpiText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, your fees of {amount} at {gym} are due ({invoice}). Pay by UPI: {link}'**
  String invoiceUpiText(String name, String amount, String gym, String invoice, String link);

  /// No description provided for @invoiceGatewayText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, pay your fees of {amount} at {gym} here: {link}'**
  String invoiceGatewayText(String name, String amount, String gym, String link);

  /// No description provided for @invoiceVoid.
  ///
  /// In en, this message translates to:
  /// **'Void invoice'**
  String get invoiceVoid;

  /// No description provided for @invoiceVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void {invoice}?'**
  String invoiceVoidTitle(String invoice);

  /// No description provided for @invoiceVoidBody.
  ///
  /// In en, this message translates to:
  /// **'The invoice stays on record marked void. This cannot be undone.'**
  String get invoiceVoidBody;

  /// No description provided for @invoiceVoided.
  ///
  /// In en, this message translates to:
  /// **'Invoice voided'**
  String get invoiceVoided;

  /// No description provided for @invoiceVoidedReason.
  ///
  /// In en, this message translates to:
  /// **'Voided: {reason}'**
  String invoiceVoidedReason(String reason);

  /// No description provided for @invoiceReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get invoiceReason;

  /// No description provided for @invoiceApplyCredit.
  ///
  /// In en, this message translates to:
  /// **'Use {amount} credit'**
  String invoiceApplyCredit(String amount);

  /// No description provided for @invoiceCreditApplied.
  ///
  /// In en, this message translates to:
  /// **'Credit applied'**
  String get invoiceCreditApplied;

  /// No description provided for @paymentVoid.
  ///
  /// In en, this message translates to:
  /// **'Void payment'**
  String get paymentVoid;

  /// No description provided for @paymentVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void receipt {receipt}?'**
  String paymentVoidTitle(String receipt);

  /// No description provided for @paymentVoidDone.
  ///
  /// In en, this message translates to:
  /// **'Payment voided'**
  String get paymentVoidDone;

  /// No description provided for @paymentRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get paymentRefund;

  /// No description provided for @paymentRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund from {receipt}'**
  String paymentRefundTitle(String receipt);

  /// No description provided for @paymentRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund amount'**
  String get paymentRefundAmount;

  /// No description provided for @paymentRefundMode.
  ///
  /// In en, this message translates to:
  /// **'Refund by'**
  String get paymentRefundMode;

  /// No description provided for @paymentRefundDone.
  ///
  /// In en, this message translates to:
  /// **'Refund recorded'**
  String get paymentRefundDone;

  /// No description provided for @paymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded {amount}'**
  String paymentRefunded(String amount);

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a reason.'**
  String get reasonRequired;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount more than zero.'**
  String get amountRequired;

  /// No description provided for @dayCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close the day'**
  String get dayCloseTitle;

  /// No description provided for @dayCloseBody.
  ///
  /// In en, this message translates to:
  /// **'Count the cash drawer, then lock today\'s collections.'**
  String get dayCloseBody;

  /// No description provided for @dayCloseByMode.
  ///
  /// In en, this message translates to:
  /// **'Today\'s collections'**
  String get dayCloseByMode;

  /// No description provided for @dayCloseTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dayCloseTotal;

  /// No description provided for @dayCloseCounted.
  ///
  /// In en, this message translates to:
  /// **'Cash you counted'**
  String get dayCloseCounted;

  /// No description provided for @dayCloseExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected cash {amount}'**
  String dayCloseExpected(String amount);

  /// No description provided for @dayCloseOver.
  ///
  /// In en, this message translates to:
  /// **'{amount} over'**
  String dayCloseOver(String amount);

  /// No description provided for @dayCloseShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} short'**
  String dayCloseShort(String amount);

  /// No description provided for @dayCloseExact.
  ///
  /// In en, this message translates to:
  /// **'Matches exactly'**
  String get dayCloseExact;

  /// No description provided for @dayCloseNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get dayCloseNote;

  /// No description provided for @dayCloseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close day'**
  String get dayCloseConfirm;

  /// No description provided for @dayCloseDone.
  ///
  /// In en, this message translates to:
  /// **'Day closed. Nice work!'**
  String get dayCloseDone;

  /// No description provided for @dayCloseLocked.
  ///
  /// In en, this message translates to:
  /// **'Closed at {time}. New collections need the owner to reopen your day.'**
  String dayCloseLocked(String time);

  /// No description provided for @dayCloseHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent closes'**
  String get dayCloseHistory;

  /// No description provided for @dayCloseReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get dayCloseReopen;

  /// No description provided for @dayCloseReopened.
  ///
  /// In en, this message translates to:
  /// **'Day reopened'**
  String get dayCloseReopened;

  /// No description provided for @dayCloseReopenedPill.
  ///
  /// In en, this message translates to:
  /// **'Reopened'**
  String get dayCloseReopenedPill;

  /// No description provided for @dayCloseCountedLine.
  ///
  /// In en, this message translates to:
  /// **'Counted {counted} · expected {expected}'**
  String dayCloseCountedLine(String counted, String expected);

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesTotal.
  ///
  /// In en, this message translates to:
  /// **'Spent in {month}'**
  String expensesTotal(String month);

  /// No description provided for @expensesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get expensesEmptyTitle;

  /// No description provided for @expensesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add rent, salaries and bills to see what the gym really earns.'**
  String get expensesEmptyBody;

  /// No description provided for @expenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseAdd;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @expenseDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDate;

  /// No description provided for @expenseNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get expenseNote;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved'**
  String get expenseSaved;

  /// No description provided for @expenseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted'**
  String get expenseDeleted;

  /// No description provided for @expenseDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get expenseDelete;

  /// No description provided for @expenseRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get expenseRent;

  /// No description provided for @expenseSalaries.
  ///
  /// In en, this message translates to:
  /// **'Salaries'**
  String get expenseSalaries;

  /// No description provided for @expenseElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get expenseElectricity;

  /// No description provided for @expenseEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get expenseEquipment;

  /// No description provided for @expenseMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get expenseMaintenance;

  /// No description provided for @expenseMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get expenseMarketing;

  /// No description provided for @expenseSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get expenseSupplies;

  /// No description provided for @expenseOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expenseOther;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get historyTitle;

  /// No description provided for @historySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, receipt or UTR'**
  String get historySearchHint;

  /// No description provided for @historyAllModes.
  ///
  /// In en, this message translates to:
  /// **'All modes'**
  String get historyAllModes;

  /// No description provided for @historyDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get historyDates;

  /// No description provided for @historyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get historyClear;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search or filter.'**
  String get historyEmptyBody;

  /// No description provided for @dashRevenue.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get dashRevenue;

  /// No description provided for @dashToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashToday;

  /// No description provided for @dashWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get dashWeek;

  /// No description provided for @dashMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dashMonth;

  /// No description provided for @dashOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue fees'**
  String get dashOverdue;

  /// No description provided for @dashToVerify.
  ///
  /// In en, this message translates to:
  /// **'Payments to verify'**
  String get dashToVerify;

  /// No description provided for @dashOutstanding.
  ///
  /// In en, this message translates to:
  /// **'{amount} outstanding'**
  String dashOutstanding(String amount);

  /// No description provided for @dashLast30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get dashLast30;

  /// No description provided for @dashInvoices.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No invoices} =1{1 invoice} other{{count} invoices}}'**
  String dashInvoices(int count);

  /// No description provided for @reasonOverdue.
  ///
  /// In en, this message translates to:
  /// **'{amount} overdue since {date}'**
  String reasonOverdue(String amount, String date);

  /// No description provided for @whatsappDuesText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, a friendly reminder: {amount} is due at {gym} (since {date}).'**
  String whatsappDuesText(String name, String amount, String gym, String date);

  /// No description provided for @whatsappDueSoonText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, your fees of {amount} at {gym} are due on {date}.'**
  String whatsappDueSoonText(String name, String amount, String gym, String date);

  /// No description provided for @whatsappDueTodayText.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, your fees of {amount} at {gym} are due today.'**
  String whatsappDueTodayText(String name, String amount, String gym);

  /// No description provided for @whatsappPayLine.
  ///
  /// In en, this message translates to:
  /// **'Pay by UPI: {link}'**
  String whatsappPayLine(String link);

  /// No description provided for @meDuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fees due'**
  String get meDuesTitle;

  /// No description provided for @meDueBy.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String meDueBy(String date);

  /// No description provided for @mePayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get mePayNow;

  /// No description provided for @meAllPaid.
  ///
  /// In en, this message translates to:
  /// **'All paid up. Thank you!'**
  String get meAllPaid;

  /// No description provided for @mePayTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay fees'**
  String get mePayTitle;

  /// No description provided for @mePayUpi.
  ///
  /// In en, this message translates to:
  /// **'Pay with a UPI app'**
  String get mePayUpi;

  /// No description provided for @mePayScan.
  ///
  /// In en, this message translates to:
  /// **'Or scan this QR from another phone'**
  String get mePayScan;

  /// No description provided for @mePaid.
  ///
  /// In en, this message translates to:
  /// **'I\'ve paid'**
  String get mePaid;

  /// No description provided for @mePaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us you\'ve paid'**
  String get mePaidTitle;

  /// No description provided for @mePaidBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the UPI reference (UTR) from your payment app. The desk checks it and your receipt appears here.'**
  String get mePaidBody;

  /// No description provided for @mePaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount you paid'**
  String get mePaidAmount;

  /// No description provided for @mePaidSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send for check'**
  String get mePaidSubmit;

  /// No description provided for @mePaidSent.
  ///
  /// In en, this message translates to:
  /// **'Sent! We\'ll confirm it soon.'**
  String get mePaidSent;

  /// No description provided for @mePaidPending.
  ///
  /// In en, this message translates to:
  /// **'{amount} waiting for the desk to check'**
  String mePaidPending(String amount);

  /// No description provided for @mePayments.
  ///
  /// In en, this message translates to:
  /// **'My payments'**
  String get mePayments;

  /// No description provided for @mePaymentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices and receipts'**
  String get mePaymentsSubtitle;

  /// No description provided for @meNoUpi.
  ///
  /// In en, this message translates to:
  /// **'The gym hasn\'t set up UPI yet. Please pay at the front desk.'**
  String get meNoUpi;

  /// No description provided for @meNoInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get meNoInvoicesTitle;

  /// No description provided for @meNoInvoicesBody.
  ///
  /// In en, this message translates to:
  /// **'Your invoices and receipts will show up here.'**
  String get meNoInvoicesBody;

  /// No description provided for @mePayAtDesk.
  ///
  /// In en, this message translates to:
  /// **'You can also pay at the front desk.'**
  String get mePayAtDesk;

  /// No description provided for @meRejected.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed: {reason}'**
  String meRejected(String reason);

  /// No description provided for @noUpiApp.
  ///
  /// In en, this message translates to:
  /// **'No UPI app opened. Scan the QR instead.'**
  String get noUpiApp;

  /// No description provided for @checkInDues.
  ///
  /// In en, this message translates to:
  /// **'{amount} fees pending'**
  String checkInDues(String amount);

  /// No description provided for @memberCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit {amount}'**
  String memberCredit(String amount);

  /// No description provided for @memberDues.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String memberDues(String amount);

  /// No description provided for @memberNoInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get memberNoInvoicesTitle;

  /// No description provided for @memberNoInvoicesBody.
  ///
  /// In en, this message translates to:
  /// **'An invoice is created when a plan starts or renews.'**
  String get memberNoInvoicesBody;

  /// No description provided for @gymPaymentsSection.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get gymPaymentsSection;

  /// No description provided for @gymGstEnabled.
  ///
  /// In en, this message translates to:
  /// **'Charge GST'**
  String get gymGstEnabled;

  /// No description provided for @gymGstEnabledBody.
  ///
  /// In en, this message translates to:
  /// **'Shows CGST and SGST on invoices (needs a GSTIN).'**
  String get gymGstEnabledBody;

  /// No description provided for @gymGstInclusive.
  ///
  /// In en, this message translates to:
  /// **'Prices include GST'**
  String get gymGstInclusive;

  /// No description provided for @gymGstInclusiveBody.
  ///
  /// In en, this message translates to:
  /// **'Off: GST is added on top of plan prices.'**
  String get gymGstInclusiveBody;

  /// No description provided for @gymRazorpay.
  ///
  /// In en, this message translates to:
  /// **'Razorpay payment links'**
  String get gymRazorpay;

  /// No description provided for @gymRazorpayBody.
  ///
  /// In en, this message translates to:
  /// **'Needs Razorpay keys on the server. UPI links work without it.'**
  String get gymRazorpayBody;

  /// No description provided for @moreDayClose.
  ///
  /// In en, this message translates to:
  /// **'Day close'**
  String get moreDayClose;

  /// No description provided for @moreDayCloseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Count cash and lock the day'**
  String get moreDayCloseSubtitle;

  /// No description provided for @moreExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get moreExpenses;

  /// No description provided for @moreExpensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rent, salaries and bills'**
  String get moreExpensesSubtitle;

  /// No description provided for @morePaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get morePaymentHistory;

  /// No description provided for @morePaymentHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every receipt, with filters'**
  String get morePaymentHistorySubtitle;

  /// No description provided for @welcomeGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get welcomeGoogle;

  /// No description provided for @welcomeGoogleHint.
  ///
  /// In en, this message translates to:
  /// **'Staff and members: use the Gmail the gym has on your record.'**
  String get welcomeGoogleHint;

  /// No description provided for @authSharedEmail.
  ///
  /// In en, this message translates to:
  /// **'This Gmail is on more than one member. Ask the front desk to give each member their own Gmail.'**
  String get authSharedEmail;

  /// No description provided for @authGoogleOnly.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with your Google account.'**
  String get authGoogleOnly;

  /// No description provided for @authCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in didn\'t open. Please try again.'**
  String get authCancelled;

  /// No description provided for @fieldGmail.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get fieldGmail;

  /// No description provided for @staffGmailHelp.
  ///
  /// In en, this message translates to:
  /// **'They sign in with Google using this address.'**
  String get staffGmailHelp;

  /// No description provided for @memberGmailHelp.
  ///
  /// In en, this message translates to:
  /// **'Used to sign in to the member app with Google.'**
  String get memberGmailHelp;

  /// No description provided for @memberNoGmail.
  ///
  /// In en, this message translates to:
  /// **'Add a Gmail so {name} can sign in to the member app.'**
  String memberNoGmail(String name);

  /// No description provided for @staffAddedTitle.
  ///
  /// In en, this message translates to:
  /// **'Added to the team'**
  String get staffAddedTitle;

  /// No description provided for @staffAddedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} can now sign in with Google using:'**
  String staffAddedBody(String name);

  /// No description provided for @trainTitle.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get trainTitle;

  /// No description provided for @trainTabMembers.
  ///
  /// In en, this message translates to:
  /// **'My members'**
  String get trainTabMembers;

  /// No description provided for @trainTabPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get trainTabPrograms;

  /// No description provided for @trainTabExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get trainTabExercises;

  /// No description provided for @trainAllTrainers.
  ///
  /// In en, this message translates to:
  /// **'All trainers'**
  String get trainAllTrainers;

  /// No description provided for @trainNoProgram.
  ///
  /// In en, this message translates to:
  /// **'No program'**
  String get trainNoProgram;

  /// No description provided for @trainLastWorkout.
  ///
  /// In en, this message translates to:
  /// **'Last workout {date}'**
  String trainLastWorkout(String date);

  /// No description provided for @trainNeverWorkedOut.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get trainNeverWorkedOut;

  /// No description provided for @trainThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None this week} =1{1 this week} other{{count} this week}}'**
  String trainThisWeek(int count);

  /// No description provided for @trainAdherence.
  ///
  /// In en, this message translates to:
  /// **'{percent}% on plan'**
  String trainAdherence(int percent);

  /// No description provided for @trainEmptyMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get trainEmptyMembersTitle;

  /// No description provided for @trainEmptyMembersBody.
  ///
  /// In en, this message translates to:
  /// **'Members assigned to you show up here with their program and progress.'**
  String get trainEmptyMembersBody;

  /// No description provided for @trainSearchMembers.
  ///
  /// In en, this message translates to:
  /// **'Search members'**
  String get trainSearchMembers;

  /// No description provided for @exTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exTitle;

  /// No description provided for @exSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search {count} exercises'**
  String exSearchHint(int count);

  /// No description provided for @exFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get exFront;

  /// No description provided for @exBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get exBack;

  /// No description provided for @exBodyMapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a muscle to see its exercises'**
  String get exBodyMapHint;

  /// No description provided for @exAllMuscles.
  ///
  /// In en, this message translates to:
  /// **'All muscles'**
  String get exAllMuscles;

  /// No description provided for @exFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get exFavourites;

  /// No description provided for @exFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get exFilters;

  /// No description provided for @exOurEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment we have'**
  String get exOurEquipment;

  /// No description provided for @exEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exEquipment;

  /// No description provided for @exLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get exLevel;

  /// No description provided for @exCategory.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get exCategory;

  /// No description provided for @exClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get exClearFilters;

  /// No description provided for @exShowResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises} =1{Show 1 exercise} other{Show {count} exercises}}'**
  String exShowResults(int count);

  /// No description provided for @exEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No exercises match'**
  String get exEmptyTitle;

  /// No description provided for @exEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another muscle, search or filter.'**
  String get exEmptyBody;

  /// No description provided for @exEmptyFavouritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get exEmptyFavouritesTitle;

  /// No description provided for @exEmptyFavouritesBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the star on any exercise to keep it here.'**
  String get exEmptyFavouritesBody;

  /// No description provided for @exAdd.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get exAdd;

  /// No description provided for @exStar.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get exStar;

  /// No description provided for @exUnstar.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get exUnstar;

  /// No description provided for @exCustom.
  ///
  /// In en, this message translates to:
  /// **'Gym exercise'**
  String get exCustom;

  /// No description provided for @exInstructions.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get exInstructions;

  /// No description provided for @exTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get exTips;

  /// No description provided for @exMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common mistakes'**
  String get exMistakes;

  /// No description provided for @exMuscles.
  ///
  /// In en, this message translates to:
  /// **'Muscles worked'**
  String get exMuscles;

  /// No description provided for @exPrimary.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get exPrimary;

  /// No description provided for @exSecondary.
  ///
  /// In en, this message translates to:
  /// **'Also works'**
  String get exSecondary;

  /// No description provided for @exAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Alternatives'**
  String get exAlternatives;

  /// No description provided for @exWatchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get exWatchVideo;

  /// No description provided for @exYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get exYourProgress;

  /// No description provided for @exBestWeight.
  ///
  /// In en, this message translates to:
  /// **'Best weight'**
  String get exBestWeight;

  /// No description provided for @exBestE1rm.
  ///
  /// In en, this message translates to:
  /// **'Est. 1-rep max'**
  String get exBestE1rm;

  /// No description provided for @exSessions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String exSessions(int count);

  /// No description provided for @exNoHistory.
  ///
  /// In en, this message translates to:
  /// **'Log this exercise in a workout to see your progress.'**
  String get exNoHistory;

  /// No description provided for @exEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get exEdit;

  /// No description provided for @exArchive.
  ///
  /// In en, this message translates to:
  /// **'Remove from library'**
  String get exArchive;

  /// No description provided for @exArchived.
  ///
  /// In en, this message translates to:
  /// **'Exercise removed'**
  String get exArchived;

  /// No description provided for @exSaved.
  ///
  /// In en, this message translates to:
  /// **'Exercise saved'**
  String get exSaved;

  /// No description provided for @exEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Equipment we have'**
  String get exEquipmentTitle;

  /// No description provided for @exEquipmentBody.
  ///
  /// In en, this message translates to:
  /// **'Untick what the gym doesn\'t have. Members and trainers can hide exercises that need it.'**
  String get exEquipmentBody;

  /// No description provided for @exEquipmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Equipment saved'**
  String get exEquipmentSaved;

  /// No description provided for @exNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New exercise'**
  String get exNewTitle;

  /// No description provided for @exEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get exEditTitle;

  /// No description provided for @exFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exFieldName;

  /// No description provided for @exFieldLocalName.
  ///
  /// In en, this message translates to:
  /// **'Hindi name (optional)'**
  String get exFieldLocalName;

  /// No description provided for @exFieldPrimary.
  ///
  /// In en, this message translates to:
  /// **'Main muscles'**
  String get exFieldPrimary;

  /// No description provided for @exFieldSecondary.
  ///
  /// In en, this message translates to:
  /// **'Other muscles'**
  String get exFieldSecondary;

  /// No description provided for @exFieldTracking.
  ///
  /// In en, this message translates to:
  /// **'Log as'**
  String get exFieldTracking;

  /// No description provided for @exFieldInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps (one per line)'**
  String get exFieldInstructions;

  /// No description provided for @exFieldTips.
  ///
  /// In en, this message translates to:
  /// **'Tips (optional)'**
  String get exFieldTips;

  /// No description provided for @exFieldMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common mistakes (optional)'**
  String get exFieldMistakes;

  /// No description provided for @exFieldVideo.
  ///
  /// In en, this message translates to:
  /// **'YouTube link (optional)'**
  String get exFieldVideo;

  /// No description provided for @exFieldPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get exFieldPhoto;

  /// No description provided for @exPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get exPhotoAdd;

  /// No description provided for @exPhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get exPhotoChange;

  /// No description provided for @exNeedsMuscle.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one main muscle.'**
  String get exNeedsMuscle;

  /// No description provided for @exBadVideo.
  ///
  /// In en, this message translates to:
  /// **'Use a YouTube link (youtube.com or youtu.be).'**
  String get exBadVideo;

  /// No description provided for @trackRepsWeight.
  ///
  /// In en, this message translates to:
  /// **'Reps and weight'**
  String get trackRepsWeight;

  /// No description provided for @trackReps.
  ///
  /// In en, this message translates to:
  /// **'Reps only'**
  String get trackReps;

  /// No description provided for @trackTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get trackTime;

  /// No description provided for @trackDistanceTime.
  ///
  /// In en, this message translates to:
  /// **'Distance and time'**
  String get trackDistanceTime;

  /// No description provided for @levelExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get levelExpert;

  /// No description provided for @catStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get catStrength;

  /// No description provided for @catStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get catStretching;

  /// No description provided for @catCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get catCardio;

  /// No description provided for @catPlyometrics.
  ///
  /// In en, this message translates to:
  /// **'Plyometrics'**
  String get catPlyometrics;

  /// No description provided for @catPowerlifting.
  ///
  /// In en, this message translates to:
  /// **'Powerlifting'**
  String get catPowerlifting;

  /// No description provided for @catOlympic.
  ///
  /// In en, this message translates to:
  /// **'Olympic lifting'**
  String get catOlympic;

  /// No description provided for @catStrongman.
  ///
  /// In en, this message translates to:
  /// **'Strongman'**
  String get catStrongman;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// No description provided for @muscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get muscleForearms;

  /// No description provided for @muscleAbdominals.
  ///
  /// In en, this message translates to:
  /// **'Abs'**
  String get muscleAbdominals;

  /// No description provided for @muscleQuadriceps.
  ///
  /// In en, this message translates to:
  /// **'Quads'**
  String get muscleQuadriceps;

  /// No description provided for @muscleAdductors.
  ///
  /// In en, this message translates to:
  /// **'Inner thighs'**
  String get muscleAdductors;

  /// No description provided for @muscleAbductors.
  ///
  /// In en, this message translates to:
  /// **'Outer thighs'**
  String get muscleAbductors;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get muscleNeck;

  /// No description provided for @muscleTraps.
  ///
  /// In en, this message translates to:
  /// **'Traps'**
  String get muscleTraps;

  /// No description provided for @muscleLats.
  ///
  /// In en, this message translates to:
  /// **'Lats'**
  String get muscleLats;

  /// No description provided for @muscleMiddleBack.
  ///
  /// In en, this message translates to:
  /// **'Middle back'**
  String get muscleMiddleBack;

  /// No description provided for @muscleLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get muscleLowerBack;

  /// No description provided for @muscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// No description provided for @equipBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipBarbell;

  /// No description provided for @equipDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get equipDumbbell;

  /// No description provided for @equipCable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get equipCable;

  /// No description provided for @equipMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipMachine;

  /// No description provided for @equipKettlebells.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get equipKettlebells;

  /// No description provided for @equipBands.
  ///
  /// In en, this message translates to:
  /// **'Bands'**
  String get equipBands;

  /// No description provided for @equipMedicineBall.
  ///
  /// In en, this message translates to:
  /// **'Medicine ball'**
  String get equipMedicineBall;

  /// No description provided for @equipExerciseBall.
  ///
  /// In en, this message translates to:
  /// **'Exercise ball'**
  String get equipExerciseBall;

  /// No description provided for @equipFoamRoll.
  ///
  /// In en, this message translates to:
  /// **'Foam roller'**
  String get equipFoamRoll;

  /// No description provided for @equipEzBar.
  ///
  /// In en, this message translates to:
  /// **'EZ curl bar'**
  String get equipEzBar;

  /// No description provided for @equipBodyOnly.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get equipBodyOnly;

  /// No description provided for @equipOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get equipOther;

  /// No description provided for @progEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No programs yet'**
  String get progEmptyTitle;

  /// No description provided for @progEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start from a gym template or build your own.'**
  String get progEmptyBody;

  /// No description provided for @progSearch.
  ///
  /// In en, this message translates to:
  /// **'Search programs'**
  String get progSearch;

  /// No description provided for @progStarter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get progStarter;

  /// No description provided for @progWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, =1{1 week} other{{weeks} weeks}}'**
  String progWeeks(int weeks);

  /// No description provided for @progDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day a week} other{{count} days a week}}'**
  String progDays(int count);

  /// No description provided for @progExercises.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String progExercises(int count);

  /// No description provided for @progNew.
  ///
  /// In en, this message translates to:
  /// **'New program'**
  String get progNew;

  /// No description provided for @progAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get progAssign;

  /// No description provided for @progDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get progDuplicate;

  /// No description provided for @progDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Copy saved as \"{name}\"'**
  String progDuplicated(String name);

  /// No description provided for @progEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get progEdit;

  /// No description provided for @progShare.
  ///
  /// In en, this message translates to:
  /// **'Share plan'**
  String get progShare;

  /// No description provided for @progSharePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get progSharePdf;

  /// No description provided for @progShareText.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp text'**
  String get progShareText;

  /// No description provided for @progArchive.
  ///
  /// In en, this message translates to:
  /// **'Remove program'**
  String get progArchive;

  /// No description provided for @progArchived.
  ///
  /// In en, this message translates to:
  /// **'Program removed'**
  String get progArchived;

  /// No description provided for @progProgressionNone.
  ///
  /// In en, this message translates to:
  /// **'Same each week'**
  String get progProgressionNone;

  /// No description provided for @progProgressionWeight.
  ///
  /// In en, this message translates to:
  /// **'+{step} kg a week'**
  String progProgressionWeight(String step);

  /// No description provided for @progProgressionReps.
  ///
  /// In en, this message translates to:
  /// **'+{step} rep a week'**
  String progProgressionReps(String step);

  /// No description provided for @progCopyName.
  ///
  /// In en, this message translates to:
  /// **'{name} (copy)'**
  String progCopyName(String name);

  /// No description provided for @goalFatLossShort.
  ///
  /// In en, this message translates to:
  /// **'Fat loss'**
  String get goalFatLossShort;

  /// No description provided for @goalMuscleGainShort.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get goalMuscleGainShort;

  /// No description provided for @goalStrengthShort.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get goalStrengthShort;

  /// No description provided for @goalGeneralShort.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get goalGeneralShort;

  /// No description provided for @goalRehabShort.
  ///
  /// In en, this message translates to:
  /// **'Rehab'**
  String get goalRehabShort;

  /// No description provided for @blockWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get blockWarmup;

  /// No description provided for @blockMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get blockMain;

  /// No description provided for @blockCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get blockCooldown;

  /// No description provided for @superset.
  ///
  /// In en, this message translates to:
  /// **'Superset {key}'**
  String superset(String key);

  /// No description provided for @itemSetsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps}'**
  String itemSetsReps(int sets, String reps);

  /// No description provided for @itemSetsTime.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {time}'**
  String itemSetsTime(int sets, String time);

  /// No description provided for @itemAt.
  ///
  /// In en, this message translates to:
  /// **'@ {weight}'**
  String itemAt(String weight);

  /// No description provided for @itemRest.
  ///
  /// In en, this message translates to:
  /// **'rest {time}'**
  String itemRest(String time);

  /// No description provided for @itemRpe.
  ///
  /// In en, this message translates to:
  /// **'RPE {rpe}'**
  String itemRpe(String rpe);

  /// No description provided for @itemTempo.
  ///
  /// In en, this message translates to:
  /// **'tempo {tempo}'**
  String itemTempo(String tempo);

  /// No description provided for @buildNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New program'**
  String get buildNewTitle;

  /// No description provided for @buildEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit program'**
  String get buildEditTitle;

  /// No description provided for @buildName.
  ///
  /// In en, this message translates to:
  /// **'Program name'**
  String get buildName;

  /// No description provided for @buildDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get buildDescription;

  /// No description provided for @buildGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get buildGoal;

  /// No description provided for @buildLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get buildLevel;

  /// No description provided for @buildWeeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get buildWeeks;

  /// No description provided for @buildProgression.
  ///
  /// In en, this message translates to:
  /// **'Each week'**
  String get buildProgression;

  /// No description provided for @buildStep.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get buildStep;

  /// No description provided for @buildAddDay.
  ///
  /// In en, this message translates to:
  /// **'Add day'**
  String get buildAddDay;

  /// No description provided for @buildDayName.
  ///
  /// In en, this message translates to:
  /// **'Day name'**
  String get buildDayName;

  /// No description provided for @buildDay.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String buildDay(int n);

  /// No description provided for @buildRemoveDay.
  ///
  /// In en, this message translates to:
  /// **'Remove day'**
  String get buildRemoveDay;

  /// No description provided for @buildRenameDay.
  ///
  /// In en, this message translates to:
  /// **'Rename day'**
  String get buildRenameDay;

  /// No description provided for @buildAddExercises.
  ///
  /// In en, this message translates to:
  /// **'Add exercises'**
  String get buildAddExercises;

  /// No description provided for @buildEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'Add exercises to this day.'**
  String get buildEmptyDay;

  /// No description provided for @buildSaved.
  ///
  /// In en, this message translates to:
  /// **'Program saved'**
  String get buildSaved;

  /// No description provided for @buildNeedsName.
  ///
  /// In en, this message translates to:
  /// **'Give the program a name.'**
  String get buildNeedsName;

  /// No description provided for @buildNeedsExercises.
  ///
  /// In en, this message translates to:
  /// **'Every day needs at least one exercise.'**
  String get buildNeedsExercises;

  /// No description provided for @buildItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Sets and targets'**
  String get buildItemTitle;

  /// No description provided for @buildSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get buildSets;

  /// No description provided for @buildReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get buildReps;

  /// No description provided for @buildRepsMax.
  ///
  /// In en, this message translates to:
  /// **'Up to (optional)'**
  String get buildRepsMax;

  /// No description provided for @buildSeconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get buildSeconds;

  /// No description provided for @buildMetres.
  ///
  /// In en, this message translates to:
  /// **'Metres (optional)'**
  String get buildMetres;

  /// No description provided for @buildWeight.
  ///
  /// In en, this message translates to:
  /// **'Target kg (optional)'**
  String get buildWeight;

  /// No description provided for @buildRpe.
  ///
  /// In en, this message translates to:
  /// **'RPE 1–10 (optional)'**
  String get buildRpe;

  /// No description provided for @buildRestSeconds.
  ///
  /// In en, this message translates to:
  /// **'Rest (seconds)'**
  String get buildRestSeconds;

  /// No description provided for @buildTempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo, e.g. 3-1-1 (optional)'**
  String get buildTempo;

  /// No description provided for @buildNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get buildNotes;

  /// No description provided for @buildBlock.
  ///
  /// In en, this message translates to:
  /// **'Part of the workout'**
  String get buildBlock;

  /// No description provided for @buildGroup.
  ///
  /// In en, this message translates to:
  /// **'Superset with'**
  String get buildGroup;

  /// No description provided for @buildRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove exercise'**
  String get buildRemoveItem;

  /// No description provided for @buildDragHint.
  ///
  /// In en, this message translates to:
  /// **'Hold and drag to reorder'**
  String get buildDragHint;

  /// No description provided for @buildPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Add exercises'**
  String get buildPickTitle;

  /// No description provided for @buildPickAdd.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Pick exercises} =1{Add 1 exercise} other{Add {count} exercises}}'**
  String buildPickAdd(int count);

  /// No description provided for @buildDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get buildDiscardTitle;

  /// No description provided for @buildDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your edits to this program will be lost.'**
  String get buildDiscardBody;

  /// No description provided for @buildDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get buildDiscard;

  /// No description provided for @buildKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get buildKeepEditing;

  /// No description provided for @assignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign \"{name}\"'**
  String assignTitle(String name);

  /// No description provided for @assignMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get assignMembers;

  /// No description provided for @assignSearch.
  ///
  /// In en, this message translates to:
  /// **'Search your members'**
  String get assignSearch;

  /// No description provided for @assignStart.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get assignStart;

  /// No description provided for @assignWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Training days ({count} a week)'**
  String assignWeekdays(int count);

  /// No description provided for @assignPickWeekdays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Pick 1 day} other{Pick {count} days}}'**
  String assignPickWeekdays(int count);

  /// No description provided for @assignMode.
  ///
  /// In en, this message translates to:
  /// **'If they already have a program'**
  String get assignMode;

  /// No description provided for @assignReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace it'**
  String get assignReplace;

  /// No description provided for @assignQueue.
  ///
  /// In en, this message translates to:
  /// **'Start after it'**
  String get assignQueue;

  /// No description provided for @assignConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Pick members} =1{Assign to 1 member} other{Assign to {count} members}}'**
  String assignConfirm(int count);

  /// No description provided for @assignDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Assigned to 1 member} other{Assigned to {count} members}}'**
  String assignDone(int count);

  /// No description provided for @assignPickProgram.
  ///
  /// In en, this message translates to:
  /// **'Pick a program'**
  String get assignPickProgram;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @wkProgram.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get wkProgram;

  /// No description provided for @wkWeekOf.
  ///
  /// In en, this message translates to:
  /// **'Week {week} of {total}'**
  String wkWeekOf(int week, int total);

  /// No description provided for @wkStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String wkStartsOn(String date);

  /// No description provided for @wkQueued.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get wkQueued;

  /// No description provided for @wkEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String wkEnds(String date);

  /// No description provided for @wkStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get wkStreak;

  /// No description provided for @wkAdherence.
  ///
  /// In en, this message translates to:
  /// **'On plan'**
  String get wkAdherence;

  /// No description provided for @wkThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get wkThisWeek;

  /// No description provided for @wkCalendar.
  ///
  /// In en, this message translates to:
  /// **'Plan vs done'**
  String get wkCalendar;

  /// No description provided for @wkPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get wkPlanned;

  /// No description provided for @wkDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get wkDone;

  /// No description provided for @wkMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get wkMissed;

  /// No description provided for @wkHistory.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get wkHistory;

  /// No description provided for @wkNoWorkoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get wkNoWorkoutsTitle;

  /// No description provided for @wkNoWorkoutsBody.
  ///
  /// In en, this message translates to:
  /// **'Finished workouts show up here with PRs and coach comments.'**
  String get wkNoWorkoutsBody;

  /// No description provided for @wkNoProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'No program yet'**
  String get wkNoProgramTitle;

  /// No description provided for @wkNoProgramBody.
  ///
  /// In en, this message translates to:
  /// **'Your trainer will set one up for you. Meanwhile, browse the exercise library.'**
  String get wkNoProgramBody;

  /// No description provided for @wkNoProgramStaffBody.
  ///
  /// In en, this message translates to:
  /// **'Assign a program to get them started.'**
  String get wkNoProgramStaffBody;

  /// No description provided for @wkAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign program'**
  String get wkAssign;

  /// No description provided for @wkEditProgram.
  ///
  /// In en, this message translates to:
  /// **'Tune program'**
  String get wkEditProgram;

  /// No description provided for @wkEndProgram.
  ///
  /// In en, this message translates to:
  /// **'End program'**
  String get wkEndProgram;

  /// No description provided for @wkEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End \"{name}\"?'**
  String wkEndTitle(String name);

  /// No description provided for @wkEndBody.
  ///
  /// In en, this message translates to:
  /// **'The program stops today. Logged workouts stay.'**
  String get wkEndBody;

  /// No description provided for @wkEnded.
  ///
  /// In en, this message translates to:
  /// **'Program ended'**
  String get wkEnded;

  /// No description provided for @wkTodayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today: {name}'**
  String wkTodayWorkout(String name);

  /// No description provided for @wkRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get wkRestDay;

  /// No description provided for @wkRestDayBody.
  ///
  /// In en, this message translates to:
  /// **'Next: {name} on {date}'**
  String wkRestDayBody(String name, String date);

  /// No description provided for @wkDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Done for today. Great work!'**
  String get wkDoneToday;

  /// No description provided for @wkStart.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get wkStart;

  /// No description provided for @wkResume.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get wkResume;

  /// No description provided for @wkStartNext.
  ///
  /// In en, this message translates to:
  /// **'Start {name} instead'**
  String wkStartNext(String name);

  /// No description provided for @wkDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String wkDuration(int minutes);

  /// No description provided for @wkVolume.
  ///
  /// In en, this message translates to:
  /// **'{kg} kg lifted'**
  String wkVolume(String kg);

  /// No description provided for @wkPrs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 PR} other{{count} PRs}}'**
  String wkPrs(int count);

  /// No description provided for @wkPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get wkPartial;

  /// No description provided for @wkComments.
  ///
  /// In en, this message translates to:
  /// **'Coach notes'**
  String get wkComments;

  /// No description provided for @wkCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Say something encouraging'**
  String get wkCommentHint;

  /// No description provided for @wkSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get wkSend;

  /// No description provided for @wkReacted.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get wkReacted;

  /// No description provided for @wkLibrary.
  ///
  /// In en, this message translates to:
  /// **'Exercise library'**
  String get wkLibrary;

  /// No description provided for @wkDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get wkDays;

  /// No description provided for @wkLogTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} · {date}'**
  String wkLogTitle(String name, String date);

  /// No description provided for @wkEditable.
  ///
  /// In en, this message translates to:
  /// **'You can change this workout until {time}.'**
  String wkEditable(String time);

  /// No description provided for @playExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the workout?'**
  String get playExitTitle;

  /// No description provided for @playExitBody.
  ///
  /// In en, this message translates to:
  /// **'Your sets are saved on this phone. Resume any time from Workout.'**
  String get playExitBody;

  /// No description provided for @playExitSave.
  ///
  /// In en, this message translates to:
  /// **'Save as partial'**
  String get playExitSave;

  /// No description provided for @playExitKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it for later'**
  String get playExitKeep;

  /// No description provided for @playExitDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard workout'**
  String get playExitDiscard;

  /// No description provided for @playSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get playSet;

  /// No description provided for @playTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get playTarget;

  /// No description provided for @playKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get playKg;

  /// No description provided for @playReps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get playReps;

  /// No description provided for @playSec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get playSec;

  /// No description provided for @playMetres.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get playMetres;

  /// No description provided for @playAddSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get playAddSet;

  /// No description provided for @playTick.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get playTick;

  /// No description provided for @playUntick.
  ///
  /// In en, this message translates to:
  /// **'Not done'**
  String get playUntick;

  /// No description provided for @playNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {name}'**
  String playNext(String name);

  /// No description provided for @playLastExercise.
  ///
  /// In en, this message translates to:
  /// **'Last exercise'**
  String get playLastExercise;

  /// No description provided for @playRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get playRest;

  /// No description provided for @playRestSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get playRestSkip;

  /// No description provided for @playRestAdd.
  ///
  /// In en, this message translates to:
  /// **'+15 s'**
  String get playRestAdd;

  /// No description provided for @playFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get playFinish;

  /// No description provided for @playFinishEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish early?'**
  String get playFinishEarlyTitle;

  /// No description provided for @playFinishEarlyBody.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} sets done. It is saved as a partial workout.'**
  String playFinishEarlyBody(int done, int total);

  /// No description provided for @playFinishAnyway.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get playFinishAnyway;

  /// No description provided for @playSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout done!'**
  String get playSummaryTitle;

  /// No description provided for @playSummaryPartial.
  ///
  /// In en, this message translates to:
  /// **'Workout saved'**
  String get playSummaryPartial;

  /// No description provided for @playSummaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get playSummaryDuration;

  /// No description provided for @playSummaryVolume.
  ///
  /// In en, this message translates to:
  /// **'Lifted'**
  String get playSummaryVolume;

  /// No description provided for @playSummarySets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get playSummarySets;

  /// No description provided for @playSummaryPrs.
  ///
  /// In en, this message translates to:
  /// **'New personal records'**
  String get playSummaryPrs;

  /// No description provided for @playPrWeight.
  ///
  /// In en, this message translates to:
  /// **'Heaviest'**
  String get playPrWeight;

  /// No description provided for @playPrReps.
  ///
  /// In en, this message translates to:
  /// **'Most reps'**
  String get playPrReps;

  /// No description provided for @playPrE1rm.
  ///
  /// In en, this message translates to:
  /// **'Best 1-rep max'**
  String get playPrE1rm;

  /// No description provided for @playSynced.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get playSynced;

  /// No description provided for @playQueued.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone. It uploads when you are back online.'**
  String get playQueued;

  /// No description provided for @playDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get playDone;

  /// No description provided for @playElapsed.
  ///
  /// In en, this message translates to:
  /// **'{time} elapsed'**
  String playElapsed(String time);

  /// No description provided for @playOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Works offline: your sets are saved on this phone.'**
  String get playOfflineHint;

  /// No description provided for @meTodayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get meTodayWorkout;

  /// No description provided for @meProgressWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts per week'**
  String get meProgressWorkouts;

  /// No description provided for @meProgressPrs.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get meProgressPrs;

  /// No description provided for @meNoPrs.
  ///
  /// In en, this message translates to:
  /// **'Lift a little more than last time to set your first record.'**
  String get meNoPrs;

  /// No description provided for @playSetsDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} sets done'**
  String playSetsDone(int done, int total);

  /// No description provided for @dashTrainingToday.
  ///
  /// In en, this message translates to:
  /// **'Training today'**
  String get dashTrainingToday;

  /// No description provided for @dashMissedWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Missed workouts'**
  String get dashMissedWorkouts;

  /// No description provided for @dashNoSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'No sessions planned today.'**
  String get dashNoSessionsToday;

  /// No description provided for @dashMissedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 missed this week} other{{count} missed this week}}'**
  String dashMissedCount(int count);

  /// No description provided for @wkEditWorkout.
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get wkEditWorkout;

  /// No description provided for @trainAreaWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get trainAreaWorkouts;

  /// No description provided for @trainAreaDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get trainAreaDiet;

  /// No description provided for @trainTabDiets.
  ///
  /// In en, this message translates to:
  /// **'Diet plans'**
  String get trainTabDiets;

  /// No description provided for @trainTabFoods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get trainTabFoods;

  /// No description provided for @dietNew.
  ///
  /// In en, this message translates to:
  /// **'New diet plan'**
  String get dietNew;

  /// No description provided for @foodAdd.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get foodAdd;

  /// No description provided for @dietEmptyMembersBody.
  ///
  /// In en, this message translates to:
  /// **'Members assigned to you show up here with their diet plan and how closely they follow it.'**
  String get dietEmptyMembersBody;

  /// No description provided for @dietNeverLogged.
  ///
  /// In en, this message translates to:
  /// **'No meals marked yet'**
  String get dietNeverLogged;

  /// No description provided for @dietLastLogged.
  ///
  /// In en, this message translates to:
  /// **'Last marked {date}'**
  String dietLastLogged(String date);

  /// No description provided for @dietTodayMarked.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} today'**
  String dietTodayMarked(int done, int total);

  /// No description provided for @dietMissedMeals.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 missed meal} other{{count} missed meals}}'**
  String dietMissedMeals(int count);

  /// No description provided for @dietHealthFlag.
  ///
  /// In en, this message translates to:
  /// **'Health condition'**
  String get dietHealthFlag;

  /// No description provided for @dietNoPlanShort.
  ///
  /// In en, this message translates to:
  /// **'No diet plan'**
  String get dietNoPlanShort;

  /// No description provided for @dietSearchPlans.
  ///
  /// In en, this message translates to:
  /// **'Search diet plans'**
  String get dietSearchPlans;

  /// No description provided for @dietPlansEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No diet plans'**
  String get dietPlansEmptyTitle;

  /// No description provided for @dietPlansEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another search, or build the gym\'s first plan.'**
  String get dietPlansEmptyBody;

  /// No description provided for @mealEarlyMorning.
  ///
  /// In en, this message translates to:
  /// **'Early morning'**
  String get mealEarlyMorning;

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealMidMorning.
  ///
  /// In en, this message translates to:
  /// **'Mid-morning'**
  String get mealMidMorning;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealEveningSnack.
  ///
  /// In en, this message translates to:
  /// **'Evening snack'**
  String get mealEveningSnack;

  /// No description provided for @mealPreWorkout.
  ///
  /// In en, this message translates to:
  /// **'Pre-workout'**
  String get mealPreWorkout;

  /// No description provided for @mealPostWorkout.
  ///
  /// In en, this message translates to:
  /// **'Post-workout'**
  String get mealPostWorkout;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @mealBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get mealBedtime;

  /// No description provided for @foodCatGrains.
  ///
  /// In en, this message translates to:
  /// **'Grains & breads'**
  String get foodCatGrains;

  /// No description provided for @foodCatPulses.
  ///
  /// In en, this message translates to:
  /// **'Dals & pulses'**
  String get foodCatPulses;

  /// No description provided for @foodCatVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get foodCatVegetables;

  /// No description provided for @foodCatFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get foodCatFruits;

  /// No description provided for @foodCatDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get foodCatDairy;

  /// No description provided for @foodCatEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get foodCatEggs;

  /// No description provided for @foodCatMeatFish.
  ///
  /// In en, this message translates to:
  /// **'Meat & fish'**
  String get foodCatMeatFish;

  /// No description provided for @foodCatNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts & seeds'**
  String get foodCatNuts;

  /// No description provided for @foodCatSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get foodCatSnacks;

  /// No description provided for @foodCatSweets.
  ///
  /// In en, this message translates to:
  /// **'Sweets'**
  String get foodCatSweets;

  /// No description provided for @foodCatDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get foodCatDrinks;

  /// No description provided for @foodCatFats.
  ///
  /// In en, this message translates to:
  /// **'Ghee & oils'**
  String get foodCatFats;

  /// No description provided for @foodCatCondiments.
  ///
  /// In en, this message translates to:
  /// **'Chutneys & extras'**
  String get foodCatCondiments;

  /// No description provided for @foodCatSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get foodCatSupplements;

  /// No description provided for @vegVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegVegan;

  /// No description provided for @vegVeg.
  ///
  /// In en, this message translates to:
  /// **'Veg'**
  String get vegVeg;

  /// No description provided for @vegEgg.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get vegEgg;

  /// No description provided for @vegNonVeg.
  ///
  /// In en, this message translates to:
  /// **'Non-veg'**
  String get vegNonVeg;

  /// No description provided for @prefVeg.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get prefVeg;

  /// No description provided for @prefEggetarian.
  ///
  /// In en, this message translates to:
  /// **'Eggetarian'**
  String get prefEggetarian;

  /// No description provided for @prefNonVeg.
  ///
  /// In en, this message translates to:
  /// **'Non-vegetarian'**
  String get prefNonVeg;

  /// No description provided for @prefVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get prefVegan;

  /// No description provided for @prefJain.
  ///
  /// In en, this message translates to:
  /// **'Jain'**
  String get prefJain;

  /// No description provided for @prefAny.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get prefAny;

  /// No description provided for @dietGoalFatLoss.
  ///
  /// In en, this message translates to:
  /// **'Fat loss'**
  String get dietGoalFatLoss;

  /// No description provided for @dietGoalMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get dietGoalMuscleGain;

  /// No description provided for @dietGoalMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get dietGoalMaintenance;

  /// No description provided for @presetHighProtein.
  ///
  /// In en, this message translates to:
  /// **'High protein'**
  String get presetHighProtein;

  /// No description provided for @presetKetoLight.
  ///
  /// In en, this message translates to:
  /// **'Keto-light'**
  String get presetKetoLight;

  /// No description provided for @presetBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get presetBalanced;

  /// No description provided for @allergyDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get allergyDairy;

  /// No description provided for @allergyGluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get allergyGluten;

  /// No description provided for @allergyNuts.
  ///
  /// In en, this message translates to:
  /// **'Tree nuts'**
  String get allergyNuts;

  /// No description provided for @allergyPeanut.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get allergyPeanut;

  /// No description provided for @allergySoy.
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get allergySoy;

  /// No description provided for @allergyEgg.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get allergyEgg;

  /// No description provided for @allergyFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get allergyFish;

  /// No description provided for @allergyShellfish.
  ///
  /// In en, this message translates to:
  /// **'Shellfish'**
  String get allergyShellfish;

  /// No description provided for @allergySesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get allergySesame;

  /// No description provided for @conflictPref.
  ///
  /// In en, this message translates to:
  /// **'Not {pref}'**
  String conflictPref(String pref);

  /// No description provided for @conflictAllergy.
  ///
  /// In en, this message translates to:
  /// **'Contains {allergen}'**
  String conflictAllergy(String allergen);

  /// No description provided for @conflictAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoids {word}'**
  String conflictAvoid(String word);

  /// No description provided for @allergicTo.
  ///
  /// In en, this message translates to:
  /// **'Allergic to {allergen}'**
  String allergicTo(String allergen);

  /// No description provided for @avoids.
  ///
  /// In en, this message translates to:
  /// **'Avoids {food}'**
  String avoids(String food);

  /// No description provided for @unitKatori.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{katori} other{katori}}'**
  String unitKatori(int count);

  /// No description provided for @unitRoti.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{roti} other{rotis}}'**
  String unitRoti(int count);

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{piece} other{pieces}}'**
  String unitPiece(int count);

  /// No description provided for @unitGlass.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{glass} other{glasses}}'**
  String unitGlass(int count);

  /// No description provided for @unitCup.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{cup} other{cups}}'**
  String unitCup(int count);

  /// No description provided for @unitBowl.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{bowl} other{bowls}}'**
  String unitBowl(int count);

  /// No description provided for @unitPlate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{plate} other{plates}}'**
  String unitPlate(int count);

  /// No description provided for @unitSlice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{slice} other{slices}}'**
  String unitSlice(int count);

  /// No description provided for @unitTbsp.
  ///
  /// In en, this message translates to:
  /// **'tbsp'**
  String get unitTbsp;

  /// No description provided for @unitTsp.
  ///
  /// In en, this message translates to:
  /// **'tsp'**
  String get unitTsp;

  /// No description provided for @unitScoop.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{scoop} other{scoops}}'**
  String unitScoop(int count);

  /// No description provided for @unitHandful.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{handful} other{handfuls}}'**
  String unitHandful(int count);

  /// No description provided for @dietCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get dietCalories;

  /// No description provided for @dietProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get dietProtein;

  /// No description provided for @dietCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get dietCarbs;

  /// No description provided for @dietFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get dietFat;

  /// No description provided for @dietP.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get dietP;

  /// No description provided for @dietC.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get dietC;

  /// No description provided for @dietF.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dietF;

  /// No description provided for @dietProteinG.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get dietProteinG;

  /// No description provided for @dietCarbsG.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get dietCarbsG;

  /// No description provided for @dietFatG.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get dietFatG;

  /// No description provided for @dietFibreG.
  ///
  /// In en, this message translates to:
  /// **'Fibre (g)'**
  String get dietFibreG;

  /// No description provided for @foodSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search {count} foods'**
  String foodSearchHint(int count);

  /// No description provided for @foodSuits.
  ///
  /// In en, this message translates to:
  /// **'Suits {pref}'**
  String foodSuits(String pref);

  /// No description provided for @foodNotReviewed.
  ///
  /// In en, this message translates to:
  /// **'Not reviewed'**
  String get foodNotReviewed;

  /// No description provided for @foodNotReviewedCount.
  ///
  /// In en, this message translates to:
  /// **'Not reviewed ({count})'**
  String foodNotReviewedCount(int count);

  /// No description provided for @foodReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get foodReviewed;

  /// No description provided for @foodCustom.
  ///
  /// In en, this message translates to:
  /// **'Gym\'s own'**
  String get foodCustom;

  /// No description provided for @foodEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No foods match'**
  String get foodEmptyTitle;

  /// No description provided for @foodEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another word or clear the filters.'**
  String get foodEmptyBody;

  /// No description provided for @foodPerServing.
  ///
  /// In en, this message translates to:
  /// **'Per {serving}'**
  String foodPerServing(String serving);

  /// No description provided for @foodFibre.
  ///
  /// In en, this message translates to:
  /// **'Fibre {grams} g'**
  String foodFibre(String grams);

  /// No description provided for @foodPer100.
  ///
  /// In en, this message translates to:
  /// **'Per 100 g: {kcal} kcal, {protein} g protein'**
  String foodPer100(int kcal, String protein);

  /// No description provided for @foodAllergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get foodAllergens;

  /// No description provided for @foodToBuy.
  ///
  /// In en, this message translates to:
  /// **'To buy for one serving'**
  String get foodToBuy;

  /// No description provided for @foodJainOk.
  ///
  /// In en, this message translates to:
  /// **'Jain-friendly'**
  String get foodJainOk;

  /// No description provided for @foodJainHint.
  ///
  /// In en, this message translates to:
  /// **'No onion, garlic or root vegetables'**
  String get foodJainHint;

  /// No description provided for @foodMarkReviewed.
  ///
  /// In en, this message translates to:
  /// **'Mark as reviewed'**
  String get foodMarkReviewed;

  /// No description provided for @foodReviewedDone.
  ///
  /// In en, this message translates to:
  /// **'Marked as reviewed'**
  String get foodReviewedDone;

  /// No description provided for @foodEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit values'**
  String get foodEdit;

  /// No description provided for @foodRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get foodRemove;

  /// No description provided for @foodRemoved.
  ///
  /// In en, this message translates to:
  /// **'Food removed'**
  String get foodRemoved;

  /// No description provided for @foodNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New food'**
  String get foodNewTitle;

  /// No description provided for @foodEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit food'**
  String get foodEditTitle;

  /// No description provided for @foodSaved.
  ///
  /// In en, this message translates to:
  /// **'Food saved'**
  String get foodSaved;

  /// No description provided for @foodSaveReviewed.
  ///
  /// In en, this message translates to:
  /// **'Save and mark reviewed'**
  String get foodSaveReviewed;

  /// No description provided for @foodReviewHint.
  ///
  /// In en, this message translates to:
  /// **'These values came with the app and haven\'t been checked yet. Correct anything that\'s off for how the gym\'s members cook it, then save to mark it reviewed.'**
  String get foodReviewHint;

  /// No description provided for @foodFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get foodFieldName;

  /// No description provided for @foodFieldLocalName.
  ///
  /// In en, this message translates to:
  /// **'Hindi name'**
  String get foodFieldLocalName;

  /// No description provided for @foodFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Food group'**
  String get foodFieldCategory;

  /// No description provided for @foodFieldServing.
  ///
  /// In en, this message translates to:
  /// **'Measured in'**
  String get foodFieldServing;

  /// No description provided for @foodFieldGrams.
  ///
  /// In en, this message translates to:
  /// **'Grams in one {unit}'**
  String foodFieldGrams(String unit);

  /// No description provided for @foodFieldVeg.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get foodFieldVeg;

  /// No description provided for @foodValuesPer100.
  ///
  /// In en, this message translates to:
  /// **'Values per 100 {unit}'**
  String foodValuesPer100(String unit);

  /// No description provided for @foodValuesPerServing.
  ///
  /// In en, this message translates to:
  /// **'Values per {unit}'**
  String foodValuesPerServing(String unit);

  /// No description provided for @foodBadNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number in range'**
  String get foodBadNumber;

  /// No description provided for @foodMismatch.
  ///
  /// In en, this message translates to:
  /// **'Protein, carbs and fat add up to about {kcal} kcal. Check the calories.'**
  String foodMismatch(int kcal);

  /// No description provided for @dietPlan.
  ///
  /// In en, this message translates to:
  /// **'Diet plan'**
  String get dietPlan;

  /// No description provided for @dietMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get dietMeals;

  /// No description provided for @dietMealsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meal} other{{count} meals}}'**
  String dietMealsCount(int count);

  /// No description provided for @dietFoodsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 food} other{{count} foods}}'**
  String dietFoodsCount(int count);

  /// No description provided for @dietOr.
  ///
  /// In en, this message translates to:
  /// **'Or option {group}'**
  String dietOr(int group);

  /// No description provided for @dietSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get dietSupplements;

  /// No description provided for @dietDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This plan is general guidance, not medical advice. If you have a medical condition, are pregnant or take medicines, check with your doctor before changing what you eat.'**
  String get dietDisclaimer;

  /// No description provided for @dietPlannedVsTarget.
  ///
  /// In en, this message translates to:
  /// **'Planned vs target'**
  String get dietPlannedVsTarget;

  /// No description provided for @dietAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign diet'**
  String get dietAssign;

  /// No description provided for @dietDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate & scale'**
  String get dietDuplicate;

  /// No description provided for @dietDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate and scale'**
  String get dietDuplicateTitle;

  /// No description provided for @dietDuplicateKcal.
  ///
  /// In en, this message translates to:
  /// **'Calories a day for the copy'**
  String get dietDuplicateKcal;

  /// No description provided for @dietKcalRange.
  ///
  /// In en, this message translates to:
  /// **'Calories must be between 800 and 6,000 a day'**
  String get dietKcalRange;

  /// No description provided for @dietRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String dietRemoveTitle(String name);

  /// No description provided for @dietRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'It disappears from the library. Members already on it keep their own copy.'**
  String get dietRemoveBody;

  /// No description provided for @dietRemoved.
  ///
  /// In en, this message translates to:
  /// **'Plan removed'**
  String get dietRemoved;

  /// No description provided for @medicalFlagTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} has a health condition'**
  String medicalFlagTitle(String name);

  /// No description provided for @medicalFlagBody.
  ///
  /// In en, this message translates to:
  /// **'Check the plan suits them, and ask them to clear diet changes with their doctor.'**
  String get medicalFlagBody;

  /// No description provided for @dietNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New diet plan'**
  String get dietNewTitle;

  /// No description provided for @dietEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit diet plan'**
  String get dietEditTitle;

  /// No description provided for @dietEditFor.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s plan'**
  String dietEditFor(String name);

  /// No description provided for @dietSaved.
  ///
  /// In en, this message translates to:
  /// **'Diet plan saved'**
  String get dietSaved;

  /// No description provided for @dietNeedsFoods.
  ///
  /// In en, this message translates to:
  /// **'Add a food to each meal, or remove the empty ones.'**
  String get dietNeedsFoods;

  /// No description provided for @dietConflictsPlan.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 food isn\'t {pref}} other{{count} foods aren\'t {pref}}}'**
  String dietConflictsPlan(int count, String pref);

  /// No description provided for @dietConflictsMember.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 food doesn\'t suit {name}} other{{count} foods don\'t suit {name}}}'**
  String dietConflictsMember(int count, String name);

  /// No description provided for @dietTargets.
  ///
  /// In en, this message translates to:
  /// **'Daily targets'**
  String get dietTargets;

  /// No description provided for @dietScaleToTarget.
  ///
  /// In en, this message translates to:
  /// **'Scale foods to {kcal} kcal'**
  String dietScaleToTarget(String kcal);

  /// No description provided for @dietPreference.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get dietPreference;

  /// No description provided for @dietAddSupplement.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get dietAddSupplement;

  /// No description provided for @dietSupplementName.
  ///
  /// In en, this message translates to:
  /// **'Supplement name'**
  String get dietSupplementName;

  /// No description provided for @dietAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Add a meal'**
  String get dietAddMeal;

  /// No description provided for @dietAddFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get dietAddFood;

  /// No description provided for @dietAddFoods.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Pick foods} =1{Add 1 food} other{Add {count} foods}}'**
  String dietAddFoods(int count);

  /// No description provided for @dietLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get dietLess;

  /// No description provided for @dietMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get dietMore;

  /// No description provided for @dietAmountGrams.
  ///
  /// In en, this message translates to:
  /// **'Amount in grams'**
  String get dietAmountGrams;

  /// No description provided for @dietAmountServings.
  ///
  /// In en, this message translates to:
  /// **'Number of servings'**
  String get dietAmountServings;

  /// No description provided for @dietSetTime.
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get dietSetTime;

  /// No description provided for @dietRemoveMeal.
  ///
  /// In en, this message translates to:
  /// **'Remove meal'**
  String get dietRemoveMeal;

  /// No description provided for @dietRemoveOption.
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get dietRemoveOption;

  /// No description provided for @dietSuggestOption.
  ///
  /// In en, this message translates to:
  /// **'Suggest an option'**
  String get dietSuggestOption;

  /// No description provided for @dietAddOption.
  ///
  /// In en, this message translates to:
  /// **'Add an option'**
  String get dietAddOption;

  /// No description provided for @dietMealNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes for this meal'**
  String get dietMealNotes;

  /// No description provided for @targetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Targets calculator'**
  String get targetsTitle;

  /// No description provided for @targetsBody.
  ///
  /// In en, this message translates to:
  /// **'From BMR (Mifflin-St Jeor) and daily activity: a starting point to adjust as they progress.'**
  String get targetsBody;

  /// No description provided for @targetsCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get targetsCalculate;

  /// No description provided for @targetsGender.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get targetsGender;

  /// No description provided for @targetsAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get targetsAge;

  /// No description provided for @targetsHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get targetsHeight;

  /// No description provided for @targetsWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get targetsWeight;

  /// No description provided for @targetsActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get targetsActivity;

  /// No description provided for @targetsGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get targetsGoal;

  /// No description provided for @targetsPreset.
  ///
  /// In en, this message translates to:
  /// **'Macro split'**
  String get targetsPreset;

  /// No description provided for @targetsProteinPerKg.
  ///
  /// In en, this message translates to:
  /// **'Protein per kg body weight'**
  String get targetsProteinPerKg;

  /// No description provided for @targetsNeedProfile.
  ///
  /// In en, this message translates to:
  /// **'Enter age, height and weight to calculate.'**
  String get targetsNeedProfile;

  /// No description provided for @targetsBmrTdee.
  ///
  /// In en, this message translates to:
  /// **'BMR {bmr} kcal · maintenance {tdee} kcal'**
  String targetsBmrTdee(String bmr, String tdee);

  /// No description provided for @targetsUse.
  ///
  /// In en, this message translates to:
  /// **'Use these targets'**
  String get targetsUse;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get activitySedentary;

  /// No description provided for @activityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly active'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get activityModerate;

  /// No description provided for @activityActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get activityActive;

  /// No description provided for @activityAthlete.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get activityAthlete;

  /// No description provided for @dietPickPlan.
  ///
  /// In en, this message translates to:
  /// **'Pick a diet plan'**
  String get dietPickPlan;

  /// No description provided for @dietAssignReplaces.
  ///
  /// In en, this message translates to:
  /// **'From the start date it replaces their current diet plan. Earlier plans stay in their history.'**
  String get dietAssignReplaces;

  /// No description provided for @assignHealthWarning.
  ///
  /// In en, this message translates to:
  /// **'{name}: {conditions}. Check the plan suits them.'**
  String assignHealthWarning(String name, String conditions);

  /// No description provided for @assignFoodsWarning.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{name}: 1 food doesn\'t suit their preferences} other{{name}: {count} foods don\'t suit their preferences}}'**
  String assignFoodsWarning(int count, String name);

  /// No description provided for @dietPrivate.
  ///
  /// In en, this message translates to:
  /// **'Diet plans and logs are private: only the member\'s trainer and the owner can see them.'**
  String get dietPrivate;

  /// No description provided for @dietNoPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'No diet plan yet'**
  String get dietNoPlanTitle;

  /// No description provided for @dietNoPlanStaffBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a plan from the library and adjust it to their targets.'**
  String get dietNoPlanStaffBody;

  /// No description provided for @dietNoPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Your trainer will add one. You can still track water.'**
  String get dietNoPlanBody;

  /// No description provided for @dietNoPlanThatDay.
  ///
  /// In en, this message translates to:
  /// **'There was no plan on this day.'**
  String get dietNoPlanThatDay;

  /// No description provided for @dietStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get dietStatusActive;

  /// No description provided for @dietStatusQueued.
  ///
  /// In en, this message translates to:
  /// **'Starts later'**
  String get dietStatusQueued;

  /// No description provided for @dietStatusReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get dietStatusReplaced;

  /// No description provided for @dietStatusEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get dietStatusEnded;

  /// No description provided for @dietStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String dietStarts(String date);

  /// No description provided for @dietSince.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String dietSince(String date);

  /// No description provided for @dietTune.
  ///
  /// In en, this message translates to:
  /// **'Adjust their plan'**
  String get dietTune;

  /// No description provided for @dietEnd.
  ///
  /// In en, this message translates to:
  /// **'End plan'**
  String get dietEnd;

  /// No description provided for @dietEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End {name}?'**
  String dietEndTitle(String name);

  /// No description provided for @dietEndBody.
  ///
  /// In en, this message translates to:
  /// **'The member stops seeing this plan. What they logged stays.'**
  String get dietEndBody;

  /// No description provided for @dietEnded.
  ///
  /// In en, this message translates to:
  /// **'Plan ended'**
  String get dietEnded;

  /// No description provided for @dietToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dietToday;

  /// No description provided for @dietHistory.
  ///
  /// In en, this message translates to:
  /// **'Earlier plans'**
  String get dietHistory;

  /// No description provided for @dietWeeklyAdherence.
  ///
  /// In en, this message translates to:
  /// **'On plan, week by week'**
  String get dietWeeklyAdherence;

  /// No description provided for @dietThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get dietThisWeek;

  /// No description provided for @dietAdherence.
  ///
  /// In en, this message translates to:
  /// **'Meals on plan'**
  String get dietAdherence;

  /// No description provided for @dietWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Weight {min}–{max} kg'**
  String dietWeightRange(String min, String max);

  /// No description provided for @dietCoachNotes.
  ///
  /// In en, this message translates to:
  /// **'Coach notes'**
  String get dietCoachNotes;

  /// No description provided for @dietNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get dietNoNotes;

  /// No description provided for @dietAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note for the member'**
  String get dietAddNote;

  /// No description provided for @waterAverage.
  ///
  /// In en, this message translates to:
  /// **'Water {avg} of {goal} a day'**
  String waterAverage(String avg, int goal);

  /// No description provided for @prefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Food preferences'**
  String get prefsTitle;

  /// No description provided for @prefsAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get prefsAllergies;

  /// No description provided for @prefsAvoid.
  ///
  /// In en, this message translates to:
  /// **'Foods to avoid'**
  String get prefsAvoid;

  /// No description provided for @prefsAvoidHint.
  ///
  /// In en, this message translates to:
  /// **'Foods to avoid, separated by commas'**
  String get prefsAvoidHint;

  /// No description provided for @prefsSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get prefsSaved;

  /// No description provided for @dietDayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dietDayToday;

  /// No description provided for @dietDayYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dietDayYesterday;

  /// No description provided for @dietNewPlan.
  ///
  /// In en, this message translates to:
  /// **'New plan from your coach: {name}'**
  String dietNewPlan(String name);

  /// No description provided for @dietStartsOn.
  ///
  /// In en, this message translates to:
  /// **'{name} starts {date}'**
  String dietStartsOn(String name, String date);

  /// No description provided for @dietWeekOnPlan.
  ///
  /// In en, this message translates to:
  /// **'{percent}% this week'**
  String dietWeekOnPlan(int percent);

  /// No description provided for @dietMarkedOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} meals marked'**
  String dietMarkedOf(int done, int total);

  /// No description provided for @dietAllMarked.
  ///
  /// In en, this message translates to:
  /// **'All meals marked today'**
  String get dietAllMarked;

  /// No description provided for @dietNextMeal.
  ///
  /// In en, this message translates to:
  /// **'Next: {meal} at {time}'**
  String dietNextMeal(String meal, String time);

  /// No description provided for @meTodayMeals.
  ///
  /// In en, this message translates to:
  /// **'Today\'s meals'**
  String get meTodayMeals;

  /// No description provided for @markEaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get markEaten;

  /// No description provided for @markPartly.
  ///
  /// In en, this message translates to:
  /// **'Partly'**
  String get markPartly;

  /// No description provided for @markSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get markSkipped;

  /// No description provided for @markSwapped.
  ///
  /// In en, this message translates to:
  /// **'Swapped'**
  String get markSwapped;

  /// No description provided for @markSwappedTo.
  ///
  /// In en, this message translates to:
  /// **'Swapped: {option}'**
  String markSwappedTo(String option);

  /// No description provided for @markClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get markClear;

  /// No description provided for @waterTitle.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get waterTitle;

  /// No description provided for @waterGlasses.
  ///
  /// In en, this message translates to:
  /// **'{glasses} of {goal} glasses'**
  String waterGlasses(int glasses, int goal);

  /// No description provided for @waterGoalHint.
  ///
  /// In en, this message translates to:
  /// **'One glass is 250 ml. Your goal comes from your weight.'**
  String get waterGoalHint;

  /// No description provided for @waterAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a glass'**
  String get waterAdd;

  /// No description provided for @waterRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove a glass'**
  String get waterRemove;

  /// No description provided for @remindersOn.
  ///
  /// In en, this message translates to:
  /// **'Remind me at meal times'**
  String get remindersOn;

  /// No description provided for @remindersOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off meal reminders'**
  String get remindersOff;

  /// No description provided for @remindersOnDone.
  ///
  /// In en, this message translates to:
  /// **'Meal reminders on'**
  String get remindersOnDone;

  /// No description provided for @remindersOffDone.
  ///
  /// In en, this message translates to:
  /// **'Meal reminders off'**
  String get remindersOffDone;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for {meal}'**
  String reminderTitle(String meal);

  /// No description provided for @groceryTitle.
  ///
  /// In en, this message translates to:
  /// **'Grocery list'**
  String get groceryTitle;

  /// No description provided for @groceryFor7Days.
  ///
  /// In en, this message translates to:
  /// **'For 7 days of the plan as written (not the \"or\" options).'**
  String get groceryFor7Days;

  /// No description provided for @groceryShare.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get groceryShare;

  /// No description provided for @dietPlanName.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get dietPlanName;

  /// No description provided for @exPauseMotion.
  ///
  /// In en, this message translates to:
  /// **'Tap to pause'**
  String get exPauseMotion;

  /// No description provided for @exPlayMotion.
  ///
  /// In en, this message translates to:
  /// **'Tap to play'**
  String get exPlayMotion;

  /// No description provided for @bulkWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get bulkWhatsApp;

  /// No description provided for @waTitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get waTitle;

  /// No description provided for @waMoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s messages, broadcasts and templates'**
  String get waMoreSubtitle;

  /// No description provided for @waTabQueue.
  ///
  /// In en, this message translates to:
  /// **'To send'**
  String get waTabQueue;

  /// No description provided for @waTabLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get waTabLog;

  /// No description provided for @waTabBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'Broadcasts'**
  String get waTabBroadcasts;

  /// No description provided for @waModeFree.
  ///
  /// In en, this message translates to:
  /// **'Free mode'**
  String get waModeFree;

  /// No description provided for @waModeApi.
  ///
  /// In en, this message translates to:
  /// **'API mode'**
  String get waModeApi;

  /// No description provided for @waModeFreeBody.
  ///
  /// In en, this message translates to:
  /// **'Each message opens in your WhatsApp, ready to send.'**
  String get waModeFreeBody;

  /// No description provided for @waModeApiBody.
  ///
  /// In en, this message translates to:
  /// **'Approved templates send automatically.'**
  String get waModeApiBody;

  /// No description provided for @waNewBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get waNewBroadcast;

  /// No description provided for @waQueueLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All sent} =1{1 to send} other{{count} to send}}'**
  String waQueueLeft(int count);

  /// No description provided for @waQueueLeftMore.
  ///
  /// In en, this message translates to:
  /// **'{count}+ to send'**
  String waQueueLeftMore(int count);

  /// No description provided for @waSendNext.
  ///
  /// In en, this message translates to:
  /// **'Send to {name} · {left} left'**
  String waSendNext(String name, int left);

  /// No description provided for @waSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get waSend;

  /// No description provided for @waSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get waSkip;

  /// No description provided for @waMarkSent.
  ///
  /// In en, this message translates to:
  /// **'Mark sent'**
  String get waMarkSent;

  /// No description provided for @waMarkedSent.
  ///
  /// In en, this message translates to:
  /// **'Ticked: sent to {name}'**
  String waMarkedSent(String name);

  /// No description provided for @waMarkedSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped {name}'**
  String waMarkedSkipped(String name);

  /// No description provided for @waQueueEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to send'**
  String get waQueueEmptyTitle;

  /// No description provided for @waQueueEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s reminders, wishes and receipts show up here, ready to send one by one.'**
  String get waQueueEmptyBody;

  /// No description provided for @waBuildToday.
  ///
  /// In en, this message translates to:
  /// **'Check for today\'s reminders'**
  String get waBuildToday;

  /// No description provided for @waBuilt.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No new reminders} =1{1 new reminder} other{{count} new reminders}}'**
  String waBuilt(int count);

  /// No description provided for @waNoWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open WhatsApp on this device.'**
  String get waNoWhatsApp;

  /// No description provided for @waApiQueueNote.
  ///
  /// In en, this message translates to:
  /// **'API mode is on. These are messages the API couldn\'t send: send them by hand.'**
  String get waApiQueueNote;

  /// No description provided for @waSendNow.
  ///
  /// In en, this message translates to:
  /// **'Send now'**
  String get waSendNow;

  /// No description provided for @waSendNowDone.
  ///
  /// In en, this message translates to:
  /// **'Sending the due messages'**
  String get waSendNowDone;

  /// No description provided for @waLogAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get waLogAll;

  /// No description provided for @waLogQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get waLogQueued;

  /// No description provided for @waLogSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get waLogSent;

  /// No description provided for @waLogProblems.
  ///
  /// In en, this message translates to:
  /// **'Problems'**
  String get waLogProblems;

  /// No description provided for @waLogSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get waLogSkipped;

  /// No description provided for @waStatusQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get waStatusQueued;

  /// No description provided for @waStatusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get waStatusSending;

  /// No description provided for @waStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get waStatusSent;

  /// No description provided for @waStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get waStatusDelivered;

  /// No description provided for @waStatusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get waStatusRead;

  /// No description provided for @waStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get waStatusFailed;

  /// No description provided for @waStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get waStatusSkipped;

  /// No description provided for @waStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get waStatusCancelled;

  /// No description provided for @waChannelLink.
  ///
  /// In en, this message translates to:
  /// **'By hand'**
  String get waChannelLink;

  /// No description provided for @waChannelApi.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get waChannelApi;

  /// No description provided for @waFreeWindow.
  ///
  /// In en, this message translates to:
  /// **'Free: the member wrote in the last 24 hours'**
  String get waFreeWindow;

  /// No description provided for @waLogEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get waLogEmptyTitle;

  /// No description provided for @waLogEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Every WhatsApp message to members is listed here with its status.'**
  String get waLogEmptyBody;

  /// No description provided for @waMemberMessages.
  ///
  /// In en, this message translates to:
  /// **'Message log'**
  String get waMemberMessages;

  /// No description provided for @waMemberMessagesOf.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s messages'**
  String waMemberMessagesOf(String name);

  /// No description provided for @waKeyExpirySoon.
  ///
  /// In en, this message translates to:
  /// **'Membership ending soon'**
  String get waKeyExpirySoon;

  /// No description provided for @waKeyExpiryToday.
  ///
  /// In en, this message translates to:
  /// **'Membership ends today'**
  String get waKeyExpiryToday;

  /// No description provided for @waKeyExpired.
  ///
  /// In en, this message translates to:
  /// **'Membership ended'**
  String get waKeyExpired;

  /// No description provided for @waKeyDues.
  ///
  /// In en, this message translates to:
  /// **'Fee reminder'**
  String get waKeyDues;

  /// No description provided for @waKeyPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get waKeyPayment;

  /// No description provided for @waKeyMembershipStarted.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get waKeyMembershipStarted;

  /// No description provided for @waKeyMembershipRenewed.
  ///
  /// In en, this message translates to:
  /// **'Renewal thanks'**
  String get waKeyMembershipRenewed;

  /// No description provided for @waKeyProgram.
  ///
  /// In en, this message translates to:
  /// **'New workout program'**
  String get waKeyProgram;

  /// No description provided for @waKeyDiet.
  ///
  /// In en, this message translates to:
  /// **'New diet plan'**
  String get waKeyDiet;

  /// No description provided for @waKeyBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday wishes'**
  String get waKeyBirthday;

  /// No description provided for @waKeyFestival.
  ///
  /// In en, this message translates to:
  /// **'Festival wishes'**
  String get waKeyFestival;

  /// No description provided for @waKeyManual.
  ///
  /// In en, this message translates to:
  /// **'Sent by hand'**
  String get waKeyManual;

  /// No description provided for @waKeyBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get waKeyBroadcast;

  /// No description provided for @waTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp today'**
  String get waTodayTitle;

  /// No description provided for @waTodayBody.
  ///
  /// In en, this message translates to:
  /// **'{toSend} to send · {sent} sent'**
  String waTodayBody(int toSend, int sent);

  /// No description provided for @waTodayAllDone.
  ///
  /// In en, this message translates to:
  /// **'All of today\'s messages are sent.'**
  String get waTodayAllDone;

  /// No description provided for @waBroadcastTitle.
  ///
  /// In en, this message translates to:
  /// **'New broadcast'**
  String get waBroadcastTitle;

  /// No description provided for @waBroadcastName.
  ///
  /// In en, this message translates to:
  /// **'Title (only staff see it)'**
  String get waBroadcastName;

  /// No description provided for @waBroadcastMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get waBroadcastMessage;

  /// No description provided for @waInsertVariable.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a detail that changes per member:'**
  String get waInsertVariable;

  /// No description provided for @waCategory.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get waCategory;

  /// No description provided for @waCategoryMarketing.
  ///
  /// In en, this message translates to:
  /// **'Offer or wishes'**
  String get waCategoryMarketing;

  /// No description provided for @waCategoryUtility.
  ///
  /// In en, this message translates to:
  /// **'Gym update'**
  String get waCategoryUtility;

  /// No description provided for @waCategoryHelp.
  ///
  /// In en, this message translates to:
  /// **'Gym updates (timings, closures) are utility messages. Offers and wishes are marketing: each member gets at most one a day.'**
  String get waCategoryHelp;

  /// No description provided for @waSegment.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get waSegment;

  /// No description provided for @waSegAll.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get waSegAll;

  /// No description provided for @waSegActive.
  ///
  /// In en, this message translates to:
  /// **'Active members'**
  String get waSegActive;

  /// No description provided for @waSegExpiring.
  ///
  /// In en, this message translates to:
  /// **'Ending in 7 days'**
  String get waSegExpiring;

  /// No description provided for @waSegExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired 30–90 days ago'**
  String get waSegExpired;

  /// No description provided for @waSegDues.
  ///
  /// In en, this message translates to:
  /// **'With fees due'**
  String get waSegDues;

  /// No description provided for @waSegTrainer.
  ///
  /// In en, this message translates to:
  /// **'A trainer\'s members'**
  String get waSegTrainer;

  /// No description provided for @waSegTrainerNamed.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s members'**
  String waSegTrainerNamed(String name);

  /// No description provided for @waSegBatch.
  ///
  /// In en, this message translates to:
  /// **'A batch'**
  String get waSegBatch;

  /// No description provided for @waSegMembers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected member} other{{count} selected members}}'**
  String waSegMembers(int count);

  /// No description provided for @waReach.
  ///
  /// In en, this message translates to:
  /// **'{reachable} of {total} members get it'**
  String waReach(int reachable, int total);

  /// No description provided for @waReachNote.
  ///
  /// In en, this message translates to:
  /// **'Members who turned WhatsApp off, or never agreed to it, are skipped.'**
  String get waReachNote;

  /// No description provided for @waSchedule.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get waSchedule;

  /// No description provided for @waScheduleNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get waScheduleNow;

  /// No description provided for @waSchedulePick.
  ///
  /// In en, this message translates to:
  /// **'Pick a day'**
  String get waSchedulePick;

  /// No description provided for @waScheduleOn.
  ///
  /// In en, this message translates to:
  /// **'{date}, 9:00 am'**
  String waScheduleOn(String date);

  /// No description provided for @waPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get waPreview;

  /// No description provided for @waPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your message shows here as members will see it.'**
  String get waPreviewEmpty;

  /// No description provided for @waSampleName.
  ///
  /// In en, this message translates to:
  /// **'Riya'**
  String get waSampleName;

  /// No description provided for @waQueueBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Queue messages'**
  String get waQueueBroadcast;

  /// No description provided for @waQueueBroadcastN.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No one to send to} =1{Queue 1 message} other{Queue {count} messages}}'**
  String waQueueBroadcastN(int count);

  /// No description provided for @waBroadcastQueued.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No one to send to} =1{1 message queued} other{{count} messages queued}}'**
  String waBroadcastQueued(int count);

  /// No description provided for @waBroadcastSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count} skipped'**
  String waBroadcastSkipped(int count);

  /// No description provided for @waBroadcastDone.
  ///
  /// In en, this message translates to:
  /// **'{queued} queued · {skipped} skipped'**
  String waBroadcastDone(int queued, int skipped);

  /// No description provided for @waBroadcastsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No broadcasts yet'**
  String get waBroadcastsEmptyTitle;

  /// No description provided for @waBroadcastsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Send one message to a group: new timings, a holiday, an offer.'**
  String get waBroadcastsEmptyBody;

  /// No description provided for @waNeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a name'**
  String get waNeedTitle;

  /// No description provided for @waNeedMessage.
  ///
  /// In en, this message translates to:
  /// **'Write the message'**
  String get waNeedMessage;

  /// No description provided for @waTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get waTemplatesTitle;

  /// No description provided for @waTemplatesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No templates'**
  String get waTemplatesEmptyTitle;

  /// No description provided for @waTemplatesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'The automatic messages appear here once the database is set up.'**
  String get waTemplatesEmptyBody;

  /// No description provided for @waTemplateReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the owner can change templates.'**
  String get waTemplateReadOnly;

  /// No description provided for @waTemplateEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get waTemplateEnglish;

  /// No description provided for @waTemplateHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get waTemplateHindi;

  /// No description provided for @waTemplateOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get waTemplateOff;

  /// No description provided for @waTemplateUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility'**
  String get waTemplateUtility;

  /// No description provided for @waTemplateMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get waTemplateMarketing;

  /// No description provided for @waTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get waTemplateTitle;

  /// No description provided for @waTemplateText.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get waTemplateText;

  /// No description provided for @waTemplatePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview with a sample member'**
  String get waTemplatePreview;

  /// No description provided for @waTemplateEnabled.
  ///
  /// In en, this message translates to:
  /// **'Send this message'**
  String get waTemplateEnabled;

  /// No description provided for @waTemplateMetaName.
  ///
  /// In en, this message translates to:
  /// **'Meta template name (API mode)'**
  String get waTemplateMetaName;

  /// No description provided for @waTemplateMetaHelp.
  ///
  /// In en, this message translates to:
  /// **'The approved template\'s name in WhatsApp Manager. Register it with this text (tap to copy):'**
  String get waTemplateMetaHelp;

  /// No description provided for @waTemplateSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved'**
  String get waTemplateSaved;

  /// No description provided for @waCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get waCopied;

  /// No description provided for @waFestivalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Festival calendar'**
  String get waFestivalsTitle;

  /// No description provided for @waFestivalsNote.
  ///
  /// In en, this message translates to:
  /// **'Wishes go out at 9:00 am on the day. Lunar festivals move every year: check the dates.'**
  String get waFestivalsNote;

  /// No description provided for @waFestivalAdd.
  ///
  /// In en, this message translates to:
  /// **'Add festival'**
  String get waFestivalAdd;

  /// No description provided for @waFestivalName.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get waFestivalName;

  /// No description provided for @waFestivalLocalName.
  ///
  /// In en, this message translates to:
  /// **'Hindi name (for Hindi messages)'**
  String get waFestivalLocalName;

  /// No description provided for @waFestivalDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get waFestivalDate;

  /// No description provided for @waFestivalMessage.
  ///
  /// In en, this message translates to:
  /// **'Own message (optional)'**
  String get waFestivalMessage;

  /// No description provided for @waFestivalMessageHelp.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use the festival wishes template.'**
  String get waFestivalMessageHelp;

  /// No description provided for @waFestivalOn.
  ///
  /// In en, this message translates to:
  /// **'Send wishes'**
  String get waFestivalOn;

  /// No description provided for @waFestivalMarketingNote.
  ///
  /// In en, this message translates to:
  /// **'Festival wishes are marketing messages: a member who already got one that day is skipped.'**
  String get waFestivalMarketingNote;

  /// No description provided for @waFestivalDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove festival'**
  String get waFestivalDelete;

  /// No description provided for @waFestivalSaved.
  ///
  /// In en, this message translates to:
  /// **'Festival saved'**
  String get waFestivalSaved;

  /// No description provided for @waFestivalPast.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get waFestivalPast;

  /// No description provided for @waFestivalIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today} =1{Tomorrow} other{In {days} days}}'**
  String waFestivalIn(int days);

  /// No description provided for @waFestivalsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No festivals'**
  String get waFestivalsEmptyTitle;

  /// No description provided for @waFestivalsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add the festivals your members celebrate.'**
  String get waFestivalsEmptyBody;

  /// No description provided for @waSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp settings'**
  String get waSettingsTitle;

  /// No description provided for @waModeTitle.
  ///
  /// In en, this message translates to:
  /// **'How messages are sent'**
  String get waModeTitle;

  /// No description provided for @waModeFreeHelp.
  ///
  /// In en, this message translates to:
  /// **'Free: each message opens in the gym\'s WhatsApp with the text ready, and staff tap send. Nothing to set up.'**
  String get waModeFreeHelp;

  /// No description provided for @waModeApiHelp.
  ///
  /// In en, this message translates to:
  /// **'API: approved templates go out automatically through Meta\'s WhatsApp Cloud API. Needs the API keys in Supabase (see the README). Anything the API can\'t send moves to the To send list.'**
  String get waModeApiHelp;

  /// No description provided for @waExpiryDays.
  ///
  /// In en, this message translates to:
  /// **'Membership reminders'**
  String get waExpiryDays;

  /// No description provided for @waOnTheDay.
  ///
  /// In en, this message translates to:
  /// **'On the day'**
  String get waOnTheDay;

  /// No description provided for @waDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day before} other{{days} days before}}'**
  String waDaysBefore(int days);

  /// No description provided for @waDaysAfter.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day after} other{{days} days after}}'**
  String waDaysAfter(int days);

  /// No description provided for @waAddDay.
  ///
  /// In en, this message translates to:
  /// **'Add a day'**
  String get waAddDay;

  /// No description provided for @waDayPrompt.
  ///
  /// In en, this message translates to:
  /// **'Days before the end date (use a minus for after, e.g. -5)'**
  String get waDayPrompt;

  /// No description provided for @waAutomations.
  ///
  /// In en, this message translates to:
  /// **'Automatic messages'**
  String get waAutomations;

  /// No description provided for @waAutoExpiry.
  ///
  /// In en, this message translates to:
  /// **'Membership reminders'**
  String get waAutoExpiry;

  /// No description provided for @waAutoDues.
  ///
  /// In en, this message translates to:
  /// **'Fee reminders with the pay link'**
  String get waAutoDues;

  /// No description provided for @waAutoBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday wishes'**
  String get waAutoBirthday;

  /// No description provided for @waAutoFestival.
  ///
  /// In en, this message translates to:
  /// **'Festival wishes'**
  String get waAutoFestival;

  /// No description provided for @waAutoPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get waAutoPayment;

  /// No description provided for @waAutoMembership.
  ///
  /// In en, this message translates to:
  /// **'Welcome and renewal thanks'**
  String get waAutoMembership;

  /// No description provided for @waAutoPlan.
  ///
  /// In en, this message translates to:
  /// **'New workout and diet plans'**
  String get waAutoPlan;

  /// No description provided for @waCostTitle.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get waCostTitle;

  /// No description provided for @waCostUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility (API)'**
  String get waCostUtility;

  /// No description provided for @waCostMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing (API)'**
  String get waCostMarketing;

  /// No description provided for @waCostFree.
  ///
  /// In en, this message translates to:
  /// **'Free in the 24-hour window'**
  String get waCostFree;

  /// No description provided for @waCostLink.
  ///
  /// In en, this message translates to:
  /// **'Sent by hand (free)'**
  String get waCostLink;

  /// No description provided for @waCostMessages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 message} other{{count} messages}}'**
  String waCostMessages(int count);

  /// No description provided for @waCostTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated spend'**
  String get waCostTotal;

  /// No description provided for @waCap.
  ///
  /// In en, this message translates to:
  /// **'Monthly marketing cap'**
  String get waCap;

  /// No description provided for @waCapHelp.
  ///
  /// In en, this message translates to:
  /// **'Marketing messages pause for the rest of the month once their spend reaches this. 0 = no cap.'**
  String get waCapHelp;

  /// No description provided for @waCapPaused.
  ///
  /// In en, this message translates to:
  /// **'Cap reached: marketing messages are paused until next month.'**
  String get waCapPaused;

  /// No description provided for @waCapUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} of {cap} marketing cap used'**
  String waCapUsed(String used, String cap);

  /// No description provided for @waPrices.
  ///
  /// In en, this message translates to:
  /// **'Meta\'s price per message'**
  String get waPrices;

  /// No description provided for @waPriceUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility (₹)'**
  String get waPriceUtility;

  /// No description provided for @waPriceMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing (₹)'**
  String get waPriceMarketing;

  /// No description provided for @waPricesHelp.
  ///
  /// In en, this message translates to:
  /// **'Used only for the estimate. Check Meta\'s current prices for India.'**
  String get waPricesHelp;

  /// No description provided for @waBadAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get waBadAmount;

  /// No description provided for @waSaved.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp settings saved'**
  String get waSaved;

  /// No description provided for @waOptIn.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp messages'**
  String get waOptIn;

  /// No description provided for @waOptInBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders, receipts and wishes from the gym'**
  String get waOptInBody;

  /// No description provided for @waOptedOut.
  ///
  /// In en, this message translates to:
  /// **'Turned off: no WhatsApp messages from the gym.'**
  String get waOptedOut;

  /// No description provided for @waOptInDone.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp messages turned on'**
  String get waOptInDone;

  /// No description provided for @waOptOutDone.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp messages turned off'**
  String get waOptOutDone;

  /// No description provided for @waSendTo.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp to {name}'**
  String waSendTo(String name);

  /// No description provided for @receiptHeading.
  ///
  /// In en, this message translates to:
  /// **'RECEIPT'**
  String get receiptHeading;

  /// No description provided for @receiptDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt {no}'**
  String receiptDocTitle(String no);

  /// No description provided for @receiptGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN {gstin}'**
  String receiptGstin(String gstin);

  /// No description provided for @receiptReceivedFrom.
  ///
  /// In en, this message translates to:
  /// **'Received from'**
  String get receiptReceivedFrom;

  /// No description provided for @receiptAgainstInvoice.
  ///
  /// In en, this message translates to:
  /// **'Against invoice {invoiceNo}'**
  String receiptAgainstInvoice(String invoiceNo);

  /// No description provided for @receiptDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get receiptDiscount;

  /// No description provided for @receiptTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable value'**
  String get receiptTaxable;

  /// No description provided for @receiptCgst.
  ///
  /// In en, this message translates to:
  /// **'CGST'**
  String get receiptCgst;

  /// No description provided for @receiptSgst.
  ///
  /// In en, this message translates to:
  /// **'SGST'**
  String get receiptSgst;

  /// No description provided for @receiptInvoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Invoice total'**
  String get receiptInvoiceTotal;

  /// No description provided for @receiptAmountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get receiptAmountReceived;

  /// No description provided for @receiptMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get receiptMode;

  /// No description provided for @receiptUtr.
  ///
  /// In en, this message translates to:
  /// **'Reference / UTR'**
  String get receiptUtr;

  /// No description provided for @receiptBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance due'**
  String get receiptBalanceDue;

  /// No description provided for @receiptThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for training with us!'**
  String get receiptThanks;

  /// No description provided for @receiptGenerated.
  ///
  /// In en, this message translates to:
  /// **'This is a computer-generated receipt.'**
  String get receiptGenerated;

  /// No description provided for @notifRestTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest over'**
  String get notifRestTitle;

  /// No description provided for @notifRestBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your next set'**
  String get notifRestBody;

  /// No description provided for @notifRestChannel.
  ///
  /// In en, this message translates to:
  /// **'Rest timer'**
  String get notifRestChannel;

  /// No description provided for @notifRestChannelBody.
  ///
  /// In en, this message translates to:
  /// **'Tells you when your rest between sets is over'**
  String get notifRestChannelBody;

  /// No description provided for @notifMealChannel.
  ///
  /// In en, this message translates to:
  /// **'Meal reminders'**
  String get notifMealChannel;

  /// No description provided for @notifMealChannelBody.
  ///
  /// In en, this message translates to:
  /// **'Reminds you of the meals in your diet plan'**
  String get notifMealChannelBody;

  /// No description provided for @waTodayProblems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 needs attention} other{{count} need attention}}'**
  String waTodayProblems(int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
