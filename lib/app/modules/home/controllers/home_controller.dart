import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:e_commerce/app/routes/app_pages.dart';

class HomeController extends GetxController {
  // 1. State reaktif
  final cartCount = 0.obs;
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;

  // 2. Formatter harga
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // 3. Kategori
  final List<String> categories = [
    'Semua',
    'Lifestyle',
    'Running',
    'Basketball',
    'Skate',
    'Casual',
  ];

  // 4. Mock data produk
  final List<Map<String, dynamic>> products = [
    {
      'id': 'p1',
      'title': 'Nike Air Jordan 1 Retro High',
      'category': 'Basketball',
      'price': 2499000,
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
    },
    {
      'id': 'p2',
      'title': 'Nike Air Force 1 07 Triple White',
      'category': 'Lifestyle',
      'price': 1549000,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80',
    },
    {
      'id': 'p3',
      'title': 'Adidas Ultraboost Light Running',
      'category': 'Running',
      'price': 2899000,
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500&q=80',
    },
    {
      'id': 'p4',
      'title': 'Puma Suede Classic XXI Black',
      'category': 'Casual',
      'price': 1099000,
      'rating': 4.6,
      'image': 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&q=80',
    },
    {
      'id': 'p5',
      'title': 'New Balance 574 Core Grey',
      'category': 'Lifestyle',
      'price': 1499000,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&q=80',
    },
    {
      'id': 'p6',
      'title': 'Vans Old Skool Classic Skate',
      'category': 'Skate',
      'price': 999000,
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&q=80',
    },
  ];

  // 5. Getter filter
  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory.value == 'Semua') return products;
    return products
        .where((p) => p['category'] == selectedCategory.value)
        .toList();
  }

  // 6. Fungsi-fungsi
  void changeCategory(String category) => selectedCategory.value = category;

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
  }

  void addToCart(Map<String, dynamic> product) {
    cartCount.value++;
  }

  void openDetail(Map<String, dynamic> product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }
}