# Changelog

All notable user-visible changes to this project are documented in this file.

## Unreleased

### Added

- **AdMob / privacy (Stage 5):** User Messaging Platform (UMP) runs before ad SDK initialization; optional **Ad privacy settings** link on the main menu when the platform requires a privacy-options entry point. Documentation: `docs/admob-privacy-ump-compliance.md`.

- Customize Cards grid: added **6 cards** (2×3) option for an easier, balanced layout.
- Implemented the `MainMenuScreen` with reusable component composition:
  background, logo group, primary action section, and developer brand footer.
- Added locked screen golden baselines for phone and tablet:
  `test/main_menu_screen_phone.png` and `test/main_menu_screen_tablet.png`.
- Implemented `SelectLevelScreen` with reusable `Select level` title and
  difficulty options (`Simple`, `Medium`, `Hard`).
- Added Select Level flow wiring from `Quick Play` to gameplay board
  initialization via difficulty mapping (`3x4`, `4x4`, `4x5`).
- Implemented `GameScreen` gameplay loop with deterministic pair setup,
  match/mismatch state transitions, and elapsed timer behavior across
  `simple`, `medium`, and `hard` boards.
- Implemented `SuccessScreen` post-completion flow with final elapsed time
  presentation, `Play again` replay for the same difficulty, and `Close`
  navigation back to `MainMenuScreen`.
- Implemented `CustomizeScreen` composition (`Select set` + `Cards grid`) and
  wired `Main Menu -> Customize -> Game` flow with direct card-count start.
- Added locked Customize mapping payload (`cardCount -> rows x columns -> pairs`)
  with fallback to `16` and default set key `food-set`.
- Implemented `SelectSetScreen`: Customize -> tap set selector -> Select Set
  screen -> choose Animals or Food -> return to Customize with selected set.
- Selected set is used for card icons in game (MVP sets: `animals-set`,
  `food-set`).

### Changed

- **Game screen:** Cards now fit the available screen space (phone and tablet) without scrolling; card size is dynamic (aspect ratio preserved). Developer logo (footer) is no longer shown on the game screen; other screens (Select Level, Customize, Success, Select Set) unchanged.
- **Customize Cards grid**: removed **22 cards** (2×11) option; replaced with 6 cards for better screen fill. Supported counts are now 6, 8, 10, 12, 14, 16, 18, 20, 24. Mapping table and spec lock updated accordingly.
- Added a `CLOSE` action on `SelectLevelScreen` below difficulty options
  (30 px spacing) to let players return directly to Main Menu.
- Finalized Main Menu documentation closure in:
  - `docs/main-menu-spec-lock.md`,
  - `docs/main-menu-stage-4-validation.md`,
  - `docs/main-menu-stage-5-closure.md`.
- Kept Main Menu status as `accepted-with-known-deviations` due to remaining
  visual differences against the latest provided phone reference screenshot.
- Finalized Select Level documentation closure in:
  - `docs/select-level-spec-lock.md`,
  - `docs/select-level-stage-5-validation.md`,
  - `docs/select-level-stage-6-closure.md`.
- Marked Select Level as `done` with acceptance level
  `accepted-with-known-deviations`.
- Improved Select Level responsive composition by switching to a vertical layout
  flow with proportional spacing, reducing overlap risk on real device viewports.
- Updated Select Level golden baselines (`phone` + `tablet`) to match the current
  shared non-main scene layout policy used by gameplay-adjacent screens.
- Added Game Stage 5/6 documentation set:
  - `docs/game-screen-stage-5-validation.md`,
  - `docs/game-screen-stage-6-closure.md`.
- Cleared local Xcode prerequisite and completed final `Game` Stage 5 gate,
  including successful `flutter build ios --simulator`; `Game` roadmap status
  is now closed as `done`.
- Reduced revealed/matched gameplay card icon scale so symbols fit card faces
  with better visual balance during play.
- Added Success Stage 5/6 documentation set:
  - `docs/success-screen-stage-5-validation.md`,
  - `docs/success-screen-stage-6-closure.md`.
- Closed Success roadmap as `done` after Stage 6 documentation sync.
- Added Customize Stage 3 integration documentation:
  - `docs/customize-screen-stage-3-integration.md`.
- Finalized Customize Stage 5/6 documentation set:
  - `docs/customize-screen-stage-5-validation.md`,
  - `docs/customize-screen-stage-6-closure.md`.
- Closed Customize roadmap as `done` after Stage 6 documentation sync;
  acceptance level `accepted-with-known-deviations` (set icon from food-set vs
  reference cookie-like, acceptable per scope lock).
- Customize flow: set selector opens `SelectSetScreen` for user to choose
  Animals or Food; selected set is passed to gameplay for card icons.
