import 'package:get/get.dart';

import '../../../data/local/product_local_datasource.dart';
import '../../../data/remote/product_remote_datasource.dart';
import '../../../data/repository/product_repository.dart';
import '../controllers/wishlist_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductLocalDataSource>()) {
      Get.lazyPut<ProductLocalDataSource>(() => ProductLocalDataSourceImpl());
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(
          Get.find<ProductRemoteDataSource>(),
          Get.find<ProductLocalDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }

    Get.lazyPut<WishlistController>(
      () => WishlistController(Get.find<ProductRepository>()),
    );
  }
}
