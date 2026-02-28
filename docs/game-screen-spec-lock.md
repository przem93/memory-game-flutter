# Game Screen - Spec Lock (Stage 1)

This document freezes Stage 1 specification for `Game` before UI implementation.

## Sources

- Roadmap and Stage 1 requirements: `in-progress-roadmaps/roadmap-game-screen.md`
- Screen visual references: `assets/game-screen/Game.svg`, `assets/game-screen/Game.png`
- Card state assets:
  - `assets/game-screen/reversed-card.svg`
  - `assets/game-screen/Card.svg`
  - `assets/game-screen/matched card.svg`
  - `assets/card-brain.svg`
- Close button visual source: `assets/game-screen/Button small.svg`
- Pair icon source: `assets/sets/food-set/*.svg`
- Reusable scene references:
  - `lib/features/main_menu/presentation/widgets/main_menu_background.dart`
  - `lib/features/main_menu/presentation/widgets/main_menu_developer_brand.dart`
- Difficulty to grid contract reference:
  - `lib/features/select_level/presentation/select_level_start_config.dart`

## Screen-First Lock Note

Spec is locked against local `Game.svg/png` references and existing reusable scene components.  
All values below are the implementation contract for Stage 2 and Stage 3.

## 1) Frame and Safe Area

### Phone (locked reference)

- Frame: `393 x 852` px (`Game.svg`)
- Orientation: portrait
- Safe area: wrap gameplay content with `SafeArea`; no tappable controls under notch/home indicator

### Tablet (locked implementation target)

- Orientation: portrait
- Keep vertical flow and section order identical to phone:
  `top-logo-row -> timer-close-row -> board-grid -> developer-brand`
- Keep board centered horizontally, with increased side insets and spacing that scale proportionally from phone baseline
- Reuse existing tablet brand preset from `MainMenuDeveloperBrandScalePreset.tablet`

## 2) Locked Layout Structure and Positioning

### Phone reference coordinates (393x852)

Coordinates are measured from top-left in `Game.svg`.

| Element | X | Y | W | H | Notes |
| --- | ---: | ---: | ---: | ---: | --- |
| `logo-icon-shell` | 27 | 50 | 64 | 64 | Rounded white tile with black stroke, contains brain icon |
| `logo-wordmark-slot` | 119 | 57 | 242 | 54 | `MEMORY` wordmark group |
| `timer-close-row` | 29 | 173 | 335 | 33 | Timer on left, close button on right |
| `close-button-hit` | 267 | 173 | 97 | 28 | Matches `Button small.svg` base size |
| `board-grid` | 29 | 226 | 335 | 488 | 4x4 reference layout in visual asset |
| `developer-brand` | 137.5 | 767.5 | 118 | 64 | Footer brand block |

### Board geometry lock (phone baseline)

- Card slot size: `76.25 x 114.5`
- Card radius: `6`
- Card stroke: black, `2`
- Horizontal card gap: `10`
- Vertical card gap: `10`
- Grid margins:
  - left: `29`
  - right: `29`
  - top (from frame): `226`
- Board bottom in reference: `714`
- Gap board -> developer brand top: `53.5`

### Difficulty -> board mapping (locked)

| Difficulty | Rows | Columns | Card count | Pair count |
| --- | ---: | ---: | ---: | ---: |
| `simple` | 3 | 4 | 12 | 6 |
| `medium` | 4 | 4 | 16 | 8 |
| `hard` | 4 | 5 | 20 | 10 |

Contract:

- Mapping stays aligned with `resolveSelectLevelStartConfig`.
- `pairCount = (rows * columns) / 2`.
- In runtime fallback case for unknown difficulty, use `simple (3x4)` payload contract.

## 3) Card-State Matrix (implementation and tests contract)

### State mapping

