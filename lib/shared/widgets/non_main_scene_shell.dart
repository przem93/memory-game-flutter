import 'package:flutter/material.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';
import 'package:memory_game/shared/layout/non_main_flow_layout.dart';

/// Shared shell for all non-main screens with identical background/footer.
class NonMainSceneShell extends StatelessWidget {
  const NonMainSceneShell({
    required this.screenKey,
    required this.semanticsLabel,
    this.child,
    super.key,
  });

  final Key screenKey;
  final String semanticsLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenuBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = NonMainFlowLayout.isTabletWidth(constraints.maxWidth);

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
