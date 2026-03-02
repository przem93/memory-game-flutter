import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_game/features/select_set/domain/select_set_catalog.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_options_section.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_scene_shell.dart';
import 'package:memory_game/shared/layout/non_main_flow_layout.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

/// Select Set screen for choosing the card icon set.
class SelectSetScreen extends StatelessWidget {
  const SelectSetScreen({
    super.key,
    this.initialSelectedSetKey,
    required this.onSetSelected,
    this.semanticsLabel = 'Select set screen',
  });

  static const contentKey = ValueKey<String>('selectSetScreenContent');
  static const logoSlotKey = ValueKey<String>('selectSetScreenLogoSlot');
  static const titleSlotKey = ValueKey<String>('selectSetScreenTitleSlot');
  static const optionsSlotKey = ValueKey<String>('selectSetScreenOptionsSlot');

  final String? initialSelectedSetKey;
  final ValueChanged<String> onSetSelected;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SelectSetSceneShell(
      semanticsLabel: semanticsLabel,
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
            _phoneTitleTop -
                NonMainFlowLayout.phoneTopLogoOffset -
                _logoHeight,
            normalizedHeight,
          ).clamp(0.0, _maxLogoToTitleSpacing);
          final titleToOptionsSpacing = NonMainFlowLayout.scaledOffset(
            _phoneTitleToFirstButtonGap,
            normalizedHeight,
          );
          final optionsWidth = isTablet
              ? math.min(
                  _tabletOptionsMaxWidth,
                  constraints.maxWidth -
                      (NonMainFlowLayout.tabletHorizontalInset * 2),
                )
              : constraints.maxWidth -
                  (NonMainFlowLayout.phoneHorizontalMargin * 2);

          return Semantics(
            key: SelectSetScreen.contentKey,
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: logoTopSpacing),
                SizedBox(
                  key: SelectSetScreen.logoSlotKey,
                  width: double.infinity,
                  child: ScreenLogoRow(isTablet: isTablet),
                ),
                SizedBox(height: logoToTitleSpacing),
                SizedBox(
                  key: SelectSetScreen.titleSlotKey,
                  width: double.infinity,
                  child: const _SelectSetTitle(),
                ),
                SizedBox(height: titleToOptionsSpacing),
                Container(
                  key: SelectSetScreen.optionsSlotKey,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: optionsWidth,
                    child: SelectSetOptionsSection(
                      availableSets: lockedSetCatalog,
                      onSetSelected: (setKey) {
                        onSetSelected(setKey);
                        Navigator.of(context).pop();
                      },
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
}

class _SelectSetTitle extends StatelessWidget {
  const _SelectSetTitle();

  static const _height = 37.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        'Select set',
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: const TextStyle(
          fontFamily: 'DynaPuff',
          fontWeight: FontWeight.w700,
          fontSize: _height,
          height: 1,
          letterSpacing: 0,
          color: Color(0xFFFFFFFF),
          shadows: [
            Shadow(
              color: Color(0x66000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
            Shadow(
              color: Color(0xFF1F4134),
              blurRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

const _phoneTitleTop = 290.5;
const _phoneTitleToFirstButtonGap = 11.0;
const _logoHeight = 60.0;
const _maxLogoToTitleSpacing = 120.0;
const _tabletOptionsMaxWidth = 560.0;
