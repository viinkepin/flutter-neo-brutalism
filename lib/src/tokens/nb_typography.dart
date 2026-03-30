import 'package:flutter/material.dart';

/// Defines the typographic scale for Neo-Brutalism UI.
///
/// Neo-Brutalism typography is bold and commanding:
/// - Heavy font weights (700–900)
/// - Tight letter-spacing on large sizes
/// - Generous line height on body text
///
/// Use [NbTypography.defaultStyle] for the built-in scale,
/// or construct a custom instance to override any level.
class NbTypography {
  const NbTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.titleSmall,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.labelSmall,
    required this.caption,
  });

  /// 36px · w800 · tight tracking — hero titles, page headers.
  final TextStyle display;

  /// 28px · w800 · tight tracking — section main headings.
  final TextStyle headline;

  /// 20px · w700 — card headers, dialog titles.
  final TextStyle title;

  /// 16px · w700 — sub-section headings.
  final TextStyle titleSmall;

  /// 14px · w500 — regular content text.
  final TextStyle body;

  /// 12px · w500 — secondary content.
  final TextStyle bodySmall;

  /// 13px · w600 — labels, button text, form field labels.
  final TextStyle label;

  /// 11px · w600 — small labels, badge text.
  final TextStyle labelSmall;

  /// 10px · w500 — metadata, timestamps.
  final TextStyle caption;

  // ─── Factory ─────────────────────────────────────────────────────────────

  /// Creates the default Neo-Brutalism typographic scale.
  ///
  /// Pass [color] to set the base text color (matches [NbColorScheme.foreground]).
  /// Pass [fontFamily] to use a custom font (e.g. "DMSans", "Satoshi").
  factory NbTypography.defaultStyle({
    Color color = const Color(0xFF000000),
    String? fontFamily,
  }) {
    TextStyle base(double size, FontWeight weight, {double? spacing, double? height}) {
      return TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontFamily: fontFamily,
        letterSpacing: spacing,
        height: height,
      );
    }

    return NbTypography(
      display:    base(36, FontWeight.w800, spacing: -0.8, height: 1.1),
      headline:   base(28, FontWeight.w800, spacing: -0.5, height: 1.2),
      title:      base(20, FontWeight.w700, spacing: -0.3, height: 1.3),
      titleSmall: base(16, FontWeight.w700, spacing: -0.2, height: 1.3),
      body:       base(14, FontWeight.w500, height: 1.55),
      bodySmall:  base(12, FontWeight.w500, height: 1.5),
      label:      base(13, FontWeight.w600),
      labelSmall: base(11, FontWeight.w600),
      caption:    base(10, FontWeight.w500),
    );
  }

  NbTypography copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? titleSmall,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? labelSmall,
    TextStyle? caption,
  }) {
    return NbTypography(
      display:    display    ?? this.display,
      headline:   headline   ?? this.headline,
      title:      title      ?? this.title,
      titleSmall: titleSmall ?? this.titleSmall,
      body:       body       ?? this.body,
      bodySmall:  bodySmall  ?? this.bodySmall,
      label:      label      ?? this.label,
      labelSmall: labelSmall ?? this.labelSmall,
      caption:    caption    ?? this.caption,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NbTypography &&
        other.display == display &&
        other.headline == headline &&
        other.title == title &&
        other.titleSmall == titleSmall &&
        other.body == body &&
        other.bodySmall == bodySmall &&
        other.label == label &&
        other.labelSmall == labelSmall &&
        other.caption == caption;
  }

  @override
  int get hashCode => Object.hashAll([
        display, headline, title, titleSmall,
        body, bodySmall, label, labelSmall, caption,
      ]);
}
