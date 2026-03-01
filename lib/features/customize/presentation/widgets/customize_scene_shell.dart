import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/non_main_scene_shell.dart';

/// Shared scene shell for Customize that reuses non-main background and footer.
class CustomizeSceneShell extends StatelessWidget {
  const CustomizeSceneShell({
    super.key,
    this.child,
    this.semanticsLabel = 'Customize screen',
  });

  static const screenKey = ValueKey<String>('customizeSceneShell');

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
