# Firebase configuration

The application prefers injecting Firebase credentials at build time using
`--dart-define` flags so that sensitive values are not committed to
source control.

## Required values

Provide the following defines per platform you target:

### Android
```
flutter run \
  --dart-define=FIREBASE_ANDROID_API_KEY=... \
  --dart-define=FIREBASE_ANDROID_APP_ID=... \
  --dart-define=FIREBASE_ANDROID_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_ANDROID_PROJECT_ID=... \
  --dart-define=FIREBASE_ANDROID_STORAGE_BUCKET=... \
  --dart-define=FIREBASE_ANDROID_CLIENT_ID=...
```
Only the first four values are mandatory. Retrieve the values from
`google-services.json` (do not commit the file).

### iOS / macOS
```
flutter run \
  --dart-define=FIREBASE_IOS_API_KEY=... \
  --dart-define=FIREBASE_IOS_APP_ID=... \
  --dart-define=FIREBASE_IOS_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_IOS_PROJECT_ID=... \
  --dart-define=FIREBASE_IOS_STORAGE_BUCKET=... \
  --dart-define=FIREBASE_IOS_CLIENT_ID=... \
  --dart-define=FIREBASE_IOS_BUNDLE_ID=...
```
Values are available in `GoogleService-Info.plist`.

### Web (if applicable)
```
flutter run -d chrome \
  --dart-define=FIREBASE_WEB_API_KEY=... \
  --dart-define=FIREBASE_WEB_APP_ID=... \
  --dart-define=FIREBASE_WEB_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_WEB_PROJECT_ID=... \
  --dart-define=FIREBASE_WEB_AUTH_DOMAIN=... \
  --dart-define=FIREBASE_WEB_STORAGE_BUCKET=... \
  --dart-define=FIREBASE_WEB_MEASUREMENT_ID=...
```
Copy these values from your Firebase project's web app configuration.

### Desktop (optional)
Defines exist in `lib/firebase_options.dart` for Windows, Linux and Fuchsia.
Declare them only if you target these platforms.

## Generating the credentials

1. Run `flutterfire configure` and register the project for every platform you
   need. This generates the `google-services.json` and `GoogleService-Info.plist`
   files that contain the values listed above.
2. Copy the keys into your CI or local run configuration as `--dart-define`
   entries. Do **not** commit the generated files unless you intend to share the
   credentials.

If you omit the defines, the app falls back to the traditional native Firebase
setup that relies on `google-services.json` (Android) and `GoogleService-Info.plist`
(iOS/macOS). In that case, place those files in the standard platform folders
and ensure they are not tracked by git (see `.gitignore`).

## Debugging

Look for log lines mentioning `Firebase configuration not provided` to confirm
that the fallback path is being used. If initialization still fails, verify that
your native config files are present or that the `--dart-define` values are set.
