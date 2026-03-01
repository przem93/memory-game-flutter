import 'package:flutter/material.dart';

enum CustomizeGridOptionButtonPreset { phone, tablet }

/// Reusable card-count option button used in Customize screen grid.
class CustomizeGridOptionButton extends StatefulWidget {
  const CustomizeGridOptionButton({
    required this.cardCount,
    this.onTap,
    this.isEnabled = true,
    this.isSelected = false,
    this.preset = CustomizeGridOptionButtonPreset.phone,
    this.semanticsLabel,
    super.key,
  }) : assert(cardCount > 0);

  static const containerKey = ValueKey<String>(
    'customizeGridOptionButtonContainer',
  );
  static const semanticsKey = ValueKey<String>(
    'customizeGridOptionButtonSemantics',
  );
  static const labelKey = ValueKey<String>('customizeGridOptionButtonLabel');

  final int cardCount;
  final VoidCallback? onTap;
  final bool isEnabled;
  final bool isSelected;
  final CustomizeGridOptionButtonPreset preset;
  final String? semanticsLabel;

  @override
  State<CustomizeGridOptionButton> createState() =>
      _CustomizeGridOptionButtonState();
}

class _CustomizeGridOptionButtonState extends State<CustomizeGridOptionButton> {
  static const _phoneWidth = 110.667;
  static const _phoneHeight = 89.0;
  static const _radius = 5.5;

  static const _enabledFill = Color(0xFFFFFFFF);
  static const _pressedFill = Color(0xFFF7F7F7);
  static const _disabledFill = Color(0xFFF0F0F0);

  static const _labelColor = Color(0xFF214336);
  static const _disabledLabelColor = Color(0x8A214336);
  static const _selectedBorderColor = Color(0xFF214336);

  bool _isPressed = false;

  bool get _isInteractive => widget.isEnabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final dimensions = _dimensionsFor(widget.preset);
    final fill = _isInteractive
        ? (_isPressed ? _pressedFill : _enabledFill)
        : _disabledFill;
    final label = widget.semanticsLabel ?? '${widget.cardCount} cards';
    final borderColor = widget.isSelected ? _selectedBorderColor : Colors.black;
    final borderWidth = widget.isSelected ? 2.0 : 1.0;

    return Semantics(
      key: CustomizeGridOptionButton.semanticsKey,
      excludeSemantics: true,
      button: true,
      enabled: _isInteractive,
      selected: widget.isSelected,
      label: label,
      onTap: _isInteractive ? widget.onTap : null,
      child: AnimatedScale(
        scale: _isInteractive && _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
          onTapCancel: _isInteractive ? () => _setPressed(false) : null,
          onTapUp: _isInteractive ? (_) => _setPressed(false) : null,
          onTap: _isInteractive ? widget.onTap : null,
          child: AnimatedContainer(
            key: CustomizeGridOptionButton.containerKey,
            duration: const Duration(milliseconds: 90),
            width: dimensions.width,
            height: dimensions.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Text(
              '${widget.cardCount}',
              key: CustomizeGridOptionButton.labelKey,
              style: TextStyle(
                fontFamily: 'DynaPuff',
                fontWeight: FontWeight.w700,
                fontSize: 48 * (44 / 89),
                height: 1,
                letterSpacing: 0,
                color: _isInteractive ? _labelColor : _disabledLabelColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Size _dimensionsFor(
    CustomizeGridOptionButtonPreset preset,
  ) => switch (preset) {
    CustomizeGridOptionButtonPreset.phone => const Size(
      _phoneWidth,
      _phoneHeight,
    ),
    // Keep the same baseline geometry for now; tablet layout is handled at section level.
    CustomizeGridOptionButtonPreset.tablet => const Size(
      _phoneWidth,
      _phoneHeight,
    ),
  };

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }
    setState(() {
      _isPressed = value;
    });
  }
}
