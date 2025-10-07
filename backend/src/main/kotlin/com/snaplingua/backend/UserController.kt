package com.snaplingua.backend

import org.springframework.web.bind.annotation.*
import org.springframework.http.ResponseEntity
import java.time.Instant

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
            role = "user",
            status = "active",
            createdAt = Instant.now()
        )
        return userRepository.save(user)
    }

    @GetMapping("/{id}")
    fun getUserById(@PathVariable id: String): ResponseEntity<User> {
        return userRepository.findById(id)
            .map { ResponseEntity.ok(it) }
            .orElse(ResponseEntity.notFound().build())
    }

    @PutMapping("/{id}")
    fun updateUser(@PathVariable id: String, @RequestBody request: CreateUserRequest): ResponseEntity<User> {
        return userRepository.findById(id)
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
        return if (userRepository.existsById(id)) {
            userRepository.deleteById(id)
            ResponseEntity.noContent().build()
        } else {
            ResponseEntity.notFound().build()
        }
    }
}