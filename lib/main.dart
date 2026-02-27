import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:memory_game/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MemoryGameApp());
}
