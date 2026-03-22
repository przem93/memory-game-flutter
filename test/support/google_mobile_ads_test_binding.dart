import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:google_mobile_ads/src/ump/user_messaging_codec.dart';

/// Default anchored adaptive height used for tests (matches AdMob sample behavior).
const double kTestAnchoredAdaptiveBannerHeight = 90.0;

/// UMP channel name (must match [UserMessagingChannel] in `google_mobile_ads`).
const String kGoogleMobileAdsUmpChannelName =
    'plugins.flutter.io/google_mobile_ads/ump';

/// Installs [MethodChannel] mocks for `google_mobile_ads` and UMP so
/// [AdBannerSlot], consent APIs, and [MobileAds.initialize] work in tests.
///
/// Unknown methods on the main ads channel return `null` so SDK additions do not
/// break the whole suite.
void setupGoogleMobileAdsTestMocks({
  double anchoredAdaptiveHeight = kTestAnchoredAdaptiveBannerHeight,
}) {
  instanceManager = AdInstanceManager('plugins.flutter.io/google_mobile_ads');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(instanceManager.channel, (
        MethodCall call,
      ) async {
        switch (call.method) {
          case 'MobileAds#initialize':
            return InitializationStatus(<String, AdapterStatus>{
              'com.google.android.gms.ads.MobileAds': AdapterStatus(
                AdapterInitializationState.ready,
                'test',
                0,
              ),
            });
          case '_init':
          case 'MobileAds#setSameAppKeyEnabled':
          case 'MobileAds#setAppMuted':
          case 'MobileAds#setAppVolume':
          case 'MobileAds#disableSDKCrashReporting':
          case 'MobileAds#disableMediationInitialization':
          case 'MobileAds#updateRequestConfiguration':
          case 'MobileAds#registerWebView':
            return null;
          case 'AdSize#getAnchoredAdaptiveBannerAdSize':
            return anchoredAdaptiveHeight;
          case 'loadBannerAd':
          case 'disposeAd':
            return null;
          default:
            return null;
        }
      });

  final umpChannel = MethodChannel(
    kGoogleMobileAdsUmpChannelName,
    StandardMethodCodec(UserMessagingCodec()),
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(umpChannel, (MethodCall call) async {
        switch (call.method) {
          case 'ConsentInformation#requestConsentInfoUpdate':
            return null;
          case 'UserMessagingPlatform#loadAndShowConsentFormIfRequired':
            return null;
          case 'ConsentInformation#getPrivacyOptionsRequirementStatus':
            return 0;
          case 'ConsentInformation#isConsentFormAvailable':
            return false;
          case 'ConsentInformation#getConsentStatus':
            return 0;
          case 'ConsentInformation#canRequestAds':
            return true;
          case 'ConsentInformation#reset':
          case 'UserMessagingPlatform#loadConsentForm':
          case 'ConsentForm#show':
          case 'ConsentForm#dispose':
            return null;
          case 'UserMessagingPlatform#showPrivacyOptionsForm':
            return null;
          default:
            return null;
        }
      });
}
