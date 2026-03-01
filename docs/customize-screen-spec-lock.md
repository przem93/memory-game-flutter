# Customize Screen - Spec Lock (Stage 1)

This document freezes the Stage 1 specification for `Customize` before UI coding.

## Sources

- Roadmap scope and stage rules: `in-progress-roadmaps/roadmap-customize-screen.md`
- Screen visual references:
  - `assets/customize-screen/Customize.svg`
  - `assets/customize-screen/Customize.png`
- Non-main shell baseline:
  - `lib/shared/layout/non_main_flow_layout.dart`
  - `lib/shared/widgets/non_main_scene_shell.dart`
  - `lib/shared/widgets/screen_logo_row.dart`
- Existing non-main layout implementation references:
  - `lib/features/select_level/presentation/select_level_screen.dart`
  - `lib/features/gameplay/presentation/widgets/game_scene_shell.dart`

## Screen-First Lock Note

Spec is locked against local `Customize.svg/png` references and current reusable non-main shell contracts.
All values below are the implementation contract for Stage 2 and Stage 3.

## 1) Frame and Safe Area

### Phone (locked reference)

- Frame: `393 x 852` px (`Customize.svg`)
- Orientation: portrait
- Safe area: all interactive elements must stay under `SafeArea` (no actionable controls under notch/home indicator)

### Tablet (locked implementation target)

- Orientation: portrait
- Keep phone section order and vertical rhythm:
  `top-logo-row -> select-set-title -> set-selector-row -> cards-grid-title -> cards-grid-buttons -> developer-brand`
- Keep content centered with wider side insets (reuse shared non-main shell behavior and responsive spacing scale).
- Top logo baseline and footer behavior must remain aligned with shared non-main tokens.

## 2) Locked Layout Structure and Positioning

### Phone reference coordinates (393x852)

Coordinates are measured from top-left in `Customize.svg`.

| Element | X | Y | W | H | Notes |
| --- | ---: | ---: | ---: | ---: | --- |
| `logo-icon-shell` | 27 | 50 | 64 | 64 | Shared top logo icon tile |
| `logo-wordmark-slot` | 119 | 57 | 242 | 54 | Shared `MEMORY` wordmark area |
| `select-set-block` | 19 | 205 | 355 | 104 | Group containing title and selector row |
| `set-selector-row` | 19.5 | 253.5 | 354 | 55 | Active set row container |
| `set-selector-icon-slot` | 111.5 | 266 | 30 | 30 | Left icon slot inside selector |
| `cards-grid-block` | 19 | 349 | 355 | 338 | Group containing title + grid |
| `cards-grid-buttons-area` | 19 | 397 | 355 | 290 | 3x3 option matrix |
| `grid-button` (each) | 19.5 / 141.167 / 262.833 | 397.5 / 497.5 / 597.5 | 110.667 | 89 | Uniform 9-button geometry |
| `developer-brand` | 137.5 | 767.5 | 118 | 64 | Shared footer brand block |

### Vertical spacing lock (phone baseline)

- top logo bottom (`114`) -> `select-set-block` top (`205`): `91`
- `set-selector-row` bottom (`308.5`) -> `cards-grid-block` top (`349`): `40.5`
- `cards-grid-buttons-area` bottom (`686.5`) -> `developer-brand` top (`767.5`): `81`

### Grid spacing lock

- Horizontal gap between columns: `11`
- Vertical gap between rows: `11`
- Grid order is fixed:
  - row 1: `8`, `10`, `12`
  - row 2: `14`, `16`, `18`
  - row 3: `20`, `22`, `24`

### Non-main shell alignment lock

- Top logo baseline must align with `NonMainFlowLayout.phoneTopLogoOffset` and use `NonMainFlowLayout.resolveTopLogoSpacing(...)`.
- `Customize` must reuse shared `NonMainSceneShell` behavior (`background + developer brand`) without duplicating scaffold/shell logic.
- `ScreenLogoRow` is the locked top-logo implementation baseline.

## 3) Set Selector Spec (`CustomizeSetSelectorField`)

### Content lock

- Visible label: `Animals`
- Leading icon: decorative set icon from reference composition
- In this roadmap, selector acts as active-set display only (set picker navigation is out of scope)

### Visual treatment lock

- Container geometry:
  - width `354`, height `55`, radius `5.5`
  - fill: white
  - border: black, `1`
- Icon slot:
  - `30 x 30` logical slot, vertically centered
  - positioned to preserve reference left-bias and text spacing rhythm
- Text:
  - family: `DynaPuff`
  - visual weight: bold (`w700` equivalent)
  - color: dark green tone close to reference (`#204235`/`#214336` family)
  - centered vertically in the row

