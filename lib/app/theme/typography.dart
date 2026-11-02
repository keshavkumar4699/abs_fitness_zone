import 'package:flutter/material.dart';

/// Font families bundled in assets/fonts (never fetched at runtime).
abstract final class AbsFonts {
  static const display = 'Sora';
  static const text = 'Inter';

  /// Per-glyph fallback that supplies ₹ for both families.
  static const fallback = ['AbsRupee'];
}

/// Type scale (spec §4). Read through `context.text`.
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
    TextStyle style(String family, double size, double lineHeight, FontWeight weight) {
      return TextStyle(
        fontFamily: family,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        color: color,
        letterSpacing: 0,
        fontFamilyFallback: AbsFonts.fallback,
      );
    }

    return AbsTypography(
      displayXL: style(AbsFonts.display, 48, 52, FontWeight.w700).copyWith(fontFeatures: tabular, letterSpacing: -1),
      displayL: style(AbsFonts.display, 34, 40, FontWeight.w700).copyWith(fontFeatures: tabular, letterSpacing: -0.5),
      title: style(AbsFonts.display, 22, 28, FontWeight.w600),
      heading: style(AbsFonts.text, 17, 24, FontWeight.w600),
      body: style(AbsFonts.text, 15, 22, FontWeight.w400),
      label: style(AbsFonts.text, 13, 18, FontWeight.w500),
      caption: style(AbsFonts.text, 12, 16, FontWeight.w400),
      // Numeric inherits size/line height from where it is merged in.
      numeric: const TextStyle(
        fontFamily: AbsFonts.display,
        fontFamilyFallback: AbsFonts.fallback,
        fontWeight: FontWeight.w600,
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
