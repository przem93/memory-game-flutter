import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

void main() {
  const goldenPrefix = '../../../goldens';

  Future<void> pumpFor(
    WidgetTester tester, {
    required TargetPlatform platform,
    required Size physicalSize,
    double devicePixelRatio = 1,
  }) async {
    tester.view.devicePixelRatio = devicePixelRatio;
    tester.view.physicalSize = physicalSize;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: platform),
        home: const GameScreen(
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

  Future<void> runOnPlatform(
    WidgetTester tester, {
    required TargetPlatform platform,
    required Size physicalSize,
    required String goldenPath,
    double devicePixelRatio = 1,
  }) async {
    debugDefaultTargetPlatformOverride = platform;
    try {
      await pumpFor(
        tester,
        platform: platform,
        physicalSize: physicalSize,
        devicePixelRatio: devicePixelRatio,
      );

      await expectLater(
        find.byType(GameScreen),
        matchesGoldenFile(goldenPath),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('GameScreen Stage 5 goldens: iOS + Android (phone + tablet)',
      (WidgetTester tester) async {
    const phoneSize = Size(393, 852);
    const tabletSize = Size(834, 1194);

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/ios/game_screen_stage5_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/android/game_screen_stage5_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/ios/game_screen_stage5_tablet.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/android/game_screen_stage5_tablet.png',
    );
  });
}
