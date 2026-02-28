import 'package:flutter/material.dart';
import 'package:memory_game/shared/layout/non_main_flow_layout.dart';

/// Shared screen logo row used by Select Level and Game top sections.
class ScreenLogoRow extends StatelessWidget {
  const ScreenLogoRow({
    this.isTablet = false,
    this.horizontalPadding,
    this.imageKey,
    super.key,
  });

  final bool isTablet;
  final double? horizontalPadding;
  final Key? imageKey;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = horizontalPadding ??
        (isTablet
            ? NonMainFlowLayout.tabletHorizontalInset
            : NonMainFlowLayout.phoneHorizontalMargin);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: effectivePadding),
      child: KeyedSubtree(
        key: imageKey,
        child: Image.asset('assets/screen-logo.png', fit: BoxFit.contain),
      ),
    );
  }
}
