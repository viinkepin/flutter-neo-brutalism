import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled horizontal tab bar.
///
/// Renders as a pill container with equal-width (or scrollable) tab segments.
/// Use [selectedIndex] and [onChanged] to control state externally.
///
/// ```dart
/// // Equal-width tabs (default)
/// NbTabBar(
///   tabs: ['Overview', 'Analytics', 'Settings'],
///   selectedIndex: _tab,
///   onChanged: (i) => setState(() => _tab = i),
/// )
///
/// // Scrollable — for many tabs
/// NbTabBar(
///   tabs: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
///   selectedIndex: _tab,
///   onChanged: (i) => setState(() => _tab = i),
///   isScrollable: true,
/// )
/// ```
class NbTabBar extends StatelessWidget {
  const NbTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.isScrollable = false,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  /// When true, tabs have natural width and scroll horizontally.
  /// When false (default), tabs fill equally across the full width.
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final br = theme.borderRadius;
    final bw = theme.borderWidth;

    final tabWidgets = List<Widget>.generate(tabs.length, (i) {
      final selected = i == selectedIndex;
      final tab = GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(br - 2),
            border: selected ? Border.all(color: colors.border, width: bw) : null,
          ),
          child: Text(
            tabs[i],
            textAlign: TextAlign.center,
            style: theme.typography.label.copyWith(
              color: selected ? colors.foreground : colors.mutedForeground,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      );
      return isScrollable ? tab : Expanded(child: tab);
    });

    final row = isScrollable
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: tabWidgets),
          )
        : Row(children: tabWidgets);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(br),
        border: Border.all(color: colors.border, width: bw),
      ),
      child: row,
    );
  }
}
