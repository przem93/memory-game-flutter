# Select Set Screen - Spec Lock (Stage 1)

This document freezes Stage 1 specification for `Select Set` before UI implementation.

## Sources

- Roadmap and Stage 1 requirements: `in-progress-roadmaps/roadmap-select-set-screen.md`
- Screen visual references: `assets/select set screen/Select set.svg`, `assets/select set screen/Select set.png`
- Reusable scene references:
  - `lib/shared/widgets/non_main_scene_shell.dart`
  - `lib/shared/layout/non_main_flow_layout.dart`
  - `lib/features/main_menu/presentation/widgets/main_menu_background.dart`
  - `lib/features/main_menu/presentation/widgets/main_menu_developer_brand.dart`
  - `lib/shared/widgets/screen_logo_row.dart`
- Set selector field reference: `lib/features/customize/presentation/widgets/customize_set_selector_field.dart`
- Customize payload contract: `lib/features/customize/presentation/customize_start_payload.dart`

## Screen-First Lock Note

Spec is locked against local `Select set.svg/png` references and existing reusable scene components.  
All values below are the implementation contract for Stage 2 and Stage 3.

## 1) Frame and Safe Area

### Phone (locked reference)

- Frame: `393 x 852` px (`Select set.svg` viewBox)
- Orientation: portrait
- Safe area: wrap content with `SafeArea`; no tappable controls under notch/home indicator

### Tablet (locked implementation target)

- Orientation: portrait
- Keep vertical flow and section order identical to phone:
  `top-logo-row -> screen-title -> set-buttons-section -> developer-brand`
- Keep set buttons centered horizontally, with increased side insets (`NonMainFlowLayout.tabletHorizontalInset`) and spacing that scale proportionally from phone baseline
- Reuse existing tablet brand preset from `MainMenuDeveloperBrandScalePreset.tablet`

## 2) Locked Layout Structure and Positioning

### Phone reference coordinates (393x852)

Coordinates are measured from top-left in `Select set.svg`.

| Element | X | Y | W | H | Notes |
| --- | ---: | ---: | ---: | ---: | --- |
| `logo-icon-shell` | 27 | 50 | 64 | 64 | Rounded white tile with black stroke, contains brain icon |
| `logo-wordmark-slot` | 119 | 57 | 242 | 54 | `MEMORY` wordmark group |
| `screen-title` | — | — | — | 37 | "Select set" section title, centered |
| `set-button-1` | 19.5 | 338.5 | 354 | 55 | First set option (Cakes in reference; Animals in MVP) |
| `set-button-2` | 19.5 | 404.5 | 354 | 55 | Second set option |
| `set-button-3` | 19.5 | 470.5 | 354 | 55 | Third set option |
| `set-button-4` | 19.5 | 536.5 | 354 | 55 | Fourth set option |
| `developer-brand` | 137.5 | 767.5 | 118 | 64 | Footer brand block |

### Vertical spacing lock (phone baseline)

- Top logo row baseline: `NonMainFlowLayout.phoneTopLogoOffset` (28)
- Logo row height: 60 (aligned with `ScreenLogoRow`)
- Screen title: "Select set", height 37, style aligned with `_CustomizeSectionTitle`
- Gap between set option buttons: **11 px** (derived from SVG: 404.5 - 338.5 - 55 = 11)
- Horizontal margin for buttons: 19.5 each side (centered: (393 - 354) / 2 = 19.5)

### Non-main screen shell baseline

- Top logo baseline aligned with `NonMainFlowLayout.phoneTopLogoOffset`
- Shared `background + developer brand` reuse (no custom per-screen top offset overrides)
- Use `NonMainSceneShell` or equivalent scene shell that composes `MainMenuBackground` and `MainMenuDeveloperBrand`

## 3) Set Option Button Spec (SelectSetOptionButton)

Implementation contract for reusable option button (Stage 2.1).

### Container

- Width: `354` px (phone); scale with content width on tablet
- Height: `55` px
- Border radius: `5.5`
- Fill: white (`#FFFFFF`)
- Border: black, `1` px
- Shadow: none (reference shows flat white rectangle with outline)

### Icon slot

- Size: `30 x 30` px
- Position: leading (left) side of button
- Gap between icon and label: `12` px (aligned with `CustomizeSetSelectorField._iconToLabelGap`)

### Label typography