## 4) Cards Grid Option Button Spec (`CustomizeGridOptionButton`)

### Content and values lock

- Supported values: `8`, `10`, `12`, `14`, `16`, `18`, `20`, `22`, `24`
- Each value is rendered once in fixed matrix order (see section 2).

### Visual treatment lock

- Geometry:
  - width `110.667`, height `89`, radius `5.5`
  - fill: white
  - border: black, `1`
- Label style:
  - family: `DynaPuff`
  - visual weight: bold (`w700` equivalent)
  - color: dark green tone close to reference (`#204235`/`#214336` family)
  - centered horizontally and vertically

### State expectations lock

- `enabled`: tappable and navigates to game start flow
- `pressed`: short feedback interaction aligned with existing project motion language
- `disabled`: muted state with no callback (for defensive API completeness)
- `selected`: optional transitional state only if retained prior to immediate navigation

## 5) Headings and Background Styling Lock

### Headings

- Heading labels:
  - `Select set`
  - `Cards grid`
- Typography baseline:
  - family: `DynaPuff`
  - bold rounded style, center aligned
  - white fill with dark edging/shadow impression matching references

### Background and layer order

- Layer order:
  1. full-screen vertical gradient background,
  2. decorative line-art overlays,
  3. content layer (logo, titles, selector, grid),
  4. footer brand.
- Gradient baseline from SVG:
  - top: `#151414`
  - bottom: `#2E7C5E`
- Decorative overlay opacity baseline: around `0.08` where present in SVG.

## 6) Behavior and Navigation Contract Lock

### Entry and set behavior

- Entry path: `Main Menu` -> `Customize` (via `Customize` action).
- Active set row displays `Animals` visual option.
- Gameplay source set remains fixed to `food-set` in this roadmap (scope lock).

### Cards-grid selection behavior

- Tapping any cards-grid option starts `Game` immediately.
- `cardCount` means total visible cards.
- `pairCount` is always `cardCount / 2`.

### Transition lock

- MVP transition from `Customize` to `Game` is immediate (no mandatory animation requirement in this stage).

## 7) Locked Mapping Table (`cardCount -> rows x columns -> pairs`)

| cardCount | rows | columns | pairCount |
| ---: | ---: | ---: | ---: |
| 8 | 2 | 4 | 4 |
| 10 | 2 | 5 | 5 |
| 12 | 3 | 4 | 6 |
| 14 | 2 | 7 | 7 |
| 16 | 4 | 4 | 8 |
| 18 | 3 | 6 | 9 |
| 20 | 4 | 5 | 10 |
| 22 | 2 | 11 | 11 |
| 24 | 4 | 6 | 12 |

Fallback rule:

- If unsupported card count is requested at runtime, fallback to `16` (`4x4`, `8` pairs) and log debug warning.

## 8) Accessibility Lock

- Screen semantics container label: `Customize screen` (or stable equivalent).
- Set row semantics communicates active set value (`Animals`) and current interaction mode.
- Section titles exposed as headers (`Select set`, `Cards grid`).
- Each cards-grid option exposes semantic button role and count label (e.g. `24 cards`).

## 9) Known Assumptions and Follow-Up Checkpoints

### Known assumptions (locked for Stage 2 start)

1. Set selector is visually active but does not open a picker route in this roadmap.
2. Active gameplay set key remains fixed to `food-set` regardless of visible `Animals` label.
3. Navigation from `Customize` to `Game` remains immediate on count tap.
4. Shared non-main shell stays the only shell source (`NonMainSceneShell` + `ScreenLogoRow`), without screen-specific top offset overrides.
5. Mapping table above is the authoritative contract for Stage 4 validation.

### Follow-up checkpoints (must be re-confirmed before Stage 3/4 acceptance)

- Re-confirm desired interaction policy for set selector (`disabled`, `no-op`, or placeholder feedback) after first integrated demo.
- Re-confirm post-game close behavior for sessions entered from `Customize` against global navigation policy.
- Re-confirm if transition animation between `Customize` and `Game` is required after MVP demo.

## 10) Stage 1 Gate Checklist

Stage 1 is `done` when:

- `docs/customize-screen-spec-lock.md` is present and accepted.
- Layout, selector field spec, cards-grid spec, styling, and behavior contracts are all locked.
- Mapping table for `8..24` is explicit and treated as authoritative.
- Known assumptions and follow-up checkpoints are explicitly documented.
- No unresolved blocker remains for Stage 2.1 (`CustomizeSetSelectorField`) kickoff.
