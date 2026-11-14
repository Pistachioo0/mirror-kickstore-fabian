import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/routes/app_pages.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Keranjang Belanja'),
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return _buildEmptyState(isDark);
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return _buildCartItem(item, isDark);
                },
              ),
            ),
            _buildSummaryCard(isDark),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang masih kosong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk mulai belanja sneakers favoritmu!',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.offNamed(Routes.HOME),
            icon: const Icon(Icons.shopping_bag_rounded),
            label: const Text('Mulai Belanja'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: isDark
                  ? AppColors.darkSurface
                  : const Color(0xFFF1F5F9),
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.selectedSize}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.product.formattedPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                // Stepper
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () =>
                                controller.decreaseQuantity(item.id),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.remove_rounded, size: 16),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                controller.increaseQuantity(item.id),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.add_rounded, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _confirmRemove(item.id),
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rowSummary('Subtotal', controller.formattedSubtotal, isDark),
            const SizedBox(height: 6),
            _rowSummary('PPN 11%', controller.formattedTax, isDark),
            const SizedBox(height: 6),
            _rowSummary('Ongkos Kirim', controller.formattedShipping, isDark),
            const Divider(height: 20),
            _rowSummary(
              'Total',
              controller.formattedTotal,
              isDark,
              bold: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Checkout',
                    'Total pembayaran ${controller.formattedTotal}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.success,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  );
                },
                icon: const Icon(Icons.payment_rounded),
                label: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowSummary(String label, String value, bool isDark,
      {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: bold
                ? AppColors.primary
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  void _confirmRemove(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Item'),
        content: const Text('Yakin ingin menghapus item ini dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              controller.removeItem(id);
              Get.back();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}