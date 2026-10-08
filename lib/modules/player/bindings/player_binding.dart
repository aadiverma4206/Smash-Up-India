import 'package:get/get.dart';
import '../datasources/player_remote_datasource.dart';
import '../repositories/player_repository.dart';
import '../controllers/player_controller.dart';
import '../controllers/notifications_controller.dart';
import '../../games/datasources/games_remote_datasource.dart';
import '../../games/repositories/games_repository.dart';
import '../../../core/network/dio_client.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PlayerRemoteDataSource>()) {
      Get.lazyPut<PlayerRemoteDataSource>(
        () => PlayerRemoteDataSource(dioClient: Get.find<DioClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<PlayerRepository>()) {
      Get.lazyPut<PlayerRepository>(
        () => PlayerRepository(
            remoteDataSource: Get.find<PlayerRemoteDataSource>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GamesRemoteDataSource>()) {
      Get.lazyPut<GamesRemoteDataSource>(
        () => GamesRemoteDataSource(dioClient: Get.find<DioClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<GamesRepository>()) {
      Get.lazyPut<GamesRepository>(
        () => GamesRepository(
            remoteDataSource: Get.find<GamesRemoteDataSource>()),
        fenix: true,
      );
    }
    Get.lazyPut<PlayerController>(
      () => PlayerController(),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );
  }
}
