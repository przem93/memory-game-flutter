# Implementation Roadmap — dolny pasek reklamowy AdMob (wszystkie ekrany)

Roadmapa wprowadzenia **zarezerwowanego miejsca** na reklamę (banner AdMob) jako **pasek u dołu ekranu** na **każdym** ekranie aplikacji. Wzorowana na istniejących roadmapach: **Spec Lock → implementacja component-first → walidacja 1:1 / testy**.

## Zakres (Scope)

- **W obrębie:** integracja Google Mobile Ads (AdMob), wspólny slot reklamy u dołu, wpływ na layout (phone + tablet, portrait), dokumentacja i wpisy zgodności ze sklepami.
- **Cel:** na każdym ekranie jest **przewidywalne, zarezerwowane** miejsce na banner; treść reklamy ładuje się w tym slocie; przy braku reklamy (błąd sieci, polityka, dev) UI nie „skacze” — slot pozostaje lub pokazuje bezpieczny placeholder zgodnie ze Spec Lock.
- **Poza zakresem (na ten etap, chyba że produkt rozstrzygnie inaczej):** reklamy pełnoekranowe (interstitial/rewarded), subskrypcja „usuń reklamy”, zaawansowana personalizacja zgody UMP poza minimalnym wymaganiem prawnym, zmiany w logice rozgrywki.

## Execution Rules

1. Każdy etap kończy się bramką weryfikacji (`flutter analyze`, `flutter test`, ewentualnie `flutter run` / build na obu platformach).
2. Przed implementacją UI obowiązuje **Spec Lock** dla slota reklamy (wymiary względem safe area, developer brand, treść ekranu).
3. Roadmapa jest uznana za zakończoną po statusie `accepted` i przeniesieniu pliku do `done-roadmaps`.
4. Nowe zależności i identyfikatory AdMob muszą być udokumentowane (README / docs), z uwzględnieniem wpływu na Android i iOS.

---

## Stage 1 — Spec Lock (Figma / produkt + ograniczenia techniczne)

**Cel:** zamrożenie specyfikacji slota reklamy przed kodowaniem.

**Do zebrania i udokumentowania:**

- **Format reklamy:** banner klasyczny vs **adaptive banner** (zalecane przez Google dla różnych szerokości); maksymalna wysokość slota na phone/tablet.
- **Położenie:** stały pas **na dole** obszaru bezpiecznego (`SafeArea`) lub z uwzględnieniem **systemowych insetów** (gestural navigation); brak nakładania się na przyciski systemowe.
- **Stos warstw w pionie (kolejność od dołu):**
  - slot reklamy,
  - `MainMenuDeveloperBrand` (tam gdzie jest wyświetlany),
  - ewentualnie inne stałe elementy dolne zgodnie z projektem.
  Ustalenie: czy reklama jest **nad** developer brand, czy **pod** — i konsekwentne zastosowanie na **Main Menu** oraz **Non-main** (`NonMainSceneShell` i ekrany pośrednie: Select Level, Select Set, Customize, Success; **Game** przez `GameSceneShell`).
- **Zarezerwowana przestrzeń:** minimalna wysokość slota nawet gdy reklama nie załadowana (placeholder o stałej wysokości **albo** jawna decyzja produktu o zwijaniu — wtedy opisać wpływ na layout i testy golden).
- **Ekran gry:** slot reklamy musi **zmniejszać** dostępną wysokość dla planszy (`GameBoardGrid` / `Expanded`) — aktualizacja założeń jak w `roadmap-game-screen-layout-refinement` (bounded height obejmuje także pas reklamy).
- **Dostępność:** semantyka / etykiety dla obszaru reklamowego (np. „Reklama”) zgodnie z wytycznymi projektu.

**Output:**

- dokument Spec Lock, np. `docs/admob-bottom-banner-spec-lock.md`,
- ewentualna aktualizacja istniejących speców ekranów, jeśli Figma wprowadza dedykowany slot wizualny.

