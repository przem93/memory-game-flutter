import 'dart:math';

import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

enum GameIconSetProviderFailure { insufficientIconPool }

class GameIconSetProviderException implements Exception {
  const GameIconSetProviderException({
    required this.failure,
    required this.requestedPairCount,
    required this.availableIconCount,
  });

  final GameIconSetProviderFailure failure;
  final int requestedPairCount;
  final int availableIconCount;

  @override
  String toString() {
    return 'GameIconSetProviderException('
        'failure: $failure, '
        'requestedPairCount: $requestedPairCount, '
        'availableIconCount: $availableIconCount'
        ')';
  }
}

class GameIconIdentity {
  const GameIconIdentity({
    required this.id,
    required this.assetPath,
  });

  final String id;
  final String assetPath;
}

/// Provides randomized icon pair identities for gameplay board initialization.
class GameIconSetProvider {
  GameIconSetProvider({
    List<String> availableIconAssets = _defaultFoodSetAssets,
  }) : _availableIconAssets = List.unmodifiable(availableIconAssets);

  static const List<String> _defaultFoodSetAssets = <String>[
    'assets/sets/food-set/apple-svgrepo-com.svg',
    'assets/sets/food-set/avocado-svgrepo-com.svg',
    'assets/sets/food-set/banana-svgrepo-com.svg',
    'assets/sets/food-set/boxing-svgrepo-com.svg',
    'assets/sets/food-set/cherry-svgrepo-com.svg',
    'assets/sets/food-set/coffee-svgrepo-com.svg',
    'assets/sets/food-set/fish-svgrepo-com.svg',
    'assets/sets/food-set/grape-svgrepo-com.svg',
    'assets/sets/food-set/kiwi-fruit-svgrepo-com.svg',
    'assets/sets/food-set/lemon-svgrepo-com.svg',
    'assets/sets/food-set/milk-svgrepo-com.svg',
    'assets/sets/food-set/peach-svgrepo-com.svg',
    'assets/sets/food-set/poached-eggs-svgrepo-com.svg',
    'assets/sets/food-set/soda-water-svgrepo-com.svg',
    'assets/sets/food-set/steak-svgrepo-com.svg',
    'assets/sets/food-set/watermelon-svgrepo-com.svg',
    'assets/sets/food-set/yogurt-svgrepo-com.svg',
  ];

  final List<String> _availableIconAssets;

  List<GameIconIdentity> generateForDifficulty(
    SelectLevelDifficulty difficulty, {
    int? seed,
  }) {
    final startConfig = resolveSelectLevelStartConfig(difficulty);
    return generateForStartConfig(startConfig, seed: seed);
  }

  List<GameIconIdentity> generateForStartConfig(
    SelectLevelStartConfig startConfig, {
    int? seed,
  }) {
    return generateForPairCount(startConfig.pairCount, seed: seed);
  }

  List<GameIconIdentity> generateForPairCount(
    int pairCount, {
    int? seed,
  }) {
    if (pairCount <= 0) {
      throw ArgumentError.value(pairCount, 'pairCount', 'must be greater than 0');
    }

    if (_availableIconAssets.length < pairCount) {
      throw GameIconSetProviderException(
        failure: GameIconSetProviderFailure.insufficientIconPool,
        requestedPairCount: pairCount,
        availableIconCount: _availableIconAssets.length,
      );
    }

    final random = seed == null ? Random() : Random(seed);
    final uniquePool = List<String>.from(_availableIconAssets)..shuffle(random);
    final selectedAssets = uniquePool.take(pairCount);
    final pairCards = <GameIconIdentity>[
      for (final assetPath in selectedAssets) ...[
        GameIconIdentity(
          id: _identityFromAssetPath(assetPath),
          assetPath: assetPath,
        ),
        GameIconIdentity(
          id: _identityFromAssetPath(assetPath),
          assetPath: assetPath,
        ),
      ],
    ]..shuffle(random);

    return List.unmodifiable(pairCards);
  }

  String _identityFromAssetPath(String assetPath) {
    const prefix = 'assets/sets/food-set/';
    const suffix = '.svg';

    var value = assetPath;
    if (value.startsWith(prefix)) {
      value = value.substring(prefix.length);
    }
    if (value.endsWith(suffix)) {
      value = value.substring(0, value.length - suffix.length);
    }
    return value;
  }
}
