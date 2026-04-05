import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';
import 'nb_select.dart';

/// A Neo-Brutalism styled multi-select dropdown.
///
/// Renders like [NbSelect] but allows selecting multiple values.
/// Opens a bottom sheet with checkboxes on tap.
///
/// Reuses [NbSelectOption] from [NbSelect].
///
/// ```dart
/// NbMultiSelect<String>(
///   label: 'Kategori',
///   hint: 'Pilih kategori',
///   values: _selected,
///   onChanged: (v) => setState(() => _selected = v),
///   options: [
///     NbSelectOption(value: 'food', label: 'Makanan'),
///     NbSelectOption(value: 'drink', label: 'Minuman'),
///     NbSelectOption(value: 'dessert', label: 'Dessert'),
///   ],
/// )
/// ```
class NbMultiSelect<T> extends StatefulWidget {
  const NbMultiSelect({
    super.key,
    required this.options,
    required this.values,
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

  /// Currently selected values.
  final List<T> values;

  /// Called when selection changes.
  final ValueChanged<List<T>>? onChanged;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool required;

  /// Title shown in the bottom sheet.
  final String? sheetTitle;

  /// When true, shows a × button to clear all selections.
  final bool clearable;

  @override
  State<NbMultiSelect<T>> createState() => _NbMultiSelectState<T>();
}

class _NbMultiSelectState<T> extends State<NbMultiSelect<T>> {
  bool _focused = false;

  String get _displayLabel {
    if (widget.values.isEmpty) return '';
    final labels = widget.options
        .where((o) => widget.values.contains(o.value))
        .map((o) => o.label)
        .toList();
    if (labels.isEmpty) return '';
    if (labels.length == 1) return labels.first;
    return '${labels.first} +${labels.length - 1}';
  }

  void _openSheet() async {
    if (!widget.enabled) return;
    setState(() => _focused = true);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NbMultiSelectSheet<T>(
        title: widget.sheetTitle ?? widget.label ?? 'Select',
        options: widget.options,
        selectedValues: List.from(widget.values),
        onConfirm: (values) {
          Navigator.of(context).pop();
          widget.onChanged?.call(values);
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
    final hasValue = widget.values.isNotEmpty;

    final borderColor = hasError
        ? colors.danger
        : _focused
            ? colors.primary
            : colors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: theme.typography.label.copyWith(
                color: hasError
                    ? colors.danger
                    : _focused
                        ? colors.primary
                        : colors.foreground,
              ),
              children: widget.required
                  ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
        ],

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
                Expanded(
                  child: Text(
                    hasValue ? _displayLabel : (widget.hint ?? 'Select options'),
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
                    onTap: () => widget.onChanged?.call([]),
                    child: Icon(Icons.close_rounded, size: 16, color: colors.mutedForeground),
                  ),
                  const SizedBox(width: 4),
                ],
                Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: colors.mutedForeground),
              ],
            ),
          ),
        ),

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

// ─── Bottom sheet ─────────────────────────────────────────────────────────────

class _NbMultiSelectSheet<T> extends StatefulWidget {
  const _NbMultiSelectSheet({
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onConfirm,
  });

  final String title;
  final List<NbSelectOption<T>> options;
  final List<T> selectedValues;
  final ValueChanged<List<T>> onConfirm;

  @override
  State<_NbMultiSelectSheet<T>> createState() => _NbMultiSelectSheetState<T>();
}

class _NbMultiSelectSheetState<T> extends State<_NbMultiSelectSheet<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedValues);
  }

  void _toggle(T value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else {
        _selected.add(value);
      }
    });
  }

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
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Text(widget.title, style: theme.typography.title)),
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

          // Options
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: widget.options.length,
              separatorBuilder: (_, __) => Divider(color: colors.muted, thickness: 1, height: 1),
              itemBuilder: (_, i) {
                final option = widget.options[i];
                final isSelected = _selected.contains(option.value);
                return GestureDetector(
                  onTap: option.disabled ? null : () => _toggle(option.value),
                  child: Container(
                    color: isSelected ? colors.primary.withValues(alpha: 0.08) : null,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        // Checkbox
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelected ? colors.primary : colors.border,
                              width: theme.borderWidth,
                            ),
                          ),
                          child: isSelected
                              ? Icon(Icons.check_rounded, size: 13, color: colors.primaryForeground)
                              : null,
                        ),
                        const SizedBox(width: 12),
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
                              color: option.disabled ? colors.mutedForeground : colors.foreground,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Divider(color: colors.border, thickness: 2, height: 2),

          // Confirm button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: Row(
              children: [
                if (_selected.isNotEmpty)
                  Text(
                    '${_selected.length} selected',
                    style: theme.typography.caption.copyWith(color: colors.mutedForeground),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () => widget.onConfirm(_selected),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(theme.borderRadius),
                      border: Border.all(color: colors.border, width: theme.borderWidth),
                      boxShadow: [
                        BoxShadow(
                          color: colors.foreground,
                          offset: Offset(theme.shadowOffsetX, theme.shadowOffsetY),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      'Confirm',
                      style: theme.typography.label.copyWith(
                        color: colors.primaryForeground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
