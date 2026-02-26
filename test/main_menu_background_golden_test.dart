import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';

void main() {
  testWidgets('MainMenuBackground renders locked phone baseline',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MainMenuBackground(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MainMenuBackground),
      matchesGoldenFile('main_menu_background_phone.png'),
    );
  });
}
