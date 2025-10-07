/// DTO cho API backend - khác với User model local (Realm)
class UserDto {
  final String userId;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserDto({
    required this.userId,
    this.email,
    this.displayName,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
