import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';

void main() {
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
        home: const Scaffold(
          body: MainMenuBackground(),
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
        find.byType(MainMenuBackground),
        matchesGoldenFile(goldenPath),
      );
    } finally {
      // KLUCZ: reset od razu, zanim test się skończy
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('MainMenuBackground goldens: iOS + Android (phone + tablet)',
      (WidgetTester tester) async {
    const phoneSize = Size(393, 852); // iPhone-like
    const tabletSize = Size(834, 1194); // iPad 11"

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: phoneSize,
      goldenPath: 'goldens/ios/main_menu_background_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: phoneSize,
      goldenPath: 'goldens/android/main_menu_background_phone.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.iOS,
      physicalSize: tabletSize,
      goldenPath: 'goldens/ios/main_menu_background_tablet.png',
    );

    await runOnPlatform(
      tester,
      platform: TargetPlatform.android,
      physicalSize: tabletSize,
      goldenPath: 'goldens/android/main_menu_background_tablet.png',
    );
  });
}