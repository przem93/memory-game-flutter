import 'package:flutter/material.dart';
import 'package:memory_game/shared/theme/splash_typography.dart';

enum AppLogoGroupVariant {
  iconAndText,
  iconOnly,
}

class AppLogoGroup extends StatelessWidget {
  const AppLogoGroup({
    super.key,
    this.variant = AppLogoGroupVariant.iconAndText,
    this.alignment = Alignment.center,
    this.spacing,
    this.iconWidth = 118,
    this.iconHeight = 117,
    this.textWidth = 336,
    this.textHeight = 60,
    this.useTextWordmark = false,
    this.wordmarkText = 'MEMORY',
  });

  static const String _iconAsset = 'assets/logo-icon.png';
  static const String _textAsset = 'assets/logo-text.png';

  final AppLogoGroupVariant variant;
  final Alignment alignment;
  final double? spacing;
  final double iconWidth;
  final double iconHeight;
  final double textWidth;
  final double textHeight;
  final bool useTextWordmark;
  final String wordmarkText;

  @override
  Widget build(BuildContext context) {
    final SplashTypography typography = Theme.of(context).splashTypography;
    final double resolvedSpacing = spacing ?? typography.iconToWordmarkSpacing;

    return Align(
      alignment: alignment,
      child: Semantics(
        label: 'Memory game logo',
        image: true,
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: iconWidth,
                height: iconHeight,
                child: Image.asset(
                  _iconAsset,
                  fit: BoxFit.contain,
                ),
              ),
              if (variant == AppLogoGroupVariant.iconAndText) ...<Widget>[
                SizedBox(height: resolvedSpacing),
                SizedBox(
                  width: textWidth,
                  height: textHeight,
                  child: useTextWordmark
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            wordmarkText,
                            style: typography.wordmark,
                          ),
                        )
                      : Image.asset(
                          _textAsset,
                          fit: BoxFit.contain,
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
