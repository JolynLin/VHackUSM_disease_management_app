
# Disease Management App (VHack USM 2025)

This is a Flutter + Firebase app developed for the VHack USM 2025 hackathon. 
The app helps users manage chronic disease symptoms, book clinic appointments, and access community support.

## 🌟 Features

- AI-powered Symptom Checker
- Medicine Lookup
- Patient Records & Tracking
- Clinic Finder & Appointment Booking
- Comment & Discussion Forum

---

## 🛠️ Prerequisites

Before you begin, make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- A connected Android/iOS emulator or physical device

---

## 🚀 Getting Started

### 1. Clone or Download the Project

If you've downloaded the ZIP, extract it and navigate to the project folder:

```bash
cd VHackUSM_disease_management_app-main
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Set Up Firebase

Make sure you're logged in via Firebase CLI and initialize the project:

```bash
firebase login
firebase init
```

Then, link to your Firebase project or create a new one and ensure the following files exist:
- `google-services.json` (for Android, in `android/app/`)
- `GoogleService-Info.plist` (for iOS, in `ios/Runner/`)

Update `android/app/build.gradle` and `ios/Runner/Info.plist` accordingly if needed.

### 4. Run the App

```bash
flutter run
```

---

## 🧪 Optional: Firebase Emulators for Local Testing

```bash
firebase emulators:start
```

---

## 🤝 Team & Contributors

Developed during VHack USM 2025. For issues, suggestions, or contributions, please create a pull request or open an issue.

---

## 📄 License

This project is licensed under the MIT License.
