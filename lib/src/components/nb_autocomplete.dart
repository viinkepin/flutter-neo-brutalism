import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled text field with inline dropdown suggestions.
///
/// Uses Flutter's built-in [Autocomplete] for proper overlay positioning.
/// User can type freely (free-form) OR select from suggestions.
/// The [onChanged] callback fires on every keystroke;
/// [onSelected] fires only when the user picks an option from the list.
///
/// For a select-only dropdown (value must come from list), use [NbCombobox].
///
/// ```dart
/// NbAutocomplete(
///   label: 'City',
///   hint: 'Type to search...',
///   options: ['Jakarta', 'Bandung', 'Surabaya', 'Medan', 'Bali'],
///   onSelected: (value) => setState(() => _city = value),
///   onChanged: (value) => setState(() => _city = value),
/// )
///
/// // With dynamic options (from API)
/// NbAutocomplete(
///   label: 'Product',
///   options: _searchResults,
///   onChanged: (q) async {
///     final results = await api.search(q);
///     setState(() => _searchResults = results);
///   },
///   onSelected: (value) => setState(() => _product = value),
/// )
/// ```
class NbAutocomplete extends StatelessWidget {
  const NbAutocomplete({
    super.key,
    required this.options,
    this.onSelected,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.initialValue,
    this.leading,
    this.maxSuggestionsHeight = 220,
  });

  /// The list of suggestion strings shown in the dropdown.
  /// Update this list dynamically to implement server-side search.
  final List<String> options;

  /// Called when the user selects an option from the dropdown.
  final ValueChanged<String>? onSelected;

  /// Called on every keystroke. Use this to update [options] dynamically.
  final ValueChanged<String>? onChanged;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool enabled;

  /// Pre-fill the text field with this value.
  final String? initialValue;

  /// Optional leading icon inside the text field.
  final Widget? leading;

  /// Maximum height of the suggestions dropdown. Default: 220.
  final double maxSuggestionsHeight;

  List<String> _filterOptions(TextEditingValue value) {
    if (value.text.isEmpty) return options;
    final q = value.text.toLowerCase();
    return options.where((o) => o.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final hasError = errorText != null && errorText!.isNotEmpty;

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

        // ── Autocomplete field ──────────────────────────────────────
        Autocomplete<String>(
          initialValue:
              initialValue != null ? TextEditingValue(text: initialValue!) : null,
          optionsBuilder: _filterOptions,
          onSelected: onSelected,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return _NbAutocompleteField(
              controller: controller,
              focusNode: focusNode,
              hint: hint,
              enabled: enabled,
              leading: leading,
              hasError: hasError,
              onChanged: onChanged,
              theme: theme,
              colors: colors,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return _NbSuggestionsDropdown(
              options: options.toList(),
              onSelected: onSelected,
              maxHeight: maxSuggestionsHeight,
              theme: theme,
              colors: colors,
            );
          },
        ),

        // ── Helper / Error ─────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(errorText!,
              style: theme.typography.caption.copyWith(color: colors.danger)),
        ] else if (helperText != null) ...[
          const SizedBox(height: 5),
          Text(helperText!,
              style: theme.typography.caption
                  .copyWith(color: colors.mutedForeground)),
        ],
      ],
    );
  }
}

// ─── Internal field widget ────────────────────────────────────────────────────

class _NbAutocompleteField extends StatefulWidget {
  const _NbAutocompleteField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.enabled,
    required this.leading,
    required this.hasError,
    required this.onChanged,
    required this.theme,
    required this.colors,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;
  final bool enabled;
  final Widget? leading;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final dynamic theme;
  final dynamic colors;

  @override
  State<_NbAutocompleteField> createState() => _NbAutocompleteFieldState();
}

class _NbAutocompleteFieldState extends State<_NbAutocompleteField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() => setState(() => _isFocused = widget.focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final colors = widget.colors;

    final activeBorderColor = widget.hasError
        ? colors.danger
        : _isFocused
            ? colors.primary
            : colors.border;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.borderRadius as double),
      borderSide: BorderSide(color: activeBorderColor, width: theme.borderWidth as double),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.borderRadius as double),
      borderSide: BorderSide(color: colors.mutedForeground, width: 1.5),
    );

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      style: (theme.typography.body as TextStyle).copyWith(
        color: widget.enabled ? colors.foreground : colors.mutedForeground,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: (theme.typography.body as TextStyle).copyWith(color: colors.mutedForeground),
        filled: true,
        fillColor: widget.enabled ? colors.surface : colors.muted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        disabledBorder: disabledBorder,
        prefixIcon: widget.leading != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: IconTheme(
                  data: IconThemeData(color: colors.mutedForeground, size: 18),
                  child: widget.leading!,
                ),
              )
            : null,
        prefixIconConstraints: widget.leading != null
            ? const BoxConstraints(minWidth: 44, minHeight: 44)
            : null,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.arrow_drop_down_rounded,
              size: 22, color: colors.mutedForeground),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      ),
    );
  }
}

// ─── Suggestions dropdown ─────────────────────────────────────────────────────

class _NbSuggestionsDropdown extends StatelessWidget {
  const _NbSuggestionsDropdown({
    required this.options,
    required this.onSelected,
    required this.maxHeight,
    required this.theme,
    required this.colors,
  });

  final List<String> options;
  final AutocompleteOnSelected<String> onSelected;
  final double maxHeight;
  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(theme.borderRadius as double),
              border: Border.all(
                  color: colors.border, width: theme.borderWidth as double),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular((theme.borderRadius as double) - 1),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) =>
                    Divider(color: colors.muted, thickness: 1, height: 1),
                itemBuilder: (_, i) {
                  final option = options[i];
                  return GestureDetector(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        option,
                        style: (theme.typography.body as TextStyle)
                            .copyWith(color: colors.foreground),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
