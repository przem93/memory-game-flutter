import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/success/presentation/success_screen.dart';

void main() {
  const startConfig = SelectLevelStartConfig(
    difficulty: SelectLevelDifficulty.simple,
    rows: 3,
    columns: 4,
  );

  Future<void> pumpGoldenSuccessScreen(
    WidgetTester tester, {
    required Size canvas,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: SuccessScreen(
          elapsed: Duration(minutes: 4, seconds: 21),
          startConfig: startConfig,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SuccessScreen matches phone reference baseline', (
    WidgetTester tester,
  ) async {
    await pumpGoldenSuccessScreen(tester, canvas: const Size(393, 852));

    await expectLater(
      find.byType(SuccessScreen),
      matchesGoldenFile('success_screen_phone.png'),
    );
  });

  testWidgets('SuccessScreen matches tablet reference baseline', (
    WidgetTester tester,
  ) async {
    await pumpGoldenSuccessScreen(tester, canvas: const Size(1024, 1366));

    await expectLater(
      find.byType(SuccessScreen),
      matchesGoldenFile('success_screen_tablet.png'),
    );
  });
}
