import 'package:flutter/material.dart';
import 'nb_theme_data.dart';
import 'nb_color_scheme.dart';
import '../tokens/nb_typography.dart';

/// Provides a [NbThemeData] to all descendant widgets.
///
/// Place [NbTheme] near the root of your widget tree, inside or outside
/// Flutter's [MaterialApp]:
///
/// ```dart
/// NbTheme(
///   data: NbThemeData.light(
///     colorScheme: NbColorScheme.light(primary: Color(0xFF6366F1)),
///     fontFamily: 'DMSans',
///   ),
///   child: MaterialApp(...),
/// )
/// ```
///
/// Access the theme anywhere via:
/// ```dart
/// final theme = NbTheme.of(context);
/// final colors = theme.colorScheme;
/// ```
class NbTheme extends InheritedWidget {
  const NbTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme configuration to apply.
  final NbThemeData data;

  /// Returns the nearest [NbThemeData] from the widget tree.
  /// Falls back to [NbThemeData.light()] if no [NbTheme] ancestor is found.
  static NbThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<NbTheme>();
    return theme?.data ?? NbThemeData.light();
  }

  /// Returns null if no [NbTheme] ancestor is found.
  static NbThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NbTheme>()?.data;
  }

  @override
  bool updateShouldNotify(NbTheme old) => data != old.data;
}

/// Convenience extensions on [BuildContext] for quick theme access.
extension NbThemeExtension on BuildContext {
  /// The nearest [NbThemeData].
  NbThemeData get nbTheme => NbTheme.of(this);

  /// The nearest [NbColorScheme].
  NbColorScheme get nbColors => NbTheme.of(this).colorScheme;

  /// The nearest [NbTypography].
  NbTypography get nbType => NbTheme.of(this).typography;
}
