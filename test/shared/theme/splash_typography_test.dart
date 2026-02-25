import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/shared/theme/app_theme.dart';
import 'package:memory_game/shared/theme/splash_typography.dart';

void main() {
  test('AppTheme.light exposes SplashTypography extension', () {
    final ThemeData theme = AppTheme.light();
    final SplashTypography typography = theme.splashTypography;

    expect(theme.extension<SplashTypography>(), isNotNull);
    expect(typography.iconToWordmarkSpacing, equals(45));
  });

  test('SplashTypography fallback includes all DynaPuff families', () {
    final SplashTypography typography = SplashTypography.fallback();

    expect(typography.wordmark.fontFamily, equals('DynaPuff'));
    expect(typography.wordmarkCondensed.fontFamily, equals('DynaPuffCondensed'));
    expect(
      typography.wordmarkSemiCondensed.fontFamily,
      equals('DynaPuffSemiCondensed'),
    );
  });
}
