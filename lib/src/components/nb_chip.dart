import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

/// Data model for [NbChipGroup].
class NbChipOption<T> {
  const NbChipOption({
    required this.value,
    required this.label,
    this.leading,
    this.disabled = false,
  });

  final T value;
  final String label;

  /// Optional leading icon or widget.
  final Widget? leading;
  final bool disabled;
}

// ─── NbChip ───────────────────────────────────────────────────────────────────

/// Visual variant of [NbChip].
enum NbChipVariant {
  /// Selectable chip — toggles on/off. Shows checkmark when selected.
  filter,

  /// Deletable chip — shows a × button. Use for tag inputs.
  input,

  /// Read-only styled tag.
  display,
}

/// A Neo-Brutalism styled chip.
///
/// ```dart
/// // Filter chip (selectable)
/// NbChip(
///   label: 'Food',
///   selected: _selected,
///   onTap: () => setState(() => _selected = !_selected),
/// )
///
/// // Input chip (deletable tag)
/// NbChip(
///   label: 'flutter',
///   variant: NbChipVariant.input,
///   onDeleted: () => setState(() => _tags.remove('flutter')),
/// )
///
/// // Display chip (read-only)
/// NbChip(label: 'New', variant: NbChipVariant.display)
/// ```
class NbChip extends StatelessWidget {
  const NbChip({
    super.key,
    required this.label,
    this.variant = NbChipVariant.filter,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.leading,
    this.activeColor,
    this.enabled = true,
  });

  final String label;
  final NbChipVariant variant;

  /// Whether this chip is selected. Only relevant for [NbChipVariant.filter].
  final bool selected;

  /// Called when the chip is tapped.
  final VoidCallback? onTap;

  /// Called when the × button is tapped. Only shown for [NbChipVariant.input].
  final VoidCallback? onDeleted;

  /// Optional leading icon/widget displayed left of the label.
  final Widget? leading;

  /// Active (selected) fill color. Defaults to [NbColorScheme.primary].
  final Color? activeColor;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final isEnabled = enabled && (onTap != null || onDeleted != null);
    final isSelected = variant == NbChipVariant.filter && selected;
    final effectiveActiveColor = activeColor ?? colors.primary;

    final bg = isSelected ? effectiveActiveColor : colors.surface;
    final fg = isSelected
        ? colors.primaryForeground
        : isEnabled
            ? colors.foreground
            : colors.mutedForeground;
    final borderColor = isSelected
        ? effectiveActiveColor
        : isEnabled
            ? colors.border
            : colors.mutedForeground;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: theme.pressAnimationDuration,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          border: Border.all(color: borderColor, width: theme.borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              IconTheme(
                data: IconThemeData(color: fg, size: 14),
                child: leading!,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.typography.label.copyWith(color: fg),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_rounded, size: 14, color: fg),
            ],
            if (variant == NbChipVariant.input && onDeleted != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(Icons.close_rounded, size: 14, color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── NbChipGroup ──────────────────────────────────────────────────────────────

/// A group of selectable [NbChip] widgets with managed selection state.
///
/// ```dart
/// NbChipGroup<String>(
///   options: [
///     NbChipOption(value: 'food', label: 'Food'),
///     NbChipOption(value: 'drink', label: 'Drink'),
///     NbChipOption(value: 'dessert', label: 'Dessert'),
///   ],
///   selectedValues: _selected,
///   onChanged: (values) => setState(() => _selected = values),
/// )
///
/// // Single-select (radio-like)
/// NbChipGroup<String>(
///   multiSelect: false,
///   options: [...],
///   selectedValues: _selected,
///   onChanged: (values) => setState(() => _selected = values),
/// )
/// ```
class NbChipGroup<T> extends StatelessWidget {
  const NbChipGroup({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.multiSelect = true,
    this.spacing = 8,
    this.runSpacing = 8,
    this.activeColor,
    this.label,
  });

  final List<NbChipOption<T>> options;

  /// Currently selected values.
  final List<T> selectedValues;

  /// Called whenever selection changes.
  final ValueChanged<List<T>> onChanged;

  /// When true (default), multiple chips can be selected simultaneously.
  /// When false, selecting one deselects others (radio-like).
  final bool multiSelect;

  final double spacing;
  final double runSpacing;

  /// Active color for selected chips. Defaults to [NbColorScheme.primary].
  final Color? activeColor;

  /// Optional group label above the chips.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final chips = Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option.value);

        return NbChip(
          label: option.label,
          leading: option.leading,
          selected: isSelected,
          enabled: !option.disabled,
          activeColor: activeColor,
          onTap: option.disabled
              ? null
              : () {
                  if (multiSelect) {
                    final updated = List<T>.from(selectedValues);
                    if (isSelected) {
                      updated.remove(option.value);
                    } else {
                      updated.add(option.value);
                    }
                    onChanged(updated);
                  } else {
                    onChanged(isSelected ? [] : [option.value]);
                  }
                },
        );
      }).toList(),
    );

    if (label == null) return chips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label!, style: theme.typography.label.copyWith(color: colors.foreground)),
        const SizedBox(height: 10),
        chips,
      ],
    );
  }
}
