import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_options_section.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_scene_shell.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_title.dart';
import 'package:memory_game/shared/layout/non_main_flow_layout.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

class SelectLevelScreen extends StatefulWidget {
  const SelectLevelScreen({
    super.key,
    this.onStartRequested,
    this.semanticsLabel = 'Select level screen',
  });

  static const contentKey = ValueKey<String>('selectLevelScreenContent');
  static const logoSlotKey = ValueKey<String>('selectLevelScreenLogoSlot');
  static const titleSlotKey = ValueKey<String>('selectLevelScreenTitleSlot');
  static const optionsSlotKey = ValueKey<String>('selectLevelScreenOptionsSlot');

  final ValueChanged<SelectLevelStartConfig>? onStartRequested;
  final String semanticsLabel;

  @override
  State<SelectLevelScreen> createState() => _SelectLevelScreenState();
}

class _SelectLevelScreenState extends State<SelectLevelScreen> {
  static const _phoneTitleTop = 330.0;
  static const _phoneTitleToFirstButtonGap = 41.0;
  static const _tabletOptionsMaxWidth = 560.0;

  static const _logoHeight = 60.0;
  SelectLevelDifficulty _selectedDifficulty = SelectLevelDifficulty.simple;

  @override
  Widget build(BuildContext context) {
    return SelectLevelSceneShell(
      semanticsLabel: widget.semanticsLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = NonMainFlowLayout.isTabletWidth(constraints.maxWidth);
          final viewPadding = MediaQuery.viewPaddingOf(context);
          final normalizedHeight = (constraints.maxHeight +
                  viewPadding.top +
                  viewPadding.bottom)
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
          final logoToTitleSpacing = NonMainFlowLayout.scaledOffset(
            _phoneTitleTop - NonMainFlowLayout.phoneTopLogoOffset - _logoHeight,
            normalizedHeight,
          );
          final titleToOptionsSpacing = NonMainFlowLayout.scaledOffset(
            _phoneTitleToFirstButtonGap,
            normalizedHeight,
          );
          final optionsWidth = isTablet
              ? math.min(
                  _tabletOptionsMaxWidth,
                  constraints.maxWidth - (NonMainFlowLayout.tabletHorizontalInset * 2),
                )
              : constraints.maxWidth - (NonMainFlowLayout.phoneHorizontalMargin * 2);

          return Semantics(
            key: SelectLevelScreen.contentKey,
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: logoTopSpacing),
                SizedBox(
                  key: SelectLevelScreen.logoSlotKey,
                  width: double.infinity,
                  child: ScreenLogoRow(isTablet: isTablet),
                ),
                SizedBox(height: logoToTitleSpacing),
                SizedBox(
                  key: SelectLevelScreen.titleSlotKey,
                  width: double.infinity,
                  child: const SelectLevelTitle(),
                ),
                SizedBox(height: titleToOptionsSpacing),
                Container(
                  key: SelectLevelScreen.optionsSlotKey,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: optionsWidth,
                    child: SelectLevelOptionsSection(
                      selectedDifficulty: _selectedDifficulty,
                      onDifficultyChanged: _onDifficultyChanged,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDifficultyChanged(SelectLevelDifficulty difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });

    final startConfig = resolveSelectLevelStartConfig(difficulty);
    widget.onStartRequested?.call(startConfig);
  }

}
