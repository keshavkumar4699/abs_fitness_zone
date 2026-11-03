import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/abs_card.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../application/theme_mode_controller.dart';

/// System / Light / Dark override.
class AppearanceCard extends ConsumerWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    const modes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final mode = ref.watch(themeModeControllerProvider);
    return AbsCard(
      title: l.moreAppearance,
      hue: PopHue.bubblegum,
      child: SegmentedTabs(
        hue: PopHue.bubblegum,
        labels: [l.themeSystem, l.themeLight, l.themeDark],
        selected: modes.indexOf(mode),
        onChanged: (i) => ref.read(themeModeControllerProvider.notifier).set(modes[i]),
      ),
    );
  }
}
