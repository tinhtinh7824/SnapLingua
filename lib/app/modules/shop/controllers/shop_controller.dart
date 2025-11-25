import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/auth_service.dart';

class ShopController extends GetxController {
  // Dependencies with safe initialization
  UserService? _userService;
  AuthService? _authService;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    loadUserBalance();
    loadUserInventory();
  }

  // Initialize services safely
  void _initializeServices() {
    try {
      if (Get.isRegistered<UserService>()) {
        _userService = Get.find<UserService>();
      }
    } catch (e) {
      Get.log('UserService not available: $e');
    }

    try {
      if (Get.isRegistered<AuthService>()) {
        _authService = Get.find<AuthService>();
      }
    } catch (e) {
      Get.log('AuthService not available: $e');
    }
  }

  // Coins and gems balance
  final coins = 160.obs;
  final gems = 2.obs;

  // Loading states
  final isLoading = false.obs;
  final isInitialized = false.obs;

  // Inventory data
  final myItems = <ShopItem>[].obs;

  // Load user's current balance
  Future<void> loadUserBalance() async {
    try {
      isLoading.value = true;

      if (_authService?.isLoggedIn == true) {
        final userId = _authService?.currentUserId;
        if (userId != null) {
          // Try to load from UserService if available
          try {
            final profile = await _userService?.getUserProfile();
            if (profile != null) {
              coins.value = profile['coins'] as int? ?? coins.value;
              gems.value = profile['gems'] as int? ?? gems.value;
              Get.log('Loaded balance: ${coins.value} coins, ${gems.value} gems');
            }
          } catch (e) {
            Get.log('Could not load balance from UserService: $e');
          }
        }
      }
    } catch (e) {
      Get.log('Error loading user balance: $e');
    } finally {
      isLoading.value = false;
      isInitialized.value = true;
    }
  }

  // Load user's inventory
  Future<void> loadUserInventory() async {
    try {
      // For now, set some default inventory items
      myItems.value = [
        const ShopItem(
          id: 'streak_freeze',
          name: 'Đá băng',
          description: 'Giữ chuỗi streak khi nghỉ 1 ngày',
          imagePath: 'assets/images/streak/streakbang.png',
          price: 200,
          isCoins: true,
          quantity: 1,
        ),
        const ShopItem(
          id: 'xp_boost',
          name: 'Vảy tăng tốc',
          description: 'Nhận đôi XP trong 15 phút',
          imagePath: 'assets/images/XPx2.png',
          price: 150,
          isCoins: true,
          quantity: 0,
        ),
        const ShopItem(
          id: 'super_boost',
          name: 'Bình cực quang',
          description: 'Tăng 25% XP toàn app trong 24 giờ',
          imagePath: 'assets/images/binhcucquang.png',
          price: 2,
          isCoins: false,
          quantity: 0,
        ),
      ];
    } catch (e) {
      Get.log('Error loading inventory: $e');
    }
  }

  // Check if user can afford an item
  bool canPurchase(int price, bool isCoins) {
    if (isCoins) {
      return coins.value >= price;
    } else {
      return gems.value >= price;
    }
  }

  // Get item from inventory by id
  ShopItem? getInventoryItem(String itemId) {
    try {
      return myItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  // Update item quantity in inventory
  void updateItemQuantity(String itemId, int quantity) {
    final itemIndex = myItems.indexWhere((item) => item.id == itemId);
    if (itemIndex >= 0) {
      final item = myItems[itemIndex];
      myItems[itemIndex] = item.copyWith(quantity: quantity);
    }
  }

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
    if (!canPurchase(price, isCoins)) {
      final needed = isCoins ? price - coins.value : price - gems.value;
      final currency = isCoins ? 'vảy' : 'ngọc';
      AppWidgets.showErrorDialog(
        title: 'Không đủ tiền',
        message: 'Bạn cần thêm $needed $currency để mua vật phẩm này',
      );
      return;
    }

    try {
      // Deduct the cost
      if (isCoins) {
        coins.value -= price;
      } else {
        gems.value -= price;
      }

      // Add item to inventory if it exists
      final existingItem = getInventoryItem(_getItemIdByName(itemName));
      if (existingItem != null) {
        updateItemQuantity(existingItem.id, existingItem.quantity + 1);
      }

      // Show success message
      AppWidgets.showSuccessDialog(
        title: 'Thành công',
        message: 'Đã mua $itemName thành công!',
        onConfirm: () {
          // You could add additional actions here like saving to database
          _savePurchaseToProfile(itemName, price, isCoins);
        },
      );

      Get.log('Successfully purchased: $itemName for $price ${isCoins ? 'coins' : 'gems'}');
    } catch (e) {
      Get.log('Error during purchase: $e');
      AppWidgets.showErrorDialog(
        title: 'Lỗi',
        message: 'Có lỗi xảy ra khi mua hàng. Vui lòng thử lại.',
      );
    }
  }

  // Helper method to get item ID by name (simplified mapping)
  String _getItemIdByName(String itemName) {
    switch (itemName) {
      case 'Đá băng':
        return 'streak_freeze';
      case 'Vảy tăng tốc':
        return 'xp_boost';
      case 'Bình cực quang':
        return 'super_boost';
      default:
        return 'unknown';
    }
  }

  // Save purchase to user profile (placeholder for future implementation)
  Future<void> _savePurchaseToProfile(String itemName, int price, bool isCoins) async {
    try {
      // This would save the purchase to the user's profile in the database
      // For now, just log it
      Get.log('Saving purchase to profile: $itemName');
    } catch (e) {
      Get.log('Error saving purchase: $e');
    }
  }

  // Refresh balance and inventory
  Future<void> refreshShopData() async {
    isLoading.value = true;
    await loadUserBalance();
    await loadUserInventory();
    isLoading.value = false;
  }
}

/// Model for shop items
class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.isCoins,
    this.quantity = 0,
  });

  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int price;
  final bool isCoins;
  final int quantity;

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    int? price,
    bool? isCoins,
    int? quantity,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      isCoins: isCoins ?? this.isCoins,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'ShopItem(id: $id, name: $name, quantity: $quantity, price: $price)';
  }
}