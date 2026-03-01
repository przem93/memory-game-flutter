import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/success/presentation/widgets/success_result_panel.dart';

void main() {
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

  testWidgets('renders success title and elapsed labels', (tester) async {
    await pumpHarness(
      tester,
      child: const SuccessResultPanel(
        elapsed: Duration(minutes: 4, seconds: 21),
      ),
    );

    expect(find.byKey(SuccessResultPanel.panelKey), findsOneWidget);
    expect(find.byKey(SuccessResultPanel.titleKey), findsOneWidget);
    expect(find.byKey(SuccessResultPanel.elapsedLabelKey), findsOneWidget);
    expect(find.byKey(SuccessResultPanel.elapsedValueKey), findsOneWidget);
    expect(find.text('You Win!'), findsOneWidget);
    expect(find.text('Time elapsed:'), findsOneWidget);
  });

  testWidgets('formats elapsed time in HH:MM:SS format', (tester) async {
    Future<void> expectFormatted(Duration elapsed, String expected) async {
      await pumpHarness(tester, child: SuccessResultPanel(elapsed: elapsed));
      expect(find.text(expected), findsOneWidget);
    }

    await expectFormatted(Duration.zero, '00:00:00');
    await expectFormatted(
      const Duration(minutes: 4, seconds: 21),
      '00:04:21',
    );
    await expectFormatted(
      const Duration(hours: 1),
      '01:00:00',
    );
    await expectFormatted(
      const Duration(hours: 100),
      '100:00:00',
    );
  });

  testWidgets('exposes expected default and custom semantics labels', (tester) async {
    await pumpHarness(
      tester,
      child: const SuccessResultPanel(
        elapsed: Duration(minutes: 4, seconds: 21),
      ),
    );
    expect(find.bySemanticsLabel('You Win'), findsOneWidget);
    expect(find.bySemanticsLabel('Time elapsed 00:04:21'), findsOneWidget);

    await pumpHarness(
      tester,
      child: const SuccessResultPanel(
        elapsed: Duration(minutes: 1, seconds: 2),
        titleSemanticsLabel: 'Victory title',
        elapsedSemanticsLabel: 'Elapsed semantic value',
      ),
    );
    expect(find.bySemanticsLabel('Victory title'), findsOneWidget);
    expect(find.bySemanticsLabel('Elapsed semantic value'), findsOneWidget);
  });

  testWidgets('applies scale presets for phone and tablet', (tester) async {
    await pumpHarness(
      tester,
      child: const SuccessResultPanel(
        elapsed: Duration(seconds: 3),
        scalePreset: SuccessResultPanelScalePreset.phone,
      ),
    );
    final phoneSize = tester.getSize(find.byKey(SuccessResultPanel.panelKey));

    await pumpHarness(
      tester,
      canvas: const Size(834, 1194),
      child: const SuccessResultPanel(
        elapsed: Duration(seconds: 3),
        scalePreset: SuccessResultPanelScalePreset.tablet,
      ),
    );
    final tabletSize = tester.getSize(find.byKey(SuccessResultPanel.panelKey));

    expect(phoneSize.width, 335);
    expect(phoneSize.height, 186);
    expect(tabletSize.width, closeTo(402, 0.01));
    expect(tabletSize.height, closeTo(223.2, 0.01));
  });
}
