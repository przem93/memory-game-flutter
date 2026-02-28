import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';

void main() {
  Future<void> pumpGoldenHarness(
    WidgetTester tester, {
    required Size canvas,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(
          startConfig: SelectLevelStartConfig(
            difficulty: SelectLevelDifficulty.medium,
            rows: 4,
            columns: 4,
          ),
          seed: 42,
          elapsed: Duration(minutes: 3, seconds: 45),
          timerTick: Duration(days: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('GameScreen Stage 5 phone comparison baseline', (tester) async {
    await pumpGoldenHarness(tester, canvas: const Size(393, 852));

    await expectLater(
      find.byType(GameScreen),
      matchesGoldenFile('game_screen_stage5_phone.png'),
    );
  });

  testWidgets('GameScreen Stage 5 tablet comparison baseline', (tester) async {
    await pumpGoldenHarness(tester, canvas: const Size(1024, 1366));

    await expectLater(
      find.byType(GameScreen),
      matchesGoldenFile('game_screen_stage5_tablet.png'),
    );
  });
}
