import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/success/presentation/success_screen.dart';

void main() {
  const goldenPrefix = '../../../goldens';
  const startConfig = SelectLevelStartConfig(
    difficulty: SelectLevelDifficulty.simple,
    rows: 3,
    columns: 4,
  );

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
        home: const SuccessScreen(
          elapsed: Duration(minutes: 4, seconds: 21),
          startConfig: startConfig,
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
        find.byType(SuccessScreen),
        matchesGoldenFile(goldenPath),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('SuccessScreen goldens: iOS + Android (phone + tablet)',
      (WidgetTester tester) async {
    const phoneSize = Size(393, 852);
    const tabletSize = Size(834, 1194);

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/ios/success_screen_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/android/success_screen_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/ios/success_screen_tablet.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/android/success_screen_tablet.png',
    );
  });
}
