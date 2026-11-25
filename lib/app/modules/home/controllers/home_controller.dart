import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/result.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final ProductRepository _productRepository;

  HomeController(this._productRepository);

  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final products = <ProductModel>[].obs;

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  int get cartCount => cartController.totalItemCount;

  final List<String> categories = [
    'Semua', 'Lifestyle', 'Running', 'Basketball', 'Skate', 'Casual',
  ];

  // Fallback produk lokal kalau server mati total
  final List<ProductModel> _initialFallbackProducts = [
    ProductModel(
      id: 'p1',
      name: 'Nike Air Jordan 1 Retro High',
      category: 'Basketball',
      price: 2499000,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
    ),
    ProductModel(
      id: 'p2',
      name: 'Nike Air Force 1 07 Triple White',
      category: 'Lifestyle',
      price: 1549000,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80',
    ),
    ProductModel(
      id: 'p3',
      name: 'Adidas Ultraboost Light Running',
      category: 'Running',
      price: 2899000,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500&q=80',
    ),
  ];

  
  void onInit() {
    super.onInit();
    favoriteIds.assignAll(_productRepository.getWishlist().map((e) => e.id));
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _productRepository.fetchProducts();

    switch (result) {
      case Success(data: final remoteProducts):
        if (remoteProducts.isNotEmpty) {
          products.assignAll(remoteProducts);
        }
        // TANTANGAN: Snackbar hijau
        Get.snackbar(
          'Katalog Berhasil Diperbarui',
          'Berhasil mengunduh ${remoteProducts.length} sepatu terbaru dari server!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          icon: const Icon(Icons.cloud_done_rounded, color: Colors.white),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      case Failure(error: final error):
        errorMessage.value = error;
        if (products.isEmpty) {
          products.assignAll(_initialFallbackProducts);
        } else {
          // TANTANGAN: Snackbar merah (mode offline) jika sudah ada data
          Get.snackbar(
            'Mode Offline',
            'Koneksi ke server terputus. Menampilkan data yang tersimpan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
          );
        }
    }

    isLoading.value = false;
  }

  List<ProductModel> get filteredProducts {
    if (selectedCategory.value == 'Semua') return products;
    return products
        .where((p) => p.category == selectedCategory.value)
        .toList();
  }

  void changeCategory(String category) => selectedCategory.value = category;

  bool isFavorite(String id) => favoriteIds.contains(id);

  Future<void> toggleFavorite(String productId) async {
    final product = products.firstWhereOrNull((p) => p.id == productId);
    if (product == null) return;

    final isNowFav = await _productRepository.toggleWishlist(product);
    if (isNowFav) {
      favoriteIds.add(productId);
    } else {
      favoriteIds.remove(productId);
    }
  }

  void addToCart(ProductModel product) {
    cartController.addItemAsync(product);
  }

  void openDetail(ProductModel product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }
}