# Implementation Roadmap - Splash Screen (component-first)

This document describes the implementation plan for the first screen (`Splash/Loading`) using the following approach:
- reusable components first,
- full screen integration second,
- 1:1 validation against Figma at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run).
2. Before visual UI implementation starts, `Spec Lock` for node `1:55` must be completed.
3. Do not move to the next screen until splash reaches `accepted` status.

## Stage 0 - Flutter Project Bootstrap (completed)

Scope:
- initialize the Flutter project in the repository (Android + iOS),
- configure `pubspec.yaml` for SVG and DynaPuff fonts,
- prepare the base structure for upcoming screens.

Gate:
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter run` (debug)

## Stage 1 - Spec Lock for splash (`node 1:55`)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame dimensions and safe area,
- positions and sizes of elements (`background`, `logo-icon`, `logo-text`, `developer-logo`, optional `brain`),
- colors (hex/opacity),
- typography (family, weight, size, line-height, letter-spacing),
- layer order and alignment.

Output:
- `Spec Lock` table (final values) added to this file or a separate reference file.

Status:
- `accepted-with-fallback` (implemented based on reference screenshot measurements).
- Final strict 1:1 closure planned after Figma MCP access is available.
- Metrics reference: `docs/splash-spec-lock.md`.

Stage 1 Gate:
- `done` (Stage 2.1 `AppBackground` can start).

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently:

### 2.1 `AppBackground`
- render `assets/background.svg`,
- responsive scaling and positioning (phone/tablet),
- no hardcoded position for a single phone model.

Gate:
- `flutter analyze`
- background-only comparison screenshot.

### 2.2 `AppLogoGroup`
- logo group (`logo-icon.svg` + `logo-text.svg`, optional variant with `brain.svg`),
- component API: variant, alignment, spacing.

Gate:
- `flutter analyze`
- widget test for API variants and layout.

### 2.3 `DeveloperBrand`
- separate bottom-footer component based on `assets/developer-logo.svg`,
- positioning relative to bottom edge and safe areas.

Status:
- `done` (widget + integration + tests + validation on 2 screen heights).
- Validation artifacts: `test/features/splash/presentation/screens/goldens/splash_screen_step_2_3_h852.png`, `test/features/splash/presentation/screens/goldens/splash_screen_step_2_3_h740.png`.

Gate:
- `flutter analyze`
- component comparison screenshot on 2 screen heights.

### 2.4 `SplashTypography`
- map text styles to tokens (`ThemeExtension` or dedicated style map),
- use `DynaPuff`, `DynaPuffCondensed`, `DynaPuffSemiCondensed` families.

Gate:
- `flutter analyze`
- style tests (smoke widget test).

## Stage 3 - `SplashScreenComposition` Integration

Scope:
- compose the splash screen from completed components,
- map layers and spacing 1:1 according to `Spec Lock`,
- add accessibility semantics where relevant.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

## Stage 4 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match Figma,
- typography matches Figma,
- colors and contrast match Figma,
- SVG proportions match Figma,
- result is correct on Android and iOS.

Artifacts:
- 2 comparison screenshots (at least 2 resolutions),
- deviations list (`known deviations`) or `none`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

## Stage 5 - Cursor Rules for Future Screens

After finishing splash, add permanent rules in `.cursor/rules`:
- `screen-by-screen` workflow,
- `component-first` workflow,
- mandatory `Spec Lock` before visual implementation,
- mandatory 1:1 validation after screen integration.

## Stage 6 - Native Launch Replacement (`LaunchTheme` / `LaunchScreen`) [IN PROGRESS]

Goal: align native startup screens with the splash visual direction so users see consistent branding before Flutter renders the first frame.

### 6.1 Preferred path - `flutter_native_splash`
- add dependency: `flutter pub add flutter_native_splash --dev`,
- configure `flutter_native_splash` in `pubspec.yaml`:
  - base background color (matching splash background),
  - launch icon/image asset,
  - Android + iOS enabled,
  - Android 12 specific section (`android_12`) with dedicated icon and color,
- run generator: `dart run flutter_native_splash:create`,
- verify generated native resources in Android/iOS projects.

### 6.2 Manual fallback path (if generator constraints appear)
- Android:
  - update `android/app/src/main/res/values/styles.xml` (`LaunchTheme`),
  - update `android/app/src/main/res/drawable/launch_background.xml`,
  - ensure Android 12 compatibility via `values-v31/styles.xml`,
- iOS:
  - keep `UILaunchStoryboardName` in `ios/Runner/Info.plist`,
  - update `ios/Runner/Base.lproj/LaunchScreen.storyboard` layout and assets.

### 6.3 Validation checklist
- native launch appears before Flutter UI on Android and iOS,
- no white/blank frame between native launch and `SplashScreen`,
- visual continuity between native launch and Flutter splash,
- dark mode behavior reviewed (or explicitly fixed to one style),
- launch time regression: none critical.

Stage 6 Gate:
- `flutter analyze`
- `flutter test`
- real device/emulator cold start check (Android + iOS),
- screenshots/video evidence of startup transition attached in docs/PR notes.

## Splash Completion Definition (`Definition of Done`)

Splash has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 screen integration is complete,
- Stage 4 passes with no critical deviations,
- documentation and rules from Stage 5 are updated,
- Stage 6 native launch replacement is implemented and validated on Android/iOS.
