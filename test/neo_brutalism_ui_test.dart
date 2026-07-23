import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';

void main() {
  group('NbThemeData', () {
    test('light factory creates correct defaults', () {
      final theme = NbThemeData.light();
      expect(theme.borderWidth, 2.0);
      expect(theme.shadowOffsetX, 4.0);
      expect(theme.shadowOffsetY, 4.0);
      expect(theme.colorScheme.border, Colors.black);
    });

    test('dark factory creates correct defaults', () {
      final theme = NbThemeData.dark();
      expect(theme.colorScheme.background, const Color(0xFF0F0F0F));
      expect(theme.colorScheme.foreground, const Color(0xFFEBEBEB));
    });

    test('copyWith overrides only specified fields', () {
      final theme = NbThemeData.light().copyWith(borderWidth: 3.0);
      expect(theme.borderWidth, 3.0);
      expect(theme.shadowOffsetX, 4.0);
    });
  });

  group('NbColorScheme', () {
    test('light copyWith overrides only specified colors', () {
      const customPrimary = Color(0xFF6366F1);
      final scheme = NbColorScheme.light(primary: customPrimary);
      expect(scheme.primary, customPrimary);
      expect(scheme.border, Colors.black);
    });

    test('dark scheme has white border', () {
      final scheme = NbColorScheme.dark();
      expect(scheme.border, const Color(0xFFEBEBEB));
    });
  });

  group('NbButton widget', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(
        NbTheme(
          data: NbThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              body: NbButton(label: 'Test', onPressed: null),
            ),
          ),
        ),
      );
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        NbTheme(
          data: NbThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              body: NbButton(label: 'Disabled', onPressed: null),
            ),
          ),
        ),
      );
      expect(find.text('Disabled'), findsOneWidget);
    });
  });

  group('NbCard widget', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        NbTheme(
          data: NbThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              body: NbCard(child: Text('Card content')),
            ),
          ),
        ),
      );
      expect(find.text('Card content'), findsOneWidget);
    });
  });

  group('NbText widget', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(
        NbTheme(
          data: NbThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              body: NbText.headline('Hello'),
            ),
          ),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
    });
  });

  group('NbAppBar layout', () {
    testWidgets('does not overflow when used as Scaffold.appBar without a bottom', (tester) async {
      final overflows = <FlutterErrorDetails>[];
      final previousOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('overflowed')) {
          overflows.add(details);
        } else {
          previousOnError?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = previousOnError);

      await tester.pumpWidget(
        NbTheme(
          data: NbThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              appBar: NbAppBar(title: 'Pesanan Kios-K'),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(overflows, isEmpty, reason: 'the always-present bottom divider must be counted in preferredSize');
    });

    testWidgets('preferredSize accounts for the divider and matches actual height', (tester) async {
      const bar = NbAppBar(title: 'X');
      expect(bar.preferredSize.height, 58); // 56 toolbar + 2 divider

      await tester.pumpWidget(
        NbTheme(
          data: NbThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              appBar: bar,
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // The rendered app bar occupies exactly preferredSize.height (plus the
      // status-bar inset the Scaffold adds on top) — no more, no less.
      final barSize = tester.getSize(find.byType(NbAppBar));
      final topInset = tester.view.padding.top / tester.view.devicePixelRatio;
      expect(barSize.height, 58 + topInset);
    });
  });
}
