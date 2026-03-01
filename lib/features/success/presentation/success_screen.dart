import 'package:flutter/material.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/success/presentation/widgets/success_action_buttons.dart';
import 'package:memory_game/features/success/presentation/widgets/success_result_panel.dart';
import 'package:memory_game/features/success/presentation/widgets/success_scene_shell.dart';
import 'package:memory_game/shared/layout/non_main_flow_layout.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

/// Stage 3 success composition screen built from reusable Success components.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    required this.elapsed,
    required this.startConfig,
    this.onPlayAgainTap,
    this.onCloseTap,
    this.semanticsLabel = 'Success screen',
    super.key,
  });

  static const contentKey = ValueKey<String>('successScreenContent');
  static const logoSlotKey = ValueKey<String>('successScreenLogoSlot');
  static const resultPanelSlotKey = ValueKey<String>(
    'successScreenResultPanelSlot',
  );
  static const actionsSlotKey = ValueKey<String>('successScreenActionsSlot');

  static const _phoneLogoHeight = 60.0;
  static const _phoneResultPanelTop = 267.0;
  static const _phoneActionsTop = 503.0;
  static const _phoneResultPanelHeight = 186.0;

  final Duration elapsed;
  final SelectLevelStartConfig startConfig;
  final VoidCallback? onPlayAgainTap;
  final VoidCallback? onCloseTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SuccessSceneShell(
      semanticsLabel: semanticsLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = NonMainFlowLayout.isTabletWidth(
            constraints.maxWidth,
          );
          final viewPadding = MediaQuery.viewPaddingOf(context);
          final normalizedHeight =
              (constraints.maxHeight + viewPadding.top + viewPadding.bottom)
                  .clamp(
                    NonMainFlowLayout.phoneReferenceHeight *
                        NonMainFlowLayout.topScaleMinFactor,
                    NonMainFlowLayout.phoneReferenceHeight *
                        NonMainFlowLayout.topScaleMaxFactor,
                  );
          final logoTopSpacing = NonMainFlowLayout.resolveTopLogoSpacing(
            safeAreaHeight: constraints.maxHeight,
            viewPadding: viewPadding,
          );
          final logoToPanelSpacing = NonMainFlowLayout.scaledOffset(
            _phoneResultPanelTop -
                NonMainFlowLayout.phoneTopLogoOffset -
                _phoneLogoHeight,
            normalizedHeight,
          ).clamp(0.0, double.infinity);
          final panelToActionsSpacing = NonMainFlowLayout.scaledOffset(
            _phoneActionsTop - _phoneResultPanelTop - _phoneResultPanelHeight,
            normalizedHeight,
          );

          return Semantics(
            key: contentKey,
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: logoTopSpacing),
                SizedBox(
                  key: logoSlotKey,
                  width: double.infinity,
                  child: ScreenLogoRow(isTablet: isTablet),
                ),
                SizedBox(height: logoToPanelSpacing),
                Container(
                  key: resultPanelSlotKey,
                  alignment: Alignment.center,
                  child: SuccessResultPanel(
                    elapsed: elapsed,
                    scalePreset: isTablet
                        ? SuccessResultPanelScalePreset.tablet
                        : SuccessResultPanelScalePreset.phone,
                  ),
                ),
                SizedBox(height: panelToActionsSpacing),
                Container(
                  key: actionsSlotKey,
                  alignment: Alignment.center,
                  child: SuccessActionButtons(
                    scalePreset: isTablet
                        ? SuccessActionButtonsScalePreset.tablet
                        : SuccessActionButtonsScalePreset.phone,
                    onPlayAgainTap:
                        onPlayAgainTap ?? () => _restartGame(context),
                    onCloseTap: onCloseTap ?? () => _closeToMainMenu(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _restartGame(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(startConfig: startConfig),
      ),
    );
  }

  void _closeToMainMenu(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainMenuScreen()),
      (route) => false,
    );
  }
}
