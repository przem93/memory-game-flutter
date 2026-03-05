import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import '../../../golden_sizes.dart' as golden_sizes;

void main() {
  const goldenBaseName = 'game_screen_stage5';
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

  testWidgets('GameScreen Stage 5 goldens: iOS + Android (popular sizes)',
      (WidgetTester tester) async {
    for (final entry in golden_sizes.goldenPhoneSizes.entries) {
      await runOnPlatform(
        tester,
        platform: TargetPlatform.iOS,
        physicalSize: entry.value,
        goldenPath: '$goldenPrefix/ios/${goldenBaseName}_${entry.key}.png',
      );
      await runOnPlatform(
        tester,
        platform: TargetPlatform.android,
        physicalSize: entry.value,
        goldenPath: '$goldenPrefix/android/${goldenBaseName}_${entry.key}.png',
      );
    }
    for (final entry in golden_sizes.goldenTabletSizes.entries) {
      await runOnPlatform(
        tester,
        platform: TargetPlatform.iOS,
        physicalSize: entry.value,
        goldenPath: '$goldenPrefix/ios/${goldenBaseName}_${entry.key}.png',
      );
      await runOnPlatform(
        tester,
        platform: TargetPlatform.android,
        physicalSize: entry.value,
        goldenPath: '$goldenPrefix/android/${goldenBaseName}_${entry.key}.png',
      );
    }
  });
}
