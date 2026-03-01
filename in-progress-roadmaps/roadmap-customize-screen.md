# Implementation Roadmap - Customize Screen (component-first)

This document describes the implementation plan for the next screen (`Customize`) using the following approach:
- reusable components first,
- full screen integration second,
- settings-to-gameplay contract validation third,
- 1:1 validation against provided references at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run/build where relevant).
2. Before visual UI implementation starts, `Spec Lock` for the target `Customize` screen must be completed.
3. Do not move to the next screen until `Customize` reaches `accepted` status.
4. Reuse provided local references as source of truth:
   - `assets/customize-screen/Customize.svg`
   - `assets/customize-screen/Customize.png`
5. Scope lock for this roadmap:
   - set-selection navigation to a dedicated set-picker screen is out of scope (planned in a separate roadmap),
   - active/default set is fixed to `food-set` in this roadmap.

## Stage 1 - Spec Lock for `Customize` (assets/Figma-aligned)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame and safe area baseline from `assets/customize-screen/Customize.svg` (`393x852`) + tablet adaptation strategy,
- vertical structure and spacing of: `top-logo-row`, `select-set-title`, `set-selector-row`, `cards-grid-title`, `cards-grid-buttons`, `developer-brand`,
- set selector spec (container size, corner radius, border, shadow, icon slot, text style),
- cards-grid button spec:
  - values: `8`, `10`, `12`, `14`, `16`, `18`, `20`, `22`, `24`,
  - dimensions, spacing, corner radius, border, shadow, text style,
  - selected/pressed/disabled state expectations,
- typography and styling for headings (`Select set`, `Cards grid`) and option labels,
- colors, opacities, gradients, and background layer order,
- non-main screen shell baseline requirements:
  - top logo baseline aligned with `NonMainFlowLayout.phoneTopLogoOffset`,
  - shared `background + developer brand` reuse (no custom per-screen top offset overrides).

Behavior contract to lock in this stage:
- entry path: `Main Menu` -> `Customize` via `Customize` button,
- active set displayed as `Animals` visual option, but gameplay source remains default `food-set` in this roadmap,
- clicking a `cards grid` option starts `Game Screen` immediately,
- `cards grid` value means total visible cards:
  - `24` means `12` pairs,
  - pair count always equals `cardCount / 2`.

Out-of-scope contract (explicitly deferred):
- opening set-picker/details screen from set selector,
- adding additional icon sets beyond default `food-set`,
- remote/network-backed set catalog.

Output:
- `Spec Lock` document: `docs/customize-screen-spec-lock.md`,
- explicit assumptions list (`known assumptions`) with follow-up checkpoints,
- locked mapping table for `cards grid -> rows x columns -> pairs`.

Stage 1 Gate:
- `done` (`docs/customize-screen-spec-lock.md` locked and accepted for Stage 2.1 kickoff).

Status:
- `done`.

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently.

### 2.1 `CustomizeSetSelectorField`
- implement reusable selector field for the visible active set row (`icon + label`),
- preserve visual parity with references (`Animals` row container),
- expose API:
  - `label`,
  - `leadingIconAsset`,
  - `onTap` (kept optional or disabled in this roadmap due to deferred set-picker),
  - `isEnabled`.

Gate:
- `flutter analyze`
- widget tests for layout, text rendering, semantics, and disabled mode behavior.

Status:
- `done` (implemented in `lib/features/customize/presentation/widgets/customize_set_selector_field.dart` with tests in `test/features/customize/presentation/widgets/customize_set_selector_field_test.dart`).

### 2.2 `CustomizeGridOptionButton`
- implement reusable square option button for card-count values,
- expose API:
  - `cardCount`,
  - `onTap`,
  - `isEnabled`,
  - optional visual preset (`phone|tablet`),
- support minimum states: enabled, pressed, disabled, selected (if selection state is retained before navigation).

Gate:
- `flutter analyze`
- widget tests for dimensions, state visuals, and semantics labels.

Status:
- `done` (implemented in `lib/features/customize/presentation/widgets/customize_grid_option_button.dart` with tests in `test/features/customize/presentation/widgets/customize_grid_option_button_test.dart`).

### 2.3 `CustomizeGridOptionsSection`
- implement responsive section that arranges all card-count options in a 3x3 layout:
  - row 1: `8`, `10`, `12`,
  - row 2: `14`, `16`, `18`,
  - row 3: `20`, `22`, `24`,
- expose API:
  - `availableCardCounts`,
  - `onCardCountSelected`,
  - optional spacing presets.

Gate:
- `flutter analyze`
- widget tests for fixed ordering, spacing, and callback contract.

Status:
- `done` (implemented in `lib/features/customize/presentation/widgets/customize_grid_options_section.dart` with tests in `test/features/customize/presentation/widgets/customize_grid_options_section_test.dart`).

