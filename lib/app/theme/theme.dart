import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'tokens.dart';
import 'typography.dart';

export 'colors.dart';
export 'motion.dart';
export 'tokens.dart';
export 'typography.dart';

/// Builds the app theme for [brightness] purely from tokens.
ThemeData buildAbsTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AbsColors.dark : AbsColors.light;
  final t = AbsTypography.forColor(c.textPrimary);
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    secondary: c.info,
    onSecondary: c.onAccent,
    error: c.danger,
    onError: c.onAccent,
    surface: c.surface,
    onSurface: c.textPrimary,
    onSurfaceVariant: c.textSecondary,
    surfaceContainerHighest: c.surfaceRaised,
    surfaceContainerHigh: c.surfaceRaised,
    surfaceContainer: c.surface,
    surfaceContainerLow: c.surface,
    surfaceContainerLowest: c.bg,
    outline: c.border,
    outlineVariant: c.border,
    shadow: c.shadow,
    scrim: c.scrim,
  );

  const sharedAxis = SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal);

  final inputBorder = OutlineInputBorder(
    borderRadius: AbsRadius.chipAll,
    borderSide: BorderSide(color: c.border),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    fontFamily: AbsFonts.text,
    textTheme: t.toTextTheme(),
    extensions: [c, t],
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: DividerThemeData(color: c.border, thickness: AbsSize.hairline, space: AbsSize.hairline),
    iconTheme: IconThemeData(color: c.textPrimary, size: AbsSize.icon),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: t.title,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x4),
      labelStyle: t.body.copyWith(color: c.textSecondary),
      floatingLabelStyle: t.label.copyWith(color: c.accentText),
      helperStyle: t.caption.copyWith(color: c.textSecondary),
      errorStyle: t.caption.copyWith(color: c.danger),
      prefixStyle: t.numericOf(t.body).copyWith(color: c.textSecondary),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: c.accentText, width: 1.5)),
      errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: c.danger)),
      focusedErrorBorder: inputBorder.copyWith(borderSide: BorderSide(color: c.danger, width: 1.5)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.surfaceRaised,
      contentTextStyle: t.body.copyWith(color: c.textPrimary),
      actionTextColor: c.accentText,
      shape: const RoundedRectangleBorder(borderRadius: AbsRadius.buttonAll),
      elevation: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surfaceRaised,
      modalBackgroundColor: c.surfaceRaised,
      shape: const RoundedRectangleBorder(borderRadius: AbsRadius.sheetTop),
      showDragHandle: false,
      modalBarrierColor: c.scrim,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surfaceRaised,
      shape: const RoundedRectangleBorder(borderRadius: AbsRadius.cardAll),
      titleTextStyle: t.title,
      contentTextStyle: t.body.copyWith(color: c.textSecondary),
    ),
    // Depth comes from surface steps, not shadows (spec §4).
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.accent,
      foregroundColor: c.onAccent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      extendedTextStyle: t.heading.copyWith(color: c.onAccent),
      shape: const RoundedRectangleBorder(borderRadius: AbsRadius.cardAll),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent, circularTrackColor: c.border),
    textSelectionTheme: TextSelectionThemeData(cursorColor: c.accentText, selectionHandleColor: c.accent),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      indicatorColor: c.accent.withValues(alpha: AbsOpacity.subtleFill),
      height: AbsSize.bottomNavHeight,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => t.caption.copyWith(
          color: s.contains(WidgetState.selected) ? c.textPrimary : c.textSecondary,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: c.bg,
      indicatorColor: c.accent.withValues(alpha: AbsOpacity.subtleFill),
      selectedLabelTextStyle: t.caption.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600),
      unselectedLabelTextStyle: t.caption.copyWith(color: c.textSecondary),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: c.textSecondary,
      textColor: c.textPrimary,
      titleTextStyle: t.body,
      subtitleTextStyle: t.caption.copyWith(color: c.textSecondary),
      minVerticalPadding: AbsSpace.x3,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: sharedAxis,
        TargetPlatform.iOS: sharedAxis,
        TargetPlatform.linux: sharedAxis,
        TargetPlatform.macOS: sharedAxis,
        TargetPlatform.windows: sharedAxis,
        TargetPlatform.fuchsia: sharedAxis,
      },
    ),
  );
}

/// Short accessors so widgets never reach for raw values.
extension AbsThemeContext on BuildContext {
  AbsColors get colors => Theme.of(this).extension<AbsColors>()!;
  AbsTypography get text => Theme.of(this).extension<AbsTypography>()!;

  /// Screen side padding: 20 on phone, 32 on tablet and wider.
  double get screenPadding =>
      MediaQuery.sizeOf(this).width >= AbsBreakpoint.tablet ? AbsSpace.screenTablet : AbsSpace.screenPhone;
}
