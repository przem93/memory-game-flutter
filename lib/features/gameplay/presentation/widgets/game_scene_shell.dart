import 'package:flutter/material.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';

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
    return Scaffold(
      body: MainMenuBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;

              return Semantics(
                key: screenKey,
                container: true,
                label: semanticsLabel,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (child != null) child!,
                    MainMenuDeveloperBrand(
                      scalePreset: isTablet
                          ? MainMenuDeveloperBrandScalePreset.tablet
                          : MainMenuDeveloperBrandScalePreset.phone,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
