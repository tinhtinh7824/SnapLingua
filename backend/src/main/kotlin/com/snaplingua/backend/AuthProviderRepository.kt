package com.snaplingua.backend

import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface AuthProviderRepository : MongoRepository<AuthProvider, String> {
    fun findByUserIdAndProvider(userId: String, provider: String): Optional<AuthProvider>
    fun findAllByUserId(userId: String): List<AuthProvider>
    fun existsByProviderAndProviderUid(provider: String, providerUid: String): Boolean
    fun findByProviderAndProviderUid(provider: String, providerUid: String): Optional<AuthProvider>
}
