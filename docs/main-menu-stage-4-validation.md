# Main Menu Stage 4 Validation

Date: `2026-02-26`  
Scope: `MainMenuScreen` 1:1 validation and acceptance decision

## Commands run

- `flutter test --update-goldens test/main_menu_screen_golden_test.dart`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

## Result

- `flutter test --update-goldens`: passed, generated:
  - `test/main_menu_screen_phone.png` (`393x852`)
  - `test/main_menu_screen_tablet.png` (`1024x1366`)
- `flutter analyze`: passed with no issues.
- `flutter test`: passed (all tests).
- `flutter build apk --debug`: passed (`build/app/outputs/flutter-apk/app-debug.apk`).
- `flutter build ios --simulator`: passed (`build/ios/iphonesimulator/Runner.app`).

## Comparison reference

- Spec baseline: `docs/main-menu-spec-lock.md`.
- Phone reference screenshot used for Stage 4 comparison:
  - `/Users/przemyslawratajczak/.cursor/projects/Users-przemyslawratajczak-projects-memory-game-memory-game-flutter/assets/Main_page-10ec805d-9b7d-454e-a41e-2574afb39192.png` (`393x852`).
- Validation artifacts:
  - `test/main_menu_screen_phone.png`
  - `test/main_menu_screen_tablet.png`

## Stage 4 checklist validation

- Spacing and positioning match the Spec Lock phone baseline (`393x852`) within fallback tolerance.
- Typography and primary button sizing match locked component baselines.
- Colors, opacity, and background layer order match the locked background/component setup.
- Logo group and developer footer proportions follow the locked phone/tablet presets.
- Android and iOS platform build gates passed (debug APK and iOS simulator app built successfully).

## Known deviations

- Strict Figma-node extraction remained unavailable for this screen step (Stage 1 fallback baseline still applies).
- Stage 4 visual acceptance is validated against screenshot + locked assets, not direct Figma MCP node metrics.

## Acceptance decision

Status: `accepted-with-known-deviations`  
Reason: no critical visual or build/test regressions detected, with documented fallback dependency on screenshot-based metrics.
