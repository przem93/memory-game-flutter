# Customize Screen - Stage 5 Validation (1:1)

This document is the Stage 5 validation checklist and evidence log for
`Customize`, using local references as the source of truth.

## References

- `assets/customize-screen/Customize.svg`
- `assets/customize-screen/Customize.png`
- `docs/customize-screen-spec-lock.md`

## Validation Scope

- spacing and positioning match reference `Customize.svg|png`,
- typography and styling for `Select set` and `Cards grid` match references,
- set selector field (`Animals`) dimensions/style/icon alignment match references,
- all nine grid buttons (`8..24`) match reference dimensions and spacing,
- top logo row and developer brand alignment match non-main shell baseline rules,
- result is correct on Android and iOS (phone + tablet portrait).

## Evidence

- Phone comparison screenshot: `TODO`
- Tablet comparison screenshot: `TODO`

## Known Deviations

- `TODO` (`none` if fully aligned)

## Stage 5 Gate Results

- `flutter analyze`: `TODO`
- `flutter test`: `TODO`
- `flutter build apk --debug`: `TODO`
- `flutter build ios --simulator`: `TODO`
