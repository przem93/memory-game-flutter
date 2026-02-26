import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';

void main() {
  testWidgets('MainMenuScreen renders locked phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MainMenuScreen),
      matchesGoldenFile('main_menu_screen_phone.png'),
    );
  });

  testWidgets('MainMenuScreen renders locked tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MainMenuScreen),
      matchesGoldenFile('main_menu_screen_tablet.png'),
    );
  });
}
