# Implementation Roadmap - Select Set Screen (component-first)

This document describes the implementation plan for the `Select Set` screen using the following approach:
- reusable components first,
- full screen integration second,
- Customize screen integration and set-to-gameplay contract third,
- 1:1 validation against provided references at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run/build where relevant).
2. Before visual UI implementation starts, `Spec Lock` for the target `Select Set` screen must be completed.
3. Do not move to the next screen until `Select Set` reaches `accepted` status.
4. Reuse provided local references as source of truth:
   - `assets/select set screen/Select set.svg`
   - `assets/select set screen/Select set.png`
5. Scope lock for this roadmap:
   - two sets only: `animals-set` and `food-set`,
   - selecting a set navigates back to `Customize` screen where the chosen set is visible,
   - gameplay must use the selected set for card icons.

## Stage 1 - Spec Lock for `Select Set` (assets/Figma-aligned)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame and safe area baseline from `assets/select set screen/Select set.svg` + tablet adaptation strategy,
- vertical structure and spacing of: `top-logo-row`, `screen-title`, `set-buttons-section`, `developer-brand`,
- set option button spec (container size, corner radius, border, shadow, icon slot, text style),
- typography and styling for `Select set` title and set option labels,
- colors, opacities, gradients, and background layer order,
- non-main screen shell baseline requirements:
  - top logo baseline aligned with `NonMainFlowLayout.phoneTopLogoOffset`,
  - shared `background + developer brand` reuse (no custom per-screen top offset overrides).

Behavior contract to lock in this stage:
- entry path: `Customize` -> tap set selector row -> `Select Set` screen,
- selecting a set option pops back to `Customize` with the chosen set key,
- `Customize` displays the selected set (label + icon) in the set selector row,
- starting game from `Customize` uses the selected set for card icons.

Set catalog lock (MVP):
- `animals-set` -> display label `Animals`, representative icon from `assets/sets/animals-set/`,
- `food-set` -> display label `Food`, representative icon from `assets/sets/food-set/`.

Output:
- `Spec Lock` document: `docs/select-set-screen-spec-lock.md`,
- explicit assumptions list (`known assumptions`) with follow-up checkpoints,
- locked set catalog table (`setKey` -> `label`, `iconAsset`).

Stage 1 Gate:
- `done` (`docs/select-set-screen-spec-lock.md` locked and accepted for Stage 2.1 kickoff).

Status:
- `done`.

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently.

### 2.1 `SelectSetOptionButton`
- implement reusable option button for a single set row (`icon + label`),
- preserve visual parity with references (white rectangle, rounded corners, dark outline, icon slot),
- expose API:
  - `label`,
  - `leadingIconAsset`,
  - `onTap`,
  - `isEnabled`,
- support minimum states: enabled, pressed, disabled.

Gate:
- `flutter analyze`
- widget tests for layout, text rendering, semantics, and tap behavior.

Status:
- `done`.

### 2.2 `SelectSetOptionsSection`
- implement section that renders and spaces all set option buttons vertically,
- expose API:
  - `availableSets` (list of `{setKey, label, iconAsset}`),
  - `onSetSelected`,
  - optional spacing preset.

Gate:
- `flutter analyze`
- widget tests for layout, callback emission, and semantics.

Status:
- `done`.

### 2.3 `SelectSetSceneShell`
- reuse existing non-main scene shell (`NonMainSceneShell` + `ScreenLogoRow` + developer brand),
- keep top logo baseline and footer spacing consistent with other non-main screens.

Gate:
- `flutter analyze`
- comparison screenshot for background/logo/footer alignment.

Status:
- `done` (widget and golden tests in `test/features/select_set/presentation/widgets/select_set_scene_shell_test.dart` and `select_set_scene_shell_golden_test.dart`; phone and tablet baselines generated).

## Stage 3 - `SelectSetScreen` Composition and Customize Integration

