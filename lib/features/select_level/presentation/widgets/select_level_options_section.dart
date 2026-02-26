import 'package:flutter/widgets.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

/// Reusable section with all selectable level options.
class SelectLevelOptionsSection extends StatelessWidget {
  const SelectLevelOptionsSection({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    this.spacing = 10,
    this.isEnabled = true,
  }) : assert(spacing >= 0);

  final SelectLevelDifficulty selectedDifficulty;
  final ValueChanged<SelectLevelDifficulty> onDifficultyChanged;
  final double spacing;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SelectLevelOptionButton(
          label: 'Simple',
          difficulty: SelectLevelDifficulty.simple,
          isSelected: selectedDifficulty == SelectLevelDifficulty.simple,
          onTap: isEnabled
              ? () => onDifficultyChanged(SelectLevelDifficulty.simple)
              : null,
        ),
        SizedBox(height: spacing),
        SelectLevelOptionButton(
          label: 'Medium',
          difficulty: SelectLevelDifficulty.medium,
          isSelected: selectedDifficulty == SelectLevelDifficulty.medium,
          onTap: isEnabled
              ? () => onDifficultyChanged(SelectLevelDifficulty.medium)
              : null,
        ),
        SizedBox(height: spacing),
        SelectLevelOptionButton(
          label: 'Hard',
          difficulty: SelectLevelDifficulty.hard,
          isSelected: selectedDifficulty == SelectLevelDifficulty.hard,
          onTap: isEnabled
              ? () => onDifficultyChanged(SelectLevelDifficulty.hard)
              : null,
        ),
      ],
    );
  }
}
