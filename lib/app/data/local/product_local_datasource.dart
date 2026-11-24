import 'package:hive_ce/hive.dart';

import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  List<ProductModel> getCachedProducts();
  Future<void> saveToWishlist(ProductModel product);
  Future<void> removeFromWishlist(String productId);
  List<ProductModel> getWishlist();
  bool isFavorite(String productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productsBoxName = 'products_box';
  static const String wishlistBoxName = 'wishlist_box';

  Box<ProductModel> get _productsBox => Hive.box<ProductModel>(productsBoxName);
  Box<ProductModel> get _wishlistBox => Hive.box<ProductModel>(wishlistBoxName);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final Map<String, ProductModel> map = {
      for (final p in products) p.id: p,
    };
    await _productsBox.putAll(map);
  }

  @override
  List<ProductModel> getCachedProducts() {
    return _productsBox.values.toList();
  }

  @override
  Future<void> saveToWishlist(ProductModel product) async {
    await _wishlistBox.put(product.id, product.copyWith(isFavorite: true));
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await _wishlistBox.delete(productId);
  }

  @override
  List<ProductModel> getWishlist() {
    return _wishlistBox.values.toList();
  }

  @override
  bool isFavorite(String productId) {
    return _wishlistBox.containsKey(productId);
  }
}
