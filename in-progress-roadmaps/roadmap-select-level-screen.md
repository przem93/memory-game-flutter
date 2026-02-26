# Implementation Roadmap - Select Level Screen (component-first)

This document describes the implementation plan for the next screen (`Select Level`) using the following approach:
- reusable components first,
- full screen integration second,
- 1:1 validation against Figma at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run).
2. Before visual UI implementation starts, `Spec Lock` for the target `Select Level` node in Figma must be completed.
3. Do not move to the next screen until `Select Level` reaches `accepted` status.

## Stage 1 - Spec Lock for `Select Level` (Figma)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame dimensions and safe area (phone + tablet, portrait),
- positions and sizes of: `background`, `logo-group`, `screen-title`, `level-buttons-section`, `developer-brand`,
- spacing between title and level buttons, and spacing between each level button,
- level button specs: radius, border width/color, shadow, text style, vertical alignment, pressed and disabled behavior,
- level color mapping:
  - selected `Simple` -> green,
  - selected `Medium` -> yellow,
  - selected `Hard` -> red,
  - unselected level -> gray,
- typography (family, weight, size, line-height, letter-spacing) for title and button labels,
- navigation behavior from `Quick Play` and transition requirements to gameplay board.

Difficulty-to-grid mapping (must be locked in this stage):
- `Simple` -> target board grid size,
- `Medium` -> target board grid size,
- `Hard` -> target board grid size.

Asset references to reuse (do not recreate unless blocked):
- `assets/Level button.svg` (vector source of button style),
- `assets/Level button.png` (raster reference for color and visual state checks).

Output:
- `Spec Lock` document added: `docs/select-level-spec-lock.md`,
- explicit grid mapping table consumed by gameplay board setup (included in spec lock doc),
- temporary assumptions explicitly listed for later Figma re-validation.

Stage 1 Gate:
- `done` (Stage 2.1 `SelectLevelOptionButton` can start).

Status:
- `done`

Completion notes:
- Stage 1 locked using local assets + provided screen reference screenshot.
- Figma MCP access was blocked by plan call limit during this stage; assumptions were documented in `docs/select-level-spec-lock.md` for follow-up verification.

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently.

### 2.1 `SelectLevelOptionButton`
- create a dedicated reusable component for level selection (different from `MainMenuPrimaryButton`),
- preserve shape and visual language from `assets/Level button.svg` and `assets/Level button.png`,
- expose API:
  - `label`,
  - `difficulty` (`simple | medium | hard`),
  - `isSelected`,
  - `onTap`,
- map colors by state:
  - selected text color by difficulty (`green/yellow/red`),
  - unselected text color `gray`,
  - border/shadow color aligned with selected difficulty (and neutral for unselected),
- support minimum states: enabled, pressed, disabled, selected, unselected,
- include accessibility semantics for selected/unselected state.

Gate:
- `flutter analyze`
- widget test for all color/state variants and semantics.

Status:
- `done`

Completion notes:
- Implemented `SelectLevelOptionButton` as a dedicated reusable component in `lib/features/select_level/presentation/widgets/select_level_option_button.dart`.
- Added widget coverage for selected/unselected/pressed/disabled states and semantics in `test/select_level_option_button_test.dart`.
- Gate passed: `flutter analyze` and `flutter test test/select_level_option_button_test.dart`.

### 2.2 `SelectLevelOptionsSection`
- implement section that renders and spaces all level buttons (`Simple`, `Medium`, `Hard`),
- ensure only one active selected option at a time,
- expose API:
  - `selectedDifficulty`,
  - `onDifficultyChanged`,
  - optional custom spacing preset.

Gate:
- `flutter analyze`
- widget test for layout, single-selection behavior, and callback emission.

Status:
- `done`

Completion notes:
- Implemented `SelectLevelOptionsSection` in `lib/features/select_level/presentation/widgets/select_level_options_section.dart` with API: `selectedDifficulty`, `onDifficultyChanged`, optional `spacing`, optional `isEnabled`.
- Added widget coverage for layout, single-selection state, callback emission, and spacing variants in `test/select_level_options_section_test.dart`.
- Gate passed: `flutter analyze` and `flutter test test/select_level_options_section_test.dart`.

