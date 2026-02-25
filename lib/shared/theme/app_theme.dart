import 'package:flutter/material.dart';
import 'package:memory_game/shared/theme/splash_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B3CC4)),
      fontFamily: 'DynaPuff',
      extensions: <ThemeExtension<dynamic>>[
        SplashTypography.fallback(),
      ],
      useMaterial3: true,
    );
  }
}
