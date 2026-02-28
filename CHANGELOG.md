# Changelog

All notable user-visible changes to this project are documented in this file.

## Unreleased

### Added

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

### Changed

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
