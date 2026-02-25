# Splash Spec Lock (`node 1:55`)

## Context

- Source of truth target: Figma file `Memory-game-design` (`fALJoRbR9Mxao3BintsOoJ`), node `1:55`.
- Current capture source: `assets/Start_page-890efb97-86c9-4bbf-ad38-969b1403693f.png`.
- Figma MCP status during this step: request limit reached for the seat plan.
- This document is a locked fallback spec from screenshot measurements to unblock component-first implementation.

## Canvas

| Property | Value |
| --- | --- |
| Reference frame size | `393 x 852` px |
| Safe area top | not confirmed from Figma (use platform safe area in implementation) |
| Safe area bottom | not confirmed from Figma (use platform safe area in implementation) |

## Layer order and composition

1. Gradient background (full frame).
2. Decorative outline icons/patterns (low-opacity overlay).
3. Logo icon card (centered horizontally, upper-mid area).
4. Brand text (`MEMORY`) below logo icon, centered.
5. Developer logo is not visible in this reference capture (treat as optional layer until Figma unlock).

## Measured element bounds (from screenshot)

Coordinates are `x, y` from top-left of the frame.

| Element | Bounding box | Size | Alignment |
| --- | --- | --- | --- |
| Logo icon card (outer) | `x=130..247`, `y=309..425` | `118 x 117` px | centered (`cx ~ 196`) |
| Brain mark inside icon | `x=150..230`, `y=341..396` | `81 x 56` px | centered in icon |
| `MEMORY` text group | `x=24..359`, `y=470..529` | `336 x 60` px | centered (`cx ~ 191.5`) |

## Vertical spacing (from screenshot)

| Between | Value |
| --- | --- |
| Icon bottom to text top | `45` px |
| Top edge to icon top | `309` px |
| Text bottom to frame bottom | `323` px |

## Color tokens (fallback estimates)

These values are extracted from screenshot pixels and should be replaced by exact Figma tokens when MCP/API access is available again.

| Token | Value | Notes |
| --- | --- | --- |
| Background gradient top | `#161515` | center-top sample |
| Background gradient bottom | `#29654E` | center-bottom sample |
| Primary surface (logo/text fill) | `#F8F8F8` (approx) | anti-aliased white |
| Primary stroke/shadow | `#000000` (approx) | dark outline around logo/text |
| Accent glow | `#B89A2A` (approx) | subtle yellow glow near text |
| Decorative overlay | `#183028`..`#286850` (range) | low-contrast background motifs |

## Typography fallback (to be finalized from Figma)

| Property | Value |
| --- | --- |
| Family | `DynaPuff` / condensed variants (project baseline) |
| Weight | visually bold (`700` estimated for logo wordmark) |
| Exact size / line-height / letter spacing | not confirmed from Figma; derive in `SplashTypography` and verify against screenshot |

## Known deviations

- Exact Figma metrics and token names are not yet validated due to Figma MCP call limit.
- Developer logo position/size cannot be locked from this capture because the element is not visible.

## Stage 1 acceptance decision

- Decision: `accepted-with-fallback`.
- Rationale: unblocks Etap 2 (component-first implementation) while preserving a measurable baseline.
- Exit condition to upgrade to strict `accepted`: replace fallback rows with exact Figma values when MCP access is restored.
