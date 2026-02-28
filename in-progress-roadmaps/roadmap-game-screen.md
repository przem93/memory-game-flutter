# Implementation Roadmap - Game Screen (component-first)

This document describes the implementation plan for the next screen (`Game`) using the following approach:
- reusable components first,
- full screen integration second,
- deterministic gameplay behavior third,
- 1:1 validation against provided assets at the end.

## Execution Rules

1. Each step ends with a verification gate (`analyze`, `test`, app run/build where relevant).
2. Before visual UI implementation starts, `Spec Lock` for the target `Game` screen must be completed.
3. Do not move to the next screen until `Game` reaches `accepted` status.
4. Reuse provided local assets from `/assets/game-screen` and `/assets` as source of truth (no visual recreation unless blocked).

## Stage 1 - Spec Lock for `Game` (assets/Figma-aligned)

Goal: freeze the 1:1 specification before coding the UI.

Collect and document:
- frame and safe area baseline from `assets/game-screen/Game.svg` (`393x852`) + tablet adaptation strategy,
- vertical structure and spacing of: `top-logo-row`, `timer-close-row`, `board-grid`, `developer-brand`,
- board layout spec (columns/rows, card spacing, outer margins, bottom spacing to brand),
- difficulty-to-board mapping and resulting card counts:
  - `simple` -> `3x4` (12 cards -> 6 pairs),
  - `medium` -> `4x4` (16 cards -> 8 pairs),
  - `hard` -> `4x5` (20 cards -> 10 pairs),
- card state visuals and exact mapping:
  - `assets/game-screen/reversed-card.svg|png`,
  - `assets/game-screen/Card.svg|png`,
  - `assets/game-screen/matched card.svg|matched-card.png`,
  - `assets/card-brain.svg` placement on non-reversed card,
- icon source set for gameplay pairs:
  - `assets/sets/food-set/*.svg` as the first supported icon set,
  - random draw without repetition per board (`pairCount` unique icons),
  - each drawn icon duplicated exactly twice to create one pair,
  - shuffle after pair creation using deterministic injectable RNG in tests,
  - fallback contract if available icons < required `pairCount` (must be defined in spec lock),
- close button spec from `assets/game-screen/Button small.svg|png` (size, radius, border, text style, pressed/disabled),
- timer typography and formatting (`00:03:45`-style fixed-width layout),
- background/brand reuse requirements vs existing reusable components.

Output:
- `Spec Lock` document: `docs/game-screen-spec-lock.md`,
- explicit assumptions list (`known assumptions`) with follow-up checkpoints,
- final card-state matrix used by implementation and tests.

Stage 1 Gate:
- `done` (Stage 2.1 can start).

Status:
- `in-progress`.

## Stage 2 - Reusable Components (separate implementation steps)

Each component must be implemented and verified independently.

### 2.1 `GameTopBar`
- implement reusable top section: game logo icon + `MEMORY` wordmark + timer + small close button,
- keep scale/alignment responsive (phone/tablet portrait),
- expose API:
  - `elapsed`/`remaining` time value,
  - `onCloseTap`,
  - optional visual preset (`phone|tablet`).

Gate:
- `flutter analyze`
- widget tests for layout, timer format rendering, and button semantics.

Status:
- `done`.

### 2.2 `GameCardShell`
- implement card shell component with visual states from assets:
  - `hidden/reversed`,
  - `revealed`,
  - `matched`,
- keep exact corner radius, border width/color, and shadow from SVG references,
- avoid hardcoded screen-dependent card sizing (size driven by grid constraints).

Gate:
- `flutter analyze`
- widget tests for all states and dimensions.

Status:
- `done`.

### 2.3 `GameCardFaceContent`
- implement content layer displayed on top of `GameCardShell` when card is revealed/matched,
- support `assets/card-brain.svg` for non-reversed state per requirement,
- define API for symbol/content slot so gameplay can render pair identities.

Gate:
- `flutter analyze`
- widget tests for asset rendering and semantic labels.

Status:
- `done`.

### 2.4 `GameBoardGrid`
- implement reusable board section rendering cards in responsive fixed-ratio grid,
- lock board behavior for selected difficulty config (`rows x columns` from previous flow),
- define tap callbacks and disabled interaction mode (e.g., mismatch animation in progress).

Gate:
- `flutter analyze`
- widget tests for grid dimensions, spacing, and interaction contract.

Status:
- `done`.

