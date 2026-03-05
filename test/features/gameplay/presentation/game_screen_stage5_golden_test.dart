import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/customize_start_payload.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import '../../../golden_sizes.dart' as golden_sizes;

void main() {
  const goldenBaseName = 'game_screen_stage5';
  const goldenPrefix = '../../../goldens';

  /// All card counts available in Customize (Cards grid).
  const gameScreenCardCounts = [8, 10, 12, 14, 16, 18, 20, 22, 24];

  Future<void> pumpFor(
    WidgetTester tester, {
    required TargetPlatform platform,
    required Size physicalSize,
    required SelectLevelStartConfig startConfig,
    double devicePixelRatio = 1,
  }) async {
    tester.view.devicePixelRatio = devicePixelRatio;
    tester.view.physicalSize = physicalSize;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: platform),
        home: GameScreen(
          startConfig: startConfig,
          seed: 42,
          elapsed: const Duration(minutes: 3, seconds: 45),
          timerTick: const Duration(days: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> runOnPlatform(
    WidgetTester tester, {
    required TargetPlatform platform,
    required Size physicalSize,
    required SelectLevelStartConfig startConfig,
    required String goldenPath,
    double devicePixelRatio = 1,
  }) async {
    debugDefaultTargetPlatformOverride = platform;
    try {
      await pumpFor(
        tester,
        platform: platform,
        physicalSize: physicalSize,
        startConfig: startConfig,
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

  testWidgets('GameScreen Stage 5 goldens: all Customize card counts, iOS + Android (popular sizes)',
      (WidgetTester tester) async {
    for (final cardCount in gameScreenCardCounts) {
      final startConfig = resolveCustomizeStartPayload(
        cardCount,
        CustomizeStartPayload.defaultSetKey,
      ).toSelectLevelStartConfig();

      for (final entry in golden_sizes.goldenPhoneSizes.entries) {
        await runOnPlatform(
          tester,
          platform: TargetPlatform.iOS,
          physicalSize: entry.value,
          startConfig: startConfig,
          goldenPath: '$goldenPrefix/ios/${goldenBaseName}_${cardCount}_${entry.key}.png',
        );
        await runOnPlatform(
          tester,
          platform: TargetPlatform.android,
          physicalSize: entry.value,
          startConfig: startConfig,
          goldenPath: '$goldenPrefix/android/${goldenBaseName}_${cardCount}_${entry.key}.png',
        );
      }
      for (final entry in golden_sizes.goldenTabletSizes.entries) {
        await runOnPlatform(
          tester,
          platform: TargetPlatform.iOS,
          physicalSize: entry.value,
          startConfig: startConfig,
          goldenPath: '$goldenPrefix/ios/${goldenBaseName}_${cardCount}_${entry.key}.png',
        );
        await runOnPlatform(
          tester,
          platform: TargetPlatform.android,
          physicalSize: entry.value,
          startConfig: startConfig,
          goldenPath: '$goldenPrefix/android/${goldenBaseName}_${cardCount}_${entry.key}.png',
        );
      }
    }
  });
}
