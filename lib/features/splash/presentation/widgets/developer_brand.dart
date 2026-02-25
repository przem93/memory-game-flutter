import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeveloperBrand extends StatelessWidget {
  const DeveloperBrand({
    super.key,
    this.enabled = false,
    this.alignment = Alignment.bottomCenter,
    this.bottomOffset = 24,
    this.widthFactor = 0.30,
    this.minWidth = 96,
    this.maxWidth = 180,
  });

  static const String _developerLogoAsset = 'assets/developer-logo.svg';
  static const double _assetAspectRatio = 119 / 65;

  final bool enabled;
  final Alignment alignment;
  final double bottomOffset;
  final double widthFactor;
  final double minWidth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const SizedBox.shrink();
    }

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double logoWidth = (screenWidth * widthFactor).clamp(minWidth, maxWidth);
    final double logoHeight = logoWidth / _assetAspectRatio;

    return SafeArea(
      top: false,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomOffset),
          child: Semantics(
            label: 'Developer brand logo',
            image: true,
            child: ExcludeSemantics(
              child: SizedBox(
                width: logoWidth,
                height: logoHeight,
                child: SvgPicture.asset(
                  _developerLogoAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
