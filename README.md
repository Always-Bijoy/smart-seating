# Smart Seating — Flutter App

A Flutter app that helps bus passengers find the shadiest seat based on sun position, route direction, and departure time.

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Home Screen** | Route overview with bus illustration, sunlight direction, and seat recommendation |
| **Plan Trip Screen** | Origin/destination input, departure time selector, weather forecast |
| **Best Seat Screen** | Seat map showing shaded seats highlighted in blue, ride recommendation |
| **Sun Tracker Screen** | Live compass dial showing sun position relative to the bus, shade movement timeline |

## 🗂 Folder Structure

```
lib/
├── main.dart                   # App entry point
├── theme/
│   └── app_theme.dart          # Colors, gradients, typography
├── models/
│   └── trip_model.dart         # Data models
├── screens/
│   ├── home_screen.dart        # Screen 1 - Home
│   ├── plan_trip_screen.dart   # Screen 2 - Plan Your Trip
│   ├── best_seat_screen.dart   # Screen 3 - Best Seat Found
│   └── sun_tracker_screen.dart # Screen 4 - Live Sun Tracker
├── widgets/
│   ├── bottom_nav_bar.dart     # Shared bottom navigation
│   ├── bus_illustration.dart   # Animated bus with sun/snow icons
│   ├── bus_seat_map.dart       # Interactive seat grid
│   └── buttons.dart            # Primary/Secondary buttons
└── utils/
    └── constants.dart          # Spacing, radius, route constants
```

## 🎨 Design System

### Colors
- **Primary Yellow**: `#F5C518` — buttons, highlights, CTA
- **Accent Blue**: `#2B5CE6` — "Right" recommendation text  
- **Background**: `#F2F2F7` — soft warm grey
- **Card**: `#FFFFFF` with subtle shadow

### Typography
- **Google Fonts — Poppins**: weights 400, 500, 600, 700, 800
- Display headings: 22–30px, weight 700–800
- Body: 12–15px, weight 400–500

### Key Components
- **PrimaryButton**: Yellow gradient pill button with shadow
- **BusIllustration**: Custom-painted bus with sun/snowflake icons
- **BusSeatMap**: Grid-based seat selector with blue highlighted shaded seats
- **SunDial**: Circular compass with animated sun position indicator

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```

## 📦 Dependencies

```yaml
google_fonts: ^6.2.1    # Poppins typography
flutter_svg: ^2.0.9     # SVG support
provider: ^6.1.2        # State management (ready for expansion)
```

## ✨ Design Highlights

- 100% pixel-matched to the original Figma/screenshot
- Custom `CustomPainter` for the bus illustration
- Smooth animated transitions between screens
- Gradient buttons with depth shadows
- Live tracker compass with tick marks and cardinal directions
- Timeline slider with gradient fill
