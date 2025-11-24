# Firebase Cloud Firestore Migration Plan

This document outlines the steps required to migrate the SnapLingua project from the current MongoDB Realm (Flutter) and MongoDB Atlas (Spring Boot backend) data stack to Firebase Cloud Firestore.

## 1. Migration Goals
- Replace Realm local database usage in the Flutter app with Firebase Cloud Firestore.
- Replace Spring Data MongoDB repositories in the backend with Firestore access via the Firebase Admin SDK (or remove redundant backend endpoints in favour of direct Firestore access from the app where appropriate).
- Preserve existing functionality: authentication flows, vocabulary/lesson management, community features, notifications, and gamification data.
- Maintain offline capability where critical (Firestore local persistence).
- Ensure secure access rules leveraging Firebase Authentication and Firestore security rules.

## 2. High-Level Strategy
1. **Introduce Firebase to the Flutter app**
   - Add `firebase_core`, `cloud_firestore`, `firebase_auth` packages.
   - Generate platform configuration files (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`) via `flutterfire configure`.
   - Initialize Firebase in `main.dart` before starting the app; replace `RealmService` bootstrapping with Firestore init.
2. **Abstract data layer**
   - Create `FirestoreService` analogous to `RealmService` that exposes the minimal methods required by higher-level services (e.g., `AuthService`, `VocabularyService`).
   - Replace direct Realm model usage with plain Dart models / DTOs stored in Firestore collections.
3. **Incremental refactor of services/controllers**
   - Auth + user management (high priority).
   - Vocabulary, lessons, gamification.
   - Community, camera detection history, notifications.
   - Update `ServiceBinding` to inject Firestore-based services.
4. **Backend migration**
   - Decide whether to keep backend: if required for secured admin flows, add Firebase Admin SDK (`com.google.firebase:firebase-admin`) to interact with Firestore.
   - Replace Mongo repositories with service classes using Firestore collections.
   - Update controllers/services accordingly.
5. **Security & rules**
   - Configure Firebase Authentication providers (email/password, Google, etc.).
   - Write Firestore security rules matching current access restrictions (per-user documents, admin collections).
6. **Data migration**
   - Export existing Mongo Realm/MongoDB data (if any) and import into Firestore using scripts or Firebase Import/Export.
   - Provide tooling for initial dataset creation.

## 3. Flutter App Changes

### Dependencies (`pubspec.yaml`)
```yaml
dependencies:
  firebase_core: ^latest
  cloud_firestore: ^latest
  firebase_auth: ^latest
```
Remove `realm` packages once replacement complete.

### App Initialization (`lib/main.dart`)
- Call `WidgetsFlutterBinding.ensureInitialized();`
- Await `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);`
- Remove `RealmService.init()` and register `FirestoreService`.

### Data Layer
- Create new models (using `freezed`/manual) for Firestore documents, e.g. `UserProfile`, `VocabularyEntry`.
- Map Firestore documents to strongly typed models.
- Update services to use Firestore queries (`FirebaseFirestore.instance.collection('users')...`).
- Remove Realm object annotations (`@RealmModel`) and generated `.realm.dart` files once unused.

### Offline Support
- Enable Firestore persistence: `FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);`
- Use `withConverter` for typed collections.

### Routing Impact
- Ensure existing controllers fetch data via new services; adapt reactive GetX observables to Firestore streams (`collection.snapshots()`).

## 4. Backend Changes (Spring Boot)

### Dependencies (`pom.xml`)
- Remove `spring-boot-starter-data-mongodb`.
- Add Firebase Admin SDK:
  ```xml
  <dependency>
      <groupId>com.google.firebase</groupId>
      <artifactId>firebase-admin</artifactId>
      <version>9.2.0</version>
  </dependency>
  ```
- Optionally, add `com.google.cloud:google-cloud-firestore`.

### Configuration
- Load service account credentials (JSON) from environment variable / file.
- Initialize Firebase app in a configuration class (`@Configuration`).

### Repositories -> Services
- Replace `MongoRepository` interfaces with Firestore service classes using `FirestoreClient.getFirestore()`; implement CRUD manually.
- Update controllers to use new services.

### Authentication
- Use Firebase Authentication tokens verified via `FirebaseAuth.getInstance().verifyIdToken`.
- Align with mobile client tokens.

## 5. Firestore Data Model Mapping

| Realm/Mongo collection | Firestore collection | Notes |
| ---------------------- | -------------------- | ----- |
| `users`                | `users`              | Document ID: UID from Firebase Auth. |
| `auth_sessions`        | `authSessions`       | Consider replacing with Firebase Auth session management. |
| `password_resets`      | `passwordResets`     | Prefer Firebase Auth password reset API; may not need collection. |
| `vocabulary`, `userVocabulary`, etc. | `vocabulary`, `userVocabulary`, `reviews` | Mirror current structure; use subcollections if beneficial. |
| `study_groups`, `messages` | `groups`, `groupMessages` | Use security rules for access control. |
| `notifications`        | `notifications`      | Consider Cloud Functions for push scheduling. |
| `gamification` entities | `achievements`, `leaderboards`, etc. | Evaluate batching/aggregation strategies with Cloud Functions. |

## 6. Migration Steps & Sequencing
1. **Project Setup**
   - Configure Firebase project.
   - Generate platform config files.
   - Update Flutter dependencies and initialization.
2. **Auth Migration**
   - Integrate Firebase Auth.
   - Update login/register flows.
   - Migrate password reset to Firebase.
3. **User Profile & Core Data**
   - Implement Firestore repositories for user profiles, vocabulary.
   - Update UI controllers for these features.
4. **Secondary Modules**
   - Lessons, gamification, community, camera history.
5. **Backend Adjustments**
   - Introduce Firebase Admin configuration.
   - Migrate endpoints data access.
6. **Remove Realm/Mongo Artifacts**
   - Delete Realm models, generated files, and config after verification.
7. **Testing**
   - Write integration tests using Firebase emulator suite.
   - Ensure offline behavior matches expectations.

## 7. Tooling & Environment
- Use Firebase Emulator Suite for local development (Firestore + Auth).
- Update `README` and `DATABASE_SETUP` with Firebase instructions.
- Provide scripts to seed Firestore (e.g., via Node.js or Kotlin).

## 8. Risks & Mitigations
- **Large refactor scope**: approach incrementally, feature-by-feature.
- **Security rules complexity**: design early, use emulator to test.
- **Offline differences vs Realm**: test thoroughly, consider caching strategies.
- **Backend duplication**: evaluate necessity; consider migrating to Firebase Functions if backend logic minimal.

## 9. Acceptance Criteria
- App boots with Firebase initialized; no Realm dependencies.
- Core CRUD operations succeed via Firestore.
- Authentication uses Firebase Auth.
- Backend (if retained) reads/writes Firestore.
- Automated tests updated to cover Firestore access (using emulator/mocks).

