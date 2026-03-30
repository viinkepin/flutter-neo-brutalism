import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// An option in [NbSelect].
class NbSelectOption<T> {
  const NbSelectOption({
    required this.value,
    required this.label,
    this.leading,
    this.disabled = false,
  });

  final T value;
  final String label;

  /// Optional leading widget (icon, color swatch, etc.).
  final Widget? leading;
  final bool disabled;
}

/// A Neo-Brutalism styled select / dropdown.
///
/// Renders like a [NbTextField] but opens a bottom sheet with options on tap.
///
/// ```dart
/// NbSelect<String>(
///   label: 'Category',
///   hint: 'Select a category',
///   options: [
///     NbSelectOption(value: 'food', label: 'Food & Beverage'),
///     NbSelectOption(value: 'retail', label: 'Retail'),
///     NbSelectOption(value: 'service', label: 'Service'),
///   ],
///   value: _category,
///   onChanged: (v) => setState(() => _category = v),
/// )
/// ```
class NbSelect<T> extends StatefulWidget {
  const NbSelect({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.required = false,
    this.sheetTitle,
    this.clearable = false,
  });

  final List<NbSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool required;

  /// Title shown in the selection bottom sheet.
  final String? sheetTitle;

  /// When true, shows a clear (×) button to reset selection.
  final bool clearable;

  @override
  State<NbSelect<T>> createState() => _NbSelectState<T>();
}

class _NbSelectState<T> extends State<NbSelect<T>> {
  bool _focused = false;

  String get _displayLabel {
    if (widget.value == null) return '';
    try {
      return widget.options.firstWhere((o) => o.value == widget.value).label;
    } catch (_) {
      return '';
    }
  }

  Widget? get _displayLeading {
    if (widget.value == null) return null;
    try {
      return widget.options.firstWhere((o) => o.value == widget.value).leading;
    } catch (_) {
      return null;
    }
  }

  void _openSheet() async {
    if (!widget.enabled) return;
    setState(() => _focused = true);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NbSelectSheet<T>(
        title: widget.sheetTitle ?? widget.label ?? 'Select',
        options: widget.options,
        selectedValue: widget.value,
        onSelected: (v) {
          Navigator.of(context).pop();
          widget.onChanged?.call(v);
        },
      ),
    );

    if (mounted) setState(() => _focused = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final hasValue = widget.value != null;

    final borderColor = hasError
        ? colors.danger
        : _focused
            ? colors.primary
            : colors.border;

    final leading = _displayLeading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ────────────────────────────────────────────────
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: theme.typography.label.copyWith(
                color: hasError ? colors.danger : _focused ? colors.primary : colors.foreground,
              ),
              children: widget.required
                  ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Field ─────────────────────────────────────────────────
        GestureDetector(
          onTap: _openSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.enabled ? colors.surface : colors.muted,
              borderRadius: BorderRadius.circular(theme.borderRadius),
              border: Border.all(
                color: widget.enabled ? borderColor : colors.mutedForeground,
                width: widget.enabled ? theme.borderWidth : 1.5,
              ),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  IconTheme(
                    data: IconThemeData(color: colors.mutedForeground, size: 18),
                    child: leading,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    hasValue ? _displayLabel : (widget.hint ?? 'Select an option'),
                    style: theme.typography.body.copyWith(
                      color: hasValue
                          ? (widget.enabled ? colors.foreground : colors.mutedForeground)
                          : colors.mutedForeground,
                    ),
                  ),
                ),
                if (widget.clearable && hasValue) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => widget.onChanged?.call(null),
                    child: Icon(Icons.close_rounded, size: 16, color: colors.mutedForeground),
                  ),
                  const SizedBox(width: 4),
                ],
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: widget.enabled ? colors.mutedForeground : colors.mutedForeground,
                ),
              ],
            ),
          ),
        ),

        // ── Helper / Error ─────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(widget.errorText!, style: theme.typography.caption.copyWith(color: colors.danger)),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: 5),
          Text(widget.helperText!, style: theme.typography.caption.copyWith(color: colors.mutedForeground)),
        ],
      ],
    );
  }
}

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────

class _NbSelectSheet<T> extends StatelessWidget {
  const _NbSelectSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final List<NbSelectOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: colors.border, width: theme.borderWidth),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Text(title, style: theme.typography.title)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.muted,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.border, width: 1.5),
                    ),
                    child: Icon(Icons.close_rounded, size: 16, color: colors.foreground),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colors.border, thickness: 2, height: 2),
          // Options list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: options.length,
              separatorBuilder: (_, __) =>
                  Divider(color: colors.muted, thickness: 1, height: 1),
              itemBuilder: (_, i) {
                final option = options[i];
                final isSelected = option.value == selectedValue;
                return GestureDetector(
                  onTap: option.disabled ? null : () => onSelected(option.value),
                  child: Container(
                    color: isSelected ? colors.primary.withValues(alpha: 0.08) : null,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        if (option.leading != null) ...[
                          IconTheme(
                            data: IconThemeData(
                              color: option.disabled ? colors.mutedForeground : colors.foreground,
                              size: 18,
                            ),
                            child: option.leading!,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: Text(
                            option.label,
                            style: theme.typography.body.copyWith(
                              color: option.disabled
                                  ? colors.mutedForeground
                                  : isSelected
                                      ? colors.primary
                                      : colors.foreground,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_rounded, size: 18, color: colors.primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
