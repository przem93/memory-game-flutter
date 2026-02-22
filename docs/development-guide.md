# Development Guide

## Purpose

This document aligns day-to-day development with the project rules in `.cursor/rules/`.

## Architecture Direction

- Use clear separation between presentation, domain, and data concerns.
- Keep game logic independent from UI widgets where possible.
- Isolate platform-specific code in adapters with shared interfaces.

## UI Implementation from Figma

- Treat Figma as visual source of truth.
- Build reusable widgets for repeating design components.
- Centralize spacing, typography, and colors in shared tokens/theme.
- Include screenshots for significant UI changes during review.

## Quality and Testing

- Run formatter, analyzer, and tests before opening PRs.
- Cover game rules with unit tests.
- Cover key screen behavior with widget tests.
- Add integration tests for critical end-to-end flows.

## Platform Services

- iOS: Game Center integration for leaderboard/achievement features.
- Android: Play Games Services equivalent integration for the same feature set.
- Gameplay must remain functional when platform services are unavailable.

## Definition of Done

A feature is done when:

- implementation matches scope and architecture rules,
- required tests are added and passing,
- documentation is updated (`README.md` and/or `docs`),
- Android/iOS impact is documented in PR notes.
