# Memory Game (Flutter)

Memory game application implemented in Flutter for Android and iOS.

## Product Scope

- Core gameplay works offline.
- Scores/achievements are designed to integrate with:
  - Game Center on iOS,
  - Google Play Games Services equivalent on Android.
- If platform services are unavailable, the game should continue in local-only mode.

## Design Source

- Main design:
  - `https://www.figma.com/design/fALJoRbR9Mxao3BintsOoJ/Memory-game-design?node-id=0-1`
- Components:
  - `https://www.figma.com/design/fALJoRbR9Mxao3BintsOoJ/Memory-game-design?node-id=4-4`

## Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Xcode (for iOS builds)
- Android Studio / Android SDK (for Android builds)
- Apple Developer and Google Play Console accounts for store releases

## Local Development

Typical commands:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Dependency note:

- `flutter_native_splash` is used to generate native launch screens for Android and iOS.

## Platform Notes

- Keep user-facing behavior aligned across Android and iOS.
- Isolate platform-specific integrations behind shared abstractions.
- Do not block core gameplay if Game Center / Play Games is unavailable.

## Manual Release (Current)

Release is currently manual for both stores.

- See `docs/release-manual.md` for release checklist.
- Keep privacy declarations, store metadata, and versioning updated per release.

## Documentation

- Development guidance: `docs/development-guide.md`
- Manual release process: `docs/release-manual.md`
- Main Menu Spec Lock: `docs/main-menu-spec-lock.md`
- Main Menu validation (Stage 4): `docs/main-menu-stage-4-validation.md`
- Main Menu closure (Stage 5): `docs/main-menu-stage-5-closure.md`
- Select Level Spec Lock: `docs/select-level-spec-lock.md`
- Select Level validation (Stage 5): `docs/select-level-stage-5-validation.md`
- Select Level closure (Stage 6): `docs/select-level-stage-6-closure.md`
- Game Spec Lock: `docs/game-screen-spec-lock.md`
- Game validation (Stage 5): `docs/game-screen-stage-5-validation.md`
- Game closure (Stage 6): `docs/game-screen-stage-6-closure.md`
- Cursor project rules: `.cursor/rules/`

## Main Menu

- `MainMenuScreen` is composed from reusable Stage 2 widgets in
  `lib/features/main_menu/presentation/widgets/`.
- Primary actions:
  - `Quick Play` opens `SelectLevelScreen`; choosing a difficulty starts gameplay
    board initialization with mapped grid config.
  - Gameplay `Close` in `GameTopBar` returns to `SelectLevelScreen` (MVP flow).
  - `Customize` navigates to the game configuration flow.
- Visual implementation and acceptance notes are documented in the Main Menu
  files listed in the Documentation section.
