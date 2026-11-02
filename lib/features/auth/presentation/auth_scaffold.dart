import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';

/// Centred, width-capped layout shared by the sign-in flow screens.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: showBack),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: t.displayL),
                  const SizedBox(height: AbsSpace.x2),
                  Text(subtitle, style: t.body.copyWith(color: c.textSecondary)),
                  const SizedBox(height: AbsSpace.x8),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
