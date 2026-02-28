import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/non_main_scene_shell.dart';

/// Shared scene shell for gameplay that reuses background and brand footer.
class GameSceneShell extends StatelessWidget {
  const GameSceneShell({
    super.key,
    this.child,
    this.semanticsLabel = 'Game screen',
  });

  static const screenKey = ValueKey<String>('gameSceneShell');

  final Widget? child;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return NonMainSceneShell(
      screenKey: screenKey,
      semanticsLabel: semanticsLabel,
      child: child,
    );
  }
}
