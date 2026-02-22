# Manual Release Checklist

Current release process is manual for both Android and iOS.

## Pre-release (Both Platforms)

- [ ] Confirm changelog and release notes are updated.
- [ ] Verify app version is bumped appropriately.
- [ ] Run `flutter analyze` and `flutter test`.
- [ ] Smoke test core game flow on physical devices.
- [ ] Verify privacy policy and data usage statements are up to date.

## Android (Google Play)

- [ ] Validate signing configuration and keystore availability.
- [ ] Verify package id, `versionCode`, and `versionName`.
- [ ] Build release artifact (AAB/APK as required).
- [ ] Upload build to Play Console and complete release notes.
- [ ] Verify Data safety section and store assets/screenshots.

## iOS (App Store)

- [ ] Validate signing identity, provisioning profile, and bundle id.
- [ ] Build/archive iOS release in Xcode/Flutter flow.
- [ ] Upload build to App Store Connect.
- [ ] Verify privacy nutrition labels and metadata.
- [ ] Run TestFlight smoke verification before production rollout.

## Release Decision

- [ ] Block release if critical crashes, gameplay regressions, or compliance issues exist.
- [ ] If production issue occurs, prepare hotfix branch and targeted rollback plan.
