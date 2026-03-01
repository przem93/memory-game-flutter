import 'package:flutter/material.dart';

enum SuccessActionButtonsScalePreset { phone, tablet }

/// Reusable action section for Success with `Play again` and `Close`.
class SuccessActionButtons extends StatelessWidget {
  const SuccessActionButtons({
    this.onPlayAgainTap,
    this.onCloseTap,
    this.playAgainEnabled = true,
    this.closeEnabled = true,
    this.scalePreset = SuccessActionButtonsScalePreset.phone,
    super.key,
  });

  static const sectionKey = ValueKey<String>('successActionButtonsSection');
  static const playAgainButtonKey = ValueKey<String>(
    'successActionButtonsPlayAgainButton',
  );
  static const closeButtonKey = ValueKey<String>('successActionButtonsCloseButton');

  static const _phoneButtonWidth = 335.0;
  static const _phoneButtonsGap = 10.0;

  final VoidCallback? onPlayAgainTap;
  final VoidCallback? onCloseTap;
  final bool playAgainEnabled;
  final bool closeEnabled;
  final SuccessActionButtonsScalePreset scalePreset;

  @override
  Widget build(BuildContext context) {
    final scale = scalePreset == SuccessActionButtonsScalePreset.tablet ? 1.2 : 1.0;

    return SizedBox(
      key: sectionKey,
      width: _phoneButtonWidth * scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SuccessActionButton(
            buttonKey: playAgainButtonKey,
            label: 'Play again',
            scale: scale,
            enabled: playAgainEnabled,
            onTap: onPlayAgainTap,
          ),
          SizedBox(height: _phoneButtonsGap * scale),
          _SuccessActionButton(
            buttonKey: closeButtonKey,
            label: 'Close',
            scale: scale,
            enabled: closeEnabled,
            onTap: onCloseTap,
          ),
        ],
      ),
    );
  }
}

class _SuccessActionButton extends StatefulWidget {
  const _SuccessActionButton({
    required this.buttonKey,
    required this.label,
    required this.scale,
    this.enabled = true,
    this.onTap,
  });

  static const _width = 335.0;
  static const _height = 56.0;
  static const _radius = 10.0;
  static const _enabledFillColor = Color(0xFFFFFFFF);
  static const _pressedFillColor = Color(0xFFF7F7F7);
  static const _disabledFillColor = Color(0xFFF1F1F1);
  static const _enabledTextColor = Color(0xFF214336);
  static const _disabledTextColor = Color(0x8C214336);

  final Key buttonKey;
  final String label;
  final double scale;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  State<_SuccessActionButton> createState() => _SuccessActionButtonState();
}

class _SuccessActionButtonState extends State<_SuccessActionButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.enabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final fillColor = _resolveFillColor();
    final textColor = _isEnabled
        ? _SuccessActionButton._enabledTextColor
        : _SuccessActionButton._disabledTextColor;
    final shadowColor = Colors.black.withValues(alpha: _isPressed ? 0.18 : 0.25);

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.label,
      child: AnimatedScale(
        scale: _isEnabled && _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _isEnabled ? (_) => _setPressed(true) : null,
          onTapCancel: _isEnabled ? () => _setPressed(false) : null,
          onTapUp: _isEnabled ? (_) => _setPressed(false) : null,
          onTap: _isEnabled ? widget.onTap : null,
          child: AnimatedContainer(
            key: widget.buttonKey,
            duration: const Duration(milliseconds: 90),
            width: _SuccessActionButton._width * widget.scale,
            height: _SuccessActionButton._height * widget.scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(
                _SuccessActionButton._radius * widget.scale,
              ),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 4),
                  blurRadius: _isPressed ? 1.5 : 2,
                ),
              ],
            ),
            child: ExcludeSemantics(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'DynaPuff',
                  fontWeight: FontWeight.w700,
                  fontSize: 32 * widget.scale,
                  height: 1,
                  letterSpacing: 0,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveFillColor() {
    if (!_isEnabled) {
      return _SuccessActionButton._disabledFillColor;
    }

    if (_isPressed) {
      return _SuccessActionButton._pressedFillColor;
    }

    return _SuccessActionButton._enabledFillColor;
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }
}
