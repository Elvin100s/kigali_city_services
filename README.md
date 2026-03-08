# Kigali City Services & Places Directory

A modern Flutter mobile application that helps Kigali residents locate and navigate to essential public services and leisure locations including hospitals, police stations, libraries, restaurants, cafés, parks, and tourist attractions.

## 🎯 Features

### Authentication
- **Firebase Authentication** with email and password
- **Email OTP Verification** - 6-digit code sent to user's email for verification
- Secure user profile management in Firestore
- Session persistence

### Service Listings (CRUD Operations)
- **Create** new service/place listings with complete details
- **Read** all listings in a shared directory with real-time updates
- **Update** your own listings
- **Delete** your own listings
- Each listing includes:
  - Place/Service Name
  - Category (Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction)
  - Address
  - Contact Number
  - Description
  - Geographic Coordinates (Latitude & Longitude)
  - Creator UID and Timestamp

### Search & Filter
- **Search by name** - Dynamic search across all listings
- **Filter by category** - Quick category-based filtering
- Real-time results update as Firestore data changes

### Map Integration
- Interactive map view using flutter_map
- Location markers for all services
- Detailed view with embedded map for each listing
- Turn-by-turn navigation support via url_launcher

### Navigation
Bottom navigation bar with 4 main screens:
- **Directory** - Browse all listings
- **My Listings** - Manage your own listings
- **Map View** - See all locations on map
- **Settings** - User profile and preferences

## 🎨 Design

### Modern UI Theme
- **Dark forest green** theme with terra cotta accents (primary: #2D6A4F, highlight: #52B788)
- Dark background (#0D1117) with layered surface cards for depth
- Playfair Display for headings, DM Sans for body text
- Shimmer loading placeholders and slide/fade animations via flutter_animate
- Category-coded color system with unique icons per service type

## 🏗️ Architecture

### State Management
- **Provider** pattern for state management
- Clean separation between UI and business logic
- Dedicated service layer for Firebase operations

### Project Structure
```
lib/
├── models/           # Data models (ListingModel, UserModel)
├── providers/        # State management (AuthProvider, ListingsProvider)
├── screens/          # UI screens
├── services/         # Firebase services (Auth, Firestore, OTP)
├── theme/            # App theme and styling constants
├── widgets/          # Reusable widgets
└── main.dart         # App entry point
```

## 🔥 Firebase Structure

### Firestore Collections

#### `users`
```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "emailVerified": "boolean",
  "createdAt": "timestamp",
  "verifiedAt": "timestamp"
}
```

#### `listings`
```json
{
  "name": "string",
  "category": "string",
  "description": "string",
  "address": "string",
  "latitude": "double",
  "longitude": "double",
  "phoneNumber": "string",
  "createdBy": "string (UID)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### `email_otps`
```json
{
  "otp": "string (6-digit code)",
  "createdAt": "timestamp",
  "expiresAt": "timestamp",
  "verified": "boolean"
}
```

#### `otp_emails`
```json
{
  "to": "string (email)",
  "subject": "string",
  "html": "string (email body)",
  "createdAt": "timestamp"
}
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd kigali_city_services
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Firebase Authentication (Email/Password)
   - Create a Firestore database
   - Download `google-services.json` (Android) and place in `android/app/`
   - Run Firebase CLI to generate `firebase_options.dart`:
   ```bash
   flutterfire configure
   ```

4. **Run the app**
```bash
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.4.0
  firebase_auth: ^6.1.4
  cloud_firestore: ^6.1.2
  provider: ^6.1.1
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  url_launcher: ^6.2.2
  intl: ^0.18.1
```

## 🎓 State Management Approach

### Provider Pattern
- **AuthProvider** - Manages authentication state, OTP verification, user sessions
- **ListingsProvider** - Handles CRUD operations, search, and filtering for listings

### Service Layer
- **AuthService** - Firebase Authentication operations
- **FirestoreService** - Firestore database operations
- **EmailOtpService** - OTP generation and verification

### Data Flow
```
UI Widget → Provider → Service Layer → Firebase
                ↓
         notifyListeners()
                ↓
         UI Rebuilds (Consumer/Selector)
```

## 🔐 Security Features

- Email verification required before app access
- OTP expires after 10 minutes
- User can only edit/delete their own listings
- Firestore security rules enforce user ownership
- No sensitive data stored locally

## 🧪 Testing on Emulator

### OTP Verification
Since email links don't work well on emulators, we use OTP codes:
1. Sign up with any email
2. Check Firestore `otp_emails` collection for the 6-digit code
3. Enter the code in the app
4. Access granted after verification

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS (with proper Firebase setup)
- ❌ Web (not optimized for this assignment)

## 🎯 Assignment Requirements Met

- ✅ Firebase Authentication with email verification
- ✅ Full CRUD operations for listings
- ✅ Real-time Firestore updates
- ✅ Search and category filtering
- ✅ Map integration with navigation
- ✅ Provider state management
- ✅ Bottom navigation with 4 screens
- ✅ Clean architecture with service layer
- ✅ User profile management
- ✅ Settings screen with preferences

## 👨‍💻 Development

### Code Quality
- Clean code architecture
- Separation of concerns
- Reusable components
- Consistent naming conventions
- Comprehensive error handling

### Performance Optimizations
- Const constructors where possible
- Efficient state updates
- Lazy loading of data
- Optimized Firestore queries

## 📄 License

This project is created for educational purposes as part of a mobile development course assignment.

## 🤝 Contributing

This is an individual assignment project. Contributions are not accepted.

## 📧 Contact

For questions or issues, please contact through the course platform.

---

**Built with ❤️ using Flutter & Firebase**
