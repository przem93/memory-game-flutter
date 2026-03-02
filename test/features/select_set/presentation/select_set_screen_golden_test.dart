import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_set/presentation/select_set_screen.dart';

void main() {
  testWidgets('SelectSetScreen renders locked phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SelectSetScreen(
          initialSelectedSetKey: 'food-set',
          onSetSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectSetScreen),
      matchesGoldenFile('select_set_screen_phone.png'),
    );
  });

  testWidgets('SelectSetScreen renders locked tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SelectSetScreen(
          initialSelectedSetKey: 'food-set',
          onSetSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectSetScreen),
      matchesGoldenFile('select_set_screen_tablet.png'),
    );
  });
}
