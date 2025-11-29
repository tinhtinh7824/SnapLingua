import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/notification_settings_service.dart';
import '../../../data/services/notification_scheduler_service.dart';

class ProfileNotificationController extends GetxController {
  ProfileNotificationController({NotificationSettingsService? settingsService})
      : _settingsService = settingsService ?? NotificationSettingsService.to,
        _schedulerService = NotificationSchedulerService.to;

  final NotificationSettingsService _settingsService;
  final NotificationSchedulerService _schedulerService;

  RxBool get notificationsEnabled => _settingsService.pushEnabled;
  Rx<TimeOfDay> get reminderTime => _settingsService.reminderTime;
  RxString get frequency => _settingsService.frequency;
  List<String> get frequencies => _settingsService.availableFrequencies;

  Future<void> toggleNotifications(bool value) async {
    await _settingsService.updateEnabled(value);
  }

  Future<void> updateTime(TimeOfDay time) async {
    await _settingsService.updateTime(time);
  }

  Future<void> updateFrequency(String value) async {
    await _settingsService.updateFrequency(value);
  }

  Future<void> sendTestNotification() async {
    await _schedulerService.showTestNotification();
  }

  Future<void> sendScheduledTestNotification() async {
    await _schedulerService.scheduleTestNotification();
  }
}
