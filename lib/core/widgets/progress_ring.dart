import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Animated arc for membership days used, workout completion and macros.
/// Draws in once on first view (not on every rebuild); later value changes
/// animate from the previous value.
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 96,
    this.strokeWidth = AbsSize.ringStroke,
    this.color,
    this.child,
    this.semanticsLabel,
  });

  /// 0.0 – 1.0
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? child;
  final String? semanticsLabel;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing> {
  double _from = 0;

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) _from = oldWidget.progress;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final target = widget.progress.clamp(0.0, 1.0);
    final reduced = AbsMotion.reduced(context);
    return Semantics(
      label: widget.semanticsLabel,
      value: '${(target * 100).round()}%',
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: widget.size,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: reduced ? target : _from, end: target),
            duration: AbsMotion.expressive.duration,
            curve: AbsMotion.expressive.curve,
            builder: (context, value, child) => CustomPaint(
              painter: _RingPainter(
                progress: value,
                track: c.border,
                color: widget.color ?? c.accent,
                stroke: widget.strokeWidth,
              ),
              child: child,
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.track, required this.color, required this.stroke});

  final double progress;
  final Color track;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, base);
    if (progress <= 0) return;
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * progress.clamp(0.0, 1.0), false, fg);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track || old.stroke != stroke;
}
