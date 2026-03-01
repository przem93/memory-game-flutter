import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/success/presentation/widgets/success_scene_shell.dart';

void main() {
  testWidgets('SuccessSceneShell renders phone baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SuccessSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SuccessSceneShell),
      matchesGoldenFile('success_scene_shell_phone.png'),
    );
  });

  testWidgets('SuccessSceneShell renders tablet baseline', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1366);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SuccessSceneShell(child: SizedBox.expand())),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SuccessSceneShell),
      matchesGoldenFile('success_scene_shell_tablet.png'),
    );
  });
}
