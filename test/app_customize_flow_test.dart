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

  testWidgets('supports all locked Customize card counts in app flow', (
    tester,
  ) async {
    const expected = <int, ({int rows, int columns, int pairCount})>{
      8: (rows: 2, columns: 4, pairCount: 4),
      10: (rows: 2, columns: 5, pairCount: 5),
      12: (rows: 3, columns: 4, pairCount: 6),
      14: (rows: 2, columns: 7, pairCount: 7),
      16: (rows: 4, columns: 4, pairCount: 8),
      18: (rows: 3, columns: 6, pairCount: 9),
      20: (rows: 4, columns: 5, pairCount: 10),
      22: (rows: 2, columns: 11, pairCount: 11),
      24: (rows: 4, columns: 6, pairCount: 12),
    };

    for (final entry in expected.entries) {
      await pumpApp(tester);

      await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(1)));
      await tester.pumpAndSettle();
      expect(find.byType(CustomizeScreen), findsOneWidget);

      await tester.tap(
        find.byKey(ValueKey<String>('customizeGridOptionsButton-${entry.key}')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsOneWidget);
      expect(find.byType(GameCardShell), findsNWidgets(entry.key));

      final gameScreen = tester.widget<GameScreen>(find.byType(GameScreen));
      expect(gameScreen.startConfig.rows, entry.value.rows);
      expect(gameScreen.startConfig.columns, entry.value.columns);
      expect(gameScreen.startConfig.pairCount, entry.value.pairCount);
    }
  });
}
