import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n/l10n.dart';
import '../../app/routes.dart';
import '../../app/theme/theme.dart';
import '../../core/widgets/states.dart';

/// Shown for unknown links instead of the router's default error page.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: EmptyState(
          title: l.notFoundTitle,
          message: l.notFoundBody,
          actionLabel: l.goHome,
          onAction: () => context.go(Routes.splash),
          illustration: EmptyIllustration.search,
          hue: PopHue.tangerine,
        ),
      ),
    );
  }
}
