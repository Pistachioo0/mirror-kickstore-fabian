import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../models/product_model.dart';
import 'product_local_datasource.dart';

class StorageService extends GetxService {
  static const _themeKey = 'is_dark_mode';

  late SharedPreferences _prefs;
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<StorageService> init({bool initHive = true}) async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;

    if (initHive) {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ProductModelAdapter());
      }

      await Hive.openBox<ProductModel>(
        ProductLocalDataSourceImpl.productsBoxName,
      );
      await Hive.openBox<ProductModel>(
        ProductLocalDataSourceImpl.wishlistBoxName,
      );
    }

    return this;
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _prefs.setBool(_themeKey, _isDarkMode.value);
    Get.changeThemeMode(themeMode);

    if (_isDarkMode.value) {
      Get.snackbar(
        'Mode Gelap Diaktifkan',
        'Tampilan hemat daya dan nyaman untuk mata telah aktif.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
        icon: const Icon(Icons.dark_mode_rounded, color: Colors.amber),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Mode Terang Diaktifkan',
        'Tampilan cerah bersemangat telah aktif.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4F46E5),
        colorText: Colors.white,
        icon: const Icon(Icons.light_mode_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
