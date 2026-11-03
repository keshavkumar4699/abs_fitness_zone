import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/abs_button.dart';
import '../../../core/widgets/states.dart';
import '../application/onboarding_controller.dart';

/// First-run member onboarding: three swipeable cards, each in its own pop
/// colour, with a parallax sticker illustration.
class MemberOnboardingScreen extends ConsumerStatefulWidget {
  const MemberOnboardingScreen({super.key});

  @override
  ConsumerState<MemberOnboardingScreen> createState() => _MemberOnboardingScreenState();
}

class _MemberOnboardingScreenState extends ConsumerState<MemberOnboardingScreen> {
  final _pages = PageController();
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pages.addListener(() => setState(() => _page = _pages.page ?? 0));
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _done() => ref.read(onboardingControllerProvider.notifier).complete();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final cards = [
      (
        PhosphorIcons.identificationCard(PhosphorIconsStyle.bold),
        l.onboardingTrackTitle,
        l.onboardingTrackBody,
        PopHue.sky,
      ),
      (
        PhosphorIcons.barbell(PhosphorIconsStyle.bold),
        l.onboardingWorkoutTitle,
        l.onboardingWorkoutBody,
        PopHue.bubblegum,
      ),
      (PhosphorIcons.bowlFood(PhosphorIconsStyle.bold), l.onboardingDietTitle, l.onboardingDietBody, PopHue.mint),
    ];
    final index = _page.round().clamp(0, cards.length - 1);
    final last = index == cards.length - 1;
    // Background tint blends between neighbouring cards as you swipe.
    final from = c.pop(cards[_page.floor().clamp(0, cards.length - 1)].$4).fill;
    final to = c.pop(cards[_page.ceil().clamp(0, cards.length - 1)].$4).fill;
    final tint = Color.lerp(from, to, _page - _page.floor())!;

    return Scaffold(
      backgroundColor: Color.alphaBlend(tint.withValues(alpha: c.isDark ? 0.14 : 0.22), c.bg),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [if (!last) TextButton(onPressed: _done, child: Text(l.commonSkip))],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: cards.length,
                itemBuilder: (context, i) {
                  final (icon, title, body, hue) = cards[i];
                  return _OnboardingCard(
                    icon: icon,
                    title: title,
                    body: body,
                    hue: hue,
                    parallax: (_page - i).clamp(-1.0, 1.0),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < cards.length; i++)
                  AnimatedContainer(
                    duration: AbsMotion.bouncy.duration,
                    curve: AbsMotion.bouncy.curve,
                    margin: const EdgeInsets.symmetric(horizontal: AbsSpace.x1),
                    width: index == i ? AbsSpace.x8 : AbsSpace.x3,
                    height: AbsSpace.x3,
                    decoration: BoxDecoration(
                      color: index == i ? c.pop(cards[i].$4).fill : c.border,
                      borderRadius: AbsRadius.pill,
                      border: Border.all(
                        color: index == i ? (c.isDark ? c.pop(cards[i].$4).deep : c.ink) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(context.screenPadding),
              child: AbsButton(
                label: last ? l.onboardingStart : l.commonNext,
                hue: cards[index].$4,
                onPressed: last
                    ? _done
                    : () => _pages.nextPage(duration: AbsMotion.standard.duration, curve: AbsMotion.standard.curve),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.hue,
    required this.parallax,
  });

  final IconData icon;
  final String title;
  final String body;
  final PopHue hue;

  /// -1..1, how far this card is from the centre of the viewport.
  final double parallax;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(parallax * width * 0.35, 0),
                child: Transform.rotate(
                  angle: parallax * 0.3,
                  child: StickerIllustration(icon: icon, hue: hue, size: 240),
                ),
              ),
            ),
          ),
          Text(title, style: t.displayL),
          const SizedBox(height: AbsSpace.x3),
          Text(body, style: t.body.copyWith(color: c.textSecondary, fontSize: 17)),
          const SizedBox(height: AbsSpace.x8),
        ],
      ),
    );
  }
}
