import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Provides Firebase configuration using compile-time environment variables.
///
/// Configure the required `--dart-define` values when running the app.
/// See `docs/firebase_setup.md` for details.
class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return _webOptions;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidOptions;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return _appleOptions;
      case TargetPlatform.windows:
        return _windowsOptions;
      case TargetPlatform.linux:
        return _linuxOptions;
      case TargetPlatform.fuchsia:
        return _fuchsiaOptions;
    }
  }

  static FirebaseOptions? get _androidOptions {
    const apiKey = String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_ANDROID_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_ANDROID_PROJECT_ID');
    const storageBucket =
        String.fromEnvironment('FIREBASE_ANDROID_STORAGE_BUCKET');
    const androidClientId =
        String.fromEnvironment('FIREBASE_ANDROID_CLIENT_ID');

    if (_anyEmpty([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
      androidClientId: androidClientId.isEmpty ? null : androidClientId,
    );
  }

  static FirebaseOptions? get _appleOptions {
    const apiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_IOS_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_IOS_PROJECT_ID');
    const storageBucket =
        String.fromEnvironment('FIREBASE_IOS_STORAGE_BUCKET');
    const iosClientId =
        String.fromEnvironment('FIREBASE_IOS_CLIENT_ID');
    const iosBundleId =
        String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');
    const iosAppGroupId =
        String.fromEnvironment('FIREBASE_IOS_APP_GROUP_ID');

    if (_anyEmpty([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
      iosClientId: iosClientId.isEmpty ? null : iosClientId,
      iosBundleId: iosBundleId.isEmpty ? null : iosBundleId,
      appGroupId: iosAppGroupId.isEmpty ? null : iosAppGroupId,
    );
  }

  static FirebaseOptions? get _webOptions {
    const apiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
    const authDomain =
        String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
    const storageBucket =
        String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET');
    const measurementId =
        String.fromEnvironment('FIREBASE_WEB_MEASUREMENT_ID');
    const databaseURL =
        String.fromEnvironment('FIREBASE_WEB_DATABASE_URL');

    if (_anyEmpty([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain.isEmpty ? null : authDomain,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
      measurementId: measurementId.isEmpty ? null : measurementId,
      databaseURL: databaseURL.isEmpty ? null : databaseURL,
    );
  }

  static FirebaseOptions? get _windowsOptions {
    const apiKey = String.fromEnvironment('FIREBASE_WINDOWS_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_WINDOWS_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_WINDOWS_MESSAGING_SENDER_ID');
    const projectId =
        String.fromEnvironment('FIREBASE_WINDOWS_PROJECT_ID');
    const storageBucket =
        String.fromEnvironment('FIREBASE_WINDOWS_STORAGE_BUCKET');

    if (_anyEmpty([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }

  static FirebaseOptions? get _linuxOptions {
    const apiKey = String.fromEnvironment('FIREBASE_LINUX_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_LINUX_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_LINUX_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_LINUX_PROJECT_ID');
    const storageBucket =
        String.fromEnvironment('FIREBASE_LINUX_STORAGE_BUCKET');

    if (_anyEmpty([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }

  static FirebaseOptions? get _fuchsiaOptions {
    const apiKey = String.fromEnvironment('FIREBASE_FUCHSIA_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_FUCHSIA_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_FUCHSIA_MESSAGING_SENDER_ID');
    const projectId =
        String.fromEnvironment('FIREBASE_FUCHSIA_PROJECT_ID');

    if (_anyEmpty([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
    );
  }

  static bool _anyEmpty(Iterable<String> values) =>
      values.any((value) => value.trim().isEmpty);
}
