import 'package:flutter/material.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_primary_button.dart';

enum SuccessActionButtonsScalePreset { phone, tablet }

/// Reusable action section for Success with `Play again` and `Close`.
class SuccessActionButtons extends StatelessWidget {
  const SuccessActionButtons({
    this.onPlayAgainTap,
    this.onCloseTap,
    this.playAgainEnabled = true,
    this.closeEnabled = true,
    this.scalePreset = SuccessActionButtonsScalePreset.phone,
    super.key,
  });

  static const sectionKey = ValueKey<String>('successActionButtonsSection');
  static const playAgainButtonKey = ValueKey<String>(
    'successActionButtonsPlayAgainButton',
  );
  static const closeButtonKey = ValueKey<String>('successActionButtonsCloseButton');

  static const _phoneButtonWidth = 335.0;
  static const _phoneButtonHeight = 56.0;
  static const _phoneFontSize = 32.0;
  static const _phoneButtonsGap = 10.0;

  final VoidCallback? onPlayAgainTap;
  final VoidCallback? onCloseTap;
  final bool playAgainEnabled;
  final bool closeEnabled;
  final SuccessActionButtonsScalePreset scalePreset;

  @override
  Widget build(BuildContext context) {
    final scale = scalePreset == SuccessActionButtonsScalePreset.tablet ? 1.2 : 1.0;

    return SizedBox(
      key: sectionKey,
      width: _phoneButtonWidth * scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            buttonKey: playAgainButtonKey,
            label: 'Play again',
            scale: scale,
            enabled: playAgainEnabled,
            onTap: onPlayAgainTap,
          ),
          SizedBox(height: _phoneButtonsGap * scale),
          _buildButton(
            buttonKey: closeButtonKey,
            label: 'Close',
            scale: scale,
            enabled: closeEnabled,
            onTap: onCloseTap,
          ),
        ],
      ),
    );
  }
  Widget _buildButton({
    required Key buttonKey,
    required String label,
    required double scale,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    final resolvedShadow = BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      offset: const Offset(0, 4),
      blurRadius: 2,
    );
    final pressedShadow = BoxShadow(
      color: Colors.black.withValues(alpha: 0.18),
      offset: const Offset(0, 4),
      blurRadius: 1.5,
    );

    return SizedBox(
      width: _phoneButtonWidth * scale,
      child: MainMenuPrimaryButton(
        customContainerKey: buttonKey,
        label: label,
        onPressed: onTap,
        enabled: enabled,
        uppercaseLabel: false,
        height: _phoneButtonHeight * scale,
        borderRadius: 10 * scale,
        padding: EdgeInsets.zero,
        fontFamily: 'DynaPuff',
        fontSize: _phoneFontSize * scale,
        excludeLabelSemanticsFromText: true,
        enabledFillColor: const Color(0xFFFFFFFF),
        pressedFillColor: const Color(0xFFF7F7F7),
        disabledFillColor: const Color(0xFFF1F1F1),
        enabledBorderColor: Colors.black,
        disabledBorderColor: Colors.black,
        enabledTextColor: const Color(0xFF214336),
        disabledTextColor: const Color(0x8C214336),
        enabledShadow: resolvedShadow,
        pressedShadow: pressedShadow,
        disabledShadow: resolvedShadow,
      ),
    );
  }
}
