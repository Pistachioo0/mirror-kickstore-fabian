import 'package:hive_ce/hive.dart';

import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<void> saveCartItem(CartItemModel item);
  Future<void> removeCartItem(String cartItemId);
  Future<void> clearCart();
  List<CartItemModel> getCartItems();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String cartBoxName = 'cart_box';

  Box<CartItemModel> get _cartBox => Hive.box<CartItemModel>(cartBoxName);

  @override
  Future<void> saveCartItem(CartItemModel item) async {
    await _cartBox.put(item.id, item);
  }

  @override
  Future<void> removeCartItem(String cartItemId) async {
    await _cartBox.delete(cartItemId);
  }

  @override
  Future<void> clearCart() async {
    await _cartBox.clear();
  }

  @override
  List<CartItemModel> getCartItems() {
    return _cartBox.values.toList();
  }
}
