import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:memory_game/features/customize/presentation/customize_start_payload.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_grid_options_section.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_scene_shell.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_set_selector_field.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_primary_button.dart';
import 'package:memory_game/shared/layout/non_main_flow_layout.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

/// Stage 3 Customize composition screen.
class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({
    super.key,
    this.onStartRequested,
    this.semanticsLabel = 'Customize screen',
  });

  static const contentKey = ValueKey<String>('customizeScreenContent');
  static const logoSlotKey = ValueKey<String>('customizeScreenLogoSlot');
  static const selectSetTitleSlotKey = ValueKey<String>(
    'customizeScreenSelectSetTitleSlot',
  );
  static const setSelectorSlotKey = ValueKey<String>(
    'customizeScreenSetSelectorSlot',
  );
  static const cardsGridTitleSlotKey = ValueKey<String>(
    'customizeScreenCardsGridTitleSlot',
  );
  static const gridOptionsSlotKey = ValueKey<String>('customizeScreenGridSlot');
  static const closeButtonSlotKey = ValueKey<String>('customizeScreenCloseSlot');

  static const _phoneLogoHeight = 60.0;
  static const _phoneSelectSetTop = 165.0;
  static const _phoneSetSelectorTop = 213.5;
  static const _phoneCardsGridTop = 309.0;
  static const _phoneGridTop = 357.0;
  static const _gridToCloseButtonGap = 50.0;
  static const _maxGridWidth = 354.0;
  static const _phoneHorizontalMargin = 19.0;
  static const _tabletMaxContentWidth = 560.0;
  static const _setIconAsset = 'assets/sets/food-set/coffee-svgrepo-com.svg';

  final ValueChanged<CustomizeStartPayload>? onStartRequested;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return CustomizeSceneShell(
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
          final logoToSelectSetSpacing = NonMainFlowLayout.scaledOffset(
            _phoneSelectSetTop -
                NonMainFlowLayout.phoneTopLogoOffset -
                _phoneLogoHeight,
            normalizedHeight,
          ).clamp(0.0, double.infinity);
          final selectSetTitleToSelectorSpacing =
              NonMainFlowLayout.scaledOffset(
                _phoneSetSelectorTop - _phoneSelectSetTop - _sectionTitleHeight,
                normalizedHeight,
              ).clamp(0.0, double.infinity);
          final selectorToCardsGridTitleSpacing =
              NonMainFlowLayout.scaledOffset(
                _phoneCardsGridTop - _phoneSetSelectorTop - _selectorHeight,
                normalizedHeight,
              ).clamp(0.0, double.infinity);
          final cardsGridTitleToGridSpacing = NonMainFlowLayout.scaledOffset(
            _phoneGridTop - _phoneCardsGridTop - _sectionTitleHeight,
            normalizedHeight,
          ).clamp(0.0, double.infinity);
          final maxContentWidth = isTablet
              ? math.min(
                  _tabletMaxContentWidth,
                  constraints.maxWidth -
                      (NonMainFlowLayout.tabletHorizontalInset * 2),
                )
              : constraints.maxWidth - (_phoneHorizontalMargin * 2);
          final gridWidth = math.min(_maxGridWidth, maxContentWidth);

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
                SizedBox(height: logoToSelectSetSpacing),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MainMenuDeveloperBrand.requiredBottomSpace(
                        isTablet
                            ? MainMenuDeveloperBrandScalePreset.tablet
                            : MainMenuDeveloperBrandScalePreset.phone,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          key: selectSetTitleSlotKey,
                          child: const _CustomizeSectionTitle(text: 'Select set'),
                        ),
                        SizedBox(height: selectSetTitleToSelectorSpacing),
                        Container(
                          key: setSelectorSlotKey,
                          alignment: Alignment.center,
                          child: const CustomizeSetSelectorField(
                            label: 'Food',
                            leadingIconAsset: _setIconAsset,
                            onTap: _noopSetTap,
                          ),
                        ),
                        SizedBox(height: selectorToCardsGridTitleSpacing),
                        SizedBox(
                          key: cardsGridTitleSlotKey,
                          child: const _CustomizeSectionTitle(text: 'Cards grid'),
                        ),
                        SizedBox(height: cardsGridTitleToGridSpacing),
                        Container(
                          key: gridOptionsSlotKey,
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: gridWidth,
                            child: CustomizeGridOptionsSection(
                              availableCardCounts:
                                  CustomizeGridOptionsSection.buttonValues,
                              onCardCountSelected: (cardCount) =>
                                  _onCardCountSelected(context, cardCount),
                            ),
                          ),
                        ),
                        const SizedBox(height: _gridToCloseButtonGap),
                        Center(
                          key: closeButtonSlotKey,
                          child: SizedBox(
                            width: gridWidth,
                            child: MainMenuPrimaryButton(
                              label: 'Close',
                              onPressed: () => _onClosePressed(context),
                            ),
                          ),
                        ),
                      ],
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

  void _onClosePressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onCardCountSelected(BuildContext context, int cardCount) {
    final payload = resolveCustomizeStartPayload(cardCount);
    if (onStartRequested != null) {
      onStartRequested!(payload);
      return;
    }
  }

  static void _noopSetTap() {}
}

class _CustomizeSectionTitle extends StatelessWidget {
  const _CustomizeSectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: const TextStyle(
          fontFamily: 'DynaPuff',
          fontWeight: FontWeight.w700,
          fontSize: _sectionTitleHeight,
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

const _sectionTitleHeight = 37.0;
const _selectorHeight = 55.0;
