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

  testWidgets('emits locked start payload for selected card count', (
    tester,
  ) async {
    CustomizeStartPayload? emitted;

    await pumpHarness(
      tester,
      child: CustomizeScreen(onStartRequested: (payload) => emitted = payload),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('customizeGridOptionsButton-24')),
    );
    await tester.pumpAndSettle();

    expect(emitted, isNotNull);
    expect(emitted?.setKey, 'food-set');
    expect(emitted?.cardCount, 24);
    expect(emitted?.rows, 4);
    expect(emitted?.columns, 6);
    expect(emitted?.pairCount, 12);
  });

  testWidgets('marks section titles as semantic headers', (tester) async {
    await pumpHarness(tester, child: const CustomizeScreen());

    final selectSetSemantics = tester.getSemantics(find.text('Select set'));
    expect(selectSetSemantics, matchesSemantics(isHeader: true));

    final cardsGridSemantics = tester.getSemantics(find.text('Cards grid'));
    expect(cardsGridSemantics, matchesSemantics(isHeader: true));
  });
}
