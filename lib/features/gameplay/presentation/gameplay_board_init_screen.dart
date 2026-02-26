import 'package:flutter/material.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';

/// Temporary board init destination for Select Level flow validation.
class GameplayBoardInitScreen extends StatelessWidget {
  const GameplayBoardInitScreen({required this.startConfig, super.key});

  static const configSemanticsKey = ValueKey<String>(
    'gameplayBoardInitConfigSemantics',
  );

  final SelectLevelStartConfig startConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gameplay')),
      body: Center(
        child: Semantics(
          key: configSemanticsKey,
          label:
              'gameplay config ${startConfig.difficulty.name} '
              '${startConfig.rows}x${startConfig.columns}',
          child: Text(
            '${startConfig.difficulty.name.toUpperCase()} '
            '${startConfig.rows}x${startConfig.columns} '
            'pairs:${startConfig.pairCount}',
          ),
        ),
      ),
    );
  }
}
