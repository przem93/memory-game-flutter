import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/non_main_scene_shell.dart';

/// Shared scene shell for Select Level that reuses background and brand footer.
class SelectLevelSceneShell extends StatelessWidget {
  const SelectLevelSceneShell({
    super.key,
    this.child,
    this.semanticsLabel = 'Select level screen',
  });

  static const screenKey = ValueKey<String>('selectLevelSceneShell');

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
