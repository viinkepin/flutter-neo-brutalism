import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled notification badge that wraps a child widget.
///
/// Shows a counter in the top-right corner. Hidden automatically when [count] is 0.
///
/// ```dart
/// NbBadge(count: 3, child: Icon(Icons.notifications_rounded))
///
/// // Cap at 99+
/// NbBadge(count: 120, maxCount: 99, child: Icon(Icons.shopping_cart_rounded))
///
/// // Custom color
/// NbBadge(count: 2, color: colors.primary, child: Icon(Icons.mail_rounded))
/// ```
class NbBadge extends StatelessWidget {
  const NbBadge({
    super.key,
    required this.count,
    required this.child,
    this.maxCount = 99,
    this.color,
    this.foregroundColor,
  });

  /// The child widget to stack the badge on top of.
  final Widget child;

  /// Badge count. Badge is hidden when 0.
  final int count;

  /// Maximum value shown. Values above this show as `"99+"`. Default: 99.
  final int maxCount;

  /// Badge background color. Defaults to [NbColorScheme.danger].
  final Color? color;

  /// Badge text color. Defaults to white.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            top: -6,
            right: -8,
            child: Container(
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: color ?? colors.danger,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: theme.borderWidth - 0.5),
              ),
              child: Text(
                count > maxCount ? '$maxCount+' : '$count',
                style: theme.typography.labelSmall.copyWith(
                  color: foregroundColor ?? Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
