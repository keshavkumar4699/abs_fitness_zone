import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import 'abs_button.dart';

enum EmptyIllustration { dumbbell, people, search, clock, rocket }

/// Playful empty state: a bobbing sticker illustration on a pop blob, one
/// sentence and one primary action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.illustration = EmptyIllustration.dumbbell,
    this.hue = PopHue.grape,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EmptyIllustration illustration;
  final PopHue hue;

  static IconData iconFor(EmptyIllustration i) => switch (i) {
    EmptyIllustration.dumbbell => PhosphorIcons.barbell(PhosphorIconsStyle.bold),
    EmptyIllustration.people => PhosphorIcons.usersThree(PhosphorIconsStyle.bold),
    EmptyIllustration.search => PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
    EmptyIllustration.clock => PhosphorIcons.hourglassHigh(PhosphorIconsStyle.bold),
    EmptyIllustration.rocket => PhosphorIcons.rocketLaunch(PhosphorIconsStyle.bold),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.screenPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StickerIllustration(icon: iconFor(illustration), hue: hue),
              const SizedBox(height: AbsSpace.x6),
              Text(title, style: t.title, textAlign: TextAlign.center),
              const SizedBox(height: AbsSpace.x2),
              Text(
                message,
                style: t.body.copyWith(color: c.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AbsSpace.x6),
                AbsButton(label: actionLabel!, onPressed: onAction, expand: false, hue: hue),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Big icon sticker on a wobbly blob with confetti bits; gently bobs.
class StickerIllustration extends StatelessWidget {
  const StickerIllustration({super.key, required this.icon, required this.hue, this.size = AbsSize.emptyIllustration});

  final IconData icon;
  final PopHue hue;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(hue);
    Widget sticker = Transform.rotate(
      angle: -0.08,
      child: Container(
        width: size * 0.56,
        height: size * 0.56,
        decoration: BoxDecoration(
          color: p.fill,
          borderRadius: BorderRadius.circular(size * 0.18),
          border: Border.all(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline),
          boxShadow: [BoxShadow(color: c.isDark ? p.deep : c.ink, offset: const Offset(0, AbsDepth.lip))],
        ),
        child: Icon(icon, size: size * 0.28, color: p.onFill),
      ),
    );
    if (!AbsMotion.reduced(context)) {
      sticker = sticker
          .animate(onPlay: (a) => a.repeat(reverse: true))
          .moveY(begin: -4, end: 4, duration: 1600.ms, curve: Curves.easeInOutSine);
    }
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size.square(size),
              painter: _BlobBits(p.fill, c.pop(PopHue.lime).fill, c.pop(PopHue.bubblegum).fill),
            ),
            sticker,
          ],
        ),
      ),
    );
  }
}

class _BlobBits extends CustomPainter {
  _BlobBits(this.blob, this.a, this.b);

  final Color blob;
  final Color a;
  final Color b;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);
    final path = Path();
    for (var i = 0; i <= 48; i++) {
      final ang = i / 48 * math.pi * 2;
      final r = s * 0.44 * (1 + 0.07 * math.sin(ang * 3) + 0.04 * math.cos(ang * 5));
      final p = center + Offset(math.cos(ang), math.sin(ang)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), Paint()..color = blob.withValues(alpha: 0.28));
    canvas.drawCircle(Offset(s * 0.12, s * 0.2), 5, Paint()..color = a);
    canvas.drawCircle(Offset(s * 0.9, s * 0.78), 4, Paint()..color = b);
    canvas.save();
    canvas.translate(s * 0.86, s * 0.16);
    canvas.rotate(0.6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-7, -3, 14, 6), const Radius.circular(3)),
      Paint()..color = b,
    );
    canvas.restore();
    canvas.save();
    canvas.translate(s * 0.14, s * 0.84);
    canvas.rotate(-0.4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-7, -3, 14, 6), const Radius.circular(3)),
      Paint()..color = a,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BlobBits old) => old.blob != blob || old.a != a || old.b != b;
}

/// Message plus retry.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.screenPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StickerIllustration(icon: PhosphorIcons.plugs(PhosphorIconsStyle.bold), hue: PopHue.coral, size: 112),
              const SizedBox(height: AbsSpace.x5),
              Text(message, style: context.text.heading, textAlign: TextAlign.center),
              const SizedBox(height: AbsSpace.x5),
              AbsButton.secondary(
                label: context.l10n.commonRetry,
                icon: PhosphorIcons.arrowClockwise(PhosphorIconsStyle.bold),
                onPressed: onRetry,
                expand: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
