import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

void main() {
  group('GameIconSetProvider', () {
    final provider = GameIconSetProvider();

    Map<String, int> countsByIdentity(List<GameIconIdentity> icons) {
      final counts = <String, int>{};
      for (final icon in icons) {
        counts.update(icon.id, (value) => value + 1, ifAbsent: () => 1);
      }
      return counts;
    }

    List<String> signature(List<GameIconIdentity> icons) {
      return icons.map((icon) => '${icon.id}|${icon.assetPath}').toList();
    }

    test('draws exact unique identities and duplicates each icon into a pair', () {
      const pairCount = 8;
      final result = provider.generateForPairCount(pairCount, seed: 42);

      expect(result.length, pairCount * 2);

      final counts = countsByIdentity(result);
      expect(counts.length, pairCount);
      for (final entry in counts.entries) {
        expect(entry.value, 2);
      }
    });

    test('is deterministic for same seed', () {
      final first = provider.generateForPairCount(10, seed: 99);
      final second = provider.generateForPairCount(10, seed: 99);

      expect(signature(first), signature(second));
    });

    test('returns different permutation for different seeds', () {
      final first = provider.generateForPairCount(10, seed: 1);
      final second = provider.generateForPairCount(10, seed: 2);

      expect(signature(first), isNot(signature(second)));
    });

    test('throws explicit insufficientIconPool failure when pool is too small', () {
      final tinyPoolProvider = GameIconSetProvider(
        availableIconAssets: <String>[
          'assets/sets/food-set/apple-svgrepo-com.svg',
          'assets/sets/food-set/banana-svgrepo-com.svg',
        ],
      );

      expect(
        () => tinyPoolProvider.generateForPairCount(3, seed: 7),
        throwsA(
          isA<GameIconSetProviderException>()
              .having((e) => e.failure, 'failure', GameIconSetProviderFailure.insufficientIconPool)
              .having((e) => e.requestedPairCount, 'requestedPairCount', 3)
              .having((e) => e.availableIconCount, 'availableIconCount', 2),
        ),
      );
    });

    test('supports roadmap difficulty pair counts via start config', () {
      const configs = <SelectLevelStartConfig>[
        SelectLevelStartConfig(
          difficulty: SelectLevelDifficulty.simple,
          rows: 3,
          columns: 4,
        ),
        SelectLevelStartConfig(
          difficulty: SelectLevelDifficulty.medium,
          rows: 4,
          columns: 4,
        ),
        SelectLevelStartConfig(
          difficulty: SelectLevelDifficulty.hard,
          rows: 4,
          columns: 5,
        ),
      ];

      for (final config in configs) {
        final result = provider.generateForStartConfig(config, seed: 50);
        expect(result.length, config.pairCount * 2);
      }
    });

    test('supports difficulty adapter input', () {
      final simpleResult = provider.generateForDifficulty(
        SelectLevelDifficulty.simple,
        seed: 9,
      );
      final mediumResult = provider.generateForDifficulty(
        SelectLevelDifficulty.medium,
        seed: 9,
      );
      final hardResult = provider.generateForDifficulty(
        SelectLevelDifficulty.hard,
        seed: 9,
      );

      expect(simpleResult.length, 12);
      expect(mediumResult.length, 16);
      expect(hardResult.length, 20);
    });
  });
}
