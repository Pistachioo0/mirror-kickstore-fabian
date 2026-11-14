import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  // 1. Data produk dari argumen navigasi
  late final Map<String, dynamic> product;

  // 2. Referensi ke HomeController untuk sinkron cart & favorit
  late final HomeController homeController;

  // 3. State reaktif kuantitas
  final quantity = 1.obs;
  final selectedSize = 42.obs;

  @override
  void onInit() {
    super.onInit();

    // Tangkap argumen dengan aman
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      product = args;
    } else {
      product = <String, dynamic>{};
    }

    // Ambil HomeController yang sudah terdaftar di binding
    homeController = Get.find<HomeController>();
  }

  // 4. Counter
  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  // 5. Tambah ke keranjang
  void addToCart() {
    homeController.cartCount.value += quantity.value;
    Get.snackbar(
      'Berhasil',
      '${quantity.value} item ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    Get.back();
  }

  // 6. Sinkron favorit dengan HomeController
  bool get isFavorite =>
      homeController.isFavorite(product['id'] as String? ?? '');

  void toggleFavorite() {
    final id = product['id'] as String?;
    if (id != null) homeController.toggleFavorite(id);
  }
}