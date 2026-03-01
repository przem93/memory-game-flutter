import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_set_selector_field.dart';

void main() {
  const iconAsset = 'assets/logo-icon.svg';

  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(child: child))));
    await tester.pumpAndSettle();
  }

  testWidgets('renders label, icon slot and locked geometry', (tester) async {
    await pumpHarness(
      tester,
      child: const CustomizeSetSelectorField(
        label: 'Food',
        leadingIconAsset: iconAsset,
      ),
    );

    expect(find.byKey(CustomizeSetSelectorField.containerKey), findsOneWidget);
    expect(find.byKey(CustomizeSetSelectorField.iconSlotKey), findsOneWidget);
    expect(find.byKey(CustomizeSetSelectorField.labelKey), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);

    final containerSize = tester.getSize(
      find.byKey(CustomizeSetSelectorField.containerKey),
    );
    expect(containerSize.width, closeTo(354, 0.01));
    expect(containerSize.height, closeTo(55, 0.01));

    final iconSize = tester.getSize(
      find.byKey(CustomizeSetSelectorField.iconSlotKey),
    );
    expect(iconSize.width, closeTo(30, 0.01));
    expect(iconSize.height, closeTo(30, 0.01));

    final labelText = tester.widget<Text>(find.byKey(CustomizeSetSelectorField.labelKey));
    expect(labelText.style?.fontFamily, 'DynaPuff');
    expect(labelText.style?.fontWeight, FontWeight.w700);
    expect(
      labelText.style?.color?.toARGB32(),
      const Color(0xFF214336).toARGB32(),
    );
  });

  testWidgets('exposes expected semantics for non-interactive and interactive modes', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: const CustomizeSetSelectorField(
        label: 'Food',
        leadingIconAsset: iconAsset,
      ),
    );

    final nonInteractiveNode = tester.getSemantics(
      find.byKey(CustomizeSetSelectorField.semanticsKey),
    );
    expect(
      nonInteractiveNode,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
        label: 'Active set Food',
      ),
    );

    await pumpHarness(
      tester,
      child: CustomizeSetSelectorField(
        label: 'Food',
        leadingIconAsset: iconAsset,
        onTap: () {},
      ),
    );

    final interactiveNode = tester.getSemantics(
      find.byKey(CustomizeSetSelectorField.semanticsKey),
    );
    expect(
      interactiveNode,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        label: 'Active set Food',
      ),
    );
  });

  testWidgets('calls onTap only when enabled and interactive', (tester) async {
    var taps = 0;
    Future<void> pumpField({required bool isEnabled, VoidCallback? onTap}) async {
      await pumpHarness(
        tester,
        child: CustomizeSetSelectorField(
          label: 'Food',
          leadingIconAsset: iconAsset,
          isEnabled: isEnabled,
          onTap: onTap,
        ),
      );
    }

    await pumpField(isEnabled: true, onTap: () => taps++);
    await tester.tap(find.byKey(CustomizeSetSelectorField.containerKey));
    await tester.pumpAndSettle();
    expect(taps, 1);

    await pumpField(isEnabled: false, onTap: () => taps++);
    await tester.tap(find.byKey(CustomizeSetSelectorField.containerKey));
    await tester.pumpAndSettle();
    expect(taps, 1);

    await pumpField(isEnabled: true, onTap: null);
    await tester.tap(find.byKey(CustomizeSetSelectorField.containerKey));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
