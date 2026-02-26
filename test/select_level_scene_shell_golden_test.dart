import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_scene_shell.dart';

void main() {
  testWidgets('SelectLevelSceneShell renders phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SelectLevelSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectLevelSceneShell),
      matchesGoldenFile('select_level_scene_shell_phone.png'),
    );
  });

  testWidgets('SelectLevelSceneShell renders tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SelectLevelSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectLevelSceneShell),
      matchesGoldenFile('select_level_scene_shell_tablet.png'),
    );
  });
}
