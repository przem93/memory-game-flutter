# Changelog

All notable user-visible changes to this project are documented in this file.

## Unreleased

### Added

- Implemented the `MainMenuScreen` with reusable component composition:
  background, logo group, primary action section, and developer brand footer.
- Added locked screen golden baselines for phone and tablet:
  `test/main_menu_screen_phone.png` and `test/main_menu_screen_tablet.png`.

### Changed

- Finalized Main Menu documentation closure in:
  - `docs/main-menu-spec-lock.md`,
  - `docs/main-menu-stage-4-validation.md`,
  - `docs/main-menu-stage-5-closure.md`.
- Kept Main Menu status as `accepted-with-known-deviations` due to remaining
  visual differences against the latest provided phone reference screenshot.
