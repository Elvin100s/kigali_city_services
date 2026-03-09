# Demo Video Script - Part 2: Live Demo (7 minutes)

---

## SETUP BEFORE RECORDING

**Required Windows:**
1. Android Emulator with app installed
2. Firebase Console (Authentication tab)
3. Firebase Console (Firestore Database tab)
4. Split screen or picture-in-picture setup

**Pre-Demo Checklist:**
- [ ] App is built and installed on emulator
- [ ] Firebase Console is logged in
- [ ] Firestore has some existing listings (2-3 for demo)
- [ ] Screen recording software ready
- [ ] Audio is clear

---

## INTRODUCTION (15 seconds)

**[Screen: Show emulator with app splash screen + Firebase Console]**

"Now let's see the app in action. I have the Android emulator running on the left and Firebase Console on the right so you can see how actions in the app are reflected in the backend database in real-time."

---

## 1. AUTHENTICATION FLOW (1 minute 30 seconds)

### Signup

**[Screen: App shows login screen]**

"The app starts with the login screen. Since I don't have an account yet, I'll tap 'Sign Up'.

**[Tap Sign Up button]**

Here's the signup screen. I'll enter my email and password.

**[Type: test123@example.com, password: Test123!]**

**[Tap Sign Up button]**

Notice the loading indicator appears - that's our loading state from AuthProvider.

**[Switch to Firebase Console - Authentication tab]**

Look at Firebase Console - a new user was just created with this email. The user is authenticated but not verified yet.

**[Switch back to app - OTP screen appears]**

The app navigated to the OTP verification screen. Now I need to get the OTP code.

**[Switch to Firebase Console - Firestore Database]**

In Firestore, let me open the `email_otps` collection.

**[Click on the document with the email]**

Here's the OTP document for my email. You can see the 6-digit code, the creation timestamp, and the expiry timestamp which is 10 minutes from now. The code is: [read the code].

**[Switch back to app]**

Let me enter this code in the app.

**[Type the 6-digit code]**

**[Tap Verify button]**

Perfect! The app verified the code and navigated to the home screen. 

**[Switch to Firebase Console - Firestore users collection]**

In Firestore, if I open the `users` collection and find my user document, you can see `emailVerified` is now true and there's a `verifiedAt` timestamp."

### Login

**[In app, tap Settings → Logout]**

"Let me log out and log back in to show the login flow.

**[App returns to login screen]**

**[Enter same credentials]**

**[Tap Login]**

Since my email is already verified, I'm taken directly to the home screen without OTP verification."

---

## 2. CREATE LISTING (1 minute 15 seconds)

**[Screen: App on Directory screen]**

"Now let's create a new listing. I'm on the Directory screen which shows all listings from all users.

**[Tap the floating action button (+)]**

This opens the Add Listing screen.

**[Fill in the form:]**
- Name: "Kigali Heights Restaurant"
- Category: Select "Restaurant"
- Description: "Fine dining with city views"
- Address: "KN 4 Ave, Kigali"
- Phone: "+250788123456"
- Latitude: "-1.9536"
- Longitude: "30.0606"

**[As you fill, say:]**

"I'm entering the place name, selecting Restaurant from the category dropdown, adding a description, address, contact number, and the geographic coordinates. These coordinates will be used to show the location on the map.

**[Tap Save button]**

Notice the loading indicator while the data is being saved to Firestore.

**[Switch to Firebase Console - Firestore listings collection]**

Look at Firebase Console - a new document just appeared in the `listings` collection. You can see all the fields I entered: name, category, description, address, phone number, latitude, longitude, and importantly the `createdBy` field which contains my user UID. This is how we track ownership.

**[Switch back to app]**

The app automatically navigated back to the Directory screen, and there's my new listing at the top! This happened automatically because the Directory screen is listening to the Firestore stream through ListingsProvider."

---

## 3. SEARCH AND FILTER (45 seconds)

**[Screen: App on Directory screen with multiple listings visible]**

"Let me demonstrate search and filtering. I'll tap the search icon.

**[Tap search icon in app bar]**

**[Type "restaurant" in search field]**

As I type, the list filters in real-time to show only listings with 'restaurant' in the name. This is the search functionality working through the filtered stream in ListingsProvider.

**[Clear search]**

Now let me try category filtering.

**[Tap the filter chip or dropdown]**

**[Select "Hospital" category]**

The list now shows only hospitals. The filtering is happening at the Firestore query level, so it's efficient even with large datasets.

**[Clear filter to show all listings again]**

Let me reset the filter to show all listings."

---

## 4. VIEW DETAIL PAGE WITH MAP (1 minute)

**[Screen: Directory screen with listings]**

"Now let's view the details of a listing. I'll tap on the restaurant I just created.

**[Tap on "Kigali Heights Restaurant"]**

This is the listing detail screen. It shows all the information: name, category, description, address, and contact number.

**[Scroll down to show the map]**

Here's the embedded map using flutter_map with OpenStreetMap tiles. You can see a marker at the exact coordinates I entered - that's the restaurant location.

