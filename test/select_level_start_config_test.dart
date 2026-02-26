import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

void main() {
  group('resolveSelectLevelStartConfig', () {
    test('maps simple difficulty to 3x4 board', () {
      final config = resolveSelectLevelStartConfig(SelectLevelDifficulty.simple);

      expect(config.difficulty, SelectLevelDifficulty.simple);
      expect(config.rows, 3);
      expect(config.columns, 4);
      expect(config.pairCount, 6);
    });

    test('maps medium difficulty to 4x4 board', () {
      final config = resolveSelectLevelStartConfig(SelectLevelDifficulty.medium);

      expect(config.difficulty, SelectLevelDifficulty.medium);
      expect(config.rows, 4);
      expect(config.columns, 4);
      expect(config.pairCount, 8);
    });

    test('maps hard difficulty to 4x5 board', () {
      final config = resolveSelectLevelStartConfig(SelectLevelDifficulty.hard);

      expect(config.difficulty, SelectLevelDifficulty.hard);
      expect(config.rows, 4);
      expect(config.columns, 5);
      expect(config.pairCount, 10);
    });

    test('defines fallback as simple mapping', () {
      const fallback = SelectLevelStartConfig.fallbackSimple;

      expect(fallback.difficulty, SelectLevelDifficulty.simple);
      expect(fallback.rows, 3);
      expect(fallback.columns, 4);
      expect(fallback.pairCount, 6);
    });
  });
}
