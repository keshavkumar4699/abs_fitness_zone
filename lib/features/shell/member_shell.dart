import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import 'adaptive_shell.dart';

/// Member navigation: Home, Workout, Diet, Progress, Profile.
class MemberShell extends StatelessWidget {
  const MemberShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AdaptiveShell(
      shell: shell,
      destinations: [
        NavDestination(
          label: l.navHome,
          icon: PhosphorIcons.house(),
          selectedIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navWorkout,
          icon: PhosphorIcons.barbell(),
          selectedIcon: PhosphorIcons.barbell(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navDiet,
          icon: PhosphorIcons.forkKnife(),
          selectedIcon: PhosphorIcons.forkKnife(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navProgress,
          icon: PhosphorIcons.chartLineUp(),
          selectedIcon: PhosphorIcons.chartLineUp(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navProfile,
          icon: PhosphorIcons.userCircle(),
          selectedIcon: PhosphorIcons.userCircle(PhosphorIconsStyle.fill),
        ),
      ],
    );
  }
}
