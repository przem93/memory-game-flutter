import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';
import 'package:memory_game/features/gameplay/presentation/game_screen.dart';
import 'package:memory_game/features/gameplay/presentation/widgets/game_card_shell.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MemoryGameApp());
    await tester.pumpAndSettle();
  }

  Future<void> openSelectLevel(WidgetTester tester) async {
    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(0)));
    await tester.pumpAndSettle();
  }

  Future<void> expectGameplayStartFromDifficulty(
    WidgetTester tester, {
    required String difficultyLabel,
    required int expectedCardCount,
  }) async {
    await pumpApp(tester);
    await openSelectLevel(tester);

    await tester.tap(find.text(difficultyLabel));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.byType(GameCardShell), findsNWidgets(expectedCardCount));
  }

  testWidgets('starts gameplay config for Simple', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Simple',
      expectedCardCount: 12,
    );
  });

  testWidgets('starts gameplay config for Medium', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Medium',
      expectedCardCount: 16,
    );
  });

  testWidgets('starts gameplay config for Hard', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Hard',
      expectedCardCount: 20,
    );
  });
}
