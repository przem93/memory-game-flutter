import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_face_content.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';

@immutable
class GameBoardGridCardData {
  const GameBoardGridCardData({
    required this.id,
    required this.state,
    this.symbolAssetPath,
    this.semanticLabel,
  }) : assert(
         state == GameCardShellState.hidden ||
             (symbolAssetPath != null && symbolAssetPath != ''),
         'symbolAssetPath is required for revealed and matched states',
       );

  final String id;
  final GameCardShellState state;
  final String? symbolAssetPath;
  final String? semanticLabel;
}

/// Reusable responsive board grid with fixed-ratio cards.
class GameBoardGrid extends StatelessWidget {
  const GameBoardGrid({
    required this.rows,
    required this.columns,
    required this.cards,
    this.onCardTap,
    this.isInteractionEnabled = true,
    super.key,
  }) : assert(rows > 0, 'rows must be greater than zero'),
       assert(columns > 0, 'columns must be greater than zero'),
       assert(
         cards.length == rows * columns,
         'cards length must be equal to rows * columns',
       );

  static const gridKey = ValueKey<String>('gameBoardGrid');
  static const boardSemanticsKey = ValueKey<String>('gameBoardGridSemantics');
  static const cardAspectRatio = 76.25 / 114.5;
  static const gridSpacing = 10.0;
  static const cardShellPrefix = 'gameBoardGridCardShell-';

  final int rows;
  final int columns;
  final List<GameBoardGridCardData> cards;
  final ValueChanged<String>? onCardTap;
  final bool isInteractionEnabled;

  static ValueKey<String> cardShellKeyFor(String cardId) =>
      ValueKey<String>('$cardShellPrefix$cardId');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = _resolveBoardSize(constraints);
        final cardCount = rows * columns;

        return Semantics(
          key: boardSemanticsKey,
          container: true,
          label: 'Game board ${rows}x$columns with $cardCount cards',
          child: SizedBox(
            key: gridKey,
            width: boardSize.width,
            height: boardSize.height,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: gridSpacing,
                crossAxisSpacing: gridSpacing,
                childAspectRatio: cardAspectRatio,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                final onTap = isInteractionEnabled && onCardTap != null
                    ? () => onCardTap?.call(card.id)
                    : null;
                final semanticLabel =
                    card.semanticLabel ??
                    'Card ${index + 1} of ${cards.length} ${card.state.name}';

                return Semantics(
                  key: cardShellKeyFor(card.id),
                  button: true,
                  enabled: onTap != null,
                  label: semanticLabel,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: GameCardShell(
                      state: card.state,
                      semanticEnabled: false,
                      child: GameCardFaceContent(
                        state: card.state,
                        symbolAssetPath: card.symbolAssetPath,
                        semanticEnabled: false,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Size _resolveBoardSize(BoxConstraints constraints) {
    final horizontalGap = (columns - 1) * gridSpacing;
    final verticalGap = (rows - 1) * gridSpacing;
    final fallbackWidth = (columns * 76.25) + horizontalGap;

    final maxWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : fallbackWidth;
    final maxHeight = constraints.hasBoundedHeight
        ? constraints.maxHeight
        : double.infinity;

    final widthBasedCardWidth = math.max(0, (maxWidth - horizontalGap) / columns);
    final widthBasedCardHeight = widthBasedCardWidth / cardAspectRatio;
    final widthBasedBoardHeight = (rows * widthBasedCardHeight) + verticalGap;

    if (widthBasedBoardHeight <= maxHeight) {
      return Size(maxWidth, widthBasedBoardHeight);
    }

    final heightBasedCardHeight = math.max(0, (maxHeight - verticalGap) / rows);
    final heightBasedCardWidth = heightBasedCardHeight * cardAspectRatio;
    final heightBasedBoardWidth = (columns * heightBasedCardWidth) + horizontalGap;

    return Size(heightBasedBoardWidth, maxHeight);
  }
}
