import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_board_grid.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_top_bar.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/success/presentation/success_screen.dart';

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

  List<String> currentBoardSignature(WidgetTester tester) {
    final board = tester.widget<GameBoardGrid>(find.byType(GameBoardGrid));
    return board.cards
        .map((card) => '${card.id}|${card.symbolAssetPath}')
        .toList(growable: false);
  }

  String currentTimerLabel(WidgetTester tester) {
    return tester.widget<Text>(find.byKey(GameTopBar.timerTextKey)).data ?? '';
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

  testWidgets(
    'routes completion to Success and replay starts fresh round for each difficulty',
    (WidgetTester tester) async {
      const scenarios = <({String label, int cardCount, SelectLevelDifficulty difficulty})>[
        (
          label: 'Simple',
          cardCount: 12,
          difficulty: SelectLevelDifficulty.simple,
        ),
        (
          label: 'Medium',
          cardCount: 16,
          difficulty: SelectLevelDifficulty.medium,
        ),
        (
          label: 'Hard',
          cardCount: 20,
          difficulty: SelectLevelDifficulty.hard,
        ),
      ];

      for (final scenario in scenarios) {
        await expectGameplayStartFromDifficulty(
          tester,
          difficultyLabel: scenario.label,
          expectedCardCount: scenario.cardCount,
        );
        final firstRoundBoardSignature = currentBoardSignature(tester);

        await tester.pump(const Duration(milliseconds: 1200));
        expect(currentTimerLabel(tester), isNot('00:00:00'));

        await completeCurrentBoard(tester);

        expect(find.byType(SuccessScreen), findsOneWidget);
        expect(find.text('Time elapsed:'), findsOneWidget);

        await tester.tap(find.text('Play again'));
        await tester.pumpAndSettle();

        expect(find.byType(GameScreen), findsOneWidget);
        expect(find.byType(GameCardShell), findsNWidgets(scenario.cardCount));

        final replayGameScreen = tester.widget<GameScreen>(
          find.byType(GameScreen),
        );
        expect(replayGameScreen.startConfig.difficulty, scenario.difficulty);
        expect(
          replayGameScreen.startConfig.rows * replayGameScreen.startConfig.columns,
          scenario.cardCount,
        );

        final replayBoardSignature = currentBoardSignature(tester);
        expect(replayBoardSignature, isNot(firstRoundBoardSignature));

        expect(currentTimerLabel(tester), '00:00:00');
        await tester.pump(const Duration(milliseconds: 1100));
        expect(currentTimerLabel(tester), isNot('00:00:00'));
      }
    },
  );

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
