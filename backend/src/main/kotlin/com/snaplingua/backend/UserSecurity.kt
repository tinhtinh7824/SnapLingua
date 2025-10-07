package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant

@Document(collection = "user_security")
data class UserSecurity(
    @Id
    val userId: String, // user_id (PK = FK -> users)

    val passwordHash: String? = null, // password_hash (bcrypt/argon2)

    val twoFactorEnabled: Boolean = false, // two_factor_enabled

    val twoFactorMethod: String? = null, // two_factor_method: app | email

    val twoFactorSecret: String? = null, // two_factor_secret: Secret/TOTP (mã hóa)

    val lastPasswordChange: Instant? = null // last_password_change
)
