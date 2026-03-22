import 'dart:io';

/// Google sample [banner test ad unit IDs](https://developers.google.com/admob/android/test-ads#sample_ad_units)
/// — safe for development and CI.
const String _testBannerAdUnitAndroid =
    'ca-app-pub-3940256099942544/9214589741';
const String _testBannerAdUnitIos = 'ca-app-pub-3940256099942544/2435281174';

/// Anchored adaptive banner unit ID for the current platform.
///
/// Override at build time (no secrets in repo), e.g.:
/// `--dart-define=ADMOB_BANNER_AD_UNIT_ANDROID=ca-app-pub-.../...`
/// `--dart-define=ADMOB_BANNER_AD_UNIT_IOS=ca-app-pub-.../...`
String anchoredAdaptiveBannerAdUnitId() {
  if (Platform.isAndroid) {
    return const String.fromEnvironment(
      'ADMOB_BANNER_AD_UNIT_ANDROID',
      defaultValue: _testBannerAdUnitAndroid,
    );
  }
  return const String.fromEnvironment(
    'ADMOB_BANNER_AD_UNIT_IOS',
    defaultValue: _testBannerAdUnitIos,
  );
}
