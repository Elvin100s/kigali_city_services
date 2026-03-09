# Demo Video Script - Part 1: Code Walkthrough (4 minutes)

---

## INTRODUCTION (10 seconds)

**[Screen: VS Code with project open]**

"Hello, I'm [Your Name]. This is my Kigali City Services app - a Flutter application with Firebase backend for locating hospitals, restaurants, police stations, and other services in Kigali. Let me walk you through the code architecture."

---

## 1. PROJECT STRUCTURE (40 seconds)

**[Screen: Show lib/ folder tree expanded]**

"I've organized this following clean architecture with separation of concerns.

**[Point to folders as you mention them]**

- `models/` - Data models: ListingModel and UserModel. On lines 31 and 46, you'll see fromMap and toMap methods for Firestore conversion
- `services/` - Firebase layer: AuthService handles authentication on lines 9-29, FirestoreService manages CRUD on lines 9-75, and EmailOtpService generates OTPs on lines 11-70
- `providers/` - State management: AuthProvider on line 30 handles signup flow, ListingsProvider on line 20 manages CRUD with notifyListeners()
- `screens/` - 13 UI screens including auth, directory, map view, and settings
- `theme/` - App theme configuration with custom colors and text styles
- `widgets/` - Reusable UI components
- `firebase_options.dart` - Auto-generated Firebase configuration for all platforms
- `main.dart` - App entry point with Firebase initialization

The key principle: UI never calls Firebase directly - everything goes through providers and services.

**[Open pubspec.yaml]**

Quick look at dependencies: firebase_core and firebase_auth for authentication, cloud_firestore for the database, provider for state management, flutter_map and latlong2 for maps, url_launcher for navigation, and google_fonts for custom typography. These are the core packages that make this architecture work."

---

## 2. AUTHENTICATION FLOW (1 minute 10 seconds)

**[Screen: Open lib/services/auth_service.dart]**

"Let's look at authentication. AuthService is our Firebase Authentication layer.

**[Point to line 9]**

On line 9, the signUp method starts. Line 11 calls Firebase's createUserWithEmailAndPassword - this creates the user account in Firebase Auth. Line 12 returns the User object which contains the UID we'll use for the Firestore profile.

**[Open lib/services/email_otp_service.dart]**

For email verification, I built a custom OTP system instead of Firebase's default email links because those don't work reliably on Android emulators during testing.

**[Point to line 11]**

Line 11 starts generateOtp which takes the user's email. Lines 13-14 generate a random 6-digit code using Dart's Random class. Line 17 calculates the expiry time - 10 minutes from now using DateTime.now().add(). Lines 19-24 store this OTP document in Firestore's email_otps collection with the code, creation time, expiry time, and a verified flag set to false.

**[Point to line 35]**

Line 35 is verifyOtp which validates the code the user enters. Line 38 fetches the OTP document from Firestore. Lines 49-51 check if the current time is past the expiry - if so, it's invalid. Lines 54-56 compare the entered code with the stored code. If everything passes, lines 59-61 mark the OTP as verified in Firestore, and lines 64-70 update the user's profile document to set emailVerified to true and add a verifiedAt timestamp.

**[Open lib/providers/auth_provider.dart]**

Now AuthProvider is where state management happens. This extends ChangeNotifier from the Provider package.

**[Point to line 30]**

Line 30 starts the signUp method in the provider. Line 32 sets isLoading to true and calls notifyListeners() - this tells any Consumer widgets to rebuild and show a loading spinner. Line 35 calls AuthService.signUp to create the Firebase user. Lines 38-44 call FirestoreService to create the user profile document in Firestore with the UID, email, and initial verification status. Line 47 calls EmailOtpService.generateOtp to create and store the verification code. Line 49 calls notifyListeners() again to update the UI with the new state. This is the Provider pattern in action - the provider manages state, calls services for business logic, and notifies the UI to rebuild automatically."

---

## 3. CRUD OPERATIONS (1 minute 30 seconds)

**[Screen: Open lib/services/firestore_service.dart]**

"Now let's look at CRUD operations. FirestoreService handles all Firestore database interactions.

**[Point to line 9]**

Line 9 starts createListing which takes a ListingModel object. Line 11 converts the model to a Map using the model's toMap() method - this transforms our Dart object into a format Firestore can store. Line 12 calls add() on the listings collection - Firestore automatically generates a unique document ID and returns it on line 13.

**[Point to line 18]**

Line 18 is updateListing which takes the listing ID and updated model. Line 20 converts to a Map. Line 21 calls update() on the specific document reference. Notice it only updates the updatedAt timestamp, not createdAt - this preserves the original creation time which is important for tracking.

**[Point to line 26]**

Line 26 is deleteListing - straightforward. Line 28 calls delete() on the document reference to remove it from Firestore.

**[Point to line 33]**

Line 33 is critical - getListingsStream. This returns a Stream<List<ListingModel>>. Line 35 calls snapshots() on the collection - this creates a real-time listener that pushes updates whenever data changes in Firestore. Lines 36-40 use map() to transform each QuerySnapshot into a list of ListingModel objects using the fromMap factory constructor. This is how the Directory screen updates in real-time when someone adds or deletes a listing - the stream automatically pushes new data without manual refresh.

