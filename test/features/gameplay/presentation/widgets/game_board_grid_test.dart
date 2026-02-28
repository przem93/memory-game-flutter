import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_board_grid.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
    await tester.pumpAndSettle();
  }

  List<GameBoardGridCardData> buildCards(int count) {
    return List.generate(
      count,
      (index) => GameBoardGridCardData(
        id: 'card-$index',
        state: GameCardShellState.hidden,
      ),
    );
  }

  testWidgets('renders expected card count for all roadmap difficulties', (
    tester,
  ) async {
    Future<void> expectConfig({
      required int rows,
      required int columns,
    }) async {
      final cards = buildCards(rows * columns);

      await pumpHarness(
        tester,
        child: Center(
          child: SizedBox(
            width: 335,
            child: GameBoardGrid(rows: rows, columns: columns, cards: cards),
          ),
        ),
      );

      for (final card in cards) {
        expect(find.byKey(GameBoardGrid.cardShellKeyFor(card.id)), findsOneWidget);
      }
    }

    await expectConfig(rows: 3, columns: 4);
    await expectConfig(rows: 4, columns: 4);
    await expectConfig(rows: 4, columns: 5);
  });

  testWidgets('uses locked spacing and fixed-ratio card layout from constraints', (
    tester,
  ) async {
    final cards = buildCards(16);

    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 335,
          child: GameBoardGrid(rows: 4, columns: 4, cards: cards),
        ),
      ),
    );

    final first = find.byKey(GameBoardGrid.cardShellKeyFor('card-0'));
    final second = find.byKey(GameBoardGrid.cardShellKeyFor('card-1'));
    final fifth = find.byKey(GameBoardGrid.cardShellKeyFor('card-4'));

    final firstSize = tester.getSize(first);
    final firstTopLeft = tester.getTopLeft(first);
    final secondTopLeft = tester.getTopLeft(second);
    final fifthTopLeft = tester.getTopLeft(fifth);
    final boardSize = tester.getSize(find.byKey(GameBoardGrid.gridKey));

    expect(
      firstSize.width / firstSize.height,
      closeTo(GameBoardGrid.cardAspectRatio, 0.0001),
    );
    expect(
      secondTopLeft.dx - firstTopLeft.dx,
      closeTo(firstSize.width + 10, 0.0001),
    );
    expect(
      fifthTopLeft.dy - firstTopLeft.dy,
      closeTo(firstSize.height + 10, 0.0001),
    );
    expect(boardSize.width, 335);
  });

  testWidgets('calls onCardTap only when interaction is enabled', (tester) async {
    final cards = buildCards(12);
    var tappedId = '';

    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 335,
          child: GameBoardGrid(
            rows: 3,
            columns: 4,
            cards: cards,
            onCardTap: (cardId) => tappedId = cardId,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor('card-0')));
    await tester.pump();

    expect(tappedId, 'card-0');

    tappedId = '';
    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 335,
          child: GameBoardGrid(
            rows: 3,
            columns: 4,
            cards: cards,
            onCardTap: (cardId) => tappedId = cardId,
            isInteractionEnabled: false,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor('card-0')));
    await tester.pump();
    expect(tappedId, isEmpty);
  });

  testWidgets('exposes board and card semantics contract', (tester) async {
    final cards = buildCards(12);

    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 335,
          child: GameBoardGrid(
            rows: 3,
            columns: 4,
            cards: cards,
            onCardTap: (_) {},
          ),
        ),
      ),
    );

    final boardNode = tester.getSemantics(find.byKey(GameBoardGrid.boardSemanticsKey));
    expect(
      boardNode,
      matchesSemantics(
        label: 'Game board 3x4 with 12 cards',
      ),
    );

    final firstCardNode = tester.getSemantics(
      find.byKey(GameBoardGrid.cardShellKeyFor('card-0')),
    );
    expect(firstCardNode.label, 'Card 1 of 12 hidden');
    expect(firstCardNode.hasFlag(SemanticsFlag.hasEnabledState), isTrue);
    expect(firstCardNode.hasFlag(SemanticsFlag.isEnabled), isTrue);
    expect(firstCardNode.hasFlag(SemanticsFlag.isButton), isTrue);
  });
}
