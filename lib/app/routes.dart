import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/domain/app_user.dart';

/// Every route path in one place.
abstract final class Routes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const staffLogin = '/login/staff';
  static const memberLogin = '/login/member';
  static const setPassword = '/set-password';
  static const onboarding = '/onboarding';
  static const gallery = '/gallery';

  static const staffHome = '/staff/home';
  static const staffMembers = '/staff/members';
  static const staffPayments = '/staff/payments';
  static const staffPlans = '/staff/plans';
  static const staffMore = '/staff/more';
  static const staffTeam = '/staff/more/team';
  static const memberPin = '/staff/more/member-pin';

  static const meHome = '/me/home';
  static const meWorkout = '/me/workout';
  static const meDiet = '/me/diet';
  static const meProgress = '/me/progress';
  static const meProfile = '/me/profile';

  static bool isPublic(String location) => location == welcome || location.startsWith('/login') || location == gallery;
}

/// Role guard and auth redirect, as a pure function so it is unit-tested.
/// Returns the path to go to, or null to stay.
String? authRedirect({required AsyncValue<AppUser?> auth, required bool onboardingDone, required String location}) {
  // Still resolving the session, or failed before ever loading: hold on the
  // splash screen (which shows the error + retry).
  if (!auth.hasValue) return location == Routes.splash ? null : Routes.splash;

  final user = auth.value;
  if (user == null) {
    return Routes.isPublic(location) ? null : Routes.welcome;
  }

  // The hidden component gallery stays reachable for owners.
  if (location == Routes.gallery && user.role.isOwner) return null;

  if (user.role.isStaff && user.mustSetPassword) {
    return location == Routes.setPassword ? null : Routes.setPassword;
  }
  if (user.role == UserRole.member && !onboardingDone) {
    return location == Routes.onboarding ? null : Routes.onboarding;
  }

  final home = user.role.isStaff ? Routes.staffHome : Routes.meHome;
  final isEntry =
      location == Routes.splash ||
      Routes.isPublic(location) ||
      location == Routes.setPassword ||
      location == Routes.onboarding;
  if (isEntry) return home;

  if (location.startsWith('/staff') && !user.role.isStaff) return home;
  if (location.startsWith('/me') && user.role.isStaff) return home;
  if (location.startsWith(Routes.staffTeam) && !user.role.isOwner) return Routes.staffMore;
  if (location.startsWith(Routes.memberPin) && !user.role.isDesk) return Routes.staffMore;
  return null;
}
