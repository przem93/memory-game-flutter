# Implementation Roadmap - Success Screen (component-first)

This document describes the implementation plan for the next screen (`Success`) using the following approach:
- reusable components first,
- full screen integration second,
- gameplay completion and replay flow validation third,
- 1:1 validation against provided references at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run/build where relevant).
2. Before visual UI implementation starts, `Spec Lock` for the target `Success` screen must be completed.
3. Do not move to the next screen until `Success` reaches `accepted` status.
4. Reuse provided local references from `assets/success-screen/Success.svg` and `assets/success-screen/Success.png` as source of truth.
5. The two success screen references are attached in the repository and must remain the default visual validation source throughout implementation (you can always revisit them during any stage).

## Stage 1 - Spec Lock for `Success` (assets/Figma-aligned)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame and safe area baseline from `assets/success-screen/Success.svg` (`393x852`) + tablet adaptation strategy,
- vertical structure and spacing of: `top-logo-row`, `success-panel`, `play-again-button`, `close-button`, `developer-brand`,
- exact `You Win!` typography, color, stroke/shadow style, and alignment,
- timer result block spec:
  - label text: `Time elapsed:`,
  - duration format: fixed-width `HH:MM:SS` (example from reference: `00:04:21`),
  - overflow rules for long sessions (e.g., `>= 1h` still rendered in `HH:MM:SS`),
- action buttons spec from reference:
  - `Play again` visual style and pressed/disabled behavior,
  - `Close` visual style and pressed/disabled behavior,
  - width, corner radius, border, spacing between buttons,
- non-main screen shell reuse requirements:
  - top logo baseline aligned with existing `NonMainFlowLayout.phoneTopLogoOffset`,
  - background + developer brand reuse from shared non-main screen shell.

Behavior contract to lock in this stage:
- screen is shown immediately after all pairs are matched,
- `Play again` starts a new game round for the same selected difficulty,
- `Play again` must regenerate card identities and reshuffle board order (no board reuse),
- `Close` exits to `Main Menu`,
- elapsed time shown on `Success` is the final elapsed time of the completed round.

Asset references to reuse:
- `assets/success-screen/Success.svg`,
- `assets/success-screen/Success.png`.

Output:
- `Spec Lock` document: `docs/success-screen-spec-lock.md`,
- explicit assumptions list (`known assumptions`) with follow-up checkpoints,
- locked navigation contract for `Game` -> `Success` -> (`Play again` | `Close`).

Stage 1 Gate:
- `done` (Stage 2.1 can start).

Status:
- `done`.

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently.

### 2.1 `SuccessResultPanel`
- implement reusable result panel containing `You Win!`, `Time elapsed:`, and formatted elapsed value,
- expose API:
  - `elapsed` (`Duration`),
  - optional semantics labels for title/time sections,
  - optional visual preset (`phone|tablet`),
- keep visual parity with success panel background, opacity, and text treatment from references.

Gate:
- `flutter analyze`
- widget tests for duration formatting, semantics, and responsive scaling.

Status:
- `done`.

Stage 2.1 closure note:
- `SuccessResultPanel` implemented in `lib/features/success/presentation/widgets/success_result_panel.dart`.
- Widget coverage is available in `test/features/success/presentation/widgets/success_result_panel_test.dart` (formatting, semantics, scaling).
- Stage gate executed:
  - `flutter analyze` (reported only existing unrelated infos in gameplay tests),
  - `flutter test test/features/success/presentation/widgets/success_result_panel_test.dart` (pass).

### 2.2 `SuccessActionButtons`
- implement reusable action section with `Play again` and `Close` buttons,
- expose API:
  - `onPlayAgainTap`,
  - `onCloseTap`,
  - optional enabled/disabled flags,
- preserve exact spacing, size, and style from references.

Gate:
- `flutter analyze`
- widget tests for button labels, callbacks, and disabled behavior.

Status:
- `done`.

