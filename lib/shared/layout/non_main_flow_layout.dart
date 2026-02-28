import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared layout tokens for all non-main screens (e.g. Select Level, Gameplay).
abstract final class NonMainFlowLayout {
  static const phoneReferenceHeight = 852.0;
  static const phoneTopLogoOffset = 28.0;
  static const phoneHorizontalMargin = 20.0;
  static const tabletHorizontalInset = 48.0;
  static const tabletBreakpoint = 600.0;
  static const topScaleMinFactor = 0.85;
  static const topScaleMaxFactor = 1.25;

  static bool isTabletWidth(double width) => width > tabletBreakpoint;

  static double scaledOffset(double phoneOffset, double normalizedHeight) {
    return phoneOffset * (normalizedHeight / phoneReferenceHeight);
  }

  static double resolveTopLogoSpacing({
    required double safeAreaHeight,
    required EdgeInsets viewPadding,
  }) {
    final fullViewportHeight = safeAreaHeight + viewPadding.top + viewPadding.bottom;
    final normalizedHeight = fullViewportHeight.clamp(
      phoneReferenceHeight * topScaleMinFactor,
      phoneReferenceHeight * topScaleMaxFactor,
    );

    return math.max(0, scaledOffset(phoneTopLogoOffset, normalizedHeight) - viewPadding.top);
  }
}
