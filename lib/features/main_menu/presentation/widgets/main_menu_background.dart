import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Main Menu background with locked gradient and decorative SVG layer.
class MainMenuBackground extends StatelessWidget {
  const MainMenuBackground({
    super.key,
    this.child,
    this.decorativeOpacity = 1,
    this.decorativeScale,
  }) : assert(decorativeOpacity >= 0 && decorativeOpacity <= 1);

  final Widget? child;

  /// Opacity multiplier for the decorative icon layer.
  ///
  /// The `assets/background.svg` file already encodes the base icon opacity.
  /// This value scales that decorative layer while preserving the base gradient.
  final double decorativeOpacity;

  /// Optional scale override for decorative SVG on wider layouts.
  final double? decorativeScale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedScale =
            decorativeScale ?? _resolveDecorativeScale(constraints.maxWidth);

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF151414),
                Color(0xFF2E7C5E),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              IgnorePointer(
                child: ClipRect(
                  child: Opacity(
                    opacity: decorativeOpacity,
                    child: Transform.scale(
                      alignment: Alignment.topCenter,
                      scale: resolvedScale,
                      child: SvgPicture.asset(
                        'assets/background.svg',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              if (child != null) child!,
            ],
          ),
        );
      },
    );
  }

  double _resolveDecorativeScale(double width) {
    if (width <= 600) {
      return 1;
    }

    return (width / 393).clamp(1.0, 1.6);
  }
}
