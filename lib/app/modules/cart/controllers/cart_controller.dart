import 'package:get/get.dart';

import '../../../data/local/cart_local_datasource.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final CartLocalDataSource? _localDataSource;

  CartController({CartLocalDataSource? localDataSource})
      : _localDataSource = localDataSource;

  final items = <CartItemModel>[].obs;

  CartLocalDataSource? get _ds {
    if (_localDataSource != null) return _localDataSource;
    if (Get.isRegistered<CartLocalDataSource>()) {
      return Get.find<CartLocalDataSource>();
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final ds = _ds;
    if (ds != null) {
      final saved = ds.getCartItems();
      if (saved.isNotEmpty) items.assignAll(saved);
    }
  }

  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  int get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  int get tax => (subtotal * 0.11).round();

  int get shippingFee => subtotal >= 2000000 ? 0 : 20000;

  int get totalAmount => subtotal + tax + shippingFee;

  String _fmt(int amount) {
    final f = amount.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $f';
  }

  String get formattedSubtotal => _fmt(subtotal);
  String get formattedTax => _fmt(tax);
  String get formattedShipping =>
      shippingFee == 0 ? 'Gratis' : _fmt(shippingFee);
  String get formattedTotal => _fmt(totalAmount);

  Future<void> addItemAsync(
    ProductModel product, {
    int quantity = 1,
    String size = '42',
  }) async {
    final compositeId = '${product.id}_$size';
    final index = items.indexWhere((item) => item.id == compositeId);

    if (index >= 0) {
      final existing = items[index];
      final updated = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
      items[index] = updated;
      await _ds?.saveCartItem(updated);
    } else {
      final newItem = CartItemModel(
        id: compositeId,
        product: product,
        selectedSize: size,
        quantity: quantity,
      );
      items.add(newItem);
      await _ds?.saveCartItem(newItem);
    }
  }

  Future<void> increaseQuantity(String id) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final item = items[index];
    final updated = item.copyWith(quantity: item.quantity + 1);
    items[index] = updated;
    await _ds?.saveCartItem(updated);
  }

  Future<void> decreaseQuantity(String id) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final item = items[index];
    if (item.quantity <= 1) {
      items.removeAt(index);
      await _ds?.removeCartItem(id);
    } else {
      final updated = item.copyWith(quantity: item.quantity - 1);
      items[index] = updated;
      await _ds?.saveCartItem(updated);
    }
  }

  Future<void> removeItem(String id) async {
    items.removeWhere((item) => item.id == id);
    await _ds?.removeCartItem(id);
  }

  Future<void> clearCartAsync() async {
    items.clear();
    await _ds?.clearCart();
  }
}
