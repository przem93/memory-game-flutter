import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(393, 852),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = canvas;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: canvas.width,
            height: canvas.height,
            child: child,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders locked baseline phone geometry', (tester) async {
    await pumpHarness(
      tester,
      child: const MainMenuDeveloperBrand(),
    );

    final logoSize = tester.getSize(find.byKey(MainMenuDeveloperBrand.logoKey));
    final logoTopLeft =
        tester.getTopLeft(find.byKey(MainMenuDeveloperBrand.logoKey));
    final logoBottom =
        tester.getBottomLeft(find.byKey(MainMenuDeveloperBrand.logoKey)).dy;

    expect(logoSize, const Size(119, 65));
    expect(logoTopLeft.dx, 137);
    expect(852 - logoBottom, 20);
  });

  testWidgets('applies tablet preset and exposes semantics', (tester) async {
    await pumpHarness(
      tester,
      child: const MainMenuDeveloperBrand(
        scalePreset: MainMenuDeveloperBrandScalePreset.tablet,
      ),
    );

    final logoSize = tester.getSize(find.byKey(MainMenuDeveloperBrand.logoKey));
    final logoBottom =
        tester.getBottomLeft(find.byKey(MainMenuDeveloperBrand.logoKey)).dy;

    final semantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Piar Games',
      ),
    );

    expect(logoSize.width, closeTo(142.8, 0.001));
    expect(logoSize.height, closeTo(78, 0.001));
    expect(852 - logoBottom, 24);
    expect(semantics.properties.image, true);
    expect(semantics.properties.label, 'Piar Games');
  });
}
