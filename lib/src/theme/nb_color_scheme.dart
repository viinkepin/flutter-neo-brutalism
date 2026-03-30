import 'package:flutter/material.dart';

/// Defines the complete color palette for a Neo-Brutalism theme.
///
/// Use [NbColorScheme.light] or [NbColorScheme.dark] factories for defaults,
/// then override individual colors via [copyWith].
///
/// Example:
/// ```dart
/// NbColorScheme.light(primary: Color(0xFF6366F1)) // purple accent
/// ```
class NbColorScheme {
  const NbColorScheme({
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.background,
    required this.surface,
    required this.foreground,
    required this.border,
    required this.shadow,
    required this.danger,
    required this.dangerForeground,
    required this.success,
    required this.successForeground,
    required this.warning,
    required this.warningForeground,
    required this.muted,
    required this.mutedForeground,
  });

  /// Main accent color — used on primary buttons and highlights.
  final Color primary;

  /// Text/icon color on top of [primary].
  final Color primaryForeground;

  /// Secondary accent color.
  final Color secondary;

  /// Text/icon color on top of [secondary].
  final Color secondaryForeground;

  /// Page/scaffold background color.
  final Color background;

  /// Card and container surface color.
  final Color surface;

  /// Default text and icon color.
  final Color foreground;

  /// Border color — typically black in light mode, white in dark mode.
  final Color border;

  /// Hard offset shadow color — typically black in light mode.
  final Color shadow;

  /// Destructive / error color.
  final Color danger;

  /// Text/icon color on top of [danger].
  final Color dangerForeground;

  /// Success / positive color.
  final Color success;

  /// Text/icon color on top of [success].
  final Color successForeground;

  /// Warning / caution color.
  final Color warning;

  /// Text/icon color on top of [warning].
  final Color warningForeground;

  /// Disabled / muted background.
  final Color muted;

  /// Text color on top of [muted].
  final Color mutedForeground;

  // ─── Factories ───────────────────────────────────────────────────────────

  /// Default light color scheme. Override [primary] to set your brand color.
  factory NbColorScheme.light({
    Color primary = const Color(0xFFFDE047),
    Color primaryForeground = const Color(0xFF000000),
    Color secondary = const Color(0xFF60A5FA),
    Color secondaryForeground = const Color(0xFF000000),
    Color background = const Color(0xFFFAFAF9),
    Color surface = const Color(0xFFFFFFFF),
    Color foreground = const Color(0xFF000000),
    Color border = const Color(0xFF000000),
    Color shadow = const Color(0xFF000000),
    Color danger = const Color(0xFFEF4444),
    Color dangerForeground = const Color(0xFFFFFFFF),
    Color success = const Color(0xFF22C55E),
    Color successForeground = const Color(0xFF000000),
    Color warning = const Color(0xFFFB923C),
    Color warningForeground = const Color(0xFF000000),
    Color muted = const Color(0xFFE5E7EB),
    Color mutedForeground = const Color(0xFF6B7280),
  }) {
    return NbColorScheme(
      primary: primary,
      primaryForeground: primaryForeground,
      secondary: secondary,
      secondaryForeground: secondaryForeground,
      background: background,
      surface: surface,
      foreground: foreground,
      border: border,
      shadow: shadow,
      danger: danger,
      dangerForeground: dangerForeground,
      success: success,
      successForeground: successForeground,
      warning: warning,
      warningForeground: warningForeground,
      muted: muted,
      mutedForeground: mutedForeground,
    );
  }

  /// Default dark color scheme.
  factory NbColorScheme.dark({
    Color primary = const Color(0xFFFDE047),
    Color primaryForeground = const Color(0xFF000000),
    Color secondary = const Color(0xFF60A5FA),
    Color secondaryForeground = const Color(0xFF000000),
    Color background = const Color(0xFF0F0F0F),
    Color surface = const Color(0xFF1A1A1A),
    Color foreground = const Color(0xFFEBEBEB),
    Color border = const Color(0xFFEBEBEB),
    Color shadow = const Color(0xFFFFFFFF),
    Color danger = const Color(0xFFEF4444),
    Color dangerForeground = const Color(0xFFFFFFFF),
    Color success = const Color(0xFF22C55E),
    Color successForeground = const Color(0xFF000000),
    Color warning = const Color(0xFFFB923C),
    Color warningForeground = const Color(0xFF000000),
    Color muted = const Color(0xFF374151),
    Color mutedForeground = const Color(0xFF9CA3AF),
  }) {
    return NbColorScheme(
      primary: primary,
      primaryForeground: primaryForeground,
      secondary: secondary,
      secondaryForeground: secondaryForeground,
      background: background,
      surface: surface,
      foreground: foreground,
      border: border,
      shadow: shadow,
      danger: danger,
      dangerForeground: dangerForeground,
      success: success,
      successForeground: successForeground,
      warning: warning,
      warningForeground: warningForeground,
      muted: muted,
      mutedForeground: mutedForeground,
    );
  }

  // ─── copyWith ────────────────────────────────────────────────────────────

  NbColorScheme copyWith({
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? background,
    Color? surface,
    Color? foreground,
    Color? border,
    Color? shadow,
    Color? danger,
    Color? dangerForeground,
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? muted,
    Color? mutedForeground,
  }) {
    return NbColorScheme(
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      foreground: foreground ?? this.foreground,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      danger: danger ?? this.danger,
      dangerForeground: dangerForeground ?? this.dangerForeground,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NbColorScheme &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.background == background &&
        other.surface == surface &&
        other.foreground == foreground &&
        other.border == border &&
        other.shadow == shadow &&
        other.danger == danger &&
        other.dangerForeground == dangerForeground &&
        other.success == success &&
        other.successForeground == successForeground &&
        other.warning == warning &&
        other.warningForeground == warningForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground;
  }

  @override
  int get hashCode => Object.hashAll([
        primary, primaryForeground, secondary, secondaryForeground,
        background, surface, foreground, border, shadow,
        danger, dangerForeground, success, successForeground,
        warning, warningForeground, muted, mutedForeground,
      ]);
}
