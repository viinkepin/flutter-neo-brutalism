import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// A Neo-Brutalism styled accordion / collapsible section.
///
/// ```dart
/// NbAccordion(
///   title: 'What is Neo-Brutalism?',
///   child: NbText.body('A design style combining brutalism with modern UI...'),
/// )
///
/// // Group of accordions (only one open at a time)
/// NbAccordionGroup(
///   items: [
///     NbAccordionItem(title: 'Section 1', child: Text('Content 1')),
///     NbAccordionItem(title: 'Section 2', child: Text('Content 2')),
///   ],
/// )
/// ```
class NbAccordion extends StatefulWidget {
  const NbAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.padding,
    this.onExpansionChanged,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  /// Optional leading widget (e.g. an icon representing the section).
  final Widget? leading;

  /// Optional widget shown on the right of the header (in addition to the arrow).
  final Widget? trailing;

  final EdgeInsets? padding;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<NbAccordion> createState() => _NbAccordionState();
}

class _NbAccordionState extends State<NbAccordion>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurn;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
      value: _expanded ? 1.0 : 0.0,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurn = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final padding = widget.padding ?? const EdgeInsets.all(14);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: colors.border, width: theme.borderWidth),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────────
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: _expanded ? colors.primary.withValues(alpha: 0.06) : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(theme.borderRadius - 2),
                  topRight: Radius.circular(theme.borderRadius - 2),
                  bottomLeft: Radius.circular(_expanded ? 0 : theme.borderRadius - 2),
                  bottomRight: Radius.circular(_expanded ? 0 : theme.borderRadius - 2),
                ),
              ),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    IconTheme(
                      data: IconThemeData(color: colors.foreground, size: 18),
                      child: widget.leading!,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.typography.label.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    widget.trailing!,
                    const SizedBox(width: 6),
                  ],
                  RotationTransition(
                    turns: _iconTurn,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: colors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────
          ClipRect(
            child: AnimatedBuilder(
              animation: _heightFactor,
              builder: (_, child) => SizeTransition(
                sizeFactor: _heightFactor,
                child: child,
              ),
              child: Column(
                children: [
                  Container(height: 2, color: colors.border),
                  Padding(
                    padding: padding,
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Accordion Group ──────────────────────────────────────────────────────────

/// Data model for [NbAccordionGroup].
class NbAccordionItem {
  const NbAccordionItem({
    required this.title,
    required this.child,
    this.leading,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final Widget? leading;
  final bool initiallyExpanded;
}

/// A group of [NbAccordion] items where only one can be open at a time.
class NbAccordionGroup extends StatefulWidget {
  const NbAccordionGroup({
    super.key,
    required this.items,
    this.gap = 8,
  });

  final List<NbAccordionItem> items;

  /// Vertical gap between accordion items.
  final double gap;

  @override
  State<NbAccordionGroup> createState() => _NbAccordionGroupState();
}

class _NbAccordionGroupState extends State<NbAccordionGroup> {
  late int? _openIndex;

  @override
  void initState() {
    super.initState();
    _openIndex = widget.items.indexWhere((i) => i.initiallyExpanded);
    if (_openIndex == -1) _openIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < widget.items.length; i++) ...[
          NbAccordion(
            title: widget.items[i].title,
            leading: widget.items[i].leading,
            initiallyExpanded: _openIndex == i,
            onExpansionChanged: (expanded) {
              setState(() => _openIndex = expanded ? i : null);
            },
            child: widget.items[i].child,
          ),
          if (i < widget.items.length - 1) SizedBox(height: widget.gap),
        ],
      ],
    );
  }
}
