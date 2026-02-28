import 'package:flutter/material.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_screen.dart';
import 'package:memory_game/shared/theme/app_theme.dart';

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: AppTheme.light(),
      home: Builder(
        builder: (context) => MainMenuScreen(
          onQuickPlayPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SelectLevelScreen(
                  onStartRequested: (startConfig) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => GameScreen(startConfig: startConfig),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          onCustomizePressed: () {
            debugPrint('Customize tapped');
          },
        ),
      ),
    );
  }
}
