import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!AuthService.to.isLoggedIn.value) {
      AuthService.to.redirectRoute = route;

      Get.snackbar(
        'Akses Dibatasi',
        'Silakan masuk akun terlebih dahulu untuk melanjutkan proses pemesanan.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
        icon: const Icon(Icons.lock_outline_rounded,
            color: Colors.orangeAccent),
      );

      return const RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}
