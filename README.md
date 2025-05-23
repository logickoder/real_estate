# Real Estate App

A modern Flutter application for real estate management and browsing. This app provides a seamless experience for users to explore properties, view detailed information, and manage real estate listings.

## Features

- 🏠 Property Listings
- 📍 Location-based Search
- 💬 Messaging System
- ❤️ Favorites Management
- 🔍 Advanced Search Functionality
- 👤 User Profile Management
- 🎨 Modern UI with Custom Satoshi Font

## Tech Stack

- Flutter SDK (>=3.4.1)
- Bloc Pattern for State Management
- Dio for HTTP Networking
- GetIt for Dependency Injection
- Flutter SVG for Vector Graphics
- Flutter DotEnv for Environment Configuration

## Getting Started

### Prerequisites

- Flutter SDK (>=3.4.1)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/real_estate.git
   ```

2. Navigate to the project directory:
   ```bash
   cd real_estate
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Set up environment files:
   - Create `.env.staging` and `.env.production` files based on your configuration

5. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
├── assets/
│   ├── images/         # Image assets
│   └── svg/           # SVG icons and illustrations
├── lib/
│   ├── core/          # Core functionality
│   ├── feature/       # Feature modules
│   └── screens/       # App screens
└── fonts/            # Custom fonts
```

## Dependencies

- **State Management**
  - bloc
  - flutter_bloc
  - equatable

- **UI Components**
  - flutter_svg
  - google_fonts

- **Networking**
  - dio

- **Utilities**
  - get_it
  - logger
  - intl
  - flutter_dotenv

## Custom Fonts

The app uses the Satoshi font family with various weights:
- Satoshi Black (700)
- Satoshi Bold (600)
- Satoshi Medium (500)
- Satoshi Regular (400)
- Satoshi Light (300)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
