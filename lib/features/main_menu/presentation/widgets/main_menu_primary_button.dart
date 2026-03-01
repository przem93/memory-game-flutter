import 'package:flutter/material.dart';

/// Shared primary action button used by menu-like screens.
class MainMenuPrimaryButton extends StatefulWidget {
  const MainMenuPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.customContainerKey,
    this.customLabelKey,
    this.uppercaseLabel = true,
    this.height = 54,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.fontSize = 32,
    this.fontFamily,
    this.fontWeight = FontWeight.w700,
    this.excludeLabelSemanticsFromText = false,
    this.enabledFillColor = const Color(0xFFFFFFFF),
    this.pressedFillColor = const Color(0xFFF5F5F5),
    this.disabledFillColor = const Color(0xFFD9D9D9),
    this.enabledBorderColor = const Color(0xFF000000),
    this.disabledBorderColor = const Color(0xFF7A7A7A),
    this.enabledTextColor = const Color(0xFF214336),
    this.disabledTextColor = const Color(0x8C214336),
    this.enabledShadow,
    this.pressedShadow,
    this.disabledShadow,
  });

  static const containerKey = ValueKey<String>(
    'mainMenuPrimaryButtonContainer',
  );
  static const labelKey = ValueKey<String>('mainMenuPrimaryButtonLabel');

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final Key? customContainerKey;
  final Key? customLabelKey;
  final bool uppercaseLabel;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final String? fontFamily;
  final FontWeight fontWeight;
  final bool excludeLabelSemanticsFromText;
  final Color enabledFillColor;
  final Color pressedFillColor;
  final Color disabledFillColor;
  final Color enabledBorderColor;
  final Color disabledBorderColor;
  final Color enabledTextColor;
  final Color disabledTextColor;
  final BoxShadow? enabledShadow;
  final BoxShadow? pressedShadow;
  final BoxShadow? disabledShadow;

  @override
  State<MainMenuPrimaryButton> createState() => _MainMenuPrimaryButtonState();
}

class _MainMenuPrimaryButtonState extends State<MainMenuPrimaryButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final fillColor = _resolveFillColor();
    final borderColor = _isEnabled
        ? widget.enabledBorderColor
        : widget.disabledBorderColor;
    final textColor = _isEnabled
        ? widget.enabledTextColor
        : widget.disabledTextColor;
    final shadow = _resolveShadow();
    final shadows = shadow == null ? const <BoxShadow>[] : <BoxShadow>[shadow];
    final resolvedLabel = widget.uppercaseLabel
        ? widget.label.toUpperCase()
        : widget.label;

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
            key: widget.customContainerKey ?? MainMenuPrimaryButton.containerKey,
            duration: const Duration(milliseconds: 90),
            height: widget.height,
            alignment: Alignment.center,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: shadows,
            ),
            child: ExcludeSemantics(
              excluding: widget.excludeLabelSemanticsFromText,
              child: Text(
                resolvedLabel,
                key: widget.customLabelKey ?? MainMenuPrimaryButton.labelKey,
                style: TextStyle(
                  color: widget.enabledTextColor,
                  fontFamily: widget.fontFamily,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  letterSpacing: 0,
                  height: 1,
                ).copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveFillColor() {
    if (!_isEnabled) {
      return widget.disabledFillColor;
    }

    if (_isPressed) {
      return widget.pressedFillColor;
    }

    return widget.enabledFillColor;
  }

  BoxShadow? _resolveShadow() {
    if (!_isEnabled) {
      return widget.disabledShadow;
    }

    if (_isPressed) {
      return widget.pressedShadow;
    }

    return widget.enabledShadow;
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
