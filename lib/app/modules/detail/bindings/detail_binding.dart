import '../../../data/local/cart_local_datasource.dart';
import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(),
    );

    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<DetailController>(() => DetailController());
  }
}