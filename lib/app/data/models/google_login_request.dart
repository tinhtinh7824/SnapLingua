class GoogleLoginRequest {
  final String idToken;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? deviceType;
  final String? fcmToken;

  GoogleLoginRequest({
    required this.idToken,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.deviceType,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'deviceType': deviceType,
      'fcmToken': fcmToken,
    };
  }
}
