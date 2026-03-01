import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/customize_screen.dart';

void main() {
  Future<void> pumpGoldenCustomizeScreen(
    WidgetTester tester, {
    required Size canvas,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: CustomizeScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('CustomizeScreen matches phone reference baseline', (
    WidgetTester tester,
  ) async {
    await pumpGoldenCustomizeScreen(tester, canvas: const Size(393, 852));

    await expectLater(
      find.byType(CustomizeScreen),
      matchesGoldenFile('customize_screen_phone.png'),
    );
  });

  testWidgets('CustomizeScreen matches tablet reference baseline', (
    WidgetTester tester,
  ) async {
    await pumpGoldenCustomizeScreen(tester, canvas: const Size(1024, 1366));

    await expectLater(
      find.byType(CustomizeScreen),
      matchesGoldenFile('customize_screen_tablet.png'),
    );
  });
}
