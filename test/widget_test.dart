// Basic smoke test for the Iqra app.
import 'package:flutter_test/flutter_test.dart';

import 'package:iqraa/main.dart';

void main() {
  testWidgets('app launches and shows onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const IqraApp());
    await tester.pumpAndSettle();

    // Onboarding is the first screen when onboarding has not been completed.
    expect(find.text('اقرأ'), findsWidgets);
  });
}
