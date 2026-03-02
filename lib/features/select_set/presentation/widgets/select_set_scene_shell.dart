import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/non_main_scene_shell.dart';

/// Shared scene shell for Select Set that reuses background and brand footer.
class SelectSetSceneShell extends StatelessWidget {
  const SelectSetSceneShell({
    super.key,
    this.child,
    this.semanticsLabel = 'Select set screen',
  });

  static const screenKey = ValueKey<String>('selectSetSceneShell');

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
