import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/firestore_notification_settings.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'push_notification_service.dart';

class NotificationSettingsService extends GetxService {
  NotificationSettingsService({
    FirestoreService? firestoreService,
    AuthService? authService,
    PushNotificationService? pushNotificationService,
  })  : _firestoreService = firestoreService ?? FirestoreService.to,
        _authService = authService ?? AuthService.to,
        _pushNotificationService = pushNotificationService;

  static NotificationSettingsService get to => Get.find();

  static const TimeOfDay _defaultMorning = TimeOfDay(hour: 8, minute: 0);
  static const TimeOfDay _defaultEvening = TimeOfDay(hour: 20, minute: 0);

  final FirestoreService _firestoreService;
  final AuthService _authService;
  PushNotificationService? _pushNotificationService;

  final RxBool isLoading = false.obs;
  final RxBool pushEnabled = false.obs;
  final RxBool contextualAllowed = false.obs;
  final Rx<TimeOfDay> morningTime = _defaultMorning.obs;
  final Rx<TimeOfDay> eveningTime = _defaultEvening.obs;
  // Đơn giản hoá: tần suất chỉ lưu tại client (chưa có trường trên Firestore)
  final RxString frequency = 'Hằng ngày'.obs;
  final List<String> availableFrequencies = <String>[
    'Hằng ngày',
    'Mỗi 2 ngày',
    'Hằng tuần',
  ];

  FirestoreNotificationSettings? _current;
  bool _hasInitialized = false;

  Future<void> ensureLoaded() async {
    if (_hasInitialized) return;
    await loadSettings();
  }

  Future<void> loadSettings() async {
    if (!_authService.isLoggedIn) {
      _applyDefaults();
      _hasInitialized = true;
      return;
    }

    isLoading.value = true;
    try {
      final userId = _authService.currentUserId;
      final settings = await _firestoreService.getNotificationSettings(userId);
      if (settings != null) {
        _applySettings(settings);
      } else {
        _applyDefaults();
        final created = FirestoreNotificationSettings(
          userId: userId,
          pushEnabled: false,
          morningTime: _formatTime(_defaultMorning),
          eveningTime: _formatTime(_defaultEvening),
          contextualAllowed: false,
        );
        await _firestoreService.upsertNotificationSettings(created);
        _current = created;
      }
      _hasInitialized = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePushEnabled(bool enabled) async {
    if (!_authService.isLoggedIn) {
      pushEnabled.value = false;
      return;
    }

    final pushService = await _ensurePushService();
    if (enabled) {
      if (pushService == null) {
        pushEnabled.value = false;
        _showPermissionWarning();
        await _persistSettings(pushEnabled: false);
        return;
      }
      final registered = await pushService.registerCurrentDevice();
      if (!registered) {
        pushEnabled.value = false;
        _showPermissionWarning();
        await _persistSettings(pushEnabled: false);
        return;
      }
    } else {
      if (pushService != null) {
        await pushService.unregisterCurrentDevice();
      }
    }

    pushEnabled.value = enabled;
    await _persistSettings(pushEnabled: enabled);
  }

  Future<void> updateMorningTime(TimeOfDay time) async {
    morningTime.value = time;
    await _persistSettings(morning: time);
  }

  Future<void> updateEveningTime(TimeOfDay time) async {
    eveningTime.value = time;
    await _persistSettings(evening: time);
  }

  // Aliases cho UI cũ
  Rx<TimeOfDay> get reminderTime => morningTime;
  Future<void> updateTime(TimeOfDay time) => updateMorningTime(time);
  Future<void> updateEnabled(bool enabled) => updatePushEnabled(enabled);

  Future<void> updateFrequency(String value) async {
    frequency.value = value;
    // Hiện chưa có field trên Firestore; nếu sau này cần lưu, bổ sung tại đây.
  }

  Future<void> updateContextualAllowed(bool value) async {
    contextualAllowed.value = value;
    await _persistSettings(contextual: value);
  }

  void resetToDefaults() {
    _applyDefaults();
    _hasInitialized = false;
    _current = null;
  }

  Future<PushNotificationService?> _ensurePushService() async {
    if (_pushNotificationService != null) {
      return _pushNotificationService;
    }
    if (Get.isRegistered<PushNotificationService>()) {
      _pushNotificationService = PushNotificationService.to;
      return _pushNotificationService;
    }
    return null;
  }

  void _applyDefaults() {
    pushEnabled.value = false;
    contextualAllowed.value = false;
    morningTime.value = _defaultMorning;
    eveningTime.value = _defaultEvening;
  }

  void _applySettings(FirestoreNotificationSettings settings) {
    _current = settings;
    pushEnabled.value = settings.pushEnabled;
    contextualAllowed.value = settings.contextualAllowed;
    morningTime.value =
        _parseTime(settings.morningTime) ?? _defaultMorning;
    eveningTime.value =
        _parseTime(settings.eveningTime) ?? _defaultEvening;
  }

  Future<void> _persistSettings({
    bool? pushEnabled,
    TimeOfDay? morning,
    TimeOfDay? evening,
    bool? contextual,
  }) async {
    if (!_authService.isLoggedIn) {
      return;
    }
    final userId = _authService.currentUserId;
    final Map<String, dynamic> payload = {
      'push_enabled': pushEnabled ?? this.pushEnabled.value,
      'morning_time': _formatTime(morning ?? morningTime.value),
      'evening_time': _formatTime(evening ?? eveningTime.value),
      'contextual_allowed': contextual ?? contextualAllowed.value,
    };

    await _firestoreService.updateNotificationSettings(userId, payload);
    _current = FirestoreNotificationSettings(
      userId: userId,
      pushEnabled: payload['push_enabled'] as bool,
      morningTime: payload['morning_time'] as String?,
      eveningTime: payload['evening_time'] as String?,
      contextualAllowed: payload['contextual_allowed'] as bool,
    );
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final segments = value.split(':');
    if (segments.length != 2) return null;
    final hour = int.tryParse(segments[0]) ?? _defaultMorning.hour;
    final minute = int.tryParse(segments[1]) ?? _defaultMorning.minute;
    return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showPermissionWarning() {
    Get.snackbar(
      'Chưa bật thông báo',
      'Bạn cần cho phép Snaplingua gửi thông báo trong phần cài đặt hệ thống.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
