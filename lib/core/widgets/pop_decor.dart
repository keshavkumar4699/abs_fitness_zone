import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/theme.dart';

/// An icon sitting in a round pop-coloured bubble.
class IconBubble extends StatelessWidget {
  const IconBubble({
    super.key,
    required this.icon,
    required this.hue,
    this.size = AbsSize.iconBubble,
    this.solid = true,
  });

  final IconData icon;
  final PopHue hue;
  final double size;

  /// Solid fill with ink icon, or a soft tint with a coloured icon.
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(hue);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: solid ? p.fill : p.soft,
        shape: BoxShape.circle,
        border: solid ? Border.all(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline) : null,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.5, color: solid ? p.onFill : p.text),
    );
  }
}

/// Soft colourful blobs and confetti bits behind a screen. Purely decorative
/// and excluded from semantics.
class PopBackground extends StatelessWidget {
  const PopBackground({
    super.key,
    required this.child,
    this.hues = const [PopHue.grape, PopHue.bubblegum, PopHue.lime],
    this.animate = true,
  });

  final Widget child;
  final List<PopHue> hues;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final colors = [for (final h in hues) c.pop(h).fill];
    Widget painter = CustomPaint(painter: _BlobPainter(colors, c.isDark), size: Size.infinite);
    if (animate && !AbsMotion.reduced(context)) {
      painter = painter
          .animate(onPlay: (a) => a.repeat(reverse: true))
          .moveY(begin: -6, end: 6, duration: 4.seconds, curve: Curves.easeInOutSine);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: IgnorePointer(child: RepaintBoundary(child: painter)),
        ),
        child,
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter(this.colors, this.dark);

  final List<Color> colors;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final alpha = dark ? 0.22 : 0.32;
    void blob(Offset center, double r, Color color) {
      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      final path = Path();
      for (var i = 0; i <= 64; i++) {
        final a = i / 64 * math.pi * 2;
        final wobble = 1 + 0.08 * math.sin(a * 3) + 0.05 * math.cos(a * 5);
        final p = center + Offset(math.cos(a), math.sin(a)) * r * wobble;
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path..close(), paint);
    }

    blob(Offset(w * 0.95, h * 0.08), w * 0.42, colors[0 % colors.length]);
    blob(Offset(w * -0.05, h * 0.42), w * 0.32, colors[1 % colors.length]);
    blob(Offset(w * 0.85, h * 0.92), w * 0.38, colors[2 % colors.length]);

    // Confetti bits.
    final rnd = math.Random(7);
    for (var i = 0; i < 18; i++) {
      final color = colors[i % colors.length];
      final p = Offset(rnd.nextDouble() * w, rnd.nextDouble() * h);
      final paint = Paint()..color = color.withValues(alpha: dark ? 0.7 : 0.85);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(rnd.nextDouble() * math.pi);
      switch (i % 3) {
        case 0:
          canvas.drawRRect(
            RRect.fromRectAndRadius(const Rect.fromLTWH(-5, -2, 10, 4), const Radius.circular(2)),
            paint,
          );
        case 1:
          canvas.drawCircle(Offset.zero, 3, paint);
        default:
          final path = Path()
            ..moveTo(0, -4)
            ..lineTo(4, 3)
            ..lineTo(-4, 3)
            ..close();
          canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.dark != dark || old.colors != colors;
}

/// One-shot confetti burst for celebration moments (skippable: it ignores
/// touches and lasts about a second).
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key, this.play = true});

  final bool play;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

  @override
  void initState() {
    super.initState();
    if (widget.play) _c.forward();
  }

  @override
  void didUpdateWidget(ConfettiBurst old) {
    super.didUpdateWidget(old);
    if (widget.play && !old.play) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AbsMotion.reduced(context)) return const SizedBox.shrink();
    final c = context.colors;
    final colors = [for (final h in PopHue.values) c.pop(h).fill];
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => _c.value == 0 || _c.isCompleted
              ? const SizedBox.shrink()
              : CustomPaint(painter: _ConfettiPainter(_c.value, colors), size: Size.infinite),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.colors);

  final double t;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(42);
    final origin = Offset(size.width / 2, size.height * 0.45);
    final fade = t < 0.7 ? 1.0 : 1 - (t - 0.7) / 0.3;
    for (var i = 0; i < 48; i++) {
      final angle = rnd.nextDouble() * math.pi * 2;
      final speed = 180 + rnd.nextDouble() * 260;
      final d = speed * Curves.easeOutCubic.transform(t);
      final gravity = 320 * t * t;
      final p = origin + Offset(math.cos(angle) * d, math.sin(angle) * d + gravity);
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: fade);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(angle + t * 8);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-6, -3, 12, 6), const Radius.circular(2)), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

/// Gentle continuous wiggle (e.g. a waving hand).
class Wiggle extends StatelessWidget {
  const Wiggle({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (AbsMotion.reduced(context)) return child;
    return child
        .animate(onPlay: (a) => a.repeat())
        .rotate(begin: -0.03, end: 0.03, duration: 350.ms, curve: Curves.easeInOut)
        .then()
        .rotate(begin: 0.03, end: -0.03, duration: 350.ms, curve: Curves.easeInOut)
        .then(delay: 1600.ms);
  }
}
