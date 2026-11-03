import 'package:flutter/material.dart';

/// The six playful "pop" hues (plus coral for danger). Every section of the
/// app owns one hue, so colour tells people where they are.
enum PopHue { lime, sky, tangerine, bubblegum, grape, mint, coral }

/// One pop colour in all the forms the UI needs.
@immutable
class PopColor {
  const PopColor({required this.fill, required this.deep, required this.text, required this.onFill});

  /// Vivid fill for buttons, stickers, blobs.
  final Color fill;

  /// Darker shade used for the 3D "lip" under buttons and sticker shadows.
  final Color deep;

  /// Text/icon colour that passes WCAG AA on the page background.
  final Color text;

  /// Ink colour for text placed on [fill] (AA on every fill).
  final Color onFill;

  /// Soft tint for backgrounds and pills.
  Color get soft => fill.withValues(alpha: 0.22);

  PopColor lerp(PopColor o, double t) => PopColor(
    fill: Color.lerp(fill, o.fill, t)!,
    deep: Color.lerp(deep, o.deep, t)!,
    text: Color.lerp(text, o.text, t)!,
    onFill: Color.lerp(onFill, o.onFill, t)!,
  );
}

/// Colour tokens. Widgets read these through `context.colors`; raw hex values
/// live only in this file.
@immutable
class AbsColors extends ThemeExtension<AbsColors> {
  const AbsColors({
    required this.bg,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.ink,
    required this.textPrimary,
    required this.textSecondary,
    required this.pops,
    required this.shadow,
    required this.scrim,
    required this.isDark,
  });

  final Color bg;
  final Color surface;
  final Color surfaceRaised;
  final Color border;

  /// Outline and hard-shadow colour for stickers and cards.
  final Color ink;
  final Color textPrimary;
  final Color textSecondary;

  /// Indexed by [PopHue.index].
  final List<PopColor> pops;
  final Color shadow;
  final Color scrim;
  final bool isDark;

  PopColor pop(PopHue hue) => pops[hue.index];

  // Semantic shortcuts.
  PopColor get primary => pop(PopHue.lime);
  Color get accent => primary.fill;
  Color get accentText => primary.text;
  Color get onAccent => primary.onFill;
  Color get success => pop(PopHue.mint).text;
  Color get warning => pop(PopHue.tangerine).text;
  Color get danger => pop(PopHue.coral).text;
  Color get info => pop(PopHue.sky).text;

  /// chart1..chart5.
  List<Color> get chart => [
    pop(PopHue.lime).text,
    pop(PopHue.sky).text,
    pop(PopHue.grape).text,
    pop(PopHue.bubblegum).text,
    pop(PopHue.mint).text,
  ];

  static const _ink = Color(0xFF1D1638);

  static const _fills = [
    Color(0xFFC6F432), // lime
    Color(0xFF5CC8FF), // sky
    Color(0xFFFFA53D), // tangerine
    Color(0xFFFF7AC6), // bubblegum
    Color(0xFFA98BFF), // grape
    Color(0xFF4BE0A6), // mint
    Color(0xFFFF6B6B), // coral
  ];
  static const _deeps = [
    Color(0xFF8DB51A),
    Color(0xFF2F9BD6),
    Color(0xFFD9801C),
    Color(0xFFD9529F),
    Color(0xFF7C5FE0),
    Color(0xFF22B07D),
    Color(0xFFD94848),
  ];
  // AA text colours on the light cream background.
  static const _lightText = [
    Color(0xFF3F6212),
    Color(0xFF0369A1),
    Color(0xFFB45309),
    Color(0xFFBE185D),
    Color(0xFF6D28D9),
    Color(0xFF047857),
    Color(0xFFC81E3A),
  ];

  static List<PopColor> _popsFor({required bool dark}) => [
    for (var i = 0; i < _fills.length; i++)
      PopColor(fill: _fills[i], deep: _deeps[i], text: dark ? _fills[i] : _lightText[i], onFill: _ink),
  ];

  static final dark = AbsColors(
    bg: const Color(0xFF120E26),
    surface: const Color(0xFF1D1838),
    surfaceRaised: const Color(0xFF282247),
    border: const Color(0xFF393160),
    ink: const Color(0xFF07051A),
    textPrimary: const Color(0xFFFBF8FF),
    textSecondary: const Color(0xFFB7AEDA),
    pops: _popsFor(dark: true),
    shadow: const Color(0xFF07051A),
    scrim: const Color(0xB307051A),
    isDark: true,
  );

  static final light = AbsColors(
    bg: const Color(0xFFFFF6EA),
    surface: const Color(0xFFFFFFFF),
    surfaceRaised: const Color(0xFFFFFFFF),
    border: const Color(0xFFEADCC8),
    ink: _ink,
    textPrimary: _ink,
    textSecondary: const Color(0xFF675E83),
    pops: _popsFor(dark: false),
    shadow: _ink,
    scrim: const Color(0x801D1638),
    isDark: false,
  );

  @override
  AbsColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? ink,
    Color? textPrimary,
    Color? textSecondary,
    List<PopColor>? pops,
    Color? shadow,
    Color? scrim,
    bool? isDark,
  }) {
    return AbsColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      ink: ink ?? this.ink,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      pops: pops ?? this.pops,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
      isDark: isDark ?? this.isDark,
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
      ink: l(ink, other.ink),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      pops: [for (var i = 0; i < pops.length; i++) pops[i].lerp(other.pops[i], t)],
      shadow: l(shadow, other.shadow),
      scrim: l(scrim, other.scrim),
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
