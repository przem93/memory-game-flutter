# Main Menu Stage 2.1 Validation

Date: `2026-02-26`
Scope: `MainMenuBackground`

## Commands run

- `flutter analyze`
- `flutter test --update-goldens test/main_menu_background_golden_test.dart`

## Result

- `flutter analyze`: passed with no issues.
- Golden screenshot generated: `test/main_menu_background_phone.png` (`393x852`).

## Comparison reference

- Project reference screenshot: `background-only-current.png` (`1080x2400`).
- The generated golden uses the spec-lock baseline frame (`393x852`), so direct pixel diff is not 1:1 due to different output resolutions.
- Visual comparison target for this stage: gradient direction/colors and decorative layer order/opacity behavior.

## Notes

- `MainMenuBackground` keeps explicit layer order: gradient -> decorative SVG -> child content.
- Decorative opacity is controllable through `decorativeOpacity` API and defaults to the locked baseline.
