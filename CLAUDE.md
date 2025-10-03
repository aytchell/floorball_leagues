# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter mobile app for browsing German floorball leagues, games, results, and players. The app consumes APIs from https://saisonmanager.de/ to display league tables, game schedules, player statistics, and detailed game information.

## Common Commands

### Running the App
```bash
flutter run
```

### Development
```bash
# Install dependencies
flutter pub get

# Run analyzer
flutter analyze

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart
```

### Build
```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for all platforms
flutter build
```

## Architecture

### State Management
- Uses **Provider** pattern for global state management
- `AppState` (lib/app_state.dart) manages:
  - Currently selected season (`SeasonInfo`)
  - List of all available seasons
  - State changes trigger UI updates via `notifyListeners()`

### API Layer Architecture
The API layer follows a parser/fetcher pattern to interact with saisonmanager.de:

- **lib/api/saisonmanager.dart**: Main API entry point
- **lib/net/rest_client.dart**: Singleton HTTP client with caching via `flutter_cache_manager`
  - All requests go to `https://saisonmanager.de`
  - Responses are cached automatically
- **lib/api/models/**: Domain model classes (immutable data structures)
- **lib/api/impls/**: Implementation classes that:
  - Parse JSON responses into domain models (files ending in `_parser.dart`)
  - Fetch data from specific endpoints (files ending in `_fetcher.dart`)
  - Implement abstract model classes (files ending in `_impl.dart`)

Key API patterns:
- Parsers: Convert JSON to domain objects (e.g., `parseSeasonInfo`, `parseGameDay`)
- Fetchers: Async functions that fetch and parse data (e.g., `fetchChampTableFromServer`)
- Implementations: Extend abstract models with `fromJson` factories and `fetchFromServer` methods

### UI Layer
Organized by feature/screen:

- **lib/ui/all_operations_view/**: Grid view of all game operations (federations/leagues)
- **lib/ui/season_selector/**: Season selection screen
- **lib/ui/fed_op_leagues/**: Federation/operation league views (tables, scorers, champions)
- **lib/ui/game_day/**: Game schedule and game detail views
- **lib/ui/team_details/**: Team statistics, player stats, game history
- **lib/ui/widgets/**: Reusable widgets (logos, loading spinners, cached images)
- **lib/ui/main_app_scaffold.dart**: Common scaffold with bottom navigation

### Navigation
- Uses named routes defined in `main.dart`:
  - `/` - Home (GameOperationsGrid)
  - `/seasons` - Season selection
- Bottom navigation bar provides:
  - Home button
  - Season picker button
  - Season indicator (shows current season year, red text for non-current seasons)

### Logging
- Uses `package:logging` throughout
- Configured in `main.dart` via `setupLogging()`
- Each file typically declares: `final log = Logger('ClassName');`

## Data Flow
1. App starts → Fetches entry info from `/api/v2/init.json`
2. EntryInfo contains available seasons and game operations
3. User selects season → Updates AppState → UI rebuilds
4. User navigates to leagues → Fetches league-specific data
5. All network responses are cached for offline access

## Key Dependencies
- **flutter_svg**: SVG image support
- **provider**: State management
- **flutter_cache_manager**: HTTP response caching
- **material_table_view**: Table widgets for displaying league tables and statistics
- **shared_preferences**: Local storage
- **intl**: Date/time formatting

## Custom Fonts
The app uses **NimbusSans** font family (Regular and Bold weights) located in the `fonts/` directory.
