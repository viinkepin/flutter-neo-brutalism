import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled app bar that implements [PreferredSizeWidget].
///
/// Can be used directly as [Scaffold.appBar]:
/// ```dart
/// Scaffold(
///   appBar: NbAppBar(title: 'Settings'),
///   body: ...,
/// )
/// ```
///
/// Or placed inside a [Column] as a standalone widget.
///
/// When [leading] is null and the navigator can pop, a back button
/// is rendered automatically.
///
/// ```dart
/// NbAppBar(
///   title: 'Order Details',
///   actions: [
///     NbAppBarAction(icon: Icons.more_vert_rounded, onTap: () {}),
///   ],
/// )
/// ```
class NbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NbAppBar({
    super.key,
    this.title,
    this.leading,
    this.showLeading = true,
    this.centerTitle = false,
    this.actions,
    this.bottom,
    this.backgroundColor,
  });

  final String? title;

  /// Custom leading widget. If null and [showLeading] is true, auto back button is shown.
  final Widget? leading;

  /// Whether to show the leading widget (back button or custom). Default: true.
  final bool showLeading;

  final bool centerTitle;
  final List<Widget>? actions;

  /// Widget placed below the main toolbar row (e.g. [NbTabBar]).
  final PreferredSizeWidget? bottom;

  final Color? backgroundColor;

  static const double _toolbarHeight = 56;

  @override
  Size get preferredSize => Size.fromHeight(
        _toolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final canPop = Navigator.canPop(context);

    return Container(
      color: backgroundColor ?? colors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Safe area covers status bar ───────────────────────────────
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: _toolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Leading / back button
                    if (showLeading) ...[
                      if (leading != null) leading! else if (canPop) _NbBackButton(theme: theme, colors: colors),
                      const SizedBox(width: 8),
                    ],

                    // Title
                    Expanded(
                      child: title != null
                          ? Text(
                              title!,
                              style: theme.typography.title,
                              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Actions
                    if (actions != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < actions!.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            actions![i],
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom widget (e.g. NbTabBar) ─────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.border, width: theme.borderWidth),
              ),
            ),
            child: bottom != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: bottom!,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Back button ──────────────────────────────────────────────────────────────

class _NbBackButton extends StatelessWidget {
  const _NbBackButton({required this.theme, required this.colors});

  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: colors.muted,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          border: Border.all(color: colors.border, width: theme.borderWidth),
        ),
        child: Icon(Icons.arrow_back_rounded, size: 18, color: colors.foreground),
      ),
    );
  }
}

// ─── Action icon button ───────────────────────────────────────────────────────

/// A pre-styled icon button for use in [NbAppBar.actions].
///
/// ```dart
/// NbAppBar(
///   title: 'Profile',
///   actions: [
///     NbAppBarAction(icon: Icons.edit_outlined, onTap: () {}),
///     NbAppBarAction(icon: Icons.more_vert_rounded, onTap: () {}),
///   ],
/// )
/// ```
class NbAppBarAction extends StatelessWidget {
  const NbAppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final VoidCallback onTap;

  /// Optional badge count shown on top-right of the icon.
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(theme.borderRadius),
              border: Border.all(color: colors.border, width: theme.borderWidth),
            ),
            child: Icon(icon, size: 18, color: colors.foreground),
          ),
          if (badge != null && badge! > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: colors.danger,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.surface, width: 1.5),
                ),
                child: Text(
                  badge! > 99 ? '99+' : '$badge',
                  style: TextStyle(
                    color: colors.dangerForeground,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
