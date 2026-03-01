import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';
import 'package:memory_game/features/customize/presentation/customize_screen.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MemoryGameApp(key: UniqueKey()));
    await tester.pumpAndSettle();
  }

  testWidgets('opens Customize screen from Main Menu', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(1)));
    await tester.pumpAndSettle();

    expect(find.byType(CustomizeScreen), findsOneWidget);
    expect(find.text('Select set'), findsOneWidget);
    expect(find.text('Cards grid'), findsOneWidget);
  });

  testWidgets('starts game with selected Customize card count', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(1)));
    await tester.pumpAndSettle();
    expect(find.byType(CustomizeScreen), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('customizeGridOptionsButton-22')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.byType(GameCardShell), findsNWidgets(22));

    final gameScreen = tester.widget<GameScreen>(find.byType(GameScreen));
    expect(gameScreen.startConfig.rows, 2);
    expect(gameScreen.startConfig.columns, 11);
    expect(gameScreen.startConfig.pairCount, 11);
  });
}
