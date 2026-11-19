import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}