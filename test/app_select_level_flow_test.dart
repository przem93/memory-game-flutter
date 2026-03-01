import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_board_grid.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';
import 'package:memory_game/features/success/presentation/success_screen.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MemoryGameApp());
    await tester.pumpAndSettle();
  }

  Future<void> openSelectLevel(WidgetTester tester) async {
    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(0)));
    await tester.pumpAndSettle();
  }

  Future<void> completeCurrentBoard(WidgetTester tester) async {
    final board = tester.widget<GameBoardGrid>(find.byType(GameBoardGrid));
    final grouped = <String, List<String>>{};
    for (final card in board.cards) {
      final symbol = card.symbolAssetPath!;
      grouped.putIfAbsent(symbol, () => <String>[]).add(card.id);
    }

    for (final pair in grouped.values) {
      await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(pair[0])));
      await tester.pump();
      await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(pair[1])));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> expectGameplayStartFromDifficulty(
    WidgetTester tester, {
    required String difficultyLabel,
    required int expectedCardCount,
  }) async {
    await pumpApp(tester);
    await openSelectLevel(tester);

    await tester.tap(find.text(difficultyLabel));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.byType(GameCardShell), findsNWidgets(expectedCardCount));
  }

  testWidgets('starts gameplay config for Simple', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Simple',
      expectedCardCount: 12,
    );
  });

  testWidgets('starts gameplay config for Medium', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Medium',
      expectedCardCount: 16,
    );
  });

  testWidgets('starts gameplay config for Hard', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Hard',
      expectedCardCount: 20,
    );
  });

  testWidgets('routes completion to Success and supports replay action', (
    WidgetTester tester,
  ) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Simple',
      expectedCardCount: 12,
    );

    await completeCurrentBoard(tester);

    expect(find.byType(SuccessScreen), findsOneWidget);
    expect(find.text('Time elapsed:'), findsOneWidget);

    await tester.tap(find.text('Play again'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.byType(GameCardShell), findsNWidgets(12));
  });

  testWidgets('routes success close action back to Main Menu', (
    WidgetTester tester,
  ) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Simple',
      expectedCardCount: 12,
    );

    await completeCurrentBoard(tester);
    expect(find.byType(SuccessScreen), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(MainMenuScreen), findsOneWidget);
    expect(find.byType(SuccessScreen), findsNothing);
    expect(find.byType(GameScreen), findsNothing);
  });
}