| Logical state | Shell asset | Face overlay | Expected visual |
| --- | --- | --- | --- |
| `hidden` | `assets/game-screen/reversed-card.svg` | `assets/card-brain.svg` centered | White card + brain icon |
| `revealed` | `assets/game-screen/Card.svg` | pair symbol from icon set | White card + symbol |
| `matched` | `assets/game-screen/matched card.svg` | same pair symbol retained | Green card + symbol |

### Placement rules

- Face overlay is centered both axes.
- Overlay scales to fit card content area while preserving aspect ratio.
- `hidden` state always shows `card-brain`.
- `matched` state keeps the matched symbol visible (no symbol removal after match).

## 4) Pair Icon Source and Randomization Contract

Initial icon set:

- `assets/sets/food-set/*.svg` (currently 17 icons, sufficient for max `pairCount=10`).

Generation rules per new game:

1. Resolve `pairCount` from selected difficulty.
2. Draw exactly `pairCount` unique icon identities from active set.
3. Duplicate each identity exactly 2 times to build pairs.
4. Shuffle resulting list only after duplication.
5. Use injectable RNG (`Random` adapter/seed input) for deterministic tests.

### Fallback contract (`availableIcons < pairCount`)

- Provider returns explicit domain failure (`insufficientIconPool`) instead of silently generating invalid board.
- UI behavior for MVP fallback:
  - do not start invalid game board,
  - show recoverable user-facing error,
  - keep user on current flow (no crash).
- Tests must cover this failure path explicitly.

## 5) Timer and Close Button Lock

### Timer

- Visual format: fixed-width `HH:MM:SS` (example: `00:03:45`)
- Use monospaced rendering behavior (tabular digits or equivalent fixed glyph widths) to avoid width jumps
- Baseline row placement: left side of `timer-close-row`, vertically centered with close button
- Accessibility:
  - semantic label includes meaning and current value, e.g. `Elapsed time 00:03:45`
  - updates announced in a non-disruptive way (no noisy per-frame announcements)

### Close button

Source: `assets/game-screen/Button small.svg`

- Size: `97 x 28`
- Radius: `10`
- Fill: white
- Border: black, `1`
- Shadow: `offsetY=4`, `blur=2`, black at ~25% alpha
- Label style:
  - family: `DynaPuff`
  - weight: `700`
  - color: `#204235`

Interaction lock:

- `enabled`: tappable, standard shadow
- `pressed`: slight scale and/or shadow reduction (consistent with existing button interaction style in project)
- `disabled`: muted visual + no tap callback

Accessibility lock:

- semantic role: button
- semantic label: `Close game`
- clear focus order before board cards

## 6) Background and Developer Brand Reuse

- Reuse `MainMenuBackground` as screen background container.
- Reuse `MainMenuDeveloperBrand` for footer alignment and scaling presets.
- Any API extension in Stage 2.6 must be minimal and justified by this document.
- Do not duplicate scene scaffold logic already provided by reusable background/brand components.

## 7) Known Assumptions and Follow-Up Checkpoints

### Known assumptions (locked for Stage 2 start)

1. Card-state semantic mapping resolved as:
   `reversed-card=hidden`, `Card=revealed`, `matched card=matched + symbol`.
2. Timer mode for MVP: `elapsed` (count up from `00:00:00`).
3. Close action for MVP: navigate back to `Select Level` (no confirmation dialog).
4. Board-complete behavior for MVP: stay on board, freeze timer, keep final state visible (no forced navigation).
5. Active icon set in MVP: fixed `food-set`.

### Follow-up checkpoints (must be confirmed before Stage 3 completion)

- Validate close navigation behavior with product owner against full game flow.
- Validate end-of-game UX (stay on board vs modal) before Stage 4 acceptance.
- Validate timer accessibility announcement strategy in widget tests.

## 8) Stage 1 Gate Checklist

Stage 1 is `done` when:

- `docs/game-screen-spec-lock.md` is present and accepted.
- Layout, board geometry, card-state matrix, timer/close specs, and icon fallback contract are all locked.
- No unresolved blocker remains for Stage 2.1 (`GameTopBar`) kickoff.
