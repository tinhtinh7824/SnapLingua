part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const home = _Paths.home;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const survey = _Paths.survey;
  static const forgotPassword = _Paths.forgotPassword;
  static const verifyResetCode = _Paths.verifyResetCode;
  static const newPassword = _Paths.newPassword;
  static const debugData = _Paths.debugData;
  static const shop = _Paths.shop;
  static const streak = _Paths.streak;
  static const notification = _Paths.notification;
  static const review = _Paths.review;
  static const vocabularyList = _Paths.vocabularyList;
  static const cameraDetection = _Paths.cameraDetection;
  static const detectionResult = _Paths.detectionResult;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const survey = '/survey';
  static const forgotPassword = '/forgot-password';
  static const verifyResetCode = '/verify-reset-code';
  static const newPassword = '/new-password';
  static const debugData = '/debug-data';
  static const shop = '/shop';
  static const streak = '/streak';
  static const notification = '/notification';
  static const review = '/review';
  static const vocabularyList = '/vocabulary-list';
  static const cameraDetection = '/camera-detection';
  static const detectionResult = '/detection-result';
}