Stage 2.2 closure note:
- `SuccessActionButtons` is implemented in `lib/features/success/presentation/widgets/success_action_buttons.dart`.
- Widget coverage is available in `test/features/success/presentation/widgets/success_action_buttons_test.dart` (labels, callbacks, disabled behavior, semantics, locked dimensions, tablet scaling).
- Stage gate executed:
  - `flutter analyze` (reported only existing unrelated infos in gameplay tests),
  - `flutter test test/features/success/presentation/widgets/success_action_buttons_test.dart` (pass).

Stage 2.3 handoff note:
- Reuse `NonMainSceneShell` (`background + developer brand`) via a dedicated `SuccessSceneShell`, without duplicating scaffold logic.
- Keep top logo baseline aligned with `NonMainFlowLayout.phoneTopLogoOffset` and follow the same responsive spacing rule used by other non-main screens.
- Keep Stage 2.3 scoped to shell alignment/comparison screenshot gate; do not start Stage 3 composition in this step.

### 2.3 `SuccessSceneShell`
- reuse existing non-main scene shell (`background + developer brand + top logo row`) without duplicating scaffold logic,
- keep top logo vertical baseline consistent with `Select Level` and other non-main screens,
- introduce only minimal API extension if required by `Spec Lock`.

Gate:
- `flutter analyze`
- comparison screenshot for logo/footer/background alignment.

Status:
- `done`.

Stage 2.3 closure note:
- `SuccessSceneShell` implemented in `lib/features/success/presentation/widgets/success_scene_shell.dart` as a thin wrapper around `NonMainSceneShell`.
- Widget coverage is available in `test/features/success/presentation/widgets/success_scene_shell_test.dart` (background/footer reuse, safe area, phone/tablet brand presets).
- Comparison screenshot coverage is available in `test/features/success/presentation/widgets/success_scene_shell_golden_test.dart` (phone and tablet baselines).
- Stage gate executed:
  - `flutter analyze` (reported only existing unrelated infos in gameplay tests),
  - `flutter test test/features/success/presentation/widgets/success_scene_shell_test.dart` (pass),
  - `flutter test test/features/success/presentation/widgets/success_scene_shell_golden_test.dart --update-goldens` (pass),
  - `flutter test test/features/success/presentation/widgets/success_scene_shell_golden_test.dart` (pass).

## Stage 3 - `SuccessScreenComposition` Integration

Scope:
- compose `Success` screen from Stage 2 components,
- keep layer order and spacing 1:1 with `Spec Lock`,
- integrate navigation contract:
  - `Game` completion opens `Success`,
  - `Play again` starts a new `Game` round with preserved `difficulty` and fresh randomized board,
  - `Close` navigates to `Main Menu`,
- pass final elapsed time from completed `Game` round to `Success`,
- add semantics for success title, elapsed time, and actions.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

Status:
- `done`.

Stage 3 closure note:
- `SuccessScreenComposition` is integrated in `lib/features/success/presentation/success_screen.dart` using Stage 2 components (`SuccessSceneShell`, `SuccessResultPanel`, `SuccessActionButtons`) with locked non-main shell baseline spacing.
- Gameplay -> Success wiring is integrated in `lib/core/app.dart` (`onCompleted` -> `SuccessScreen`), with replay preserving `SelectLevelStartConfig` and close clearing stack to `Main Menu`.
- Final elapsed payload from completed gameplay round is emitted by `GameScreen` (`onCompleted`) and rendered on `Success`.
- Stage 3 gate executed:
  - `flutter analyze` (reported only existing unrelated infos in gameplay widget tests),
  - `flutter test` (suite run executed; failures observed in unrelated `test/select_level_screen_golden_test.dart` baselines),
  - `flutter run -d "iPhone 17 Pro" --no-resident` (launch success),
  - focused Stage 3 validation: `flutter test test/features/success/presentation/success_screen_test.dart test/app_select_level_flow_test.dart` (pass).

## Stage 4 - Replay Flow and Deterministic Gameplay Validation

