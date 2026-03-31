import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

/// A single item in [NbPopupMenuButton].
///
/// Use [NbPopupMenuItem.divider] to insert a horizontal divider line.
class NbPopupMenuItem {
  const NbPopupMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.isDestructive = false,
    this.enabled = true,
  })  : isDivider = false;

  const NbPopupMenuItem.divider()
      : label = '',
        icon = null,
        onTap = null,
        isDestructive = false,
        enabled = true,
        isDivider = true;

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  /// Renders label and icon in [NbColorScheme.danger]. Default: false.
  final bool isDestructive;
  final bool enabled;
  final bool isDivider;
}

// ─── NbPopupMenuButton ────────────────────────────────────────────────────────

/// A Neo-Brutalism styled popup menu that opens an overlay near the tapped widget.
///
/// ```dart
/// NbPopupMenuButton(
///   items: [
///     NbPopupMenuItem(
///       label: 'Edit',
///       icon: Icons.edit_outlined,
///       onTap: () {},
///     ),
///     const NbPopupMenuItem.divider(),
///     NbPopupMenuItem(
///       label: 'Delete',
///       icon: Icons.delete_outlined,
///       isDestructive: true,
///       onTap: () {},
///     ),
///   ],
///   child: Icon(Icons.more_vert_rounded),
/// )
/// ```
class NbPopupMenuButton extends StatefulWidget {
  const NbPopupMenuButton({
    super.key,
    required this.items,
    required this.child,
    this.menuWidth = 200,
  });

  final List<NbPopupMenuItem> items;
  final Widget child;

  /// Width of the popup menu. Default: 200.
  final double menuWidth;

  @override
  State<NbPopupMenuButton> createState() => _NbPopupMenuButtonState();
}

class _NbPopupMenuButtonState extends State<NbPopupMenuButton> {
  DateTime? _lastClosed;

  void _open() async {
    // Prevent reopening immediately after barrier dismissal propagates to button
    if (_lastClosed != null &&
        DateTime.now().difference(_lastClosed!) <
            const Duration(milliseconds: 250)) {
      return;
    }
    final box = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset globalPos =
        box.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = box.size;
    final Size screenSize = overlay.size;
    final theme = context.nbTheme;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'NbPopupMenu',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 100),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: child,
      ),
      pageBuilder: (ctx, _, __) => _NbMenuOverlay(
        globalPos: globalPos,
        buttonSize: buttonSize,
        screenSize: screenSize,
        items: widget.items,
        menuWidth: widget.menuWidth,
        theme: theme,
      ),
    );
    if (mounted) _lastClosed = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}

// ─── Overlay widget ───────────────────────────────────────────────────────────

class _NbMenuOverlay extends StatelessWidget {
  const _NbMenuOverlay({
    required this.globalPos,
    required this.buttonSize,
    required this.screenSize,
    required this.items,
    required this.menuWidth,
    required this.theme,
  });

  final Offset globalPos;
  final Size buttonSize;
  final Size screenSize;
  final List<NbPopupMenuItem> items;
  final double menuWidth;
  final dynamic theme;

  @override
  Widget build(BuildContext context) {
    final colors = theme.colorScheme;
    final double menuEstimatedHeight =
        items.fold(0.0, (sum, item) => sum + (item.isDivider ? 17.0 : 48.0));

    // Prefer below button; flip above if not enough space
    final bool showAbove =
        (globalPos.dy + buttonSize.height + menuEstimatedHeight + 8) >
            screenSize.height;

    // Align right edge with button right edge; clamp to screen
    double left = globalPos.dx + buttonSize.width - menuWidth;
    if (left < 8) left = 8;
    if (left + menuWidth > screenSize.width - 8) {
      left = screenSize.width - 8 - menuWidth;
    }

    final double top = showAbove
        ? globalPos.dy - menuEstimatedHeight - 4
        : globalPos.dy + buttonSize.height + 4;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen tap absorber — dismisses menu when tapping outside
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox.expand(),
          ),

          // Menu panel (on top — absorbs its own taps)
          Positioned(
            left: left,
            top: top,
            width: menuWidth,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius:
                    BorderRadius.circular(theme.borderRadius as double),
                border: Border.all(
                    color: colors.border, width: theme.borderWidth as double),
                boxShadow: [
                  BoxShadow(
                    color: colors.foreground,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    (theme.borderRadius as double) - 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildItems(context, colors),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, dynamic colors) {
    final List<Widget> result = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.isDivider) {
        result.add(
          Divider(color: colors.border, height: 1, thickness: 1),
        );
      } else {
        final color = item.isDestructive
            ? colors.danger
            : item.enabled
                ? colors.foreground
                : colors.mutedForeground;
        result.add(
          GestureDetector(
            onTap: item.enabled
                ? () {
                    Navigator.of(context).pop();
                    item.onTap?.call();
                  }
                : null,
            child: Container(
              color: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (item.icon != null) ...[
                    Icon(item.icon, size: 16, color: color),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      item.label,
                      style: (theme.typography.label as TextStyle)
                          .copyWith(color: color),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return result;
  }
}
