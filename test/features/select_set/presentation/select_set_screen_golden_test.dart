import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_set/presentation/select_set_screen.dart';

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
        home: SelectSetScreen(
          initialSelectedSetKey: 'food-set',
          onSetSelected: (_) {},
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
        find.byType(SelectSetScreen),
        matchesGoldenFile(goldenPath),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('SelectSetScreen goldens: iOS + Android (phone + tablet)',
      (WidgetTester tester) async {
    const phoneSize = Size(393, 852);
    const tabletSize = Size(834, 1194);

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/ios/select_set_screen_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: phoneSize,
      goldenPath: '$goldenPrefix/android/select_set_screen_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/ios/select_set_screen_tablet.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: tabletSize,
      goldenPath: '$goldenPrefix/android/select_set_screen_tablet.png',
    );
  });
}
