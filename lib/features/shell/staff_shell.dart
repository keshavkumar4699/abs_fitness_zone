import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import 'adaptive_shell.dart';

export 'adaptive_shell.dart' show FadeThroughBranches;

/// Staff navigation: Home, Members, Payments, Plans, More.
class StaffShell extends StatelessWidget {
  const StaffShell({super.key, required this.shell});

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
          label: l.navMembers,
          icon: PhosphorIcons.users(),
          selectedIcon: PhosphorIcons.users(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navPayments,
          icon: PhosphorIcons.wallet(),
          selectedIcon: PhosphorIcons.wallet(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navPlans,
          icon: PhosphorIcons.barbell(),
          selectedIcon: PhosphorIcons.barbell(PhosphorIconsStyle.fill),
        ),
        NavDestination(
          label: l.navMore,
          icon: PhosphorIcons.dotsThreeCircle(),
          selectedIcon: PhosphorIcons.dotsThreeCircle(PhosphorIconsStyle.fill),
        ),
      ],
    );
  }
}
