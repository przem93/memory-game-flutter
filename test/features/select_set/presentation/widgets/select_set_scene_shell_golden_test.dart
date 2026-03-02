import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_scene_shell.dart';

void main() {
  testWidgets('SelectSetSceneShell renders phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SelectSetSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectSetSceneShell),
      matchesGoldenFile('select_set_scene_shell_phone.png'),
    );
  });

  testWidgets('SelectSetSceneShell renders tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SelectSetSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SelectSetSceneShell),
      matchesGoldenFile('select_set_scene_shell_tablet.png'),
    );
  });
}
