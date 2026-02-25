# Design Summary Document

## Application Overview

**Name**: Kigali City Services & Places Directory  
**Platform**: Flutter (iOS & Android)  
**Backend**: Firebase (Authentication + Firestore)  
**State Management**: Provider  

## Architecture Design

### Layer Structure

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, UI Components)  │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│      State Management Layer         │
│    (Providers - Auth, Listings)     │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│         Service Layer               │
│  (AuthService, FirestoreService)    │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│         Data Layer                  │
│    (Firebase Auth, Firestore)       │
└─────────────────────────────────────┘
```

### Design Patterns

1. **Repository Pattern**: Services abstract Firebase operations
2. **Observer Pattern**: Provider notifies UI of state changes
3. **Singleton Pattern**: Service instances shared across app
4. **Factory Pattern**: Model fromFirestore constructors

## Data Models

### User Model
- uid (String)
- email (String)
- displayName (String)
- createdAt (DateTime)

### Listing Model (8 Required Fields)
- id (String)
- name (String)
- category (String)
- description (String)
- address (String)
- latitude (double)
- longitude (double)
- phoneNumber (String)
- createdBy (String)
- createdAt (DateTime)
- updatedAt (DateTime?)

## Screen Flow

```
App Start
    ↓
AuthWrapper (checks auth state)
    ↓
├─→ Not Authenticated → LoginScreen
│                           ↓
│                       SignupScreen
│                           ↓
│                   EmailVerificationScreen
│
└─→ Authenticated → HomeScreen (Bottom Navigation)
                        ↓
        ┌───────────────┼───────────────┬──────────────┐
        ↓               ↓               ↓              ↓
   DirectoryScreen  MyListingsScreen  MapViewScreen  SettingsScreen
        ↓               ↓
   ListingDetail   AddListingScreen
                   EditListingScreen
```

## UI/UX Design Decisions

### Navigation
- **Bottom Navigation Bar**: 4 tabs for main features
- **Stack Navigation**: Push/pop for detail screens
- **Persistent State**: Bottom nav maintains tab state

### Color Scheme
- Primary: Blue (Material Design)
- Accent: Default Material colors
- Error: Red for validation and delete actions

### Components
- **Material Design 3**: Modern Flutter UI components
- **Form Validation**: Real-time input validation
- **Loading States**: CircularProgressIndicator during async operations
- **Empty States**: Helpful messages when no data exists

## Firebase Architecture

### Collections Structure

```
users/
  {userId}/
    - email
    - displayName
    - createdAt

listings/
  {listingId}/
    - name
    - category
    - description
    - address
    - latitude
    - longitude
    - phoneNumber
    - createdBy
    - createdAt
    - updatedAt
```

### Security Rules
- Users can only read/write their own profile
- All authenticated users can read listings
- Users can only create listings with their own userId
- Users can only update/delete their own listings

## State Management Flow

```
User Action (UI)
    ↓
Provider Method Called
    ↓
Service Method Executed
    ↓
Firebase Operation
    ↓
Stream Emits New Data
    ↓
Provider Notifies Listeners
    ↓
UI Rebuilds (Consumer/StreamBuilder)
```

## Search & Filter Implementation

1. **Text Search**: Filters listings by name (case-insensitive)
2. **Category Filter**: Filters by selected category
3. **Combined**: Both filters applied simultaneously
4. **Real-time**: Filters applied to live Firestore stream

## Maps Integration

### Detail View Map
- Embedded GoogleMap widget (250px height)
- Single marker at listing location
- Zoom level 15 for detail view

### Map View Screen
- Full-screen map
- All listings as markers
- Info windows with name and category
- Tap marker to navigate to detail screen

### Directions
- "Get Directions" button
- Launches Google Maps app with destination coordinates
- Uses url_launcher package

## Performance Considerations

1. **Stream Optimization**: Only subscribe to needed data
2. **Lazy Loading**: ListView.builder for efficient scrolling
3. **Debouncing**: Search input debounced to reduce queries
4. **Indexed Queries**: Firestore indexes for orderBy operations

## Testing Strategy

1. **Manual Testing**: All user flows tested on emulator
2. **Firebase Console**: Verify data operations
3. **Authentication Flow**: Test signup, verification, login, logout
4. **CRUD Operations**: Test create, read, update, delete
5. **Edge Cases**: Empty states, network errors, validation

## Deployment Considerations

- Firebase project in production mode
- Security rules properly configured
- Google Maps API keys secured
- Environment-specific configurations
- .gitignore excludes sensitive files

## Conclusion

This design implements a scalable, maintainable architecture following Flutter and Firebase best practices. The clean separation of concerns allows for easy testing, debugging, and future enhancements.
