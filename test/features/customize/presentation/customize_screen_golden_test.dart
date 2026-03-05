import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/customize_screen.dart';

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
        home: const CustomizeScreen(),
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
        find.byType(CustomizeScreen),
        matchesGoldenFile(goldenPath),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('CustomizeScreen goldens: iOS + Android (phone + tablet)',
      (WidgetTester tester) async {
    const phoneSize = Size(393, 852);
    const tabletSize = Size(834, 1194);

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/ios/customize_screen_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/android/customize_screen_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/ios/customize_screen_tablet.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/android/customize_screen_tablet.png',
    );
  });
}
