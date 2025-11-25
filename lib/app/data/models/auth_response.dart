import 'user_dto.dart';

class AuthResponse {
  final bool success;
  final String message;
  final UserDto? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final resolvedUser =
        userJson is Map<String, dynamic> ? UserDto.fromJson(userJson) : null;

    // Backend có thể trả về "success", "status", "ok" hoặc chỉ trả user/token.
    final rawSuccess = json['success'] ?? json['status'] ?? json['ok'];
    final parsedSuccess = _parseSuccess(rawSuccess);
    final success = parsedSuccess || resolvedUser != null;

    final message = json['message'] as String? ??
        json['error'] as String? ??
        'Unknown error';

    return AuthResponse(
      success: success,
      message: message,
      user: resolvedUser,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }

  static bool _parseSuccess(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == 'ok' || lower == 'success') return true;
      if (lower == 'false' || lower == 'error') return false;
    }
    return false;
  }
}
