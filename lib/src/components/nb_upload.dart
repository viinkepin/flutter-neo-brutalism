import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Dashed border painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    this.dashWidth = 8,
    this.dashSpace = 6,
  });

  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
              size.width - strokeWidth, size.height - strokeWidth),
          Radius.circular(borderRadius),
        ),
      );

    var distance = 0.0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(start, end), paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.borderRadius != borderRadius;
}

// ─── NbFileUpload ─────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled file upload zone.
///
/// This widget handles UI only — wire up [onTap] to your file picker.
/// Pass [fileName] to show the selected file, and [onClear] to allow removal.
///
/// ```dart
/// NbFileUpload(
///   label: 'Attachment',
///   fileName: _fileName,
///   onTap: () async {
///     final result = await FilePicker.platform.pickFiles();
///     if (result != null) setState(() => _fileName = result.files.single.name);
///   },
///   onClear: () => setState(() => _fileName = null),
/// )
/// ```
class NbFileUpload extends StatelessWidget {
  const NbFileUpload({
    super.key,
    this.label,
    this.fileName,
    this.onTap,
    this.onClear,
    this.hint = 'Tap to select a file',
    this.helperText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.acceptedTypes,
    this.maxSizeLabel,
  });

  /// Label above the upload zone.
  final String? label;

  /// Currently selected file name. When set, shows the file info row.
  final String? fileName;

  /// Called when the upload zone is tapped.
  final VoidCallback? onTap;

  /// Called when the clear button is tapped.
  final VoidCallback? onClear;

  final String hint;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool enabled;

  /// Shown below the hint (e.g. "PDF, DOC, XLSX").
  final String? acceptedTypes;

