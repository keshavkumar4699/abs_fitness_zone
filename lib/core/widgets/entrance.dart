import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/theme.dart';

/// List entrance: fade + slide up 12 px with a 40 ms stagger (max 8 items).
/// Only plays when [animate] is true (first load), never on refresh/scroll.
class Entrance extends StatelessWidget {
  const Entrance({super.key, required this.index, required this.child, this.animate = true});

  final int index;
  final Widget child;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (!animate || index >= AbsMotion.staggerMaxItems || AbsMotion.reduced(context)) return child;
    return child
        .animate(delay: AbsMotion.staggerDelay(index))
        .fadeIn(duration: AbsMotion.quick.duration, curve: AbsMotion.staggerCurve)
        .moveY(
          begin: AbsMotion.entranceOffset,
          end: 0,
          duration: AbsMotion.quick.duration,
          curve: AbsMotion.staggerCurve,
        );
  }
}

/// Pull-to-refresh with the accent ring.
class AbsRefresh extends StatelessWidget {
  const AbsRefresh({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: c.accent,
      backgroundColor: c.surfaceRaised,
      strokeWidth: 3,
      child: child,
    );
  }
}
