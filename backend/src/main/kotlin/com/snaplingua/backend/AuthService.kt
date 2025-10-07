package com.snaplingua.backend

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Service
import java.time.Instant

@Service
class AuthService(
    private val userRepository: UserRepository,
    private val authProviderRepository: AuthProviderRepository,
    private val userSecurityRepository: UserSecurityRepository,
    private val deviceTokenRepository: DeviceTokenRepository
) {

    private val passwordEncoder = BCryptPasswordEncoder()

    fun register(request: RegisterRequest): AuthResponse {
        try {
            // Kiểm tra email đã tồn tại chưa
            if (userRepository.existsByEmail(request.email)) {
                return AuthResponse(
                    success = false,
                    message = "Email đã được sử dụng"
                )
            }

            // Tạo user mới
            val newUser = User(
                email = request.email,
                displayName = request.displayName,
                role = "user",
                status = "active",
                createdAt = Instant.now()
            )

            val savedUser = userRepository.save(newUser)

            // Mã hóa mật khẩu và lưu vào UserSecurity
            val hashedPassword = passwordEncoder.encode(request.password)
            val userSecurity = UserSecurity(
                userId = savedUser.userId,
                passwordHash = hashedPassword,
                twoFactorEnabled = false,
                lastPasswordChange = Instant.now()
            )
            userSecurityRepository.save(userSecurity)

            // Tạo AuthProvider cho password
            val authProvider = AuthProvider(
                userId = savedUser.userId,
                provider = "password",
                providerUid = request.email,
                emailVerified = false,
                linkedAt = Instant.now()
            )
            authProviderRepository.save(authProvider)

            return AuthResponse(
                success = true,
                message = "Đăng ký thành công",
                user = savedUser.toDto()
            )

        } catch (e: Exception) {
            return AuthResponse(
                success = false,
                message = "Đăng ký thất bại: ${e.message}"
            )
        }
    }

    fun login(request: LoginRequest): AuthResponse {
        try {
            // Tìm user theo email
            val userOptional = userRepository.findByEmail(request.email)

            if (!userOptional.isPresent) {
                return AuthResponse(
                    success = false,
                    message = "Email hoặc mật khẩu không đúng"
                )
            }

            val user = userOptional.get()

            // Kiểm tra trạng thái tài khoản
            if (user.status == "blocked") {
                return AuthResponse(
                    success = false,
                    message = "Tài khoản đã bị khóa"
                )
            }

            if (user.status == "deleted") {
                return AuthResponse(
                    success = false,
                    message = "Tài khoản không tồn tại"
                )
            }

            // Lấy thông tin bảo mật
            val securityOptional = userSecurityRepository.findByUserId(user.userId)
            if (!securityOptional.isPresent || securityOptional.get().passwordHash == null) {
                return AuthResponse(
                    success = false,
                    message = "Email hoặc mật khẩu không đúng"
                )
            }

            val userSecurity = securityOptional.get()

            // Kiểm tra mật khẩu
            if (!passwordEncoder.matches(request.password, userSecurity.passwordHash)) {
                return AuthResponse(
                    success = false,
                    message = "Email hoặc mật khẩu không đúng"
                )
            }

            // Cập nhật thời gian cập nhật
            val updatedUser = user.copy(updatedAt = Instant.now())
            userRepository.save(updatedUser)

            // Lưu device token nếu có
            if (request.deviceType != null && request.fcmToken != null) {
                val deviceToken = DeviceToken(
                    userId = user.userId,
                    deviceType = request.deviceType,
                    fcmToken = request.fcmToken,
                    lastActiveAt = Instant.now(),
                    createdAt = Instant.now()
                )
                deviceTokenRepository.save(deviceToken)
            }

            return AuthResponse(
                success = true,
                message = "Đăng nhập thành công",
                user = updatedUser.toDto()
            )

        } catch (e: Exception) {
            return AuthResponse(
                success = false,
                message = "Đăng nhập thất bại: ${e.message}"
            )
        }
    }

    fun loginWithGoogle(request: GoogleLoginRequest): AuthResponse {
        try {
            // Tìm hoặc tạo user từ Google
            val userOptional = userRepository.findByEmail(request.email)

            val user = if (userOptional.isPresent) {
                // User đã tồn tại
                val existingUser = userOptional.get()

                // Kiểm tra trạng thái
                if (existingUser.status == "blocked") {
                    return AuthResponse(
                        success = false,
                        message = "Tài khoản đã bị khóa"
                    )
                }

                if (existingUser.status == "deleted") {
                    return AuthResponse(
                        success = false,
                        message = "Tài khoản không tồn tại"
                    )
                }

                // Cập nhật thông tin từ Google
                val updatedUser = existingUser.copy(
                    displayName = request.displayName ?: existingUser.displayName,
                    avatarUrl = request.photoUrl ?: existingUser.avatarUrl,
                    updatedAt = Instant.now()
                )
                userRepository.save(updatedUser)
            } else {
                // Tạo user mới
                val newUser = User(
                    email = request.email,
                    displayName = request.displayName,
                    avatarUrl = request.photoUrl,
                    role = "user",
                    status = "active",
                    createdAt = Instant.now()
                )
                userRepository.save(newUser)
            }

            // Tìm hoặc tạo auth provider
            val providerOptional = authProviderRepository.findByUserIdAndProvider(user.userId, "google")
            if (!providerOptional.isPresent) {
                val authProvider = AuthProvider(
                    userId = user.userId,
                    provider = "google",
                    providerUid = request.email, // hoặc có thể dùng Google UID
                    emailVerified = true, // Google đã verify
                    linkedAt = Instant.now()
                )
                authProviderRepository.save(authProvider)
            }

            // Lưu device token nếu có
            if (request.deviceType != null && request.fcmToken != null) {
                val deviceToken = DeviceToken(
                    userId = user.userId,
                    deviceType = request.deviceType,
                    fcmToken = request.fcmToken,
                    lastActiveAt = Instant.now(),
                    createdAt = Instant.now()
                )
                deviceTokenRepository.save(deviceToken)
            }

            return AuthResponse(
                success = true,
                message = "Đăng nhập thành công",
                user = user.toDto()
            )

        } catch (e: Exception) {
            return AuthResponse(
                success = false,
                message = "Đăng nhập thất bại: ${e.message}"
            )
        }
    }
}