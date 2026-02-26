# Main Menu Spec Lock

Status: `accepted-with-fallback`  
Date: `2026-02-26`  
Scope: Stage 1 from `in-progress-roadmaps/roadmap-main-menu.md`

## Source and method

- Target source of truth was Figma file `fALJoRbR9Mxao3BintsOoJ`, but direct MCP extraction was blocked by account tool-call limit.
- Spec below is locked from:
  - reference screenshot: `assets/Main_page-ce94a42e-dd1f-4338-86a6-2846c663b589.png`,
  - existing assets used by this screen: `assets/background.svg`, `assets/logo-icon.svg`, `assets/logo-text.svg`, `assets/developer-logo.svg`.
- Pixel values are measured on canvas `393x852` and should be treated as `+-2px` where marked as estimated.

## Frame and safe area

| Item | Value |
|---|---|
| Reference frame (phone portrait) | `393x852` |
| Measured coordinate system | Full exported canvas (`x: 0..392`, `y: 0..851`) |
| Safe area (fallback note) | Not explicitly encoded in screenshot export; use platform `SafeArea` in implementation |

## Main sections layout

| Section | Bounds (x, y, w, h) | Notes |
|---|---|---|
| `background` | `0, 0, 393, 852` | Full-bleed gradient + decorative icon layer |
| `logo-group` (overall) | `~18, ~55, ~357, ~229` | Contains icon + title wordmark |
| `logo-icon` | `130, 55, 118, 118` | Bright area in screenshot; source asset is `146x146` |
| `logo-text` (visual) | `~18, ~205, ~357, ~79` | Wordmark area with glow and stroke |
| `action-buttons` (section) | `20, 471, 353, 120` | Two buttons + 12 px vertical gap |
| `developer-brand` | `~137, ~767, 119, 65` | Centered footer mark near bottom |

## Vertical rhythm and margins

| Metric | Value |
|---|---|
| Horizontal margin for primary actions | `20` |
| Top of screen -> top of logo icon | `55` |
| Logo icon bottom -> logo text top | `~33` |
| Logo text bottom -> actions section top | `~187` |
| Actions section bottom -> developer-brand top | `~176` |
| Developer-brand bottom -> screen bottom | `~20` |

## Buttons (`Quick Play`, `Customize`)

### Geometry

| Item | `Quick Play` | `Customize` |
|---|---|---|
| Bounds | `20, 471, 353, 54` | `20, 537, 353, 54` |
| Corner radius | `~10` | `~10` |
| Border | `1 px`, `#000000` | `1 px`, `#000000` |
| Fill | `#FFFFFF` | `#FFFFFF` |
| Spacing between buttons | `12 px` | n/a |

### Typography (fallback inference)

| Item | Value |
|---|---|
| Content | Uppercase (`QUICK PLAY`, `CUSTOMIZE`) |
| Family | `DynaPuff` (project font family) |
| Weight | `700` (visual match) |
| Size | `~18-20` |
| Letter spacing | `~0` |
| Text color | `#214336` (visual match from existing assets) |

### States

- `enabled`: white fill, black 1 px border, dark-green label.
- `pressed` (fallback spec): enabled style + subtle darkening (`~4%`) and scale `0.98`.
- `disabled` (fallback spec): fill `#D9D9D9`, border `#7A7A7A`, text opacity `~55%`.

## Colors, gradients, layers

### Background

| Item | Value |
|---|---|
| Base gradient start | `#151414` (top) |
| Base gradient end | `#2E7C5E` (bottom) |
| Decorative icon layer | Black with `0.08` opacity (from `assets/background.svg`) |

### Logo group

| Item | Value |
|---|---|
| Logo tile fill | `#FFFFFF` |
| Logo tile border | `#000000`, `5 px` |
| Brain glyph color | `#214336` |
| Wordmark fill | `#FFFFFF` |
| Wordmark outer stroke | `#000000` |
| Wordmark glow/shadows | Bottom `#01995E`, top `#997D01` (from `assets/logo-text.svg` filter) |

### Developer brand

| Item | Value |
|---|---|
| Card size | `119x65` |
| Corner radius | `6` |
| Fill | `#80F3D0` at `0.1` opacity |
| Border | `#000000`, `1 px` |

## Responsiveness lock (phone + tablet portrait)

Because strict tablet node measurements were not obtainable from Figma in this step, tablet behavior is locked as proportional rules:

- Keep `background` full-bleed and maintain decorative layer order.
- Keep `logo-group`, `action-buttons`, and `developer-brand` horizontally centered.
- On phone (`<=600dp`): use measured phone values above.
- On tablet (`>600dp`):
  - constrain action button width to `min(560dp, screenWidth - 2*20dp)`,
  - keep button height `54dp`,
  - preserve vertical order and approximate proportional spacing from phone baseline.

## Known deviations

- `Figma MCP` hard limit blocked direct extraction from Figma for this step.
- Stage 1 is accepted as `accepted-with-fallback` using screenshot + existing SVG assets.
- When MCP access is restored, replace this file with strict node-derived metrics and switch status to `done` (strict 1:1).
