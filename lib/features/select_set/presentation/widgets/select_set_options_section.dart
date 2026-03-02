import 'package:flutter/widgets.dart';
import 'package:memory_game/features/select_set/domain/select_set_entry.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_option_button.dart';

/// Reusable section with all selectable set options.
class SelectSetOptionsSection extends StatelessWidget {
  SelectSetOptionsSection({
    super.key,
    required this.availableSets,
    required this.onSetSelected,
    this.spacing = 11,
  })  : assert(spacing >= 0),
        assert(availableSets.isNotEmpty);

  final List<SelectSetEntry> availableSets;
  final ValueChanged<String> onSetSelected;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < availableSets.length; i++) {
      final entry = availableSets[i];
      children.add(
        SelectSetOptionButton(
          label: entry.label,
          leadingIconAsset: entry.iconAsset,
          onTap: () => onSetSelected(entry.setKey),
        ),
      );
      if (i < availableSets.length - 1) {
        children.add(SizedBox(height: spacing));
      }
    }

    return Semantics(
      container: true,
      label: 'Select set options',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
