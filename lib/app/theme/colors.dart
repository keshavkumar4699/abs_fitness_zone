import 'package:flutter/material.dart';

/// Colour tokens (spec §4). Widgets read these through `context.colors`;
/// raw hex values live only in this file.
@immutable
class AbsColors extends ThemeExtension<AbsColors> {
  const AbsColors({
    required this.bg,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.accentText,
    required this.onAccent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.chart,
    required this.highlight,
    required this.shadow,
    required this.scrim,
  });

  final Color bg;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  /// Volt accent used for fills (buttons, progress, focus rings).
  final Color accent;

  /// Accent used for text and thin strokes; darker in light mode for AA contrast.
  final Color accentText;
  final Color onAccent;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  /// chart1..chart5, charts only.
  final List<Color> chart;

  /// 1 px top highlight on dark surfaces (white at 4%).
  final Color highlight;

  /// Soft shadow colour used in light mode; transparent in dark mode.
  final Color shadow;

  /// Dimming layer behind modals.
  final Color scrim;

  static const _volt = Color(0xFFC6F432);

  static const dark = AbsColors(
    bg: Color(0xFF0B0D10),
    surface: Color(0xFF14171C),
    surfaceRaised: Color(0xFF1C2027),
    border: Color(0xFF262B33),
    textPrimary: Color(0xFFF2F4F7),
    textSecondary: Color(0xFF9AA3AF),
    accent: _volt,
    accentText: _volt,
    onAccent: Color(0xFF0B0D10),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
    chart: [_volt, Color(0xFF60A5FA), Color(0xFFA78BFA), Color(0xFFF472B6), Color(0xFF34D399)],
    highlight: Color(0x0AFFFFFF),
    shadow: Color(0x00000000),
    scrim: Color(0x99000000),
  );

  static const light = AbsColors(
    bg: Color(0xFFF6F7F9),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    border: Color(0xFFE4E7EC),
    textPrimary: Color(0xFF0F1217),
    textSecondary: Color(0xFF5B6472),
    accent: _volt,
    accentText: Color(0xFF5C7A00),
    onAccent: Color(0xFF0B0D10),
    success: Color(0xFF059669),
    warning: Color(0xFFB45309),
    danger: Color(0xFFDC2626),
    info: Color(0xFF2563EB),
    chart: [Color(0xFF5C7A00), Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFFDB2777), Color(0xFF059669)],
    highlight: Color(0x00FFFFFF),
    shadow: Color(0x0F0F1217),
    scrim: Color(0x660F1217),
  );

  bool get isDark => bg.computeLuminance() < 0.2;

  @override
  AbsColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
    Color? accentText,
    Color? onAccent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    List<Color>? chart,
    Color? highlight,
    Color? shadow,
    Color? scrim,
  }) {
    return AbsColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      accentText: accentText ?? this.accentText,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      chart: chart ?? this.chart,
      highlight: highlight ?? this.highlight,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AbsColors lerp(AbsColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AbsColors(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      surfaceRaised: l(surfaceRaised, other.surfaceRaised),
      border: l(border, other.border),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      accent: l(accent, other.accent),
      accentText: l(accentText, other.accentText),
      onAccent: l(onAccent, other.onAccent),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      danger: l(danger, other.danger),
      info: l(info, other.info),
      chart: [for (var i = 0; i < chart.length; i++) l(chart[i], other.chart[i])],
      highlight: l(highlight, other.highlight),
      shadow: l(shadow, other.shadow),
      scrim: l(scrim, other.scrim),
    );
  }
}
