import 'package:flutter_test/flutter_test.dart';

import 'support/google_mobile_ads_test_binding.dart';

Future<void> testExecutable(Future<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupGoogleMobileAdsTestMocks();
  await testMain();
}
