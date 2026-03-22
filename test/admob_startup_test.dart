import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/core/admob_startup.dart';

import 'support/google_mobile_ads_test_binding.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(setupGoogleMobileAdsTestMocks);

  test('ensureConsentAndMobileAdsReady completes without throwing', () async {
    await ensureConsentAndMobileAdsReady();
  });
}
