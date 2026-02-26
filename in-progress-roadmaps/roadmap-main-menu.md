# Implementation Roadmap - Main Menu Screen (component-first)

This document describes the implementation plan for the next screen (`Main Menu`) using the following approach:
- reusable components first,
- full screen integration second,
- 1:1 validation against Figma at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run).
2. Before visual UI implementation starts, `Spec Lock` for the target `Main Menu` node in Figma must be completed.
3. Do not move to the next screen until `Main Menu` reaches `accepted` status.

## Stage 1 - Spec Lock for `Main Menu` (Figma)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame dimensions and safe area (phone + tablet, portrait),
- positions and sizes of: `background`, `logo-group`, `action-buttons`, `developer-brand`,
- vertical spacing between sections and horizontal margins,
- button specs (`Quick Play`, `Customize`): corner radius, border, shadow, states,
- colors (hex/opacity), gradients, and background layer order,
- typography (family, weight, size, line-height, letter-spacing).

Output:
- `Spec Lock` table added to this file or a dedicated reference file (`docs/main-menu-spec-lock.md`).

Status:
- `accepted-with-fallback` (implemented based on reference screenshot measurements).
- Figma MCP strict extraction was blocked by account call limit during this step.
- Metrics reference: `docs/main-menu-spec-lock.md`.

Stage 1 Gate:
- `done` (Stage 2.1 `MainMenuBackground` can start).

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently.

### 2.1 `MainMenuBackground`
- render background according to Figma (gradient + SVG icon layer),
- control background icon opacity and layer order,
- responsive scaling with no hardcoding for a single phone model.

Gate:
- `flutter analyze`
- background-only comparison screenshot.

Status:
- `done` (`2026-02-26`)
- Gate passed:
  - `flutter analyze` -> no issues,
  - background artifact generated: `test/main_menu_background_phone.png`,
  - comparison note: `docs/main-menu-stage-2-1-validation.md`.

### 2.2 `MainMenuLogoGroup`
- logo group (`logo-icon` + `logo-text`) as a separate component,
- component API: alignment, spacing, optional scale preset.

Gate:
- `flutter analyze`
- widget test for API variants and layout.

Status:
- `done` (`2026-02-26`)
- Gate passed:
  - `flutter analyze` -> no issues,
  - `flutter test` -> all tests passed (including `test/main_menu_logo_group_test.dart`).

### 2.3 `MainMenuPrimaryButton`
- shared button component for `Quick Play` and `Customize`,
- 1:1 style (font, outline, radius, height, padding),
- minimum states: enabled, pressed, disabled.

Gate:
- `flutter analyze`
- widget test for styles and states.

Status:
- `done` (`2026-02-26`)
- Gate passed:
  - `flutter analyze` -> no issues,
  - `flutter test` -> all tests passed (including `test/main_menu_primary_button_test.dart`).

### 2.4 `MainMenuActionSection`
- section that arranges action buttons on the screen,
- section API: action list, button spacing, semantics.

Gate:
- `flutter analyze`
- widget test for layout and semantics.

Status:
- `done` (`2026-02-26`)
- Gate passed:
  - `flutter analyze` -> no issues,
  - `flutter test test/main_menu_action_section_test.dart` -> all tests passed.

### 2.5 `DeveloperBrand`
- reuse the existing developer footer component (no duplication),
- optional API adaptation for `Main Menu` (offset/size variant) if required by `Spec Lock`.

Gate:
- `flutter analyze`
- bottom section comparison screenshot.

## Stage 3 - `MainMenuScreenComposition` Integration

Scope:
- compose the `Main Menu` screen from completed components,
- map layers and spacing 1:1 according to `Spec Lock`,
- connect actions:
  - `Quick Play` -> start default gameplay,
  - `Customize` -> navigate to configuration screen,
- add accessibility semantics for key elements.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

## Stage 4 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match Figma,
- typography and button sizes match Figma,
- colors, opacity, and background layers match Figma,
- logo and developer footer proportions match Figma,
- result is correct on Android and iOS.

Artifacts:
- minimum 2 comparison screenshots (2 resolutions),
- deviations list (`known deviations`) or `none`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

## Stage 5 - Documentation and Screen Closure

After `Main Menu` acceptance:
- update `README.md` and/or `docs` with the new screen and navigation flow,
- add an entry in `CHANGELOG.md` (if user-visible),
- record final screen status (`accepted`) and deviation decisions.

## `Main Menu` Definition of Done (`Definition of Done`)

`Main Menu` has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 screen integration is complete and actions are connected,
- Stage 4 passes with no critical deviations,
- Stage 5 documentation is updated.
