# Customize Screen - Stage 5 Validation (1:1)

This note captures Stage 5 (`1:1 Validation and Acceptance`) for `Customize`.

## References

- Visual source of truth:
  - `assets/customize-screen/Customize.svg`
  - `assets/customize-screen/Customize.png`
- Locked spec:
  - `docs/customize-screen-spec-lock.md`
- Screen under validation:
  - `lib/features/customize/presentation/customize_screen.dart`

## Comparison Artifacts (minimum 2)

- Phone (`393x852`): `test/features/customize/presentation/customize_screen_phone.png`
- Tablet (`1024x1366`): `test/features/customize/presentation/customize_screen_tablet.png`
- Golden test: `test/features/customize/presentation/customize_screen_golden_test.dart`

## Stage 5 Checklist

- Spacing and positioning match `Customize.svg|png`:
  - `pass` (logo, select-set block, set-selector row, cards-grid block, grid buttons, developer brand rhythm preserved in phone/tablet baselines)
- Typography/styling of `Select set` and `Cards grid` headings:
  - `pass` (DynaPuff bold, white fill with shadow treatment aligned with spec lock)
- Set selector field (`Animals`) dimensions/style/icon alignment:
  - `pass` (354x55, radius 5.5, border 1, icon slot 30x30; label and icon layout match spec)
- All nine grid buttons (`8..24`) dimensions and spacing:
  - `pass` (110.667x89, radius 5.5, gap 11, fixed ordering per spec lock)
- Top logo row + developer brand alignment with non-main shell baseline:
  - `pass` (shell reuse via `CustomizeSceneShell` and `NonMainFlowLayout` spacing rules)
- Android+iOS outcome for Stage 5 build gate:
  - `pass` for `flutter build apk --debug`
  - `pass` for `flutter build ios --simulator`

## Gate Execution Log

- `flutter analyze`
  - completed with 5 existing `info` diagnostics in unrelated files (gameplay `hasFlag` deprecation, success `value` deprecation)
- `flutter test test/features/customize/`
  - `pass` (18 tests including golden tests)
- `flutter build apk --debug`
  - `pass`
- `flutter build ios --simulator`
  - `pass`

## Known Deviations

- **Set selector icon:** Reference shows cookie-like icon; implementation uses `coffee-svgrepo-com.svg` from `food-set` per roadmap scope lock (fixed `food-set` for this roadmap). Documented as acceptable known assumption.
- Residual unrelated workspace issues remain outside Stage 5 scope:
  - deprecation infos in gameplay and success tests from `flutter analyze`

## Acceptance Decision

- Stage 5 for `Customize` is accepted as `done` in scope:
  - 1:1 validation artifacts are present for phone and tablet,
  - `Customize`-scoped tests and golden coverage pass,
  - Android and iOS simulator builds pass,
  - one documented deviation (set icon from food-set vs reference cookie-like) is within roadmap scope and acceptable.
