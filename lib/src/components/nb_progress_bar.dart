import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled progress indicator.
///
/// Two variants: linear (default) and circular.
///
/// ```dart
/// // Linear
/// NbProgressBar(value: 0.65)
/// NbProgressBar(value: 0.65, label: '65%')
///
/// // Circular
/// NbProgressBar.circular(value: 0.4, size: 48)
/// NbProgressBar.circular(value: 0.75, size: 64, label: '75%')
/// ```
class NbProgressBar extends StatelessWidget {
  /// Linear progress bar.
  const NbProgressBar({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.label,
    this.height = 12,
  }) : _circular = false,
       _size = 48;

  /// Circular progress indicator.
  const NbProgressBar.circular({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.label,
    double size = 48,
  }) : _circular = true,
       _size = size,
       height = 12;

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Fill color. Defaults to [NbColorScheme.primary].
  final Color? color;

  /// Track/background color. Defaults to [NbColorScheme.muted].
  final Color? backgroundColor;

  /// Label shown below (linear) or centered inside (circular).
  final String? label;

  /// Track height for linear variant. Default: 12.
  final double height;

  final bool _circular;
  final double _size;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final fill = color ?? colors.primary;
    final track = backgroundColor ?? colors.muted;
    final clampedValue = value.clamp(0.0, 1.0);

    if (_circular) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _size,
            height: _size,
            child: CustomPaint(
              painter: _CircularProgressPainter(
                value: clampedValue,
                fill: fill,
                track: track,
                borderColor: colors.border,
                borderWidth: theme.borderWidth,
                strokeWidth: _size * 0.12,
              ),
              child: label != null
                  ? Center(
                      child: Text(
                        label!,
                        style: theme.typography.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.foreground,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      );
    }

    // Linear
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: track,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(color: colors.border, width: theme.borderWidth),
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final fillWidth = constraints.maxWidth * clampedValue;
              return Stack(
                children: [
                  if (clampedValue > 0)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: fillWidth,
                      decoration: BoxDecoration(
                        color: fill,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: theme.typography.caption.copyWith(color: colors.mutedForeground),
          ),
        ],
      ],
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  const _CircularProgressPainter({
    required this.value,
    required this.fill,
    required this.track,
    required this.borderColor,
    required this.borderWidth,
    required this.strokeWidth,
  });

  final double value;
  final Color fill;
  final Color track;
  final Color borderColor;
  final double borderWidth;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = track
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fill
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    // Track
    canvas.drawCircle(center, radius, trackPaint);

    // Fill arc
    if (value > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * value,
        false,
        fillPaint,
      );
    }

    // Border circle
    canvas.drawCircle(center, radius + strokeWidth / 2, borderPaint);
    canvas.drawCircle(center, radius - strokeWidth / 2, borderPaint);
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) =>
      old.value != value || old.fill != fill;
}
