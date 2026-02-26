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
  static const _phoneOptionsTop = 371.0;
  static const _phoneHorizontalMargin = 20.0;
  static const _tabletHorizontalInset = 48.0;
  static const _tabletOptionsMaxWidth = 560.0;

  static const _logoWidth = 287.0;
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
          final verticalScale =
              (constraints.maxHeight / _phoneReferenceSize.height).clamp(
                0.9,
                1.3,
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  key: SelectLevelScreen.logoSlotKey,
                  top: _phoneLogoTop * verticalScale,
                  left: _phoneHorizontalMargin,
                  child: _TopLogoRow(isTablet: isTablet),
                ),
                Positioned(
                  key: SelectLevelScreen.titleSlotKey,
                  top: _phoneTitleTop * verticalScale,
                  left: 0,
                  right: 0,
                  child: const Center(child: SelectLevelTitle()),
                ),
                Positioned(
                  key: SelectLevelScreen.optionsSlotKey,
                  top: _phoneOptionsTop * verticalScale,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: optionsWidth,
                      child: SelectLevelOptionsSection(
                        selectedDifficulty: _selectedDifficulty,
                        onDifficultyChanged: _onDifficultyChanged,
                      ),
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

class _TopLogoRow extends StatelessWidget {
  const _TopLogoRow({required this.isTablet});

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final factor = isTablet ? 1.2 : 1.0;

    return SizedBox(
      width: _SelectLevelScreenState._logoWidth * factor,
      height: _SelectLevelScreenState._logoHeight * factor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _SelectLevelScreenState._logoIconSize * factor,
            height: _SelectLevelScreenState._logoIconSize * factor,
            child: Image.asset('assets/logo-icon.png', fit: BoxFit.contain),
          ),
          SizedBox(width: _SelectLevelScreenState._logoSpacing * factor),
          SizedBox(
            height: _SelectLevelScreenState._logoTextHeight * factor,
            child: Image.asset('assets/logo-text.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
