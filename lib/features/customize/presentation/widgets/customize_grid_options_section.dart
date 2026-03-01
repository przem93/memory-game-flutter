import 'package:flutter/widgets.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_grid_option_button.dart';

enum CustomizeGridOptionsSectionSpacingPreset { phone, tablet }

/// Reusable 3x3 section containing card-count options for Customize screen.
class CustomizeGridOptionsSection extends StatelessWidget {
  const CustomizeGridOptionsSection({
    super.key,
    required this.availableCardCounts,
    required this.onCardCountSelected,
    this.isEnabled = true,
    this.spacingPreset = CustomizeGridOptionsSectionSpacingPreset.phone,
  });

  static const sectionSemanticsKey = ValueKey<String>(
    'customizeGridOptionsSectionSemantics',
  );

  static const buttonValues = <int>[8, 10, 12, 14, 16, 18, 20, 22, 24];
  static const _buttonsPerRow = 3;

  final List<int> availableCardCounts;
  final ValueChanged<int> onCardCountSelected;
  final bool isEnabled;
  final CustomizeGridOptionsSectionSpacingPreset spacingPreset;

  @override
  Widget build(BuildContext context) {
    final orderedCardCounts = _resolveOrderedCardCounts(availableCardCounts);
    final rows = <List<int>>[];
    for (var index = 0; index < orderedCardCounts.length; index += _buttonsPerRow) {
      rows.add(orderedCardCounts.sublist(index, index + _buttonsPerRow));
    }

    return Semantics(
      key: sectionSemanticsKey,
      container: true,
      label: 'Cards grid options',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var columnIndex = 0;
                    columnIndex < rows[rowIndex].length;
                    columnIndex++) ...[
                  CustomizeGridOptionButton(
                    key: ValueKey<String>(
                      'customizeGridOptionsButton-${rows[rowIndex][columnIndex]}',
                    ),
                    cardCount: rows[rowIndex][columnIndex],
                    onTap: isEnabled
                        ? () => onCardCountSelected(rows[rowIndex][columnIndex])
                        : null,
                  ),
                  if (columnIndex < rows[rowIndex].length - 1)
                    SizedBox(width: _spacingFor(spacingPreset)),
                ],
              ],
            ),
            if (rowIndex < rows.length - 1)
              SizedBox(height: _spacingFor(spacingPreset)),
          ],
        ],
      ),
    );
  }

  List<int> _resolveOrderedCardCounts(List<int> input) {
    assert(input.isNotEmpty, 'availableCardCounts cannot be empty.');
    final uniqueValues = input.toSet();
    assert(uniqueValues.length == input.length, 'availableCardCounts must be unique.');

    final ordered = buttonValues.where(uniqueValues.contains).toList(growable: false);

    assert(
      ordered.length == input.length,
      'availableCardCounts can only include supported values: $buttonValues',
    );
    assert(
      ordered.length % _buttonsPerRow == 0,
      'availableCardCounts must produce full rows of $_buttonsPerRow items.',
    );

    return ordered;
  }

  double _spacingFor(CustomizeGridOptionsSectionSpacingPreset preset) {
    return switch (preset) {
      CustomizeGridOptionsSectionSpacingPreset.phone => 11.0,
      // Keep baseline spacing for now; tablet spacing can be tuned in Stage 3.
      CustomizeGridOptionsSectionSpacingPreset.tablet => 11.0,
    };
  }
}
