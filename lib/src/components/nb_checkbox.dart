import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled checkbox.
///
/// Square shape with a bold black border. When checked, fills with
/// [NbColorScheme.primary] and shows a checkmark.
///
/// ```dart
/// NbCheckbox(
///   value: _checked,
///   onChanged: (v) => setState(() => _checked = v ?? false),
/// )
///
/// // With label
/// NbCheckbox(
///   value: _checked,
///   label: 'Accept terms and conditions',
///   onChanged: (v) => setState(() => _checked = v ?? false),
/// )
/// ```
class NbCheckbox extends StatelessWidget {
  const NbCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.tristate = false,
    this.activeColor,
    this.size = 22,
  });

  /// Current checked state. null = indeterminate (only when [tristate] is true).
  final bool? value;

  final ValueChanged<bool?>? onChanged;

  /// Optional label rendered to the right.
  final String? label;

  /// When true, allows a null (indeterminate) state.
  final bool tristate;

  /// Custom active color. Defaults to [NbColorScheme.primary].
  final Color? activeColor;

  /// Box size in logical pixels. Default: 22.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final isEnabled = onChanged != null;
    final isChecked = value == true;
    final isIndeterminate = tristate && value == null;

    final effectiveActiveColor = activeColor ?? colors.primary;

    void handleTap() {
      if (!isEnabled) return;
      if (tristate) {
        if (value == false)
          onChanged!(null);
        else if (value == null)
          onChanged!(true);
        else
          onChanged!(false);
      } else {
        onChanged!(!isChecked);
      }
    }

    final box = GestureDetector(
      onTap: handleTap,
      child: AnimatedContainer(
        duration: theme.pressAnimationDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isChecked
              ? effectiveActiveColor
              : isIndeterminate
                  ? effectiveActiveColor.withValues(alpha: 0.4)
                  : colors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isEnabled ? colors.border : colors.mutedForeground,
            width: theme.borderWidth,
          ),
        ),
        child: isChecked
            ? Icon(Icons.check_rounded, size: size * 0.65, color: colors.primaryForeground)
            : isIndeterminate
                ? Icon(Icons.remove_rounded, size: size * 0.65, color: colors.primaryForeground)
                : null,
      ),
    );

    if (label == null) return box;

    return GestureDetector(
      onTap: handleTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          box,
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
