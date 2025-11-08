# Short Notes Trainer 📘⚡

Short Notes Trainer helps learners master speed note-taking with a curated library of abbreviations, mnemonic exercises, and interactive practice tools. The app blends colorful UI, audio cues, and real-time feedback to keep study sessions fast and fun.

## ✨ Features
- **Abbreviation Learning Paths** – Structured lessons that guide users from basics to advanced shorthand.
- **Interactive Practice Modes** – Quizzes, flash cards, and fill-in challenges to reinforce retention.
- **Voice Input Support** – Dictate notes using speech-to-text and review the shorthand suggestions.
- **Personalized Progress** – Track streaks, achievements, and topics needing revision.
- **Offline-first Storage** – Notes, preferences, and progress are stored locally with Hive.

## 🛠 Tech Stack
- [Flutter](https://flutter.dev/) (Dart 3.9+)
- State management with [`provider`](https://pub.dev/packages/provider)
- Local persistence via [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter)
- Speech recognition using [`speech_to_text`](https://pub.dev/packages/speech_to_text)
- Animations powered by [`flutter_animate`](https://pub.dev/packages/flutter_animate) and [`lottie`](https://pub.dev/packages/lottie)

## 🚀 Getting Started
### Prerequisites
- [Flutter SDK 3.19+](https://docs.flutter.dev/get-started/install) (Dart 3.9 ships with Flutter)
- Android Studio or Xcode with device/emulator support
- Optional: macOS/iOS builds require Xcode; Windows builds require Visual Studio with C++ workload

### Installation
```bash
git clone https://github.com/<your-username>/Short-Note-Taking-App.git
cd Short-Note-Taking-App
flutter pub get
```

### Run the App
```bash
# List available devices
flutter devices

# Start the desired target
flutter run -d <device_id>
```

For web:
```bash
flutter run -d chrome
```

For Windows/macOS/Linux:
```bash
flutter run -d windows   # or macos / linux
```

## 📂 Project Structure
```
lib/
 ├─ main.dart                   // App entry point
 ├─ models/                     // Data models and Hive adapters
 ├─ providers/                  // State management logic (Provider)
 ├─ screens/                    // Feature screens (learning, practice, settings, etc.)
 ├─ widgets/                    // Reusable UI components
 └─ utils/                      // Helpers, constants, theming
assets/
 ├─ audio/                      // Voice cues and pronunciation guides
 └─ mystake145.png              // Illustrations & UI artwork
```

## 🧪 Testing
Run widget/unit tests:
```bash
flutter test
```
Use `flutter analyze` or IDE tooling to keep lint warnings in check.

## 🗺 Roadmap Ideas
- Integrate cloud sync for multi-device progress
- Add competitive leaderboards for streak challenges
- Expand content with medical/legal shorthand packs
- Explore export to PDF/Markdown

## 🤝 Contributing
1. Fork the repo and create a feature branch.
2. Make your changes with clear commit messages.
3. Run `flutter analyze` and `flutter test`.
4. Open a pull request describing the motivation and screenshots if UI changes apply.

## 📄 License
MIT License — see [`LICENSE`](LICENSE) for details.

---
Made with Flutter and a passion for efficient learning ✍️
