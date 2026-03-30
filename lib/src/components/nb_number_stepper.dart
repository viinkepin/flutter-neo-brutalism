import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled increment/decrement number stepper.
///
/// Renders as a single bordered container: [−] | [value] | [+]
/// No shadow — follows the hierarchy rule for inner interactive controls.
///
/// ```dart
/// NbNumberStepper(
///   value: _qty,
///   onChanged: (v) => setState(() => _qty = v),
/// )
///
/// // With min/max/step
/// NbNumberStepper(
///   value: _qty,
///   min: 1,
///   max: 99,
///   step: 1,
///   onChanged: (v) => setState(() => _qty = v),
/// )
///
/// // With label
/// NbNumberStepper(
///   label: 'Quantity',
///   value: _qty,
///   helperText: 'Max 99 items per order',
///   onChanged: (v) => setState(() => _qty = v),
/// )
/// ```
class NbNumberStepper extends StatelessWidget {
  const NbNumberStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max,
    this.step = 1,
    this.enabled = true,
    this.label,
    this.helperText,
    this.errorText,
    this.required = false,
  });

  /// Current value.
  final int value;

  /// Called when value changes. Set to null to disable.
  final ValueChanged<int>? onChanged;

  /// Minimum allowed value. Default: 0.
  final int min;

  /// Maximum allowed value. null = no upper limit.
  final int? max;

  /// Amount to increment/decrement per tap. Default: 1.
  final int step;

  final bool enabled;

  /// Label rendered above the stepper.
  final String? label;

  final String? helperText;
  final String? errorText;

  /// Appends a red asterisk to the label.
  final bool required;

  bool get _canDecrement => enabled && onChanged != null && value > min;
  bool get _canIncrement => enabled && onChanged != null && (max == null || value < max!);

  void _decrement() {
    if (_canDecrement) onChanged!(value - step);
  }

  void _increment() {
    if (_canIncrement) onChanged!(value + step);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final hasError = errorText != null && errorText!.isNotEmpty;
    final borderColor = hasError
        ? colors.danger
        : enabled
            ? colors.border
            : colors.mutedForeground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: theme.typography.label.copyWith(
                color: hasError ? colors.danger : colors.foreground,
              ),
              children: required
                  ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Stepper ────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: enabled ? colors.surface : colors.muted,
            borderRadius: BorderRadius.circular(theme.borderRadius),
            border: Border.all(color: borderColor, width: theme.borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.borderRadius - 1),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // − button
                  GestureDetector(
                    onTap: _canDecrement ? _decrement : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: _canDecrement ? colors.surface : colors.muted,
                      child: Icon(
                        Icons.remove_rounded,
                        size: 18,
                        color: _canDecrement ? colors.foreground : colors.mutedForeground,
                      ),
                    ),
                  ),

                  // Divider
                  Container(width: theme.borderWidth, color: borderColor),

                  // Value display
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: enabled ? colors.surface : colors.muted,
                      child: Text(
                        '$value',
                        style: theme.typography.label.copyWith(
                          color: enabled ? colors.foreground : colors.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Divider
                  Container(width: theme.borderWidth, color: borderColor),

                  // + button
                  GestureDetector(
                    onTap: _canIncrement ? _increment : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: _canIncrement ? colors.surface : colors.muted,
                      child: Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: _canIncrement ? colors.foreground : colors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Helper / Error ─────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(errorText!, style: theme.typography.caption.copyWith(color: colors.danger)),
        ] else if (helperText != null) ...[
          const SizedBox(height: 5),
          Text(helperText!, style: theme.typography.caption.copyWith(color: colors.mutedForeground)),
        ],
      ],
    );
  }
}
