# Implementation Roadmap - Game Screen Layout Refinement (fit cards, no scroll, no developer logo)

Roadmap zmian na ekranie gry (`Game Screen`): dynamiczne dopasowanie rozmiaru kart do wolnej przestrzeni (bez scrolla) oraz usunięcie developer logo z tego ekranu. Wzorowana na istniejących roadmapach (component-first, Spec Lock → implementacja → walidacja).

## Zakres (Scope)

- **W obrębie:** ekran `Game Screen` — układ, rozmiar kart, widoczność developer brand.
- **Cel:** karty mieszczą się w całości na wszystkich rozmiarach ekranu (phone/tablet, różne gęstości); brak przewijania; brak developer logo na game screen.
- **Poza zakresem:** zmiany w innych ekranach, zmiany w assetach kart, zmiany w pętli rozgrywki.

## Execution Rules

1. Każdy etap kończy się bramką weryfikacji (`analyze`, `test`, ewentualnie `run`/`build`).
2. Przed implementacją UI obowiązuje Spec Lock dla tej zmiany.
3. Roadmapa jest uznana za zakończoną po statusie `accepted` i przeniesieniu do `done-roadmaps`.

## Stage 1 - Spec Lock dla Game Screen Layout Refinement

**Cel:** zamrożenie specyfikacji zmiany przed kodowaniem.

**Do zebrania i udokumentowania:**

- **Wolna przestrzeń na game screen:**
  - pion: od dołu paska `GameTopBar` (po `_topBarToBoardGap`) do dołu safe area, minus paddingi dolne (obecnie `_phoneBoardBottomPadding` / `_tabletBoardBottomPadding`),
  - poziom: szerokość ekranu minus marginesy boczne (`_phoneHorizontalMargin` / `_tabletHorizontalInset`),
- **Wymaganie:** cała siatka kart (`GameBoardGrid`) musi się mieścić w tej wolnej przestrzeni bez przewijania; rozmiar kart wynika wyłącznie z tej przestrzeni i proporcji kart (`cardAspectRatio`),
- **Algorytm:** przy ograniczonej wysokości — najpierw sprawdzić, czy karty dopasowane do szerokości mieszczą się w wysokości; jeśli nie — dopasować rozmiar kart do wysokości (zachowując `cardAspectRatio`),
- **Developer logo:** na game screen **nie** wyświetlać developer brand (footer); zachować ten element na pozostałych ekranach non-main,
- **Kontrakt:** `GameBoardGrid` otrzymuje **ograniczone** (bounded) `maxWidth` i `maxHeight` od rodzica; wewnętrznie wybiera rozmiar planszy (i kart) tak, aby całość mieściła się w tych granicach.

**Output:**

- dokument Spec Lock: `docs/game-screen-layout-refinement-spec-lock.md`,
- lista założeń i ewentualnych odstępstw.

**Bramka Stage 1:**  
- status `done` (można startować Stage 2).

**Status:**  
- `pending`.

---

## Stage 2 - Zmiany w komponentach i ekranie

Każdy krok implementowany i weryfikowany osobno.

### 2.1 Ukrycie developer brand na Game Screen

- **GameSceneShell** lub **NonMainSceneShell:** dodać parametr umożliwiający pominięcie footera z developer brand (np. `showDeveloperBrand`, domyślnie `true`),
- Na `GameScreen` użyć wariantu **bez** developer brand,
- Nie zmieniać zachowania innych ekranów (Select Level, Customize, Success, Select Set) — nadal wyświetlają developer brand.

**Bramka:**  
- `flutter analyze`,  
- testy widgetowe/scenariuszowe potwierdzające brak brandu na game screen i obecność na innym wybranym non-main screen.

**Status:**  
- `pending`.

### 2.2 Przekazanie ograniczonej wysokości do planszy i usunięcie scrolla

