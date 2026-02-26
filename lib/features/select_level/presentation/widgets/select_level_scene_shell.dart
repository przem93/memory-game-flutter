import 'package:flutter/material.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';

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
