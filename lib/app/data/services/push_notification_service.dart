import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'firestore_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log(
    'Received background notification ${message.messageId}',
    name: 'PushNotificationService',
  );
}

class PushNotificationService extends GetxService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestoreService = firestoreService ?? FirestoreService.to,
        _authService = authService ?? AuthService.to;

  static PushNotificationService get to => Get.find();

  final FirebaseMessaging _messaging;
  final FirestoreService _firestoreService;
  final AuthService _authService;

  final RxBool permissionGranted = false.obs;
  bool _messagingSupported = false;

  Future<PushNotificationService> init() async {
    if (!_isSupportedPlatform) {
      _logUnsupported();
      return this;
    }
    try {
      _messagingSupported = await _messaging.isSupported();
    } catch (error) {
      _logUnsupported(reason: 'Messaging plugin unavailable: $error');
      _messagingSupported = false;
    }
    if (!_messagingSupported) {
      _logUnsupported();
      return this;
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _refreshPermissionStatus();
    await _syncInitialToken();
    _messaging.onTokenRefresh.listen(_handleTokenRefresh);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    return this;
  }

  Future<bool> ensurePermission() async {
    if (!_messagingSupported) {
      return false;
    }
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    permissionGranted.value = granted;
    if (!granted) {
      log(
        'Notification permission denied: ${settings.authorizationStatus}',
        name: 'PushNotificationService',
      );
    }
    return granted;
  }

  Future<bool> registerCurrentDevice() async {
    if (!_messagingSupported) {
      return false;
    }
    if (!_authService.isLoggedIn) {
      return false;
    }
    if (!permissionGranted.value) {
      final granted = await ensurePermission();
      if (!granted) return false;
    }
    await _syncInitialToken(force: true);
    return true;
  }

  Future<void> unregisterCurrentDevice() async {
    if (!_messagingSupported) return;
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _firestoreService.removeDeviceToken(token);
      }
    } catch (error) {
      log('Failed to unregister device token: $error',
          name: 'PushNotificationService');
    }
  }

  Future<void> _refreshPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    permissionGranted.value = settings.authorizationStatus ==
            AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> _syncInitialToken({bool force = false}) async {
    if (!_authService.isLoggedIn) {
      return;
    }
    if (!permissionGranted.value && !force) {
      return;
    }
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      final deviceType = _resolveDeviceType();
      await _firestoreService.upsertDeviceToken(
        userId: _authService.currentUserId,
        fcmToken: token,
        deviceType: deviceType,
      );
    } catch (error) {
      log('Failed to sync device token: $error', name: 'PushNotificationService');
    }
  }

  void _handleTokenRefresh(String token) {
    if (!_messagingSupported) return;
    if (!_authService.isLoggedIn) {
      return;
    }
    final deviceType = _resolveDeviceType();
    _firestoreService.upsertDeviceToken(
      userId: _authService.currentUserId,
      fcmToken: token,
      deviceType: deviceType,
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (!_messagingSupported) return;
    log(
      'Foreground notification received: ${message.messageId}',
      name: 'PushNotificationService',
    );
  }

  String _resolveDeviceType() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      default:
        return 'unknown';
    }
  }

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  void _logUnsupported({Object? reason}) {
    log(
      'Push notifications are not supported on this platform.'
      '${reason != null ? ' ($reason)' : ''}',
      name: 'PushNotificationService',
    );
  }
}
