# Demo Video Script - Part 1: Code Walkthrough (5 minutes)

---

## INTRODUCTION (15 seconds)

**[Screen: Show your face or just VS Code with project open]**

"Hello, I'm [Your Name], and this is my Kigali City Services mobile application demo. This is a Flutter app with Firebase backend that helps residents locate hospitals, restaurants, police stations, and other essential services in Kigali. In this first part, I'll walk you through the code architecture and implementation."

---

## 1. PROJECT STRUCTURE (45 seconds)

**[Screen: Show lib/ folder tree in VS Code explorer]**

"Let me start by showing you the project structure. I've organized this app following clean architecture principles with clear separation of concerns.

**[Expand lib/ folder]**

At the root, we have the `main.dart` file which is our app entry point. It sets up Firebase initialization and wraps the app with MultiProvider for state management.

**[Point to each folder as you mention it]**

The `models` folder contains our data models - ListingModel and UserModel. These are plain Dart classes that represent our Firestore documents.

The `providers` folder has our state management logic. I'm using the Provider pattern with two main providers: AuthProvider for authentication state and ListingsProvider for managing CRUD operations on listings.

The `services` folder contains our Firebase integration layer - AuthService for Firebase Authentication, FirestoreService for database operations, and EmailOtpService for OTP verification.

The `screens` folder has all 11 UI screens including login, signup, directory, my listings, map view, and settings.

And finally, the `widgets` folder contains reusable UI components like custom buttons, loading indicators, and theme helpers.

This structure ensures that UI components never directly call Firebase - everything goes through the service layer."

---

## 2. DATA MODELS (30 seconds)

**[Screen: Open lib/models/listing_model.dart]**

"Let's look at the data models. Here's the ListingModel - this is a 60-line file that represents a service or place in our app.

**[Point to lines 3-15: class fields]**

Starting at line 3, you can see all the fields: name, category, description, address, phoneNumber, and critically on lines 10-11, latitude and longitude for map integration. Line 12 has the `createdBy` field which stores the user's UID - this is how we enforce ownership when editing or deleting.

**[Scroll to line 17: constructor]**

Line 17 shows the constructor with all required fields.

**[Scroll to line 31: fromMap factory]**

Now on line 31, here's the `fromMap` factory constructor. This takes a Firestore document Map and converts it to a ListingModel object. Notice lines 33-42 extract each field from the map, handling the GeoPoint conversion for coordinates on lines 39-40.

**[Scroll to line 46: toMap method]**

Line 46 has the `toMap` method which does the reverse - converts the model back to a Map for storing in Firestore. This is the factory pattern in action.

**[Open lib/models/user_model.dart]**

Similarly, UserModel is a 40-line file representing user profiles. Lines 3-7 define fields like uid, email, displayName, and emailVerified. It also has fromMap on line 15 and toMap on line 28 for Firestore conversion."

---

## 3. AUTHENTICATION IMPLEMENTATION (2 minutes)

**[Screen: Open lib/services/auth_service.dart]**

"Now let's dive into authentication. This is AuthService - a 50-line service class that handles all Firebase Authentication operations.

**[Point to line 6: FirebaseAuth instance]**

Line 6 initializes the FirebaseAuth instance that we'll use throughout.

**[Scroll to line 9: signUp method]**

Starting at line 9, the `signUp` method takes email and password. Line 11 calls `createUserWithEmailAndPassword` from Firebase Auth. Line 12 returns the User object which we'll use to create a Firestore profile. Lines 13-15 have the try-catch for error handling.

**[Scroll to line 19: signIn method]**

Line 19 has the `signIn` method. Line 21 calls `signInWithEmailAndPassword` to authenticate existing users. Same error handling pattern.

**[Scroll to line 29: signOut method]**

Line 29 is the simple `signOut` method that clears the session.

**[Open lib/services/email_otp_service.dart]**

Now this is EmailOtpService - a 90-line file. I implemented a custom OTP system instead of Firebase's default email links because email links don't work reliably on Android emulators.

**[Point to line 8: FirebaseFirestore instance]**

Line 8 gets the Firestore instance.

**[Scroll to line 11: generateOtp method]**

Starting at line 11, `generateOtp` takes an email address. Lines 13-14 generate a random 6-digit code using Random. Line 17 calculates the expiry time - 10 minutes from now. Lines 19-24 create the OTP document in the `email_otps` collection with the code, timestamps, and verified status.

