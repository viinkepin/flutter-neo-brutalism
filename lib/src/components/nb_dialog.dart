import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled modal dialog.
///
/// Use [NbDialog.show] for a quick one-liner, or use [NbDialog] directly
/// inside [showDialog] for full control.
///
/// ```dart
/// NbDialog.show(
///   context: context,
///   title: 'Delete Order',
///   content: const Text('This cannot be undone.'),
///   actions: [
///     NbButton.ghost(label: 'Cancel', onPressed: () => Navigator.pop(context)),
///     NbButton.danger(label: 'Delete', onPressed: () {}),
///   ],
/// );
/// ```
class NbDialog extends StatelessWidget {
  const NbDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.showCloseButton = true,
  });

  final String? title;

  /// Widget shown below the title. Defaults body text style.
  final Widget? content;

  /// Row of action buttons shown at the bottom.
  final List<Widget>? actions;

  /// Whether to show the × close button in the header. Default: true.
  final bool showCloseButton;

  /// Convenience method — shows [NbDialog] via [showDialog].
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? content,
    List<Widget>? actions,
    bool showCloseButton = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => NbDialog(
        title: title,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          border: Border.all(color: colors.border, width: theme.borderWidth),
          boxShadow: [
            BoxShadow(
              color: colors.foreground,
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            if (title != null || showCloseButton) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(title!, style: theme.typography.title),
                      ),
                    if (showCloseButton)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.muted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.border, width: 1.5),
                          ),
                          child: Icon(Icons.close_rounded, size: 16, color: colors.foreground),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // ── Content ──────────────────────────────────────────────────
            if (content != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: DefaultTextStyle(
                  style: theme.typography.body.copyWith(color: colors.mutedForeground),
                  child: content!,
                ),
              ),

            // ── Actions ──────────────────────────────────────────────────
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors.border, width: theme.borderWidth),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions!.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      actions![i],
                    ],
                  ],
                ),
              ),
            ] else
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
