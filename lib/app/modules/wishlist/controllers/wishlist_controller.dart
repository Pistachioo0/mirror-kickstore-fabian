import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistController extends GetxController {
  HomeController get homeController {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>();
    }
    return Get.put(HomeController());
  }

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  // Filter katalog home berdasarkan favoriteIds
  List<ProductModel> get wishlistItems {
    return homeController.products
        .where((p) => homeController.favoriteIds.contains(p.id))
        .toList();
  }

  // Badge keranjang
  int get cartCount => cartController.totalItemCount;

  // Pindahkan item ke cart, lalu hapus dari favorit
  void moveToCart(ProductModel product) {
    cartController.addItem(product);
    homeController.toggleFavorite(product.id);
    Get.snackbar(
      'Dipindahkan',
      '${product.name} dipindahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Hapus dari favorit saja
  void removeFromWishlist(ProductModel product) {
    homeController.toggleFavorite(product.id);
  }
}