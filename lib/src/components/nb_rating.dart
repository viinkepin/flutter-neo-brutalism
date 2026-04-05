import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled star rating widget.
///
/// When [onChanged] is null, renders as read-only.
/// Supports half-star display (read-only only).
///
/// ```dart
/// // Interactive
/// NbRating(value: _rating, onChanged: (v) => setState(() => _rating = v))
///
/// // Read-only (supports half-star)
/// NbRating(value: 3.5)
///
/// // Custom max / size
/// NbRating(value: 2, maxValue: 5, size: 32, onChanged: (v) {})
/// ```
class NbRating extends StatelessWidget {
  const NbRating({
    super.key,
    required this.value,
    this.maxValue = 5,
    this.onChanged,
    this.size = 24,
    this.activeColor,
  });

  /// Current rating value.
  final double value;

  /// Number of stars. Default: 5.
  final int maxValue;

  /// Selection callback. `null` = read-only.
  final ValueChanged<double>? onChanged;

  /// Star size in logical pixels. Default: 24.
  final double size;

  /// Filled star color. Defaults to [NbColorScheme.primary].
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final fill = activeColor ?? colors.primary;
    final isInteractive = onChanged != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxValue, (i) {
        final starValue = i + 1;
        final filled = value >= starValue;
        final halfFilled = !filled && value >= starValue - 0.5;

        final star = _StarIcon(
          filled: filled,
          halfFilled: halfFilled,
          size: size,
          fill: fill,
          emptyColor: colors.muted,
          borderColor: colors.border,
        );

        if (!isInteractive) return star;

        return GestureDetector(
          onTap: () => onChanged!(starValue.toDouble()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: star,
          ),
        );
      }),
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    required this.filled,
    required this.halfFilled,
    required this.size,
    required this.fill,
    required this.emptyColor,
    required this.borderColor,
  });

  final bool filled;
  final bool halfFilled;
  final double size;
  final Color fill;
  final Color emptyColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    if (halfFilled) {
      return Stack(
        children: [
          Icon(Icons.star_rounded, size: size, color: emptyColor),
          ClipRect(
            clipper: _HalfClipper(),
            child: Icon(Icons.star_rounded, size: size, color: fill),
          ),
        ],
      );
    }

    return Icon(
      filled ? Icons.star_rounded : Icons.star_outline_rounded,
      size: size,
      color: filled ? fill : emptyColor,
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width / 2, size.height);

  @override
  bool shouldReclip(_HalfClipper _) => false;
}
