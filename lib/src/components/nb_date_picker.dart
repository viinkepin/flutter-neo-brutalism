import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── NbDatePicker ─────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled date picker with three scroll columns: Day | Month | Year.
///
/// Use [NbDatePicker.show] to present as a bottom sheet:
/// ```dart
/// final date = await NbDatePicker.show(
///   context: context,
///   initialDate: DateTime.now(),
/// );
/// if (date != null) setState(() => _date = date);
/// ```
///
/// Or embed inline:
/// ```dart
/// NbDatePicker(
///   initialDate: _date,
///   onChanged: (d) => setState(() => _date = d),
/// )
/// ```
class NbDatePicker extends StatefulWidget {
  const NbDatePicker({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onChanged,
  });

  /// Starting date. Defaults to today.
  final DateTime? initialDate;

  /// Earliest selectable date. Default: 100 years ago.
  final DateTime? minDate;

  /// Latest selectable date. Default: 10 years from now.
  final DateTime? maxDate;

  /// Called every time any column changes.
  final ValueChanged<DateTime>? onChanged;

  /// Shows [NbDatePicker] as a modal bottom sheet and returns the picked [DateTime].
  ///
  /// Returns `null` if dismissed without confirming.
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    String confirmLabel = 'Select',
    String title = 'Select Date',
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _NbDatePickerSheet(
        initialDate: initialDate ?? DateTime.now(),
        minDate: minDate,
        maxDate: maxDate,
        confirmLabel: confirmLabel,
        title: title,
      ),
    );
  }

  @override
  State<NbDatePicker> createState() => _NbDatePickerState();
}

class _NbDatePickerState extends State<NbDatePicker> {
  static const double _itemExtent = 44.0;
  static const int _visibleItems = 5;

  late int _day;
  late int _month;
  late int _year;

  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;

  int get _minYear =>
      widget.minDate?.year ?? (DateTime.now().year - 100);
  int get _maxYear =>
      widget.maxDate?.year ?? (DateTime.now().year + 10);
  int get _yearCount => _maxYear - _minYear + 1;

  int get _daysInMonth => DateTime(_year, _month + 1, 0).day;

  DateTime get _currentDate =>
      DateTime(_year, _month, min(_day, _daysInMonth));

  static const _monthNames = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.initialDate ?? DateTime.now();
    _day = d.day;
    _month = d.month;
    _year = d.year.clamp(_minYear, _maxYear);

    _dayCtrl = FixedExtentScrollController(initialItem: _day - 1);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtrl = FixedExtentScrollController(initialItem: _year - _minYear);
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  void _onDayChanged(int index) {
    setState(() => _day = index + 1);
    widget.onChanged?.call(_currentDate);
  }

  void _onMonthChanged(int index) {
    setState(() => _month = index + 1);
    _clampDay();
  }

  void _onYearChanged(int index) {
    setState(() => _year = _minYear + index);
    _clampDay();
  }

