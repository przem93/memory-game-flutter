import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

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

  testWidgets('renders selected state colors for each difficulty', (
    tester,
  ) async {
    const scenarios = [
      (SelectLevelDifficulty.simple, Color(0xFF00E51F)),
      (SelectLevelDifficulty.medium, Color(0xFFE2C800)),
      (SelectLevelDifficulty.hard, Color(0xFFE50004)),
    ];

    for (final scenario in scenarios) {
      await pumpHarness(
        tester,
        child: SelectLevelOptionButton(
          label: 'Simple',
          difficulty: scenario.$1,
          isSelected: true,
          onTap: () {},
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byKey(SelectLevelOptionButton.containerKey),
      );
      final text = tester.widget<Text>(
        find.byKey(SelectLevelOptionButton.labelKey),
      );
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;

      expect(border.top.color, scenario.$2);
      expect(border.top.width, 2);
      expect(text.style?.color, scenario.$2);
      expect(decoration.borderRadius, BorderRadius.circular(10));
      expect(tester.getSize(find.byType(SelectLevelOptionButton)).height, 56);
    }
  });

  testWidgets('renders unselected neutral colors', (tester) async {
    await pumpHarness(
      tester,
      child: SelectLevelOptionButton(
        label: 'Medium',
        difficulty: SelectLevelDifficulty.medium,
        isSelected: false,
        onTap: () {},
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byKey(SelectLevelOptionButton.containerKey),
    );
    final text = tester.widget<Text>(
      find.byKey(SelectLevelOptionButton.labelKey),
    );
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;

    expect(border.top.color, const Color(0xFFD2D2D2));
    expect(border.top.width, 3);
    expect(text.style?.color, const Color(0xFFD2D2D2));
  });

  testWidgets('applies pressed animation and invokes callback', (tester) async {
    var taps = 0;
    await pumpHarness(
      tester,
      child: SelectLevelOptionButton(
        label: 'Hard',
        difficulty: SelectLevelDifficulty.hard,
        isSelected: true,
        onTap: () => taps++,
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(SelectLevelOptionButton)),
    );
    await tester.pump();

    final pressedScale = tester.widget<AnimatedScale>(
      find.byType(AnimatedScale),
    );
    expect(pressedScale.scale, 0.98);

    await gesture.up();
    await tester.pumpAndSettle();

    final releasedScale = tester.widget<AnimatedScale>(
      find.byType(AnimatedScale),
    );
    expect(releasedScale.scale, 1);
    expect(taps, 1);
  });

  testWidgets('renders disabled state and selected semantics', (tester) async {
    await pumpHarness(
      tester,
      child: const SelectLevelOptionButton(
        label: 'Simple',
        difficulty: SelectLevelDifficulty.simple,
        isSelected: false,
      ),
    );

    await tester.tap(find.byType(SelectLevelOptionButton));
    await tester.pumpAndSettle();

    final container = tester.widget<AnimatedContainer>(
      find.byKey(SelectLevelOptionButton.containerKey),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, const Color(0xFFF1F1F1));
    final disabledNode = tester.getSemantics(
      find.byType(SelectLevelOptionButton),
    );
    expect(
      disabledNode,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        hasSelectedState: true,
        isEnabled: false,
        isSelected: false,
        hasTapAction: false,
      ),
    );

    await pumpHarness(
      tester,
      child: SelectLevelOptionButton(
        label: 'Simple',
        difficulty: SelectLevelDifficulty.simple,
        isSelected: true,
        onTap: () {},
      ),
    );
    final selectedNode = tester.getSemantics(
      find.byType(SelectLevelOptionButton),
    );
    expect(
      selectedNode,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        hasSelectedState: true,
        isEnabled: true,
        isSelected: true,
        hasTapAction: true,
      ),
    );
  });
}