### 2.3 `SelectLevelTitle`
- implement reusable title block for `Select level` text with Figma-accurate style.

Gate:
- `flutter analyze`
- widget test for typography and scaling behavior.

Status:
- `done`

Completion notes:
- Implemented `SelectLevelTitle` in `lib/features/select_level/presentation/widgets/select_level_title.dart` with locked `Select level` label, `DynaPuff` typography, and capped text scaling support.
- Added widget coverage for render, typography, and text scale clamping in `test/select_level_title_test.dart`.
- Gate passed: `flutter analyze` and `flutter test test/select_level_title_test.dart`.

### 2.4 `SelectLevelBackgroundAndBrandReuse`
- reuse existing `MainMenuBackground` and `DeveloperBrand` components where possible,
- add only minimal API extension if required by `Spec Lock`,
- avoid duplicated background/footer code in the new screen.

Gate:
- `flutter analyze`
- comparison screenshot for bottom and background alignment.

Status:
- `done`

Completion notes:
- Implemented reusable Select Level shell in `lib/features/select_level/presentation/widgets/select_level_scene_shell.dart` with `MainMenuBackground` + `MainMenuDeveloperBrand` reuse and automatic phone/tablet brand preset selection.
- Existing `MainMenuBackground` and `MainMenuDeveloperBrand` APIs were sufficient; no extension was required for Stage 2.4.
- Added widget and golden coverage in `test/select_level_scene_shell_test.dart` and `test/select_level_scene_shell_golden_test.dart`.
- Added Stage 2.4 baseline screenshots for background/footer alignment: `test/select_level_scene_shell_phone.png` and `test/select_level_scene_shell_tablet.png`.
- Gate passed: `flutter analyze`, `flutter test test/select_level_scene_shell_test.dart`, `flutter test test/select_level_scene_shell_golden_test.dart --update-goldens`.

## Stage 3 - `SelectLevelScreenComposition` Integration

Scope:
- compose `Select Level` screen from completed components,
- keep layer order and spacing 1:1 with `Spec Lock`,
- navigation and behavior:
  - entering `Quick Play` from `Main Menu` opens `Select Level`,
  - selecting `Simple/Medium/Hard` updates selected state immediately,
  - confirm flow starts gameplay with grid size from locked mapping table,
- pass selected difficulty (or resolved grid config) into game board initialization,
- add semantics for key screen elements and each difficulty button.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

Status:
- `todo`

## Stage 4 - Gameplay Mapping Validation (difficulty -> board grid)

Checklist:
- each difficulty resolves to the correct grid size defined in Stage 1,
- board receives expected rows/columns (or equivalent card-count config),
- no mismatch between selected label color/state and applied gameplay configuration,
- fallback behavior is defined if mapping config is missing.

Gate:
- `flutter analyze`
- unit/integration tests for mapping and board initialization.

Artifacts:
- tests covering all three difficulty levels and expected board setup.

Status:
- `todo`

## Stage 5 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match Figma,
- typography and button styling match Figma,
- selected/unselected color states match references (`green/yellow/red/gray`),
- visual parity with `assets/Level button.svg` and `assets/Level button.png`,
- result is correct on Android and iOS.

Artifacts:
- minimum 2 comparison screenshots (phone + tablet),
- deviations list (`known deviations`) or `none`,
- validation note in `docs/select-level-stage-5-validation.md`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

Status:
- `todo`

## Stage 6 - Documentation and Screen Closure

After `Select Level` acceptance:
- update navigation docs and screen flow docs in `docs` (`Main Menu` -> `Select Level` -> `Game Board`),
- update `README.md` if launch flow/setup notes changed,
- add `CHANGELOG.md` entry for user-visible new screen and difficulty selection behavior,
- record final screen status and deviation decisions.

Gate:
- documentation updates merged and consistent with implemented flow.

Status:
- `todo`

## `Select Level` Definition of Done (`Definition of Done`)

`Select Level` has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 integration is complete and wired from `Quick Play`,
- Stage 4 gameplay mapping validation passes for all levels,
- Stage 5 passes with no critical deviations,
- Stage 6 documentation is updated.

Final status:
- `in-progress`
