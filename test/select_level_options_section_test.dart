import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_options_section.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: canvas.width,
            height: canvas.height,
            child: Center(child: SizedBox(width: 353, child: child)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders three options and keeps only one selected', (tester) async {
    await pumpHarness(
      tester,
      child: SelectLevelOptionsSection(
        selectedDifficulty: SelectLevelDifficulty.medium,
        onDifficultyChanged: (_) {},
      ),
    );

    final options = tester.widgetList<SelectLevelOptionButton>(
      find.byType(SelectLevelOptionButton),
    );
    expect(options.length, 3);

    expect(options.elementAt(0).difficulty, SelectLevelDifficulty.simple);
    expect(options.elementAt(1).difficulty, SelectLevelDifficulty.medium);
    expect(options.elementAt(2).difficulty, SelectLevelDifficulty.hard);

    expect(options.elementAt(0).isSelected, isFalse);
    expect(options.elementAt(1).isSelected, isTrue);
    expect(options.elementAt(2).isSelected, isFalse);
  });

  testWidgets('uses default spacing of 10 between buttons', (tester) async {
    await pumpHarness(
      tester,
      child: SelectLevelOptionsSection(
        selectedDifficulty: SelectLevelDifficulty.simple,
        onDifficultyChanged: (_) {},
      ),
    );

    final first = find.byType(SelectLevelOptionButton).at(0);
    final second = find.byType(SelectLevelOptionButton).at(1);
    final third = find.byType(SelectLevelOptionButton).at(2);

    final gap1 = tester.getTopLeft(second).dy - tester.getBottomLeft(first).dy;
    final gap2 = tester.getTopLeft(third).dy - tester.getBottomLeft(second).dy;

    expect(gap1, 10);
    expect(gap2, 10);
  });

  testWidgets('supports custom spacing', (tester) async {
    await pumpHarness(
      tester,
      child: SelectLevelOptionsSection(
        selectedDifficulty: SelectLevelDifficulty.hard,
        onDifficultyChanged: (_) {},
        spacing: 16,
      ),
    );

    final first = find.byType(SelectLevelOptionButton).at(0);
    final second = find.byType(SelectLevelOptionButton).at(1);
    final third = find.byType(SelectLevelOptionButton).at(2);

    final gap1 = tester.getTopLeft(second).dy - tester.getBottomLeft(first).dy;
    final gap2 = tester.getTopLeft(third).dy - tester.getBottomLeft(second).dy;

    expect(gap1, 16);
    expect(gap2, 16);
  });

  testWidgets('emits selected difficulty on tap', (tester) async {
    SelectLevelDifficulty? selected;
    await pumpHarness(
      tester,
      child: SelectLevelOptionsSection(
        selectedDifficulty: SelectLevelDifficulty.simple,
        onDifficultyChanged: (difficulty) => selected = difficulty,
      ),
    );

    await tester.tap(find.text('Medium'));
    await tester.pumpAndSettle();
    expect(selected, SelectLevelDifficulty.medium);

    await tester.tap(find.text('Hard'));
    await tester.pumpAndSettle();
    expect(selected, SelectLevelDifficulty.hard);
  });
}