### 2.5 `GameIconSetProvider` (pair source selection)
- implement data/provider layer for icon-set based board generation,
- initial source: `assets/sets/food-set/*.svg`,
- API contract:
  - input: `difficulty` or resolved `pairCount`,
  - output: list of randomized pair identities with bound icon asset path,
- enforce rules:
  - draw exactly `pairCount` unique icons per new game,
  - no duplicate identity before pair duplication,
  - expose seeded RNG mode for deterministic tests.

Gate:
- `flutter analyze`
- unit tests for icon draw count, uniqueness, duplication-to-pairs, and deterministic seeded shuffle.

Status:
- `todo`.

### 2.6 `GameSceneShell` (background + brand reuse)
- reuse existing background and developer brand components where possible,
- add minimal API extensions only if required by `Spec Lock`,
- avoid duplicated scene scaffold code.

Gate:
- `flutter analyze`
- comparison screenshot for background/footer alignment.

Status:
- `todo`.

## Stage 3 - `GameScreenComposition` Integration

Scope:
- compose `Game` screen from Stage 2 components,
- preserve 1:1 layer order and spacing from `Spec Lock`,
- wire inputs:
  - receive selected difficulty/grid config from `Select Level` flow,
  - resolve card count from difficulty and initialize board accordingly,
  - request icon pool from `GameIconSetProvider` and bind icons to card identities,
  - `Close` action behavior aligned with locked navigation rule,
- add accessibility semantics for timer, board, card states, and close action.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter run`

Status:
- `todo`.

## Stage 4 - Gameplay Loop and Deterministic State Validation

Checklist:
- deterministic board setup (pair generation + shuffle strategy suitable for tests),
- card count always equals selected level board size (`rows * columns`),
- pair count equals half of board card count,
- selected icons are randomly drawn from `assets/sets/food-set` for each new game,
- selected icon identities are unique before pair duplication,
- card interaction state machine:
  - first flip,
  - second flip,
  - match resolution,
  - mismatch resolution with temporary input lock,
- matched cards remain in matched state,
- timer start/stop/reset behavior defined and tested,
- board completion condition defined (all pairs matched),
- stable offline behavior (no network dependency in core loop).

Gate:
- `flutter analyze`
- unit/widget tests for gameplay engine/state transitions and timer behavior.

Artifacts:
- tests covering at least one full happy-path game and mismatch path,
- tests covering all difficulty levels (`simple|medium|hard`) with expected card/pair counts and icon selection invariants.

Status:
- `todo`.

## Stage 5 - 1:1 Validation and Acceptance

Checklist:
- spacing and positioning match `assets/game-screen/Game.png|svg`,
- card state visuals match `reversed-card`, `Card`, and `matched card` references,
- `assets/card-brain.svg` placement/scale matches locked spec,
- card face icons are rendered from `assets/sets/food-set` and remain visually centered/scaled across screen sizes,
- timer row and close button style match reference,
- result is correct on Android and iOS (phone + tablet portrait).

Artifacts:
- minimum 2 comparison screenshots (phone + tablet),
- deviations list (`known deviations`) or `none`,
- validation note: `docs/game-screen-stage-5-validation.md`.

Gate:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

Status:
- `todo`.

## Stage 6 - Documentation and Screen Closure

After `Game` acceptance:
- update gameplay/navigation docs in `docs` (`Select Level` -> `Game` -> close/back outcome),
- update `README.md` if run/test flow changed,
- add `CHANGELOG.md` entry for user-visible gameplay screen behavior,
- record final acceptance and deviations decision.

Gate:
- documentation updates merged and consistent with implemented behavior.

Status:
- `todo`.

## Open Questions to Lock Before Stage 2/3

1. Confirm semantic mapping of card assets:
   - `reversed-card` = hidden state?
   - `Card` = revealed non-matched state?
   - `matched card` = matched background only or matched background + icon?
2. `Close` action expected behavior: navigate back to `Select Level`, `Main Menu`, or show confirmation dialog?
3. Timer mode: count up (`elapsed`) or count down (`remaining`)?
4. On finishing all pairs: stay on board with final time, show modal, or navigate to another screen?
5. When future icon sets are added, how should active set be chosen in MVP (fixed `food-set`, random set-per-game, or user-selected set)?

## `Game` Definition of Done (`Definition of Done`)

`Game` has `done` status when:
- all reusable components from Stage 2 are complete,
- Stage 3 integration is complete and wired from `Select Level`,
- Stage 4 gameplay loop validation passes with deterministic tests,
- Stage 5 passes with no critical visual/behavior deviations,
- Stage 6 documentation is updated.

Final status:
- `in-progress`.
