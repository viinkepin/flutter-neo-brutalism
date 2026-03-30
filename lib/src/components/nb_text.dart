import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';
import '../tokens/nb_typography.dart';

/// Semantic variant of [NbText].
enum NbTextVariant {
  /// 36px · w800 — hero titles, page headers.
  display,

  /// 28px · w800 — section headings.
  headline,

  /// 20px · w700 — card headers, dialog titles.
  title,

  /// 16px · w700 — sub-section headings.
  titleSmall,

  /// 14px · w500 — regular body content.
  body,

  /// 12px · w500 — secondary content.
  bodySmall,

  /// 13px · w600 — labels, form field labels, button text.
  label,

  /// 11px · w600 — badge text, small labels.
  labelSmall,

  /// 10px · w500 — metadata, timestamps.
  caption,
}

/// A Neo-Brutalism styled text widget.
///
/// Uses the typographic scale from [NbTheme]. Use [variant] to select
/// a semantic text level, then override [color], [fontWeight], or
/// [style] for one-off customizations.
///
/// ```dart
/// NbText('Hello World', variant: NbTextVariant.headline)
/// NbText.display('Big Title')
/// NbText.body('Regular paragraph text')
/// ```
class NbText extends StatelessWidget {
  const NbText(
    this.text, {
    super.key,
    this.variant = NbTextVariant.body,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.softWrap,
  });

  // ─── Named constructors ───────────────────────────────────────────────────

  const NbText.display(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.display;

  const NbText.headline(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.headline;

  const NbText.title(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.title;

  const NbText.titleSmall(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.titleSmall;

  const NbText.body(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.body;

  const NbText.bodySmall(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.bodySmall;

  const NbText.label(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.label;

  const NbText.labelSmall(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.labelSmall;

  const NbText.caption(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.maxLines, this.overflow, this.style, this.softWrap})
      : variant = NbTextVariant.caption;

  // ─── Properties ──────────────────────────────────────────────────────────

  final String text;
  final NbTextVariant variant;

  /// Overrides the text color.
  final Color? color;

  /// Overrides the font weight.
  final FontWeight? fontWeight;

  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  /// Fully overrides the text style (color and fontWeight are still applied on top).
  final TextStyle? style;

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final typography = context.nbType;
    final baseStyle = _resolveStyle(typography);
    final resolved = (style ?? baseStyle).copyWith(
      color: color,
      fontWeight: fontWeight,
    );

    return Text(
      text,
      style: resolved,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  TextStyle _resolveStyle(NbTypography t) {
    switch (variant) {
      case NbTextVariant.display:    return t.display;
      case NbTextVariant.headline:   return t.headline;
      case NbTextVariant.title:      return t.title;
      case NbTextVariant.titleSmall: return t.titleSmall;
      case NbTextVariant.body:       return t.body;
      case NbTextVariant.bodySmall:  return t.bodySmall;
      case NbTextVariant.label:      return t.label;
      case NbTextVariant.labelSmall: return t.labelSmall;
      case NbTextVariant.caption:    return t.caption;
    }
  }
}
