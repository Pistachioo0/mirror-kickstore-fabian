import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class CourierOption {
  final String name;
  final String estimatedTime;
  final int cost;

  const CourierOption({
    required this.name,
    required this.estimatedTime,
    required this.cost,
  });
}

class CheckoutController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController notesController;
  late final TextEditingController couponController;

  final selectedCourierIndex = 0.obs;
  final selectedPaymentMethod = 0.obs;
  final isLoading = false.obs;

  // TANTANGAN: Kupon diskon
  final discountAmount = 0.obs;
  final appliedCouponCode = ''.obs;

  final List<CourierOption> courierOptions = const [
    CourierOption(
        name: 'JNE Reguler', estimatedTime: '2-3 hari kerja', cost: 25000),
    CourierOption(
        name: 'SiCepat BEST', estimatedTime: '1-2 hari kerja', cost: 22000),
    CourierOption(
        name: 'GoSend Instant',
        estimatedTime: 'Tiba hari ini (Instant 3-4 jam)',
        cost: 35000),
  ];

  CartController get cart => Get.find<CartController>();

  int get subtotal => cart.subtotal;
  int get tax => cart.tax;
  int get courierFee =>
      cart.items.isEmpty ? 0 : courierOptions[selectedCourierIndex.value].cost;
  int get promoDiscount => discountAmount.value;
  int get grandTotal => subtotal + tax + courierFee - promoDiscount;

  String _fmt(int amount) {
    final f = amount.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $f';
  }

  String get formattedSubtotal => _fmt(subtotal);
  String get formattedTax => _fmt(tax);
  String get formattedCourier => _fmt(courierFee);
  String get formattedDiscount => '- ${_fmt(promoDiscount)}';
  String get formattedGrandTotal => _fmt(grandTotal);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    notesController = TextEditingController();
    couponController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    couponController.dispose();
    super.onClose();
  }

  String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama penerima wajib diisi';
    if (v.trim().length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor WhatsApp wajib diisi';
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(v.trim())) {
      return 'Nomor WA tidak valid (10-15 digit angka)';
    }
    return null;
  }

  String? validateAddress(String? v) {
    if (v == null || v.trim().isEmpty) return 'Alamat lengkap wajib diisi';
    if (v.trim().length < 10) return 'Alamat minimal 10 karakter';
    return null;
  }

  void applyCoupon(String code) {
    final normalized = code.trim().toUpperCase();
    if (normalized == 'SMKBISA' || normalized == 'KICKS10') {
      discountAmount.value = 25000;
      appliedCouponCode.value = normalized;
      Get.snackbar(
        'Kupon Berhasil Dipasang! 🎉',
        'Hemat Rp 25.000 untuk pesanan sneakers impianmu.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else {
      discountAmount.value = 0;
      appliedCouponCode.value = '';
      Get.snackbar(
        'Kupon Tidak Valid',
        'Kode kupon promo tidak ditemukan atau telah kedaluwarsa.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> placeOrder() async {
    if (formKey.currentState == null ||
        !formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    await cart.clearCartAsync();
    isLoading.value = false;

    Get.defaultDialog(
      title: 'Pesanan Sukses! 🎉',
      middleText:
          'Pesanan kamu sedang diproses.\nTotal: ${_fmt(grandTotal)}\nKurir: ${courierOptions[selectedCourierIndex.value].name}',
      textConfirm: 'Lihat Pesanan',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF4F46E5),
      onConfirm: () {
        Get.back();
        Get.offAllNamed(Routes.ORDERS);
      },
      onCancel: () {},
    );
  }
}
