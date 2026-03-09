# Implementation Reflection — Kigali City Services

---

## Overview

This reflection documents the challenges encountered while integrating Firebase Authentication and Cloud Firestore into the Kigali City Services Flutter application, along with the solutions applied to resolve each issue.

---

## Challenge 1: EmailJS API Blocked in Non-Browser Environments

**Description:**
After implementing the OTP email verification system using EmailJS, the app worked correctly when tested on a web browser but failed completely when running on an Android device. The app threw the following exception:

```
Exception: Failed to send OTP email: API access from a non-browser environment is currently disabled
```

**Cause:**
EmailJS blocks API requests originating from non-browser environments by default as a security measure. Since Flutter mobile apps do not run in a browser, all requests were being rejected.

**Solution:**
The fix was applied in the EmailJS account security settings by enabling the **"Allow EmailJS API for non-browser applications"** option. This explicitly permits API calls from mobile environments. After saving the setting and re-running the app on the Android device, OTP emails were delivered successfully.

---

## Challenge 2: EmailJS Strict Mode — Private Key Not Provided

**Description:**
After resolving the first EmailJS error, a second error appeared when attempting to sign up on the Android device:

```
Exception: Failed to send OTP email: API access in strict mode, but no private key was provided
```

**Cause:**
The **"Use Private Key"** option in EmailJS security settings had been inadvertently enabled, which puts the API into strict mode. In strict mode, every request must include a private key in the Authorization header. The Flutter app was only sending the public key, causing all requests to be rejected.

**Solution:**
The fix was to disable the **"Use Private Key"** strict mode option in the EmailJS account security settings. With strict mode turned off, the public key was sufficient to authenticate requests and OTP emails were delivered correctly.

---

## Challenge 3: Firestore Missing Composite Index

**Description:**
When navigating to the My Listings screen, the following error appeared:

```
Error: [cloud_firestore/failed-precondition]
The query requires an index. You can create it here: https://console.firebase.google.com/...
```

**Cause:**
The `getUserListingsStream` query used both a `where` clause filtering by `createdBy` and an `orderBy` clause sorting by `createdAt` in descending order. Firestore requires a composite index for any query that combines filtering and ordering on different fields.

**Solution:**
Two approaches were applied. First, the composite index was created via the link provided in the error message. However, since the index was taking time to build and the error persisted, the query was refactored to remove the `orderBy` clause from the Firestore query entirely. Sorting is now performed client-side in Dart after the documents are retrieved:

```dart
listings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
```

This eliminates the composite index requirement while producing identical results — listings still appear newest first.

---

## Challenge 4: Google Maps SDK Requires Billing Account

**Description:**
The assignment specification required an embedded Google Map on the listing detail page. When attempting to integrate the `google_maps_flutter` package, it became clear that a Google Maps API key is required, and obtaining one requires a billing-enabled Google Cloud account.

**Cause:**
Google Maps Platform requires valid billing credentials even for free-tier usage. Without a billing account, no API key can be generated and the SDK cannot be used.

**Solution:**
The `flutter_map` package with OpenStreetMap tiles was used as an alternative. This provides identical functionality to the Google Maps SDK — interactive maps, coordinate-based markers, zoom and pan controls — without requiring any API key or billing account. Geographic coordinates stored in Firestore are passed directly into the `FlutterMap` widget to place markers at the correct locations. Navigation was still implemented using Google Maps by constructing a directions URL with the stored coordinates and launching it externally via `url_launcher`:

```dart
final url = Uri.parse(
  'https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}'
);
await launchUrl(url, mode: LaunchMode.externalApplication);
```

This ensures users get full turn-by-turn navigation through Google Maps while the embedded map view works without billing requirements.

---

## Summary

| Challenge | Cause | Resolution |
|---|---|---|
| EmailJS non-browser blocked | Default security restriction | Enabled non-browser access in EmailJS settings |
| EmailJS strict mode error | Private key mode accidentally enabled | Disabled strict mode in EmailJS settings |
| Firestore composite index error | where + orderBy query requires index | Removed orderBy from query, sort client-side |
| Google Maps requires billing | No billing account available | Used flutter_map + OpenStreetMap as alternative |
