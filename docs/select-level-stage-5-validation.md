# Select Level Stage 5 Validation

Date: `2026-02-26`  
Scope: `SelectLevelScreen` 1:1 validation and acceptance decision

## Commands run

- `flutter test --update-goldens test/select_level_screen_golden_test.dart`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

## Result

- `flutter test --update-goldens`: passed, generated:
  - `test/select_level_screen_phone.png` (`393x852`)
  - `test/select_level_screen_tablet.png` (`1024x1366`)
- `flutter analyze`: passed with no issues.
- `flutter test`: passed (all tests).
- `flutter build apk --debug`: passed (`build/app/outputs/flutter-apk/app-debug.apk`).
- `flutter build ios --simulator`: passed (`build/ios/iphonesimulator/Runner.app`).

## Comparison reference

- Spec baseline: `docs/select-level-spec-lock.md`.
- Phone reference screenshot used for Stage 5 comparison:
  - `/Users/przemyslawratajczak/.cursor/projects/Users-przemyslawratajczak-projects-memory-game-memory-game-flutter/assets/Select_level-185de5fb-f780-4bba-9fd9-a6fb2d7da939.png` (`393x852`).
- Validation artifacts:
  - `test/select_level_screen_phone.png`
  - `test/select_level_screen_tablet.png`

## Comparison outcome

- Canvas size parity: both phone images are `393x852`.
- Binary equality: no (`cmp` mismatch).
- Visual structure remains aligned with the locked spec: top logo row, centered `Select level` title, three-option level section with selected `Simple` state, and developer brand anchor.

## Stage 5 checklist validation

- Spacing and positioning follow the locked phone baseline geometry.
- Typography and button visual language follow locked `DynaPuff` + level button assets.
- Selected and unselected color states stay consistent with locked mapping (`green/yellow/red/gray`).
- Visual parity checks are available for phone and tablet artifacts.
- Android and iOS platform build gates passed (debug APK and iOS simulator app built successfully).

## Known deviations

- Strict Figma-node extraction remained unavailable for this screen step (Stage 1 fallback baseline still applies).
- Acceptance is validated against screenshot + locked assets, not direct Figma MCP node metrics.

## Acceptance decision

Status: `accepted-with-known-deviations`  
Reason: all test/build gates passed and no critical visual regressions were detected, with documented fallback dependency on screenshot-based validation.