**[Scroll to line 35: verifyOtp method]**

Line 35 has `verifyOtp` which takes email and the entered code. Line 38 fetches the OTP document. Lines 41-43 check if it exists. Line 46 extracts the stored OTP. Lines 49-51 check expiry. Lines 54-56 compare the codes. If everything passes, lines 59-61 mark it as verified in Firestore, and lines 64-70 update the user's profile to set emailVerified to true.

**[Open lib/providers/auth_provider.dart]**

Now here's where state management comes in. AuthProvider is a 180-line ChangeNotifier that manages authentication state for the entire app.

**[Point to lines 10-14: state variables]**

Lines 10-14 declare state variables: current user, loading state, and error message.

**[Scroll to line 30: signUp method]**

Starting at line 30, when a user signs up, line 32 sets loading to true and calls `notifyListeners()` to show a loading spinner. Line 35 calls AuthService to create the Firebase user. Lines 38-44 create the user profile in Firestore using FirestoreService. Line 47 generates the OTP using EmailOtpService. After each step, `notifyListeners()` on lines 32, 49 updates the UI. Lines 50-55 handle errors.

**[Scroll to line 59: signIn method]**

Similar pattern for signIn starting at line 59 - set loading, call service, update state, notify listeners.

**[Scroll to line 90: verifyOtp method]**

Line 90 has the `verifyOtp` method that calls EmailOtpService and updates the user state.

This three-layer architecture - Provider for state, Service for Firebase calls, UI for display - ensures complete separation of concerns."

---

## 4. CRUD OPERATIONS (2 minutes)

**[Screen: Open lib/services/firestore_service.dart]**

"Let's look at how CRUD operations work. FirestoreService is a 120-line file that handles all Firestore database interactions.

**[Point to line 6: FirebaseFirestore instance]**

Line 6 initializes the Firestore instance.

**[Scroll to line 9: createListing method]**

Starting at line 9, `createListing` takes a ListingModel. Line 11 converts it to a Map using the model's `toMap()` method. Line 12 adds it to the `listings` collection. Firestore automatically generates a document ID. The method returns this ID on line 13.

**[Scroll to line 18: updateListing method]**

Line 18 has `updateListing` which takes a listing ID and the updated model. Line 20 converts to Map. Line 21 updates the specific document. Notice it only updates the `updatedAt` timestamp, not `createdAt` - this preserves the original creation time.

**[Scroll to line 26: deleteListing method]**

Line 26 is `deleteListing` - simple and clean. Line 28 just calls delete on the document reference.

**[Scroll to line 33: getListingsStream method]**

Now this is important - line 33 has `getListingsStream`. This returns a Stream<List<ListingModel>>. Line 35 calls `snapshots()` which gives us real-time updates. Lines 36-40 map each snapshot to a list of ListingModel objects. This is how the Directory screen updates in real-time when someone adds or deletes a listing - the stream automatically pushes new data.

**[Scroll to line 45: getUserListingsStream method]**

Line 45 has `getUserListingsStream` which takes a user ID. Line 47 adds a `where` clause to filter by `createdBy` field. This ensures users only see their own listings on the My Listings screen.

**[Scroll to line 60: getFilteredListingsStream method]**

Line 60 is `getFilteredListingsStream` for search and category filtering. Lines 63-65 build the query - if there's a category filter, it adds a where clause. Lines 67-75 map the results and apply the search filter on the name field.

**[Open lib/providers/listings_provider.dart]**

Now ListingsProvider is a 150-line ChangeNotifier that wraps these service methods and manages state.

**[Point to lines 8-12: state variables]**

Lines 8-12 declare state variables for loading, errors, search query, and selected category.

**[Scroll to line 20: createListing method]**

Starting at line 20, when creating a listing, line 22 sets loading to true and calls `notifyListeners()`. Line 25 calls FirestoreService.createListing. Line 26 sets loading to false. Line 27 calls `notifyListeners()` again to rebuild the UI. Lines 28-32 handle errors.

**[Scroll to line 35: updateListing method]**

Same pattern for update on line 35 and delete on line 50.

**[Scroll to line 70: getFilteredListingsStream method]**

