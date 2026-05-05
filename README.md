# FrameShot

**Your shot. Your gear. Your story.**

## About

FrameShot is a Flutter mobile app for Android and iOS that reads EXIF metadata from your photos and renders beautiful, customizable frames. Display your camera body, lens, ISO, shutter speed, aperture, focal length, date, and location in designer-crafted layouts, ready to share on social media.

<!-- Screenshots coming soon -->

## Key Features

- **Auto EXIF extraction** from any photo in your gallery
- **8 designer frame styles:** Classic, Darkroom, Film Border, Minimal Line, Fujifilm Sim, Architect, Polaroid, Editorial
- **Pro customization:** colors, fonts, field overrides, camera logos
- **Full-resolution export** with no quality loss
- **Direct share** to Instagram, WhatsApp, X, and more
- **GPS location display** with reverse geocoding (opt-in)
- **Presets system** to save and reuse your favorite configurations

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter / Dart |
| State Management | Riverpod |
| Frame Rendering | CustomPainter |
| EXIF Extraction | exif + native_exif |
| Camera Logos | flutter_svg |
| Location | geocoding (reverse geocoding) |
| In-App Purchases | RevenueCat |

## Project Structure

```
lib/
├── app/            # Theme, routing, app config
├── core/           # Models, EXIF extraction, rendering engine
├── features/
│   ├── home/       # Home screen, photo import
│   ├── preview/    # Frame preview + style carousel
│   ├── customize/  # Customization bottom sheet
│   ├── export/     # Export + share flow
│   ├── paywall/    # Pro upgrade screen
│   └── settings/   # App settings
└── shared/         # Extensions, widgets, constants
```

## Getting Started

### Prerequisites

- Flutter SDK 3.11 or higher
- Android Studio / Xcode for platform tooling

### Install and Run

```bash
git clone https://github.com/your-username/frame_shot.git
cd frame_shot
flutter pub get
flutter run
```

## Monetization

Freemium model:

- **Free tier:** Classic frame style with watermark
- **Pro unlock:** One-time purchase (IDR 59,000) for all styles, full resolution export, and no watermark

## License

This project is licensed under the [MIT License](LICENSE).
