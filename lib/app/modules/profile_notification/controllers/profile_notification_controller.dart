import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/notification_settings_service.dart';

class ProfileNotificationController extends GetxController {
  ProfileNotificationController({
    NotificationSettingsService? settingsService,
  }) : _settingsService = settingsService ?? NotificationSettingsService.to;

  final NotificationSettingsService _settingsService;

  RxBool get isLoading => _settingsService.isLoading;
  RxBool get notificationsEnabled => _settingsService.pushEnabled;
  Rx<TimeOfDay> get morningTime => _settingsService.morningTime;
  Rx<TimeOfDay> get eveningTime => _settingsService.eveningTime;
  RxBool get contextualAllowed => _settingsService.contextualAllowed;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(_settingsService.ensureLoaded);
  }

  Future<void> toggleNotifications(bool value) {
    return _settingsService.updatePushEnabled(value);
  }

  Future<void> pickMorningTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: morningTime.value,
      helpText: 'Chọn giờ thông báo buổi sáng',
    );
    if (selected == null) return;
    await _settingsService.updateMorningTime(selected);
  }

  Future<void> pickEveningTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: eveningTime.value,
      helpText: 'Chọn giờ thông báo buổi tối',
    );
    if (selected == null) return;
    await _settingsService.updateEveningTime(selected);
  }

  Future<void> toggleContextual(bool value) {
    return _settingsService.updateContextualAllowed(value);
  }

  String formatTimeLabel(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}
