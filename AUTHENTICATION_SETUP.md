# Hướng dẫn Setup Đăng ký/Đăng nhập SnapLingua

## Tổng quan

Hệ thống đăng ký/đăng nhập đã được thiết lập với:
- **Backend**: Spring Boot + Kotlin + MongoDB
- **Frontend**: Flutter
- **Database**: MongoDB Atlas

## Cấu trúc Database

### 1. Table `users`
- `user_id` (UUID, PK): Mã người dùng
- `email` (VARCHAR, UNIQUE): Email
- `display_name` (VARCHAR): Tên hiển thị
- `avatar_url` (TEXT): URL ảnh đại diện
- `role` (VARCHAR): Vai trò (user | admin)
- `status` (VARCHAR): Trạng thái (active | blocked | deleted)
- `created_at` (TIMESTAMPTZ): Ngày tạo
- `updated_at` (TIMESTAMPTZ): Ngày cập nhật

### 2. Table `auth_providers`
- `provider_id` (UUID, PK): Mã nhà cung cấp
- `user_id` (UUID, FK): Liên kết với users
- `provider` (VARCHAR): Loại (password | google | facebook)
- `provider_uid` (VARCHAR): ID từ nhà cung cấp
- `email_verified` (BOOLEAN): Email đã xác minh?
- `linked_at` (TIMESTAMPTZ): Ngày liên kết

### 3. Table `user_security`
- `user_id` (UUID, PK=FK): Liên kết với users
- `password_hash` (TEXT): Hash mật khẩu (bcrypt)
- `two_factor_enabled` (BOOLEAN): Bật 2FA?
- `two_factor_method` (VARCHAR): Phương thức 2FA (app | email)
- `two_factor_secret` (TEXT): Secret TOTP
- `last_password_change` (TIMESTAMPTZ): Lần đổi mật khẩu gần nhất

### 4. Table `device_tokens`
- `token_id` (UUID, PK): Mã token
- `user_id` (UUID, FK): Liên kết với users
- `device_type` (VARCHAR): Loại thiết bị (android | ios)
- `device_id` (VARCHAR): Định danh thiết bị
- `fcm_token` (TEXT): Token FCM/APNS
- `last_active_at` (TIMESTAMPTZ): Hoạt động gần nhất
- `created_at` (TIMESTAMPTZ): Ngày tạo

## Backend Setup

### Files đã tạo:

1. **Models**:
   - `User.kt` - Model người dùng
   - `AuthProvider.kt` - Model nhà cung cấp xác thực
   - `UserSecurity.kt` - Model bảo mật
   - `DeviceToken.kt` - Model token thiết bị

2. **Repositories**:
   - `UserRepository.kt`
   - `AuthProviderRepository.kt`
   - `UserSecurityRepository.kt`
   - `DeviceTokenRepository.kt`

3. **Services**:
   - `AuthService.kt` - Xử lý logic đăng ký/đăng nhập

4. **Controllers**:
   - `AuthController.kt` - API endpoints

5. **DTOs**:
   - `AuthDto.kt` - Request/Response models

### API Endpoints:

- `POST /auth/register` - Đăng ký tài khoản mới
- `POST /auth/login` - Đăng nhập
- `GET /auth/health` - Kiểm tra trạng thái service

### Chạy Backend:

```bash
cd backend
./mvnw spring-boot:run
```

Backend sẽ chạy tại: `http://localhost:9090`

## Flutter Setup

### Files đã tạo:

1. **Models** (`lib/app/data/models/`):
   - `user_dto.dart` - DTO người dùng
   - `auth_response.dart` - Response từ API
   - `register_request.dart` - Request đăng ký
   - `login_request.dart` - Request đăng nhập

2. **Services** (`lib/app/data/services/`):
   - `auth_api_service.dart` - Service gọi API

3. **Controllers**:
   - `register_controller.dart` - Đã cập nhật với API integration

### Cài đặt dependencies:

```bash
flutter pub get
```

### Chạy Flutter:

```bash
flutter run
```

## MongoDB Atlas

Database đã được cấu hình tại:
- Cluster: `snaplingua-cluster`
- Database: `snaplingua`
- Connection String đã được cấu hình trong `application.yml`

## Flow Đăng ký

1. User nhập email, password, display_name (optional)
2. Flutter gửi request đến `/auth/register`
3. Backend:
   - Kiểm tra email đã tồn tại chưa
   - Tạo record trong `users`
   - Hash password và lưu vào `user_security`
   - Tạo record trong `auth_providers` với provider="password"
   - Trả về thông tin user
4. Flutter nhận response và chuyển sang màn hình survey

## Flow Đăng nhập

1. User nhập email, password
2. Flutter gửi request đến `/auth/login` (có thể kèm deviceType và fcmToken)
3. Backend:
   - Tìm user theo email
   - Kiểm tra status (active/blocked/deleted)
   - Verify password từ `user_security`
   - Lưu device token nếu có
   - Trả về thông tin user
4. Flutter nhận response và navigate đến màn hình chính

## Testing

### Test Backend API bằng curl:

**Đăng ký:**
```bash
curl -X POST http://localhost:9090/auth/register \\
  -H "Content-Type: application/json" \\
  -d '{
    "email": "test@example.com",
    "password": "123456",
    "displayName": "Test User"
  }'
```

**Đăng nhập:**
```bash
curl -X POST http://localhost:9090/auth/login \\
  -H "Content-Type: application/json" \\
  -d '{
    "email": "test@example.com",
    "password": "123456"
  }'
```

**Health check:**
```bash
curl http://localhost:9090/auth/health
```

## Kiểm tra Database trên MongoDB Atlas

1. Đăng nhập vào MongoDB Atlas
2. Browse Collections
3. Chọn database `snaplingua`
4. Xem các collections:
   - `users` - Thông tin người dùng
   - `auth_providers` - Nhà cung cấp xác thực
   - `user_security` - Thông tin bảo mật
   - `device_tokens` - Token thiết bị

## Lưu ý

1. **Port Backend**: 9090 (đã cấu hình trong `application.yml`)
2. **Base URL Flutter**: `http://localhost:9090` (trong `auth_api_service.dart`)
3. **Password Hashing**: BCrypt (đã implement trong `AuthService`)
4. **UUID**: Tự động generate cho tất cả primary keys

## Các bước tiếp theo (Optional)

1. Implement Google Sign-In
2. Implement Facebook Sign-In
3. Thêm email verification
4. Thêm forgot password functionality
5. Implement 2FA (Two-Factor Authentication)
6. Thêm JWT tokens cho authentication
7. Implement refresh tokens

## Troubleshooting

### Backend không kết nối được MongoDB:
- Kiểm tra connection string trong `application.yml`
- Kiểm tra IP whitelist trên MongoDB Atlas
- Kiểm tra network/firewall

### Flutter không gọi được API:
- Đảm bảo backend đang chạy
- Kiểm tra base URL trong `auth_api_service.dart`
- Thêm `http` package vào `pubspec.yaml` (đã thêm)
- Check console logs để xem error message

### Database không có data sau khi register:
- Kiểm tra logs của backend
- Verify MongoDB connection
- Check collections trong MongoDB Atlas web UI
