import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_logo_group.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    Size canvas = const Size(400, 300),
  }) async {
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
      child: const MainMenuLogoGroup(),
    );

    final iconSize = tester.getSize(find.byKey(MainMenuLogoGroup.iconKey));
    final textSize = tester.getSize(find.byKey(MainMenuLogoGroup.textKey));
    final iconBottom =
        tester.getBottomLeft(find.byKey(MainMenuLogoGroup.iconKey)).dy;
    final textTop = tester.getTopLeft(find.byKey(MainMenuLogoGroup.textKey)).dy;

    expect(iconSize, const Size(118, 118));
    expect(textSize, const Size(357, 79));
    expect(textTop - iconBottom, 33);
  });

  testWidgets('applies alignment and spacing API', (tester) async {
    await pumpHarness(
      tester,
      child: const MainMenuLogoGroup(
        alignment: Alignment.bottomRight,
        spacing: 10,
      ),
    );

    final contentTopLeft =
        tester.getTopLeft(find.byKey(MainMenuLogoGroup.contentKey));
    final iconBottom =
        tester.getBottomLeft(find.byKey(MainMenuLogoGroup.iconKey)).dy;
    final textTop = tester.getTopLeft(find.byKey(MainMenuLogoGroup.textKey)).dy;

    expect(contentTopLeft.dx, 43);
    expect(contentTopLeft.dy, 93);
    expect(textTop - iconBottom, 10);
  });

  testWidgets('applies tablet scale preset to dimensions and spacing',
      (tester) async {
    await pumpHarness(
      tester,
      canvas: const Size(520, 340),
      child: const MainMenuLogoGroup(
        scalePreset: MainMenuLogoScalePreset.tablet,
      ),
    );

    final iconSize = tester.getSize(find.byKey(MainMenuLogoGroup.iconKey));
    final textSize = tester.getSize(find.byKey(MainMenuLogoGroup.textKey));
    final iconBottom =
        tester.getBottomLeft(find.byKey(MainMenuLogoGroup.iconKey)).dy;
    final textTop = tester.getTopLeft(find.byKey(MainMenuLogoGroup.textKey)).dy;

    expect(iconSize.width, closeTo(141.6, 0.001));
    expect(iconSize.height, closeTo(141.6, 0.001));
    expect(textSize.width, closeTo(428.4, 0.001));
    expect(textSize.height, closeTo(94.8, 0.001));
    expect(textTop - iconBottom, closeTo(39.6, 0.001));
  });
}
