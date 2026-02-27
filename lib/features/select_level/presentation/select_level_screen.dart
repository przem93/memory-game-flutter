import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_options_section.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_scene_shell.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_title.dart';

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
  static const _phoneReferenceSize = Size(393, 852);
  static const _phoneLogoTop = 28.0;
  static const _phoneTitleTop = 330.0;
  static const _phoneTitleToFirstButtonGap = 41.0;
  static const _phoneHorizontalMargin = 20.0;
  static const _tabletHorizontalInset = 48.0;
  static const _tabletOptionsMaxWidth = 560.0;

  static const _logoHeight = 60.0;
  static const _logoIconSize = 60.0;
  static const _logoTextHeight = 49.0;
  static const _logoSpacing = 8.0;

  SelectLevelDifficulty _selectedDifficulty = SelectLevelDifficulty.simple;

  @override
  Widget build(BuildContext context) {
    return SelectLevelSceneShell(
      semanticsLabel: widget.semanticsLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final viewPadding = MediaQuery.viewPaddingOf(context);
          final fullViewportHeight =
              constraints.maxHeight + viewPadding.top + viewPadding.bottom;
          final normalizedHeight = fullViewportHeight.clamp(
            _phoneReferenceSize.height * 0.85,
            _phoneReferenceSize.height * 1.25,
          );
          final logoTopSpacing = math.max(
            0,
            _scaledOffset(_phoneLogoTop, normalizedHeight) - viewPadding.top,
          ).toDouble();
          final logoToTitleSpacing = _scaledOffset(
            _phoneTitleTop - _phoneLogoTop - _logoHeight,
            normalizedHeight,
          );
          final titleToOptionsSpacing = _scaledOffset(
            _phoneTitleToFirstButtonGap,
            normalizedHeight,
          );
          final optionsWidth = isTablet
              ? math.min(
                  _tabletOptionsMaxWidth,
                  constraints.maxWidth - (_tabletHorizontalInset * 2),
                )
              : constraints.maxWidth - (_phoneHorizontalMargin * 2);

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
                  child: _TopLogoRow(isTablet: isTablet),
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

  double _scaledOffset(double phoneOffset, double height) {
    return phoneOffset * (height / _phoneReferenceSize.height);
  }
}

class _TopLogoRow extends StatelessWidget {
  const _TopLogoRow({required this.isTablet});

  static const _phoneHorizontalMargin = 20.0;
  static const _tabletHorizontalInset = 48.0;

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? _tabletHorizontalInset : _phoneHorizontalMargin,
      ),
      child: Image.asset('assets/screen-logo.png', fit: BoxFit.contain),
    );
  }
}
