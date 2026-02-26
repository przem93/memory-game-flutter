import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_logo_group.dart';

/// Full Main Menu composition built from reusable Stage 2 components.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({
    super.key,
    this.onQuickPlayPressed,
    this.onCustomizePressed,
    this.semanticsLabel = 'Main menu screen',
  });

  static const screenKey = ValueKey<String>('mainMenuScreen');
  static const logoSlotKey = ValueKey<String>('mainMenuScreenLogoSlot');
  static const actionsSlotKey = ValueKey<String>('mainMenuScreenActionsSlot');

  final VoidCallback? onQuickPlayPressed;
  final VoidCallback? onCustomizePressed;
  final String semanticsLabel;

  static const _phoneReferenceSize = Size(393, 852);
  static const _phoneHorizontalMargin = 20.0;
  static const _phoneLogoTop = 55.0;
  static const _phoneActionsTop = 471.0;
  static const _phoneActionGap = 12.0;
  static const _tabletActionMaxWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenuBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;
              final verticalScale =
                  (constraints.maxHeight / _phoneReferenceSize.height).clamp(
                    0.9,
                    1.3,
                  );
              final logoTop = _phoneLogoTop * verticalScale;
              final actionsTop = _phoneActionsTop * verticalScale;
              final actionsWidth = isTablet
                  ? math.min(
                      _tabletActionMaxWidth,
                      constraints.maxWidth - (_phoneHorizontalMargin * 2),
                    )
                  : constraints.maxWidth - (_phoneHorizontalMargin * 2);

              return Semantics(
                key: screenKey,
                container: true,
                label: semanticsLabel,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      key: logoSlotKey,
                      top: logoTop,
                      left: 0,
                      right: 0,
                      child: Semantics(
                        header: true,
                        label: 'Memory logo',
                        child: MainMenuLogoGroup(
                          spacing: 33,
                          scalePreset: isTablet
                              ? MainMenuLogoScalePreset.tablet
                              : MainMenuLogoScalePreset.phone,
                        ),
                      ),
                    ),
                    Positioned(
                      key: actionsSlotKey,
                      top: actionsTop,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: actionsWidth,
                          child: MainMenuActionSection(
                            buttonSpacing: _phoneActionGap,
                            semanticsLabel: 'Main menu primary actions',
                            actions: [
                              MainMenuActionItem(
                                label: 'Quick Play',
                                onPressed: onQuickPlayPressed,
                              ),
                              MainMenuActionItem(
                                label: 'Customize',
                                onPressed: onCustomizePressed,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
