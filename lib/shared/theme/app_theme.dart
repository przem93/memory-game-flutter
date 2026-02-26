import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B3CC4)),
      fontFamily: 'DynaPuff',
      useMaterial3: true,
    );
  }
}
