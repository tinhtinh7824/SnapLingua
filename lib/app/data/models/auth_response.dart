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
    return AuthResponse(
      success: _parseSuccess(json['success']),
      message: json['message'] as String? ?? 'Unknown error',
      user: json['user'] != null
          ? UserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
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
