import 'package:get/get.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/survey/bindings/survey_binding.dart';
import '../modules/survey/views/survey_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/forgot_password/views/verify_code_view.dart';
import '../modules/forgot_password/views/new_password_view.dart';
import '../modules/debug/views/debug_data_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/shop/bindings/shop_binding.dart';
import '../modules/shop/views/shop_view.dart';
import '../modules/streak/bindings/streak_binding.dart';
import '../modules/streak/views/streak_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/vocabulary_list/bindings/vocabulary_list_binding.dart';
import '../modules/vocabulary_list/views/vocabulary_list_view.dart';
import '../modules/camera_detection/bindings/camera_detection_binding.dart';
import '../modules/camera_detection/views/camera_detection_view.dart';
import '../modules/camera_detection/views/detection_result_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    // Add other pages here
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.survey,
      page: () => const SurveyView(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.verifyResetCode,
      page: () => const VerifyCodeView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.newPassword,
      page: () => const NewPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.debugData,
      page: () => const DebugDataView(),
    ),
    GetPage(
      name: _Paths.shop,
      page: () => const ShopView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.streak,
      page: () => const StreakView(),
      binding: StreakBinding(),
    ),
    GetPage(
      name: _Paths.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.review,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.vocabularyList,
      page: () => const VocabularyListView(),
      binding: VocabularyListBinding(),
    ),
    GetPage(
      name: _Paths.cameraDetection,
      page: () => const CameraDetectionView(),
      binding: CameraDetectionBinding(),
    ),
    GetPage(
      name: _Paths.detectionResult,
      page: () => const DetectionResultView(),
    ),
  ];
}