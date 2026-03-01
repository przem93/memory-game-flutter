import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/success/presentation/success_screen.dart';
import 'package:memory_game/features/success/presentation/widgets/success_action_buttons.dart';
import 'package:memory_game/features/success/presentation/widgets/success_result_panel.dart';
import 'package:memory_game/features/success/presentation/widgets/success_scene_shell.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

void main() {
  const simpleConfig = SelectLevelStartConfig(
    difficulty: SelectLevelDifficulty.simple,
    rows: 3,
    columns: 4,
  );

  Future<void> pumpSuccessScreen(
    WidgetTester tester, {
    Duration elapsed = const Duration(minutes: 4, seconds: 21),
    SelectLevelStartConfig startConfig = simpleConfig,
    VoidCallback? onPlayAgainTap,
    VoidCallback? onCloseTap,
    Size canvas = const Size(393, 852),
    String semanticsLabel = 'Success screen',
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SuccessScreen(
          elapsed: elapsed,
          startConfig: startConfig,
          onPlayAgainTap: onPlayAgainTap,
          onCloseTap: onCloseTap,
          semanticsLabel: semanticsLabel,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders Stage 3 success composition with result and actions', (
    WidgetTester tester,
  ) async {
    await pumpSuccessScreen(tester);

    expect(find.byType(SuccessSceneShell), findsOneWidget);
    expect(find.byType(ScreenLogoRow), findsOneWidget);
    expect(find.byType(SuccessResultPanel), findsOneWidget);
    expect(find.byType(SuccessActionButtons), findsOneWidget);
    expect(find.text('You Won!'), findsAtLeastNWidgets(1));
    expect(find.text('Time elapsed:'), findsOneWidget);
    expect(find.text('00:04:21'), findsOneWidget);
    expect(find.text('Play again'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.byKey(SuccessScreen.logoSlotKey), findsOneWidget);
    expect(find.byKey(SuccessScreen.resultPanelSlotKey), findsOneWidget);
    expect(find.byKey(SuccessScreen.actionsSlotKey), findsOneWidget);
  });

  testWidgets('fires provided callbacks for play again and close', (
    WidgetTester tester,
  ) async {
    var playAgainCalls = 0;
    var closeCalls = 0;

    await pumpSuccessScreen(
      tester,
      onPlayAgainTap: () => playAgainCalls++,
      onCloseTap: () => closeCalls++,
    );

    await tester.tap(find.text('Play again'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(playAgainCalls, 1);
    expect(closeCalls, 1);
  });

  testWidgets(
    'default play again starts a new game round with same difficulty',
    (WidgetTester tester) async {
      const startConfig = SelectLevelStartConfig(
        difficulty: SelectLevelDifficulty.hard,
        rows: 4,
        columns: 5,
      );

      await pumpSuccessScreen(tester, startConfig: startConfig);

      await tester.tap(find.text('Play again'));
      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsOneWidget);
      final gameScreen = tester.widget<GameScreen>(find.byType(GameScreen));
      expect(gameScreen.startConfig.difficulty, SelectLevelDifficulty.hard);
      expect(gameScreen.startConfig.rows, 4);
      expect(gameScreen.startConfig.columns, 5);
    },
  );

  testWidgets('default close exits success flow to main menu', (
    WidgetTester tester,
  ) async {
    await pumpSuccessScreen(tester);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(MainMenuScreen), findsOneWidget);
    expect(find.byType(SuccessScreen), findsNothing);
  });

  testWidgets('exposes custom semantics label on shell', (
    WidgetTester tester,
  ) async {
    await pumpSuccessScreen(
      tester,
      semanticsLabel: 'Success stage 3 composition',
    );

    final shellNode = tester.getSemantics(
      find.byKey(SuccessSceneShell.screenKey),
    );
    expect(shellNode.label, contains('Success stage 3 composition'));
  });
}
