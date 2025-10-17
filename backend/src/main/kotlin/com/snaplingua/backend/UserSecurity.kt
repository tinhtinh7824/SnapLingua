package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant
import java.util.UUID

@Document(collection = "user_security")
data class UserSecurity(
    @Id
    val userId: UUID,
    var passwordHash: String?,
    var twoFactorEnabled: Boolean = false,
    var twoFactorMethod: String? = null,
    var twoFactorSecret: String? = null,
    var lastPasswordChange: Instant = Instant.now()
)
