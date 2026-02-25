import 'package:flutter/material.dart';
import 'package:memory_game/features/splash/presentation/widgets/app_background.dart';
import 'package:memory_game/features/splash/presentation/widgets/app_logo_group.dart';
import 'package:memory_game/features/splash/presentation/widgets/developer_brand.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    this.showDeveloperBrand = true,
    this.developerBrandBottomOffset = 24,
  });

  final bool showDeveloperBrand;
  final double developerBrandBottomOffset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const AppBackground(),
          const SafeArea(
            child: Center(
              child: AppLogoGroup(),
            ),
          ),
          DeveloperBrand(
            enabled: showDeveloperBrand,
            bottomOffset: developerBrandBottomOffset,
          ),
        ],
      ),
    );
  }
}