Line 70 exposes the filtered stream to the UI. This method is called by StreamBuilder widgets in the screens. When the user types in search or changes category filter, lines 72-73 pass those values to the service, and the stream automatically updates.

This architecture means the UI never touches Firestore directly - it only talks to the provider, which talks to the service."

---

## 5. STATE MANAGEMENT FLOW (45 seconds)

**[Screen: Open lib/main.dart]**

"Let me show you how state management ties everything together. In main.dart, I'm using MultiProvider to inject both AuthProvider and ListingsProvider at the root of the widget tree.

**[Open lib/screens/directory_screen.dart]**

In the UI screens, I use Consumer widgets to listen to provider changes.

**[Scroll to Consumer<ListingsProvider>]**

Here in the Directory screen, the Consumer rebuilds whenever ListingsProvider calls `notifyListeners()`. I'm using StreamBuilder to listen to the Firestore stream from the provider.

**[Draw diagram on screen or show existing diagram]**

So the data flow is: User interacts with UI → UI calls Provider method → Provider calls Service → Service calls Firebase → Firebase responds → Service returns data → Provider calls notifyListeners() → Consumer rebuilds UI.

This architecture ensures complete separation between UI and business logic. No Firebase code in widgets, no UI code in services."

---

## 6. MAP INTEGRATION (1 minute)

**[Screen: Open lib/screens/listing_detail_screen.dart]**

"Finally, let's look at map integration. This is the listing detail screen - a 280-line file that displays full listing information with an embedded map.

**[Scroll to line 150: FlutterMap widget]**

Starting at line 150, here's the FlutterMap widget. I'm using the flutter_map package with OpenStreetMap tiles instead of Google Maps because it doesn't require API keys for development.

**[Point to line 152: MapOptions]**

Line 152 sets the map options. Line 153 creates a LatLng object using the listing's latitude and longitude that came from Firestore. Line 154 sets the initial zoom level.

**[Scroll to line 157: TileLayer]**

Lines 157-160 configure the TileLayer - this loads the OpenStreetMap tiles from their server.

**[Scroll to line 162: MarkerLayer]**

Lines 162-175 create the MarkerLayer. Line 165 creates a Marker at the listing's coordinates. Lines 167-173 define the marker widget - I'm using a custom icon with the listing's category color.

**[Scroll to line 220: Get Directions button]**

Now on line 220, here's the 'Get Directions' button. Line 222 calls `_launchNavigation` method.

**[Scroll to line 250: _launchNavigation method]**

Line 250 defines `_launchNavigation`. Lines 252-253 construct a Google Maps URL with the coordinates. Line 254 uses the url_launcher package to open this URL, which launches the native Google Maps app on the device for turn-by-turn navigation.

**[Open lib/screens/map_view_screen.dart]**

Now this is the Map View screen - a 200-line file that shows all listings on a single map.

**[Scroll to line 80: StreamBuilder]**

Line 80 has a StreamBuilder listening to the listings stream from ListingsProvider. This means the map updates in real-time as listings are added or deleted.

**[Scroll to line 120: FlutterMap widget]**

Line 120 has the FlutterMap widget. Similar setup with TileLayer.

**[Scroll to line 140: MarkerLayer with multiple markers]**

Lines 140-160 create the MarkerLayer, but this time lines 143-158 map over all listings to create multiple markers. Each marker uses the listing's coordinates from Firestore. When you tap a marker, lines 150-152 navigate to that listing's detail screen.

So the complete flow is: Coordinates stored in Firestore → Retrieved via FirestoreService → Passed through ListingsProvider → Consumed by UI screens → Displayed on flutter_map → url_launcher opens Google Maps for navigation."

---

## CONCLUSION (15 seconds)

**[Screen: Back to project structure or your face]**

"That covers the code architecture. As you can see, I've implemented clean separation of concerns with models, providers, services, and screens. All Firebase operations go through the service layer, state is managed with Provider, and the UI automatically updates through streams and notifyListeners. Now let's see this app in action."

**[Transition to Part 2]**

---

## TOTAL TIME: ~5 minutes

**Key Points Covered:**
✅ Project structure and folder organization
✅ Data models with factory pattern
✅ Authentication flow with custom OTP
✅ CRUD operations with Firestore
✅ State management with Provider pattern
✅ Real-time updates with streams
✅ Map integration with coordinates
✅ Clean architecture principles
