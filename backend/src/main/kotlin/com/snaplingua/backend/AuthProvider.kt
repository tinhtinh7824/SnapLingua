package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant
import java.util.UUID

enum class ProviderType {
    PASSWORD,
    GOOGLE,
    FACEBOOK
}

@Document(collection = "auth_providers")
data class AuthProvider(
    @Id
    val providerId: UUID = UUID.randomUUID(),
    val userId: UUID,
    val provider: ProviderType,
    val providerUid: String,
    val emailVerified: Boolean = false,
    val linkedAt: Instant = Instant.now()
)