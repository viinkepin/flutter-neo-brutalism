import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled radio button.
///
/// Circular shape with a bold black border. When selected, fills with
/// [NbColorScheme.primary] and shows a center dot.
///
/// Typically used inside an [NbRadioGroup] for managed group state,
/// or directly with [groupValue] and [onChanged].
///
/// ```dart
/// // Standalone
/// NbRadio<String>(
///   value: 'option_a',
///   groupValue: _selected,
///   onChanged: (v) => setState(() => _selected = v),
///   label: 'Option A',
/// )
///
/// // Group
/// NbRadioGroup<String>(
///   label: 'Payment Method',
///   options: [
///     NbRadioOption(value: 'cash', label: 'Cash'),
///     NbRadioOption(value: 'card', label: 'Card'),
///     NbRadioOption(value: 'qris', label: 'QRIS'),
///   ],
///   groupValue: _payment,
///   onChanged: (v) => setState(() => _payment = v),
/// )
/// ```
class NbRadio<T> extends StatelessWidget {
  const NbRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.activeColor,
    this.size = 22,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final Color? activeColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final isSelected = value == groupValue;
    final isEnabled = onChanged != null;
    final effectiveActiveColor = activeColor ?? colors.primary;

    void handleTap() {
      if (isEnabled && !isSelected) onChanged!(value);
    }

    final circle = GestureDetector(
      onTap: handleTap,
      child: AnimatedContainer(
        duration: theme.pressAnimationDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? effectiveActiveColor : colors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: isEnabled ? colors.border : colors.mutedForeground,
            width: theme.borderWidth,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: size * 0.36,
                  height: size * 0.36,
                  decoration: BoxDecoration(
                    color: colors.primaryForeground,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );

    if (label == null) return circle;

    return GestureDetector(
      onTap: handleTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          circle,
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label!,
              style: theme.typography.body.copyWith(
                color: isEnabled ? colors.foreground : colors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for a radio option used in [NbRadioGroup].
class NbRadioOption<T> {
  const NbRadioOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  final T value;
  final String label;
  final bool disabled;
}

/// A labeled group of [NbRadio] buttons.
class NbRadioGroup<T> extends StatelessWidget {
  const NbRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.direction = Axis.vertical,
    this.spacing = 12,
  });

  final List<NbRadioOption<T>> options;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final Axis direction;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final items = options.map((o) {
      return NbRadio<T>(
        value: o.value,
        groupValue: groupValue,
        onChanged: o.disabled ? null : onChanged,
        label: o.label,
      );
    }).toList();

    Widget group;
    if (direction == Axis.vertical) {
      group = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    } else {
      group = Wrap(
        spacing: spacing,
        runSpacing: spacing * 0.5,
        children: items,
      );
    }

    if (label == null) return group;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label!, style: theme.typography.label.copyWith(color: colors.foreground)),
        const SizedBox(height: 10),
        group,
      ],
    );
  }
}
