# Kigali City Services & Places Directory

A Flutter mobile application for discovering and navigating to services and places in Kigali, Rwanda.

## Features

- **Authentication**: Email/password signup with email verification
- **CRUD Operations**: Create, read, update, and delete service listings
- **Search & Filter**: Search by name and filter by category
- **Google Maps Integration**: View listings on map with directions
- **Real-time Updates**: Firestore real-time data synchronization
- **Clean Architecture**: Service layer separation with Provider state management

## Tech Stack

- Flutter 3.0+
- Firebase Authentication
- Cloud Firestore
- Google Maps Flutter
- Provider (State Management)

## Setup Instructions

### Prerequisites

- Flutter SDK installed
- Firebase account
- Google Cloud Console account (for Maps API)

### Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Enable Authentication (Email/Password)
3. Create Firestore Database
4. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
5. Configure Firebase:
   ```bash
   flutterfire configure
   ```

### Google Maps Setup

1. Enable Maps SDK for Android/iOS in Google Cloud Console
2. Get API key
3. Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_API_KEY"/>
   ```
4. Add to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ```

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/           # Data models
├── services/         # Firebase services
├── providers/        # State management
├── screens/          # UI screens
├── widgets/          # Reusable widgets
└── main.dart         # App entry point
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                      request.resource.data.createdBy == request.auth.uid;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }
  }
}
```

## Usage

1. Sign up with email and verify your email
2. Login to access the app
3. Browse listings in the Directory tab
4. Add your own listings in My Listings tab
5. View all listings on the Map tab
6. Manage settings and logout in Settings tab

## License

MIT
