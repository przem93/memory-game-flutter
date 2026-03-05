import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_grid_option_button.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_grid_options_section.dart';

void main() {
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
          body: Center(child: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders fixed 3x3 order for supported card counts', (tester) async {
    const values = <int>[24, 8, 6, 10, 20, 12, 18, 14, 16];

    await pumpHarness(
      tester,
      child: CustomizeGridOptionsSection(
        availableCardCounts: values,
        onCardCountSelected: (_) {},
      ),
    );

    expect(find.byType(CustomizeGridOptionButton), findsNWidgets(9));

    final expectedOrder = <int>[6, 8, 10, 12, 14, 16, 18, 20, 24];
    final positions = <int, Offset>{
      for (final value in expectedOrder)
        value: tester.getTopLeft(
          find.byKey(ValueKey<String>('customizeGridOptionsButton-$value')),
        ),
    };

    expect(positions[6]!.dy, closeTo(positions[8]!.dy, 0.001));
    expect(positions[8]!.dy, closeTo(positions[10]!.dy, 0.001));
    expect(positions[12]!.dy, closeTo(positions[14]!.dy, 0.001));
    expect(positions[14]!.dy, closeTo(positions[16]!.dy, 0.001));
    expect(positions[18]!.dy, closeTo(positions[20]!.dy, 0.001));
    expect(positions[20]!.dy, closeTo(positions[24]!.dy, 0.001));

    expect(positions[6]!.dx, lessThan(positions[8]!.dx));
    expect(positions[8]!.dx, lessThan(positions[10]!.dx));
    expect(positions[12]!.dx, lessThan(positions[14]!.dx));
    expect(positions[14]!.dx, lessThan(positions[16]!.dx));
    expect(positions[18]!.dx, lessThan(positions[20]!.dx));
    expect(positions[20]!.dx, lessThan(positions[24]!.dx));

    expect(positions[6]!.dy, lessThan(positions[12]!.dy));
    expect(positions[12]!.dy, lessThan(positions[18]!.dy));
  });

  testWidgets('uses locked 11x11 spacing for phone preset', (tester) async {
    await pumpHarness(
      tester,
      child: CustomizeGridOptionsSection(
        availableCardCounts: CustomizeGridOptionsSection.buttonValues,
        onCardCountSelected: (_) {},
      ),
    );

    final first = find.byKey(const ValueKey<String>('customizeGridOptionsButton-6'));
    final second = find.byKey(const ValueKey<String>('customizeGridOptionsButton-8'));
    final below = find.byKey(const ValueKey<String>('customizeGridOptionsButton-12'));

    final firstTopLeft = tester.getTopLeft(first);
    final secondTopLeft = tester.getTopLeft(second);
    final belowTopLeft = tester.getTopLeft(below);
    final firstSize = tester.getSize(first);

    final horizontalGap = secondTopLeft.dx - firstTopLeft.dx - firstSize.width;
    final verticalGap = belowTopLeft.dy - firstTopLeft.dy - firstSize.height;

    expect(horizontalGap, closeTo(11, 0.01));
    expect(verticalGap, closeTo(11, 0.01));
  });

  testWidgets('calls callback with selected card count', (tester) async {
    int? selected;

    await pumpHarness(
      tester,
      child: CustomizeGridOptionsSection(
        availableCardCounts: CustomizeGridOptionsSection.buttonValues,
        onCardCountSelected: (value) => selected = value,
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('customizeGridOptionsButton-24')),
    );
    await tester.pumpAndSettle();

    expect(selected, 24);
  });

  testWidgets('exposes section semantics label', (tester) async {
    await pumpHarness(
      tester,
      child: CustomizeGridOptionsSection(
        availableCardCounts: CustomizeGridOptionsSection.buttonValues,
        onCardCountSelected: (_) {},
      ),
    );

    final node = tester.getSemantics(
      find.byKey(CustomizeGridOptionsSection.sectionSemanticsKey),
    );
    expect(
      node,
      matchesSemantics(
        label: 'Cards grid options',
      ),
    );
  });
}
