# CureMate

CureMate is a Flutter-based healthcare and pharmacy application that helps patients upload prescriptions, find nearby pharmacies, receive pharmacy responses, schedule medicine reminders, and use an AI medicine explainer.

The project uses Firebase for authentication, database, storage, messaging, and backend functions.

## Features

- Patient and pharmacy authentication
- Patient dashboard and pharmacy dashboard
- Prescription image upload from camera or gallery
- Prescription storage in Firebase Storage
- Prescription records in Cloud Firestore
- Nearby pharmacy discovery using location and Google Maps
- Pharmacy response flow for uploaded prescriptions
- User and pharmacy notification screens
- Firebase Cloud Messaging support
- Local medicine reminder notifications
- AI medicine explainer using Gemini
- Profile viewing and editing
- App launcher icons for Android, iOS, and web

## Technologies

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging
- Firebase App Check
- Firebase Cloud Functions
- Node.js 22 for backend functions
- Google Maps Flutter
- Google Places API integration
- Geolocator for location access
- Google Gemini API
- Google ML Kit Text Recognition
- Flutter Local Notifications
- Timezone package for scheduled reminders
- Image Picker
- Photo View
- HTTP package
- dotenv for local environment variables

## Project Structure

```text
lib/
  core/
    navigation/        App-level navigation helpers
    services/          Firebase, AI, location, notification, and prescription services
    theme/             Shared colors and app theme values
  models/              Data models used by the app
  screens/
    auth/              Login, signup, and forgot password screens
    home/              Patient home and dashboard screens
    notifications/     User and pharmacy notification screens
    pharmacy/          Pharmacy map, list, and response screens
    Phamacist/         Pharmacy dashboard and prescription response flow
    prescriptions/     Prescription upload, order history, and pharmacy search
    profile/           Profile and edit profile screens
    reminders/         Medicine reminder screens
    splash/            Splash and role selection screens
  widgets/             Reusable UI widgets

functions/
  index.js             Firebase Cloud Functions
```

## Requirements

- Flutter SDK with Dart `>=3.11.0 <4.0.0`
- Firebase project
- Android Studio or VS Code
- Android SDK for Android builds
- Xcode for iOS builds, if building on macOS
- Node.js 22 for Firebase Functions
- Firebase CLI, if deploying functions

## Environment Variables

Create a `.env` file in the project root:

```env
GEMINI_API_KEY=your_gemini_api_key_here
# Optional. Defaults to gemini-2.5-flash.
GEMINI_MODEL=gemini-2.5-flash
```

The app loads this file in `lib/main.dart` using `flutter_dotenv`.

Do not commit real API keys to source control.

## Firebase Setup

This app expects Firebase to be configured for Flutter.

Required Firebase products:

- Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging
- Firebase App Check
- Cloud Functions

The generated Firebase options file is:

```text
lib/firebase_options.dart
```

If you connect a new Firebase project, regenerate it with:

```bash
flutterfire configure
```

## Google Maps Setup

The app uses Google Maps and nearby pharmacy search.

Enable these APIs in Google Cloud:

- Maps SDK for Android
- Maps SDK for iOS, if using iOS
- Places API
- Geocoding API, if needed by future location features

Add real Google Maps API keys in the platform configuration before production use.

Note: `lib/screens/pharmacy/map_screen.dart` currently contains a placeholder API key value. Replace it with a secure configuration approach before release.

## Install Dependencies

```bash
flutter pub get
```

For Firebase Functions:

```bash
cd functions
npm install
cd ..
```

## Run the App

```bash
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

## Build

Android APK:

```bash
flutter build apk
```

Android App Bundle:

```bash
flutter build appbundle
```

Web:

```bash
flutter build web
```

## Firebase Functions

The functions folder contains backend logic for:

- Processing newly uploaded prescriptions
- Sending pharmacy notifications for new prescriptions
- Sending user notifications when prescription status changes

Run functions locally:

```bash
cd functions
npm run serve
```

Deploy functions:

```bash
cd functions
npm run deploy
```

## Notifications

The app uses two notification paths:

- Firebase Cloud Messaging for remote push notifications
- Flutter Local Notifications for foreground notifications and medicine reminders

Important Android permissions are already declared in:

```text
android/app/src/main/AndroidManifest.xml
```

These include:

- `POST_NOTIFICATIONS`
- `SCHEDULE_EXACT_ALARM`
- location permissions
- internet permission

## Code Check Notes

During review, these points were found:

- `README.md` had duplicated content and broken character encoding. It has been replaced.
- `prescription.status ?? "Pending"` was unnecessary because `status` is non-null in `PrescriptionModel`.
- `PrescriptionModel.fromFirestore` now safely converts Firestore status values to a string.
- The app logo files were updated so launcher icons no longer use the default Flutter icon.
- Several source comments contain broken encoded characters. These are mostly comments and labels, but they should be cleaned later for readability.
- `main.dart` currently prints `.env` values for debugging. Remove those debug prints before production.
- `map_screen.dart` contains a placeholder Google API key. Replace it before using maps in production.

## Common Commands

Analyze code:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Format code:

```bash
dart format .
```

Regenerate launcher icons:

```bash
dart run flutter_launcher_icons
```

## Developer

Developed by Dilith Karunarathne as a university project.
