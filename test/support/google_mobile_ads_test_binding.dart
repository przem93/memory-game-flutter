import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';

/// Default anchored adaptive height used for tests (matches AdMob sample behavior).
const double kTestAnchoredAdaptiveBannerHeight = 90.0;

/// Installs a [MethodChannel] mock for `google_mobile_ads` so [AdBannerSlot] can
/// load in widget tests without a platform implementation.
///
/// Unknown methods return `null` so SDK additions do not break the whole suite.
void setupGoogleMobileAdsTestMocks({
  double anchoredAdaptiveHeight = kTestAnchoredAdaptiveBannerHeight,
}) {
  instanceManager = AdInstanceManager('plugins.flutter.io/google_mobile_ads');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(instanceManager.channel, (MethodCall call) async {
    switch (call.method) {
      case 'AdSize#getAnchoredAdaptiveBannerAdSize':
        return anchoredAdaptiveHeight;
      case 'loadBannerAd':
      case 'disposeAd':
        return null;
      default:
        return null;
    }
  });
}
