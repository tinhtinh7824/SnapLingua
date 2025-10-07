import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/google_login_request.dart';
import '../../core/utils/platform_detector.dart';

class AuthApiService {
  // Backend configuration
  static const int _port = 9090;

  // IP máy tính của bạn trong mạng LAN (chạy ifconfig để xem)
  // Cập nhật IP này nếu IP máy thay đổi
  static const String _localIp = '192.168.0.102';

  /// Tự động detect và chọn URL phù hợp:
  /// - Android Emulator: http://10.0.2.2:9090
  /// - iOS Simulator: http://localhost:9090
  /// - Real Device: http://192.168.0.102:9090
  static String get baseUrl {
    return PlatformDetector.getBackendUrl(
      localIp: _localIp,
      port: _port,
      useHttps: false,
    );
  }

  /// Đăng ký tài khoản mới
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: 'Lỗi server: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Register error: $e'); // Debug log
      return AuthResponse(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  /// Đăng nhập
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: 'Lỗi server: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
      return AuthResponse(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  /// Đăng nhập bằng Google
  Future<AuthResponse> loginWithGoogle(GoogleLoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google-login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: 'Lỗi server: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Google login error: $e'); // Debug log
      return AuthResponse(
        success: false,
        message: 'Lỗi kết nối: ${e.toString()}',
      );
    }
  }

  /// Kiểm tra trạng thái backend
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/health'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Debug: In ra URL đang được sử dụng
  static void debugPrintUrl() {
    print('🔗 Backend URL: $baseUrl');
  }
}
