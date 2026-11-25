import 'package:hive_ce/hive.dart';

import 'product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ProductModel product;

  @HiveField(2)
  final String selectedSize;

  @HiveField(3)
  int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.quantity,
  });

  int get subtotal => product.price * quantity;

  String get formattedSubtotal {
    final formatted = subtotal.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      product: product,
      selectedSize: selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }
}
