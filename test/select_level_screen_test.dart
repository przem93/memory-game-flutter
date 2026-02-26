import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/select_level_screen.dart';
import 'package:memory_game/features/select_level/presentation/select_level_start_config.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_option_button.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_options_section.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_scene_shell.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_title.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester, {VoidCallback? onBuild}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            onBuild?.call();
            return const SelectLevelScreen();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders full select level composition', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    expect(find.byType(SelectLevelSceneShell), findsOneWidget);
    expect(find.byType(SelectLevelTitle), findsOneWidget);
    expect(find.byType(SelectLevelOptionsSection), findsOneWidget);
    expect(find.byKey(SelectLevelScreen.logoSlotKey), findsOneWidget);
    expect(find.byKey(SelectLevelScreen.titleSlotKey), findsOneWidget);
    expect(find.byKey(SelectLevelScreen.optionsSlotKey), findsOneWidget);
    expect(find.text('Select level'), findsOneWidget);
  });

  testWidgets('updates selection and emits start config on tap', (
    WidgetTester tester,
  ) async {
    final startConfigs = <SelectLevelStartConfig>[];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 852);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SelectLevelScreen(
          onStartRequested: (startConfig) => startConfigs.add(startConfig),
        ),
      ),
    );
    await tester.pumpAndSettle();

    var options = tester.widgetList<SelectLevelOptionButton>(
      find.byType(SelectLevelOptionButton),
    );
    expect(options.elementAt(0).isSelected, isTrue);
    expect(options.elementAt(1).isSelected, isFalse);
    expect(options.elementAt(2).isSelected, isFalse);

    await tester.tap(find.text('Medium'));
    await tester.pumpAndSettle();

    options = tester.widgetList<SelectLevelOptionButton>(
      find.byType(SelectLevelOptionButton),
    );
    expect(options.elementAt(0).isSelected, isFalse);
    expect(options.elementAt(1).isSelected, isTrue);
    expect(options.elementAt(2).isSelected, isFalse);
    expect(startConfigs, hasLength(1));
    expect(startConfigs.single.difficulty, SelectLevelDifficulty.medium);
    expect(startConfigs.single.rows, 4);
    expect(startConfigs.single.columns, 4);

    await tester.tap(find.text('Hard'));
    await tester.pumpAndSettle();

    expect(startConfigs, hasLength(2));
    expect(startConfigs.last.difficulty, SelectLevelDifficulty.hard);
    expect(startConfigs.last.rows, 4);
    expect(startConfigs.last.columns, 5);
  });
}
