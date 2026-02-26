import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';
import 'package:memory_game/features/gameplay/presentation/gameplay_board_init_screen.dart';
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
    required String expectedText,
  }) async {
    await pumpApp(tester);
    await openSelectLevel(tester);

    await tester.tap(find.text(difficultyLabel));
    await tester.pumpAndSettle();

    expect(find.byType(GameplayBoardInitScreen), findsOneWidget);
    expect(find.text(expectedText), findsOneWidget);
  }

  testWidgets('starts gameplay config for Simple', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Simple',
      expectedText: 'SIMPLE 3x4 pairs:6',
    );
  });

  testWidgets('starts gameplay config for Medium', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Medium',
      expectedText: 'MEDIUM 4x4 pairs:8',
    );
  });

  testWidgets('starts gameplay config for Hard', (WidgetTester tester) async {
    await expectGameplayStartFromDifficulty(
      tester,
      difficultyLabel: 'Hard',
      expectedText: 'HARD 4x5 pairs:10',
    );
  });
}
