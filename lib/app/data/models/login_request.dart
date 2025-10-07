class LoginRequest {
  final String email;
  final String password;
  final String? deviceType;
  final String? fcmToken;

  LoginRequest({
    required this.email,
    required this.password,
    this.deviceType,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceType': deviceType,
      'fcmToken': fcmToken,
    };
  }
}