Scope:
- compose `Select Set` screen from Stage 2 components,
- keep layer order and spacing 1:1 with `Spec Lock`,
- integrate navigation:
  - `Customize` set selector `onTap` pushes `SelectSetScreen`,
  - `SelectSetScreen` receives `initialSelectedSetKey` and `onSetSelected(setKey)` callback,
  - on set tap: call `onSetSelected(setKey)` and `Navigator.pop(context)` to return to `Customize`,
- add accessibility semantics for title and each set option.

Customize screen changes:
- `CustomizeScreen` accepts optional `selectedSetKey` (default `food-set`),
- `CustomizeSetSelectorField` receives `label`, `leadingIconAsset` from resolved set catalog for `selectedSetKey`,
- `CustomizeSetSelectorField.onTap` navigates to `SelectSetScreen` with callback to update selected set,
- state: selected set must be passed back to `Customize` (via route result or callback passed to `SelectSetScreen`).

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

Status:
- `done` (SelectSetScreen composed, CustomizeScreen StatefulWidget with set selection, navigation wired, tests passing).

## Stage 4 - Set-to-Gameplay Contract Validation

Checklist:
- `CustomizeStartPayload` already carries `setKey`; ensure it is passed from `Customize` to `Game` flow,
- `GameIconSetProvider` must support loading icons from `animals-set` and `food-set` based on `setKey`,
- `app.dart` when opening game from `Customize`: create `GameIconSetProvider` from `payload.setKey` and pass to `GameScreen`,
- `SelectLevelStartConfig` / game flow: extend or adapt so `setKey` reaches `GameIconSetProvider`,
- add `assets/sets/animals-set/` to `pubspec.yaml` assets if not present,
- fallback: unknown `setKey` -> use `food-set`.

Gate:
- `flutter analyze`
- unit/integration tests for set resolution and icon provider behavior.

Artifacts:
- tests covering both sets and gameplay init with correct icon source.

Status:
- `pending`.

## Stage 5 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match `assets/select set screen/Select set.svg|png`,
- typography and styling for `Select set` title match references,
- set option buttons match reference dimensions and spacing,
- top logo row and developer brand alignment match non-main shell baseline rules,
- result is correct on Android and iOS (phone + tablet portrait).

Artifacts:
- minimum 2 comparison screenshots (phone + tablet),
- deviations list (`known deviations`) or `none`,
- validation note: `docs/select-set-screen-stage-5-validation.md`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

Status:
- `pending`.

## Stage 6 - Documentation and Screen Closure

After `Select Set` acceptance:
- update flow docs in `docs` (`Customize` -> `Select Set` -> back to `Customize`),
- update `README.md` if run/test flow or entry flow description changed,
- add `CHANGELOG.md` entry for user-visible set selection flow,
- record final acceptance and deviation decisions.

Gate:
- documentation updates merged and consistent with implemented behavior.

Status:
- `pending`.

## Open Questions to Lock Before Stage 2/3

1. **Label mapping**: Reference design shows four options (Cakes, Vegetables, Animals, Plants). MVP has two sets (`animals-set`, `food-set`). Confirm display labels: `Animals` for `animals-set`, `Food` for `food-set`? Or should `food-set` be split into sub-labels (e.g. Cakes, Vegetables) in a future phase?
2. **Representative icon per set**: Which asset from each set should be used as the set selector/option icon? (e.g. `animals-set`: first or representative icon; `food-set`: e.g. `coffee-svgrepo-com.svg` as currently used?)
3. **Back navigation**: Should `Select Set` screen have an explicit back/close button, or is tapping a set the only way to leave (pop with selection)?

## `Select Set` Definition of Done (`Definition of Done`)

`Select Set` has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 integration is complete and wired from `Customize`,
- Stage 4 set-to-gameplay contract validation passes for both sets,
- Stage 5 passes with no critical visual/behavior deviations,
- Stage 6 documentation is updated.

Final status:
- `pending`.
