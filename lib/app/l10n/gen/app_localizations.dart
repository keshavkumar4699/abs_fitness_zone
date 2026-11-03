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

  /// No description provided for @welcomeMember.
  ///
  /// In en, this message translates to:
  /// **'I\'m a member'**
  String get welcomeMember;

  /// No description provided for @welcomeStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff login'**
  String get welcomeStaff;

  /// No description provided for @welcomeNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'This build has no server configured. Sign-in is disabled; long-press the logo to open the component gallery.'**
  String get welcomeNotConfigured;

  /// No description provided for @staffLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff login'**
  String get staffLoginTitle;

  /// No description provided for @staffLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the email your gym owner invited you with.'**
  String get staffLoginSubtitle;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get fieldPhone;

  /// No description provided for @fieldPin.
  ///
  /// In en, this message translates to:
  /// **'4-digit PIN'**
  String get fieldPin;

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

  /// No description provided for @fieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPassword;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get actionSignIn;

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

  /// No description provided for @validationPin.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits'**
  String get validationPin;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get validationPasswordMatch;

  /// No description provided for @memberLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Member login'**
  String get memberLoginTitle;

  /// No description provided for @memberLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number and the PIN set at the front desk.'**
  String get memberLoginSubtitle;

  /// No description provided for @memberForgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get memberForgotPin;

  /// No description provided for @memberForgotPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN?'**
  String get memberForgotPinTitle;

  /// No description provided for @memberForgotPinBody.
  ///
  /// In en, this message translates to:
  /// **'Please contact the front desk. They can set a new PIN for you in a few seconds.'**
  String get memberForgotPinBody;

  /// No description provided for @memberUseEmailLink.
  ///
  /// In en, this message translates to:
  /// **'Use an email link instead'**
  String get memberUseEmailLink;

  /// No description provided for @memberEmailLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get memberEmailLinkTitle;

  /// No description provided for @memberEmailLinkBody.
  ///
  /// In en, this message translates to:
  /// **'If your email is on file, we\'ll send you a sign-in link.'**
  String get memberEmailLinkBody;

  /// No description provided for @memberEmailLinkSend.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get memberEmailLinkSend;

  /// No description provided for @memberEmailLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox for the sign-in link.'**
  String get memberEmailLinkSent;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Those details don\'t match. Please check and try again.'**
  String get authInvalidCredentials;

  /// No description provided for @authInvalidPin.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Wrong PIN. 1 attempt left before a 15-minute lock.} other{Wrong PIN. {count} attempts left before a 15-minute lock.}}'**
  String authInvalidPin(int count);

  /// No description provided for @authLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong attempts. Try again after {time}.'**
  String authLocked(String time);

  /// No description provided for @authNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is not available in this build.'**
  String get authNotConfigured;

  /// No description provided for @authNoProfile.
  ///
  /// In en, this message translates to:
  /// **'Your account isn\'t linked to the gym yet. Please contact the front desk.'**
  String get authNoProfile;

  /// No description provided for @setPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your password'**
  String get setPasswordTitle;

  /// No description provided for @setPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For your security, choose a new password before you continue.'**
  String get setPasswordSubtitle;

  /// No description provided for @setPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get setPasswordAction;

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

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Warming up!'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'This section is doing its stretches and arrives in an upcoming update.'**
  String get comingSoonBody;

  /// No description provided for @comingSoonAction.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get comingSoonAction;

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
  /// **'Invite and manage your team'**
  String get moreStaffSubtitle;

  /// No description provided for @moreMemberPin.
  ///
  /// In en, this message translates to:
  /// **'Member PIN'**
  String get moreMemberPin;

  /// No description provided for @moreMemberPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set or reset a member\'s app PIN'**
  String get moreMemberPinSubtitle;

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
  /// **'Invite your trainers and front desk so they can sign in.'**
  String get staffEmptyBody;

  /// No description provided for @staffInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite staff'**
  String get staffInvite;

  /// No description provided for @staffInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a team member'**
  String get staffInviteTitle;

  /// No description provided for @staffInviteAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get staffInviteAction;

  /// No description provided for @staffInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get staffInactive;

  /// No description provided for @staffTempPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get staffTempPasswordTitle;

  /// No description provided for @staffTempPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Share this temporary password with {name}. They\'ll set their own password on first sign-in. It won\'t be shown again.'**
  String staffTempPasswordBody(String name);

  /// No description provided for @memberPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Member PIN'**
  String get memberPinTitle;

  /// No description provided for @memberPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Look up a member by phone, then set a new 4-digit PIN for the app.'**
  String get memberPinSubtitle;

  /// No description provided for @memberPinFind.
  ///
  /// In en, this message translates to:
  /// **'Find member'**
  String get memberPinFind;

  /// No description provided for @memberPinNotFound.
  ///
  /// In en, this message translates to:
  /// **'No member with this phone number.'**
  String get memberPinNotFound;

  /// No description provided for @memberPinSet.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get memberPinSet;

  /// No description provided for @memberPinDone.
  ///
  /// In en, this message translates to:
  /// **'PIN updated for {name}.'**
  String memberPinDone(String name);

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

  /// No description provided for @authSamePassword.
  ///
  /// In en, this message translates to:
  /// **'Pick a password you haven\'t used before.'**
  String get authSamePassword;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'That password is too easy to guess. Try a longer one with numbers or symbols.'**
  String get authWeakPassword;

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
  /// **'Someone already uses this email. Try a different one.'**
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

  /// No description provided for @memberHomeComingBody.
  ///
  /// In en, this message translates to:
  /// **'Your workouts, diet and progress land here soon.'**
  String get memberHomeComingBody;

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
