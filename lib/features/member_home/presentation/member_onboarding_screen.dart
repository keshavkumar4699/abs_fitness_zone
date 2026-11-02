import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/abs_button.dart';
import '../application/onboarding_controller.dart';

/// First-run member onboarding: three swipeable cards with a parallax
/// illustration. (The push-permission prompt joins when push lands in M3.)
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
      (PhosphorIcons.identificationCard(), l.onboardingTrackTitle, l.onboardingTrackBody),
      (PhosphorIcons.barbell(), l.onboardingWorkoutTitle, l.onboardingWorkoutBody),
      (PhosphorIcons.bowlFood(), l.onboardingDietTitle, l.onboardingDietBody),
    ];
    final last = _page.round() == cards.length - 1;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!last)
            TextButton(
              onPressed: _done,
              child: Text(l.commonSkip, style: TextStyle(color: c.textSecondary)),
            ),
        ],
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
                  final (icon, title, body) = cards[i];
                  final offset = (_page - i).clamp(-1.0, 1.0);
                  return _OnboardingCard(icon: icon, title: title, body: body, parallax: offset);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < cards.length; i++)
                  AnimatedContainer(
                    duration: AbsMotion.quick.duration,
                    curve: AbsMotion.quick.curve,
                    margin: const EdgeInsets.symmetric(horizontal: AbsSpace.x1),
                    width: _page.round() == i ? AbsSpace.x6 : AbsSpace.x2,
                    height: AbsSpace.x2,
                    decoration: BoxDecoration(
                      color: _page.round() == i ? c.accent : c.border,
                      borderRadius: AbsRadius.pill,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(context.screenPadding),
              child: AbsButton(
                label: last ? l.onboardingStart : l.commonNext,
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
  const _OnboardingCard({required this.icon, required this.title, required this.body, required this.parallax});

  final IconData icon;
  final String title;
  final String body;

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background ring moves slower than the foreground icon.
                  Transform.translate(
                    offset: Offset(parallax * width * 0.15, 0),
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: c.border, width: 2),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(parallax * width * 0.3, 0),
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.accent.withValues(alpha: AbsOpacity.subtleFill),
                      ),
                      child: Icon(icon, size: 72, color: c.accentText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(title, style: t.displayL),
          const SizedBox(height: AbsSpace.x3),
          Text(body, style: t.body.copyWith(color: c.textSecondary)),
          const SizedBox(height: AbsSpace.x8),
        ],
      ),
    );
  }
}
