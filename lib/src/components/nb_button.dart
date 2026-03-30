import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';
import '../theme/nb_theme_data.dart';
import '../theme/nb_color_scheme.dart';

/// Visual style variant of [NbButton].
enum NbButtonVariant {
  /// Filled with [NbColorScheme.primary]. Gets the hard shadow — use for main CTAs.
  primary,

  /// White/surface fill, black border. No shadow. Use for secondary actions.
  secondary,

  /// Danger-bordered, white fill. No shadow. Use for destructive actions.
  danger,

  /// Success-filled. No shadow. Use for confirmation actions.
  success,

  /// Transparent fill, border only. No shadow. Use for tertiary actions.
  ghost,
}

/// Size variant of [NbButton].
enum NbButtonSize {
  /// Height ~36px, padding: 10h / 16v.
  small,

  /// Height ~44px, padding: 13h / 20v. (default)
  medium,

  /// Height ~52px, padding: 16h / 24v.
  large,
}

/// A Neo-Brutalism styled button with a physical press animation.
///
/// On press, the button translates into its shadow position and the shadow
/// disappears — simulating the feel of pressing a physical button.
///
/// Only [NbButtonVariant.primary] has a shadow (it is the primary CTA).
/// All other variants use border-only styling.
///
/// ```dart
/// NbButton(
///   label: 'Checkout',
///   variant: NbButtonVariant.primary,
///   onPressed: () {},
/// )
///
/// NbButton(
///   label: 'Delete',
///   variant: NbButtonVariant.danger,
///   onPressed: () {},
///   leading: Icon(Icons.delete, size: 16),
/// )
/// ```
class NbButton extends StatefulWidget {
  const NbButton({
    super.key,
    this.label,
    this.child,
    required this.onPressed,
    this.variant = NbButtonVariant.primary,
    this.size = NbButtonSize.medium,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : assert(label != null || child != null, 'Provide either label or child');

  /// Text label of the button. Rendered with the label text style.
  final String? label;

  /// Custom child widget. Use when you need more than a text label.
  final Widget? child;

  /// Called when the button is tapped. Set to null to disable.
  final VoidCallback? onPressed;

  /// Visual style variant.
  final NbButtonVariant variant;

  /// Size variant.
  final NbButtonSize size;

  /// Widget displayed to the left of the label (e.g. Icon).
  final Widget? leading;

  /// Widget displayed to the right of the label.
  final Widget? trailing;

  /// When true, shows a circular progress indicator and disables interaction.
  final bool isLoading;

  /// When true, the button expands to fill its parent's width.
  final bool isFullWidth;

  // ─── Convenience constructors ─────────────────────────────────────────────

  const NbButton.primary({
    super.key,
    required String label,
    required VoidCallback? onPressed,
    NbButtonSize size = NbButtonSize.medium,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
          label: label,
          onPressed: onPressed,
          variant: NbButtonVariant.primary,
          size: size,
          leading: leading,
          trailing: trailing,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
        );

  const NbButton.secondary({
    super.key,
    required String label,
    required VoidCallback? onPressed,
    NbButtonSize size = NbButtonSize.medium,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
          label: label,
          onPressed: onPressed,
          variant: NbButtonVariant.secondary,
          size: size,
          leading: leading,
          trailing: trailing,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
        );

  const NbButton.danger({
    super.key,
    required String label,
    required VoidCallback? onPressed,
    NbButtonSize size = NbButtonSize.medium,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
          label: label,
          onPressed: onPressed,
          variant: NbButtonVariant.danger,
          size: size,
          leading: leading,
          trailing: trailing,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
        );

  const NbButton.ghost({
    super.key,
    required String label,
    required VoidCallback? onPressed,
    NbButtonSize size = NbButtonSize.medium,
    Widget? leading,
    Widget? trailing,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
          label: label,
          onPressed: onPressed,
          variant: NbButtonVariant.ghost,
          size: size,
          leading: leading,
          trailing: trailing,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
        );

  @override
  State<NbButton> createState() => _NbButtonState();
}

class _NbButtonState extends State<NbButton> {
  bool _pressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  void _onTapDown(TapDownDetails _) {
    if (!_isEnabled) return;
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (!_isEnabled) return;
    setState(() => _pressed = false);
    widget.onPressed?.call();
  }

  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final hasShadow = widget.variant == NbButtonVariant.primary && _isEnabled;

    final bg = _resolveBackground(colors);
    final fg = _resolveForeground(colors);
    final borderColor = _resolveBorderColor(colors);
    final padding = _resolvePadding();

    final offset = _pressed ? theme.shadowOffsetX : 0.0;

    Widget button = AnimatedContainer(
      duration: theme.pressAnimationDuration,
      transform: Matrix4.translationValues(offset, offset, 0),
      padding: padding,
      decoration: BoxDecoration(
        color: _isEnabled ? bg : colors.muted,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: _isEnabled ? borderColor : colors.mutedForeground,
          width: theme.borderWidth,
        ),
        boxShadow: hasShadow && !_pressed
            ? [theme.hardShadow]
            : null,
      ),
      child: _buildContent(fg, colors, theme),
    );

    if (widget.isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        // Reserves shadow space so layout doesn't shift on press.
        margin: hasShadow ? theme.shadowMargin : EdgeInsets.zero,
        child: button,
      ),
    );
  }

  Widget _buildContent(Color fg, NbColorScheme colors, NbThemeData theme) {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(fg),
          ),
        ),
      );
    }

    final labelStyle = theme.typography.label.copyWith(
      color: _isEnabled ? fg : colors.mutedForeground,
    );

    final children = <Widget>[
      if (widget.leading != null) ...[
        IconTheme(data: IconThemeData(color: labelStyle.color, size: 16), child: widget.leading!),
        const SizedBox(width: 8),
      ],
      if (widget.child != null)
        widget.child!
      else
        Text(widget.label!, style: labelStyle, textAlign: TextAlign.center),
      if (widget.trailing != null) ...[
        const SizedBox(width: 8),
        IconTheme(data: IconThemeData(color: labelStyle.color, size: 16), child: widget.trailing!),
      ],
    ];

    return widget.isFullWidth
        ? Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: children)
        : Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  Color _resolveBackground(NbColorScheme c) {
    return switch (widget.variant) {
      NbButtonVariant.primary   => c.primary,
      NbButtonVariant.secondary => c.surface,
      NbButtonVariant.danger    => c.surface,
      NbButtonVariant.success   => c.success,
      NbButtonVariant.ghost     => Colors.transparent,
    };
  }

  Color _resolveForeground(NbColorScheme c) {
    return switch (widget.variant) {
      NbButtonVariant.primary   => c.primaryForeground,
      NbButtonVariant.secondary => c.foreground,
      NbButtonVariant.danger    => c.danger,
      NbButtonVariant.success   => c.successForeground,
      NbButtonVariant.ghost     => c.foreground,
    };
  }

  Color _resolveBorderColor(NbColorScheme c) {
    return switch (widget.variant) {
      NbButtonVariant.danger => c.danger,
      _                      => c.border,
    };
  }

  EdgeInsets _resolvePadding() {
    return switch (widget.size) {
      NbButtonSize.small  => const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      NbButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      NbButtonSize.large  => const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
    };
  }
}
