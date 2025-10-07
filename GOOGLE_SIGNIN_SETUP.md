# Hướng dẫn cấu hình Google Sign-In

## 1. Tạo Google Cloud Project

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project có sẵn
3. Bật API "Google Sign-In API" hoặc "Google+ API"

## 2. Cấu hình OAuth 2.0

### Tạo OAuth 2.0 Client IDs

1. Vào **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth client ID**
3. Tạo các Client ID sau:

#### Android OAuth Client ID
- **Application type**: Android
- **Package name**: `com.snaplingua` (lấy từ `android/app/build.gradle.kts`)
- **SHA-1 certificate fingerprint**:
  ```bash
  # Lấy SHA-1 từ debug keystore
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```
  Hoặc:
  ```bash
  cd android
  ./gradlew signingReport
  ```

#### iOS OAuth Client ID
- **Application type**: iOS
- **Bundle ID**: `com.snaplingua` (lấy từ `ios/Runner.xcodeproj/project.pbxproj` hoặc Xcode)

#### Web OAuth Client ID (optional, cho backend verification)
- **Application type**: Web application
- **Authorized JavaScript origins**: `http://localhost:9090`
- **Authorized redirect URIs**: `http://localhost:9090/auth/google-callback`

## 3. Cấu hình Android

### File `android/app/build.gradle.kts`

Đảm bảo có `applicationId`:
```kotlin
android {
    defaultConfig {
        applicationId = "com.snaplingua"
        // ...
    }
}
```

### File `android/app/src/main/AndroidManifest.xml`

Không cần thêm gì đặc biệt, plugin `google_sign_in` tự động xử lý.

## 4. Cấu hình iOS

### File `ios/Runner/Info.plist`

Thêm các key sau:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Thay YOUR_REVERSED_CLIENT_ID bằng iOS Client ID đảo ngược -->
            <!-- Ví dụ: com.googleusercontent.apps.123456789-abcdefg -->
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>

<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
```

**Lưu ý**: Lấy `Reversed Client ID` từ Google Cloud Console, trong chi tiết iOS Client ID.

## 5. Test Google Sign-In

### Trên Android Emulator

1. Đảm bảo emulator có Google Play Services:
   - Sử dụng image có tag **"Google APIs"** hoặc **"Google Play"**
   - AVD Manager > Create Virtual Device > chọn image có Google Play

2. Đăng nhập Google Account trên emulator:
   - Settings > Accounts > Add Google Account

3. Run app:
   ```bash
   flutter run
   ```

### Trên iOS Simulator

1. iOS Simulator tự động có Google SDK
2. Run app:
   ```bash
   flutter run
   ```

### Kiểm tra Backend

Backend đang chạy trên `http://localhost:9090` (hoặc `http://10.0.2.2:9090` từ Android emulator).

Endpoint: `POST /auth/google-login`

Request body:
```json
{
  "idToken": "eyJhbGc...",
  "email": "user@gmail.com",
  "displayName": "User Name",
  "photoUrl": "https://lh3.googleusercontent.com/...",
  "deviceType": "android",
  "fcmToken": null
}
```

Response:
```json
{
  "success": true,
  "message": "Đăng nhập thành công",
  "user": {
    "userId": "...",
    "email": "user@gmail.com",
    "displayName": "User Name",
    "avatarUrl": "https://lh3.googleusercontent.com/...",
    "role": "user",
    "status": "active",
    "createdAt": "2025-10-01T...",
    "updatedAt": "2025-10-01T..."
  }
}
```

## 6. Troubleshooting

### Lỗi: "Sign in failed" hoặc "DEVELOPER_ERROR"

**Nguyên nhân**: SHA-1 không đúng hoặc package name không khớp

**Giải pháp**:
1. Kiểm tra lại SHA-1 certificate fingerprint
2. Đảm bảo package name khớp với `applicationId` trong `build.gradle.kts`
3. Đợi 5-10 phút sau khi tạo OAuth Client ID để Google cập nhật

### Lỗi: "API not enabled"

**Nguyên nhân**: Chưa bật Google Sign-In API

**Giải pháp**:
1. Vào Google Cloud Console
2. **APIs & Services** > **Library**
3. Tìm "Google Sign-In API" hoặc "Google+ API"
4. Click **Enable**

### Lỗi: "Invalid client ID"

**Nguyên nhân**: Client ID không đúng trong `Info.plist` (iOS)

**Giải pháp**:
1. Kiểm tra lại `GIDClientID` trong `Info.plist`
2. Kiểm tra lại `CFBundleURLSchemes` (Reversed Client ID)

### Lỗi backend: "Đăng nhập thất bại"

**Nguyên nhân**: Backend không thể kết nối MongoDB hoặc lỗi logic

**Giải pháp**:
1. Kiểm tra backend logs
2. Kiểm tra kết nối MongoDB Atlas
3. Kiểm tra `application.properties` có đúng connection string

## 7. Security Notes

- **KHÔNG** commit Client ID/Secret vào Git
- **KHÔNG** hardcode Client ID trong Flutter code (sử dụng config file hoặc environment variables)
- Với production app, cần tạo OAuth Client ID cho release keystore SHA-1
- Nên verify `idToken` ở backend để đảm bảo tính bảo mật (hiện tại backend chưa verify, chỉ trust client)

## 8. Production Checklist

- [ ] Tạo OAuth Client ID cho release keystore SHA-1 (Android)
- [ ] Cấu hình OAuth consent screen cho production
- [ ] Thêm logo và privacy policy vào OAuth consent screen
- [ ] Verify `idToken` ở backend bằng Google API
- [ ] Cấu hình domain verification (cho web app)
- [ ] Test trên thiết bị thật
- [ ] Submit app để Google review (nếu cần truy cập sensitive scopes)
