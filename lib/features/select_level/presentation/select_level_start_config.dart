import 'package:flutter/foundation.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

/// Immutable gameplay start payload emitted by Select Level flow.
class SelectLevelStartConfig {
  const SelectLevelStartConfig({
    required this.difficulty,
    required this.rows,
    required this.columns,
  });

  final SelectLevelDifficulty difficulty;
  final int rows;
  final int columns;

  int get pairCount => (rows * columns) ~/ 2;

  static const SelectLevelStartConfig fallbackSimple = SelectLevelStartConfig(
    difficulty: SelectLevelDifficulty.simple,
    rows: 3,
    columns: 4,
  );
}

const _difficultyGridMapping = <SelectLevelDifficulty, ({int rows, int columns})>{
  SelectLevelDifficulty.simple: (rows: 3, columns: 4),
  SelectLevelDifficulty.medium: (rows: 4, columns: 4),
  SelectLevelDifficulty.hard: (rows: 4, columns: 5),
};

/// Resolves grid configuration for the selected difficulty.
SelectLevelStartConfig resolveSelectLevelStartConfig(
  SelectLevelDifficulty difficulty,
) {
  final grid = _difficultyGridMapping[difficulty];
  if (grid == null) {
    debugPrint(
      'SelectLevel: missing grid mapping for $difficulty. Falling back to simple.',
    );
    return SelectLevelStartConfig.fallbackSimple;
  }

  return SelectLevelStartConfig(
    difficulty: difficulty,
    rows: grid.rows,
    columns: grid.columns,
  );
}
