import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_scene_shell.dart';

void main() {
  testWidgets('GameSceneShell renders phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: GameSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(GameSceneShell),
      matchesGoldenFile('game_scene_shell_phone.png'),
    );
  });

  testWidgets('GameSceneShell renders tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: GameSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(GameSceneShell),
      matchesGoldenFile('game_scene_shell_tablet.png'),
    );
  });
}
