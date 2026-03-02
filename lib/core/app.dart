import 'package:flutter/material.dart';
import 'package:memory_game/features/customize/presentation/customize_screen.dart';
import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/success/presentation/success_screen.dart';
import 'package:memory_game/shared/theme/app_theme.dart';

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: AppTheme.light(),
      home: Builder(builder: (context) => _buildMainMenu(context)),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return MainMenuScreen(
      onQuickPlayPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (selectLevelContext) => SelectLevelScreen(
              onStartRequested: (startConfig) =>
                  _openGameFlow(selectLevelContext, startConfig),
            ),
          ),
        );
      },
      onCustomizePressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (customizeContext) => CustomizeScreen(
              onStartRequested: (payload) => _openGameFlow(
                customizeContext,
                payload.toSelectLevelStartConfig(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openGameFlow(BuildContext context, SelectLevelStartConfig startConfig) {
    final iconSetProvider =
        GameIconSetProvider.forSetKey(startConfig.setKey);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (gameContext) => GameScreen(
          startConfig: startConfig,
          iconSetProvider: iconSetProvider,
          onCompleted: (elapsed) => _openSuccessFlow(
            gameContext,
            startConfig: startConfig,
            elapsed: elapsed,
          ),
        ),
      ),
    );
  }

  void _openSuccessFlow(
    BuildContext context, {
    required SelectLevelStartConfig startConfig,
    required Duration elapsed,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (successContext) => SuccessScreen(
          elapsed: elapsed,
          startConfig: startConfig,
          onPlayAgainTap: () => _openReplayRound(successContext, startConfig),
          onCloseTap: () => _closeToMainMenu(successContext),
        ),
      ),
    );
  }

  void _openReplayRound(
    BuildContext context,
    SelectLevelStartConfig startConfig,
  ) {
    final iconSetProvider =
        GameIconSetProvider.forSetKey(startConfig.setKey);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (gameContext) => GameScreen(
          startConfig: startConfig,
          iconSetProvider: iconSetProvider,
          onCompleted: (elapsed) => _openSuccessFlow(
            gameContext,
            startConfig: startConfig,
            elapsed: elapsed,
          ),
        ),
      ),
    );
  }

  void _closeToMainMenu(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (mainMenuContext) => _buildMainMenu(mainMenuContext),
      ),
      (route) => false,
    );
  }
}
