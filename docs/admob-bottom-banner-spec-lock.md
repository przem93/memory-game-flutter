# AdMob bottom banner — Spec Lock (Stage 1)

Status: `accepted` (MVP product lock for implementation Stages 2–4)  
Date: `2026-03-22`  
Scope: Stage 1 from `in-progress-roadmaps/roadmap-admob-bottom-banner.md`

## Sources and scope

- **Roadmap:** `in-progress-roadmaps/roadmap-admob-bottom-banner.md`
- **Design:** Figma file `Memory-game-design` (`fALJoRbR9Mxao3BintsOoJ`) — if a dedicated ad slot frame is added later, update this doc and screen specs; until then, behaviour below is authoritative for layout and engineering.
- **Scope of this spec:** bottom ad **slot** (format, size policy, stacking with developer brand, safe area), reserved space and non-jumping UI, accessibility, and the **contract** for how shells (`NonMainSceneShell`, `GameSceneShell`, main menu) must reserve vertical space. SDK wiring and UMP are **out of scope** here (Stages 2 and 5).

## Product lock (MVP)

These decisions unblock Stage 2+ without further product round-trips:

| Decision | Lock |
|----------|------|
| Ad format | **Adaptive banner** (anchored), using Google Mobile Ads APIs that return size from current width/orientation — not a fixed small banner size for all devices. |
| Physical order (bottom → up) | **1)** Ad slot (bottom-most in the app content column). **2)** `MainMenuDeveloperBrand` **above** the ad when the brand is shown. **3)** Screen body in `Expanded` above both. Same rule on **Main Menu** and **non-main** flows after layout work (Stage 4). |
| Reserved space | **Fixed-height** slot for the current adaptive size + **placeholder** of the same height on load/error/no-fill so layout **does not jump**. No collapsing the strip in MVP. |
| Game screen | Ad strip is **always** present (same as other screens); it **reduces** the vertical space available to `GameBoardGrid` (bounded height contract). |
| Orientation | **Portrait** for phone and tablet, matching current app scope; if landscape is added later, re-validate adaptive height. |

## Ad format and slot height

- Use **anchored adaptive banner** as described in the `google_mobile_ads` package (e.g. `AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(context, width)` or platform-equivalent per current package docs).
- The **slot widget** must reserve vertical space **at least** the height returned for the current width/orientation (implementation may read size once per layout pass / orientation change).
- **Maximum height:** adaptive banners are capped by Google’s rules for the device; document concrete numbers in code comments if needed. Do not hardcode a single pixel height for all devices unless it is the **minimum** reserved strip — the lock is “match adaptive result + stable placeholder”.

## Placement and safe area

- The ad strip lives **inside** the same `SafeArea` as the rest of the screen content (today: `MainMenuBackground` → `SafeArea` → …), so it does not draw under system home indicators or conflict with gesture navigation insets.
- The strip is **flush to the bottom** of that safe content column (full width of the safe area unless a future design adds horizontal insets).

## Vertical stacking (column order, top → bottom)

For shells that use a vertical `Column`:

1. `Expanded` — primary screen content (logo, lists, game board area, etc.).
2. `MainMenuDeveloperBrand` — **only when** `showDeveloperBrand == true` (non-main screens except game).
3. **Ad banner slot** — always last (lowest on screen).

**Game screen (`GameSceneShell` / `GameScreen`):** `showDeveloperBrand` is false; stack is `Expanded` (game UI) then **ad slot** only — ad remains the bottom-most row inside `SafeArea`.

**Main menu (Stage 4 target):** today `MainMenuScreen` uses a `Stack` with `MainMenuDeveloperBrand` aligned to the bottom. Target: equivalent vertical semantics — body fills space above, then brand, then ad at the bottom — prefer refactoring toward a **Column** + `Expanded` for the main content where feasible, consistent with project rules (responsive vertical flow, avoid unnecessary `Positioned`).

## Reserved space, loading, and error states

- **Loading:** show placeholder (empty or neutral) filling the **same** height as the eventual ad slot.
- **Loaded:** `AdWidget` (or equivalent) in that slot.
- **Error / no fill:** same height; optional subtle placeholder — **no** removal of the strip height in MVP.
- Implementation must **dispose** `BannerAd` instances correctly (Stage 3).

## Game screen: available height for `GameBoardGrid`

After AdMob integration, the vertical space for the board **shrinks** by the **ad slot height** in addition to existing `GameScreen` padding.

**Contract (extends `docs/game-screen-layout-refinement-spec-lock.md`):**

- **Previous end** of the board region: bottom of safe area minus `_phoneBoardBottomPadding` / `_tabletBoardBottomPadding` (see `game_screen.dart`).
- **With ad strip:** the `Expanded` region that contains the board must be laid out so its bottom edge is **above** the ad slot. Equivalently:

`availableHeightForBoard = height(Expanded board region)` as constrained by parent, where the parent column includes the ad slot with fixed reserved height **H_ad** at the bottom.

So **H_ad** must be included in layout math when sizing the board; regression tests must cover smallest supported heights (see roadmap risks).

**Source of truth for pre-ad layout:** `docs/game-screen-layout-refinement-spec-lock.md` § “Available space on game screen”. **Source of truth for ad-augmented layout:** this document + implementation in `GameSceneShell` / `GameScreen`.

## Accessibility

- Wrap the ad region in `Semantics` with a clear label (e.g. **“Reklama”** for Polish UI, or **“Advertisement”** if the app shell is English-only — follow the same language strategy as the rest of the app).
- Do not rely on colour alone for placeholder states; keep touch targets outside the ad unless the ad network provides them (banner handles its own content).

## Related documentation

- `docs/game-screen-layout-refinement-spec-lock.md` — board area before explicit **H_ad**; superseded for vertical extent once Stage 4 lands (see § “Future extension” there).
- `docs/game-screen-spec-lock.md` § “Layout refinement – current behaviour” — link to this doc for post–Stage 4 board bounds.

## Stage 1 gate checklist

Stage 1 is **done** when:

- This file (`docs/admob-bottom-banner-spec-lock.md`) exists and matches the roadmap Stage 1 output.
- Format (adaptive), stacking (brand above ad, ad bottom-most), fixed reserved strip, game-screen height contract, and semantics are locked.
- Related specs cross-reference this document where layout bounds change after implementation.

After Stage 1 is marked `done` in the roadmap, Stage 2 (SDK + init + platform IDs) may start.
