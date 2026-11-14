import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // 1. State reaktif
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;

  // 2. Shared CartController via DI
  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  // 3. Badge keranjang baca langsung dari CartController
  int get cartCount => cartController.totalItemCount;

  // 4. Kategori
  final List<String> categories = [
    'Semua',
    'Lifestyle',
    'Running',
    'Basketball',
    'Skate',
    'Casual',
  ];

  // 5. Katalog produk type-safe
  final List<ProductModel> products = [
    ProductModel(
      id: 'p1',
      name: 'Nike Air Jordan 1 Retro High',
      category: 'Basketball',
      price: 2499000,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
    ),
    ProductModel(
      id: 'p2',
      name: 'Nike Air Force 1 07 Triple White',
      category: 'Lifestyle',
      price: 1549000,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80',
    ),
    ProductModel(
      id: 'p3',
      name: 'Adidas Ultraboost Light Running',
      category: 'Running',
      price: 2899000,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500&q=80',
    ),
    ProductModel(
      id: 'p4',
      name: 'Puma Suede Classic XXI Black',
      category: 'Casual',
      price: 1099000,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&q=80',
    ),
    ProductModel(
      id: 'p5',
      name: 'New Balance 574 Core Grey',
      category: 'Lifestyle',
      price: 1499000,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&q=80',
    ),
    ProductModel(
      id: 'p6',
      name: 'Vans Old Skool Classic Skate',
      category: 'Skate',
      price: 999000,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&q=80',
    ),
  ];

  // 6. Getter filter
  List<ProductModel> get filteredProducts {
    if (selectedCategory.value == 'Semua') return products;
    return products
        .where((p) => p.category == selectedCategory.value)
        .toList();
  }

  // 7. Fungsi
  void changeCategory(String category) => selectedCategory.value = category;

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
  }

  // 8. Tambah ke cart lewat CartController
  void addToCart(ProductModel product) {
    cartController.addItem(product);
  }

  void openDetail(ProductModel product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }
}