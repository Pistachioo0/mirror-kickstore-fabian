import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final product = Rx<ProductModel?>(null);
  final quantity = 1.obs;
  final selectedSize = 42.obs;

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  HomeController get homeController {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>();
    }
    return Get.put(HomeController());
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
    }
  }

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    if (product.value == null) return;
    cartController.addItem(
      product.value!,
      quantity: quantity.value,
      size: selectedSize.value.toString(),
    );
    Get.snackbar(
      'Berhasil',
      '${quantity.value} item ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    Get.back();
  }

  bool get isFavorite {
    final id = product.value?.id;
    if (id == null) return false;
    return homeController.isFavorite(id);
  }

  void toggleFavorite() {
    final id = product.value?.id;
    if (id != null) homeController.toggleFavorite(id);
  }
}