- Font family: `DynaPuff`
- Font weight: `700` (Bold)
- Font size: scaled to fit (reference: ~28 effective; `CustomizeSetSelectorField` uses `48 * (32/55)`)
- Color: `#214336` (dark green, aligned with `CustomizeSetSelectorField._labelColor`)
- Height: `1` (line height)

### States

| State | Fill | Border | Interaction |
| --- | --- | --- | --- |
| `enabled` | white | black | tappable, standard |
| `pressed` | `#F7F7F7` | black | slight scale (0.995) on tap |
| `disabled` | `#F0F0F0` | black | muted, no tap callback |

### API (locked for Stage 2.1)

- `label` (String, required)
- `leadingIconAsset` (String, required)
- `onTap` (VoidCallback?, optional)
- `isEnabled` (bool, default true)

## 4) Set Catalog Lock (MVP)

Reference design shows four options (Cakes, Vegetables, Animals, Plants). MVP scope locks to two sets only.

| setKey | label | iconAsset |
| --- | --- | --- |
| `animals-set` | Animals | `assets/sets/animals-set/bear-svgrepo-com.svg` |
| `food-set` | Food | `assets/sets/food-set/coffee-svgrepo-com.svg` |

### Fallback contract

- Unknown `setKey` at runtime: use `food-set` (aligned with `CustomizeStartPayload.defaultSetKey`).
- `SelectSetOptionsSection` renders only entries from the locked catalog; no dynamic set discovery in MVP.

## 5) Behavior Contract

### Entry path

- `Customize` screen → user taps set selector row (`CustomizeSetSelectorField`) → push `SelectSetScreen`

### Exit path

- User taps a set option → call `onSetSelected(setKey)` with chosen key → `Navigator.pop(context)` to return to `Customize`
- No explicit Back/Close button: selecting a set is the only way to leave the screen (MVP assumption)

### Customize integration

- `CustomizeScreen` receives/holds `selectedSetKey` (default `food-set`)
- `CustomizeSetSelectorField` displays `label` and `leadingIconAsset` from resolved set catalog for `selectedSetKey`
- `CustomizeSetSelectorField.onTap` navigates to `SelectSetScreen` with `initialSelectedSetKey` and `onSetSelected` callback
- On set tap in Select Set: callback updates selected set in Customize, then pop

### Gameplay contract

- Starting game from Customize uses `CustomizeStartPayload.setKey` for card icons
- `GameIconSetProvider` must support loading icons from `animals-set` and `food-set` based on `setKey` (Stage 4)

## 6) Background and Developer Brand Reuse

- Reuse `MainMenuBackground` as screen background container (gradient, semi-transparent illustrations).
- Reuse `MainMenuDeveloperBrand` for footer alignment and scaling presets.
- Layer order: background → logo → title → set buttons → developer brand
- Do not duplicate scene scaffold logic; extend `NonMainSceneShell` or equivalent.

## 7) Known Assumptions and Follow-Up Checkpoints

### Known assumptions (locked for Stage 2 start)

1. **Label mapping**: MVP uses `Animals` for `animals-set` and `Food` for `food-set`; reference design shows Cakes, Vegetables, Animals, Plants — document as intentional MVP scope reduction.
2. **Representative icon per set**: `bear-svgrepo-com.svg` for animals-set, `coffee-svgrepo-com.svg` for food-set (already used in Customize).
3. **Back navigation**: No explicit Back/Close button; selecting a set is the only way to leave Select Set screen.
4. **Set count**: Two sets only in MVP; `SelectSetOptionsSection` renders 2 buttons in MVP.

### Follow-up checkpoints (must be confirmed before Stage 4/5 completion)

- Add `assets/sets/animals-set/` to `pubspec.yaml` (currently only `assets/sets/food-set/` is declared).
- Extend `GameIconSetProvider` to accept `setKey` and load icons from corresponding set directory.
- Update `app.dart` when opening game from Customize: create `GameIconSetProvider` from `payload.setKey` and pass to `GameScreen`.
- Extend `CustomizeStartPayload` / `resolveCustomizeStartPayload` to pass through selected `setKey` from Customize flow.

## 8) Stage 1 Gate Checklist

Stage 1 is `done` when:

- `docs/select-set-screen-spec-lock.md` is present and accepted.
- Layout, set option button spec, set catalog, and behavior contract are all locked.
- No unresolved blocker remains for Stage 2.1 (`SelectSetOptionButton`) kickoff.
