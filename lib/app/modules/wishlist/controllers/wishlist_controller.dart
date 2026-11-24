import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  final ProductRepository _productRepository;

  WishlistController([ProductRepository? productRepository])
      : _productRepository =
            productRepository ?? Get.find<ProductRepository>();

  final RxList<ProductModel> wishlist = <ProductModel>[].obs;

  List<ProductModel> get wishlistItems => wishlist;

  CartController get cartController => Get.find<CartController>();
  HomeController get homeController => Get.find<HomeController>();

  int get cartCount => cartController.totalItemCount;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  void loadWishlist() {
    wishlist.assignAll(_productRepository.getWishlist());
  }

  Future<void> removeFromWishlist(String productId) async {
    final item = wishlist.firstWhereOrNull((e) => e.id == productId);
    if (item != null) {
      await _productRepository.toggleWishlist(item);
      loadWishlist();
      if (Get.isRegistered<HomeController>()) {
        homeController.favoriteIds.remove(productId);
      }
    }
  }

  void moveToCart(ProductModel product) {
    cartController.addItem(product);
    removeFromWishlist(product.id);
    Get.snackbar(
      'Dipindahkan',
      '${product.name} dipindahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> clearWishlist() async {
    Get.defaultDialog(
      title: 'Kosongkan Wishlist?',
      titleStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      middleText:
          'Apakah Anda yakin ingin menghapus seluruh sepatu favorit dari memori penyimpanan lokal?',
      textCancel: 'Batal',
      textConfirm: 'Hapus Semua',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      cancelTextColor: Colors.grey,
      onConfirm: () async {
        Get.back();
        await Hive.box<ProductModel>('wishlist_box').clear();
        wishlist.clear();
        if (Get.isRegistered<HomeController>()) {
          homeController.favoriteIds.clear();
        }
        Get.snackbar(
          'Wishlist Dikosongkan',
          'Seluruh produk favorit berhasil dihapus dari penyimpanan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}
