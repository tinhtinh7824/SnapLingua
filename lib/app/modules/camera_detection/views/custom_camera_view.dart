import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomCameraView extends StatefulWidget {
  const CustomCameraView({super.key});

  @override
  State<CustomCameraView> createState() => _CustomCameraViewState();
}

class _CustomCameraViewState extends State<CustomCameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        Get.snackbar('Lỗi', 'Không tìm thấy camera');
        Get.back();
        return;
      }

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể khởi tạo camera: $e');
      Get.back();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final XFile picture = await _controller!.takePicture();

      // Return the image path back
      Get.back(result: picture.path);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chụp ảnh: $e');
    } finally {
      setState(() {
        _isTakingPicture = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1CB0F6),
          ),
        ),
      );
    }

    // Calculate square preview size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview (full screen)
          Center(
            child: CameraPreview(_controller!),
          ),

          // Black overlay with square cutout
          CustomPaint(
            size: Size(size.width, size.height),
            painter: SquareOverlayPainter(),
          ),

          // Top bar with close button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  Text(
                    'Chụp ảnh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 44.w), // Spacer for centering title
                ],
              ),
            ),
          ),

          // Bottom bar with capture button
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isTakingPicture ? Colors.grey : Colors.white,
                    border: Border.all(
                      color: const Color(0xFF1CB0F6),
                      width: 4,
                    ),
                  ),
                  child: _isTakingPicture
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1CB0F6),
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 32.sp,
                          color: const Color(0xFF1CB0F6),
                        ),
                ),
              ),
            ),
          ),

          // Guide text
          Positioned(
            bottom: 130.h,
            left: 0,
            right: 0,
            child: Text(
              'Đặt đối tượng vào khung vuông',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw square overlay
class SquareOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Calculate square size (90% of screen width)
    final squareSize = size.width * 0.9;
    final left = (size.width - squareSize) / 2;
    final top = (size.height - squareSize) / 2;

    // Draw overlay with cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, squareSize, squareSize),
          const Radius.circular(16),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw square border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, squareSize, squareSize),
        const Radius.circular(16),
      ),
      borderPaint,
    );

    // Draw corner markers
    final cornerPaint = Paint()
      ..color = const Color(0xFF1CB0F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + squareSize - cornerLength, top),
      Offset(left + squareSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + squareSize, top),
      Offset(left + squareSize, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + squareSize - cornerLength),
      Offset(left, top + squareSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + squareSize),
      Offset(left + cornerLength, top + squareSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + squareSize - cornerLength, top + squareSize),
      Offset(left + squareSize, top + squareSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + squareSize, top + squareSize - cornerLength),
      Offset(left + squareSize, top + squareSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
