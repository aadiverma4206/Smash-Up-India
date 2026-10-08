import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../utils/app_logger.dart';

class DeepLinkService {
  static void handleUri(Uri uri) {
    AppLogger.info('🔗 Deep Link received: $uri');

    final path = uri.path;
    if (path.contains('/games/')) {
      final gameId = uri.pathSegments.last;
      Get.toNamed(Routes.gameDetails, arguments: {'gameId': gameId});
    } else if (path.contains('/cctv/')) {
      Get.toNamed(Routes.cctvDashboard);
    }
  }
}
