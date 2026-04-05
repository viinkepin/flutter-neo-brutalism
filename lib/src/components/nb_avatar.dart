import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled avatar with hard border.
///
/// Shows a network image when [imageUrl] is provided. Falls back to [initials]
/// on error or when no URL is given.
///
/// ```dart
/// NbAvatar(initials: 'KH', size: 40)
///
/// NbAvatar(imageUrl: 'https://example.com/photo.jpg', size: 48)
///
/// NbAvatar(
///   initials: 'AB',
///   size: 40,
///   backgroundColor: colors.primary,
///   foregroundColor: colors.primaryForeground,
/// )
/// ```
class NbAvatar extends StatelessWidget {
  const NbAvatar({
    super.key,
    this.initials,
    this.imageUrl,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(initials != null || imageUrl != null,
            'Provide either initials or imageUrl');

  /// 1–2 character text shown as fallback or when no [imageUrl] is given.
  final String? initials;

  /// Network image URL. Shows [initials] as fallback on load error.
  final String? imageUrl;

  /// Diameter in logical pixels. Default: 40.
  final double size;

  /// Background color when showing initials. Defaults to [NbColorScheme.muted].
  final Color? backgroundColor;

  /// Initials text color. Defaults to [NbColorScheme.foreground].
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final bg = backgroundColor ?? colors.muted;
    final fg = foregroundColor ?? colors.foreground;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(color: colors.border, width: theme.borderWidth),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _InitialsWidget(
                initials: initials ?? '?',
                size: size,
                fg: fg,
                theme: theme,
              ),
            )
          : _InitialsWidget(initials: initials ?? '?', size: size, fg: fg, theme: theme),
    );
  }
}

class _InitialsWidget extends StatelessWidget {
  const _InitialsWidget({
    required this.initials,
    required this.size,
    required this.fg,
    required this.theme,
  });

  final String initials;
  final double size;
  final Color fg;
  final dynamic theme;

  @override
  Widget build(BuildContext context) {
    final display = initials.length > 2 ? initials.substring(0, 2).toUpperCase() : initials.toUpperCase();
    final fontSize = size * 0.36;

    return Center(
      child: Text(
        display,
        style: (theme.typography.label as TextStyle).copyWith(
          color: fg,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
