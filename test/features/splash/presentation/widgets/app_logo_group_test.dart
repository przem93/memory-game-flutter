import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/splash/presentation/widgets/app_logo_group.dart';
import 'package:memory_game/shared/theme/splash_typography.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders icon and text by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(const AppLogoGroup()),
    );

    expect(find.byType(Image), findsNWidgets(2));
    expect(find.bySemanticsLabel('Memory game logo'), findsOneWidget);
  });

  testWidgets('renders icon only variant', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const AppLogoGroup(
          variant: AppLogoGroupVariant.iconOnly,
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('applies custom spacing between icon and text',
      (WidgetTester tester) async {
    const double customSpacing = 12;

    await tester.pumpWidget(
      wrap(const AppLogoGroup(spacing: customSpacing)),
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is SizedBox && widget.height == customSpacing,
      ),
      findsOneWidget,
    );
  });

  testWidgets('uses spacing token when spacing is not provided',
      (WidgetTester tester) async {
    const double spacingFromTheme = 52;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            SplashTypography.fallback().copyWith(
              iconToWordmarkSpacing: spacingFromTheme,
            ),
          ],
        ),
        home: const Scaffold(body: AppLogoGroup()),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is SizedBox && widget.height == spacingFromTheme,
      ),
      findsOneWidget,
    );
  });

  testWidgets('can render text-based wordmark using splash typography tokens',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const AppLogoGroup(
          useTextWordmark: true,
          wordmarkText: 'MEMORY',
        ),
      ),
    );

    final Text wordmark = tester.widget<Text>(find.text('MEMORY'));
    expect(wordmark.style?.fontFamily, equals('DynaPuff'));
    expect(wordmark.style?.fontWeight, equals(FontWeight.w700));
  });
}
