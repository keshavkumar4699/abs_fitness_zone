import 'package:flutter/material.dart';

/// Bundled font families (never fetched at runtime). Baloo 2 is a rounded,
/// friendly display face with ₹ and tabular figures; Nunito is a rounded body
/// face that also has ₹.
abstract final class AbsFonts {
  static const display = 'Baloo2';
  static const text = 'Nunito';

  /// Devanagari (Hindi) glyphs, which the two families above don't have.
  static const fallback = ['NotoSansDevanagari'];
}

/// Type scale. Read through `context.text`.
@immutable
class AbsTypography extends ThemeExtension<AbsTypography> {
  const AbsTypography({
    required this.displayXL,
    required this.displayL,
    required this.title,
    required this.heading,
    required this.body,
    required this.label,
    required this.caption,
    required this.numeric,
  });

  factory AbsTypography.forColor(Color color) {
    const tabular = [FontFeature.tabularFigures()];
    TextStyle style(String family, double size, double lineHeight, FontWeight weight) => TextStyle(
      fontFamily: family,
      fontFamilyFallback: AbsFonts.fallback,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return AbsTypography(
      displayXL: style(AbsFonts.display, 52, 56, FontWeight.w800).copyWith(fontFeatures: tabular),
      displayL: style(AbsFonts.display, 36, 40, FontWeight.w800).copyWith(fontFeatures: tabular),
      title: style(AbsFonts.display, 24, 30, FontWeight.w700),
      heading: style(AbsFonts.text, 17, 24, FontWeight.w800),
      body: style(AbsFonts.text, 15, 22, FontWeight.w600),
      label: style(AbsFonts.text, 13, 18, FontWeight.w700),
      caption: style(AbsFonts.text, 12, 16, FontWeight.w600),
      numeric: const TextStyle(
        fontFamily: AbsFonts.display,
        fontFamilyFallback: AbsFonts.fallback,
        fontWeight: FontWeight.w700,
        fontFeatures: tabular,
      ),
    );
  }

  final TextStyle displayXL;
  final TextStyle displayL;
  final TextStyle title;
  final TextStyle heading;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;

  /// Merge onto another style for money, counts, reps and kg.
  final TextStyle numeric;

  /// [base] rendered in the numeric face with tabular figures.
  TextStyle numericOf(TextStyle base) => base.merge(numeric);

  TextTheme toTextTheme() => TextTheme(
    displayLarge: displayXL,
    displayMedium: displayL,
    headlineSmall: title,
    titleLarge: title,
    titleMedium: heading,
    titleSmall: label,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: label,
    labelMedium: label,
    labelSmall: caption,
  );

  @override
  AbsTypography copyWith({
    TextStyle? displayXL,
    TextStyle? displayL,
    TextStyle? title,
    TextStyle? heading,
    TextStyle? body,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? numeric,
  }) {
    return AbsTypography(
      displayXL: displayXL ?? this.displayXL,
      displayL: displayL ?? this.displayL,
      title: title ?? this.title,
      heading: heading ?? this.heading,
      body: body ?? this.body,
      label: label ?? this.label,
      caption: caption ?? this.caption,
      numeric: numeric ?? this.numeric,
    );
  }

  @override
  AbsTypography lerp(AbsTypography? other, double t) {
    if (other == null) return this;
    return AbsTypography(
      displayXL: TextStyle.lerp(displayXL, other.displayXL, t)!,
      displayL: TextStyle.lerp(displayL, other.displayL, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      heading: TextStyle.lerp(heading, other.heading, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      numeric: TextStyle.lerp(numeric, other.numeric, t)!,
    );
  }
}
