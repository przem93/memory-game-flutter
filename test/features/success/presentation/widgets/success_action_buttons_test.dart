import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/success/presentation/widgets/success_action_buttons.dart';

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

  testWidgets('renders both action labels and buttons', (tester) async {
    await pumpHarness(
      tester,
      child: const SuccessActionButtons(
        onPlayAgainTap: null,
        onCloseTap: null,
      ),
    );

    expect(find.byKey(SuccessActionButtons.sectionKey), findsOneWidget);
    expect(find.byKey(SuccessActionButtons.playAgainButtonKey), findsOneWidget);
    expect(find.byKey(SuccessActionButtons.closeButtonKey), findsOneWidget);
    expect(find.text('Play again'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('invokes callbacks when buttons are enabled', (tester) async {
    var playAgainCalls = 0;
    var closeCalls = 0;

    await pumpHarness(
      tester,
      child: SuccessActionButtons(
        onPlayAgainTap: () => playAgainCalls++,
        onCloseTap: () => closeCalls++,
      ),
    );

    await tester.tap(find.byKey(SuccessActionButtons.playAgainButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SuccessActionButtons.closeButtonKey));
    await tester.pumpAndSettle();

    expect(playAgainCalls, 1);
    expect(closeCalls, 1);
  });

  testWidgets('does not invoke callbacks when buttons are disabled', (tester) async {
    var playAgainCalls = 0;
    var closeCalls = 0;

    await pumpHarness(
      tester,
      child: SuccessActionButtons(
        onPlayAgainTap: () => playAgainCalls++,
        onCloseTap: () => closeCalls++,
        playAgainEnabled: false,
        closeEnabled: false,
      ),
    );

    await tester.tap(find.byKey(SuccessActionButtons.playAgainButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SuccessActionButtons.closeButtonKey));
    await tester.pumpAndSettle();

    expect(playAgainCalls, 0);
    expect(closeCalls, 0);
  });

  testWidgets('exposes semantic labels and enabled state', (tester) async {
    await pumpHarness(
      tester,
      child: const SuccessActionButtons(
        onPlayAgainTap: null,
        onCloseTap: null,
      ),
    );

    final playAgainSemantics = tester.getSemantics(
      find.byKey(SuccessActionButtons.playAgainButtonKey),
    );
    final closeSemantics = tester.getSemantics(
      find.byKey(SuccessActionButtons.closeButtonKey),
    );
    expect(
      playAgainSemantics,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
        label: 'Play again',
      ),
    );
    expect(
      closeSemantics,
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
        label: 'Close',
      ),
    );
  });

  testWidgets('uses locked phone dimensions and vertical gap', (tester) async {
    await pumpHarness(
      tester,
      child: SuccessActionButtons(
        onPlayAgainTap: () {},
        onCloseTap: () {},
      ),
    );

    final playAgainSize = tester.getSize(
      find.byKey(SuccessActionButtons.playAgainButtonKey),
    );
    final closeSize = tester.getSize(find.byKey(SuccessActionButtons.closeButtonKey));
    final playAgainBottom = tester.getBottomLeft(
      find.byKey(SuccessActionButtons.playAgainButtonKey),
    );
    final closeTop = tester.getTopLeft(find.byKey(SuccessActionButtons.closeButtonKey));

    expect(playAgainSize.width, 335);
    expect(playAgainSize.height, 56);
    expect(closeSize.width, 335);
    expect(closeSize.height, 56);
    expect(closeTop.dy - playAgainBottom.dy, closeTo(10, 0.01));
  });

  testWidgets('applies scale preset for tablet', (tester) async {
    await pumpHarness(
      tester,
      canvas: const Size(834, 1194),
      child: SuccessActionButtons(
        onPlayAgainTap: () {},
        onCloseTap: () {},
        scalePreset: SuccessActionButtonsScalePreset.tablet,
      ),
    );

    final playAgainSize = tester.getSize(
      find.byKey(SuccessActionButtons.playAgainButtonKey),
    );
    final closeSize = tester.getSize(find.byKey(SuccessActionButtons.closeButtonKey));
    final playAgainBottom = tester.getBottomLeft(
      find.byKey(SuccessActionButtons.playAgainButtonKey),
    );
    final closeTop = tester.getTopLeft(find.byKey(SuccessActionButtons.closeButtonKey));

    expect(playAgainSize.width, closeTo(402, 0.01));
    expect(playAgainSize.height, closeTo(67.2, 0.01));
    expect(closeSize.width, closeTo(402, 0.01));
    expect(closeSize.height, closeTo(67.2, 0.01));
    expect(closeTop.dy - playAgainBottom.dy, closeTo(12, 0.01));
  });
}
