import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_set/presentation/select_set_screen.dart';
import 'package:memory_game/features/select_set/presentation/widgets/select_set_option_button.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required ValueChanged<String> onSetSelected,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SelectSetScreen(
          initialSelectedSetKey: 'food-set',
          onSetSelected: onSetSelected,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders logo, title, and set options section', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester, onSetSelected: (_) {});

    expect(find.byKey(SelectSetScreen.contentKey), findsOneWidget);
    expect(find.byKey(SelectSetScreen.logoSlotKey), findsOneWidget);
    expect(find.byKey(SelectSetScreen.titleSlotKey), findsOneWidget);
    expect(find.byKey(SelectSetScreen.optionsSlotKey), findsOneWidget);
    expect(find.byType(ScreenLogoRow), findsOneWidget);
    expect(find.text('Select set'), findsOneWidget);
    expect(find.byType(SelectSetOptionButton), findsNWidgets(2));
  });

  testWidgets('calls onSetSelected and pops Navigator on set tap', (
    WidgetTester tester,
  ) async {
    String? selected;
    await pumpScreen(
      tester,
      onSetSelected: (setKey) => selected = setKey,
    );

    expect(find.byType(SelectSetScreen), findsOneWidget);

    await tester.tap(find.text('Animals'));
    await tester.pumpAndSettle();

    expect(selected, 'animals-set');
    expect(find.byType(SelectSetScreen), findsNothing);
  });

  testWidgets('title is marked as semantic header', (WidgetTester tester) async {
    await pumpScreen(tester, onSetSelected: (_) {});

    final semantics = tester.getSemantics(find.text('Select set'));
    expect(semantics.flagsCollection.isHeader, isTrue);
  });
}
