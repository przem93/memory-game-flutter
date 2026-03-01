import 'package:flutter/foundation.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

/// Immutable gameplay payload emitted by Customize flow.
class CustomizeStartPayload {
  const CustomizeStartPayload({
    required this.setKey,
    required this.cardCount,
    required this.rows,
    required this.columns,
  });

  static const String defaultSetKey = 'food-set';
  static const int fallbackCardCount = 16;

  final String setKey;
  final int cardCount;
  final int rows;
  final int columns;

  int get pairCount => cardCount ~/ 2;

  SelectLevelStartConfig toSelectLevelStartConfig() {
    // Gameplay currently uses SelectLevelStartConfig; map Customize payload
    // into the existing contract until set-aware start config is introduced.
    return SelectLevelStartConfig(
      difficulty: SelectLevelDifficulty.simple,
      rows: rows,
      columns: columns,
    );
  }
}

const _cardCountGridMapping = <int, ({int rows, int columns})>{
  8: (rows: 2, columns: 4),
  10: (rows: 2, columns: 5),
  12: (rows: 3, columns: 4),
  14: (rows: 2, columns: 7),
  16: (rows: 4, columns: 4),
  18: (rows: 3, columns: 6),
  20: (rows: 4, columns: 5),
  22: (rows: 2, columns: 11),
  24: (rows: 4, columns: 6),
};

/// Resolves locked Customize payload from a selected cards-grid value.
CustomizeStartPayload resolveCustomizeStartPayload(int cardCount) {
  final grid = _cardCountGridMapping[cardCount];
  if (grid == null) {
    final fallbackGrid =
        _cardCountGridMapping[CustomizeStartPayload.fallbackCardCount]!;
    debugPrint(
      'Customize: unsupported card count $cardCount. '
      'Falling back to ${CustomizeStartPayload.fallbackCardCount}.',
    );
    return CustomizeStartPayload(
      setKey: CustomizeStartPayload.defaultSetKey,
      cardCount: CustomizeStartPayload.fallbackCardCount,
      rows: fallbackGrid.rows,
      columns: fallbackGrid.columns,
    );
  }

  return CustomizeStartPayload(
    setKey: CustomizeStartPayload.defaultSetKey,
    cardCount: cardCount,
    rows: grid.rows,
    columns: grid.columns,
  );
}
