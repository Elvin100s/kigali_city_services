# Complete Firebase Setup Checklist

## Prerequisites
- Flutter SDK installed
- Firebase account created
- Android Studio with emulator OR physical device

---

## Part 1: Flutter Project Setup

### 1. Create Flutter Project
```bash
flutter create project_name
cd project_name
```

### 2. Add Dependencies to pubspec.yaml
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  provider: ^6.1.1
  google_maps_flutter: ^2.5.0
  url_launcher: ^6.2.2
```

### 3. Install Dependencies
```bash
flutter pub get
```

---

## Part 2: Firebase Configuration

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Run FlutterFire Configure
```bash
flutterfire configure
```

**Follow prompts:**
- If asked about existing firebase.json → Choose "yes" or delete the file first
- Enter project ID (e.g., `my-app-name`) → Creates new Firebase project
- Select platforms → Use spacebar to select `android` and `ios`, press Enter
- Override firebase_options.dart? → Type `yes`

**Result:** Generates `lib/firebase_options.dart` file

---

## Part 3: Firebase Console Setup

### Open Firebase Console
Go to: https://console.firebase.google.com

### Step 1: Enable Authentication

1. Click your project name
2. Left sidebar → Click **"Authentication"**
3. Click **"Get started"** button
4. Click **"Sign-in method"** tab
5. Find **"Email/Password"** in the providers list
6. Click on it
7. Toggle **"Enable"** switch to ON
8. Click **"Save"**

✅ Authentication enabled!

---

### Step 2: Create Firestore Database

1. Left sidebar → Click **"Firestore Database"**
2. Click **"Create database"** button
3. Select edition:
   - Choose **"Standard edition"** (free tier)
   - Click **"Continue"**
4. Security mode:
   - Select **"Start in production mode"**
   - Click **"Next"**
5. Choose location:
   - Select closest region (e.g., `eur3` for Europe, `us-central1` for US)
   - Click **"Enable"**
6. Wait 30 seconds for database creation

✅ Firestore created!

---

### Step 3: Configure Security Rules

1. In Firestore Database, click **"Rules"** tab (top menu)
2. Delete all existing rules
3. Paste your security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // All authenticated users can read listings
    // Users can only create listings with their own userId
    // Users can only update/delete their own listings
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                      request.resource.data.createdBy == request.auth.uid;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }
  }
}
```

4. Click **"Publish"** button

✅ Security rules deployed!

---

## Part 4: Google Maps Setup (Optional)

### 1. Get API Key

1. Go to: https://console.cloud.google.com
2. Select your Firebase project
3. Left menu → **"APIs & Services"** → **"Credentials"**
4. Click **"Create Credentials"** → **"API Key"**
5. Copy the API key

### 2. Enable Required APIs

1. Left menu → **"APIs & Services"** → **"Library"**
2. Search and enable:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**

### 3. Configure Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>
```

### 4. Configure iOS

Edit `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

## Part 5: Windows Setup (Required for Flutter on Windows)

### Enable Developer Mode

1. Press Windows key
2. Type "Developer settings"
3. Toggle **"Developer Mode"** to ON
4. Accept UAC prompt
5. Wait for installation

**Why?** Required for symlink support during Flutter builds

---

## Part 6: Run the App

### 1. Check Available Devices
```bash
flutter devices
```

### 2. List Emulators
```bash
flutter emulators
```

### 3. Launch Emulator
```bash
flutter emulators --launch <emulator_id>
```

### 4. Run App
```bash
flutter run
```

Or specify device:
```bash
flutter run -d <device_id>
```

---

## Part 7: Testing Checklist

### Authentication
- [ ] Sign up with email/password
- [ ] Receive verification email
- [ ] Verify email
- [ ] Login with verified account
- [ ] Logout

### Firestore
- [ ] Create data
- [ ] Read data (real-time updates)
- [ ] Update data
- [ ] Delete data
- [ ] Check Firebase Console to see data

### Security
- [ ] Try accessing data without authentication (should fail)
- [ ] Try modifying another user's data (should fail)

---

## Common Issues & Solutions

### Issue: "Missing firebase_options.dart"
**Solution:** Run `flutterfire configure` again

### Issue: "Permission denied" in Firestore
**Solution:** Check security rules are published correctly

### Issue: "PromiseJsImpl not found" (Web)
**Solution:** Run on mobile emulator, not web browser

### Issue: "Symlink support required" (Windows)
**Solution:** Enable Developer Mode in Windows settings

### Issue: "Google Maps shows gray screen"
**Solution:** 
- Verify API key is correct
- Check Maps SDK is enabled in Google Cloud Console
- Ensure API key is added to AndroidManifest.xml and AppDelegate.swift

---

## Quick Reference Commands

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure

# Install dependencies
flutter pub get

# Check devices
flutter devices

# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run

# Run on specific device
flutter run -d <device_id>

# Clean build
flutter clean
flutter pub get

# Check for issues
flutter doctor
```

---

## File Structure After Setup

```
project/
├── lib/
│   ├── firebase_options.dart    ← Generated by flutterfire
│   ├── main.dart
│   ├── models/
│   ├── services/
│   ├── providers/
│   └── screens/
├── android/
│   └── app/src/main/AndroidManifest.xml  ← Add Maps API key
├── ios/
│   └── Runner/AppDelegate.swift           ← Add Maps API key
├── pubspec.yaml                           ← Dependencies
├── firebase.json                          ← Firebase config
└── .firebaserc                            ← Firebase project
```

---

## Summary Checklist

**Local Setup:**
- [ ] Flutter project created
- [ ] Dependencies added to pubspec.yaml
- [ ] FlutterFire CLI installed
- [ ] `flutterfire configure` completed
- [ ] firebase_options.dart generated

**Firebase Console:**
- [ ] Firebase project created
- [ ] Email/Password authentication enabled
- [ ] Firestore database created
- [ ] Security rules published

**Google Maps (if needed):**
- [ ] API key obtained
- [ ] Maps SDK enabled
- [ ] API key added to Android
- [ ] API key added to iOS

**Windows:**
- [ ] Developer Mode enabled

**Testing:**
- [ ] Emulator launched
- [ ] App runs successfully
- [ ] Authentication works
- [ ] Firestore operations work

---

**You're ready to build Firebase apps! 🚀**
