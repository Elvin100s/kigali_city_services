# Kigali City Services - Design Summary

**Student**: [Your Name]  
**Course**: Mobile Development - Individual Assignment 2  
**Date**: March 2025

---

## 1. Firestore Database Structure

### Collections Schema

#### **users** Collection
```
users/{uid}
├── uid: string
├── email: string
├── displayName: string
├── emailVerified: boolean
├── createdAt: timestamp
└── verifiedAt: timestamp
```

**Purpose**: Store user profile information linked to Firebase Authentication UID. The `emailVerified` field tracks OTP verification status.

#### **listings** Collection
```
listings/{listingId}
├── name: string
├── category: string (Restaurant, Hospital, School, Hotel, Shop, Bank, Other)
├── description: string
├── address: string
├── phoneNumber: string
├── latitude: double
├── longitude: double
├── createdBy: string (UID reference)
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Purpose**: Store all service/place listings with geographic coordinates for map integration. The `createdBy` field links each listing to its creator for ownership validation.

#### **email_otps** Collection
```
email_otps/{email}
├── otp: string (6-digit code)
├── createdAt: timestamp
├── expiresAt: timestamp
└── verified: boolean
```

**Purpose**: Store OTP codes for email verification with 10-minute expiry. Used instead of email links for emulator compatibility.

#### **otp_emails** Collection
```
otp_emails/{docId}
├── to: string (email address)
├── subject: string
├── html: string (email body)
└── createdAt: timestamp
```

**Purpose**: Simulate email sending for testing. In production, this would trigger a Cloud Function to send actual emails.

---

## 2. State Management Implementation

### Provider Pattern Architecture

**Choice Rationale**: Provider was selected for its simplicity, official Flutter support, and sufficient capability for this app's complexity level.

### Provider Structure

#### **AuthProvider**
- **Responsibilities**: 
  - Manages authentication state (login, signup, logout)
  - Handles OTP verification flow
  - Tracks current user session
  - Exposes loading/error states to UI

- **Key Methods**:
  - `signUp()` - Creates Firebase Auth user + Firestore profile
  - `signIn()` - Authenticates user
  - `verifyOtp()` - Validates OTP code
  - `resendOtp()` - Generates new OTP
  - `signOut()` - Clears session

#### **ListingsProvider**
- **Responsibilities**:
  - Manages CRUD operations for listings
  - Provides filtered/searched listings streams
  - Handles category filtering and search queries
  - Exposes real-time Firestore updates to UI

- **Key Methods**:
  - `createListing()` - Adds new listing to Firestore
  - `updateListing()` - Updates existing listing
  - `deleteListing()` - Removes listing
  - `getFilteredListingsStream()` - Returns filtered real-time stream
  - `getUserListingsStream()` - Returns user-specific listings

### Service Layer

#### **AuthService**
- Direct Firebase Authentication operations
- Isolated from UI logic

#### **FirestoreService**
- All Firestore CRUD operations
- Query construction and execution
- Error handling and data transformation

#### **EmailOtpService**
- OTP generation (6-digit random codes)
- Firestore storage with expiry
- Verification logic

### Data Flow
```
UI Widget (Consumer)
    ↓
Provider (notifyListeners)
    ↓
Service Layer
    ↓
