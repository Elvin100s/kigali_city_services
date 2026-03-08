# Demo Video Script — Kigali City Services
**Target Duration:** 7–12 minutes

---

## Opening (30 seconds)

"Hi, my name is [Your Name]. This is my demo for Individual Assignment 2 — the Kigali City Services and Places Directory app built with Flutter and Firebase. The app allows users to discover and manage public services and leisure locations in Kigali. I will walk through the key features including authentication, CRUD operations, search and filtering, map integration, and the state management architecture."

---

## 1. Authentication Flow (2 minutes)

"Let me start with the authentication flow."

- Open the app — show the Login screen
- "The login screen uses Firebase Authentication with email and password. You can see the fields have labels above them, a password visibility toggle, and a styled error display."

- Tap "Sign Up"
- "On the signup screen I will create a new account."
- Fill in Display Name, Email, Password
- "You can see the password strength indicator updating as I type."
- Tap Sign Up

- "The app now sends a 6-digit OTP to the email address using EmailJS. Let me open the email."
- Open email inbox — show the OTP email arriving
- "Here is the verification code. I will enter it now."
- Enter OTP on the verification screen
- "The OTP is stored in Firestore with a 10-minute expiry. Once verified, the user profile is updated in Firestore and access is granted."

- Switch to Firebase Console → users collection
- "You can see the user profile was created in Firestore with the UID, email, display name, and emailVerified set to true."

- "Now let me demonstrate logout and login."
- Go to Settings → tap Logout → confirm
- Log back in with the same credentials
- "Login works correctly and the app restores the session."

---

## 2. Creating a Listing (1.5 minutes)

"Now let me demonstrate creating a listing."

- Go to My Listings tab → tap Add Listing FAB
- "The Add Listing form has all the required fields — name, category, description, address, phone number, and geographic coordinates."

- Go to Map View tab instead
- "I can also add a listing directly from the map. I tap the plus button — a banner appears instructing me to tap the map to place my listing."
- Tap a location on the map
- "The form opens with the coordinates already pre-filled from where I tapped."

- Fill in the remaining fields — Name, Category, Description, Address, Phone
- Tap Add Listing

- Switch to Firebase Console → listings collection
- "You can see the new listing document was created instantly in Firestore with all fields including the createdBy field storing my user UID, and a timestamp."

- Go to Directory tab
- "The listing appears immediately in the Directory without any manual refresh — this is because we are using a Firestore real-time stream."

---

## 3. Editing a Listing (1 minute)

"Now let me edit a listing."

- Go to My Listings → tap the edit icon on a listing
- "Only listings I created have the edit option — this is enforced both in the UI and in Firestore security rules."
- Change the description or phone number
- Tap Save

- Switch to Firebase Console
- "The document in Firestore updated instantly — you can see the updatedAt timestamp changed."

- Go back to Directory
- "The change is reflected immediately across the app."

---

## 4. Deleting a Listing (1 minute)

"Now let me delete a listing."

- Go to My Listings → swipe a listing left
- "Swiping reveals the delete action. A confirmation dialog appears."
- Confirm delete

- Switch to Firebase Console
- "The document is immediately removed from the listings collection in Firestore."

- Go to Directory tab
- "It has disappeared from the directory in real time."

---

## 5. Search and Category Filtering (1 minute)

"Now let me demonstrate search and category filtering."

- Go to Directory tab
- Type a place name in the search bar
- "As I type, the results filter dynamically. This works by transforming the Firestore stream client-side through the ListingsProvider."
- Clear the search

- Tap a category chip — e.g. Hospital
- "Filtering by Hospital shows only hospital listings."
- Tap another category — e.g. Park
- "Switching to Park shows only parks. The count at the top updates with each filter."
- Tap All to reset

---

## 6. Listing Detail Page and Map (1 minute)

"Let me open a listing detail page."

- Tap any listing from the Directory
- "The detail page shows all information — name, category, description, address, and phone number."
- Scroll down to show the embedded map
- "There is an embedded interactive map at the top with a marker placed at the exact coordinates stored in Firestore. These coordinates are retrieved from the ListingModel and passed directly into the FlutterMap widget."

- Tap Get Directions
- "Tapping Get Directions launches Google Maps with the destination pre-set using the stored latitude and longitude."
- Go back

---

## 7. Map View Screen (45 seconds)

"Now let me show the Map View screen."

- Go to Map tab
- "The Map View shows all listings as pin markers on a map of Kigali. Each marker color corresponds to the listing category."
- Tap a marker
- "Tapping a marker opens a popup with the listing name, category, address, and phone. From here I can tap View Details to go to the full detail page."

---

## 8. Settings Screen (30 seconds)

"The Settings screen displays the authenticated user profile pulled from Firestore — name, email, and avatar initial. There is also a notification preferences toggle which simulates local notification settings."

---

## 9. Code Walkthrough (1.5 minutes)

"Finally let me walk through the architecture."

- Open VS Code — show lib/ folder structure
- "The project follows a clean layered architecture. Models handle data mapping, services handle all Firebase interactions, providers manage state, and screens contain only UI code."

- Open `lib/services/firestore_service.dart`
- "FirestoreService is the only class that talks to Firestore. All CRUD operations and streams are defined here. No screen or widget calls Firebase directly."

- Open `lib/providers/listings_provider.dart`
- "ListingsProvider sits between the UI and the service layer. When a screen calls createListing, the provider calls FirestoreService, handles loading and error states, then calls notifyListeners to rebuild the UI. This is the complete data flow — UI calls the provider, provider calls the service, Firebase updates, the stream emits a new snapshot, and the screen rebuilds automatically."

- Open `lib/screens/directory_screen.dart`
- "The Directory screen is pure UI. It uses a Consumer to listen to the provider and a StreamBuilder to react to the Firestore stream. There are no Firebase calls here."

- Open `lib/models/listing_model.dart`
- "The ListingModel class handles serialization. fromFirestore maps a Firestore document to a Dart object and toFirestore converts it back for writing."

---

## Closing (15 seconds)

"That covers all the required features — Firebase authentication with email verification, full CRUD operations with real-time Firestore updates, search and category filtering, map integration with navigation, and a clean Provider-based architecture. Thank you."

---

## Recording Tips

- Keep Firebase Console open in a browser on your PC and show it after each create, update, and delete
- Speak at a normal pace — do not rush
- If you make a mistake just keep going, do not restart
- Record in landscape if showing both phone and Firebase Console simultaneously
