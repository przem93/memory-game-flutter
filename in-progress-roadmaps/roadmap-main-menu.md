# Roadmap implementacji - Main Menu Screen (component-first)

Ten dokument opisuje plan wdrozenia kolejnego ekranu (`Main Menu`) z podejsciem:
- najpierw komponenty wielokrotnego uzytku,
- potem integracja calego ekranu,
- na koncu walidacja 1:1 vs Figma.

## Zasady wykonania

1. Kazdy krok konczy sie bramka weryfikacyjna (`analyze`, `test`, uruchomienie aplikacji).
2. Zanim zacznie sie implementacja warstwy wizualnej, musi byc zamkniety `Spec Lock` dla docelowego node ekranu `Main Menu` w Figma.
3. Nie przechodzimy do nastepnego ekranu, dopoki `Main Menu` nie ma statusu `accepted`.

## Etap 1 - Spec Lock dla `Main Menu` (Figma)

Cel: zamrozic specyfikacje 1:1 przed kodowaniem UI.

Do zebrania i zapisania:
- wymiary frame i safe area (telefon + tablet, portrait),
- pozycje i rozmiary: `background`, `logo-group`, `action-buttons`, `developer-brand`,
- spacing pionowy miedzy sekcjami i marginesy poziome,
- specyfikacja przyciskow (`Quick Play`, `Customize`): promienie, border, shadow, stany,
- kolory (hex/opacity), gradienty i kolejnosc warstw tla,
- typografia (family, weight, size, line-height, letter-spacing).

Wynik:
- tabela `Spec Lock` dodana do tego pliku albo osobnego pliku referencyjnego (`docs/main-menu-spec-lock.md`).

Bramka Etapu 1:
- `done` (mozna rozpoczac Etap 2.1 `MainMenuBackground`).

## Etap 2 - Komponenty reusable (osobne kroki implementacji)

Kazdy komponent musi zostac zaimplementowany i zweryfikowany osobno.

### 2.1 `MainMenuBackground`
- render tla zgodnie z Figma (gradient + warstwa ikon SVG),
- kontrola opacity ikon tla i kolejnosci warstw,
- responsywne skalowanie bez hardcoded pod jeden model telefonu.

Bramka:
- `flutter analyze`
- screenshot porownawczy samego tla.

### 2.2 `MainMenuLogoGroup`
- grupa logo (`logo-icon` + `logo-text`) jako oddzielny komponent,
- API komponentu: alignment, spacing, opcjonalny scale preset.

Bramka:
- `flutter analyze`
- test widgetowy wariantow API i ukladu.

### 2.3 `MainMenuPrimaryButton`
- wspolny komponent przycisku dla `Quick Play` i `Customize`,
- styl 1:1 (font, obrys, promien, wysokosc, padding),
- stany minimum: enabled, pressed, disabled.

Bramka:
- `flutter analyze`
- test widgetowy styli i stanow.

### 2.4 `MainMenuActionSection`
- sekcja ukladajaca przyciski akcji na ekranie,
- API sekcji: lista akcji, spacing miedzy przyciskami, semantyka.

Bramka:
- `flutter analyze`
- test widgetowy ukladu i semantyki.

### 2.5 `DeveloperBrand`
- wykorzystanie istniejacego komponentu stopki dewelopera (bez duplikacji),
- ewentualna adaptacja API pod `Main Menu` (offset/size variant), jesli wynika ze `Spec Lock`.

Bramka:
- `flutter analyze`
- screenshot porownawczy sekcji dolnej.

## Etap 3 - Integracja `MainMenuScreenComposition`

Zakres:
- zlozenie ekranu `Main Menu` z gotowych komponentow,
- odwzorowanie warstw i spacingu 1:1 zgodnie z `Spec Lock`,
- podpiecie akcji:
  - `Quick Play` -> start domyslnej rozgrywki,
  - `Customize` -> przejscie do ekranu konfiguracji,
- dodanie semantyki dostepnosci dla kluczowych elementow.

Bramka:
- `flutter analyze`
- `flutter test`
- `flutter run`

## Etap 4 - Walidacja 1:1 i akceptacja

Checklist:
- spacing i pozycjonowanie zgodne z Figma,
- typografia i rozmiary przyciskow zgodne z Figma,
- kolory, opacity i warstwy tla zgodne z Figma,
- proporcje logo i stopki dewelopera zgodne z Figma,
- wynik na Android i iOS.

Artefakty:
- min. 2 screenshoty porownawcze (2 rozdzielczosci),
- lista odchylen (`known deviations`) albo wpis `none`.

Bramka:
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build ios --simulator`

## Etap 5 - Dokumentacja i zamkniecie ekranu

Po akceptacji `Main Menu`:
- aktualizacja `README.md` i/lub `docs` o nowy ekran oraz flow nawigacji,
- wpis do `CHANGELOG.md` (jesli zmiana jest user-visible),
- odnotowanie finalnego statusu ekranu (`accepted`) i decyzji o odchyleniach.

## Definicja zakonczonego etapu `Main Menu` (`Definition of Done`)

`Main Menu` ma status `done`, gdy:
- wszystkie komponenty reusable z Etapu 2 sa gotowe,
- ekran z Etapu 3 jest zintegrowany i ma podlaczone akcje,
- Etap 4 przeszedl bez krytycznych odchylen,
- dokumentacja z Etapu 5 jest uzupelniona.
