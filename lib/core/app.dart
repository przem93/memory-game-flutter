import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/app_background.dart';
import 'package:memory_game/shared/theme/app_theme.dart';

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: AppTheme.light(),
      home: const Scaffold(
        body: AppBackground(),
      ),
    );
  }
}
