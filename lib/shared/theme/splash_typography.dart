import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class SplashTypography extends ThemeExtension<SplashTypography> {
  const SplashTypography({
    required this.wordmark,
    required this.wordmarkCondensed,
    required this.wordmarkSemiCondensed,
    required this.iconToWordmarkSpacing,
  });

  factory SplashTypography.fallback() {
    return const SplashTypography(
      wordmark: TextStyle(
        fontFamily: 'DynaPuff',
        fontSize: 60,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      wordmarkCondensed: TextStyle(
        fontFamily: 'DynaPuffCondensed',
        fontSize: 60,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      wordmarkSemiCondensed: TextStyle(
        fontFamily: 'DynaPuffSemiCondensed',
        fontSize: 60,
        fontWeight: FontWeight.w700,
        height: 1.0,
      ),
      iconToWordmarkSpacing: 45,
    );
  }

  final TextStyle wordmark;
  final TextStyle wordmarkCondensed;
  final TextStyle wordmarkSemiCondensed;
  final double iconToWordmarkSpacing;

  @override
  SplashTypography copyWith({
    TextStyle? wordmark,
    TextStyle? wordmarkCondensed,
    TextStyle? wordmarkSemiCondensed,
    double? iconToWordmarkSpacing,
  }) {
    return SplashTypography(
      wordmark: wordmark ?? this.wordmark,
      wordmarkCondensed: wordmarkCondensed ?? this.wordmarkCondensed,
      wordmarkSemiCondensed:
          wordmarkSemiCondensed ?? this.wordmarkSemiCondensed,
      iconToWordmarkSpacing:
          iconToWordmarkSpacing ?? this.iconToWordmarkSpacing,
    );
  }

  @override
  SplashTypography lerp(ThemeExtension<SplashTypography>? other, double t) {
    if (other is! SplashTypography) {
      return this;
    }

    return SplashTypography(
      wordmark: TextStyle.lerp(wordmark, other.wordmark, t) ?? wordmark,
      wordmarkCondensed: TextStyle.lerp(
            wordmarkCondensed,
            other.wordmarkCondensed,
            t,
          ) ??
          wordmarkCondensed,
      wordmarkSemiCondensed: TextStyle.lerp(
            wordmarkSemiCondensed,
            other.wordmarkSemiCondensed,
            t,
          ) ??
          wordmarkSemiCondensed,
      iconToWordmarkSpacing: lerpDouble(
            iconToWordmarkSpacing,
            other.iconToWordmarkSpacing,
            t,
          ) ??
          iconToWordmarkSpacing,
    );
  }
}

extension SplashTypographyThemeX on ThemeData {
  SplashTypography get splashTypography =>
      extension<SplashTypography>() ?? SplashTypography.fallback();
}