Firebase (Auth/Firestore)
```

**Benefits**:
- Clear separation of concerns
- Testable business logic
- Automatic UI updates via `notifyListeners()`
- No direct Firebase calls in widgets

---

## 3. Design Trade-offs

### OTP vs Email Links
**Decision**: Implemented custom OTP system instead of Firebase's built-in email verification.

**Rationale**:
- Email links don't work well on Android emulators
- Faster testing iteration during development
- Better user experience for testing
- Production-ready architecture (can integrate real email service)

**Trade-off**: Additional code complexity, but improved developer experience.

### Real-time Updates vs Pagination
**Decision**: Used Firestore real-time streams without pagination.

**Rationale**:
- Assignment scope is small (expected < 100 listings)
- Real-time updates demonstrate Firestore capabilities
- Simpler implementation for MVP

**Trade-off**: Won't scale to thousands of listings, but appropriate for assignment scope.

### Provider vs Riverpod/Bloc
**Decision**: Chose Provider over more complex state management solutions.

**Rationale**:
- Sufficient for app complexity
- Official Flutter recommendation
- Easier to explain in demo video
- Faster development time

**Trade-off**: Less type-safe than Riverpod, but adequate for requirements.

---

## 4. Technical Challenges & Solutions

### Challenge 1: Gradle Memory Issues
**Problem**: Build failures with `OutOfMemoryError` on 8GB RAM machine.

**Solution**: Reduced Gradle heap allocation from 4GB to 2GB and disabled parallel builds in `gradle.properties`.

**Learning**: Default configurations assume high-end machines; optimization needed for resource-constrained environments.

### Challenge 2: Firestore Security Rules
**Problem**: `PERMISSION_DENIED` errors when writing OTP data during signup.

**Solution**: Updated Firestore rules to allow authenticated users to write to `email_otps` and `otp_emails` collections while maintaining ownership validation for listings.

**Learning**: Security rules must be configured before testing write operations.

### Challenge 3: Stream Management
**Problem**: Memory leaks from unclosed Firestore streams.

**Solution**: Implemented proper `dispose()` methods in providers to cancel `StreamSubscription` objects.

**Learning**: Real-time listeners require careful lifecycle management.

### Challenge 4: Category Filtering with Real-time Data
**Problem**: Applying filters to continuously updating Firestore streams.

**Solution**: Used computed properties in `ListingsProvider` that filter the raw stream data before exposing to UI.

**Learning**: Separation of raw data and filtered views improves performance and maintainability.

---

## 5. UI/UX Design Decisions

### Dark Theme Implementation
**Decision**: Implemented elegant dark theme with forest green accents instead of default Material Design.

**Rationale**:
- Modern, professional appearance
- Reduced eye strain
- Better battery life on OLED screens
- Distinctive visual identity

**Components**:
- Google Fonts (Playfair Display + DM Sans)
- Gradient buttons with shadows
- Category-specific color badges
- Shimmer loading states
- Smooth animations (flutter_animate)

### Map Integration
**Decision**: Used `flutter_map` with OpenStreetMap tiles instead of Google Maps SDK.

**Rationale**:
- No API key required for development
- Open-source and free
- Sufficient for assignment requirements

**Trade-off**: Less feature-rich than Google Maps, but meets all requirements.

---

## 6. Architecture Patterns

### Folder Structure
```
lib/
├── models/           # Data models (ListingModel, UserModel)
├── providers/        # State management (AuthProvider, ListingsProvider)
├── screens/          # UI screens (11 total)
├── services/         # Firebase services (Auth, Firestore, OTP)
├── theme/            # App theme constants (deprecated, moved to ui_helpers)
├── widgets/          # Reusable UI components (ui_helpers.dart)
└── main.dart         # App entry point with theme configuration
```

### Design Patterns Used
- **Repository Pattern**: Service layer abstracts Firebase operations
- **Provider Pattern**: State management with `ChangeNotifier`
- **Factory Pattern**: Model classes with `fromMap()` constructors
- **Observer Pattern**: StreamBuilder for real-time updates

---

## 7. Testing Strategy

### Emulator Testing
- OTP codes viewable in Firestore Console
- All CRUD operations tested with real-time verification
- Navigation flows validated
- Error states triggered and handled

### Firebase Console Verification
- User creation confirmed in Authentication tab
- Listings appear in Firestore immediately
- Security rules enforced correctly
- Timestamps and UIDs validated

---

## 8. Future Enhancements

If this were a production app, the following improvements would be made:

1. **Pagination**: Implement lazy loading for large datasets
2. **Image Upload**: Add photos to listings using Firebase Storage
3. **Reviews & Ratings**: Allow users to rate and review places
4. **Push Notifications**: Real-time alerts for new listings in favorite categories
5. **Offline Support**: Cache listings for offline viewing
6. **Advanced Search**: Full-text search with Algolia integration
7. **Admin Panel**: Web dashboard for content moderation
8. **Analytics**: Track user behavior with Firebase Analytics

---

## Conclusion

The Kigali City Services app successfully demonstrates full-stack mobile development with Firebase integration, clean architecture, and real-time data synchronization. The Provider pattern provides sufficient state management for the app's complexity while maintaining code clarity. The custom OTP verification system showcases problem-solving skills in adapting to development constraints. All assignment requirements have been met with a focus on code quality, user experience, and scalable architecture.

---

**Total Pages**: 2  
**Word Count**: ~1,200 words
