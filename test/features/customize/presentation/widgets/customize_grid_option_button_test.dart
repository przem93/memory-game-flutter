import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_grid_option_button.dart';

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
        home: Scaffold(body: Center(child: child)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders card count with locked phone geometry and styling', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: CustomizeGridOptionButton(cardCount: 24, onTap: () {}),
    );

    expect(find.byKey(CustomizeGridOptionButton.containerKey), findsOneWidget);
    expect(find.byKey(CustomizeGridOptionButton.labelKey), findsOneWidget);
    expect(find.text('24'), findsOneWidget);

    final containerSize = tester.getSize(
      find.byKey(CustomizeGridOptionButton.containerKey),
    );
    expect(containerSize.width, closeTo(110.667, 0.01));
    expect(containerSize.height, closeTo(89, 0.01));

    final container = tester.widget<AnimatedContainer>(
      find.byKey(CustomizeGridOptionButton.containerKey),
    );
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(decoration.borderRadius, BorderRadius.circular(5.5));
    expect(border.top.width, 1);
    expect(border.top.color.toARGB32(), Colors.black.toARGB32());

    final label = tester.widget<Text>(
      find.byKey(CustomizeGridOptionButton.labelKey),
    );
    expect(label.style?.fontFamily, 'DynaPuff');
    expect(label.style?.fontWeight, FontWeight.w700);
    expect(label.style?.color?.toARGB32(), const Color(0xFF214336).toARGB32());
  });

  testWidgets('supports pressed animation and calls onTap', (tester) async {
    var taps = 0;
    await pumpHarness(
      tester,
      child: CustomizeGridOptionButton(cardCount: 16, onTap: () => taps++),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(CustomizeGridOptionButton)),
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

  testWidgets('blocks tap and uses disabled visuals when disabled', (
    tester,
  ) async {
    var taps = 0;
    await pumpHarness(
      tester,
      child: CustomizeGridOptionButton(
        cardCount: 20,
        isEnabled: false,
        onTap: () => taps++,
      ),
    );

    await tester.tap(find.byType(CustomizeGridOptionButton));
    await tester.pumpAndSettle();
    expect(taps, 0);

    final container = tester.widget<AnimatedContainer>(
      find.byKey(CustomizeGridOptionButton.containerKey),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color?.toARGB32(), const Color(0xFFF0F0F0).toARGB32());

    final label = tester.widget<Text>(
      find.byKey(CustomizeGridOptionButton.labelKey),
    );
    expect(label.style?.color?.toARGB32(), const Color(0x8A214336).toARGB32());
  });

  testWidgets('exposes semantics for enabled/disabled and selected states', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: const CustomizeGridOptionButton(cardCount: 8),
    );

    final disabledNode = tester.getSemantics(
      find.byKey(CustomizeGridOptionButton.semanticsKey),
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
        label: '8 cards',
      ),
    );

    await pumpHarness(
      tester,
      child: CustomizeGridOptionButton(
        cardCount: 10,
        isSelected: true,
        onTap: () {},
      ),
    );

    final selectedNode = tester.getSemantics(
      find.byKey(CustomizeGridOptionButton.semanticsKey),
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
        label: '10 cards',
      ),
    );
  });
}
