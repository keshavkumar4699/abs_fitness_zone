import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/member_login_screen.dart';
import '../features/auth/presentation/set_password_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/staff_login_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/gallery/presentation/gallery_screen.dart';
import '../features/member_home/application/onboarding_controller.dart';
import '../features/member_home/presentation/member_onboarding_screen.dart';
import '../features/member_home/presentation/member_profile_screen.dart';
import '../features/settings/presentation/member_pin_screen.dart';
import '../features/settings/presentation/more_screen.dart';
import '../features/settings/presentation/team_screen.dart';
import '../features/shell/coming_soon_screen.dart';
import '../features/shell/member_shell.dart';
import '../features/shell/staff_home_screen.dart';
import '../features/shell/staff_shell.dart';
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
    redirect: (context, state) => authRedirect(
      auth: ref.read(currentUserProvider),
      onboardingDone: ref.read(onboardingControllerProvider),
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: Routes.staffLogin, builder: (_, _) => const StaffLoginScreen()),
      GoRoute(path: Routes.memberLogin, builder: (_, _) => const MemberLoginScreen()),
      GoRoute(path: Routes.setPassword, builder: (_, _) => const SetPasswordScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, _) => const MemberOnboardingScreen()),
      GoRoute(path: Routes.gallery, builder: (_, _) => const GalleryScreen()),
      StatefulShellRoute(
        builder: (context, state, shell) => StaffShell(shell: shell),
        navigatorContainerBuilder: (context, shell, children) =>
            FadeThroughBranches(index: shell.currentIndex, children: children),
        branches: [
          StatefulShellBranch(routes: [tab(Routes.staffHome, (_) => const StaffHomeScreen())]),
          StatefulShellBranch(routes: [tab(Routes.staffMembers, (c) => ComingSoonScreen(title: c.l10n.navMembers))]),
          StatefulShellBranch(routes: [tab(Routes.staffPayments, (c) => ComingSoonScreen(title: c.l10n.navPayments))]),
          StatefulShellBranch(routes: [tab(Routes.staffPlans, (c) => ComingSoonScreen(title: c.l10n.navPlans))]),
          StatefulShellBranch(
            routes: [
              tab(
                Routes.staffMore,
                (_) => const MoreScreen(),
                routes: [
                  GoRoute(path: 'team', builder: (_, _) => const TeamScreen()),
                  GoRoute(path: 'member-pin', builder: (_, _) => const MemberPinScreen()),
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
          StatefulShellBranch(routes: [tab(Routes.meHome, (c) => ComingSoonScreen(title: c.l10n.navHome))]),
          StatefulShellBranch(routes: [tab(Routes.meWorkout, (c) => ComingSoonScreen(title: c.l10n.navWorkout))]),
          StatefulShellBranch(routes: [tab(Routes.meDiet, (c) => ComingSoonScreen(title: c.l10n.navDiet))]),
          StatefulShellBranch(routes: [tab(Routes.meProgress, (c) => ComingSoonScreen(title: c.l10n.navProgress))]),
          StatefulShellBranch(routes: [tab(Routes.meProfile, (_) => const MemberProfileScreen())]),
        ],
      ),
    ],
  );
}
