import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── NbTimePicker ─────────────────────────────────────────────────────────────

/// A Neo-Brutalism styled time picker with two wheel-scroll columns: Hour | Minute.
///
/// Mirrors the pattern of [NbDatePicker].
///
/// Use [NbTimePicker.show] for a bottom sheet:
/// ```dart
/// final time = await NbTimePicker.show(context, initialTime: TimeOfDay.now());
/// if (time != null) setState(() => _time = time);
/// ```
///
/// Or embed inline:
/// ```dart
/// NbTimePicker(
///   initialTime: _time,
///   onChanged: (t) => setState(() => _time = t),
/// )
/// ```
class NbTimePicker extends StatefulWidget {
  const NbTimePicker({
    super.key,
    this.initialTime,
    this.use24Hour = true,
    this.onChanged,
  });

  /// Starting time. Defaults to [TimeOfDay.now].
  final TimeOfDay? initialTime;

  /// Whether to use 24-hour format. Default: true.
  final bool use24Hour;

  /// Called when any column changes.
  final ValueChanged<TimeOfDay>? onChanged;

  /// Shows [NbTimePicker] as a modal bottom sheet and returns the picked [TimeOfDay].
  ///
  /// Returns `null` if dismissed without confirming.
  static Future<TimeOfDay?> show(
    BuildContext context, {
    TimeOfDay? initialTime,
    bool use24Hour = true,
    String confirmLabel = 'Select',
    String title = 'Select Time',
  }) {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NbTimePickerSheet(
        initialTime: initialTime ?? TimeOfDay.now(),
        use24Hour: use24Hour,
        confirmLabel: confirmLabel,
        title: title,
      ),
    );
  }

  @override
  State<NbTimePicker> createState() => _NbTimePickerState();
}

class _NbTimePickerState extends State<NbTimePicker> {
  static const double _itemExtent = 44.0;
  static const int _visibleItems = 5;

  late int _hour;
  late int _minute;

  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;

  int get _hourCount => widget.use24Hour ? 24 : 12;

  TimeOfDay get _current => TimeOfDay(hour: _hour, minute: _minute);

  @override
  void initState() {
    super.initState();
    final t = widget.initialTime ?? TimeOfDay.now();
    _hour = widget.use24Hour ? t.hour : (t.hour % 12 == 0 ? 12 : t.hour % 12);
    _minute = t.minute;

    _hourCtrl = FixedExtentScrollController(
      initialItem: widget.use24Hour ? _hour : _hour - 1,
    );
    _minuteCtrl = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  void _onHourChanged(int index) {
    setState(() => _hour = widget.use24Hour ? index : index + 1);
    widget.onChanged?.call(_current);
  }

  void _onMinuteChanged(int index) {
    setState(() => _minute = index);
    widget.onChanged?.call(_current);
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
          Row(
            children: [
              // Hour column
              Expanded(
                child: _WheelColumn(
                  controller: _hourCtrl,
                  itemCount: _hourCount,
                  itemExtent: _itemExtent,
                  onChanged: _onHourChanged,
                  itemBuilder: (i) {
                    final label = widget.use24Hour
                        ? i.toString().padLeft(2, '0')
                        : (i + 1).toString().padLeft(2, '0');
                    return _WheelItem(
                      label: label,
                      selected: widget.use24Hour ? i == _hour : (i + 1) == _hour,
                      theme: theme,
                      colors: colors,
                    );
                  },
                ),
              ),

              // Separator
              SizedBox(
                width: 24,
                child: Center(
                  child: Text(
                    ':',
                    style: theme.typography.title.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              // Minute column
              Expanded(
                child: _WheelColumn(
                  controller: _minuteCtrl,
                  itemCount: 60,
                  itemExtent: _itemExtent,
                  onChanged: _onMinuteChanged,
                  itemBuilder: (i) => _WheelItem(
                    label: i.toString().padLeft(2, '0'),
                    selected: i == _minute,
                    theme: theme,
                    colors: colors,
                  ),
                ),
              ),
            ],
          ),

          // Selection indicator
          IgnorePointer(
            child: Column(
              children: [
                SizedBox(height: _itemExtent * (_visibleItems ~/ 2)),
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

          // Top fade
          IgnorePointer(
            child: Container(
              height: pickerH / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.surface, colors.surface.withValues(alpha: 0)],
                ),
              ),
            ),
          ),

          // Bottom fade
          IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: pickerH / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [colors.surface, colors.surface.withValues(alpha: 0)],
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
  final Widget Function(int) itemBuilder;

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

class _NbTimePickerSheet extends StatefulWidget {
  const _NbTimePickerSheet({
    required this.initialTime,
    required this.use24Hour,
    required this.confirmLabel,
    required this.title,
  });

  final TimeOfDay initialTime;
  final bool use24Hour;
  final String confirmLabel;
  final String title;

  @override
  State<_NbTimePickerSheet> createState() => _NbTimePickerSheetState();
}

class _NbTimePickerSheetState extends State<_NbTimePickerSheet> {
  late TimeOfDay _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialTime;
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: NbTimePicker(
              initialTime: widget.initialTime,
              use24Hour: widget.use24Hour,
              onChanged: (t) => setState(() => _current = t),
            ),
          ),

          Divider(color: colors.border, height: 1, thickness: theme.borderWidth),

          Padding(
            padding: EdgeInsets.fromLTRB(
              16, 12, 16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            child: SizedBox(
              width: double.infinity,
              child: _ConfirmButton(
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

// ─── Confirm button (mirrors NbDatePicker pattern) ────────────────────────────

class _ConfirmButton extends StatefulWidget {
  const _ConfirmButton({
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
  State<_ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<_ConfirmButton> {
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
