import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/select_level/presentation/widgets/select_level_title.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    required Widget child,
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 201, child: child),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders default Select level label', (tester) async {
    await pumpHarness(tester, child: const SelectLevelTitle());

    expect(find.byType(SelectLevelTitle), findsOneWidget);
    expect(find.text('Select level'), findsOneWidget);
  });

  testWidgets('uses expected typography', (tester) async {
    await pumpHarness(tester, child: const SelectLevelTitle());

    final label = tester.widget<Text>(find.byKey(SelectLevelTitle.labelKey));
    final style = label.style;
    expect(style, isNotNull);
    expect(style!.fontFamily, 'DynaPuff');
    expect(style.fontWeight, FontWeight.w700);
    expect(style.fontSize, 32);
    expect(style.letterSpacing, 0);
    expect(style.height, 1);
    expect(style.color, const Color(0xFFFFFFFF));
  });

  testWidgets('clamps text scale to maxTextScaleFactor', (tester) async {
    await pumpHarness(
      tester,
      child: const SelectLevelTitle(),
      textScaler: TextScaler.linear(2),
    );

    final label = tester.widget<Text>(find.byKey(SelectLevelTitle.labelKey));
    expect(label.textScaler, isNotNull);
    expect(label.textScaler!.scale(1), 1.2);
  });
}
