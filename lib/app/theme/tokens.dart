import 'package:flutter/widgets.dart';

/// Spacing scale on a 4-pt grid (spec §4).
abstract final class AbsSpace {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x14 = 56;

  static const double screenPhone = x5;
  static const double screenTablet = x8;
  static const double maxContentWidth = 1200;
}

/// Corner radii (spec §4).
abstract final class AbsRadius {
  static const double chip = 8;
  static const double button = 14;
  static const double card = 20;
  static const double sheet = 28;
  static const double full = 999;

  static const BorderRadius chipAll = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius buttonAll = BorderRadius.all(Radius.circular(button));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius sheetTop = BorderRadius.vertical(top: Radius.circular(sheet));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}

/// Fixed component sizes.
abstract final class AbsSize {
  static const double buttonHeight = 52;
  static const double fieldHeight = 52;
  static const double touchTarget = 48;
  static const double icon = 24;
  static const double iconSmall = 18;
  static const double iconStroke = 1.75;
  static const double hairline = 1;
  static const double avatar = 44;
  static const double avatarRing = 2.5;
  static const double ringStroke = 8;
  static const double dragHandleWidth = 36;
  static const double dragHandleHeight = 4;
  static const double pillHeight = 24;
  static const double sparklineHeight = 32;
  static const double chartHeight = 180;
  static const double skeletonLine = 12;
  static const double emptyIllustration = 96;
  static const double sideNavWidth = 248;
  static const double sideNavCollapsedWidth = 80;
  static const double bottomNavHeight = 64;
}

/// Layout breakpoints for the adaptive shell.
abstract final class AbsBreakpoint {
  static const double tablet = 600;
  static const double desktop = 1024;
}

/// Glass (blur) used only by the bottom navigation and sticky headers.
abstract final class AbsGlass {
  static const double sigma = 20;
  static const double opacity = 0.72;
}

/// Opacity steps used for pressed/hover/disabled states.
abstract final class AbsOpacity {
  static const double pressedOverlay = 0.04;
  static const double disabled = 0.4;
  static const double subtleFill = 0.14;
  static const double dim = 0.6;
}

/// Shadow geometry for light mode (0 4 16).
abstract final class AbsElevation {
  static const Offset shadowOffset = Offset(0, 4);
  static const double shadowBlur = 16;
}

/// Text scaling the UI must support without overflow.
abstract final class AbsTextScale {
  static const double max = 1.3;
}
