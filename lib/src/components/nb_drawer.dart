import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

/// A single item in [NbDrawer].
class NbDrawerItem {
  const NbDrawerItem({
    required this.label,
    this.icon,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.enabled = true,
  });

  final String label;
  final IconData? icon;

  /// Optional widget on the right (e.g. badge count, chevron).
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
}

/// A group of [NbDrawerItem]s with an optional section label.
class NbDrawerSection {
  const NbDrawerSection({
    required this.items,
    this.title,
    this.showDivider = true,
  });

  final List<NbDrawerItem> items;

  /// Optional uppercase label shown above this section.
  final String? title;

  /// Whether to show a divider above this section (ignored for first section). Default: true.
  final bool showDivider;
}

// ─── NbDrawerHeader ───────────────────────────────────────────────────────────

/// Pre-styled header for [NbDrawer].
///
/// ```dart
/// NbDrawerHeader(
///   title: 'Neo Brutalism',
///   subtitle: 'admin@company.com',
///   avatar: Icon(Icons.person_rounded),
/// )
/// ```
class NbDrawerHeader extends StatelessWidget {
  const NbDrawerHeader({
    super.key,
    this.title,
    this.subtitle,
    this.avatar,
    this.backgroundColor,
  });

  final String? title;
  final String? subtitle;

  /// Widget shown on the left (icon, image, initials box, etc.).
  final Widget? avatar;

  /// Override background. Defaults to `colors.primary`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final bg = backgroundColor ?? colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(color: colors.border, width: theme.borderWidth),
        ),
      ),
      child: Row(
        children: [
          if (avatar != null) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(theme.borderRadius),
                border: Border.all(color: colors.border, width: theme.borderWidth),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.borderRadius - 1),
                child: IconTheme(
                  data: IconThemeData(
                    color: colors.primaryForeground,
                    size: 24,
                  ),
                  child: Center(child: avatar!),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: theme.typography.title.copyWith(
                      color: colors.primaryForeground,
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.typography.bodySmall.copyWith(
                      color: colors.primaryForeground.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── NbDrawer ─────────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled left navigation drawer.
///
/// Pass to [Scaffold.drawer] to get Flutter's built-in swipe gesture and barrier:
/// ```dart
/// Scaffold(
///   drawer: NbDrawer(
///     header: NbDrawerHeader(
///       title: 'My App',
///       subtitle: 'user@email.com',
///       avatar: Icon(Icons.person_rounded),
///     ),
///     sections: [
///       NbDrawerSection(items: [
///         NbDrawerItem(
///           icon: Icons.home_rounded,
///           label: 'Home',
///           selected: true,
///           onTap: () => Navigator.pop(context),
///         ),
///         NbDrawerItem(
///           icon: Icons.analytics_rounded,
///           label: 'Analytics',
///           onTap: () {},
///         ),
///       ]),
///       NbDrawerSection(
///         title: 'ACCOUNT',
///         items: [
///           NbDrawerItem(
///             icon: Icons.settings_rounded,
///             label: 'Settings',
///             onTap: () {},
///           ),
///         ],
///       ),
///     ],
///     footer: NbDrawerItem(
///       icon: Icons.logout_rounded,
///       label: 'Log Out',
///       onTap: () {},
///     ),
///   ),
///   body: ...,
/// )
/// ```
class NbDrawer extends StatelessWidget {
  const NbDrawer({
    super.key,
    this.header,
    required this.sections,
    this.footer,
    this.width = 280.0,
  });

  /// Optional header widget. Use [NbDrawerHeader] for the pre-styled variant.
  final Widget? header;

  /// Grouped list of items. Use a single section with no title for a flat list.
  final List<NbDrawerSection> sections;

  /// Item pinned at the bottom (e.g. logout).
  final NbDrawerItem? footer;

  /// Drawer panel width. Default: 280.
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Drawer(
      width: width,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        color: colors.surface,
        foregroundDecoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: colors.border, width: theme.borderWidth),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────
              if (header != null) header!,

              // ── Item sections ─────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: _buildSections(context, theme, colors),
                ),
              ),

              // ── Footer item ───────────────────────────────────────────
              if (footer != null) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.border, width: theme.borderWidth),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _NbDrawerItemTile(item: footer!, theme: theme, colors: colors),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSections(
      BuildContext context, dynamic theme, dynamic colors) {
    final widgets = <Widget>[];
    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];

      if (i > 0 && section.showDivider) {
        widgets.add(
          Divider(
            color: colors.border,
            height: 1,
            thickness: theme.borderWidth as double,
            indent: 16,
            endIndent: 16,
          ),
        );
        widgets.add(const SizedBox(height: 4));
      }

      if (section.title != null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 6),
            child: Text(
              section.title!,
              style: (theme.typography.labelSmall as TextStyle).copyWith(
                color: colors.mutedForeground,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
      }

      for (final item in section.items) {
        widgets.add(_NbDrawerItemTile(item: item, theme: theme, colors: colors));
      }
    }
    return widgets;
  }
}

// ─── Item tile ────────────────────────────────────────────────────────────────

class _NbDrawerItemTile extends StatelessWidget {
  const _NbDrawerItemTile({
    required this.item,
    required this.theme,
    required this.colors,
  });

  final NbDrawerItem item;
  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final color = item.selected
        ? colors.primary
        : item.enabled
            ? colors.foreground
            : colors.mutedForeground;

    return GestureDetector(
      onTap: item.enabled ? item.onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: item.selected
              ? (colors.primary as Color).withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(theme.borderRadius as double),
          border: item.selected
              ? Border.all(
                  color: (colors.primary as Color).withValues(alpha: 0.4),
                  width: theme.borderWidth as double,
                )
              : null,
        ),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, size: 18, color: color),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item.label,
                style: (theme.typography.label as TextStyle).copyWith(
                  color: color,
                  fontWeight:
                      item.selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (item.trailing != null) ...[
              const SizedBox(width: 8),
              IconTheme(
                data: IconThemeData(color: colors.mutedForeground, size: 16),
                child: item.trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
