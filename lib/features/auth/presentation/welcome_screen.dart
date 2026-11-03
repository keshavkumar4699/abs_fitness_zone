import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/abs_button.dart';
import '../../../core/widgets/abs_snackbar.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/pop_decor.dart';
import '../application/auth_providers.dart';

/// The only way in: Continue with Google. Staff and members alike sign in
/// with the Gmail the gym has on their record.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _busy = false;

  Future<void> _google() async {
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final env = ref.watch(envProvider);
    final refused = ref.watch(signInErrorProvider).value;
    final reduced = AbsMotion.reduced(context);

    Widget enter(Widget w, int i) => reduced
        ? w
        : w
              .animate(delay: AbsMotion.staggerDelay(i * 2))
              .fadeIn(duration: AbsMotion.standard.duration)
              .scaleXY(begin: 0.85, end: 1, duration: AbsMotion.bouncy.duration, curve: AbsMotion.bouncy.curve);

    // Each headline word sits on its own colour highlight.
    Widget word(String text, PopHue hue, double tilt) {
      final p = c.pop(hue);
      return Transform.rotate(
        angle: tilt,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3),
          decoration: BoxDecoration(
            color: p.fill,
            borderRadius: AbsRadius.chipAll,
            border: Border.all(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline),
          ),
          child: Text(text, style: t.displayXL.copyWith(color: p.onFill, height: 1.15)),
        ),
      );
    }

    Widget chip(IconData icon, String label, PopHue hue, double tilt, int i) {
      final p = c.pop(hue);
      Widget w = Transform.rotate(
        angle: tilt,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3, vertical: AbsSpace.x2),
          decoration: stickerDecoration(
            c,
            color: p.fill,
            outline: c.isDark ? p.deep : c.ink,
            lipDepth: 3,
            borderRadius: AbsRadius.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AbsSize.iconSmall, color: p.onFill),
              const SizedBox(width: AbsSpace.x1 + 2),
              Text(label, style: t.label.copyWith(color: p.onFill)),
            ],
          ),
        ),
      );
      if (!reduced) {
        w = w
            .animate(onPlay: (a) => a.repeat(reverse: true), delay: (i * 300).ms)
            .moveY(begin: -3, end: 3, duration: 1400.ms, curve: Curves.easeInOutSine);
      }
      return w;
    }

    return Scaffold(
      body: PopBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.screenPadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        // Hidden entry to the component gallery.
                        onLongPress: () => context.push(Routes.gallery),
                        child: const BrandMark(size: 72),
                      ),
                    ),
                    const SizedBox(height: AbsSpace.x8),
                    Semantics(
                      header: true,
                      label: '${l.welcomeTitle1} ${l.welcomeTitle2} ${l.welcomeTitle3}',
                      child: ExcludeSemantics(
                        child: Wrap(
                          spacing: AbsSpace.x2,
                          runSpacing: AbsSpace.x3,
                          children: [
                            enter(word(l.welcomeTitle1, PopHue.lime, -0.04), 0),
                            enter(word(l.welcomeTitle2, PopHue.sky, 0.03), 1),
                            enter(word(l.welcomeTitle3, PopHue.bubblegum, -0.02), 2),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AbsSpace.x5),
                    enter(Text(l.welcomeSubtitle, style: t.body.copyWith(color: c.textSecondary, fontSize: 17)), 3),
                    const SizedBox(height: AbsSpace.x5),
                    ExcludeSemantics(
                      child: Wrap(
                        spacing: AbsSpace.x2,
                        runSpacing: AbsSpace.x2,
                        children: [
                          chip(
                            PhosphorIcons.barbell(PhosphorIconsStyle.bold),
                            l.welcomeChipWorkouts,
                            PopHue.tangerine,
                            -0.05,
                            0,
                          ),
                          chip(
                            PhosphorIcons.bowlFood(PhosphorIconsStyle.bold),
                            l.welcomeChipDiet,
                            PopHue.mint,
                            0.04,
                            1,
                          ),
                          chip(
                            PhosphorIcons.chartLineUp(PhosphorIconsStyle.bold),
                            l.welcomeChipProgress,
                            PopHue.grape,
                            -0.03,
                            2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AbsSpace.x8),
                    if (!env.isConfigured) ...[
                      Container(
                        padding: const EdgeInsets.all(AbsSpace.x4),
                        decoration: stickerDecoration(
                          c,
                          color: c.pop(PopHue.tangerine).soft,
                          lipDepth: 0,
                          borderRadius: AbsRadius.buttonAll,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(PhosphorIcons.warning(PhosphorIconsStyle.bold), color: c.warning),
                            const SizedBox(width: AbsSpace.x3),
                            Expanded(
                              child: Text(
                                env.configError != null ? l.authBackendError : l.welcomeNotConfigured,
                                style: t.label,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AbsSpace.x5),
                    ],
                    if (refused != null) ...[
                      _RefusedCard(
                        message: friendlyError(l, refused),
                        onClose: () => ref.read(authRepositoryProvider).clearSignInError(),
                      ),
                      const SizedBox(height: AbsSpace.x4),
                    ],
                    enter(
                      AbsButton(
                        key: const ValueKey('google-sign-in'),
                        label: l.welcomeGoogle,
                        icon: PhosphorIcons.googleLogo(PhosphorIconsStyle.bold),
                        isLoading: _busy,
                        onPressed: _google,
                      ),
                      4,
                    ),
                    const SizedBox(height: AbsSpace.x3),
                    enter(
                      Text(
                        l.welcomeGoogleHint,
                        style: t.caption.copyWith(color: c.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      5,
                    ),
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

/// "This Google account isn't registered…" with a way to dismiss it.
class _RefusedCard extends StatelessWidget {
  const _RefusedCard({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(PopHue.coral);
    return Container(
      key: const ValueKey('sign-in-refused'),
      padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x3, AbsSpace.x1, AbsSpace.x3),
      decoration: stickerDecoration(c, color: p.soft, lipDepth: 0, borderRadius: AbsRadius.buttonAll),
      child: Row(
        children: [
          Icon(PhosphorIcons.userCircleMinus(PhosphorIconsStyle.bold), color: p.text),
          const SizedBox(width: AbsSpace.x3),
          Expanded(child: Text(message, style: context.text.label)),
          IconButton(
            tooltip: context.l10n.commonClose,
            icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
