import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  static const String _backgroundAsset = 'assets/background.svg';

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SvgPicture.asset(
        _backgroundAsset,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
