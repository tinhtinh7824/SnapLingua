import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SurveyController extends GetxController {
  static SurveyController get to => Get.find();

  // Current step (1-4)
  final _currentStep = 1.obs;
  int get currentStep => _currentStep.value;

  // Survey data
  final _name = ''.obs;
  final _birthDay = ''.obs;
  final _birthMonth = ''.obs;
  final _birthYear = ''.obs;
  final _gender = ''.obs;
  final _purpose = ''.obs;
  final _studyTime = ''.obs;

  // Text controllers
  final nameController = TextEditingController();

  // Getters
  String get name => _name.value;
  String get birthDay => _birthDay.value;
  String get birthMonth => _birthMonth.value;
  String get birthYear => _birthYear.value;
  String get gender => _gender.value;
  String get purpose => _purpose.value;
  String get studyTime => _studyTime.value;

  // Purpose options
  final purposeOptions = [
    'Không gì cả',
    'Học tập',
    'Công việc',
    'Giao tiếp hàng ngày',
    'Kết bạn bốn phương',
    'Khác',
  ];

  // Study time options
  final studyTimeOptions = [
    '5 phút/ngày',
    '10 phút/ngày',
    '15 phút/ngày',
    '20 phút/ngày',
  ];

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      _name.value = nameController.text;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // Validation for each step
  bool canContinueStep1() {
    return _name.value.isNotEmpty &&
           _birthDay.value.isNotEmpty &&
           _birthMonth.value.isNotEmpty &&
           _birthYear.value.isNotEmpty &&
           _gender.value.isNotEmpty;
  }

  bool canContinueStep2() {
    return _purpose.value.isNotEmpty;
  }

  bool canContinueStep3() {
    return _studyTime.value.isNotEmpty;
  }

  // Navigation methods
  void nextStep() {
    if (_currentStep.value < 4) {
      _currentStep.value++;
    }
  }

  void previousStep() {
    if (_currentStep.value > 1) {
      _currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 4) {
      _currentStep.value = step;
    }
  }

  // Data setters
  void setName(String value) {
    _name.value = value;
  }

  void setBirthDay(String value) {
    _birthDay.value = value;
  }

  void setBirthMonth(String value) {
    _birthMonth.value = value;
  }

  void setBirthYear(String value) {
    _birthYear.value = value;
  }

  void setGender(String value) {
    _gender.value = value;
  }

  void setPurpose(String value) {
    _purpose.value = value;
  }

  void setStudyTime(String value) {
    _studyTime.value = value;
  }

  // Complete survey and navigate to home
  void completeSurvey() {
    // Save survey data (in real app, send to backend)
    debugPrint('Survey completed with data:');
    debugPrint('Name: $name');
    debugPrint('Birth: $birthDay/$birthMonth/$birthYear');
    debugPrint('Gender: $gender');
    debugPrint('Purpose: $purpose');
    debugPrint('Study Time: $studyTime');

    // Navigate to home
    Get.offAllNamed(Routes.home);
  }
}