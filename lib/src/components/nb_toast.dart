import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Variant ──────────────────────────────────────────────────────────────────

/// Visual variant of an [NbToast].
enum NbToastVariant { info, success, warning, error }

// ─── NbToastOverlay ───────────────────────────────────────────────────────────

/// Wraps your widget tree to enable [showNbToast] anywhere in the tree.
///
/// Place directly around (or inside) your [MaterialApp]:
/// ```dart
/// NbToastOverlay(
///   child: MaterialApp(home: MyApp()),
/// )
/// ```
///
/// Then show a toast from any widget:
/// ```dart
/// context.showNbToast('Tersimpan!', variant: NbToastVariant.success)
/// context.showNbToast('Gagal menyimpan', variant: NbToastVariant.error)
/// ```
class NbToastOverlay extends StatefulWidget {
  const NbToastOverlay({super.key, required this.child});

  final Widget child;

  static _NbToastOverlayState? _of(BuildContext context) {
    return context.findAncestorStateOfType<_NbToastOverlayState>();
  }

  @override
  State<NbToastOverlay> createState() => _NbToastOverlayState();
}

class _NbToastOverlayState extends State<NbToastOverlay> {
  final List<_ToastEntry> _entries = [];

  void show(
    String message, {
    NbToastVariant variant = NbToastVariant.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final entry = _ToastEntry(
      message: message,
      variant: variant,
      duration: duration,
      id: DateTime.now().microsecondsSinceEpoch,
    );
    setState(() => _entries.add(entry));

    Future.delayed(duration + const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _entries.removeWhere((e) => e.id == entry.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        widget.child,
        if (_entries.isNotEmpty)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _entries.map((entry) {
                return _NbToastItem(
                  key: ValueKey(entry.id),
                  entry: entry,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

// ─── Toast item ───────────────────────────────────────────────────────────────

class _ToastEntry {
  const _ToastEntry({
    required this.message,
    required this.variant,
    required this.duration,
    required this.id,
  });

  final String message;
  final NbToastVariant variant;
  final Duration duration;
  final int id;
}

class _NbToastItem extends StatefulWidget {
  const _NbToastItem({super.key, required this.entry});
  final _ToastEntry entry;

  @override
  State<_NbToastItem> createState() => _NbToastItemState();
}

class _NbToastItemState extends State<_NbToastItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(widget.entry.duration, () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    final variantColor = _resolveColor(colors);
    final icon = Icon(_resolveIcon(), size: 18, color: variantColor);

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(theme.borderRadius),
              border: Border.all(color: variantColor, width: theme.borderWidth),
              boxShadow: [theme.hardShadow],
            ),
            child: Row(
              children: [
                IconTheme(
                  data: IconThemeData(color: variantColor, size: 18),
                  child: icon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.entry.message,
                    style: theme.typography.body.copyWith(color: colors.foreground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveColor(dynamic colors) {
    return switch (widget.entry.variant) {
      NbToastVariant.info    => colors.secondary as Color,
      NbToastVariant.success => colors.success as Color,
      NbToastVariant.warning => colors.warning as Color,
      NbToastVariant.error   => colors.danger as Color,
    };
  }

  IconData _resolveIcon() {
    return switch (widget.entry.variant) {
      NbToastVariant.info    => Icons.info_outline_rounded,
      NbToastVariant.success => Icons.check_circle_outline_rounded,
      NbToastVariant.warning => Icons.warning_amber_rounded,
      NbToastVariant.error   => Icons.error_outline_rounded,
    };
  }
}

// ─── Context extension ────────────────────────────────────────────────────────

extension NbToastExtension on BuildContext {
  /// Shows a toast message. Requires [NbToastOverlay] to be an ancestor.
  void showNbToast(
    String message, {
    NbToastVariant variant = NbToastVariant.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    NbToastOverlay._of(this)?.show(message, variant: variant, duration: duration);
  }
}
