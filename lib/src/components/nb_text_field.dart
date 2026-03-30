import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled text input field.
///
/// Label is always rendered above the field (not floating inside).
/// Border changes color on focus (primary) and on error (danger).
///
/// ```dart
/// NbTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   leading: Icon(Icons.email_outlined, size: 18),
///   onChanged: (v) => ...,
/// )
///
/// // Currency prefix
/// NbTextField(
///   label: 'Price',
///   leadingText: 'Rp',
///   keyboardType: TextInputType.number,
/// )
///
/// // Password with toggle
/// NbTextField(
///   label: 'Password',
///   obscureText: true,
///   trailing: Icon(Icons.visibility_outlined, size: 18),
///   onTrailingTap: () => ...,
/// )
/// ```
class NbTextField extends StatefulWidget {
  const NbTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.leading,
    this.trailing,
    this.leadingText,
    this.trailingText,
    this.onTrailingTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.required = false,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Label rendered above the field.
  final String? label;

  /// Placeholder text inside the field.
  final String? hint;

  /// Helper text shown below the field.
  final String? helperText;

  /// Error text shown below the field in danger color. Overrides helperText.
  final String? errorText;

  /// Widget shown on the left inside the field (e.g. Icon).
  final Widget? leading;

  /// Widget shown on the right inside the field (e.g. Icon).
  final Widget? trailing;

  /// Short text shown on the left inside the field (e.g. "Rp", "+62").
  final String? leadingText;

  /// Short text shown on the right inside the field (e.g. "kg", ".com").
  final String? trailingText;

  /// Called when [trailing] is tapped (e.g. password visibility toggle).
  final VoidCallback? onTrailingTap;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  /// Appends a red asterisk to the label.
  final bool required;

  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String? initialValue;

  @override
  State<NbTextField> createState() => _NbTextFieldState();
}

class _NbTextFieldState extends State<NbTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsNode = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final activeBorderColor = hasError
        ? colors.danger
        : _isFocused
            ? colors.primary
            : colors.border;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.borderRadius),
      borderSide: BorderSide(color: activeBorderColor, width: theme.borderWidth),
    );

    final disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.borderRadius),
      borderSide: BorderSide(color: colors.mutedForeground, width: 1.5),
    );

    Widget? trailingWidget;
    if (widget.trailing != null) {
      trailingWidget = widget.onTrailingTap != null
          ? GestureDetector(
              onTap: widget.onTrailingTap,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconTheme(
                  data: IconThemeData(color: colors.mutedForeground, size: 18),
                  child: widget.trailing!,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconTheme(
                data: IconThemeData(color: colors.mutedForeground, size: 18),
                child: widget.trailing!,
              ),
            );
    }

    Widget? leadingWidget;
    if (widget.leading != null) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: IconTheme(
          data: IconThemeData(color: colors.mutedForeground, size: 18),
          child: widget.leading!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: theme.typography.label.copyWith(
                color: hasError
                    ? colors.danger
                    : _isFocused
                        ? colors.primary
                        : colors.foreground,
              ),
              children: widget.required ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))] : null,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Input ──────────────────────────────────────────────────
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          style: theme.typography.body.copyWith(
            color: widget.enabled ? colors.foreground : colors.mutedForeground,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.typography.body.copyWith(color: colors.mutedForeground),
            filled: true,
            fillColor: widget.enabled ? colors.surface : colors.muted,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            disabledBorder: disabledBorder,
            prefixIcon: leadingWidget,
            suffixIcon: trailingWidget,
            prefixIconConstraints: widget.leading != null ? const BoxConstraints(minWidth: 44, minHeight: 44) : null,
            suffixIconConstraints: widget.trailing != null ? const BoxConstraints(minWidth: 44, minHeight: 44) : null,
            prefix: widget.leadingText != null
                ? Text(
                    widget.leadingText!,
                    style: theme.typography.body.copyWith(color: colors.mutedForeground),
                  )
                : null,
            suffix: widget.trailingText != null
                ? Text(
                    widget.trailingText!,
                    style: theme.typography.body.copyWith(color: colors.mutedForeground),
                  )
                : null,
          ),
        ),

        // ── Helper / Error ─────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(
            widget.errorText!,
            style: theme.typography.caption.copyWith(color: colors.danger),
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: 5),
          Text(
            widget.helperText!,
            style: theme.typography.caption.copyWith(color: colors.mutedForeground),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// A multi-line Neo-Brutalism text area.
///
/// ```dart
/// NbTextarea(
///   label: 'Description',
///   hint: 'Write something...',
///   minLines: 4,
///   maxLines: 8,
/// )
/// ```
class NbTextarea extends StatelessWidget {
  const NbTextarea({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.minLines = 4,
    this.maxLines = 8,
    this.maxLength,
    this.inputFormatters,
    this.initialValue,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool required;

  /// Minimum visible lines.
  final int minLines;

  /// Maximum lines before scrolling. Set to null for unbounded.
  final int? maxLines;

  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return NbTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      required: required,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
    // Note: NbTextField doesn't expose minLines/maxLines directly.
    // For full control, use _NbTextareaField below.
  }
}

/// Internal textarea that exposes minLines/maxLines properly.
class NbTextareaField extends StatefulWidget {
  const NbTextareaField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.minLines = 4,
    this.maxLines = 8,
    this.maxLength,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<NbTextareaField> createState() => _NbTextareaFieldState();
}

class _NbTextareaFieldState extends State<NbTextareaField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsNode = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final activeBorderColor = hasError
        ? colors.danger
        : _isFocused
            ? colors.primary
            : colors.border;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.borderRadius),
      borderSide: BorderSide(color: activeBorderColor, width: theme.borderWidth),
    );

    final disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(theme.borderRadius),
      borderSide: BorderSide(color: colors.mutedForeground, width: 1.5),
    );

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
                    : _isFocused
                        ? colors.primary
                        : colors.foreground,
              ),
              children: widget.required ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))] : null,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          style: theme.typography.body.copyWith(
            color: widget.enabled ? colors.foreground : colors.mutedForeground,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.typography.body.copyWith(color: colors.mutedForeground),
            filled: true,
            fillColor: widget.enabled ? colors.surface : colors.muted,
            counterText: '',
            contentPadding: const EdgeInsets.all(14),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            disabledBorder: disabledBorder,
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
