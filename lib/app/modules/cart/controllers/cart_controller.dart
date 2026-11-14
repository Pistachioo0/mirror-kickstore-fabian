import 'package:get/get.dart';

import '../../../../app/data/models/cart_item_model.dart';
import '../../../../app/data/models/product_model.dart';

class CartController extends GetxController {
  // 1. State reaktif utama
  final items = <CartItemModel>[].obs;

  // 2. Total item (untuk badge AppBar)
  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  // 3. Subtotal (harga barang sebelum pajak & ongkir)
  int get subtotal =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  // 4. PPN 11%
  int get tax => (subtotal * 0.11).round();

  // 5. Ongkir: gratis jika subtotal >= Rp 2.000.000
  int get shippingFee => subtotal >= 2000000 ? 0 : 20000;

  // 6. Total akhir
  int get totalAmount => subtotal + tax + shippingFee;

  // 7. Formatter manual (tanpa intl)
  String _formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  String get formattedSubtotal => _formatRupiah(subtotal);
  String get formattedTax => _formatRupiah(tax);
  String get formattedShipping =>
      shippingFee == 0 ? 'Gratis' : _formatRupiah(shippingFee);
  String get formattedTotal => _formatRupiah(totalAmount);

  // 8. Tambah item ke keranjang
  void addItem(
    ProductModel product, {
    int quantity = 1,
    String size = '42',
  }) {
    final compositeId = '${product.id}_$size';
    final index = items.indexWhere((item) => item.id == compositeId);

    if (index >= 0) {
      // Produk + size sama sudah ada → tambah kuantitas
      final existing = items[index];
      items[index] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      // Produk + size baru → tambah baris baru
      items.add(CartItemModel(
        product: product,
        selectedSize: size,
        quantity: quantity,
      ));
    }
  }

  // 9. Stepper kuantitas
  void increaseQuantity(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final item = items[index];
    items[index] = item.copyWith(quantity: item.quantity + 1);
  }

  void decreaseQuantity(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final item = items[index];
    if (item.quantity <= 1) {
      // Kuantitas 1 dikurangi → hapus item
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    }
  }

  // 10. Hapus item
  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
  }

  // 11. Kosongkan keranjang
  void clearCart() => items.clear();
}