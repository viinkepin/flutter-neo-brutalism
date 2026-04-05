import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled slider with hard-bordered thumb.
///
/// ```dart
/// NbSlider(value: _val, min: 0, max: 100, onChanged: (v) => setState(() => _val = v))
///
/// // With snap divisions and label
/// NbSlider(
///   value: _val,
///   min: 0,
///   max: 100,
///   divisions: 10,
///   label: '${_val.round()}%',
///   onChanged: (v) => setState(() => _val = v),
/// )
/// ```
class NbSlider extends StatefulWidget {
  const NbSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
    required this.onChanged,
    this.divisions,
    this.label,
    this.activeColor,
    this.enabled = true,
  });

  /// Current value.
  final double value;

  /// Minimum value. Default: 0.
  final double min;

  /// Maximum value. Default: 1.
  final double max;

  /// Called when value changes. `null` = disabled.
  final ValueChanged<double>? onChanged;

  /// Number of discrete snap points.
  final int? divisions;

  /// Tooltip text shown while dragging.
  final String? label;

  /// Track fill color. Defaults to [NbColorScheme.primary].
  final Color? activeColor;

  /// Interactive state. Default: true.
  final bool enabled;

  @override
  State<NbSlider> createState() => _NbSliderState();
}

class _NbSliderState extends State<NbSlider> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final fill = widget.activeColor ?? colors.primary;
    final isEnabled = widget.enabled && widget.onChanged != null;
    final trackColor = isEnabled ? fill : colors.mutedForeground;
    final emptyColor = isEnabled ? colors.muted : colors.muted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tooltip label
        if (widget.label != null && _dragging) ...[
          Align(
            alignment: _labelAlignment(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.foreground,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colors.border, width: 1.5),
              ),
              child: Text(
                widget.label!,
                style: theme.typography.labelSmall.copyWith(
                  color: colors.background,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: trackColor,
            inactiveTrackColor: emptyColor,
            thumbColor: isEnabled ? colors.surface : colors.muted,
            overlayColor: fill.withValues(alpha: 0.12),
            thumbShape: _NbThumbShape(
              borderColor: isEnabled ? colors.border : colors.mutedForeground,
              borderWidth: theme.borderWidth,
            ),
            trackShape: _NbTrackShape(
              borderColor: isEnabled ? colors.border : colors.mutedForeground,
              borderWidth: theme.borderWidth,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            tickMarkShape: widget.divisions != null
                ? _NbTickMarkShape(color: colors.border)
                : SliderTickMarkShape.noTickMark,
          ),
          child: Slider(
            value: widget.value.clamp(widget.min, widget.max),
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            onChanged: isEnabled ? widget.onChanged : null,
            onChangeStart: (_) => setState(() => _dragging = true),
            onChangeEnd: (_) => setState(() => _dragging = false),
          ),
        ),
      ],
    );
  }

  AlignmentGeometry _labelAlignment() {
    final fraction = (widget.value - widget.min) / (widget.max - widget.min);
    if (fraction < 0.1) return Alignment.centerLeft;
    if (fraction > 0.9) return Alignment.centerRight;
    return Alignment(fraction * 2 - 1, 0);
  }
}

// ─── Custom thumb ─────────────────────────────────────────────────────────────

class _NbThumbShape extends SliderComponentShape {
  const _NbThumbShape({
    required this.borderColor,
    required this.borderWidth,
    this.thumbRadius = 10,
  });

  final Color borderColor;
  final double borderWidth;
  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center + const Offset(3, 3), thumbRadius, shadowPaint);

    // Fill
    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, fillPaint);

    // Border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

// ─── Custom track ─────────────────────────────────────────────────────────────

class _NbTrackShape extends RoundedRectSliderTrackShape {
  const _NbTrackShape({
    required this.borderColor,
    required this.borderWidth,
  });

  final Color borderColor;
  final double borderWidth;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context, offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );

    // Draw border over the track
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    final radius = Radius.circular(rect.height / 2);
    context.canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), borderPaint);
  }
}

// ─── Custom tick mark ─────────────────────────────────────────────────────────

class _NbTickMarkShape extends SliderTickMarkShape {
  const _NbTickMarkShape({required this.color});
  final Color color;

  @override
  Size getPreferredSize({required SliderThemeData sliderTheme, required bool isEnabled}) =>
      const Size(4, 4);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    context.canvas.drawCircle(
      center,
      2,
      Paint()..color = color,
    );
  }
}
