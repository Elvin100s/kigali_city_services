# Implementation Reflection - Kigali City Services

**Student**: [Your Name]  
**Course**: Mobile Development - Individual Assignment 2  
**Date**: March 2025

---

## Firebase Integration Experience

This project gave me hands-on experience integrating Firebase Authentication and Cloud Firestore into a Flutter application. Throughout development, I encountered several technical challenges that required debugging and architectural decisions to build a working app.

---

## Error 1: Gradle Build Memory Issues

### Problem Description
During initial Android builds, the application consistently failed with `OutOfMemoryError` exceptions. The build process would crash after several minutes with the following error:

```
FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'flutter'' finished with non-zero exit value 1

OutOfMemoryError: Java heap space
There is insufficient memory for the Java Runtime Environment to continue.
Native memory allocation (mmap) failed to map 274726912 bytes.
```

### Screenshot Evidence
The error logs showed heap memory exhaustion during the Gradle build process, particularly when processing Android dependencies and Flutter compilation.

### Resolution Steps
1. **Modified `android/gradle.properties`**:
   ```properties
   org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m
   org.gradle.parallel=false
   org.gradle.configureondemand=false
   ```

2. **Reduced memory allocation** from default 4GB to 2GB
3. **Disabled parallel builds** to reduce concurrent memory usage
4. **Cleared Gradle cache** using `./gradlew clean`

### Learning Outcome
I learned that default Android Studio configurations assume you have a high-end machine. On my 8GB RAM laptop, I had to optimize the build settings. This taught me the importance of understanding build tool configuration and memory management in mobile development.

---

## Error 2: Firestore Security Rules Permission Denied

### Problem Description
When implementing the OTP verification system, users encountered `PERMISSION_DENIED` errors when attempting to write OTP data to Firestore during the signup process:

```
[cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.
Error: Missing or insufficient permissions.
```

### Screenshot Evidence
Firebase Console showed failed write attempts to the `email_otps` collection with permission denied status. The error occurred specifically when newly created users tried to store OTP verification data.

### Resolution Steps
1. **Updated Firestore Security Rules**:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Allow authenticated users to read/write their own user profile
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Allow authenticated users to write OTP data
       match /email_otps/{email} {
         allow read, write: if request.auth != null;
       }
       
       // Allow authenticated users to write email simulation data
       match /otp_emails/{docId} {
         allow read, write: if request.auth != null;
       }
       
       // Listings: users can read all, but only modify their own
       match /listings/{listingId} {
         allow read: if true;
         allow create: if request.auth != null;
         allow update, delete: if request.auth != null && 
           request.auth.uid == resource.data.createdBy;
       }
     }
   }
   ```

2. **Tested rules in Firebase Console** before deployment
3. **Implemented proper error handling** in the Flutter app for permission failures

### Learning Outcome
This error taught me that Firestore security rules must be configured before testing write operations. The default rules deny all access, so you need explicit permission configuration. I now understand the importance of testing security rules in the Firebase Console before deploying them.

---

## Error 3: Missing Firebase Dependencies

### Problem Description
During initial project setup, forgetting to include the `cloud_firestore` package in `pubspec.yaml` caused widespread compilation errors. The Flutter analyzer reported 25 errors across multiple files:

```
Analyzing kigali_city_services...

error - Target of URI doesn't exist: 'package:cloud_firestore/cloud_firestore.dart'
error - Undefined class 'DocumentSnapshot'
error - Undefined class 'FirebaseFirestore'
error - Undefined name 'Timestamp'
error - Undefined name 'FieldValue'

25 issues found.
```

### Screenshot Evidence
The terminal showed import errors in `listing_model.dart`, `user_model.dart`, `email_otp_service.dart`, and `firestore_service.dart`. All files attempting to import `cloud_firestore` failed with "Target of URI doesn't exist" errors.

### Resolution Steps
1. **Added missing dependency to `pubspec.yaml`**:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^4.4.0
     firebase_auth: ^6.1.4
     cloud_firestore: ^6.1.2  # Added this line
     provider: ^6.1.1
   ```

2. **Ran `flutter pub get`** to download the package
3. **Verified imports** resolved correctly with `flutter analyze`
4. **Hot restarted** the app to apply changes

### Learning Outcome
I learned that Firebase integration requires explicit package dependencies for each service. Just having `firebase_core` isn't enough - you need separate packages for Auth, Firestore, Storage, etc. This experience showed me the importance of carefully reading Firebase setup documentation and understanding Flutter's package management.

---

## Development Insights

### Firebase Integration Workflow
The integration process followed this pattern:
1. **Firebase project setup** with Authentication and Firestore enabled
2. **Flutter configuration** with firebase_core and service-specific packages
3. **Security rules configuration** before implementing write operations
4. **Service layer implementation** for Firebase operations
5. **Provider layer** for state management and UI updates
6. **UI implementation** with proper error handling and loading states

### State Management Architecture
I chose the Provider pattern for this project because it was sufficient for the app's complexity. Separating services (Firebase operations) from providers (state management) created a clean architecture that met the assignment requirements while keeping the code maintainable.

### Testing Strategy
I relied heavily on the Firebase Console to verify data changes while testing the app on the emulator. Being able to see real-time database updates helped me quickly identify and fix integration issues.

---

## Conclusion

This project successfully demonstrated mobile development with Firebase integration. The challenges I encountered - from build configuration to security rules to dependency management - provided valuable learning experiences that improved my understanding of Flutter development and the Firebase ecosystem. The final application meets all requirements with a solid architecture.