  void _clampDay() {
    final maxDay = _daysInMonth;
    if (_day > maxDay) {
      setState(() => _day = maxDay);
      _dayCtrl.animateToItem(
        maxDay - 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
    widget.onChanged?.call(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final pickerH = _itemExtent * _visibleItems;

    return SizedBox(
      height: pickerH,
      child: Stack(
        children: [
          // ── Three scroll columns ────────────────────────────────────
          Row(
            children: [
              // Day
              Expanded(
                flex: 2,
                child: _WheelColumn(
                  controller: _dayCtrl,
                  itemCount: 31,
                  itemExtent: _itemExtent,
                  onChanged: _onDayChanged,
                  itemBuilder: (i) => _WheelItem(
                    label: '${i + 1}'.padLeft(2, '0'),
                    selected: (i + 1) == _day,
                    theme: theme,
                    colors: colors,
                  ),
                ),
              ),
              // Month
              Expanded(
                flex: 3,
                child: _WheelColumn(
                  controller: _monthCtrl,
                  itemCount: 12,
                  itemExtent: _itemExtent,
                  onChanged: _onMonthChanged,
                  itemBuilder: (i) => _WheelItem(
                    label: _monthNames[i],
                    selected: (i + 1) == _month,
                    theme: theme,
                    colors: colors,
                  ),
                ),
              ),
              // Year
              Expanded(
                flex: 2,
                child: _WheelColumn(
                  controller: _yearCtrl,
                  itemCount: _yearCount,
                  itemExtent: _itemExtent,
                  onChanged: _onYearChanged,
                  itemBuilder: (i) => _WheelItem(
                    label: '${_minYear + i}',
                    selected: (_minYear + i) == _year,
                    theme: theme,
                    colors: colors,
                  ),
                ),
              ),
            ],
          ),

          // ── Center selection indicator (ignores pointer) ────────────
          IgnorePointer(
            child: Column(
              children: [
                SizedBox(height: (_itemExtent * (_visibleItems ~/ 2))),
                Container(
                  height: _itemExtent,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: colors.border,
                        width: theme.borderWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Top fade ─────────────────────────────────────────────────
          IgnorePointer(
            child: Container(
              height: pickerH / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.surface,
                    colors.surface.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom fade ───────────────────────────────────────────────
          IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: pickerH / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colors.surface,
                      colors.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Wheel column ─────────────────────────────────────────────────────────────

class _WheelColumn extends StatelessWidget {
  const _WheelColumn({
    required this.controller,
    required this.itemCount,
    required this.itemExtent,
    required this.onChanged,
    required this.itemBuilder,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final double itemExtent;
  final ValueChanged<int> onChanged;
  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 8,
      perspective: 0.002,
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (_, i) => itemBuilder(i),
      ),
    );
  }
}

// ─── Wheel item ───────────────────────────────────────────────────────────────

class _WheelItem extends StatelessWidget {
  const _WheelItem({
    required this.label,
    required this.selected,
    required this.theme,
    required this.colors,
  });

  final String label;
  final bool selected;
  final dynamic theme;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final base = selected
        ? theme.typography.label as TextStyle
        : theme.typography.body as TextStyle;
    return Center(
      child: Text(
        label,
        style: base.copyWith(
          color: selected ? colors.foreground : colors.mutedForeground,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}

// ─── Bottom sheet wrapper ─────────────────────────────────────────────────────

class _NbDatePickerSheet extends StatefulWidget {
  const _NbDatePickerSheet({
    required this.initialDate,
    this.minDate,
    this.maxDate,
    required this.confirmLabel,
    required this.title,
  });

  final DateTime initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String confirmLabel;
  final String title;

  @override
  State<_NbDatePickerSheet> createState() => _NbDatePickerSheetState();
}

class _NbDatePickerSheetState extends State<_NbDatePickerSheet> {
  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: colors.border, width: theme.borderWidth),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Text(widget.title, style: theme.typography.title)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.muted,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.border, width: 1.5),
                    ),
                    child: Icon(Icons.close_rounded, size: 16, color: colors.foreground),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: colors.border, height: 1, thickness: theme.borderWidth),

          // Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: NbDatePicker(
              initialDate: widget.initialDate,
              minDate: widget.minDate,
              maxDate: widget.maxDate,
              onChanged: (d) => setState(() => _current = d),
            ),
          ),

          Divider(color: colors.border, height: 1, thickness: theme.borderWidth),

          // Confirm button
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            child: SizedBox(
              width: double.infinity,
              child: _NbConfirmButton(
                label: widget.confirmLabel,
                onTap: () => Navigator.of(context).pop(_current),
                colors: colors,
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Confirm button (avoids circular import with nb_button) ───────────────────

class _NbConfirmButton extends StatefulWidget {
  const _NbConfirmButton({
    required this.label,
    required this.onTap,
    required this.colors,
    required this.theme,
  });

  final String label;
  final VoidCallback onTap;
  final dynamic colors;
  final dynamic theme;

  @override
  State<_NbConfirmButton> createState() => _NbConfirmButtonState();
}

class _NbConfirmButtonState extends State<_NbConfirmButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final theme = widget.theme;
    final offset = theme.shadowOffsetX as double;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: theme.pressAnimationDuration as Duration,
        transform: _pressed
            ? Matrix4.translationValues(offset, offset, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(theme.borderRadius as double),
          border: Border.all(color: colors.border, width: theme.borderWidth as double),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: colors.foreground,
                    offset: Offset(offset, offset),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Center(
          child: Text(
            widget.label,
            style: (theme.typography.label as TextStyle).copyWith(
              color: colors.primaryForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
