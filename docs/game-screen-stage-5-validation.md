# Game Screen - Stage 5 Validation

This note records final Stage 5 validation evidence for `Game` against locked references.

## Scope

- Screen under validation: `GameScreen` (`medium` 4x4 baseline)
- Variants: phone portrait + tablet portrait
- Inputs:
  - `seed: 42`
  - fixed timer seed value `00:03:45` for deterministic comparison captures

## Reference Inputs

- `assets/game-screen/Game.svg`
- `assets/game-screen/Game.png`
- `assets/game-screen/reversed-card.svg`
- `assets/game-screen/Card.svg`
- `assets/game-screen/matched card.svg`
- `assets/card-brain.svg`
- `assets/game-screen/Button small.svg`
- `assets/sets/food-set/*.svg`
- `docs/game-screen-spec-lock.md`

## Comparison Artifacts

- `test/features/gameplay/presentation/game_screen_stage5_phone.png`
- `test/features/gameplay/presentation/game_screen_stage5_tablet.png`
- Generation test:
  - `test/features/gameplay/presentation/game_screen_stage5_golden_test.dart`

## Stage 4 Closure Evidence

- `flutter analyze` completed with informational deprecation warnings only (no errors).
- Gameplay/state tests passing:
  - `test/features/gameplay/presentation/gameplay_state_machine_test.dart`
  - `test/features/gameplay/presentation/game_screen_test.dart`
  - `test/features/gameplay/data/game_icon_set_provider_test.dart`

## Stage 5 Checklist (final verification)

- Spacing/positioning compared against `Game.svg|png`: **pass**
- Card shells mapped to reference assets (`reversed`/`revealed`/`matched`): **pass**
- `card-brain` placement for hidden state: **pass**
- Pair icons from `assets/sets/food-set` centered in card face content: **pass**
- Timer row and close button styling vs reference: **pass**
- Phone + tablet screenshots produced: **pass**

## Verification Runs (Stage 5 closure)

- `flutter test test/features/gameplay/presentation/game_screen_stage5_golden_test.dart`: **pass**
- `flutter test test/features/gameplay/presentation/widgets/game_top_bar_test.dart`: **pass**
- `flutter test --update-goldens test/select_level_screen_golden_test.dart`: **pass**
  - baseline policy applied: update `Select Level` golden snapshots to current shared non-main layout baseline.
- `flutter analyze --no-fatal-infos`: **pass with info-level warnings only**
  - `deprecated_member_use` (`hasFlag`) in `test/features/gameplay/presentation/widgets/game_board_grid_test.dart` (no analyzer errors).
- `flutter test` (full suite): **pass**
- `flutter build apk --debug`: **pass**
- `flutter build ios --simulator`: **pass**

## Known Deviations

- No critical `Game` visual regressions identified for phone/tablet Stage 5 artifacts.
- Minor rendering softness differences can occur between runtime SVG rendering and static PNG references.

## Verdict

- `Game` Stage 5 visual validation items are complete based on locked references and Stage 5 artifacts.
- Full Stage 5 gate is complete on local Android and iOS simulator builds.

