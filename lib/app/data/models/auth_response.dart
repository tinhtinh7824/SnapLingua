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
      success: json['success'] as bool? ?? false,
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
}
