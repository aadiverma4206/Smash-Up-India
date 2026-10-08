import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/preferences_service.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final PreferencesService _prefs = Get.find<PreferencesService>();
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs; // Light mode default

  @override
  void onInit() {
    super.onInit();
    final savedMode = _prefs.getThemeMode();
    if (savedMode == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }

  void switchThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    _prefs.setThemeMode(mode == ThemeMode.light ? 'light' : 'dark');
  }
}
