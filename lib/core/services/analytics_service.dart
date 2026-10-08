import 'package:get/get.dart';
import '../utils/app_logger.dart';

class AnalyticsService extends GetxService {
  static AnalyticsService get to => Get.find();

  void logEvent(String name, [Map<String, dynamic>? parameters]) {
    AppLogger.info('📊 [Analytics Event]: $name $parameters');
  }
}