Checklist:
- after `Play again`, board card count still matches selected difficulty config (`rows * columns`),
- after `Play again`, regenerated board is not reusing previous round ordering (new shuffle each round),
- selected level is preserved across replay start (`simple|medium|hard`),
- elapsed timer is reset for the new round and restarts correctly,
- no network dependency introduced in replay/success flow (offline-safe behavior),
- `Close` always exits to `Main Menu` from `Success`.

Gate:
- `flutter analyze`
- unit/widget/integration tests for replay contract and navigation outcomes.

Artifacts:
- tests covering at least one full-game completion -> `Success` -> `Play again` path,
- tests covering `Success` -> `Close` -> `Main Menu` path.

Status:
- `done`.

Stage 4 closure note:
- Replay flow contract is covered in `test/app_select_level_flow_test.dart` for all difficulty levels (`Simple|Medium|Hard`), including preserved difficulty, expected board card count, and `Success -> Play again` transition.
- Replay board freshness is validated by comparing first-round and replay board signatures to ensure a new shuffle order is produced on replay start.
- Timer contract is validated in replay flow tests by asserting reset to `00:00:00` after replay start and subsequent increment after tick progression.
- `Success -> Close -> Main Menu` navigation outcome remains covered in `test/app_select_level_flow_test.dart`.
- Stage 4 gate executed:
  - `flutter analyze` (reported only existing unrelated infos in gameplay widget tests),
  - `flutter test test/app_select_level_flow_test.dart` (pass).

## Stage 5 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match `assets/success-screen/Success.svg|png`,
- typography and styling of `You Win!` and elapsed time block match references,
- `Play again` and `Close` buttons match dimensions/states/spacing from references,
- top logo row and developer brand alignment match non-main screen shell baseline rules,
- result is correct on Android and iOS (phone + tablet portrait).

Artifacts:
- minimum 2 comparison screenshots (phone + tablet),
- deviations list (`known deviations`) or `none`,
- validation note: `docs/success-screen-stage-5-validation.md`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

Status:
- `done`.

Stage 5 closure note:
- Full-screen Success comparison coverage is available in `test/features/success/presentation/success_screen_golden_test.dart` with locked artifacts:
  - `test/features/success/presentation/success_screen_phone.png`,
  - `test/features/success/presentation/success_screen_tablet.png`.
- Validation summary is documented in `docs/success-screen-stage-5-validation.md` (checklist, artifacts, deviations decision).
- Stage 5 gate executed:
  - `flutter analyze` (reported only existing unrelated infos in gameplay tests),
  - `flutter test` (reported existing unrelated golden mismatches in `test/select_level_screen_golden_test.dart`; Success scope remained green),
  - `flutter build apk --debug` (pass),
  - `flutter build ios --simulator` (pass),
  - focused confidence run: `flutter test test/features/success/presentation` (pass).

## Stage 6 - Documentation and Screen Closure

After `Success` acceptance:
- update navigation docs in `docs` (`Game` completion -> `Success` -> replay/close outcomes),
- update `README.md` if run/test flow changes,
- add `CHANGELOG.md` entry for user-visible completion/success flow behavior,
- record final acceptance and deviations decision.

Gate:
- documentation updates merged and consistent with implemented behavior.

Status:
- `done`.

Stage 6 closure note:
- Documentation closure is complete in `docs/success-screen-stage-6-closure.md`.
- Changelog entry is synchronized with final `Success` acceptance.

## Open Questions to Lock Before Stage 2/3

1. Should `Success` be implemented as a dedicated full-screen route (matching reference) or as an in-game modal overlay?
2. On `Play again`, should new round use the same icon set source strategy as current game setup (`assets/sets/food-set`) with a new random draw each time?
3. Should `Close` clear the entire stack back to `Main Menu` (`pushAndRemoveUntil`) or perform step-by-step `pop` navigation?
4. Do we need an additional transition animation between `Game` and `Success` (fade/scale), or instant transition is preferred for MVP?

## `Success` Definition of Done (`Definition of Done`)

`Success` has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 integration is complete and wired from gameplay completion,
- Stage 4 replay/navigation validation passes,
- Stage 5 passes with no critical visual/behavior deviations,
- Stage 6 documentation is updated.

Final status:
- `done`.
