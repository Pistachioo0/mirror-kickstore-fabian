import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}