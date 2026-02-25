import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('SplashScreen matches step 2.2 golden',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(showDeveloperBrand: false),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_screen_step_2_2.png'),
    );
  });

  testWidgets('SplashScreen with DeveloperBrand matches 852px height golden',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(showDeveloperBrand: true),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_screen_step_2_3_h852.png'),
    );
  });

  testWidgets('SplashScreen with DeveloperBrand matches 740px height golden',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 740);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(showDeveloperBrand: true),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_screen_step_2_3_h740.png'),
    );
  });
}
