import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_board_grid.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_top_bar.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required SelectLevelStartConfig config,
    Size canvas = const Size(393, 852),
    VoidCallback? onCloseTap,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: GameScreen(startConfig: config, seed: 42, onCloseTap: onCloseTap),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders expected card count for all roadmap difficulties', (
    tester,
  ) async {
    const configs = <SelectLevelStartConfig>[
      SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.simple,
        rows: 3,
        columns: 4,
      ),
      SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.medium,
        rows: 4,
        columns: 4,
      ),
      SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.hard,
        rows: 4,
        columns: 5,
      ),
    ];

    for (final config in configs) {
      await pumpHarness(tester, config: config);

      expect(find.byType(GameScreen), findsOneWidget);
      expect(
        find.byType(GameCardShell),
        findsNWidgets(config.rows * config.columns),
      );
      expect(
        find.bySemanticsLabel(
          'Game board ${config.rows}x${config.columns} with ${config.rows * config.columns} cards',
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('renders timer and close semantics in top bar', (tester) async {
    var closeTapped = false;
    await pumpHarness(
      tester,
      config: const SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.simple,
        rows: 3,
        columns: 4,
      ),
      onCloseTap: () => closeTapped = true,
    );

    expect(find.text('00:00:00'), findsOneWidget);

    final timerRowNode = tester.getSemantics(
      find.byKey(GameTopBar.timerRowKey),
    );
    expect(timerRowNode.label, contains('Elapsed time 00:00:00'));

    final closeNode = tester.getSemantics(
      find.byKey(GameTopBar.closeButtonKey),
    );
    expect(closeNode.label, contains('Close game'));

    await tester.tap(find.byKey(GameTopBar.closeButtonKey));
    await tester.pumpAndSettle();
    expect(closeTapped, isTrue);
  });

  testWidgets('binds provider icon asset path to each board card', (tester) async {
    await pumpHarness(
      tester,
      config: const SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.medium,
        rows: 4,
        columns: 4,
      ),
    );

    final boardGrid = tester.widget<GameBoardGrid>(find.byType(GameBoardGrid));
    expect(boardGrid.cards, hasLength(16));

    for (final card in boardGrid.cards) {
      final symbolAssetPath = card.symbolAssetPath;
      expect(symbolAssetPath, isNotNull);
      expect(symbolAssetPath, isNotEmpty);
      expect(symbolAssetPath, startsWith('assets/sets/food-set/'));
      expect(symbolAssetPath, endsWith('.svg'));
    }
  });
}
