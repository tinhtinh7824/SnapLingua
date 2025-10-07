package com.snaplingua.backend

import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository

@Repository
interface DeviceTokenRepository : MongoRepository<DeviceToken, String> {
    fun findAllByUserId(userId: String): List<DeviceToken>
    fun findByUserIdAndDeviceType(userId: String, deviceType: String): List<DeviceToken>
    fun deleteByUserId(userId: String)
}
