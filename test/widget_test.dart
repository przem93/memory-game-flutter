import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';

void main() {
  testWidgets('App renders root scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryGameApp());

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
