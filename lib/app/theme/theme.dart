import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
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
    secondary: c.pop(PopHue.grape).fill,
    onSecondary: c.pop(PopHue.grape).onFill,
    tertiary: c.pop(PopHue.bubblegum).fill,
    onTertiary: c.pop(PopHue.bubblegum).onFill,
    error: c.danger,
    onError: c.surface,
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
    borderRadius: AbsRadius.buttonAll,
    borderSide: BorderSide(color: c.border, width: AbsDepth.outline),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    fontFamily: AbsFonts.text,
    fontFamilyFallback: AbsFonts.fallback,
    textTheme: t.toTextTheme(),
    extensions: [c, t],
    // InkSparkle needs a fragment shader; keep the safe ripple on web.
    splashFactory: kIsWeb ? InkRipple.splashFactory : InkSparkle.splashFactory,
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
      floatingLabelStyle: t.label.copyWith(color: c.pop(PopHue.grape).text),
      hintStyle: t.body.copyWith(color: c.textSecondary),
      helperStyle: t.caption.copyWith(color: c.textSecondary),
      errorStyle: t.caption.copyWith(color: c.danger),
      prefixStyle: t.numericOf(t.body).copyWith(color: c.textSecondary),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: c.pop(PopHue.grape).text, width: AbsDepth.outline + 0.5),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: c.danger, width: AbsDepth.outline),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: c.danger, width: AbsDepth.outline + 0.5),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.surfaceRaised,
      contentTextStyle: t.body.copyWith(color: c.textPrimary),
      actionTextColor: c.pop(PopHue.grape).text,
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
      shape: RoundedRectangleBorder(
        borderRadius: AbsRadius.cardAll,
        side: BorderSide(color: c.isDark ? c.border : c.ink, width: AbsDepth.outline),
      ),
      titleTextStyle: t.title,
      contentTextStyle: t.body.copyWith(color: c.textSecondary),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: c.pop(PopHue.grape).text, textStyle: t.label),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent, circularTrackColor: c.border),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.pop(PopHue.grape).text,
      selectionHandleColor: c.pop(PopHue.grape).fill,
      selectionColor: c.pop(PopHue.grape).soft,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.ink : c.textSecondary),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.accent : c.border),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.textPrimary,
      unselectedLabelColor: c.textSecondary,
      labelStyle: t.label,
      unselectedLabelStyle: t.label,
      indicatorColor: c.pop(PopHue.bubblegum).fill,
      dividerColor: c.border,
    ),
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

/// Sticker surface: bold outline + hard offset lip, no blur.
BoxDecoration stickerDecoration(
  AbsColors c, {
  Color? color,
  Color? outline,
  Color? lip,
  double lipDepth = AbsDepth.cardLip,
  BorderRadius borderRadius = AbsRadius.cardAll,
}) {
  return BoxDecoration(
    color: color ?? c.surface,
    borderRadius: borderRadius,
    border: Border.all(color: outline ?? (c.isDark ? c.border : c.ink), width: AbsDepth.outline),
    boxShadow: lipDepth <= 0
        ? null
        : [BoxShadow(color: lip ?? (c.isDark ? c.shadow : c.ink), offset: Offset(0, lipDepth))],
  );
}

/// Picks a stable pop hue for a name (avatars, initials bubbles).
PopHue hueForName(String name) {
  const hues = [PopHue.sky, PopHue.tangerine, PopHue.bubblegum, PopHue.grape, PopHue.mint, PopHue.lime];
  var h = 0;
  for (final unit in name.codeUnits) {
    h = (h * 31 + unit) & 0x7fffffff;
  }
  return hues[h % hues.length];
}
