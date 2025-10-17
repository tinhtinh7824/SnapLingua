package com.snaplingua.backend

import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant

data class RegisterRequest @JsonCreator constructor(
    @JsonProperty("email") val email: String,
    @JsonProperty("password") val password: String,
    @JsonProperty("displayName") val displayName: String? = null
)

data class LoginRequest @JsonCreator constructor(
    @JsonProperty("email") val email: String,
    @JsonProperty("password") val password: String,
    @JsonProperty("deviceType") val deviceType: String? = null, // android | ios
    @JsonProperty("fcmToken") val fcmToken: String? = null
)

data class GoogleLoginRequest @JsonCreator constructor(
    @JsonProperty("idToken") val idToken: String,
    @JsonProperty("email") val email: String,
    @JsonProperty("displayName") val displayName: String?,
    @JsonProperty("photoUrl") val photoUrl: String?,
    @JsonProperty("deviceType") val deviceType: String? = null,
    @JsonProperty("fcmToken") val fcmToken: String? = null
)

data class AuthResponse(
    val success: Boolean,
    val message: String,
    val user: UserDto? = null
)

data class UserDto(
    val userId: String,
    val email: String?,
    val displayName: String?,
    val avatarUrl: String?,
    val role: String,
    val status: String,
    val createdAt: Instant,
    val updatedAt: Instant?
)

fun User.toDto(): UserDto {
    return UserDto(
        userId = this.userId.toString(),
        email = this.email,
        displayName = this.displayName,
        avatarUrl = this.avatarUrl,
        role = this.role.name.lowercase(),
        status = this.status.name.lowercase(),
        createdAt = this.createdAt,
        updatedAt = this.updatedAt
    )
}
