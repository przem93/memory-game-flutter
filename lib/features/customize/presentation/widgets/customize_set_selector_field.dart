import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable active-set selector field used on Customize screen.
class CustomizeSetSelectorField extends StatefulWidget {
  const CustomizeSetSelectorField({
    required this.label,
    required this.leadingIconAsset,
    this.onTap,
    this.isEnabled = true,
    this.semanticsLabel,
    super.key,
  }) : assert(label != ''),
       assert(leadingIconAsset != '');

  static const containerKey = ValueKey<String>('customizeSetSelectorContainer');
  static const semanticsKey = ValueKey<String>('customizeSetSelectorSemantics');
  static const iconSlotKey = ValueKey<String>('customizeSetSelectorIconSlot');
  static const labelKey = ValueKey<String>('customizeSetSelectorLabel');

  final String label;
  final String leadingIconAsset;
  final VoidCallback? onTap;
  final bool isEnabled;
  final String? semanticsLabel;

  @override
  State<CustomizeSetSelectorField> createState() =>
      _CustomizeSetSelectorFieldState();
}

class _CustomizeSetSelectorFieldState extends State<CustomizeSetSelectorField> {
  static const _width = 354.0;
  static const _height = 55.0;
  static const _radius = 5.5;
  static const _iconSlotSize = 30.0;
  static const _iconToLabelGap = 12.0;

  static const _enabledFill = Color(0xFFFFFFFF);
  static const _pressedFill = Color(0xFFF7F7F7);
  static const _disabledFill = Color(0xFFF0F0F0);
  static const _labelColor = Color(0xFF214336);

  bool _isPressed = false;

  bool get _isInteractive => widget.isEnabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final fill = _isInteractive
        ? (_isPressed ? _pressedFill : _enabledFill)
        : _disabledFill;
    final label = widget.semanticsLabel ?? 'Active set ${widget.label}';

    return Semantics(
      key: CustomizeSetSelectorField.semanticsKey,
      excludeSemantics: true,
      button: true,
      enabled: _isInteractive,
      label: label,
      onTap: _isInteractive ? widget.onTap : null,
      child: AnimatedScale(
        scale: _isInteractive && _isPressed ? 0.995 : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
          onTapCancel: _isInteractive ? () => _setPressed(false) : null,
          onTapUp: _isInteractive ? (_) => _setPressed(false) : null,
          onTap: _isInteractive ? widget.onTap : null,
          child: AnimatedContainer(
            key: CustomizeSetSelectorField.containerKey,
            duration: const Duration(milliseconds: 90),
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  key: CustomizeSetSelectorField.iconSlotKey,
                  dimension: _iconSlotSize,
                  child: SvgPicture.asset(
                    widget.leadingIconAsset,
                    fit: BoxFit.contain,
                    colorFilter: _isInteractive
                        ? null
                        : const ColorFilter.mode(
                            Color(0x8A214336),
                            BlendMode.srcIn,
                          ),
                  ),
                ),
                const SizedBox(width: _iconToLabelGap),
                Text(
                  widget.label,
                  key: CustomizeSetSelectorField.labelKey,
                  style: const TextStyle(
                    fontFamily: 'DynaPuff',
                    fontWeight: FontWeight.w700,
                    fontSize: 48 * (32 / 55),
                    height: 1,
                    letterSpacing: 0,
                    color: _labelColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
