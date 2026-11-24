import '../../core/network/dio_exception.dart';
import '../../core/network/result.dart';
import '../local/product_local_datasource.dart';
import '../models/product_model.dart';
import '../remote/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
  List<ProductModel> getWishlist();
  Future<bool> toggleWishlist(ProductModel product);
  bool isFavorite(String productId);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final remoteProducts = await _remoteDataSource.fetchProducts();

      if (remoteProducts.isNotEmpty) {
        await _localDataSource.cacheProducts(remoteProducts);
      }

      return Success(remoteProducts);
    } on NetworkFailure catch (e) {
      final cachedProducts = _localDataSource.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return Success(cachedProducts);
      }
      return Failure(e.message);
    }
  }

  @override
  List<ProductModel> getWishlist() {
    return _localDataSource.getWishlist();
  }

  @override
  Future<bool> toggleWishlist(ProductModel product) async {
    final isCurrentlyFav = _localDataSource.isFavorite(product.id);
    if (isCurrentlyFav) {
      await _localDataSource.removeFromWishlist(product.id);
      return false;
    } else {
      await _localDataSource.saveToWishlist(product);
      return true;
    }
  }

  @override
  bool isFavorite(String productId) {
    return _localDataSource.isFavorite(productId);
  }
}
