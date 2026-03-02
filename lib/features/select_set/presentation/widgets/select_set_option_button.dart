import 'package:flutter/material.dart';
import 'package:memory_game/shared/widgets/set_option_button.dart';

/// Reusable set option button used on Select Set screen.
class SelectSetOptionButton extends StatelessWidget {
  const SelectSetOptionButton({
    required this.label,
    required this.leadingIconAsset,
    this.onTap,
    this.isEnabled = true,
    super.key,
  })  : assert(label != ''),
        assert(leadingIconAsset != '');

  final String label;
  final String leadingIconAsset;
  final VoidCallback? onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SetOptionButton(
      label: label,
      leadingIconAsset: leadingIconAsset,
      onTap: onTap,
      isEnabled: isEnabled,
      semanticsLabel: 'Select set $label',
    );
  }
}
