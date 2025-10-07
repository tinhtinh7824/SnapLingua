package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.mongodb.core.index.Indexed
import java.time.Instant
import java.util.UUID

@Document(collection = "users")
data class User(
    @Id
    val userId: String = UUID.randomUUID().toString(), // user_id (UUID)

    @Indexed(unique = true)
    val email: String? = null, // email (UNIQUE, nullable)

    val displayName: String? = null, // display_name

    val avatarUrl: String? = null, // avatar_url

    val role: String = "user", // role: user | admin

    val status: String = "active", // status: active | blocked | deleted

    val createdAt: Instant = Instant.now(), // created_at

    val updatedAt: Instant? = null // updated_at
)