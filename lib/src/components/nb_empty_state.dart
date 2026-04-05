import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled empty state widget.
///
/// Use when a list or page has no content to display.
///
/// ```dart
/// NbEmptyState(title: 'Belum ada produk')
///
/// NbEmptyState(
///   icon: Icon(Icons.inventory_2_outlined, size: 48),
///   title: 'Belum ada produk',
///   subtitle: 'Tambah produk pertamamu untuk mulai berjualan.',
///   action: NbButton.primary(label: 'Tambah Produk', onPressed: () {}),
/// )
/// ```
class NbEmptyState extends StatelessWidget {
  const NbEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });

  /// Primary message shown below the icon.
  final String title;

  /// Optional secondary message.
  final String? subtitle;

  /// Illustration or icon shown above the title.
  final Widget? icon;

  /// Optional CTA widget (e.g. an [NbButton]).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                  border: Border.all(color: colors.border, width: theme.borderWidth),
                ),
                child: IconTheme(
                  data: IconThemeData(color: colors.mutedForeground, size: 48),
                  child: icon!,
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              title,
              style: theme.typography.title.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: theme.typography.body.copyWith(color: colors.mutedForeground),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
