# Google Mobile Ads (AdMob) — setup (Stage 2)

This document describes the **SDK and platform wiring** added in roadmap Stage 2 (`in-progress-roadmaps/roadmap-admob-bottom-banner.md`). UI slots and banner units are implemented in later stages; see `docs/admob-bottom-banner-spec-lock.md` for layout rules.

## Dependency

- **Package:** [`google_mobile_ads`](https://pub.dev/packages/google_mobile_ads) (declared in `pubspec.yaml`).
- **Initialization:** `MobileAds.instance.initialize()` is called from `lib/main.dart` after `WidgetsFlutterBinding.ensureInitialized()`. Failures are logged and the app still starts (graceful degradation).

## Test vs production App IDs

The repository uses **Google’s sample test App IDs** so local and CI builds work without secrets:

| Platform | Where | Sample test App ID |
|----------|--------|---------------------|
| Android | `android/app/src/main/AndroidManifest.xml` → `com.google.android.gms.ads.APPLICATION_ID` | `ca-app-pub-3940256099942544~3347511713` |
| iOS | `ios/Runner/Info.plist` → `GADApplicationIdentifier` | `ca-app-pub-3940256099942544~1458002511` |

**Production:** Replace these with the real App ID from [AdMob](https://admob.google.com/) for your registered app. Do **not** commit production identifiers if your policy is to keep them private—use local overrides, CI secrets, or native build configuration outside version control.

**Ad unit IDs** (banner, etc.) are wired when implementing the banner slot (Stage 3). Use [Google’s test ad unit IDs](https://developers.google.com/admob/android/test-ads#sample_ad_units) during development.

## iOS: SKAdNetwork

`Info.plist` includes `SKAdNetworkItems` from [AdMob iOS quick start](https://developers.google.com/admob/ios/quick-start#update_your_infoplist). Google may update the recommended list; revisit that page before major releases.

## Android: network permission

`INTERNET` is declared in `android/app/src/main/AndroidManifest.xml` so release builds (not only debug) can load ads.

## Verification

```bash
flutter pub get
flutter analyze
flutter test
```

Smoke builds (debug):

```bash
flutter build apk --debug
flutter build ios --simulator
```

## Related docs

- Roadmap: `in-progress-roadmaps/roadmap-admob-bottom-banner.md`
- Spec lock (layout): `docs/admob-bottom-banner-spec-lock.md`
- Flutter AdMob: [Get started](https://developers.google.com/admob/flutter/quick-start)
