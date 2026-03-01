# Success Screen - Spec Lock (Stage 1)

This document freezes Stage 1 specification for `Success` before UI implementation.

## Sources

- Roadmap and Stage 1 requirements: `in-progress-roadmaps/roadmap-success-screen.md`
- Screen visual references:
  - `assets/success-screen/Success.svg`
  - `assets/success-screen/Success.png`
- Non-main shell baseline:
  - `lib/shared/widgets/non_main_scene_shell.dart`
  - `lib/shared/layout/non_main_flow_layout.dart`
  - `lib/shared/widgets/screen_logo_row.dart`
- Existing non-main screen alignment references:
  - `lib/features/select_level/presentation/select_level_screen.dart`
  - `lib/features/gameplay/presentation/widgets/game_scene_shell.dart`
- Current gameplay/timer contracts:
  - `lib/features/gameplay/presentation/game_screen.dart`
  - `lib/features/gameplay/presentation/widgets/game_top_bar.dart`
  - `lib/features/select_level/presentation/select_level_start_config.dart`
- Current app navigation entry flow:
  - `lib/core/app.dart`

## Screen-First Lock Note

Spec is locked against local `Success.svg/png` references and existing reusable non-main shell components.
All values below are the implementation contract for Stage 2 and Stage 3.

## 1) Frame and Safe Area

### Phone (locked reference)

- Frame: `393 x 852` px (`Success.svg`)
- Orientation: portrait
- Safe area: content must be under `SafeArea`; no interactive controls under notch/home indicator

### Tablet (locked implementation target)

- Orientation: portrait
- Keep section order and rhythm from phone:
  `top-logo-row -> success-panel -> play-again-button -> close-button -> developer-brand`
- Keep content centered with wider side insets (reuse non-main shell + responsive spacing scale).
- Keep footer brand preset from shared non-main shell (`MainMenuDeveloperBrandScalePreset.tablet`).

## 2) Locked Layout Structure and Positioning

### Phone reference coordinates (393x852)

Coordinates are measured from top-left in `Success.svg`.

| Element | X | Y | W | H | Notes |
| --- | ---: | ---: | ---: | ---: | --- |
| `logo-icon-shell` | 27 | 50 | 64 | 64 | Shared top logo tile |
| `logo-wordmark-slot` | 119 | 57 | 242 | 54 | Shared `MEMORY` wordmark area |
| `success-panel` | 29 | 267 | 335 | 186 | Dark semi-transparent result container |
| `play-again-button` | 29 | 503 | 335 | 56 | Primary replay action |
| `close-button` | 29 | 569 | 335 | 56 | Exit action |
| `developer-brand` | 137.5 | 767.5 | 118 | 64 | Shared footer brand block |

### Vertical spacing lock (phone baseline)

- top-logo bottom (`114`) -> success-panel top (`267`): `153`
- success-panel bottom (`453`) -> play-again top (`503`): `50`
- play-again bottom (`559`) -> close top (`569`): `10`
- close bottom (`625`) -> developer-brand top (`767.5`): `142.5`

### Non-main shell alignment lock

- Top logo baseline must align with existing `NonMainFlowLayout.phoneTopLogoOffset`.
- `Success` must reuse shared `NonMainSceneShell` behavior (background + developer brand) without duplicating shell logic.
- Any shell API extension in Stage 2.3 must be minimal and justified by this spec.

## 3) Result Panel Spec (`SuccessResultPanel`)

### Content lock

- Title text: `You Win!`
- Time label text: `Time elapsed:`
- Time value format: fixed-width `HH:MM:SS` (example: `00:04:21`)

### Duration formatting lock

- Hours/minutes/seconds must always be zero-padded to two digits.
- Long sessions still render in `HH:MM:SS` shape; for `>= 100h`, hours expand naturally while keeping `MM:SS` two-digit.
- Use tabular digits (`FontFeature.tabularFigures`) to prevent width jumps while time value changes.

### Visual treatment lock

- Panel container:
  - width `335`, height `186`, radius `6`
  - dark overlay fill close to reference (`black` with about `0.23` opacity)
  - subtle drop shadow from reference
- Text treatment:
  - family: `DynaPuff`
  - `You Win!` and elapsed block must preserve outlined/shadowed visual impression from reference
  - center alignment inside panel block

## 4) Action Buttons Spec (`SuccessActionButtons`)

### Shared geometry and spacing

- Width: `335`
- Height: `56`
- Corner radius: `10`
- Border: black, `1`
- Vertical gap between buttons: `10`

### Labels

- Top button label: `Play again`
- Bottom button label: `Close`

### States and interaction lock

- `enabled`: tappable, standard shadow
- `pressed`: short scale feedback (`~0.98`) and reduced shadow (project-consistent)
- `disabled`: muted fill + no callback
- Keep behavior and motion style consistent with existing game close button interaction language.

## 5) Behavior and Navigation Contract Lock

### Success entry

- `Success` is shown immediately after board completion (`all pairs matched`).
- Elapsed value shown on `Success` is the final elapsed time from completed round (no post-completion ticking).

### `Play again` action

- Starts a new game round for the same selected difficulty.
- Must regenerate card identities and reshuffle board order (no board reuse between rounds).
- Replay stays offline-safe and keeps existing icon source strategy (`assets/sets/food-set`) unless changed in later accepted roadmap stages.

### `Close` action

- Exits success flow to `Main Menu`.
- Locked MVP navigation strategy: clear intermediate flow and open `Main Menu` as resulting destination (`pushAndRemoveUntil`-style outcome contract).

### Locked flow statement

- `Game` completion -> `Success`
- `Success` + `Play again` -> new `Game` round (same difficulty, fresh board)
- `Success` + `Close` -> `Main Menu`

## 6) Accessibility Lock

- Semantics container label for screen: `Success screen` (or equivalent stable label).
- Title semantics include success outcome context (`You Win`).
- Time semantics include meaning and value, e.g. `Time elapsed 00:04:21`.
- Buttons expose semantic role/button state and clear action labels (`Play again`, `Close`).

## 7) Known Assumptions and Follow-Up Checkpoints

### Known assumptions (locked for Stage 2 start)

1. `Success` is implemented as a dedicated full-screen route (not in-game modal overlay).
2. Replay icon sourcing remains aligned with current gameplay provider (`food-set`) and new random draw each round.
3. `Close` uses stack-clearing outcome to guarantee destination `Main Menu`.
4. Transition from `Game` to `Success` in MVP is immediate (no mandatory animation).
5. Current `GameScreen` will be minimally extended in Stage 3 to emit completion with final elapsed payload.

### Follow-up checkpoints (must be confirmed before Stage 3/4 acceptance)

- Re-confirm route vs modal decision with product owner before Stage 3 sign-off.
- Re-confirm stack policy for `Close` against broader app navigation policy.
- Re-confirm whether transition animation is needed after first integrated flow demo.
- Validate replay freshness with deterministic tests (new board order for each replay).

## 8) Stage 1 Gate Checklist

Stage 1 is `done` when:

- `docs/success-screen-spec-lock.md` is present and accepted.
- Layout, result panel spec, action button spec, and behavior contract are all locked.
- Known assumptions and follow-up checkpoints are explicitly documented.
- No unresolved blocker remains for Stage 2.1 (`SuccessResultPanel`) kickoff.
