import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

/// Column definition for [NbTable].
///
/// Use [flex] for proportional columns or [width] for fixed-width columns.
/// Do not set both on the same column.
class NbTableColumn {
  const NbTableColumn({
    required this.label,
    this.flex,
    this.width,
    this.alignment = Alignment.centerLeft,
  }) : assert(
          !(flex != null && width != null),
          'Use either flex or width, not both.',
        );

  /// Column header label.
  final String label;

  /// Flex factor for proportional sizing.
  final int? flex;

  /// Fixed column width in logical pixels.
  final double? width;

  /// Cell content alignment. Default: [Alignment.centerLeft].
  final AlignmentGeometry alignment;
}

/// A Neo-Brutalism styled data table with horizontal scroll.
///
/// Simple display only — no sorting or filtering.
///
/// ```dart
/// NbTable(
///   columns: [
///     NbTableColumn(label: 'Produk', flex: 2),
///     NbTableColumn(label: 'Harga', width: 100),
///     NbTableColumn(label: 'Stok', width: 80),
///   ],
///   rows: [
///     [Text('Kopi'), Text('Rp 15.000'), Text('42')],
///     [Text('Teh'), Text('Rp 10.000'), Text('18')],
///   ],
/// )
/// ```
class NbTable extends StatelessWidget {
  const NbTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  /// Column definitions.
  final List<NbTableColumn> columns;

  /// Table rows. Each inner list must have the same length as [columns].
  final List<List<Widget>> rows;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: colors.border, width: theme.borderWidth),
      ),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                color: colors.muted,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: _TableRow(
                  cells: columns.map((c) => c.label).toList(),
                  columns: columns,
                  isHeader: true,
                  theme: theme,
                  colors: colors,
                ),
              ),
              Divider(color: colors.border, height: theme.borderWidth, thickness: theme.borderWidth),

              // ── Rows ─────────────────────────────────────────────────────
              for (int i = 0; i < rows.length; i++) ...[
                _TableWidgetRow(
                  widgets: rows[i],
                  columns: columns,
                  isEven: i.isEven,
                  theme: theme,
                  colors: colors,
                ),
                if (i < rows.length - 1)
                  Divider(color: colors.muted, height: 1, thickness: 1),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.cells,
    required this.columns,
    required this.isHeader,
    required this.theme,
    required this.colors,
  });

  final List<String> cells;
  final List<NbTableColumn> columns;
  final bool isHeader;
  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(cells.length, (i) {
        final col = columns[i];
        final cell = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Align(
            alignment: col.alignment,
            child: Text(
              cells[i],
              style: isHeader
                  ? (theme.typography.label as TextStyle).copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w700,
                    )
                  : (theme.typography.body as TextStyle).copyWith(
                      color: colors.foreground,
                    ),
            ),
          ),
        );

        if (col.flex != null) return Expanded(flex: col.flex!, child: cell);
        return SizedBox(width: col.width ?? 120, child: cell);
      }),
    );
  }
}

class _TableWidgetRow extends StatelessWidget {
  const _TableWidgetRow({
    required this.widgets,
    required this.columns,
    required this.isEven,
    required this.theme,
    required this.colors,
  });

  final List<Widget> widgets;
  final List<NbTableColumn> columns;
  final bool isEven;
  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? null : (colors.muted as Color).withValues(alpha: 0.3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widgets.length, (i) {
          final col = columns[i];
          final cell = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Align(
              alignment: col.alignment,
              child: DefaultTextStyle(
                style: (theme.typography.body as TextStyle).copyWith(
                  color: colors.foreground,
                ),
                child: widgets[i],
              ),
            ),
          );

          if (col.flex != null) return Expanded(flex: col.flex!, child: cell);
          return SizedBox(width: col.width ?? 120, child: cell);
        }),
      ),
    );
  }
}
