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
- Cursor project rules: `.cursor/rules/`
