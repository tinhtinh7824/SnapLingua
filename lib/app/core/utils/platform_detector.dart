import 'dart:io';
import 'package:flutter/foundation.dart';

/// Utility class để detect platform và environment
class PlatformDetector {
  /// Kiểm tra xem có phải đang chạy trên Android emulator không
  static bool get isAndroidEmulator {
    if (!Platform.isAndroid) return false;

    // Android emulator thường có các đặc điểm:
    // - Model name chứa "sdk", "emulator", "android sdk"
    // Nhưng trong Flutter, ta không thể trực tiếp lấy được device info mà không dùng plugin
    // Nên ta sẽ dùng cách đơn giản: assume emulator nếu debug mode
    return kDebugMode;
  }

  /// Kiểm tra xem có phải đang chạy trên iOS simulator không
  static bool get isIOSSimulator {
    if (!Platform.isIOS) return false;

    // iOS simulator chạy trên architecture x86_64 hoặc arm64 (M1)
    // Nhưng Flutter không expose info này dễ dàng
    // Nên ta cũng dùng debug mode để detect
    return kDebugMode;
  }

  /// Kiểm tra có phải emulator/simulator không
  static bool get isEmulator {
    return isAndroidEmulator || isIOSSimulator;
  }

  /// Kiểm tra có phải real device không
  static bool get isRealDevice {
    return !isEmulator;
  }

  /// Lấy base URL phù hợp cho backend
  ///
  /// - Android Emulator: 10.0.2.2 (địa chỉ đặc biệt trỏ đến localhost của host machine)
  /// - iOS Simulator: localhost
  /// - Real Device: IP của máy trong mạng LAN
  static String getBackendUrl({
    required String localIp,
    required int port,
    bool useHttps = false,
  }) {
    final protocol = useHttps ? 'https' : 'http';

    if (kIsWeb) {
      // Web app: dùng localhost
      return '$protocol://localhost:$port';
    }

    if (Platform.isAndroid) {
      if (kReleaseMode) {
        // Production: dùng IP thật
        return '$protocol://$localIp:$port';
      } else {
        // Debug/Profile: dùng 10.0.2.2 cho emulator
        return '$protocol://10.0.2.2:$port';
      }
    }

    if (Platform.isIOS) {
      if (kReleaseMode) {
        // Production: dùng IP thật
        return '$protocol://$localIp:$port';
      } else {
        // Debug/Profile: dùng localhost cho simulator
        return '$protocol://localhost:$port';
      }
    }

    // Fallback: dùng IP thật
    return '$protocol://$localIp:$port';
  }
}
