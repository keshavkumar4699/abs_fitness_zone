import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import 'adaptive_shell.dart';

/// Section hues for member tabs.
abstract final class MemberHues {
  static const home = PopHue.lime;
  static const workout = PopHue.bubblegum;
  static const diet = PopHue.mint;
  static const progress = PopHue.sky;
  static const profile = PopHue.grape;
}

/// Member navigation: Home, Workout, Diet, Progress, Profile.
class MemberShell extends StatelessWidget {
  const MemberShell({super.key, required this.shell});

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
        d(l.navHome, PhosphorIcons.house, MemberHues.home),
        d(l.navWorkout, PhosphorIcons.barbell, MemberHues.workout),
        d(l.navDiet, PhosphorIcons.forkKnife, MemberHues.diet),
        d(l.navProgress, PhosphorIcons.chartLineUp, MemberHues.progress),
        d(l.navProfile, PhosphorIcons.userCircle, MemberHues.profile),
      ],
    );
  }
}
