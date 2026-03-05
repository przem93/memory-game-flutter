import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';
import 'golden_sizes.dart' as golden_sizes;

void main() {
  const goldenBaseName = 'main_menu_developer_brand';
  const goldenPrefix = 'goldens';

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
        home: Scaffold(
          body: SizedBox(
            width: physicalSize.width,
            height: physicalSize.height,
            child: const MainMenuDeveloperBrand(),
          ),
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
        find.byType(MainMenuDeveloperBrand),
        matchesGoldenFile(goldenPath),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('MainMenuDeveloperBrand goldens: iOS + Android (phone)',
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
  });
}
