# Roadmap implementacji - Splash Screen (component-first)

Ten dokument opisuje plan wdrozenia pierwszego ekranu (`Splash/Loading`) z podejsciem:
- najpierw komponenty wielokrotnego uzytku,
- potem integracja calego ekranu,
- na koncu walidacja 1:1 vs Figma.

## Zasady wykonania

1. Kazdy krok konczy sie bramka weryfikacyjna (`analyze`, `test`, uruchomienie aplikacji).
2. Zanim zacznie sie implementacja warstwy wizualnej, musi byc zamkniety `Spec Lock` dla node `1:55`.
3. Nie przechodzimy do nastepnego ekranu, dopoki splash nie ma statusu `accepted`.

## Etap 0 - Bootstrap projektu Flutter (wykonane)

Zakres:
- inicjalizacja projektu Flutter w repozytorium (Android + iOS),
- konfiguracja `pubspec.yaml` pod SVG i fonty DynaPuff,
- przygotowanie bazowej struktury pod dalsze ekrany.

Bramka:
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter run` (debug)

## Etap 1 - Spec Lock dla splash (`node 1:55`)

Cel: zamrozic specyfikacje 1:1 przed kodowaniem UI.

Do zebrania i zapisania:
- wymiary frame i safe area,
- pozycje oraz rozmiary elementow (`background`, `logo-icon`, `logo-text`, `developer-logo`, ewentualnie `brain`),
- kolory (hex/opacity),
- typografia (family, weight, size, line-height, letter-spacing),
- kolejnosc warstw i alignment.

Wynik:
- tabela `Spec Lock` (wartosci finalne) dodana do tego pliku albo osobnego pliku referencyjnego.

Status:
- `accepted-with-fallback` (zrealizowane na bazie pomiarow ze screena referencyjnego).
- Docelowe domkniecie strict 1:1 po odblokowaniu MCP Figma.
- Referencja metryk: `docs/splash-spec-lock.md`.

Bramka Etapu 1:
- `done` (mozna rozpoczac Etap 2.1 `AppBackground`).

## Etap 2 - Komponenty reusable (osobne kroki implementacji)

Kazdy komponent musi zostac zaimplementowany i zweryfikowany osobno:

### 2.1 `AppBackground`
- render `assets/background.svg`,
- skala i pozycjonowanie responsywne (phone/tablet),
- brak hardcoded pozycji pod konkretny model telefonu.

Bramka:
- `flutter analyze`
- screenshot porownawczy samego tla.

### 2.2 `AppLogoGroup`
- grupa logo (`logo-icon.svg` + `logo-text.svg`, opcjonalnie wariant z `brain.svg`),
- API komponentu: wariant, alignment, spacing.

Bramka:
- `flutter analyze`
- test widgetowy API wariantow i ukladu.

### 2.3 `DeveloperBrand`
- osobny komponent dolnej stopki oparty o `assets/developer-logo.svg`,
- pozycjonowanie wzgledem dolnej krawedzi i bezpiecznych obszarow.

Status:
- `done` (widget + integracja + testy + walidacja na 2 wysokosciach).
- Artefakty walidacji: `test/features/splash/presentation/screens/goldens/splash_screen_step_2_3_h852.png`, `test/features/splash/presentation/screens/goldens/splash_screen_step_2_3_h740.png`.

Bramka:
- `flutter analyze`
- screenshot porownawczy komponentu na 2 wysokosciach ekranu.

### 2.4 `SplashTypography`
- mapowanie stylow tekstu do tokenow (`ThemeExtension` lub dedykowany stylownik),
- uzycie rodzin `DynaPuff`, `DynaPuffCondensed`, `DynaPuffSemiCondensed`.

Bramka:
- `flutter analyze`
- testy stylow (smoke widget test).

## Etap 3 - Integracja `SplashScreenComposition`

Zakres:
- zlozenie ekranu splash z gotowych komponentow,
- odwzorowanie warstw i spacingu 1:1 zgodnie z `Spec Lock`,
- dodanie semantyki dostepnosci tam, gdzie ma sens.

Bramka:
- `flutter analyze`
- `flutter test`
- `flutter run`

## Etap 4 - Walidacja 1:1 i akceptacja

Checklist:
- spacing i pozycjonowanie zgodne z Figma,
- typografia zgodna z Figma,
- kolory i kontrast zgodne z Figma,
- proporcje SVG zgodne z Figma,
- wynik na Android i iOS.

Artefakty:
- 2 screenshoty porownawcze (co najmniej 2 rozdzielczosci),
- lista odchylen (`known deviations`) albo wpis `none`.

Bramka:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

## Etap 5 - Reguly Cursor dla kolejnych ekranow

Po zakonczeniu splash dopisujemy stale reguly do `.cursor/rules`:
- workflow `screen-by-screen`,
- workflow `component-first`,
- obowiazkowy `Spec Lock` przed implementacja wizualna,
- obowiazkowa walidacja 1:1 po integracji ekranu.

## Definicja zakonczonego etapu splash (`Definition of Done`)

Splash ma status `done`, gdy:
- wszystkie komponenty reusable z Etapu 2 sa gotowe,
- ekran z Etapu 3 jest zintegrowany,
- Etap 4 przeszedl bez krytycznych odchylen,
- dokumentacja i reguly z Etapu 5 sa uzupelnione.
