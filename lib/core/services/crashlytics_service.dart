import 'package:get/get.dart';
import '../utils/app_logger.dart';

class CrashlyticsService extends GetxService {
  static CrashlyticsService get to => Get.find();

  void recordError(dynamic exception, StackTrace? stack, {String? reason}) {
    AppLogger.error('💥 [Crashlytics Error]: $reason', exception, stack);
  }
}
