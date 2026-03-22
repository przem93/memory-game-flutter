# AdMob — UMP, prywatność i sklepy (Stage 5)

Status: `active`  
Roadmap: `in-progress-roadmaps/roadmap-admob-bottom-banner.md` (Stage 5)

Ten dokument uzupełnia [admob-google-mobile-ads-setup.md](admob-google-mobile-ads-setup.md) o **User Messaging Platform (UMP)**, publiczną **politykę prywatności** oraz checklisty **Google Play Data safety** i **App Store App Privacy**.

## Kolejność startu aplikacji (implementacja)

1. `ConsentInformation.requestConsentInfoUpdate` (parametry z opcjonalnym `ConsentDebugSettings` w buildach testowych — patrz poniżej).
2. `ConsentForm.loadAndShowConsentFormIfRequired` — formularz zgody, gdy jest wymagany.
3. `MobileAds.instance.initialize()` — inicjalizacja Google Mobile Ads.

Przy błędzie UMP lub inicjalizacji reklam aplikacja nadal startuje (log w konsoli), zgodnie z zasadą graceful degradation z roadmapy.

## Konfiguracja w Google AdMob (poza repozytorium)

Wykonaj przed pierwszym sensownym testem UMP na urządzeniu:

1. **Wiadomość zgody (GDPR / UMP)**  
   W konsoli AdMob utwórz i opublikuj formularz zgody powiązany z aplikacją (UMP). Bez tego `requestConsentInfoUpdate` nie pobierze treści do wyświetlenia.

2. **URL polityki prywatności**  
   Użyj **publicznego, stabilnego** adresu HTTPS (hosting poza repo lub strona firmy). Ten sam link:
   - w konfiguracji wiadomości UMP w AdMob,
   - w opisach sklepów / ekranie szczegółów aplikacji, jeśli wymagane.

   W repozytorium **nie** commitujemy treści polityki ani sekretów — tylko dokumentacja kroków i odnośniki.

3. **Urządzenia testowe (debug)**  
   Zgodnie z [dokumentacją Google](https://developers.google.com/admob/android/privacy/gdpr): dodaj identyfikatory testowych urządzeń w AdMob, aby w trybie debug symulować geografię (np. EEA).

## Debug geografia (tylko dev / CI testowy)

Opcjonalnie, przy buildzie:

```bash
flutter run --dart-define=ADMOB_CONSENT_DEBUG_EEA=true
```

Wymusza `DebugGeography.debugGeographyEea` w `ConsentDebugSettings` (urządzenie musi być na liście testowej w AdMob). **Nie** ustawiaj tego w buildach produkcyjnych.

## Google Play — Data safety

Przed wydaniem z reklamami zaktualizuj [Data safety](https://support.google.com/googleplay/android-developer/answer/10787469) m.in. o:

- dane związane z reklamami (np. Advertising ID, jeśli dotyczy),
- udostępnianie danych partnerom reklamowym zgodnie z faktycznym zachowaniem AdMob / sieci reklamowych.

Szczegóły muszą być zgodne z publiczną polityką prywatności.

## App Store — App Privacy

W App Store Connect uzupełnij [etykiety prywatności](https://developer.apple.com/app-store/app-privacy-details/) (np. dane używane do śledzenia/reklamy), zgodnie z tym, co zbiera zestaw SDK AdMob w danej konfiguracji.

## Opcje prywatności reklam (UI)

Gdy `ConsentInformation.getPrivacyOptionsRequirementStatus` zwraca `required`, na **Main Menu** wyświetlany jest link otwierający `ConsentForm.showPrivacyOptionsForm` (wymóg Google dla punktu dostępu do zmiany zgód).

## Powiązane pliki w kodzie

- `lib/core/admob_startup.dart` — UMP + `MobileAds.initialize()`
- `lib/main.dart` — wywołanie przy starcie
- `lib/features/main_menu/presentation/widgets/main_menu_ad_privacy_options_link.dart` — link opcji prywatności (warunkowo)
