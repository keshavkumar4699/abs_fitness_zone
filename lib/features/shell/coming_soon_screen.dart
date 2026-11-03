import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import '../../core/widgets/states.dart';

/// Placeholder for sections that arrive in later milestones.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.title,
    this.hue = PopHue.grape,
    this.illustration = EmptyIllustration.rocket,
  });

  final String title;
  final PopHue hue;
  final EmptyIllustration illustration;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: EmptyState(title: l.comingSoonTitle, message: l.comingSoonBody, illustration: illustration, hue: hue),
      ),
    );
  }
}
