package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant
import java.util.UUID

enum class UserRole {
    USER,
    ADMIN
}

enum class UserStatus {
    ACTIVE,
    BLOCKED,
    DELETED
}

@Document(collection = "users")
data class User(
    @Id
    val userId: UUID = UUID.randomUUID(),
    var email: String?,
    var displayName: String?,
    var avatarUrl: String?,
    var role: UserRole = UserRole.USER,
    var status: UserStatus = UserStatus.ACTIVE,
    val createdAt: Instant = Instant.now(),
    var updatedAt: Instant? = null
)