  /// Shown below the hint (e.g. "Max 10 MB").
  final String? maxSizeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasFile = fileName != null && fileName!.isNotEmpty;
    final borderColor = hasError ? colors.danger : colors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: theme.typography.label.copyWith(color: hasError ? colors.danger : colors.foreground),
              children: required
                  ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // ── Upload Zone ────────────────────────────────────────────
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: hasError
                  ? colors.danger
                  : enabled
                      ? borderColor
                      : colors.mutedForeground,
              strokeWidth: 2,
              borderRadius: theme.borderRadius,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: enabled ? colors.muted.withValues(alpha: 0.3) : colors.muted,
                borderRadius: BorderRadius.circular(theme.borderRadius),
              ),
              child: hasFile
                  ? _FilePreview(
                      fileName: fileName!,
                      onClear: enabled ? onClear : null,
                      theme: theme,
                      colors: colors,
                    )
                  : _UploadPlaceholder(
                      hint: hint,
                      acceptedTypes: acceptedTypes,
                      maxSizeLabel: maxSizeLabel,
                      theme: theme,
                      colors: colors,
                      enabled: enabled,
                    ),
            ),
          ),
        ),

        // ── Helper / Error ─────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(errorText!, style: theme.typography.caption.copyWith(color: colors.danger)),
        ] else if (helperText != null) ...[
          const SizedBox(height: 5),
          Text(helperText!, style: theme.typography.caption.copyWith(color: colors.mutedForeground)),
        ],
      ],
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder({
    required this.hint,
    required this.theme,
    required this.colors,
    required this.enabled,
    this.acceptedTypes,
    this.maxSizeLabel,
    this.isPhoto = false,
  });

  final String hint;
  final String? acceptedTypes;
  final String? maxSizeLabel;
  final dynamic theme;
  final dynamic colors;
  final bool enabled;
  final bool isPhoto;

  @override
  Widget build(BuildContext context) {
    final iconColor = enabled ? colors.foreground : colors.mutedForeground;

    // Photo variant: compact icon-only layout (fits inside small square/circle zones)
    if (isPhoto) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 28,
            color: iconColor,
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            style: (theme.typography.caption as TextStyle).copyWith(color: iconColor),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // File variant: full layout with decorated icon box + accepted types/size info
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (enabled ? colors.foreground : colors.mutedForeground).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (enabled ? colors.foreground : colors.mutedForeground).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.upload_file_outlined,
            size: 28,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hint,
          style: (theme.typography.label as TextStyle).copyWith(color: iconColor),
          textAlign: TextAlign.center,
        ),
        if (acceptedTypes != null || maxSizeLabel != null) ...[
          const SizedBox(height: 4),
          Text(
            [if (acceptedTypes != null) acceptedTypes!, if (maxSizeLabel != null) maxSizeLabel!].join(' · '),
            style: (theme.typography.caption as TextStyle).copyWith(color: colors.mutedForeground),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({
    required this.fileName,
    required this.onClear,
    required this.theme,
    required this.colors,
  });

  final String fileName;
  final VoidCallback? onClear;
  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.success.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.success.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Icon(Icons.insert_drive_file_outlined, size: 20, color: colors.success),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: (theme.typography.label as TextStyle).copyWith(color: colors.foreground),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'File selected',
                style: (theme.typography.caption as TextStyle).copyWith(color: colors.success),
              ),
            ],
          ),
        ),
        if (onClear != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colors.danger.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Icon(Icons.close_rounded, size: 14, color: colors.danger),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── NbPhotoUpload ────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled photo upload zone.
///
/// Shows a dashed-border drop zone with a camera icon placeholder.
/// When [hasImage] is true, renders [imageChild] with a remove overlay.
///
/// ```dart
/// NbPhotoUpload(
///   label: 'Product Photo',
///   hasImage: _imageBytes != null,
///   imageChild: _imageBytes != null
///       ? Image.memory(_imageBytes!, fit: BoxFit.cover)
///       : null,
///   onTap: () async {
///     // trigger image picker, set _imageBytes
///   },
///   onClear: () => setState(() => _imageBytes = null),
/// )
/// ```
class NbPhotoUpload extends StatelessWidget {
  const NbPhotoUpload({
    super.key,
    this.label,
    this.hasImage = false,
    this.imageChild,
    this.onTap,
    this.onClear,
    this.hint = 'Tap to add photo',
    this.helperText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.size = 120,
    this.shape = NbPhotoUploadShape.square,
  });

  final String? label;

  /// Set to true when an image is selected.
  final bool hasImage;

  /// The image widget to render when [hasImage] is true.
  /// Use `Image.memory(bytes, fit: BoxFit.cover)` or similar.
  final Widget? imageChild;

  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final String hint;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool enabled;

  /// Width and height of the upload zone in logical pixels.
  final double size;

  final NbPhotoUploadShape shape;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final hasError = errorText != null && errorText!.isNotEmpty;
    final isCircle = shape == NbPhotoUploadShape.circle;
    final borderRadius = isCircle ? size / 2 : theme.borderRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: theme.typography.label.copyWith(color: hasError ? colors.danger : colors.foreground),
              children: required
                  ? [TextSpan(text: ' *', style: TextStyle(color: colors.danger))]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
        ],
        GestureDetector(
          onTap: enabled && !hasImage ? onTap : null,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                // Base: dashed zone or image
                CustomPaint(
                  painter: hasImage
                      ? null
                      : _DashedBorderPainter(
                          color: hasError
                              ? colors.danger
                              : enabled
                                  ? colors.border
                                  : colors.mutedForeground,
                          strokeWidth: 2,
                          borderRadius: borderRadius,
                        ),
                  child: Container(
                    width: size,
                    height: size,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: hasImage ? null : enabled ? colors.muted.withValues(alpha: 0.3) : colors.muted,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: hasImage
                          ? Border.all(
                              color: hasError ? colors.danger : colors.border,
                              width: theme.borderWidth,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius - 1),
                      child: hasImage && imageChild != null
                          ? imageChild
                          : Center(
                              child: _UploadPlaceholder(
                                hint: hint,
                                theme: theme,
                                colors: colors,
                                enabled: enabled,
                                isPhoto: true,
                              ),
                            ),
                    ),
                  ),
                ),

                // Clear button overlay (top-right)
                if (hasImage && onClear != null && enabled)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ),

                // Edit button overlay (bottom-right, when image selected)
                if (hasImage && onTap != null && enabled)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colors.border, width: 1.5),
                        ),
                        child: Icon(Icons.edit_rounded, size: 14, color: colors.primaryForeground),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(errorText!, style: theme.typography.caption.copyWith(color: colors.danger)),
        ] else if (helperText != null) ...[
          const SizedBox(height: 5),
          Text(helperText!, style: theme.typography.caption.copyWith(color: colors.mutedForeground)),
        ],
      ],
    );
  }
}

enum NbPhotoUploadShape { square, circle }
