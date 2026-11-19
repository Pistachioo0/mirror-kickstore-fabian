import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistController extends GetxController {
  HomeController get homeController => Get.find<HomeController>();

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  List<ProductModel> get wishlistItems {
    return homeController.products
        .where((p) => homeController.favoriteIds.contains(p.id))
        .toList();
  }

  int get cartCount => cartController.totalItemCount;

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

  void removeFromWishlist(ProductModel product) {
    homeController.toggleFavorite(product.id);
  }
}
