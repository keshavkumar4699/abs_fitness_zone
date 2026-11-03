import 'package:flutter/widgets.dart';

/// Spacing scale on a 4-pt grid.
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

/// Corner radii: generous and friendly.
abstract final class AbsRadius {
  static const double chip = 12;
  static const double button = 18;
  static const double card = 24;
  static const double sheet = 32;
  static const double full = 999;

  static const BorderRadius chipAll = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius buttonAll = BorderRadius.all(Radius.circular(button));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius sheetTop = BorderRadius.vertical(top: Radius.circular(sheet));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}

/// Sticker depth: a bold outline and a hard offset "lip" instead of blurry
/// shadows. Pressing an element squishes it down onto its lip.
abstract final class AbsDepth {
  static const double outline = 2;
  static const double lip = 4;
  static const double cardLip = 4;
}

/// Fixed component sizes.
abstract final class AbsSize {
  static const double buttonHeight = 54;
  static const double fieldHeight = 54;
  static const double touchTarget = 48;
  static const double icon = 24;
  static const double iconSmall = 18;
  static const double iconStroke = 2.25;
  static const double hairline = 1;
  static const double avatar = 46;
  static const double avatarRing = 2.5;
  static const double ringStroke = 10;
  static const double dragHandleWidth = 44;
  static const double dragHandleHeight = 5;
  static const double pillHeight = 26;
  static const double sparklineHeight = 32;
  static const double chartHeight = 180;
  static const double emptyIllustration = 132;
  static const double iconBubble = 44;
  static const double sideNavWidth = 248;
  static const double sideNavCollapsedWidth = 84;
  static const double bottomNavHeight = 68;
}

/// Layout breakpoints for the adaptive shell.
abstract final class AbsBreakpoint {
  static const double tablet = 600;
  static const double desktop = 1024;
}

/// Glass (blur) used behind sticky headers.
abstract final class AbsGlass {
  static const double sigma = 20;
  static const double opacity = 0.8;
}

/// Opacity steps.
abstract final class AbsOpacity {
  static const double pressedOverlay = 0.06;
  static const double disabled = 0.45;
  static const double subtleFill = 0.18;
  static const double dim = 0.6;
}

/// Text scaling the UI must support without overflow.
abstract final class AbsTextScale {
  static const double max = 1.3;
}
