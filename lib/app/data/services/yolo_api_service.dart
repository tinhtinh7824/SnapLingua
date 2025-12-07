import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/platform_detector.dart';
import '../models/yolo_detection_response.dart';

/// Gọi YOLO backend (giống logic vocab-snap) qua HTTP multipart.
class YoloApiService {
  // Cho phép override host/port qua --dart-define hoặc biến môi trường
  static const String _envHostKey = 'YOLO_HOST';
  static const String _envPortKey = 'YOLO_PORT';
  static const String _envForceEmuKey = 'YOLO_FORCE_EMULATOR_HOST';
  static const String _envUseLanKey = 'YOLO_USE_LAN';

  // Cổng YOLO Python service. Nếu bạn chạy cổng khác, sửa tại đây.
  static const int _port = 8001;

  // IP máy trong LAN (dùng cho thiết bị thật). Nhớ cập nhật nếu IP thay đổi.
  static const String _localIp = '192.168.1.138';

  // Android emulator: 10.0.2.2 (dùng cả debug/release); iOS simulator: localhost; device thật: IP LAN.
  static String get baseUrl {
    // Ưu tiên rõ ràng: override → emulator → simulator → device thật.
    final overrideHost =
        const String.fromEnvironment(_envHostKey, defaultValue: '')
            .trim()
            .isNotEmpty
            ? const String.fromEnvironment(_envHostKey).trim()
            : (Platform.environment[_envHostKey] ?? '').trim();
    final overridePortString =
        const String.fromEnvironment(_envPortKey, defaultValue: '')
            .trim()
            .isNotEmpty
            ? const String.fromEnvironment(_envPortKey).trim()
            : (Platform.environment[_envPortKey] ?? '').trim();
    final overridePort = int.tryParse(overridePortString);
    final port = overridePort ?? _port;
    final forceEmulatorHost =
        (const String.fromEnvironment(_envForceEmuKey, defaultValue: 'false')
                    .toLowerCase() ==
                'true') ||
            ((Platform.environment[_envForceEmuKey] ?? '').toLowerCase() ==
                'true');
    final useLanHost =
        (const String.fromEnvironment(_envUseLanKey, defaultValue: 'false')
                    .toLowerCase() ==
                'true') ||
            ((Platform.environment[_envUseLanKey] ?? '').toLowerCase() ==
                'true');

    if (overrideHost.isNotEmpty) {
      return 'http://$overrideHost:$port';
    }

    // Ưu tiên emulator host 10.0.2.2 để tránh lỗi refused do IP LAN không route được.
    if (Platform.isAndroid) {
      if (useLanHost) {
        return 'http://$_localIp:$port';
      }
      if (forceEmulatorHost ||
          PlatformDetector.isAndroidEmulator ||
          !PlatformDetector.isRealDevice ||
          kDebugMode) {
        return 'http://10.0.2.2:$port';
      }
      return 'http://$_localIp:$port';
    }

    // iOS & fallback dùng helper
    return PlatformDetector.getBackendUrl(
      localIp: _localIp,
      port: port,
      useHttps: false,
    );
  }

  Future<YoloDetectionResponse> detect(File imageFile) async {
    final uri = Uri.parse('$baseUrl/predict');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception('YOLO API trả về mã ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final detections = (data['detections'] as List<dynamic>? ?? [])
        .map((e) => e is Map<String, dynamic> ? e['class']?.toString() ?? '' : e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList(growable: false);
    final processedUrl = data['processed_image_url'] as String?;

    return YoloDetectionResponse(
      labels: detections,
      processedImageUrl: processedUrl,
    );
  }
}
