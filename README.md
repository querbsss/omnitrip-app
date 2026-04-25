# OmniTrip — Smart Travel Planner

A fully **offline** Flutter mock app for planning trips around the Philippines.
Built for a class presentation — no backend, no Firebase, no real APIs.

## ✨ Features

- **Onboarding** → **Register / Log In** → **Plan Your Trip** → **Smart Plan Results**
- Fully offline auth with `shared_preferences` (accounts stored locally on device)
- Persistent session — stays logged in after app close
- 45 hand-curated Philippine destinations across **Luzon, Visayas, Mindanao**
- ~150 activities tagged by purpose (Vacation / Date Idea / School-Business)
- Mock 5-day weather forecast based on PAGASA climate zones + month
- Mock traffic & route advisories for each destination
- "Open in Google Maps" deep-link button
- Form validation, password obfuscation, logout
- Cream + teal aesthetic with Poppins typography (Material 3)
- Responsive — fits Android phones, also runs in the browser

## 🧰 Requirements

- Flutter SDK **3.32.x** (Dart 3.8.x) — verify with `flutter --version`
- For Android APK: Android SDK + an emulator or USB-debug device
- For Web preview: any Chromium-based browser

## 🚀 Run the App

### 1. Install dependencies

```bash
cd omni_travel_app
flutter pub get
```

### 2. Run in the browser (fastest preview)

```bash
flutter run -d chrome
```

The app opens at a phone-shaped frame in the center of the browser window
(420 × 900) so the layout matches what you'll see on Android.

### 3. Run on an Android emulator / device

```bash
flutter devices              # confirm your device shows up
flutter run -d <device-id>   # or just `flutter run` if only one device
```

### 4. Build the release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 5. Build a web bundle (deployable static site)

```bash
flutter build web --release
```

Output: `build/web/` — serve with any static host or `python -m http.server`.

## 🧪 Tests

```bash
flutter analyze
flutter test
```

## 📁 Project Layout

```
lib/
├── main.dart                       # entry point + session check
├── app.dart                        # MaterialApp, routes, phone-frame on web
├── core/                           # colors.dart, theme.dart, validators.dart
├── data/
│   ├── models/                     # user, destination, activity, weather, route, plan
│   ├── datasets/                   # destinations.dart (45), activities.dart (~150), routes.dart
│   └── services/                   # auth_service, session_service, plan_generator
└── ui/
    ├── welcome_screen.dart
    ├── login_screen.dart
    ├── register_screen.dart
    ├── planner_screen.dart
    ├── results_screen.dart
    └── widgets/                    # omni_logo, pill_button, input_card, purpose_card,
                                    # toggle_row, weather_day_card, traffic_route_card, insight_card
```

## 🧭 Demo Flow (1–2 min video)

1. Launch app → Welcome screen with logo + collage
2. Tap **Get Started** → register a new user (any email + 6+ char password)
3. Auto-redirects to **Planner**
4. Tap **Where to?** → search "Cebu" → pick **Cebu City**
5. Tap **Travel Date** → pick any future date
6. Tap **Vacation** purpose card
7. Leave both toggles on → tap **Generate Smart Plan**
8. **Results** screen shows:
   - 5-day weather forecast
   - Traffic chart + map preview (tap to open Google Maps)
   - Route steps + traffic advisory
   - Activity insight cards
   - Packing tips + insights
9. Tap **Plan Another Trip** to return
10. Tap logout icon (top-right) to clear session

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `shared_preferences` | Offline auth + session storage |
| `url_launcher` | "Open in Google Maps" deep links |
| `google_fonts` | Poppins typography |
| `intl` | Date formatting |

## 🔒 A Note on Auth

Passwords are stored **base64-encoded** in `SharedPreferences` — this is intentional
obfuscation for a demo, **not** real security. For a production app, use a hashing
library like `crypto` (SHA-256 + salt) plus a real backend.
