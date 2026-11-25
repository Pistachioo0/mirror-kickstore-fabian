import '../../../data/local/cart_local_datasource.dart';
import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../data/local/product_local_datasource.dart';
import '../../../data/remote/product_remote_datasource.dart';
import '../../../data/repository/product_repository.dart';
import '../controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioClient>(() => DioClient());

    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(Get.find<DioClient>()),
    );

    Get.lazyPut<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(),
    );

    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(
        Get.find<ProductRemoteDataSource>(),
        Get.find<ProductLocalDataSource>(),
      ),
    );

    Get.lazyPut<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(),
    );

    Get.lazyPut<CartController>(() => CartController());

    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProductRepository>()),
    );
  }
}
