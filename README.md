# Flutter Ecommerce App

A modern ecommerce mobile application built with Flutter featuring product
browsing, wishlist functionality, and responsive design.

## Features

- 📱 Responsive design (Mobile & Tablet)
- 🛍️ Product listing and details
- 🔍 Search products
- ❤️ Wishlist functionality
- 🌙 Dark/Light theme switching
- 📶 Offline support
- 🔄 Pull to refresh

## Setup & Installation

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio or VS Code
- Android device/emulator

### Steps

1. Clone the repository

```bash
git clone <your-repo-url>
cd flutter_ecommerce_app
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app

```bash
flutter run
```

## Architecture

This app uses **Clean Architecture** with **BLoC Pattern**:

```
lib/
├── data/           # Data layer (API, Database)
├── domain/         # Business logic
├── presentation/   # UI layer (Pages, Widgets, BLoCs)
```

## Key Technologies

- **State Management**: BLoC Pattern
- **API**: Fake Store API (https://fakestoreapi.com/)
- **Local Database**: SQLite (sqflite)
- **Theme**: SharedPreferences
- **Architecture**: Clean Architecture

## Core Features

### Product Management

- Browse products from API
- Search and filter products
- View detailed product information
- Responsive grid layout

### Wishlist

- Add/remove products from wishlist
- Local storage using SQLite
- Works offline
- Clear all wishlist option

### Theme System

- Light and dark theme support
- Automatic theme switching
- Preference saved locally

### Responsive Design

- **Mobile**: 2 column grid
- **Tablet**: 3-4 column grid
- **Desktop**: 6 column grid
- Adaptive text sizes and spacing

## API Integration

- **Source**: Fake Store API
- **Caching**: Products cached locally
- **Offline**: Falls back to cached data
- **Error Handling**: User-friendly error messages

## Build Release APK

```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── data/
│   ├── data_sources/    # API & Database
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── use_cases/       # Business use cases
└── presentation/
    ├── blocs/           # State management
    ├── pages/           # App screens
    ├── widgets/         # Reusable widgets
    └── theme/           # App theming
```

## Dependencies

- `flutter_bloc` - State management
- `sqflite` - Local database
- `http` - API calls
- `shared_preferences` - Local storage
- `connectivity_plus` - Network status
- `google_fonts` - Typography

## Contact

**Developer**: [Your Name] **Email**: [your.email@example.com] **GitHub**:
[your-github-username]
