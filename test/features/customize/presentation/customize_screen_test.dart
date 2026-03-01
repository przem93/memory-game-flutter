import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/customize/presentation/customize_screen.dart';
import 'package:memory_game/features/customize/presentation/customize_start_payload.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_grid_option_button.dart';
import 'package:memory_game/features/customize/presentation/widgets/customize_set_selector_field.dart';
import 'package:memory_game/shared/widgets/screen_logo_row.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(home: child));
    await tester.pumpAndSettle();
  }

  testWidgets('composes Customize screen sections and shared shell elements', (
    tester,
  ) async {
    await pumpHarness(tester, child: const CustomizeScreen());

    expect(find.byKey(CustomizeScreen.contentKey), findsOneWidget);
    expect(find.byType(ScreenLogoRow), findsOneWidget);
    expect(find.text('Select set'), findsOneWidget);
    expect(find.text('Cards grid'), findsOneWidget);
    expect(find.byType(CustomizeSetSelectorField), findsOneWidget);
    expect(find.text('Animals'), findsOneWidget);
    expect(find.byType(CustomizeGridOptionButton), findsNWidgets(9));
  });

  testWidgets('emits locked start payload for each supported card count', (
    tester,
  ) async {
    CustomizeStartPayload? emitted;
    const expected = <int, ({int rows, int columns, int pairCount})>{
      8: (rows: 2, columns: 4, pairCount: 4),
      10: (rows: 2, columns: 5, pairCount: 5),
      12: (rows: 3, columns: 4, pairCount: 6),
      14: (rows: 2, columns: 7, pairCount: 7),
      16: (rows: 4, columns: 4, pairCount: 8),
      18: (rows: 3, columns: 6, pairCount: 9),
      20: (rows: 4, columns: 5, pairCount: 10),
      22: (rows: 2, columns: 11, pairCount: 11),
      24: (rows: 4, columns: 6, pairCount: 12),
    };

    await pumpHarness(
      tester,
      child: CustomizeScreen(onStartRequested: (payload) => emitted = payload),
    );

    for (final entry in expected.entries) {
      emitted = null;
      await tester.tap(
        find.byKey(ValueKey<String>('customizeGridOptionsButton-${entry.key}')),
      );
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted?.setKey, CustomizeStartPayload.defaultSetKey);
      expect(emitted?.cardCount, entry.key);
      expect(emitted?.rows, entry.value.rows);
      expect(emitted?.columns, entry.value.columns);
      expect(emitted?.pairCount, entry.value.pairCount);
    }
  });

  testWidgets('marks section titles as semantic headers', (tester) async {
    await pumpHarness(tester, child: const CustomizeScreen());

    final selectSetSemantics = tester.getSemantics(find.text('Select set'));
    expect(selectSetSemantics, matchesSemantics(isHeader: true));

    final cardsGridSemantics = tester.getSemantics(find.text('Cards grid'));
    expect(cardsGridSemantics, matchesSemantics(isHeader: true));
  });
}
