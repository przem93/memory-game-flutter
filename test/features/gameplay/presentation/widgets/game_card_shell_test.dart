import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';

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

  Color renderedFillColor(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.byKey(GameCardShell.backgroundAssetKey),
    );
    final decoration = box.decoration as BoxDecoration;
    return decoration.color!;
  }

  testWidgets('renders expected shell fill style for each card state', (tester) async {
    Future<void> expectFillForState(GameCardShellState state, Color expected) async {
      await pumpHarness(
        tester,
        child: Center(
          child: SizedBox(
            width: 80,
            height: 120,
            child: GameCardShell(state: state),
          ),
        ),
      );

      expect(renderedFillColor(tester), expected);
    }

    await expectFillForState(
      GameCardShellState.hidden,
      const Color(0xFFF3F3F3),
    );
    await expectFillForState(
      GameCardShellState.revealed,
      const Color(0xFFFFFFFF),
    );
    await expectFillForState(
      GameCardShellState.matched,
      const Color(0xFF03EBD0),
    );
  });

  testWidgets('renders child content centered on card shell', (tester) async {
    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 90,
          height: 130,
          child: const GameCardShell(
            state: GameCardShellState.revealed,
            child: Text('PAIR_ICON'),
          ),
        ),
      ),
    );

    expect(find.text('PAIR_ICON'), findsOneWidget);
  });

  testWidgets('fills available constraints without screen hardcoding', (tester) async {
    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 76.25,
          height: 114.5,
          child: const GameCardShell(state: GameCardShellState.hidden),
        ),
      ),
    );

    final shellSize = tester.getSize(find.byKey(GameCardShell.shellKey));
    expect(shellSize.width, 76.25);
    expect(shellSize.height, 114.5);
  });

  testWidgets('exposes semantic label and enabled state contract', (tester) async {
    await pumpHarness(
      tester,
      child: Center(
        child: SizedBox(
          width: 80,
          height: 120,
          child: const GameCardShell(
            state: GameCardShellState.hidden,
            semanticLabel: 'Hidden card',
            semanticEnabled: false,
          ),
        ),
      ),
    );

    final semanticsNode = tester.getSemantics(find.byKey(GameCardShell.shellKey));
    expect(
      semanticsNode,
      matchesSemantics(
        hasEnabledState: true,
        isEnabled: false,
        label: 'Hidden card',
      ),
    );
  });
}
