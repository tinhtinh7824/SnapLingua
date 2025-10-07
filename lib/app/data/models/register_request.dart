class RegisterRequest {
  final String email;
  final String password;
  final String? displayName;

  RegisterRequest({
    required this.email,
    required this.password,
    this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'displayName': displayName,
    };
  }
}
