package com.snaplingua.backend

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant
import java.util.UUID

@Document(collection = "device_tokens")
data class DeviceToken(
    @Id
    val tokenId: UUID = UUID.randomUUID(),
    val userId: UUID,
    val deviceType: String,
    val deviceId: String? = null,
    val fcmToken: String,
    var lastActiveAt: Instant = Instant.now(),
    val createdAt: Instant = Instant.now()
)
