import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/app.dart';
import 'package:memory_game/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App starts on splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryGameApp());

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
