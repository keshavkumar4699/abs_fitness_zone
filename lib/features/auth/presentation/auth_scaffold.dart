import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';
import '../../../core/widgets/pop_decor.dart';

/// Centred, width-capped, colourful layout shared by the sign-in screens.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.icon,
    this.hue = PopHue.grape,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final IconData icon;
  final PopHue hue;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: showBack, backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: PopBackground(
        hues: [hue, PopHue.lime, PopHue.sky],
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x4),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.rotate(
                        angle: -0.1,
                        child: IconBubble(icon: icon, hue: hue, size: 64),
                      ),
                    ),
                    const SizedBox(height: AbsSpace.x5),
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
      ),
    );
  }
}
