# Customize Screen - Stage 3 Integration

This note documents Stage 3 (`CustomizeScreenComposition`) implementation and
gate verification for the Customize roadmap.

## Implemented Scope

- Added full `CustomizeScreen` composition using Stage 2 reusable components:
  - `lib/features/customize/presentation/customize_screen.dart`
  - `lib/features/customize/presentation/widgets/customize_scene_shell.dart`
  - `lib/features/customize/presentation/widgets/customize_set_selector_field.dart`
  - `lib/features/customize/presentation/widgets/customize_grid_options_section.dart`
- Wired Main Menu `Customize` action to open `CustomizeScreen`:
  - `lib/core/app.dart`
- Wired cards-grid tap (`6`, `8..24`) to immediate game start via locked mapping:
  - `lib/features/customize/presentation/customize_start_payload.dart`
- Kept active gameplay set source fixed to `food-set` (roadmap scope lock).

## Accessibility Contract

- Screen semantics container label: `Customize screen`.
- Section titles (`Select set`, `Cards grid`) are semantic headers.
- Set selector semantics communicates active set value (`Active set Animals`).
- Grid option buttons expose semantic button labels (`8 cards` .. `24 cards`).

## Tests Added

- `test/features/customize/presentation/customize_screen_test.dart`
- `test/features/customize/presentation/customize_start_payload_test.dart`
- `test/app_customize_flow_test.dart`

## Stage 3 Gate Results

- `flutter analyze`
  - Completed with existing repository infos in legacy tests unrelated to
    Customize changes (deprecated API usage in pre-existing test files).
- `flutter test` (targeted to Customize and app flow tests)
  - Passed.
- `flutter run -d 072B3F13-55E7-446C-AF69-029F436442EC --debug --no-resident`
  - Passed on iOS simulator.