- W **GameScreen:**  
  - usunąć `SingleChildScrollView` wokół `GameBoardGrid`,  
  - pozostawić `GameBoardGrid` jako bezpośrednie dziecko obszaru `Expanded` (z zachowaniem istniejącego `Padding`),  
  - tak aby `GameBoardGrid` otrzymywał od `LayoutBuilder`/`Expanded` ograniczone `maxHeight` (wolna przestrzeń),
- **GameBoardGrid:**  
  - zachować obecną logikę `_resolveBoardSize` (dopasowanie po szerokości lub po wysokości);  
  - przy bounded height logika height-based zapewni, że karty zmieszczą się w pionie;  
  - ewentualnie dodać krótki komentarz w kodzie, że oczekiwane są bounded constraints przy użyciu na game screen.

**Bramka:**  
- `flutter analyze`,  
- `flutter test` (istniejące testy gameplayu i gridu),  
- wizualna weryfikacja na jednym rozmiarze phone i tablet — cała plansza widoczna bez scrolla.

**Status:**  
- `pending`.

### 2.3 Dopasowanie dolnego paddingu (opcjonalne)

- Po usunięciu developer brand z game screen dolny padding (`_phoneBoardBottomPadding` / `_tabletBoardBottomPadding`) można zredukować do np. minimalnego marginesu od safe area (żeby plansza nie przyklejała się do krawędzi),
- Wartości zaktualizować w Spec Lock i w `GameScreen` tak, aby zachować spójny wygląd.

**Bramka:**  
- `flutter analyze`,  
- krótka weryfikacja wizualna.

**Status:**  
- `pending`.

---

## Stage 3 - Integracja i testy

- Upewnić się, że wejścia na game screen (Select Level, Customize) nie zmieniły się pod względem nawigacji,
- Przetestować wszystkie poziomy trudności (simple, medium, hard) oraz różne konfiguracje z Customize (jeśli używane) na phone i tablet,
- Testy golden / screenshoty zaktualizować dla game screen (rozmiary kart będą zależne od ekranu).

**Bramka:**  
- `flutter analyze`,  
- `flutter test`,  
- `flutter run` (phone + tablet),  
- aktualizacja goldens: `flutter test … --update-goldens` dla zmienionych testów game screen.

**Status:**  
- `pending`.

---

## Stage 4 - Walidacja 1:1 i akceptacja

- Spacing i proporcje kart zgodne z Spec Lock (karty w całości, bez scrolla),
- Developer logo niewidoczne na game screen,
- Zachowanie na Android i iOS (phone + tablet portrait),
- Lista ewentualnych odstępstw w `docs/game-screen-layout-refinement-validation.md`.

**Bramka:**  
- `flutter analyze`,  
- `flutter test`,  
- `flutter build apk --debug`,  
- `flutter build ios --simulator`.

**Status:**  
- `pending`.

---

## Stage 5 - Dokumentacja i zamknięcie

- Aktualizacja `docs` (opis game screen: brak scrolla, brak developer logo, dynamiczny rozmiar kart),
- Wpis w `CHANGELOG.md` (user-visible: karty dopasowują się do ekranu, brak scrolla; usunięcie developer logo z ekranu gry),
- Przeniesienie roadmapy do `done-roadmaps` po akceptacji.

**Bramka:**  
- dokumentacja i changelog zaktualizowane i spójne z implementacją.

**Status:**  
- `pending`.

---

## Definition of Done (Game Screen Layout Refinement)

Roadmapa uznana za **done** gdy:

- Stage 1 Spec Lock jest zatwierdzony i udokumentowany,
- Stage 2 (ukrycie brandu, bounded height, ewentualnie padding) zakończony i przetestowany,
- Stage 3 integracja i testy przechodzą,
- Stage 4 walidacja 1:1 zakończona bez krytycznych odstępstw,
- Stage 5 dokumentacja i changelog zaktualizowane,
- Roadmapa przeniesiona do `done-roadmaps`.

**Status końcowy:**  
- `pending`.
