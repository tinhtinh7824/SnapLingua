import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/utils/platform_detector.dart';
import '../models/yolo_detection_response.dart';

/// Gọi YOLO backend (giống logic vocab-snap) qua HTTP multipart.
class YoloApiService {
  // Cổng YOLO Python service. Nếu bạn chạy cổng khác, sửa tại đây.
  static const int _port = 8001;

  // IP máy trong LAN (dùng cho thiết bị thật). Nhớ cập nhật nếu IP thay đổi.
  static const String _localIp = '192.168.1.138';

  // Android emulator: 10.0.2.2 (dùng cả debug/release); iOS simulator: localhost; device thật: IP LAN.
  static String get baseUrl {
    // Ưu tiên rõ ràng: emulator → 10.0.2.2, simulator → localhost, device thật → IP LAN.
    if (Platform.isAndroid) {
      if (PlatformDetector.isAndroidEmulator) {
        return 'http://10.0.2.2:$_port';
      }
      return 'http://$_localIp:$_port';
    }

    // iOS & fallback dùng helper
    return PlatformDetector.getBackendUrl(
      localIp: _localIp,
      port: _port,
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
