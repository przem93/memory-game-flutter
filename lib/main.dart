import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memory_game/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Runs before first frame; slight delay is acceptable for Stage 2. Lazy init
  // is an option later if profiling shows a problem.
  try {
    await MobileAds.instance.initialize();
  } catch (e, st) {
    debugPrint('MobileAds initialization failed: $e\n$st');
  }

  runApp(const MemoryGameApp());
}
