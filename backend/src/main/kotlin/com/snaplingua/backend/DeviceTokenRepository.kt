package com.snaplingua.backend

import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface DeviceTokenRepository : MongoRepository<DeviceToken, UUID> {
    fun findAllByUserId(userId: UUID): List<DeviceToken>
    fun findByUserIdAndDeviceType(userId: UUID, deviceType: String): List<DeviceToken>
    fun deleteByUserId(userId: UUID)
}
