import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MainMenuDeveloperBrandScalePreset {
  phone,
  tablet,
}

extension on MainMenuDeveloperBrandScalePreset {
  double get sizeFactor => switch (this) {
        MainMenuDeveloperBrandScalePreset.phone => 1,
        MainMenuDeveloperBrandScalePreset.tablet => 1.2,
      };

  double get bottomOffset => switch (this) {
        MainMenuDeveloperBrandScalePreset.phone => 20,
        MainMenuDeveloperBrandScalePreset.tablet => 24,
      };
}

/// Bottom-centered developer footer used on Main Menu.
class MainMenuDeveloperBrand extends StatelessWidget {
  const MainMenuDeveloperBrand({
    super.key,
    this.alignment = Alignment.bottomCenter,
    this.scalePreset = MainMenuDeveloperBrandScalePreset.phone,
    this.bottomOffset,
    this.semanticsLabel = 'Piar Games',
  }) : assert(bottomOffset == null || bottomOffset >= 0);

  static const contentKey = ValueKey<String>('mainMenuDeveloperBrandContent');
  static const logoKey = ValueKey<String>('mainMenuDeveloperBrandLogo');

  static const _baseSize = Size(119, 65);

  final AlignmentGeometry alignment;
  final MainMenuDeveloperBrandScalePreset scalePreset;
  final double? bottomOffset;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final factor = scalePreset.sizeFactor;
    final resolvedBottomOffset = bottomOffset ?? scalePreset.bottomOffset;

    return Align(
      alignment: alignment,
      child: Padding(
        key: contentKey,
        padding: EdgeInsets.only(bottom: resolvedBottomOffset),
        child: Semantics(
          image: true,
          label: semanticsLabel,
          child: SizedBox(
            key: logoKey,
            width: _baseSize.width * factor,
            height: _baseSize.height * factor,
            child: SvgPicture.asset(
              'assets/developer-logo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
