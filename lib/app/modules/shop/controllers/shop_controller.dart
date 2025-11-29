import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/firestore_service.purchase_models.dart';

class ShopController extends GetxController {
  // Dependencies with safe initialization
  UserService? _userService;
  AuthService? _authService;
  FirestoreService? _firestoreService;

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

    try {
      if (Get.isRegistered<FirestoreService>()) {
        _firestoreService = Get.find<FirestoreService>();
      }
    } catch (e) {
      Get.log('FirestoreService not available: $e');
    }
  }

  // Coins and gems balance
  final coins = 0.obs;
  final gems = 0.obs;

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
              coins.value =
                  profile['scalesBalance'] as int? ?? coins.value;
              gems.value = profile['gemsBalance'] as int? ?? gems.value;
              Get.log('Loaded balance: ${coins.value} coins, ${gems.value} gems');
            }
          } catch (e) {
            Get.log('Could not load balance from UserService: $e');
          }

          // Fallback/refresh directly from Firestore
          try {
            final userDoc = await _firestoreService?.getUserById(userId);
            if (userDoc != null) {
              coins.value = userDoc.scalesBalance;
              gems.value = userDoc.gemsBalance;
              Get.log('Synced balance from Firestore: ${coins.value} vảy, ${gems.value} ngọc');
            }
          } catch (e) {
            Get.log('Could not load balance from Firestore: $e');
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
      final baseItems = _defaultItems();
      if (_authService?.isLoggedIn == true && _firestoreService != null) {
        final userId = _authService!.currentUserId;
        // Ensure inventory docs exist so quantities persist even when 0.
        await _firestoreService!.ensureUserInventoryInitialized(
          userId: userId,
          itemIds: baseItems.map((e) => e.id).toList(),
        );
        final inventory = await _firestoreService!.getUserInventory(
          userId: userId,
        );
        final quantities = {
          for (final item in inventory) item.itemId: item.quantity,
        };
        myItems.value = baseItems
            .map(
              (item) => item.copyWith(
                quantity: quantities[item.id] ?? 0,
              ),
            )
            .toList();
      } else {
        myItems.value = baseItems;
      }
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
      await purchaseItem(itemName, price, isCoins);
    }
  }

  // Purchase item
  Future<void> purchaseItem(String itemName, int price, bool isCoins) async {
    if (_authService?.isLoggedIn != true) {
      AppWidgets.showErrorDialog(
        title: 'Cần đăng nhập',
        message: 'Vui lòng đăng nhập để mua vật phẩm.',
      );
      return;
    }

    final userId = _authService?.currentUserId;
    final itemId = _getItemIdByName(itemName);
    if (itemId == 'unknown' || userId == null) {
      AppWidgets.showErrorDialog(
        title: 'Không thể mua',
        message: 'Vật phẩm không hợp lệ hoặc thiếu thông tin người dùng.',
      );
      return;
    }

    try {
      final result = await _firestoreService?.purchaseShopItem(
        userId: userId,
        itemId: itemId,
        price: price,
        isCoins: isCoins,
      );

      if (result != null) {
        coins.value = result.newScalesBalance;
        gems.value = result.newGemsBalance;

        // Add item to inventory if it exists
        final existingItem = getInventoryItem(itemId);
        if (existingItem != null) {
          updateItemQuantity(existingItem.id, result.newQuantity);
        }
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
    } on InsufficientFundsException catch (e) {
      final needed = isCoins ? price - coins.value : price - gems.value;
      AppWidgets.showErrorDialog(
        title: 'Không đủ tiền',
        message:
            'Bạn cần thêm ${needed > 0 ? needed : e.requiredAmount - e.availableAmount} ${e.currency} để mua vật phẩm này',
      );
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
      case 'Sticker OK':
        return 'sticker_ok';
      case 'Sticker yêu ngất ngây':
        return 'sticker_love';
      case 'Sticker buồn hiu':
        return 'sticker_sad';
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

  List<ShopItem> _defaultItems() {
    return const [
      ShopItem(
        id: 'streak_freeze',
        name: 'Đá băng',
        description: 'Giữ chuỗi streak khi nghỉ 1 ngày',
        imagePath: 'assets/images/streak/streakbang.png',
        price: 200,
        isCoins: true,
      ),
      ShopItem(
        id: 'xp_boost',
        name: 'Vảy tăng tốc',
        description: 'Nhận đôi XP trong 15 phút',
        imagePath: 'assets/images/XPx2.png',
        price: 150,
        isCoins: true,
      ),
      ShopItem(
        id: 'super_boost',
        name: 'Bình cực quang',
        description: 'Tăng 25% XP toàn app trong 24 giờ',
        imagePath: 'assets/images/binhcucquang.png',
        price: 2,
        isCoins: false,
      ),
      ShopItem(
        id: 'sticker_ok',
        name: 'Sticker OK',
        description: 'Dùng sticker trong chat nhóm & bình luận',
        imagePath: 'assets/images/chimcanhcut/chim_ok.png',
        price: 2,
        isCoins: false,
      ),
      ShopItem(
        id: 'sticker_love',
        name: 'Sticker yêu ngất ngây',
        description: 'Dùng sticker trong chat nhóm & bình luận',
        imagePath: 'assets/images/chimcanhcut/chim_yeu.png',
        price: 2,
        isCoins: false,
      ),
      ShopItem(
        id: 'sticker_sad',
        name: 'Sticker buồn hiu',
        description: 'Dùng sticker trong chat nhóm & bình luận',
        imagePath: 'assets/images/chimcanhcut/chim_buon.png',
        price: 2,
        isCoins: false,
      ),
    ];
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
