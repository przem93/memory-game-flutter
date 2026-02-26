import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MainMenuLogoScalePreset {
  phone,
  tablet,
}

extension on MainMenuLogoScalePreset {
  double get factor => switch (this) {
        MainMenuLogoScalePreset.phone => 1,
        MainMenuLogoScalePreset.tablet => 1.2,
      };
}

/// Main Menu logo group (`logo-icon` + `logo-text`) with simple layout API.
class MainMenuLogoGroup extends StatelessWidget {
  const MainMenuLogoGroup({
    super.key,
    this.alignment = Alignment.topCenter,
    this.spacing = 33,
    this.scalePreset = MainMenuLogoScalePreset.phone,
  }) : assert(spacing >= 0);

  static const contentKey = ValueKey<String>('mainMenuLogoGroupContent');
  static const iconKey = ValueKey<String>('mainMenuLogoGroupIcon');
  static const textKey = ValueKey<String>('mainMenuLogoGroupText');

  final AlignmentGeometry alignment;
  final double spacing;
  final MainMenuLogoScalePreset scalePreset;

  static const _baseIconSize = Size(118, 118);
  static const _baseTextSize = Size(357, 79);

  @override
  Widget build(BuildContext context) {
    final factor = scalePreset.factor;

    return Align(
      alignment: alignment,
      child: Column(
        key: contentKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            key: iconKey,
            width: _baseIconSize.width * factor,
            height: _baseIconSize.height * factor,
            child: SvgPicture.asset(
              'assets/logo-icon.svg',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: spacing * factor),
          SizedBox(
            key: textKey,
            width: _baseTextSize.width * factor,
            height: _baseTextSize.height * factor,
            child: SvgPicture.asset(
              'assets/logo-text.svg',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
