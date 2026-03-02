import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_options_section.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_option_button.dart';
import 'package:memory_game/shared/widgets/set_option_button.dart';

void main() {
  const iconAsset = 'assets/logo-icon.svg';

  final twoSets = [
    (setKey: 'animals-set', label: 'Animals', iconAsset: iconAsset),
    (setKey: 'food-set', label: 'Food', iconAsset: iconAsset),
  ];

  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(width: 354, child: child),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders as many buttons as entries in availableSets',
      (tester) async {
    await pumpHarness(
      tester,
      child: SelectSetOptionsSection(
        availableSets: twoSets,
        onSetSelected: (_) {},
      ),
    );

    final buttons = tester.widgetList<SelectSetOptionButton>(
      find.byType(SelectSetOptionButton),
    ).toList();
    expect(buttons.length, 2);
    expect(buttons[0].label, 'Animals');
    expect(buttons[1].label, 'Food');
  });

  testWidgets('uses default spacing of 11 between buttons', (tester) async {
    await pumpHarness(
      tester,
      child: SelectSetOptionsSection(
        availableSets: twoSets,
        onSetSelected: (_) {},
      ),
    );

    final first = find.byType(SelectSetOptionButton).at(0);
    final second = find.byType(SelectSetOptionButton).at(1);

    final gap = tester.getTopLeft(second).dy - tester.getBottomLeft(first).dy;
    expect(gap, 11);
  });

  testWidgets('supports custom spacing', (tester) async {
    await pumpHarness(
      tester,
      child: SelectSetOptionsSection(
        availableSets: twoSets,
        onSetSelected: (_) {},
        spacing: 16,
      ),
    );

    final first = find.byType(SelectSetOptionButton).at(0);
    final second = find.byType(SelectSetOptionButton).at(1);

    final gap = tester.getTopLeft(second).dy - tester.getBottomLeft(first).dy;
    expect(gap, 16);
  });

  testWidgets('emits setKey on tap via onSetSelected', (tester) async {
    String? selected;
    await pumpHarness(
      tester,
      child: SelectSetOptionsSection(
        availableSets: twoSets,
        onSetSelected: (setKey) => selected = setKey,
      ),
    );

    await tester.tap(find.text('Animals'));
    await tester.pumpAndSettle();
    expect(selected, 'animals-set');

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();
    expect(selected, 'food-set');
  });

  testWidgets('exposes expected semantics for section and buttons',
      (tester) async {
    await pumpHarness(
      tester,
      child: SelectSetOptionsSection(
        availableSets: twoSets,
        onSetSelected: (_) {},
      ),
    );

    final buttonNodes = tester.getSemantics(
      find.byKey(SetOptionButton.semanticsKey).first,
    );
    expect(
      buttonNodes,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        label: 'Select set Animals',
      ),
    );

    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
  });
}
