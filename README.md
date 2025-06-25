# DreamScope

A mobile app to save and analyze dreams, with horoscope interpretations powered by AI.

## Features

- **Dream Journal**: Save and analyze your dreams using AI
- **Horoscope**: Get personalized horoscope predictions
- **Multi-language Support**: Available in English and Turkish
- **Dark Theme**: Beautiful dark theme design

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.3)
- Dart SDK (>=3.2.3)
- Android Studio / VS Code
- Gemini API Key

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_astroloji_deneme
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
   - Create a `.env` file in the root directory
   - Add your Gemini API key:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

4. Run the app:
```bash
flutter run
```

### Environment Variables

The app requires the following environment variables:

- `GEMINI_API_KEY`: Your Google Gemini API key for AI-powered dream analysis and horoscope generation

**Important**: Never commit your `.env` file to version control. The `.env` file is already added to `.gitignore`.

## Build

### Android APK
```bash
flutter build apk
```

### Android App Bundle
```bash
flutter build appbundle
```

## Architecture

This project follows Clean Architecture principles with:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and repositories
- **Presentation Layer**: UI and state management (BLoC/Cubit)

## Dependencies

- **State Management**: flutter_bloc
- **Routing**: go_router
- **Dependency Injection**: get_it
- **AI Integration**: google_generative_ai
- **Local Database**: sembast
- **Environment Variables**: flutter_dotenv
- **Models**: freezed, json_annotation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
