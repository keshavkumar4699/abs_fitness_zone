import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// A duration + curve pair.
@immutable
class MotionToken {
  const MotionToken(this.duration, this.curve);

  final Duration duration;
  final Curve curve;
}

/// Motion tokens (spec §5). Every animation in the app uses one of these.
abstract final class AbsMotion {
  static const instant = MotionToken(Duration(milliseconds: 120), Curves.easeOut);
  static const quick = MotionToken(Duration(milliseconds: 200), Curves.easeOutCubic);
  static const standard = MotionToken(Duration(milliseconds: 300), Curves.easeInOutCubicEmphasized);
  static const expressive = MotionToken(Duration(milliseconds: 450), springCurve);

  /// List/grid entrance stagger: 40 ms per item, at most 8 items.
  static const staggerStep = Duration(milliseconds: 40);
  static const staggerMaxItems = 8;
  static const staggerCurve = Curves.easeOutCubic;

  /// Skeleton → content cross-fade.
  static const crossFade = Duration(milliseconds: 200);

  /// Entrance slide distance for list items (12 px).
  static const entranceOffset = 12.0;

  /// Press scale for buttons and tappable cards.
  static const pressScale = 0.97;

  /// Spring used by the expressive token (stiffness 300, damping 26).
  static const spring = SpringDescription(mass: 1, stiffness: 300, damping: 26);
  static const springCurve = SpringCurve(spring);

  /// Delay for item [index] in a staggered entrance (capped at 8 items).
  static Duration staggerDelay(int index) => staggerStep * (index < staggerMaxItems ? index : staggerMaxItems);

  /// True when the platform asks for reduced motion; animations collapse to
  /// simple fades or jump to their end state.
  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}

/// A [Curve] that follows a critically/under-damped spring from 0 to 1.
class SpringCurve extends Curve {
  const SpringCurve(this.spring);

  final SpringDescription spring;

  @override
  double transformInternal(double t) {
    // Simulate over a normalised one-second window, then rescale so that the
    // curve still ends exactly at 1.0 when t == 1.
    final sim = SpringSimulation(spring, 0, 1, 0);
    final end = sim.x(1);
    return sim.x(t) / end;
  }
}
