# Demo Video Guide — Kigali City Services

**Duration:** 7–12 minutes
**Required:** Phone running the app + Firebase Console open side by side

---

## 1. Authentication Flow (2 min)

- Sign up with a new email
- Show OTP arriving in email inbox
- Enter OTP code and get verified into the app
- Log out from Settings screen
- Log back in with the same credentials

---

## 2. Creating a Listing (1.5 min)

- Go to **My Listings** tab → tap **Add Listing**
- Fill in all fields (name, category, description, address, phone)
- Tap the map to set the location pin
- Submit the form
- Show the listing appear instantly in the **Directory** tab
- **Switch to Firebase Console** → Firestore → listings collection → show the new document created

---

## 3. Editing a Listing (1 min)

- Open a listing from My Listings → tap the edit icon
- Change a field (e.g. description or phone number)
- Save the changes
- Show the listing update instantly in the UI
- **Switch to Firebase Console** → show the document reflecting the update

---

## 4. Deleting a Listing (1 min)

- On My Listings screen, swipe a listing left to delete
- Confirm the delete dialog
- Show the listing disappear from the screen instantly
- **Switch to Firebase Console** → show the document removed from Firestore

---

## 5. Search & Category Filtering (1 min)

- Go to **Directory** tab
- Type in the search bar — show results filtering in real time
- Clear the search
- Tap a category chip (e.g. Hospital, Park) — show only that category appearing
- Tap another category to switch filter

---

## 6. Listing Detail Page (1 min)

- Tap any listing from the Directory
- Show the detail page with all information displayed
- Point out the **embedded map with the location marker**
- Tap **Get Directions** — show Google Maps opening with the destination set
- Go back

---

## 7. Map View Screen (1 min)

- Go to the **Map View** tab
- Show all listing markers on the map
- Tap a marker — show the popup with name, category, address
- Tap **View Details** from the popup
- Go back to map — tap the **+ button** to show pick-location mode
- Tap a spot on the map — show Add Listing form opening with coordinates pre-filled

---

## 8. Code Walkthrough (1.5 min)

- Show the **folder structure** in your editor:
  - `models/` — data classes
  - `services/` — Firebase logic
  - `providers/` — state management
  - `screens/` — UI only
- Open `ListingsProvider` — explain how CRUD operations flow from UI → provider → service → Firebase
- Open `FirestoreService` — explain why all Firestore calls are isolated here, no Firebase in widgets
- Open `DirectoryScreen` — show `StreamBuilder` and explain how real-time updates work

---

## Key Rules

- Firebase Console must be **visible and updating** when you create, edit, and delete listings
- Explain what you are doing **while showing the relevant code on screen**
- Do not just show the app running — the examiner needs to see the implementation
