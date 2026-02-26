# Select Level - Spec Lock (Stage 1)

This document freezes the Stage 1 specification for `Select Level` before UI coding.

## Sources

- Roadmap scope and stage rules: `in-progress-roadmaps/roadmap-select-level-screen.md`
- Visual reference screenshot (phone): `.cursor/projects/Users-przemyslawratajczak-projects-memory-game-memory-game-flutter/assets/Select_level-3f51e3eb-3f1f-496e-b844-dbf30e38c827.png`
- Button visual source of truth: `assets/Level button.svg` and `assets/Level button.png`
- Existing reusable elements to align with: `MainMenuBackground`, `MainMenuDeveloperBrand`

## Screen-First Lock Note

This spec is locked directly against the provided phone screenshot and local button assets. Only non-visible details (tablet adaptation and pressed-state micro-interaction) remain as temporary assumptions.

## 1) Frame and Safe Area

### Phone (locked reference)

- Frame: `393 x 852` px (from provided screenshot)
- Orientation: portrait
- Safe area rule: wrap content in `SafeArea`; avoid placing tappable elements under top notch/home indicator
- Horizontal content inset for level section: `20` px each side

### Tablet (locked implementation target)

- Orientation: portrait
- Safe area rule: same as phone (`SafeArea`)
- Level section width: centered, capped to `560` px max
- Horizontal side inset before width cap: `48` px each side

## 2) Locked Layout Structure and Positioning

### Phone reference coordinates (portrait)

Coordinates below are measured from the top-left of the 393x852 frame.

| Element | X | Y | W | H | Notes |
| --- | ---: | ---: | ---: | ---: | --- |
| `background` | 0 | 0 | 393 | 852 | Reuse `MainMenuBackground` gradient + decorative layer |
| `logo-group` | 20 | 28 | 287 | 60 | Small top logo row (`logo-icon` + `logo-text`) |
| `screen-title` | 96 | 330 | 201 | 45 | Text: `Select level` |
| `level-buttons-section` | 20 | 371 | 353 | 188 | 3 stacked level buttons |
| `developer-brand` | 137 | 767 | 119 | 65 | Reuse `MainMenuDeveloperBrand` phone preset |

### Phone spacing lock

- `screen-title` -> first level button top: `41` px
- Button vertical gap: `10` px
- Button section padding: none (buttons render edge-to-edge inside 353 px slot)

### Tablet spacing lock

- Keep the same vertical rhythm ratio as phone (title to section and button-to-button)
- Keep section centered on X axis
- Keep `developer-brand` bottom anchored with tablet preset (`24` px bottom offset)

## 3) Level Button Spec Lock

Button shape and style are locked from `assets/Level button.svg`:

- Base size: `286 x 56` in source asset; scaled in screen composition to fill section width
- Runtime target size in phone section: `353 x 56`
- Corner radius: `10`
- Fill color: white
- Border:
  - selected `Simple`: `#00E51F`
  - selected `Medium`: `#E2C800`
  - selected `Hard`: `#E50004`
  - unselected/disabled: `#D2D2D2`
- Border width:
  - selected: `2`
  - unselected/disabled: `3` (aligned with SVG neutral state)
- Shadow: drop shadow equivalent to SVG filter (`offsetY=4`, `blur=2`, black at ~25% alpha)

### Label typography lock

- Font family: `DynaPuff`
- Font weight: `700`
- Font size: `50` (asset space), scaled to fit runtime width while preserving visual weight
- Letter spacing: `0`
- Vertical alignment: centered in button

### Label colors by state

- selected `Simple`: `#00E51F`
- selected `Medium`: `#E2C800`
- selected `Hard`: `#E50004`
- unselected/disabled: `#D2D2D2`

### Interaction/state lock

- `enabled + unselected`
- `enabled + selected`
- `pressed` (temporary visual: scale to `0.98` for 90ms and slightly reduce shadow intensity)
- `disabled` (neutral border/text/fill treatment, no tap action)

### Accessibility lock

Each button semantics must include:

- `button: true`
- `enabled: true/false`
- `selected: true/false`
- label in format: `<difficulty> level`

## 4) Difficulty -> Board Grid Mapping (locked contract)

| Difficulty | Rows | Columns | Pair count |
| --- | ---: | ---: | ---: |
| `simple` | 3 | 4 | 6 |
| `medium` | 4 | 4 | 8 |
| `hard` | 4 | 5 | 10 |

Fallback rule:

- If mapping is missing or invalid at runtime, default to `simple (3x4)` and log a warning in debug output.

## 5) Navigation Contract Lock

- Entry:
  - `Main Menu` `Quick Play` action opens `Select Level`.
- Selection:
  - tapping `Simple`, `Medium`, or `Hard` updates selected state immediately.
- Confirm/start gameplay flow:
  - in MVP, tap on a difficulty is treated as immediate confirmation for that difficulty.
  - selected difficulty resolves to grid config via mapping table above.
  - app navigates to gameplay board route with `{difficulty, rows, columns}` payload.
- Return/back:
  - back navigation from `Select Level` returns to `Main Menu` without mutating previous state.

## 6) Temporary Assumptions To Re-Validate

The following are intentionally temporary because they are not fully inferable from the single provided phone screenshot:

- Tablet horizontal inset (`48`) and section max width (`560`) for Select Level
- Pressed-state micro-interaction values (scale/duration/shadow reduction)

Phone coordinates and spacing values in this document are treated as locked from the supplied screenshot.
