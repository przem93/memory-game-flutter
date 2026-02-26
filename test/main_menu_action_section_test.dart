import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';
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

  testWidgets('renders actions in order with locked baseline width', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: MainMenuActionSection(
        actions: [
          MainMenuActionItem(label: 'Quick Play', onPressed: () {}),
          MainMenuActionItem(label: 'Customize', onPressed: () {}),
        ],
      ),
    );

    expect(find.byType(MainMenuPrimaryButton), findsNWidgets(2));
    expect(find.text('QUICK PLAY'), findsOneWidget);
    expect(find.text('CUSTOMIZE'), findsOneWidget);

    final quickPlayTop = tester.getTopLeft(find.text('QUICK PLAY')).dy;
    final customizeTop = tester.getTopLeft(find.text('CUSTOMIZE')).dy;
    expect(quickPlayTop, lessThan(customizeTop));

    final firstSlotSize = tester.getSize(
      find.byKey(MainMenuActionSection.buttonSlotKeyAt(0)),
    );
    expect(firstSlotSize.width, 353);
    expect(firstSlotSize.height, 54);
  });

  testWidgets('applies custom spacing between actions', (tester) async {
    await pumpHarness(
      tester,
      child: MainMenuActionSection(
        buttonSpacing: 14,
        actions: [
          MainMenuActionItem(label: 'Quick Play', onPressed: () {}),
          MainMenuActionItem(label: 'Customize', onPressed: () {}),
        ],
      ),
    );

    final firstBottom =
        tester.getBottomLeft(find.byKey(MainMenuActionSection.buttonSlotKeyAt(0))).dy;
    final secondTop =
        tester.getTopLeft(find.byKey(MainMenuActionSection.buttonSlotKeyAt(1))).dy;

    expect(secondTop - firstBottom, 14);
  });

  testWidgets('exposes section and action semantics', (tester) async {
    await pumpHarness(
      tester,
      child: MainMenuActionSection(
        actions: [
          MainMenuActionItem(label: 'Quick Play', onPressed: () {}),
          const MainMenuActionItem(label: 'Customize', enabled: false),
        ],
      ),
    );

    final sectionSemantics = tester.widget<Semantics>(
      find.byKey(MainMenuActionSection.sectionKey),
    );
    final quickPlaySemantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Quick Play',
      ),
    );
    final customizeSemantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Customize',
      ),
    );

    expect(sectionSemantics.properties.label, 'Main menu actions');

    expect(quickPlaySemantics.properties.button, true);
    expect(quickPlaySemantics.properties.enabled, true);

    expect(customizeSemantics.properties.button, true);
    expect(customizeSemantics.properties.enabled, false);
  });

  testWidgets('forwards callbacks and respects disabled actions', (tester) async {
    var quickPlayTaps = 0;
    var customizeTaps = 0;

    await pumpHarness(
      tester,
      child: MainMenuActionSection(
        actions: [
          MainMenuActionItem(
            label: 'Quick Play',
            onPressed: () => quickPlayTaps++,
          ),
          MainMenuActionItem(
            label: 'Customize',
            onPressed: () => customizeTaps++,
            enabled: false,
          ),
        ],
      ),
    );

    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(0)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(1)));
    await tester.pumpAndSettle();

    expect(quickPlayTaps, 1);
    expect(customizeTaps, 0);
  });
}
