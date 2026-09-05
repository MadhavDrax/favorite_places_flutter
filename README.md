# Favorite Places 📍

A Flutter app to save, view, and manage your favorite places — complete with a photo, a picked location, and a live map preview.

## Features

- **Add a place** with a title, a photo (camera capture), and a location
- **Pick a location** via device GPS or by selecting a point on the map
- **Reverse geocoding** to convert coordinates into a human-readable address
- **Static map preview** on the place detail screen (powered by Geoapify)
- **Full interactive map view** for a selected place
- **Persistent local storage** so places are saved between app sessions
- Cross-platform: Android, iOS, Web, macOS, Linux

## Tech Stack

- **Flutter / Dart**
- **Geoapify API** — static map images and geocoding
- Platform location & camera plugins (device GPS + camera capture)

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and set up
- A free [Geoapify API key](https://www.geoapify.com/)

### Setup

1. Clone the repo
   ```bash
   git clone https://github.com/MadhavDrax/favorite_places_flutter.git
   cd favorite_places_flutter
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app with your Geoapify API key passed in at build/run time — the key is **not** stored in the codebase:
   ```bash
   flutter run --dart-define=GEOAPIFY_API_KEY=your_api_key_here
   ```

   For builds:
   ```bash
   flutter build apk --dart-define=GEOAPIFY_API_KEY=your_api_key_here
   flutter build web --dart-define=GEOAPIFY_API_KEY=your_api_key_here
   ```

### VS Code

If you're using VS Code, add a `.vscode/launch.json` (gitignored, since it holds your real key) so you don't have to pass the flag manually:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "favorite_places",
      "request": "launch",
      "type": "dart",
      "toolArgs": ["--dart-define=GEOAPIFY_API_KEY=your_api_key_here"]
    }
  ]
}
```

## Project Structure

```
lib/
├── models/          # Data models (Place, etc.)
├── screens/         # App screens (list, add place, detail, map view)
├── widgets/         # Reusable UI components
└── providers/       # State management
```

## Permissions

The app requires the following device permissions:
- **Camera** — to take a photo of a place
- **Location** — to fetch the current GPS position

Make sure these are configured in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.

## License

This project is for personal/learning purposes.