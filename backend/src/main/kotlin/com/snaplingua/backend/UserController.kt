package com.snaplingua.backend

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.time.Instant
import java.util.UUID

data class CreateUserRequest(
    val email: String,
    val displayName: String?,
    val avatarUrl: String?
)

@RestController
@RequestMapping("/users")
class UserController(private val userRepository: UserRepository) {

    @GetMapping
    fun getAllUsers(): List<User> = userRepository.findAll()

    @PostMapping
    fun createUser(@RequestBody request: CreateUserRequest): User {
        val user = User(
            email = request.email,
            displayName = request.displayName,
            avatarUrl = request.avatarUrl,
            role = UserRole.USER,
            status = UserStatus.ACTIVE,
            createdAt = Instant.now()
        )
        return userRepository.save(user)
    }

    @GetMapping("/{id}")
    fun getUserById(@PathVariable id: String): ResponseEntity<User> {
        val userId = runCatching { UUID.fromString(id) }.getOrNull()
            ?: return ResponseEntity.badRequest().build()

        return userRepository.findById(userId)
            .map { ResponseEntity.ok(it) }
            .orElse(ResponseEntity.notFound().build())
    }

    @PutMapping("/{id}")
    fun updateUser(@PathVariable id: String, @RequestBody request: CreateUserRequest): ResponseEntity<User> {
        val userId = runCatching { UUID.fromString(id) }.getOrNull()
            ?: return ResponseEntity.badRequest().build()

        return userRepository.findById(userId)
            .map { existingUser ->
                val updatedUser = existingUser.copy(
                    email = request.email,
                    displayName = request.displayName,
                    avatarUrl = request.avatarUrl,
                    updatedAt = Instant.now()
                )
                ResponseEntity.ok(userRepository.save(updatedUser))
            }
            .orElse(ResponseEntity.notFound().build())
    }

    @DeleteMapping("/{id}")
    fun deleteUser(@PathVariable id: String): ResponseEntity<Void> {
        val userId = runCatching { UUID.fromString(id) }.getOrNull()
            ?: return ResponseEntity.badRequest().build()

        return if (userRepository.existsById(userId)) {
            userRepository.deleteById(userId)
            ResponseEntity.noContent().build()
        } else {
            ResponseEntity.notFound().build()
        }
    }
}
