import 'package:get/get.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/storage/preferences_service.dart';
import '../../core/storage/database_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/crashlytics_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage Services
    if (!Get.isRegistered<SecureStorageService>()) {
      Get.put(SecureStorageService(), permanent: true);
    }
    if (!Get.isRegistered<PreferencesService>()) {
      Get.put(PreferencesService(), permanent: true);
    }
    if (!Get.isRegistered<DatabaseService>()) {
      Get.put(DatabaseService(), permanent: true);
    }

    // Network Client
    if (!Get.isRegistered<DioClient>()) {
      Get.put(
        DioClient(secureStorageService: Get.find<SecureStorageService>()),
        permanent: true,
      );
    }

    // App Core Services
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<ThemeService>()) {
      Get.put(ThemeService(), permanent: true);
    }
    if (!Get.isRegistered<ConnectivityService>()) {
      Get.put(ConnectivityService(), permanent: true);
    }
    if (!Get.isRegistered<AnalyticsService>()) {
      Get.put(AnalyticsService(), permanent: true);
    }
    if (!Get.isRegistered<CrashlyticsService>()) {
      Get.put(CrashlyticsService(), permanent: true);
    }
  }
}
