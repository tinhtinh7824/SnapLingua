import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/profile_notification_controller.dart';

class ProfileNotificationView extends GetView<ProfileNotificationController> {
  const ProfileNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE6F9FF),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color(0xFF0B1D28),
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: const Color(0xFF0B1D28),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final loading = controller.isLoading.value;
        if (loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToggleCard(context),
              SizedBox(height: 18.h),
              _buildTimeCard(context),
              SizedBox(height: 18.h),
              _buildContextualCard(),
              SizedBox(height: 18.h),
              _buildHelpCard(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildToggleCard(BuildContext context) {
    return Obx(() {
      final enabled = controller.notificationsEnabled.value;
      return _SettingsCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bật thông báo',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B1D28),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Nhận nhắc nhở học tập, gợi ý bài học và cập nhật từ Snaplingua.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF4E5D6A),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: (value) => controller.toggleNotifications(value),
              thumbColor: WidgetStateProperty.resolveWith(
                (states) => const Color(0xFF1CB0F6),
              ),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? const Color(0xFFB4DBF4)
                    : const Color(0xFFDAE7F0),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTimeCard(BuildContext context) {
    return Obx(() {
      final enabled = controller.notificationsEnabled.value;
      final morningLabel =
          controller.formatTimeLabel(context, controller.morningTime.value);
      final eveningLabel =
          controller.formatTimeLabel(context, controller.eveningTime.value);

      return _SettingsCard(
        enabled: enabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giờ gửi thông báo',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0B1D28),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Chọn thời điểm bạn muốn nhận nhắc nhở buổi sáng và buổi tối.',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF4E5D6A),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: _TimePickerButton(
                    label: 'Buổi sáng',
                    value: morningLabel,
                    onTap: () => controller.pickMorningTime(context),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _TimePickerButton(
                    label: 'Buổi tối',
                    value: eveningLabel,
                    onTap: () => controller.pickEveningTime(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContextualCard() {
    return Obx(() {
      final enabled = controller.notificationsEnabled.value;
      final contextual = controller.contextualAllowed.value;
      return _SettingsCard(
        enabled: enabled,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cho phép ngữ cảnh',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B1D28),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Nhận thông báo dựa trên lịch học, streak hoặc bài học bạn đang theo dõi.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF4E5D6A),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: contextual,
              onChanged: (value) => controller.toggleContextual(value),
              thumbColor: WidgetStateProperty.resolveWith(
                (states) => const Color(0xFF1CB0F6),
              ),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? const Color(0xFFB4DBF4)
                    : const Color(0xFFDAE7F0),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHelpCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFFDCF4FF),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF9FD7FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_active_rounded,
            color: const Color(0xFF1991EB),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Hãy đảm bảo bạn đã bật quyền thông báo cho Snaplingua trong phần Cài đặt hệ thống để nhận thông báo đẩy.',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF0B1D28),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFB4DBF4), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.04),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TimePickerButton extends StatelessWidget {
  const _TimePickerButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4E5D6A),
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F6FF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFB4DBF4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0B1D28),
                  ),
                ),
                Icon(
                  Icons.access_time_filled_rounded,
                  color: const Color(0xFF1CB0F6),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
