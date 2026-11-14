import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String selectedSize;
  final int quantity;

  CartItemModel({
    required this.product,
    required this.selectedSize,
    required this.quantity,
  });

  String get id => '${product.id}_$selectedSize';

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
      product: product,
      selectedSize: selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }
}