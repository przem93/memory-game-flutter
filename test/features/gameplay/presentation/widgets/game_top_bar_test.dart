import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_top_bar.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
    await tester.pumpAndSettle();
  }

  testWidgets('renders top rows, logo tile, timer and close button', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: const GameTopBar(
        elapsed: Duration(minutes: 3, seconds: 45),
        scalePreset: GameTopBarScalePreset.phone,
      ),
    );

    expect(find.byKey(GameTopBar.topRowKey), findsOneWidget);
    expect(find.byKey(GameTopBar.timerRowKey), findsOneWidget);
    expect(find.byKey(GameTopBar.logoIconTileKey), findsOneWidget);
    expect(find.byKey(GameTopBar.timerTextKey), findsOneWidget);
    expect(find.byKey(GameTopBar.closeButtonKey), findsOneWidget);
    expect(find.text('CLOSE'), findsOneWidget);
  });

  testWidgets('renders elapsed time in HH:MM:SS format', (tester) async {
    Future<void> expectFormatted(Duration elapsed, String expected) async {
      await pumpHarness(
        tester,
        child: GameTopBar(
          elapsed: elapsed,
          scalePreset: GameTopBarScalePreset.phone,
          onCloseTap: () {},
        ),
      );
      expect(find.text(expected), findsOneWidget);
    }

    await expectFormatted(Duration.zero, '00:00:00');
    await expectFormatted(
      const Duration(minutes: 3, seconds: 45),
      '00:03:45',
    );
    await expectFormatted(
      const Duration(hours: 12, minutes: 34, seconds: 56),
      '12:34:56',
    );
  });

  testWidgets('exposes close button semantics for enabled and disabled states', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: const GameTopBar(
        elapsed: Duration(seconds: 1),
        scalePreset: GameTopBarScalePreset.phone,
      ),
    );

    final disabledNode = tester.getSemantics(find.byKey(GameTopBar.closeButtonKey));
    expect(
      disabledNode,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
        label: 'Close game',
      ),
    );

    var tapped = false;
    await pumpHarness(
      tester,
      child: GameTopBar(
        elapsed: const Duration(seconds: 1),
        scalePreset: GameTopBarScalePreset.phone,
        onCloseTap: () => tapped = true,
      ),
    );

    final enabledNode = tester.getSemantics(find.byKey(GameTopBar.closeButtonKey));
    expect(
      enabledNode,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        label: 'Close game',
      ),
    );

    await tester.tap(find.byKey(GameTopBar.closeButtonKey));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
