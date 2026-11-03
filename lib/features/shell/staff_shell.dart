import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import 'adaptive_shell.dart';

export 'adaptive_shell.dart' show FadeThroughBranches;

/// Section hues for staff tabs (also used by each tab's screen).
abstract final class StaffHues {
  static const home = PopHue.lime;
  static const members = PopHue.sky;
  static const payments = PopHue.tangerine;
  static const plans = PopHue.bubblegum;
  static const more = PopHue.grape;
}

/// Staff navigation: Home, Members, Payments, Plans, More.
class StaffShell extends StatelessWidget {
  const StaffShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    NavDestination d(String label, IconData Function([PhosphorIconsStyle]) icon, PopHue hue) => NavDestination(
      label: label,
      icon: icon(PhosphorIconsStyle.bold),
      selectedIcon: icon(PhosphorIconsStyle.fill),
      hue: hue,
    );
    return AdaptiveShell(
      shell: shell,
      destinations: [
        d(l.navHome, PhosphorIcons.house, StaffHues.home),
        d(l.navMembers, PhosphorIcons.users, StaffHues.members),
        d(l.navPayments, PhosphorIcons.wallet, StaffHues.payments),
        d(l.navPlans, PhosphorIcons.barbell, StaffHues.plans),
        d(l.navMore, PhosphorIcons.dotsThreeCircle, StaffHues.more),
      ],
    );
  }
}
