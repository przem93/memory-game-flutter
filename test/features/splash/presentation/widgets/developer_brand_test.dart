import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/features/splash/presentation/widgets/developer_brand.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders developer logo when enabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(const DeveloperBrand(enabled: true)),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.bySemanticsLabel('Developer brand logo'), findsOneWidget);
  });

  testWidgets('renders nothing when disabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(const DeveloperBrand()),
    );

    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('applies custom bottom offset', (WidgetTester tester) async {
    const double bottomOffset = 40;

    await tester.pumpWidget(
      wrap(const DeveloperBrand(enabled: true, bottomOffset: bottomOffset)),
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Padding &&
            widget.padding is EdgeInsets &&
            (widget.padding as EdgeInsets).bottom == bottomOffset,
      ),
      findsOneWidget,
    );
  });
}
