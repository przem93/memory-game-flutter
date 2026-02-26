import 'package:flutter/material.dart';

enum SelectLevelDifficulty { simple, medium, hard }

/// Reusable level option button used on Select Level screen.
class SelectLevelOptionButton extends StatefulWidget {
  const SelectLevelOptionButton({
    super.key,
    required this.label,
    required this.difficulty,
    required this.isSelected,
    this.onTap,
  }) : assert(label != '');

  static const containerKey = ValueKey<String>(
    'selectLevelOptionButtonContainer',
  );
  static const labelKey = ValueKey<String>('selectLevelOptionButtonLabel');

  final String label;
  final SelectLevelDifficulty difficulty;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<SelectLevelOptionButton> createState() =>
      _SelectLevelOptionButtonState();
}

class _SelectLevelOptionButtonState extends State<SelectLevelOptionButton> {
  static const _height = 56.0;
  static const _radius = 10.0;
  static const _enabledFillColor = Color(0xFFFFFFFF);
  static const _pressedFillColor = Color(0xFFF7F7F7);
  static const _disabledFillColor = Color(0xFFF1F1F1);

  bool _isPressed = false;

  bool get _isEnabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(widget.difficulty);
    final fill = _isEnabled
        ? (_isPressed ? _pressedFillColor : _enabledFillColor)
        : _disabledFillColor;
    final borderWidth = 2.0;
    final shadowColor = accent.withValues(alpha: _isPressed ? 0.18 : 0.3);

    return Semantics(
      button: true,
      enabled: _isEnabled,
      selected: widget.isSelected,
      label: '${widget.label} level',
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
            key: SelectLevelOptionButton.containerKey,
            duration: const Duration(milliseconds: 90),
            alignment: Alignment.center,
            height: _height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: accent, width: borderWidth),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 4),
                  blurRadius: _isPressed ? 1.5 : 2,
                ),
              ],
            ),
            child: Text(
              widget.label,
              key: SelectLevelOptionButton.labelKey,
              style: const TextStyle(
                fontFamily: 'DynaPuff',
                fontWeight: FontWeight.w700,
                fontSize: 32,
                letterSpacing: 0,
                height: 1,
              ).copyWith(color: accent),
            ),
          ),
        ),
      ),
    );
  }

  Color _accentFor(SelectLevelDifficulty difficulty) => switch (difficulty) {
    SelectLevelDifficulty.simple => const Color(0xFF00E51F),
    SelectLevelDifficulty.medium => const Color(0xFFE2C800),
    SelectLevelDifficulty.hard => const Color(0xFFE50004),
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
