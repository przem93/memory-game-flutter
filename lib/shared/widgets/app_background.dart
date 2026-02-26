import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shared full-screen background used across app screens.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/background.svg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        if (child != null) child!,
      ],
    );
  }
}
