import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/non_main_scene_shell.dart';

/// Shared scene shell for Success that reuses background and brand footer.
class SuccessSceneShell extends StatelessWidget {
  const SuccessSceneShell({
    super.key,
    this.child,
    this.semanticsLabel = 'Success screen',
  });

  static const screenKey = ValueKey<String>('successSceneShell');

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
