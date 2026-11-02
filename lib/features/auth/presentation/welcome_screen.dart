import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/abs_button.dart';
import '../../../core/widgets/brand_mark.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final configured = ref.watch(envProvider).isConfigured;
    final reduced = AbsMotion.reduced(context);

    Widget enter(Widget w, int i) => reduced
        ? w
        : w
              .animate(delay: AbsMotion.staggerDelay(i * 2))
              .fadeIn(duration: AbsMotion.standard.duration)
              .moveY(
                begin: AbsMotion.entranceOffset,
                end: 0,
                duration: AbsMotion.standard.duration,
                curve: AbsMotion.staggerCurve,
              );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.screenPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      // Hidden entry to the component gallery.
                      onLongPress: () => context.push(Routes.gallery),
                      child: const BrandMark(),
                    ),
                  ),
                  const SizedBox(height: AbsSpace.x10),
                  enter(Text(l.welcomeTitle, style: t.displayXL.copyWith(fontSize: t.displayL.fontSize! * 1.2)), 0),
                  const SizedBox(height: AbsSpace.x3),
                  enter(Text(l.welcomeSubtitle, style: t.body.copyWith(color: c.textSecondary)), 1),
                  const SizedBox(height: AbsSpace.x10),
                  if (!configured) ...[
                    Container(
                      padding: const EdgeInsets.all(AbsSpace.x4),
                      decoration: BoxDecoration(
                        color: c.warning.withValues(alpha: AbsOpacity.subtleFill),
                        borderRadius: AbsRadius.buttonAll,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(PhosphorIcons.warning(), color: c.warning),
                          const SizedBox(width: AbsSpace.x3),
                          Expanded(child: Text(l.welcomeNotConfigured, style: t.label)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AbsSpace.x5),
                  ],
                  enter(
                    AbsButton(
                      label: l.welcomeMember,
                      icon: PhosphorIcons.userCircle(),
                      onPressed: () => context.push(Routes.memberLogin),
                    ),
                    2,
                  ),
                  const SizedBox(height: AbsSpace.x3),
                  enter(
                    AbsButton.secondary(
                      label: l.welcomeStaff,
                      icon: PhosphorIcons.identificationBadge(),
                      onPressed: () => context.push(Routes.staffLogin),
                    ),
                    3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
