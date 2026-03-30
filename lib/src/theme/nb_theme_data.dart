import 'package:flutter/material.dart';
import 'nb_color_scheme.dart';
import '../tokens/nb_typography.dart';

/// The complete configuration for a Neo-Brutalism theme.
///
/// Controls colors, typography, border widths, shadow offsets, and
/// animation duration for the press interaction.
///
/// Wrap your app (or a subtree) with [NbTheme] to apply a theme:
/// ```dart
/// NbTheme(
///   data: NbThemeData.light(
///     colorScheme: NbColorScheme.light(primary: Color(0xFF6366F1)),
///   ),
///   child: MyApp(),
/// )
/// ```
class NbThemeData {
  const NbThemeData({
    required this.colorScheme,
    required this.typography,
    required this.borderWidth,
    required this.borderRadius,
    required this.shadowOffsetX,
    required this.shadowOffsetY,
    required this.pressAnimationDuration,
  });

  /// The color palette.
  final NbColorScheme colorScheme;

  /// The typographic scale.
  final NbTypography typography;

  /// Width of borders on all components. Default: 2.0.
  final double borderWidth;

  /// Default corner radius. Default: 8.0.
  final double borderRadius;

  /// X offset of the hard shadow. Default: 4.0.
  final double shadowOffsetX;

  /// Y offset of the hard shadow. Default: 4.0.
  final double shadowOffsetY;

  /// Duration of the press-in/press-out animation. Default: 80ms.
  final Duration pressAnimationDuration;

  // ─── Factories ───────────────────────────────────────────────────────────

  /// Creates a light theme. Override [colorScheme] to set your brand colors,
  /// and [fontFamily] to use your custom font.
  factory NbThemeData.light({
    NbColorScheme? colorScheme,
    String? fontFamily,
    double borderWidth = 2.0,
    double borderRadius = 8.0,
    double shadowOffsetX = 4.0,
    double shadowOffsetY = 4.0,
    Duration pressAnimationDuration = const Duration(milliseconds: 80),
  }) {
    final scheme = colorScheme ?? NbColorScheme.light();
    return NbThemeData(
      colorScheme: scheme,
      typography: NbTypography.defaultStyle(
        color: scheme.foreground,
        fontFamily: fontFamily,
      ),
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      shadowOffsetX: shadowOffsetX,
      shadowOffsetY: shadowOffsetY,
      pressAnimationDuration: pressAnimationDuration,
    );
  }

  /// Creates a dark theme.
  factory NbThemeData.dark({
    NbColorScheme? colorScheme,
    String? fontFamily,
    double borderWidth = 2.0,
    double borderRadius = 8.0,
    double shadowOffsetX = 4.0,
    double shadowOffsetY = 4.0,
    Duration pressAnimationDuration = const Duration(milliseconds: 80),
  }) {
    final scheme = colorScheme ?? NbColorScheme.dark();
    return NbThemeData(
      colorScheme: scheme,
      typography: NbTypography.defaultStyle(
        color: scheme.foreground,
        fontFamily: fontFamily,
      ),
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      shadowOffsetX: shadowOffsetX,
      shadowOffsetY: shadowOffsetY,
      pressAnimationDuration: pressAnimationDuration,
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// The hard offset shadow used on primary interactive elements.
  BoxShadow get hardShadow => BoxShadow(
        color: colorScheme.shadow,
        offset: Offset(shadowOffsetX, shadowOffsetY),
        blurRadius: 0,
      );

  /// Margin needed to prevent layout shift during the press animation.
  EdgeInsets get shadowMargin => EdgeInsets.only(
        right: shadowOffsetX,
        bottom: shadowOffsetY,
      );

  NbThemeData copyWith({
    NbColorScheme? colorScheme,
    NbTypography? typography,
    double? borderWidth,
    double? borderRadius,
    double? shadowOffsetX,
    double? shadowOffsetY,
    Duration? pressAnimationDuration,
  }) {
    return NbThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowOffsetX: shadowOffsetX ?? this.shadowOffsetX,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      pressAnimationDuration:
          pressAnimationDuration ?? this.pressAnimationDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NbThemeData &&
        other.colorScheme == colorScheme &&
        other.typography == typography &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.shadowOffsetX == shadowOffsetX &&
        other.shadowOffsetY == shadowOffsetY &&
        other.pressAnimationDuration == pressAnimationDuration;
  }

  @override
  int get hashCode => Object.hashAll([
        colorScheme, typography, borderWidth, borderRadius,
        shadowOffsetX, shadowOffsetY, pressAnimationDuration,
      ]);
}
