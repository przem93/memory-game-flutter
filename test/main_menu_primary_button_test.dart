import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_primary_button.dart';

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

  testWidgets('renders locked baseline geometry and style', (tester) async {
    await pumpHarness(
      tester,
      child: MainMenuPrimaryButton(label: 'Quick Play', onPressed: () {}),
    );

    expect(find.text('QUICK PLAY'), findsOneWidget);

    final buttonSize = tester.getSize(find.byType(MainMenuPrimaryButton));
    expect(buttonSize.width, 353);
    expect(buttonSize.height, 54);

    final container = tester.widget<AnimatedContainer>(
      find.byKey(MainMenuPrimaryButton.containerKey),
    );
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    final text = tester.widget<Text>(
      find.byKey(MainMenuPrimaryButton.labelKey),
    );

    expect(decoration.color, const Color(0xFFFFFFFF));
    expect(border.top.color, const Color(0xFF000000));
    expect(decoration.borderRadius, BorderRadius.circular(10));
    expect(text.style?.fontSize, 19);
    expect(text.style?.fontWeight, FontWeight.w700);
    expect(text.style?.color, const Color(0xFF214336));
  });

  testWidgets('applies pressed state and calls onPressed', (tester) async {
    var taps = 0;

    await pumpHarness(
      tester,
      child: MainMenuPrimaryButton(
        label: 'Quick Play',
        onPressed: () => taps++,
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(MainMenuPrimaryButton)),
    );
    await tester.pump();

    final pressedScale = tester.widget<AnimatedScale>(
      find.byType(AnimatedScale),
    );
    final pressedContainer = tester.widget<AnimatedContainer>(
      find.byKey(MainMenuPrimaryButton.containerKey),
    );
    final pressedDecoration = pressedContainer.decoration! as BoxDecoration;

    expect(pressedScale.scale, 0.98);
    expect(pressedDecoration.color, const Color(0xFFF5F5F5));

    await gesture.up();
    await tester.pumpAndSettle();

    final releasedScale = tester.widget<AnimatedScale>(
      find.byType(AnimatedScale),
    );
    expect(releasedScale.scale, 1);
    expect(taps, 1);
  });

  testWidgets('renders disabled state and does not invoke callback', (
    tester,
  ) async {
    var taps = 0;

    await pumpHarness(
      tester,
      child: MainMenuPrimaryButton(
        label: 'Customize',
        enabled: false,
        onPressed: () => taps++,
      ),
    );

    await tester.tap(find.byType(MainMenuPrimaryButton));
    await tester.pumpAndSettle();

    final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
    final container = tester.widget<AnimatedContainer>(
      find.byKey(MainMenuPrimaryButton.containerKey),
    );
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    final text = tester.widget<Text>(
      find.byKey(MainMenuPrimaryButton.labelKey),
    );

    expect(scale.scale, 1);
    expect(taps, 0);
    expect(decoration.color, const Color(0xFFD9D9D9));
    expect(border.top.color, const Color(0xFF7A7A7A));
    expect(text.style?.color, const Color(0x8C214336));
  });
}