**Bramka Stage 1:** status `done` (można startować Stage 2).

**Status:** `done` (Spec Lock: `docs/admob-bottom-banner-spec-lock.md`).

---

## Stage 2 — Infrastruktura AdMob (zależności, identyfikatory, inicjalizacja)

**Cel:** bezpieczne podłączenie SDK bez rozpraszania logiki UI po ekranach.

- Dodać oficjalny plugin **`google_mobile_ads`** (wersja zgodna z dokumentacją i z `pubspec.yaml` lockiem).
- **Inicjalizacja** `MobileAds.instance.initialize()` w odpowiednim miejscu cyklu aplikacji (np. po `WidgetsFlutterBinding.ensureInitialized()`), bez blokowania pierwszego klatkowania UI w sposób powodujący ANR — ewentualnie lazy init zgodnie z dobrymi praktykami pakietu.
- **Konfiguracja platform:**
  - **iOS:** `GADApplicationIdentifier` w `Info.plist`, App Transport Security jeśli wymagane, ewentualne `SKAdNetworkItems` wg aktualnej listy Google.
  - **Android:** `APPLICATION_ID` w `AndroidManifest`, ewentualnie konfiguracja ProGuard/R8 jeśli dotyczy.
- **Identyfikatory jednostek reklamowych:** osobne **testowe** ID na dev/debug; produkcyjne z konsoli AdMob trzymane poza repo lub przez bezpieczny mechanizm konfiguracji (opisać w docs — bez commitowania sekretów).
- **Fallback:** przy niepowodzeniu inicjalizacji — aplikacja działa dalej (zgodnie z filozofią „graceful degradation” z reguł projektu); slot zachowuje się zgodnie ze Spec Lock.

**Bramka:** `flutter analyze`, build debug **Android + iOS** (symulator/emulator wystarczy do smoke), krótki opis w `docs` lub README.

**Status:** `done` (setup: `docs/admob-google-mobile-ads-setup.md`, init w `lib/main.dart`, Android/iOS jak w dokumencie).

---

## Stage 3 — Komponent(y) UI: slot + banner (component-first)

**Cel:** jeden lub kilka reużywalnych widgetów, testowalnych osobno.

### 3.1 `AdBannerSlot` (lub nazwa zgodna z konwencją projektu)

- Stała **wysokość** lub `LayoutBuilder` dla adaptive banner — zgodnie ze Spec Lock.
- Stany: **ładowanie**, **wyświetlona reklama**, **błąd / brak fill** — spójne z decyzją o placeholderze.
- Semantics zgodnie ze Spec Lock.

**Bramka:** `flutter analyze`, testy widgetowe minimalne (np. wymiary, obecność placeholderu).

**Status:** `pending`.

### 3.2 Integracja z `BannerAd` / adaptive

- Użycie oficjalnego API (`BannerAd`, `AdWidget` lub adaptive) z prawidłowym **dispose** i cyklem życia.
- **Nie** tworzyć wielu instancji bez potrzeby; rozważyć jedną reklamę na ekran vs cache — opisać wybór w kodzie/docs.

**Bramka:** `flutter test`, ręczny smoke z testowymi ID.

**Status:** `pending`.

---

## Stage 4 — Integracja na wszystkich ekranach (layout)

**Cel:** reklama jest częścią **wspólnego szkieletu**, a nie kopiowana ad hoc w każdym pliku ekranu.

