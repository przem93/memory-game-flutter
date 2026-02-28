import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_face_content.dart';
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
      find.byKey(GameCardFaceContent.overlayAssetKey),
    );
    final loader = svg.bytesLoader as SvgAssetLoader;
    return loader.assetName;
  }

  testWidgets('renders card brain overlay for hidden state', (tester) async {
    await pumpHarness(
      tester,
      child: const SizedBox(
        width: 76.25,
        height: 114.5,
        child: GameCardFaceContent(state: GameCardShellState.hidden),
      ),
    );

    expect(renderedAssetName(tester), GameCardFaceContent.hiddenAssetPath);
  });

  testWidgets('renders provided symbol asset for revealed and matched states', (
    tester,
  ) async {
    const symbolAssetPath = 'assets/sets/food-set/apple-svgrepo-com.svg';

    Future<void> expectAssetForState(GameCardShellState state) async {
      await pumpHarness(
        tester,
        child: SizedBox(
          width: 76.25,
          height: 114.5,
          child: GameCardFaceContent(
            state: state,
            symbolAssetPath: symbolAssetPath,
          ),
        ),
      );

      expect(renderedAssetName(tester), symbolAssetPath);
    }

    await expectAssetForState(GameCardShellState.revealed);
    await expectAssetForState(GameCardShellState.matched);
  });

  testWidgets('exposes default semantic labels by state', (tester) async {
    await pumpHarness(
      tester,
      child: const SizedBox(
        width: 76.25,
        height: 114.5,
        child: GameCardFaceContent(state: GameCardShellState.hidden),
      ),
    );

    final hiddenNode = tester.getSemantics(find.byKey(GameCardFaceContent.rootKey));
    expect(
      hiddenNode,
      matchesSemantics(
        hasEnabledState: true,
        isEnabled: true,
        isImage: true,
        label: 'Hidden card symbol',
      ),
    );

    await pumpHarness(
      tester,
      child: const SizedBox(
        width: 76.25,
        height: 114.5,
        child: GameCardFaceContent(
          state: GameCardShellState.revealed,
          symbolAssetPath: 'assets/sets/food-set/apple-svgrepo-com.svg',
        ),
      ),
    );

    final revealedNode = tester.getSemantics(
      find.byKey(GameCardFaceContent.rootKey),
    );
    expect(
      revealedNode,
      matchesSemantics(
        hasEnabledState: true,
        isEnabled: true,
        isImage: true,
        label: 'Card symbol',
      ),
    );
  });

  testWidgets('supports semantic label override and enabled state contract', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      child: const SizedBox(
        width: 76.25,
        height: 114.5,
        child: GameCardFaceContent(
          state: GameCardShellState.matched,
          symbolAssetPath: 'assets/sets/food-set/cherry-svgrepo-com.svg',
          semanticLabel: 'Matched cherry symbol',
          semanticEnabled: false,
        ),
      ),
    );

    final node = tester.getSemantics(find.byKey(GameCardFaceContent.rootKey));
    expect(
      node,
      matchesSemantics(
        hasEnabledState: true,
        isEnabled: false,
        isImage: true,
        label: 'Matched cherry symbol',
      ),
    );
  });
}
