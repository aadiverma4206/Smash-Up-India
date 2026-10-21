import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/storage/preferences_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/storage/database_service.dart';
import 'core/network/dio_client.dart';
import 'core/services/theme_service.dart';
import 'core/services/auth_service.dart';
import 'core/utils/app_logger.dart';

Future<void> bootstrap({String envFile = '.env.dev'}) async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info(
      '⚡ App initialized in offline mode (disconnected from backend and database).');

  try {
    final prefs = PreferencesService();
    await prefs.init();
    Get.put<PreferencesService>(prefs, permanent: true);

    final themeService = ThemeService();
    Get.put<ThemeService>(themeService, permanent: true);

    final secureStorage = SecureStorageService();
    Get.put<SecureStorageService>(secureStorage, permanent: true);

    final dbService = DatabaseService();
    await dbService.init();
    Get.put<DatabaseService>(dbService, permanent: true);

    final dioClient = DioClient(secureStorageService: secureStorage);
    Get.put<DioClient>(dioClient, permanent: true);

    final authService = AuthService();
    Get.put<AuthService>(authService, permanent: true);
  } catch (e) {
    AppLogger.error('Failed to initialize bootstrap services', e);
  }
}
