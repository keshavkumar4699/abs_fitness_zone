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

  /// No description provided for @actionSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set app PIN'**
  String get actionSetPin;

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

  /// No description provided for @workoutsSoon.
  ///
  /// In en, this message translates to:
  /// **'Workout plans arrive with the Workouts update.'**
  String get workoutsSoon;

  /// No description provided for @dietSoon.
  ///
  /// In en, this message translates to:
  /// **'Diet plans arrive with the Diet update.'**
  String get dietSoon;

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
