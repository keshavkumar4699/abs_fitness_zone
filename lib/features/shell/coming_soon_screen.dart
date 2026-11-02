import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import '../../core/widgets/states.dart';

/// Placeholder for sections that arrive in later milestones.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title, this.header});

  final String title;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          ?header,
          Expanded(
            child: EmptyState(
              title: l.comingSoonTitle,
              message: l.comingSoonBody,
              illustration: EmptyIllustration.clock,
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + AbsSpace.x4),
        ],
      ),
    );
  }
}
