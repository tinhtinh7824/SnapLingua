package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.mongodb.core.index.Indexed
import java.time.Instant
import java.util.UUID

@Document(collection = "device_tokens")
data class DeviceToken(
    @Id
    val tokenId: String = UUID.randomUUID().toString(), // token_id (PK)

    @Indexed
    val userId: String, // user_id (FK -> users)

    val deviceType: String, // device_type: android | ios

    val deviceId: String? = null, // device_id: Định danh thiết bị

    val fcmToken: String, // fcm_token: Token FCM/APNS

    val lastActiveAt: Instant? = null, // last_active_at

    val createdAt: Instant = Instant.now() // created_at
)
