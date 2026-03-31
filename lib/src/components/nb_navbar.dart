import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

/// A single item in [NbNavBar].
class NbNavItem {
  const NbNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });

  final IconData icon;
  final String label;

  /// Icon to show when this item is selected. Falls back to [icon].
  final IconData? activeIcon;

  /// Optional badge count shown on the icon.
  final int? badge;
}

// ─── NbNavBar ─────────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled bottom navigation bar.
///
/// Manages its own selection indicator — pass [selectedIndex] and [onChanged]
/// to control state externally.
///
/// ```dart
/// Scaffold(
///   bottomNavigationBar: NbNavBar(
///     selectedIndex: _tab,
///     onChanged: (i) => setState(() => _tab = i),
///     items: const [
///       NbNavItem(icon: Icons.home_rounded, label: 'Home'),
///       NbNavItem(icon: Icons.search_rounded, label: 'Search'),
///       NbNavItem(icon: Icons.person_rounded, label: 'Profile'),
///     ],
///   ),
///   body: ...,
/// )
/// ```
class NbNavBar extends StatelessWidget {
  const NbNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<NbNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: theme.borderWidth),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? colors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: selected
                                  ? Border.all(
                                      color: colors.border,
                                      width: theme.borderWidth,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              selected
                                  ? (item.activeIcon ?? item.icon)
                                  : item.icon,
                              size: 20,
                              color: selected
                                  ? colors.primaryForeground
                                  : colors.mutedForeground,
                            ),
                          ),
                          if (item.badge != null && item.badge! > 0)
                            Positioned(
                              top: -2,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: colors.danger,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: colors.surface, width: 1.5),
                                ),
                                child: Text(
                                  item.badge! > 99 ? '99+' : '${item.badge}',
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
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: theme.typography.caption.copyWith(
                          color: selected
                              ? colors.foreground
                              : colors.mutedForeground,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
