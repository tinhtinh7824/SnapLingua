import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/survey_service.dart';

class DebugDataView extends StatelessWidget {
  const DebugDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug - View Data'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Authentication Status', _buildAuthStatus()),
            SizedBox(height: 20.h),
            _buildSection('User Profile', _buildUserProfile()),
            SizedBox(height: 20.h),
            _buildSection('Survey Data', _buildSurveyData()),
            SizedBox(height: 20.h),
            _buildSection('Actions', _buildActions()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }

  Widget _buildAuthStatus() {
    final authService = AuthService.to;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataRow('Logged In', authService.isLoggedIn.toString()),
        _buildDataRow('User ID', authService.currentUserId),
        _buildDataRow('Email', authService.currentUserEmail),
      ],
    );
  }

  Widget _buildUserProfile() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: UserService.to.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data;
        if (data == null) {
          return const Text('No user data available');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Name', data['name']?.toString() ?? 'Not set'),
            _buildDataRow('Gender', data['gender']?.toString() ?? 'Not set'),
            _buildDataRow('Birth Date',
              '${data['birthDay'] ?? '?'}/${data['birthMonth'] ?? '?'}/${data['birthYear'] ?? '?'}'),
            _buildDataRow('Level', data['level']?.toString() ?? '0'),
            _buildDataRow('XP', data['xp']?.toString() ?? '0'),
            _buildDataRow('Streak', data['streak']?.toString() ?? '0'),
            _buildDataRow('Survey Completed', data['surveyCompleted']?.toString() ?? 'false'),
            _buildDataRow('Created At', data['createdAt']?.toString() ?? 'Unknown'),
          ],
        );
      },
    );
  }

  Widget _buildSurveyData() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: SurveyService.to.getUserSurveyData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data;
        if (data == null) {
          return const Text('No survey data available');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Purpose', data['purpose']?.toString() ?? 'Not set'),
            _buildDataRow('Study Time', data['studyTime']?.toString() ?? 'Not set'),
            _buildDataRow('Survey Completed', data['surveyCompleted']?.toString() ?? 'false'),
          ],
        );
      },
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _exportData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonActive,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Export Data to Console',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _clearLocalData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonDanger,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Clear Local Data',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    try {
      final userProfile = await UserService.to.getUserProfile();
      final surveyData = await SurveyService.to.getUserSurveyData();
      final authService = AuthService.to;

      final allData = {
        'auth': {
          'isLoggedIn': authService.isLoggedIn,
          'userId': authService.currentUserId,
          'email': authService.currentUserEmail,
        },
        'userProfile': userProfile,
        'surveyData': surveyData,
        'exportedAt': DateTime.now().toIso8601String(),
      };

      print('=== SNAPLINGUA DATA EXPORT ===');
      print(allData);
      print('=== END DATA EXPORT ===');

      Get.snackbar(
        'Data Exported',
        'Check the console/debug output for data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonSuccess,
        colorText: AppColors.textWhite,
      );
    } catch (e) {
      Get.snackbar(
        'Export Error',
        'Failed to export data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonDanger,
        colorText: AppColors.textWhite,
      );
    }
  }

  Future<void> _clearLocalData() async {
    try {
      await AuthService.to.logout();

      Get.snackbar(
        'Data Cleared',
        'Local data has been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonSuccess,
        colorText: AppColors.textWhite,
      );
    } catch (e) {
      Get.snackbar(
        'Clear Error',
        'Failed to clear data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.buttonDanger,
        colorText: AppColors.textWhite,
      );
    }
  }
}