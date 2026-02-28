import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  String renderedAssetName(WidgetTester tester) {
    final svg = tester.widget<SvgPicture>(
      find.byKey(GameCardShell.backgroundAssetKey),
    );
    final loader = svg.bytesLoader as SvgAssetLoader;
    return loader.assetName;
  }

  testWidgets('renders expected shell asset for each card state', (tester) async {
    Future<void> expectAssetForState(GameCardShellState state, String expected) async {
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

      expect(renderedAssetName(tester), expected);
    }

    await expectAssetForState(
      GameCardShellState.hidden,
      'assets/game-screen/reversed-card.svg',
    );
    await expectAssetForState(
      GameCardShellState.revealed,
      'assets/game-screen/Card.svg',
    );
    await expectAssetForState(
      GameCardShellState.matched,
      'assets/game-screen/matched card.svg',
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