- **`NonMainSceneShell`:** rozszerzyć układ `Column` tak, aby **na dole** (nad lub pod developer brand — wg Spec Lock) był stały slot; `Expanded` dla treści musi uwzględniać utratę wysokości.
- **`GameSceneShell` / `GameScreen`:** upewnić się, że **plansza** dostaje poprawnie zmniejszone `maxHeight` (łącznie z reklamą), bez scrolla zgodnie z obecnymi założeniami.
- **`MainMenuScreen`:** obecnie `Stack` + `MainMenuDeveloperBrand` — wprowadzić slot w sposób zgodny ze Spec Lock (np. `Column` z `Expanded` + dolny blok z brandem i reklamą, albo precyzyjne `Positioned` **tylko** jeśli Spec Lock na to pozwala — preferencja projektu: responsywne układy pionowe).
- **Splash / inne ekrany** (jeśli istnieją poza powyższymi): objąć tym samym wzorcem lub jednym `MaterialApp`/`Navigator` wrapperem — **nie** duplikować logiki reklamy.

**Bramka:** `flutter analyze`, `flutter test`, wizualna kontrola phone + tablet, przejście przez cały flow nawigacji z `lib/core/app.dart`.

**Status:** `pending`.

---

## Stage 5 — Zgody, prywatność, sklepy (minimalny zestaw MVP)

**Cel:** spełnić wymagania Google Play i App Store dotyczące reklam i prywatności.

- **Polityka prywatności / deklaracje:** aktualizacja pod reklamy i ewentualnie personalizację (w zakresie faktycznie używanych SDK).
- **UMP / zgody (UE/EEA):** jeśli produkt targetuje te regiony — zaplanować integrację zgodnie z wymaganiami Google (moment w roadmapie: przed produkcją lub jako pod-etap z jasnym kryterium „done”).
- **Store listings:** opis, kategorie reklam — zgodnie z checklistą release.

**Bramka:** spójność `docs`, ewentualnie `CHANGELOG.md` przy user-visible disclosure.

**Status:** `pending**.

---

## Stage 6 — Testy regresji, golden, wydajność

- Aktualizacja testów złotych / screenshotów dla ekranów, których dolny layout się zmienił.
- Testy widgetowe dla shelli z reklamą (placeholder, constraints).
- Krótka ocena jank/frame drops przy pierwszym ładowaniu reklamy na średnim urządzeniu.

**Bramka:** `flutter test` (w tym `--update-goldens` tam gdzie potrzebne), `flutter analyze`.

**Status:** `pending`.

---

## Stage 7 — Walidacja końcowa i zamknięcie

- Porównanie z Figma / Spec Lock (dolny pas, marginesy, brak nachodzenia na treść).
- Weryfikacja **Android + iOS** (debug + opcjonalnie release z prawdziwymi ID na internal track).
- Aktualizacja `CHANGELOG.md` (widoczne dla użytkownika: obecność reklam).
- Przeniesienie pliku roadmapy do `done-roadmaps` po akceptacji.

**Bramka:** `flutter build apk --debug`, `flutter build ios --simulator` (lub równoważne z dokumentacji projektu).

**Status:** `pending`.

---

## Definition of Done

Roadmapa uznana za **done**, gdy:

- Spec Lock (Stage 1) jest zaakceptowany i udokumentowany,
- Inicjalizacja AdMob i konfiguracja platform działają bez crashy na obu platformach,
- Slot reklamy jest spójny na wszystkich ekranach zgodnie z planem integracji (Stage 4),
- Prywatność / sklep (Stage 5) spełnia minimalne wymagania dla wybranego zasięgu wydania,
- Testy i goldens są zaktualizowane,
- Dokumentacja i changelog są zsynchronizowane z implementacją,
- Plik roadmapy znajduje się w `done-roadmaps`.

---

## Ryzyka i uwagi

- **Zmiana dostępnej wysokości na Game Screen** — wymaga ponownego potwierdzenia, że siatka kart mieści się bez scrolla na najmniejszych wspieranych wysokościach.
- **Różnice platform** w wysokości paska systemowego i safe area — uwzględnić w Spec Lock i testach.
- **Test ads vs production** — ryzyko przypadkowego użycia produkcyjnych ID w debug (wyraźne rozdzielenie w kodzie/konfiguracji).
