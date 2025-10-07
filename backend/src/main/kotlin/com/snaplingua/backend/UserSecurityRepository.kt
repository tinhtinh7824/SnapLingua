package com.snaplingua.backend

import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface UserSecurityRepository : MongoRepository<UserSecurity, String> {
    fun findByUserId(userId: String): Optional<UserSecurity>
}
