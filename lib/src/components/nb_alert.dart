import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// Visual variant of [NbAlert].
enum NbAlertVariant { info, success, warning, danger }

/// An inline Neo-Brutalism alert banner.
///
/// Use for in-page status messages. Not an overlay — renders inline in the widget tree.
///
/// ```dart
/// NbAlert(message: 'Stok hampir habis', variant: NbAlertVariant.warning)
///
/// NbAlert(
///   title: 'Berhasil',
///   message: 'Data telah disimpan.',
///   variant: NbAlertVariant.success,
///   onDismiss: () => setState(() => _showAlert = false),
/// )
/// ```
class NbAlert extends StatelessWidget {
  const NbAlert({
    super.key,
    required this.message,
    this.variant = NbAlertVariant.info,
    this.title,
    this.onDismiss,
    this.leading,
  });

  /// Main alert body text.
  final String message;

  /// Visual style — `info`, `success`, `warning`, or `danger`.
  final NbAlertVariant variant;

  /// Optional bold title above the message.
  final String? title;

  /// When provided, shows a × dismiss button.
  final VoidCallback? onDismiss;

  /// Override the leading icon. Defaults to a variant-appropriate icon.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final variantColor = _resolveColor(colors);
    final icon = leading ?? Icon(_resolveIcon(), size: 18, color: variantColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: variantColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: variantColor, width: theme.borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTheme(
            data: IconThemeData(color: variantColor, size: 18),
            child: icon,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: theme.typography.label.copyWith(
                      color: variantColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: theme.typography.bodySmall.copyWith(
                    color: colors.foreground,
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close_rounded, size: 16, color: colors.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }

  Color _resolveColor(dynamic colors) {
    return switch (variant) {
      NbAlertVariant.info    => colors.secondary as Color,
      NbAlertVariant.success => colors.success as Color,
      NbAlertVariant.warning => colors.warning as Color,
      NbAlertVariant.danger  => colors.danger as Color,
    };
  }

  IconData _resolveIcon() {
    return switch (variant) {
      NbAlertVariant.info    => Icons.info_outline_rounded,
      NbAlertVariant.success => Icons.check_circle_outline_rounded,
      NbAlertVariant.warning => Icons.warning_amber_rounded,
      NbAlertVariant.danger  => Icons.error_outline_rounded,
    };
  }
}