### 2.4 `CustomizeSceneShell`
- reuse existing non-main scene shell (`background + top logo row + developer brand`) without duplicating scaffold logic,
- keep top logo baseline and footer spacing consistent with other non-main screens.

Gate:
- `flutter analyze`
- comparison screenshot for background/logo/footer alignment.

Status:
- `done` (implemented in `lib/features/customize/presentation/widgets/customize_scene_shell.dart` as a wrapper over `NonMainSceneShell`).

## Stage 3 - `CustomizeScreenComposition` Integration

Scope:
- compose `Customize` screen from Stage 2 components,
- keep layer order and spacing 1:1 with `Spec Lock`,
- integrate navigation and settings payload:
  - `Main Menu` `Customize` action opens `CustomizeScreen`,
  - selecting any cards-grid option navigates directly to `Game Screen`,
  - pass selected configuration payload to game init:
    - `cardCount`,
    - resolved `pairCount` (`cardCount / 2`),
    - active set key fixed to `food-set` (temporary default for this roadmap),
- add accessibility semantics for set row, section titles, and each cards-grid option.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

Status:
- `done` (implemented in `lib/features/customize/presentation/customize_screen.dart` and wired in `lib/core/app.dart`; Stage 3 tests added in `test/features/customize/presentation/customize_screen_test.dart` and `test/app_customize_flow_test.dart`; mapping payload contract introduced in `lib/features/customize/presentation/customize_start_payload.dart`).

## Stage 4 - Settings Mapping Validation (`cards grid` -> gameplay board)

Checklist:
- every supported `cardCount` resolves to a valid board setup config (`rows x columns`) agreed in Stage 1,
- `pairCount` is always half of `cardCount`,
- payload sent from `Customize` to `Game` is deterministic and complete (`setKey`, `cardCount`, `rows`, `columns`, `pairCount`),
- default/fallback behavior is defined when unsupported value is requested,
- default icon source remains `assets/sets/food-set` for all `cardCount` options in this roadmap.

Gate:
- `flutter analyze`
- unit/integration tests for mapping resolver and navigation payload.

Artifacts:
- tests covering all card-count options (`8..24`) and expected gameplay init config.

Status:
- `done` (mapping contract validated in `test/features/customize/presentation/customize_start_payload_test.dart`, `test/features/customize/presentation/customize_screen_test.dart`, and `test/app_customize_flow_test.dart`; Stage 4 gates executed with known unrelated golden failures outside Customize scope).

## Stage 5 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match `assets/customize-screen/Customize.svg|png`,
- typography and styling for `Select set` and `Cards grid` match references,
- set selector field (`Animals`) dimensions/style/icon alignment match references,
- all nine grid buttons (`8..24`) match reference dimensions and spacing,
- top logo row and developer brand alignment match non-main shell baseline rules,
- result is correct on Android and iOS (phone + tablet portrait).

Artifacts:
- minimum 2 comparison screenshots (phone + tablet),
- deviations list (`known deviations`) or `none`,
- validation note: `docs/customize-screen-stage-5-validation.md`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

Status:
- `todo`.

## Stage 6 - Documentation and Screen Closure

After `Customize` acceptance:
- update flow docs in `docs` (`Main Menu` -> `Customize` -> `Game`),
- update `README.md` if run/test flow or entry flow description changed,
- add `CHANGELOG.md` entry for user-visible new `Customize` flow,
- record final acceptance and deviation decisions,
- explicitly mark deferred scope handoff to separate roadmap for set-picker screen.

Gate:
- documentation updates merged and consistent with implemented behavior.

Status:
- `todo`.

## Open Questions to Lock Before Stage 2/3

1. Confirm board mappings for each card-count option (`8..24`) into exact `rows x columns` values (example candidates: `8=2x4`, `10=2x5`, `12=3x4`, `14=2x7`, `16=4x4`, `18=3x6`, `20=4x5`, `22=2x11`, `24=4x6`).
2. Should `CustomizeSetSelectorField` be tappable in MVP (e.g., show placeholder info/snackbar), or fully disabled/non-interactive until separate set-picker roadmap is implemented?
3. Navigation behavior from `Game Screen` close action after entering via `Customize`: back to `Customize`, `Main Menu`, or follow existing game-close contract unchanged?
4. Do we require transition animation between `Customize` and `Game`, or instant navigation is preferred for MVP?

## `Customize` Definition of Done (`Definition of Done`)

`Customize` has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 integration is complete and wired from `Main Menu`,
- Stage 4 mapping validation passes for all supported card-count options,
- Stage 5 passes with no critical visual/behavior deviations,
- Stage 6 documentation is updated.

Final status:
- `in-progress`.
