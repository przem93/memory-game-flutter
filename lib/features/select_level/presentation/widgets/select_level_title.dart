import 'package:flutter/widgets.dart';

/// Reusable title widget for the Select Level screen.
class SelectLevelTitle extends StatelessWidget {
  const SelectLevelTitle({
    super.key,
    this.text = 'Select level',
    this.maxTextScaleFactor = 1.2,
  }) : assert(maxTextScaleFactor >= 1);

  static const labelKey = ValueKey<String>('selectLevelTitleLabel');

  final String text;
  final double maxTextScaleFactor;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: maxTextScaleFactor);

    return Semantics(
      header: true,
      child: Text(
        text,
        key: labelKey,
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        textScaler: textScaler,
        style: const TextStyle(
          fontFamily: 'DynaPuff',
          fontWeight: FontWeight.w700,
          fontSize: 32,
          height: 1,
          letterSpacing: 0,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
