# Main Menu Stage 2.5 Validation

Date: `2026-02-26`  
Scope: `MainMenuDeveloperBrand`

## Commands run

- `flutter analyze`
- `flutter test test/main_menu_developer_brand_test.dart`
- `flutter test --update-goldens test/main_menu_developer_brand_golden_test.dart`

## Result

- `flutter analyze`: passed with no issues.
- Widget tests: passed (`2` tests) for geometry and semantics.
- Golden screenshot generated: `test/main_menu_developer_brand_phone.png` (`393x852`).

## Comparison reference

- Spec baseline: `docs/main-menu-spec-lock.md` (`developer-brand` section).
- Visual target: developer footer card centered near bottom with locked phone geometry (`119x65`) and `~20px` bottom offset.

## Notes

- The component reuses `assets/developer-logo.svg` and exposes phone/tablet scale presets.
- Tablet preset in Stage 2.5 keeps proportional scale while preserving bottom anchoring behavior.