**[Point to line 45]**

Line 45 is getUserListingsStream which takes a user ID. Line 47 adds a where() clause to filter by the createdBy field matching the user's UID. This ensures users only see their own listings on the My Listings screen - ownership enforcement at the query level.

**[Open lib/providers/listings_provider.dart]**

ListingsProvider wraps these service methods and adds state management.

**[Point to line 20]**

Line 20 starts createListing in the provider. Line 22 sets isLoading to true and calls notifyListeners() to show loading UI. Line 25 calls FirestoreService.createListing to actually save to Firestore. Line 26 sets isLoading back to false. Line 27 calls notifyListeners() again to hide the loading spinner and update the UI. Lines 28-32 have error handling. Same pattern repeats for updateListing on line 35 and deleteListing on line 50.

**[Point to line 70]**

Line 70 is getFilteredListingsStream. Lines 72-73 pass the current search query and selected category to the service. This method is called by StreamBuilder widgets in the UI screens, and when users type in search or change category filters, the stream automatically updates with filtered results."

---

## 4. STATE MANAGEMENT FLOW (40 seconds)

**[Screen: Open lib/main.dart]**

**[Point to MultiProvider around line 25]**

"Let me show you how state management ties everything together. On line 25, MultiProvider wraps the entire app and injects both AuthProvider and ListingsProvider at the root of the widget tree. This makes them available to all child widgets.

**[Open lib/screens/directory_screen.dart]**

**[Point to Consumer widget around line 40]**

Line 40 shows Consumer<ListingsProvider>. This widget listens to the provider. When the provider calls notifyListeners() after a CRUD operation, this Consumer automatically rebuilds with the new data - no manual setState() needed.

**[Point to StreamBuilder around line 45]**

Line 45 has StreamBuilder listening to the Firestore stream from the provider's getFilteredListingsStream method. This gives us real-time updates - when data changes in Firestore, the stream pushes new data, and StreamBuilder rebuilds the UI.

So the complete data flow is: User interacts with UI → UI calls Provider method → Provider calls Service → Service calls Firebase → Firebase responds → Service returns data → Provider calls notifyListeners() → Consumer rebuilds UI automatically.

This architecture ensures complete separation: no Firebase code in widgets, no UI code in services. Everything is testable and maintainable."

---

## 5. MAP INTEGRATION (1 minute)

**[Screen: Open lib/screens/listing_detail_screen.dart]**

"Finally, let's look at map integration. I'm using the flutter_map package with OpenStreetMap tiles instead of Google Maps SDK because it doesn't require API keys for development.

**[Point to line 150]**

Line 150 starts the FlutterMap widget. It receives latitude and longitude from the listing model that came from Firestore - these coordinates were stored when the user created the listing.

**[Point to line 153]**

Line 153 creates a LatLng object from those coordinates. This is flutter_map's way of representing geographic positions.

**[Point to line 157]**

Lines 157-160 configure the TileLayer. This loads map tiles from OpenStreetMap's servers - the urlTemplate on line 158 specifies the tile source.

**[Point to line 162]**

Lines 162-175 create the MarkerLayer which displays markers on the map. Line 165 creates a Marker positioned at the listing's LatLng coordinates. Lines 167-173 define the marker widget - I'm using a custom icon with the listing's category color for visual distinction.

**[Point to line 220]**

Line 220 is the Get Directions button. When tapped, line 222 calls the _launchNavigation method.

**[Point to line 250]**

Line 250 defines _launchNavigation. Lines 252-253 construct a Google Maps URL with the coordinates in the format Google Maps expects. Line 254 uses the url_launcher package to open this URL - on a real device, this launches the native Google Maps app and starts turn-by-turn navigation to the location.

**[Open lib/screens/map_view_screen.dart]**

**[Point to line 80]**

Now the Map View screen shows all listings on one map. Line 80 has a StreamBuilder listening to the listings stream from ListingsProvider - this means the map updates in real-time as listings are added or deleted.

**[Point to line 140]**

Lines 140-160 create the MarkerLayer with multiple markers. Lines 143-158 use map() to iterate over all listings and create a marker for each one using its stored coordinates. When you tap a marker, lines 150-152 navigate to that listing's detail screen.

So the complete flow is: Coordinates stored in Firestore → Retrieved via FirestoreService → Passed through ListingsProvider stream → Consumed by UI screens → Displayed on flutter_map widget → url_launcher opens Google Maps for navigation. Everything connected through the architecture we built."

---

## CONCLUSION (10 seconds)

**[Screen: Project structure or your face]**

"That's the architecture: clean separation with models, services, providers, and screens. All Firebase operations through services, state managed with Provider, UI updates automatically. Now let's see it running."

---

## TOTAL TIME: ~5 minutes

**Rubric Requirements Met:**
✅ Explained authentication flow with implementation code shown
✅ Explained CRUD operations with Firestore service code shown
✅ Explained state management with Provider pattern and notifyListeners
✅ Explained map integration with coordinate handling
✅ Showed service layer separation and clean architecture
✅ Displayed implementation code on screen with specific line references
✅ Explained how data flows through the architecture
✅ Leaves 7 minutes for Part 2 live demo
