import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/home_controller.dart';
import 'learning_tab_view.dart';
import '../../review/views/review_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  /// Hiển thị hộp thoại chọn ảnh từ camera hoặc thư viện
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF1CB0F6)),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Color(0xFF58CC02)),
                title: const Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.currentIndex) {
          case 0:
            return const LearningTabView();
          case 1:
            return const ReviewView();
          case 2:
            return const Center(child: Text('Cộng đồng'));
          case 3:
            return const Center(child: Text('Hồ sơ'));
          default:
            return const LearningTabView();
        }
      }),
      bottomNavigationBar: Obx(() => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.w,
        color: Colors.white,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: 'Trang chủ',
              index: 0,
              isActive: controller.currentIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.book,
              label: 'Ôn tập',
              index: 1,
              isActive: controller.currentIndex == 1,
            ),
            SizedBox(width: 40.w), // Khoảng cách cho FloatingActionButton
            _buildNavItem(
              icon: Icons.people,
              label: 'Cộng đồng',
              index: 2,
              isActive: controller.currentIndex == 2,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: 'Hồ sơ',
              index: 3,
              isActive: controller.currentIndex == 3,
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceDialog(context),
        backgroundColor: const Color(0xFF1CB0F6),
        elevation: 4,
        child: Icon(Icons.camera_alt, size: 30.sp, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: isActive ? const Color(0xFF1CB0F6) : Colors.grey,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF1CB0F6) : Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
