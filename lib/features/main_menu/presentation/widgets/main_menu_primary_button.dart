import 'package:flutter/material.dart';

/// Shared Main Menu button for `Quick Play` and `Customize`.
class MainMenuPrimaryButton extends StatefulWidget {
  const MainMenuPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  static const containerKey = ValueKey<String>(
    'mainMenuPrimaryButtonContainer',
  );
  static const labelKey = ValueKey<String>('mainMenuPrimaryButtonLabel');

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  State<MainMenuPrimaryButton> createState() => _MainMenuPrimaryButtonState();
}

class _MainMenuPrimaryButtonState extends State<MainMenuPrimaryButton> {
  static const _height = 54.0;
  static const _borderRadius = 10.0;
  static const _enabledFillColor = Color(0xFFFFFFFF);
  static const _pressedFillColor = Color(0xFFF5F5F5);
  static const _disabledFillColor = Color(0xFFD9D9D9);
  static const _enabledBorderColor = Color(0xFF000000);
  static const _disabledBorderColor = Color(0xFF7A7A7A);
  static const _enabledTextColor = Color(0xFF214336);
  static const _disabledTextColor = Color(0x8C214336);

  bool _isPressed = false;

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final fillColor = _resolveFillColor();
    final borderColor = _isEnabled ? _enabledBorderColor : _disabledBorderColor;
    final textColor = _isEnabled ? _enabledTextColor : _disabledTextColor;

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
          onTap: _isEnabled ? widget.onPressed : null,
          child: AnimatedContainer(
            key: MainMenuPrimaryButton.containerKey,
            duration: const Duration(milliseconds: 90),
            height: _height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Text(
              widget.label.toUpperCase(),
              key: MainMenuPrimaryButton.labelKey,
              style: const TextStyle(
                color: _enabledTextColor,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                height: 1,
              ).copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveFillColor() {
    if (!_isEnabled) {
      return _disabledFillColor;
    }

    if (_isPressed) {
      return _pressedFillColor;
    }

    return _enabledFillColor;
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
