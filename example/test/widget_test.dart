import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('NbShowcaseApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NbShowcaseApp());
    expect(find.text('Good Morning 👋'), findsOneWidget);
  });
}
