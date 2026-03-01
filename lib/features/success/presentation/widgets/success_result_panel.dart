import 'package:flutter/material.dart';

enum SuccessResultPanelScalePreset { phone, tablet }

/// Reusable panel that displays success outcome and final elapsed time.
class SuccessResultPanel extends StatelessWidget {
  const SuccessResultPanel({
    required this.elapsed,
    this.scalePreset = SuccessResultPanelScalePreset.phone,
    this.titleSemanticsLabel,
    this.elapsedSemanticsLabel,
    super.key,
  });

  static const panelKey = ValueKey<String>('successResultPanel');
  static const titleKey = ValueKey<String>('successResultPanelTitle');
  static const titleContainerKey = ValueKey<String>('successResultPanelTitleContainer');
  static const elapsedLabelKey = ValueKey<String>('successResultPanelElapsedLabel');
  static const elapsedValueKey = ValueKey<String>('successResultPanelElapsedValue');

  static const _phonePanelWidth = 335.0;
  static const _phonePanelHeight = 186.0;
  static const _panelRadius = 6.0;
  static const _phoneContentHorizontalPadding = 20.0;
  static const _titleWidthFactor = 0.95;
  static const _titleOutlineColor = Color(0xFF967C01);
  static const _titleOutlineStrokeWidth = 4.0;

  final Duration elapsed;
  final SuccessResultPanelScalePreset scalePreset;
  final String? titleSemanticsLabel;
  final String? elapsedSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final scale = scalePreset == SuccessResultPanelScalePreset.tablet ? 1.2 : 1.0;
    final panelWidth = _phonePanelWidth * scale;
    final panelHeight = _phonePanelHeight * scale;
    final titleSize = 60.0 * scale;
    final elapsedLabelSize = 24.0 * scale;
    final elapsedValueSize = 32.0 * scale;
    final formattedElapsed = _formatDuration(elapsed);
    final contentWidth =
        _phonePanelWidth * scale - (_phoneContentHorizontalPadding * 2 * scale);

    return SizedBox(
      key: panelKey,
      width: panelWidth,
      height: panelHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.23),
          borderRadius: BorderRadius.circular(_panelRadius * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 10 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _phoneContentHorizontalPadding * scale,
            vertical: 16 * scale,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    readOnly: true,
                    label: titleSemanticsLabel ?? 'You Won',
                    child: ExcludeSemantics(
                      child: SizedBox(
                        key: titleContainerKey,
                        width: contentWidth * _titleWidthFactor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              'You Won!',
                              key: titleKey,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: _titleOutlineStyle(titleSize, scale),
                            ),
                            Text(
                              'You Won!',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: _titleStyle(titleSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18 * scale),
                  Semantics(
                    readOnly: true,
                    label: elapsedSemanticsLabel ?? 'Time elapsed $formattedElapsed',
                    child: ExcludeSemantics(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Time elapsed:',
                            key: elapsedLabelKey,
                            textAlign: TextAlign.center,
                            style: _elapsedLabelStyle(elapsedLabelSize),
                          ),
                          SizedBox(height: 6 * scale),
                          Text(
                            formattedElapsed,
                            key: elapsedValueKey,
                            textAlign: TextAlign.center,
                            style: _elapsedValueStyle(elapsedValueSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _titleStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'DynaPuff',
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      height: 1,
      color: Colors.white,
      shadows: const [
        Shadow(
          color: Color(0x66000000),
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  TextStyle _titleOutlineStyle(double fontSize, double scale) {
    return TextStyle(
      fontFamily: 'DynaPuff',
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      height: 1,
      foreground:
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = _titleOutlineStrokeWidth * scale
            ..color = _titleOutlineColor,
    );
  }

  TextStyle _elapsedLabelStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'DynaPuff',
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      height: 1,
      color: const Color(0xFFFFFFFF),
      shadows: const [
        Shadow(
          color: Color(0x66000000),
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  TextStyle _elapsedValueStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'DynaPuff',
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      height: 1,
      color: const Color(0xFFFFFFFF),
      fontFeatures: const [FontFeature.tabularFigures()],
      shadows: const [
        Shadow(
          color: Color(0x66000000),
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  String _formatDuration(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);
    final hh = hours.toString().padLeft(2, '0');
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}
