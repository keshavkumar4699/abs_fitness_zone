import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/gallery/presentation/gallery_screen.dart';
import '../features/member_home/application/onboarding_controller.dart';
import '../features/member_home/presentation/member_onboarding_screen.dart';
import '../features/member_home/presentation/member_profile_screen.dart';
import '../features/checkin/presentation/check_in_screen.dart';
import '../features/checkin/presentation/gym_qr_screen.dart';
import '../features/checkin/presentation/member_check_in_screen.dart';
import '../features/member_home/presentation/my_progress_screen.dart';
import '../features/members/presentation/add_member_screen.dart';
import '../features/members/presentation/edit_member_screen.dart';
import '../features/members/presentation/import_members_screen.dart';
import '../features/members/presentation/member_detail_screen.dart';
import '../features/members/presentation/members_screen.dart';
import '../features/members/presentation/membership_plans_screen.dart';
import '../features/member_home/presentation/my_payments_screen.dart';
import '../features/payments/presentation/day_close_screen.dart';
import '../features/payments/presentation/expenses_screen.dart';
import '../features/payments/presentation/invoice_detail_screen.dart';
import '../features/payments/presentation/payment_history_screen.dart';
import '../features/payments/presentation/payments_screen.dart';
import '../features/settings/presentation/gym_profile_screen.dart';
import '../features/settings/presentation/more_screen.dart';
import '../features/settings/presentation/team_screen.dart';
import '../features/shell/coming_soon_screen.dart';
import '../features/member_home/presentation/member_home_screen.dart';
import '../features/shell/member_shell.dart';
import '../features/shell/not_found_screen.dart';
import '../features/shell/staff_home_screen.dart';
import '../features/shell/staff_shell.dart';
import '../core/widgets/states.dart';
import 'l10n/l10n.dart';
import 'routes.dart';

export 'routes.dart';

part 'router.g.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(currentUserProvider, (_, _) => refresh.value++)
    ..listen(onboardingControllerProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  GoRoute tab(String path, Widget Function(BuildContext) build, {List<RouteBase> routes = const []}) =>
      GoRoute(path: path, builder: (context, _) => build(context), routes: routes);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    errorBuilder: (_, _) => const NotFoundScreen(),
    redirect: (context, state) => authRedirect(
      auth: ref.read(currentUserProvider),
      onboardingDone: ref.read(onboardingControllerProvider),
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, _) => const MemberOnboardingScreen()),
      GoRoute(path: Routes.gallery, builder: (_, _) => const GalleryScreen()),
      GoRoute(path: Routes.checkIn, builder: (_, _) => const CheckInScreen()),
      GoRoute(path: Routes.meCheckIn, builder: (_, _) => const MemberCheckInScreen()),
      GoRoute(
        path: Routes.mePayments,
        builder: (_, _) => const MyPaymentsScreen(),
        routes: [
          GoRoute(
            path: ':invoiceId',
            builder: (_, state) => MemberPayScreen(invoiceId: state.pathParameters['invoiceId']!),
          ),
        ],
      ),
      StatefulShellRoute(
        builder: (context, state, shell) => StaffShell(shell: shell),
        navigatorContainerBuilder: (context, shell, children) =>
            FadeThroughBranches(index: shell.currentIndex, children: children),
        branches: [
          StatefulShellBranch(routes: [tab(Routes.staffHome, (_) => const StaffHomeScreen())]),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.staffMembers,
                builder: (_, state) => MembersScreen(
                  initialStatus: state.uri.queryParameters['status'],
                  initialSort: state.uri.queryParameters['sort'],
                ),
                routes: [
                  // Full-screen flows cover the tab bar.
                  GoRoute(path: 'new', parentNavigatorKey: _rootKey, builder: (_, _) => const AddMemberScreen()),
                  GoRoute(path: 'import', parentNavigatorKey: _rootKey, builder: (_, _) => const ImportMembersScreen()),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => MemberDetailScreen(
                      memberId: state.pathParameters['id']!,
                      openCollect: state.uri.queryParameters['collect'] == '1',
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => EditMemberScreen(memberId: state.pathParameters['id']!),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.staffPayments,
                (_) => const PaymentsScreen(),
                routes: [
                  GoRoute(
                    path: 'invoice/:id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => InvoiceDetailScreen(invoiceId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'history',
                    parentNavigatorKey: _rootKey,
                    builder: (_, _) => const PaymentHistoryScreen(),
                  ),
                  GoRoute(path: 'day-close', parentNavigatorKey: _rootKey, builder: (_, _) => const DayCloseScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.staffPlans,
                (c) => ComingSoonScreen(
                  title: c.l10n.navPlans,
                  hue: StaffHues.plans,
                  illustration: EmptyIllustration.dumbbell,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.staffMore,
                (_) => const MoreScreen(),
                routes: [
                  GoRoute(path: 'team', builder: (_, _) => const TeamScreen()),
                  GoRoute(path: 'membership-plans', builder: (_, _) => const MembershipPlansScreen()),
                  GoRoute(path: 'check-in-qr', builder: (_, _) => const GymQrScreen()),
                  GoRoute(path: 'gym-profile', builder: (_, _) => const GymProfileScreen()),
                  GoRoute(path: 'expenses', builder: (_, _) => const ExpensesScreen()),
                ],
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute(
        builder: (context, state, shell) => MemberShell(shell: shell),
        navigatorContainerBuilder: (context, shell, children) =>
            FadeThroughBranches(index: shell.currentIndex, children: children),
        branches: [
          StatefulShellBranch(routes: [tab(Routes.meHome, (_) => const MemberHomeScreen())]),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.meWorkout,
                (c) => ComingSoonScreen(
                  title: c.l10n.navWorkout,
                  hue: MemberHues.workout,
                  illustration: EmptyIllustration.dumbbell,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [tab(Routes.meDiet, (c) => ComingSoonScreen(title: c.l10n.navDiet, hue: MemberHues.diet))],
          ),
          StatefulShellBranch(routes: [tab(Routes.meProgress, (_) => const MyProgressScreen())]),
          StatefulShellBranch(routes: [tab(Routes.meProfile, (_) => const MemberProfileScreen())]),
        ],
      ),
    ],
  );
}
