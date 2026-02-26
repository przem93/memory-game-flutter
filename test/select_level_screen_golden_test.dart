import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/select_level_screen.dart';

void main() {
  testWidgets('SelectLevelScreen renders locked phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: SelectLevelScreen()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectLevelScreen),
      matchesGoldenFile('select_level_screen_phone.png'),
    );
  });

  testWidgets('SelectLevelScreen renders locked tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: SelectLevelScreen()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectLevelScreen),
      matchesGoldenFile('select_level_screen_tablet.png'),
    );
  });
}
