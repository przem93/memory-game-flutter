import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// When `true` (via `--dart-define=ADMOB_CONSENT_DEBUG_EEA=true`), consent debug
/// geography is set to EEA. Use only with AdMob test devices; never in production.
const bool kAdmobConsentDebugEea = bool.fromEnvironment(
  'ADMOB_CONSENT_DEBUG_EEA',
  defaultValue: false,
);

/// Runs UMP consent update and form (if required), then initializes Mobile Ads.
///
/// Failures are logged; the app should still launch without crashing.
Future<void> ensureConsentAndMobileAdsReady() async {
  try {
    await _requestConsentInfoUpdate();
    await ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
      if (error != null) {
        debugPrint('Consent form: ${error.message}');
      }
    });
  } catch (e, st) {
    debugPrint('UMP consent flow failed: $e\n$st');
  }

  try {
    await MobileAds.instance.initialize();
  } catch (e, st) {
    debugPrint('MobileAds initialization failed: $e\n$st');
  }
}

Future<void> _requestConsentInfoUpdate() async {
  final params = ConsentRequestParameters(
    tagForUnderAgeOfConsent: false,
    consentDebugSettings: kAdmobConsentDebugEea
        ? ConsentDebugSettings(debugGeography: DebugGeography.debugGeographyEea)
        : null,
  );

  final completer = Completer<void>();
  ConsentInformation.instance.requestConsentInfoUpdate(
    params,
    () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    },
    (FormError error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    },
  );
  await completer.future;
}
