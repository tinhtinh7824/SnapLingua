import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';

class ShopController extends GetxController {
  // Coins and gems balance
  final coins = 160.obs;
  final gems = 2.obs;

  // Show purchase confirmation dialog
  Future<void> showPurchaseDialog({
    required String itemName,
    required String itemDescription,
    required int price,
    required bool isCoins,
    required String imagePath,
  }) async {
    final result = await Get.dialog<bool>(
      Dialog(
        backgroundColor: const Color(0xFFCCEDFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Item image
              Image.asset(
                imagePath,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.inventory, size: 60);
                },
              ),
              const SizedBox(height: 16),
              // Item name
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Item description
              Text(
                itemDescription,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Price
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isCoins ? 'assets/images/vay.png' : 'assets/images/ngoc.png',
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        isCoins ? Icons.monetization_on : Icons.diamond,
                        size: 30,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$price',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCoins ? const Color(0xFFB8C3D1) : const Color(0xFF0571E6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Confirm message
              const Text(
                'Bạn có muốn mua vật phẩm này không?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonActive,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mua',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );

    if (result == true) {
      purchaseItem(itemName, price, isCoins);
    }
  }

  // Purchase item
  void purchaseItem(String itemName, int price, bool isCoins) {
    if (isCoins) {
      if (coins.value >= price) {
        coins.value -= price;
        AppWidgets.showSuccessDialog(
          title: 'Thành công',
          message: 'Đã mua $itemName',
        );
      } else {
        AppWidgets.showErrorDialog(
          title: 'Không đủ tiền',
          message: 'Bạn cần thêm ${price - coins.value} vảy để mua vật phẩm này',
        );
      }
    } else {
      if (gems.value >= price) {
        gems.value -= price;
        AppWidgets.showSuccessDialog(
          title: 'Thành công',
          message: 'Đã mua $itemName',
        );
      } else {
        AppWidgets.showErrorDialog(
          title: 'Không đủ ngọc',
          message: 'Bạn cần thêm ${price - gems.value} ngọc để mua vật phẩm này',
        );
      }
    }
  }
}
