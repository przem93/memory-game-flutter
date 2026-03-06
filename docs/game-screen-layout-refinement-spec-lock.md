# Game Screen Layout Refinement - Spec Lock (Stage 1)

This document freezes the specification for the Game Screen layout refinement before implementation (Stage 2). Scope: fit cards in available space without scrolling, and remove developer brand from the game screen.

## Sources and scope

- **Roadmap:** `in-progress-roadmaps/roadmap-game-screen-layout-refinement.md`
- **Scope of this spec:** available space definition, no-scroll requirement, card sizing algorithm, no developer logo on game screen, and the contract for `GameBoardGrid`. General game screen spec (board geometry, card states, timer, etc.) remains in `docs/game-screen-spec-lock.md`.
- **Implementation references:**
  - `lib/features/gameplay/presentation/game_screen.dart` — layout constants and structure
  - `lib/features/gameplay/presentation/widgets/game_board_grid.dart` — board sizing and `cardAspectRatio`
  - `lib/shared/widgets/non_main_scene_shell.dart` — developer brand footer
  - `lib/features/gameplay/presentation/widgets/game_scene_shell.dart` — game screen shell

## Available space on game screen

The area where the card grid must fit is defined as follows.

### Vertical

- **Start:** bottom of `GameTopBar` plus the gap below it (`_topBarToBoardGap`).
- **End:** bottom of the safe area, minus the bottom padding applied to the board slot.
- **Bottom padding:** `_phoneBoardBottomPadding` (phone) / `_tabletBoardBottomPadding` (tablet). Values in `game_screen.dart`: **24** (phone), **32** (tablet). Minimal margin from the bottom safe area edge; developer brand is not shown on the game screen (Stage 2.3 applied).

So the **available height** for the board = height of the `Expanded` content area (from below top bar + gap down to safe area bottom) minus the bottom padding.

### Horizontal

- **Available width** = screen width (within safe area) minus left and right margins:
  - Phone: `_phoneHorizontalMargin` = **29** (each side) → content width = screen width − 58.
  - Tablet: `_tabletHorizontalInset` = **48** (each side) → content width = screen width − 96.

Constants are defined in `lib/features/gameplay/presentation/game_screen.dart` (lines 46–50).

## Requirement

- The entire card grid (`GameBoardGrid`) must fit within the available space defined above **without scrolling**.
- Card size is derived **only** from this available space and the fixed card aspect ratio (`cardAspectRatio`). No fixed card dimensions; layout is fully responsive to the bounded region.

## Algorithm (card and board sizing)

When the parent gives **bounded height** to `GameBoardGrid`:

1. **Width-based trial:** Compute card size from available width (fill width, keep `cardAspectRatio`). Compute total board height (rows × card height + vertical gaps).
2. **Fit check:** If that board height ≤ available height, use this size (board fills width, may use less than full height).
3. **Height-based fallback:** Otherwise, compute card size from available height (fill height, keep `cardAspectRatio`). Board then fills height and may use less than full width.

This matches the existing logic in `GameBoardGrid._resolveBoardSize` in `lib/features/gameplay/presentation/widgets/game_board_grid.dart` (lines 121–145). Constants:

- `cardAspectRatio` = **76.25 / 114.5** (from same file, line 44).
- `gridSpacing` = **10** (horizontal and vertical gap between cards).

Today, `GameBoardGrid` is placed inside `SingleChildScrollView` on the game screen, so it receives unbounded height and only the width-based branch is used. Stage 2 will remove the scroll view and pass bounded height so the height-based branch can apply when needed.

## Developer logo (footer)

- **On game screen:** developer brand (footer) must **not** be shown.
- **On other non-main screens:** developer brand remains unchanged (Select Level, Customize, Success, Select Set).

Implementation will extend the shell (e.g. `GameSceneShell` or `NonMainSceneShell`) with a parameter to hide the footer (e.g. `showDeveloperBrand`, default `true`). Game screen will use the variant with footer hidden.

## GameBoardGrid contract

- **Input:** `GameBoardGrid` receives from its parent **bounded** constraints: finite `maxWidth` and `maxHeight` (the available space for the board).
- **Behaviour:** It chooses board size (and thus card size) so that the entire grid fits within those bounds, respecting `cardAspectRatio` and `gridSpacing`, using the algorithm above.
- **Optional:** A short code comment in `GameBoardGrid` or at the game screen usage site may state that when used on the game screen, bounded constraints are expected so the board fits without scrolling.

## Assumptions and deviations

- **Safe area:** Unchanged; content is laid out inside the same `SafeArea` as today (in `NonMainSceneShell`).
- **Bottom padding:** Stage 2.3 applied. Values are 24 (phone) / 32 (tablet) — minimal margin from the bottom safe area; developer brand is not shown on the game screen.
- **Other screens:** No change to layout or developer brand on Select Level, Customize, Success, or Select Set in this refinement.
- **Orientation / breakpoint:** Tablet vs phone uses existing breakpoint (e.g. width > 600) and the same margin/inset constants as today.

## Stage 1 gate checklist

Stage 1 is **done** when:

- This document (`docs/game-screen-layout-refinement-spec-lock.md`) exists and is accepted.
- Available space (vertical and horizontal), requirement, algorithm, developer logo rule, and `GameBoardGrid` contract are all stated and locked.
- No unresolved blocker remains for starting Stage 2 (hide developer brand, bounded height, remove scroll, optional padding).

After Stage 1 is marked done in the roadmap, Stage 2 implementation can begin.
