import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/domain/app_user.dart';

/// Every route path in one place.
abstract final class Routes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const gallery = '/gallery';

  static const staffHome = '/staff/home';
  static const staffMembers = '/staff/members';
  static const staffPayments = '/staff/payments';
  static String invoiceDetail(String id) => '/staff/payments/invoice/$id';
  static const paymentHistory = '/staff/payments/history';
  static const dayClose = '/staff/payments/day-close';
  static const expenses = '/staff/more/expenses';
  static const staffPlans = '/staff/plans';
  static const exerciseNew = '/staff/plans/exercises/new';
  static String exerciseDetail(String id) => '/staff/plans/exercises/$id';
  static String exerciseEdit(String id) => '/staff/plans/exercises/$id/edit';
  static const programNew = '/staff/plans/programs/new';
  static String programDetail(String id) => '/staff/plans/programs/$id';
  static String programEdit(String id) => '/staff/plans/programs/$id/edit';
  static const staffMore = '/staff/more';
  static const staffTeam = '/staff/more/team';

  static const memberNew = '/staff/members/new';
  static const memberImport = '/staff/members/import';
  static String memberDetail(String id) => '/staff/members/$id';
  static String memberEdit(String id) => '/staff/members/$id/edit';
  static const checkIn = '/staff/check-in';
  static const membershipPlans = '/staff/more/membership-plans';
  static const gymQr = '/staff/more/check-in-qr';
  static const gymProfile = '/staff/more/gym-profile';

  static const meHome = '/me/home';
  static const meCheckIn = '/me/check-in';
  static const meWorkout = '/me/workout';
  static const meDiet = '/me/diet';
  static const meProgress = '/me/progress';
  static const meProfile = '/me/profile';
  static const mePayments = '/me/payments';
  static const mePlayer = '/me/workout/play';
  static const meExercises = '/me/exercises';
  static String meExercise(String id) => '/me/exercises/$id';
  static String mePay(String invoiceId) => '/me/payments/$invoiceId';

  static bool isPublic(String location) => location == welcome || location == gallery;
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

  if (user.role == UserRole.member && !onboardingDone) {
    return location == Routes.onboarding ? null : Routes.onboarding;
  }

  final home = user.role.isStaff ? Routes.staffHome : Routes.meHome;
  final isEntry = location == Routes.splash || Routes.isPublic(location) || location == Routes.onboarding;
  if (isEntry) return home;

  if (location.startsWith('/staff') && !user.role.isStaff) return home;
  if (location.startsWith('/me') && user.role.isStaff) return home;
  if (location.startsWith(Routes.staffTeam) && !user.role.isOwner) return Routes.staffMore;
  // Owner-only and desk-only staff pages.
  if ((location.startsWith(Routes.gymProfile) || location.startsWith(Routes.expenses)) && !user.role.isOwner) {
    return Routes.staffMore;
  }
  // Building programs and exercises: owner and trainers only.
  if (location.startsWith('${Routes.staffPlans}/') &&
      (location.endsWith('/new') || location.endsWith('/edit')) &&
      user.role != UserRole.owner &&
      user.role != UserRole.trainer) {
    return Routes.staffPlans;
  }
  // Fees and receipts: owner and front desk only (trainers never see them).
  if (location.startsWith('${Routes.staffPayments}/') && !user.role.isDesk) return Routes.staffPayments;
  if ((location.startsWith(Routes.gymQr) ||
          location == Routes.memberNew ||
          location == Routes.memberImport ||
          (location.startsWith('/staff/members/') && location.endsWith('/edit'))) &&
      !user.role.isDesk) {
    return Routes.staffMembers;
  }
  return null;
}
