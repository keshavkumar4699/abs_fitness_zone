import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Chunky animated ring for membership days, workout completion and macros.
/// Draws in once on first view; later changes animate from the old value.
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 104,
    this.strokeWidth = AbsSize.ringStroke,
    this.hue = PopHue.lime,
    this.child,
    this.semanticsLabel,
  });

  /// 0.0 – 1.0
  final double progress;
  final double size;
  final double strokeWidth;
  final PopHue hue;
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
    final p = c.pop(widget.hue);
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
            duration: AbsMotion.bouncy.duration,
            curve: AbsMotion.expressive.curve,
            builder: (context, value, child) => CustomPaint(
              painter: _RingPainter(
                progress: value,
                track: p.fill.withValues(alpha: c.isDark ? 0.18 : 0.25),
                color: p.fill,
                edge: c.isDark ? p.deep : c.ink,
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
  _RingPainter({
    required this.progress,
    required this.track,
    required this.color,
    required this.edge,
    required this.stroke,
  });

  final double progress;
  final Color track;
  final Color color;
  final Color edge;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = (Offset.zero & size).deflate(stroke / 2 + 2);
    canvas.drawArc(
      arcRect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    if (progress <= 0) return;
    final sweep = math.pi * 2 * progress.clamp(0.0, 1.0);
    // Ink edge under the arc gives it the same sticker outline as cards.
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke + 3
        ..strokeCap = StrokeCap.round
        ..color = edge,
    );
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke - 1
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track || old.stroke != stroke || old.edge != edge;
}
