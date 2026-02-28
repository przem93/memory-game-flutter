import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/data/game_icon_set_provider.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_board_grid.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_scene_shell.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_top_bar.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required SelectLevelStartConfig config,
    Size canvas = const Size(393, 852),
    VoidCallback? onCloseTap,
    GameIconSetProvider? iconSetProvider,
    String semanticsLabel = 'Game screen',
    Duration elapsed = Duration.zero,
    Duration mismatchRevealDuration = const Duration(milliseconds: 650),
    Duration timerTick = const Duration(seconds: 1),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: GameScreen(
          startConfig: config,
          seed: 42,
          onCloseTap: onCloseTap,
          iconSetProvider: iconSetProvider,
          elapsed: elapsed,
          mismatchRevealDuration: mismatchRevealDuration,
          timerTick: timerTick,
          semanticsLabel: semanticsLabel,
        ),
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

  testWidgets('supports mismatch resolution with temporary interaction lock', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      config: const SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.simple,
        rows: 3,
        columns: 4,
      ),
      mismatchRevealDuration: const Duration(milliseconds: 100),
      timerTick: const Duration(milliseconds: 100),
    );

    final boardBefore = tester.widget<GameBoardGrid>(find.byType(GameBoardGrid));
    final cards = boardBefore.cards;
    final first = cards.first;
    final second = cards.firstWhere(
      (card) => card.symbolAssetPath != first.symbolAssetPath,
    );
    final third = cards.firstWhere(
      (card) =>
          card.id != first.id &&
          card.id != second.id &&
          card.symbolAssetPath != first.symbolAssetPath,
    );

    await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(first.id)));
    await tester.pump();
    await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(second.id)));
    await tester.pump();

    final boardDuringMismatch = tester.widget<GameBoardGrid>(
      find.byType(GameBoardGrid),
    );
    final mismatchCards = boardDuringMismatch.cards;
    expect(
      mismatchCards.firstWhere((card) => card.id == first.id).state,
      GameCardShellState.revealed,
    );
    expect(
      mismatchCards.firstWhere((card) => card.id == second.id).state,
      GameCardShellState.revealed,
    );
    expect(boardDuringMismatch.isInteractionEnabled, isFalse);

    await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(third.id)));
    await tester.pump();
    final boardAfterLockedTap = tester.widget<GameBoardGrid>(
      find.byType(GameBoardGrid),
    );
    expect(
      boardAfterLockedTap.cards.firstWhere((card) => card.id == third.id).state,
      GameCardShellState.hidden,
    );

    await tester.pump(const Duration(milliseconds: 120));
    final boardAfterResolution = tester.widget<GameBoardGrid>(
      find.byType(GameBoardGrid),
    );
    expect(
      boardAfterResolution.cards.firstWhere((card) => card.id == first.id).state,
      GameCardShellState.hidden,
    );
    expect(
      boardAfterResolution.cards
          .firstWhere((card) => card.id == second.id)
          .state,
      GameCardShellState.hidden,
    );
    expect(boardAfterResolution.isInteractionEnabled, isTrue);
  });

  testWidgets('completes full happy-path game and freezes timer', (tester) async {
    final provider = GameIconSetProvider(
      availableIconAssets: const <String>[
        'assets/sets/food-set/apple-svgrepo-com.svg',
        'assets/sets/food-set/banana-svgrepo-com.svg',
        'assets/sets/food-set/cherry-svgrepo-com.svg',
      ],
    );

    await pumpHarness(
      tester,
      config: const SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.simple,
        rows: 2,
        columns: 2,
      ),
      iconSetProvider: provider,
      mismatchRevealDuration: const Duration(milliseconds: 80),
      timerTick: const Duration(milliseconds: 150),
    );

    await tester.pump(const Duration(milliseconds: 1250));
    final timerBeforeCompletion = tester.widget<Text>(
      find.byKey(GameTopBar.timerTextKey),
    );
    expect(timerBeforeCompletion.data, isNot('00:00:00'));

    final board = tester.widget<GameBoardGrid>(find.byType(GameBoardGrid));
    final grouped = <String, List<String>>{};
    for (final card in board.cards) {
      final symbol = card.symbolAssetPath!;
      grouped.putIfAbsent(symbol, () => <String>[]).add(card.id);
    }
    expect(grouped.length, 2);
    for (final ids in grouped.values) {
      expect(ids.length, 2);
    }

    for (final ids in grouped.values) {
      await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(ids[0])));
      await tester.pump();
      await tester.tap(find.byKey(GameBoardGrid.cardShellKeyFor(ids[1])));
      await tester.pump();
    }

    final completedBoard = tester.widget<GameBoardGrid>(find.byType(GameBoardGrid));
    expect(completedBoard.isInteractionEnabled, isFalse);
    for (final card in completedBoard.cards) {
      expect(card.state, GameCardShellState.matched);
    }

    final frozenTimerValue = tester.widget<Text>(find.byKey(GameTopBar.timerTextKey));
    await tester.pump(const Duration(milliseconds: 1400));
    final timerAfterWait = tester.widget<Text>(find.byKey(GameTopBar.timerTextKey));
    expect(timerAfterWait.data, frozenTimerValue.data);
  });

  testWidgets('falls back to navigator maybePop when onCloseTap not provided', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    late BuildContext rootContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            rootContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    Navigator.of(rootContext).push(
      MaterialPageRoute<void>(
        builder: (_) => const GameScreen(
          startConfig: SelectLevelStartConfig(
            difficulty: SelectLevelDifficulty.simple,
            rows: 3,
            columns: 4,
          ),
          seed: 42,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    await tester.tap(find.byKey(GameTopBar.closeButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsNothing);
  });

  testWidgets('renders recoverable error when icon pool is insufficient', (
    tester,
  ) async {
    final provider = GameIconSetProvider(
      availableIconAssets: const <String>[
        'assets/sets/food-set/apple-svgrepo-com.svg',
        'assets/sets/food-set/banana-svgrepo-com.svg',
      ],
    );

    await pumpHarness(
      tester,
      config: const SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.hard,
        rows: 4,
        columns: 5,
      ),
      iconSetProvider: provider,
    );

    expect(find.byKey(GameScreen.errorKey), findsOneWidget);
    expect(find.textContaining('insufficientIconPool'), findsOneWidget);
    expect(find.byType(GameBoardGrid), findsNothing);
  });

  testWidgets('exposes custom screen semantics label on scene shell', (
    tester,
  ) async {
    await pumpHarness(
      tester,
      config: const SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.medium,
        rows: 4,
        columns: 4,
      ),
      semanticsLabel: 'Gameplay stage 3 shell',
    );

    final shellNode = tester.getSemantics(find.byKey(GameSceneShell.screenKey));
    expect(shellNode.label, contains('Gameplay stage 3 shell'));
  });
}
