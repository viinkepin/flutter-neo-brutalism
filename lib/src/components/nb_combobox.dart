import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

/// An option in [NbCombobox].
class NbComboboxOption<T> {
  const NbComboboxOption({
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

// ─── NbCombobox ───────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled searchable select (combobox).
///
/// Renders like a [NbTextField] but opens a bottom sheet with a search bar
/// and filtered options on tap. The selected value must come from [options].
///
/// For free-form text input with suggestions, use [NbAutocomplete] instead.
///
/// ```dart
/// NbCombobox<String>(
///   label: 'Product Category',
///   hint: 'Search and select...',
///   value: _category,
///   onChanged: (v) => setState(() => _category = v),
///   options: [
///     NbComboboxOption(value: 'food', label: 'Food & Beverage'),
///     NbComboboxOption(value: 'retail', label: 'Retail'),
///     NbComboboxOption(value: 'service', label: 'Service'),
///   ],
/// )
/// ```
class NbCombobox<T> extends StatefulWidget {
  const NbCombobox({
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
    this.clearable = false,
    this.sheetTitle,
    this.searchHint = 'Search...',
  });

  final List<NbComboboxOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool required;

  /// When true, shows a × button to clear the selection.
  final bool clearable;

  /// Title shown in the bottom sheet header.
  final String? sheetTitle;

  /// Placeholder text for the search field in the bottom sheet.
  final String searchHint;

  @override
  State<NbCombobox<T>> createState() => _NbComboboxState<T>();
}

class _NbComboboxState<T> extends State<NbCombobox<T>> {
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
      builder: (_) => _NbComboboxSheet<T>(
        title: widget.sheetTitle ?? widget.label ?? 'Select',
        searchHint: widget.searchHint,
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
                // Search icon
                Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: colors.mutedForeground,
                ),
                const SizedBox(width: 8),

                if (leading != null) ...[
                  IconTheme(
                    data: IconThemeData(color: colors.mutedForeground, size: 18),
                    child: leading,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    hasValue ? _displayLabel : (widget.hint ?? 'Search and select...'),
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
                  color: colors.mutedForeground,
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

class _NbComboboxSheet<T> extends StatefulWidget {
  const _NbComboboxSheet({
    required this.title,
    required this.searchHint,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final String searchHint;
  final List<NbComboboxOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  @override
  State<_NbComboboxSheet<T>> createState() => _NbComboboxSheetState<T>();
}

class _NbComboboxSheetState<T> extends State<_NbComboboxSheet<T>> {
  String _query = '';

  List<NbComboboxOption<T>> get _filtered {
    if (_query.isEmpty) return widget.options;
    final q = _query.toLowerCase();
    return widget.options.where((o) => o.label.toLowerCase().contains(q)).toList();
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

          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              autofocus: true,
              style: theme.typography.body.copyWith(color: colors.foreground),
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: theme.typography.body.copyWith(color: colors.mutedForeground),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(Icons.search_rounded, size: 18, color: colors.mutedForeground),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                filled: true,
                fillColor: colors.muted.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                  borderSide: BorderSide(color: colors.border, width: theme.borderWidth),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                  borderSide: BorderSide(color: colors.border, width: theme.borderWidth),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                  borderSide: BorderSide(color: colors.primary, width: theme.borderWidth),
                ),
              ),
            ),
          ),

          Divider(color: colors.border, thickness: 2, height: 2),

          // Options list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No results for "$_query"',
                        style: theme.typography.body.copyWith(color: colors.mutedForeground),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: colors.muted, thickness: 1, height: 1),
                    itemBuilder: (_, i) {
                      final option = _filtered[i];
                      final isSelected = option.value == widget.selectedValue;
                      return GestureDetector(
                        onTap: option.disabled
                            ? null
                            : () => widget.onSelected(option.value),
                        child: Container(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.08)
                              : null,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              if (option.leading != null) ...[
                                IconTheme(
                                  data: IconThemeData(
                                    color: option.disabled
                                        ? colors.mutedForeground
                                        : colors.foreground,
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
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_rounded,
                                    size: 18, color: colors.primary),
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
