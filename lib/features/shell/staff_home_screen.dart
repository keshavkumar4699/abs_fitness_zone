import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n/l10n.dart';
import '../auth/application/auth_providers.dart';
import 'coming_soon_screen.dart';

/// Staff home. The dashboard (counts in M1, revenue in M2) replaces the
/// placeholder body as those milestones land.
class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(currentUserProvider).value?.name.split(' ').first ?? '';
    return ComingSoonScreen(title: context.l10n.greeting(name));
  }
}
