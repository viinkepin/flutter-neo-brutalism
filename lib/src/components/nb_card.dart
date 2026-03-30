import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';
import '../theme/nb_theme_data.dart';

/// Visual style variant of [NbCard].
enum NbCardVariant {
  /// White/surface fill, 2px black border, no shadow.
  /// Use for list items, info panels, inner content — most of the time.
  flat,

  /// White/surface fill, 2px black border, hard 4px offset shadow.
  /// Use sparingly for primary content sections that need emphasis.
  elevated,

  /// Colored background (set via [NbCard.backgroundColor]),
  /// 2px black border, no shadow.
  filled,
}

/// A Neo-Brutalism styled container / card.
///
/// **Shadow rule:** Only [NbCardVariant.elevated] has a shadow. Use it
/// for primary content areas, not for list items or inner elements.
///
/// Tappable cards (via [onTap]) use the same press-into-shadow animation
/// as [NbButton] when [variant] is [NbCardVariant.elevated].
///
/// ```dart
/// // Basic card
/// NbCard(
///   child: NbText.body('Hello'),
/// )
///
/// // Elevated card (with shadow)
/// NbCard.elevated(
///   child: Column(...),
/// )
///
/// // Tappable card
/// NbCard.elevated(
///   onTap: () => ...,
///   child: Row(...),
/// )
///
/// // Filled card (custom background color)
/// NbCard.filled(
///   backgroundColor: Color(0xFFFDE047),
///   child: Text('Highlight'),
/// )
/// ```
class NbCard extends StatefulWidget {
  const NbCard({
    super.key,
    required this.child,
    this.variant = NbCardVariant.flat,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderWidth,
    this.onTap,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  });

  // ─── Convenience constructors ─────────────────────────────────────────────

  const NbCard.elevated({
    Key? key,
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    double? borderWidth,
    VoidCallback? onTap,
    double? width,
    double? height,
    Clip clipBehavior = Clip.none,
  }) : this(
          key: key,
          child: child,
          variant: NbCardVariant.elevated,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          onTap: onTap,
          width: width,
          height: height,
          clipBehavior: clipBehavior,
        );

  const NbCard.filled({
    Key? key,
    required Widget child,
    required Color backgroundColor,
    Color? borderColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    double? borderWidth,
    VoidCallback? onTap,
    double? width,
    double? height,
    Clip clipBehavior = Clip.none,
  }) : this(
          key: key,
          child: child,
          variant: NbCardVariant.filled,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          onTap: onTap,
          width: width,
          height: height,
          clipBehavior: clipBehavior,
        );

  // ─── Properties ──────────────────────────────────────────────────────────

  final Widget child;
  final NbCardVariant variant;

  /// Background color. Defaults to [NbColorScheme.surface] (white).
  final Color? backgroundColor;

  /// Border color. Defaults to [NbColorScheme.border] (black).
  final Color? borderColor;

  final EdgeInsets? padding;
  final EdgeInsets? margin;

  /// Corner radius. Defaults to [NbThemeData.borderRadius].
  final double? borderRadius;

  /// Border width. Defaults to [NbThemeData.borderWidth].
  final double? borderWidth;

  /// If provided, the card becomes tappable with a press animation.
  /// Elevated variant will press into its shadow; flat/filled will scale slightly.
  final VoidCallback? onTap;

  final double? width;
  final double? height;
  final Clip clipBehavior;

  @override
  State<NbCard> createState() => _NbCardState();
}

class _NbCardState extends State<NbCard> {
  bool _pressed = false;

  bool get _isTappable => widget.onTap != null;
  bool get _isElevated => widget.variant == NbCardVariant.elevated;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final bg = widget.backgroundColor ?? colors.surface;
    final border = widget.borderColor ?? colors.border;
    final radius = widget.borderRadius ?? theme.borderRadius;
    final bWidth = widget.borderWidth ?? theme.borderWidth;
    final hasShadow = _isElevated && _isTappable;
    final offset = _pressed ? theme.shadowOffsetX : 0.0;

    Widget card = AnimatedContainer(
      duration: theme.pressAnimationDuration,
      width: widget.width,
      height: widget.height,
      clipBehavior: widget.clipBehavior,
      transform: _isTappable && _isElevated
          ? Matrix4.translationValues(offset, offset, 0)
          : Matrix4.identity(),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: bWidth),
        boxShadow: _isElevated && (!_pressed || !_isTappable)
            ? [theme.hardShadow]
            : null,
      ),
      child: widget.child,
    );

    if (!_isTappable) {
      return Container(margin: widget.margin, child: card);
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap!();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Container(
        margin: widget.margin ?? (hasShadow ? theme.shadowMargin : EdgeInsets.zero),
        child: card,
      ),
    );
  }
}
