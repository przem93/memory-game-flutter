import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/main_menu/presentation/main_menu_screen.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_action_section.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_background.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_developer_brand.dart';
import 'package:memory_game/features/main_menu/presentation/widgets/main_menu_logo_group.dart';
import 'package:memory_game/features/select_level/presentation/select_level_screen.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('MainMenuScreen renders full composition', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(MainMenuBackground), findsOneWidget);
    expect(find.byType(MainMenuLogoGroup), findsOneWidget);
    expect(find.byType(MainMenuActionSection), findsOneWidget);
    expect(find.byType(MainMenuDeveloperBrand), findsOneWidget);
    expect(find.text('QUICK PLAY'), findsOneWidget);
    expect(find.text('CUSTOMIZE'), findsOneWidget);
  });

  testWidgets('MainMenuScreen fires action callbacks', (
    WidgetTester tester,
  ) async {
    var quickPlayTapCount = 0;
    var customizeTapCount = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: MainMenuScreen(
          onQuickPlayPressed: () => quickPlayTapCount++,
          onCustomizePressed: () => customizeTapCount++,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(0)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(1)));
    await tester.pumpAndSettle();

    expect(quickPlayTapCount, 1);
    expect(customizeTapCount, 1);
  });

  testWidgets('Quick Play can navigate to SelectLevelScreen', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MainMenuScreen(
            onQuickPlayPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SelectLevelScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(MainMenuActionSection.actionButtonKeyAt(0)));
    await tester.pumpAndSettle();

    expect(find.byType(SelectLevelScreen), findsOneWidget);
  });
}
