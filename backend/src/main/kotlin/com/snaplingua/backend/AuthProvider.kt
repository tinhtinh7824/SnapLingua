package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.mongodb.core.index.Indexed
import java.time.Instant
import java.util.UUID

@Document(collection = "auth_providers")
data class AuthProvider(
    @Id
    val providerId: String = UUID.randomUUID().toString(), // provider_id (PK)

    @Indexed
    val userId: String, // user_id (FK -> users)

    val provider: String, // provider: password | google | facebook

    val providerUid: String, // provider_uid: ID từ nhà cung cấp

    val emailVerified: Boolean = false, // email_verified

    val linkedAt: Instant = Instant.now() // linked_at
)
