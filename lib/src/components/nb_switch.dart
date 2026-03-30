import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled toggle switch.
///
/// Uses a rectangular track and thumb (not the pill-shaped Material switch)
/// to match the neo-brutalism aesthetic.
///
/// ```dart
/// NbSwitch(
///   value: _enabled,
///   onChanged: (v) => setState(() => _enabled = v),
/// )
///
/// // With label
/// NbSwitch(
///   value: _enabled,
///   label: 'Enable notifications',
///   onChanged: (v) => setState(() => _enabled = v),
/// )
/// ```
class NbSwitch extends StatelessWidget {
  const NbSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelPosition = NbSwitchLabelPosition.right,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// Optional label displayed next to the switch.
  final String? label;

  /// Whether the label appears on the left or right.
  final NbSwitchLabelPosition labelPosition;

  /// Custom active (on) color. Defaults to [NbColorScheme.primary].
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final isEnabled = onChanged != null;
    final trackColor = value
        ? (activeColor ?? colors.primary)
        : isEnabled
            ? colors.muted
            : colors.muted;

    final track = GestureDetector(
      onTap: isEnabled ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: theme.pressAnimationDuration,
        width: 52,
        height: 28,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isEnabled ? colors.border : colors.mutedForeground,
            width: theme.borderWidth,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isEnabled ? colors.border : colors.mutedForeground,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );

    if (label == null) return track;

    final labelWidget = GestureDetector(
      onTap: isEnabled ? () => onChanged!(!value) : null,
      child: Text(
        label!,
        style: theme.typography.label.copyWith(
          color: isEnabled ? colors.foreground : colors.mutedForeground,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: labelPosition == NbSwitchLabelPosition.left
          ? [labelWidget, const SizedBox(width: 10), track]
          : [track, const SizedBox(width: 10), labelWidget],
    );
  }
}

enum NbSwitchLabelPosition { left, right }
