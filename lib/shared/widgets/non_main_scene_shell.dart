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
    this.showDeveloperBrand = true,
    super.key,
  });

  final Key screenKey;
  final String semanticsLabel;
  final Widget? child;

  /// When false, the developer brand footer is not shown (e.g. on game screen).
  final bool showDeveloperBrand;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (child != null) Expanded(child: child!),
                    if (showDeveloperBrand)
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
