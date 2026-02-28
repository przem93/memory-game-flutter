import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_scene_shell.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester, Size size) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: GameSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('reuses background and developer brand', (
    WidgetTester tester,
  ) async {
    await pumpShell(tester, const Size(393, 852));

    expect(find.byType(MainMenuBackground), findsOneWidget);
    expect(find.byType(MainMenuDeveloperBrand), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byKey(GameSceneShell.screenKey), findsOneWidget);
  });

  testWidgets('uses phone developer brand preset on phone width', (
    WidgetTester tester,
  ) async {
    await pumpShell(tester, const Size(393, 852));

    final brand = tester.widget<MainMenuDeveloperBrand>(
      find.byType(MainMenuDeveloperBrand),
    );
    expect(brand.scalePreset, MainMenuDeveloperBrandScalePreset.phone);
  });

  testWidgets('uses tablet developer brand preset on tablet width', (
    WidgetTester tester,
  ) async {
    await pumpShell(tester, const Size(1024, 1366));

    final brand = tester.widget<MainMenuDeveloperBrand>(
      find.byType(MainMenuDeveloperBrand),
    );
    expect(brand.scalePreset, MainMenuDeveloperBrandScalePreset.tablet);
  });
}
