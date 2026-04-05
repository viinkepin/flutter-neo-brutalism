import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled skeleton loading placeholder.
///
/// When [isLoading] is true, renders a shimmer-free bordered placeholder block.
/// When false (and [child] is provided), renders the child instead.
///
/// ```dart
/// // Single block
/// NbSkeleton(width: 200, height: 16)
///
/// // Text lines placeholder
/// NbSkeleton.text(lines: 3)
///
/// // Circle avatar placeholder
/// NbSkeleton.avatar(size: 40)
///
/// // Toggle between skeleton and real content
/// NbSkeleton(isLoading: _loading, width: double.infinity, height: 16, child: Text('Loaded!'))
/// ```
class NbSkeleton extends StatefulWidget {
  /// Single rectangular skeleton block.
  const NbSkeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.isLoading = true,
    this.child,
  }) : _variant = _NbSkeletonVariant.block,
       _lines = 1,
       _lineHeight = 14,
       _lineSpacing = 8,
       _size = 40;

  /// Stack of text-line skeletons.
  const NbSkeleton.text({
    super.key,
    int lines = 3,
    double lineHeight = 14,
    double lineSpacing = 8,
  }) : _variant = _NbSkeletonVariant.text,
       _lines = lines,
       _lineHeight = lineHeight,
       _lineSpacing = lineSpacing,
       width = null,
       height = lineHeight,
       borderRadius = null,
       isLoading = true,
       child = null,
       _size = 40;

  /// Circular skeleton for avatars.
  const NbSkeleton.avatar({
    super.key,
    double size = 40,
  }) : _variant = _NbSkeletonVariant.avatar,
       _size = size,
       _lines = 1,
       _lineHeight = 14,
       _lineSpacing = 8,
       width = null,
       height = size,
       borderRadius = null,
       isLoading = true,
       child = null;

  final _NbSkeletonVariant _variant;

  /// Width of the skeleton block. Defaults to `double.infinity`.
  final double? width;

  /// Height of the skeleton block.
  final double height;

  /// Corner radius override. Defaults to theme `borderRadius`.
  final double? borderRadius;

  /// When false and [child] is provided, renders [child] instead.
  final bool isLoading;

  /// Widget to show when [isLoading] is false.
  final Widget? child;

  final int _lines;
  final double _lineHeight;
  final double _lineSpacing;
  final double _size;

  @override
  State<NbSkeleton> createState() => _NbSkeletonState();
}

enum _NbSkeletonVariant { block, text, avatar }

class _NbSkeletonState extends State<NbSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading && widget.child != null) return widget.child!;

    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final opacity = _animation.value;
        return switch (widget._variant) {
          _NbSkeletonVariant.avatar => _buildBlock(
              theme, colors, opacity,
              width: widget._size,
              height: widget._size,
              radius: widget._size / 2,
            ),
          _NbSkeletonVariant.text => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget._lines, (i) {
                // Last line slightly shorter for realism
                final w = i == widget._lines - 1 ? 0.7 : 1.0;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < widget._lines - 1 ? widget._lineSpacing : 0,
                  ),
                  child: _buildBlock(
                    theme, colors, opacity,
                    width: null,
                    widthFactor: w,
                    height: widget._lineHeight,
                    radius: theme.borderRadius / 2,
                  ),
                );
              }),
            ),
          _NbSkeletonVariant.block => _buildBlock(
              theme, colors, opacity,
              width: widget.width,
              height: widget.height,
              radius: widget.borderRadius ?? theme.borderRadius,
            ),
        };
      },
    );
  }

  Widget _buildBlock(
    dynamic theme,
    dynamic colors,
    double opacity, {
    double? width,
    double? widthFactor,
    required double height,
    required double radius,
  }) {
    Widget box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (colors.muted as Color).withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: (colors.border as Color).withValues(alpha: opacity * 0.5),
          width: (theme.borderWidth as double) * 0.5,
        ),
      ),
    );

    if (widthFactor != null) {
      box = FractionallySizedBox(widthFactor: widthFactor, child: box);
    }

    return box;
  }
}