**[Point to the map marker]**

The map is interactive - I can zoom and pan.

**[Demonstrate zooming]**

Now if I want turn-by-turn directions, I'll tap the 'Get Directions' button.

**[Tap Get Directions button]**

This launches Google Maps with the coordinates. In a real device, this would open the native Google Maps app and start navigation.

**[Show Google Maps opening or simulated navigation]**

**[Go back to app]**

Let me go back to the app."

---

## 5. MY LISTINGS SCREEN (30 seconds)

**[Screen: Tap bottom navigation to My Listings]**

"The bottom navigation bar has four screens. Let me go to 'My Listings'.

**[Tap My Listings icon]**

This screen shows only the listings I created. Notice it only shows the restaurant I just added, not the other listings in the directory. This is because the query filters by `createdBy` matching my user UID.

From here, I can edit or delete my own listings. Let me show you both operations."

---

## 6. EDIT LISTING (1 minute)

**[Screen: My Listings screen]**

"I'll tap the edit icon on my restaurant listing.

**[Tap edit icon/button]**

This opens the Edit Listing screen with all the current data pre-filled.

**[Show the pre-filled form]**

Let me change the description.

**[Change description to: "Fine dining with panoramic city views and rooftop bar"]**

I'll also update the phone number.

**[Change phone to: "+250788999888"]**

**[Tap Update button]**

Loading indicator appears while updating Firestore.

**[Switch to Firebase Console - Firestore listings collection]**

In Firebase Console, if I open this listing document, you can see the description and phone number have been updated. Also notice the `updatedAt` timestamp changed, but `createdAt` stayed the same.

**[Switch back to app]**

Back in the app, the listing detail screen shows the updated information. And if I go back to the Directory screen...

**[Navigate to Directory]**

The changes are reflected here too because of the real-time stream."

---

## 7. DELETE LISTING (45 seconds)

**[Screen: Navigate back to My Listings]**

"Now let me demonstrate deletion. I'll go back to My Listings.

**[Tap My Listings in bottom nav]**

I'll tap the delete icon on the restaurant listing.

**[Tap delete icon/button]**

A confirmation dialog appears to prevent accidental deletion.

**[Show confirmation dialog]**

I'll confirm the deletion.

**[Tap Confirm/Delete button]**

**[Switch to Firebase Console - Firestore listings collection]**

Look at Firebase Console - the document is gone from the `listings` collection.

**[Switch back to app]**

In the app, My Listings screen is now empty because I deleted my only listing. And if I go to the Directory screen...

**[Navigate to Directory]**

The restaurant is no longer in the directory either. The UI updated automatically through the Firestore stream."

---

## 8. MAP VIEW SCREEN (30 seconds)

**[Screen: Tap Map View in bottom navigation]**

"Let me show you the Map View screen.

**[Tap Map View icon]**

This screen displays all listings as markers on a single map. Each marker represents a service or place from the Firestore database.

**[Point to different markers]**

I can tap on a marker to see which listing it represents.

**[Tap a marker - show popup or navigation to detail]**

This provides a geographic overview of all services in Kigali. Users can quickly see what's nearby or in a specific area."

---

## 9. SETTINGS SCREEN (30 seconds)

**[Screen: Tap Settings in bottom navigation]**

"Finally, let's look at the Settings screen.

**[Tap Settings icon]**

Here you can see the authenticated user's profile information: email and display name pulled from the Firestore user document.

**[Point to profile section]**

There's a toggle for location-based notifications. This is a simulated preference for this assignment, but in production, it would control push notifications.

**[Toggle the switch on and off]**

And there's a logout button.

**[Point to logout button]**

When I tap logout, AuthProvider signs out the user and navigates back to the login screen."

---

## CONCLUSION (15 seconds)

**[Screen: Show app overview or Firebase Console with data]**

"That completes the demo. As you've seen, the app successfully implements Firebase Authentication with OTP verification, full CRUD operations on listings with real-time Firestore updates, search and category filtering, map integration with navigation, and clean state management using the Provider pattern. All actions in the app are immediately reflected in the Firebase backend, demonstrating proper integration between the Flutter frontend and Firebase services."

---

## TOTAL TIME: ~7 minutes

**Features Demonstrated:**
✅ User signup with OTP verification
✅ User login
✅ Create listing with Firestore confirmation
✅ Search by name
✅ Filter by category
✅ View listing detail with embedded map
✅ Launch navigation to location
✅ View user-specific listings
✅ Edit listing with real-time update
✅ Delete listing with Firestore confirmation
✅ Map view with all markers
✅ Settings screen with profile
✅ Firebase Console showing real-time backend updates

**Rubric Requirements Met:**
✅ Authentication flow explained with code shown
✅ CRUD operations demonstrated with Firebase Console verification
✅ Search & filter functionality shown
✅ Map integration and navigation demonstrated
✅ State management flow explained
✅ Real-time updates visible
✅ Implementation code displayed during explanations
✅ Video duration 7-12 minutes
