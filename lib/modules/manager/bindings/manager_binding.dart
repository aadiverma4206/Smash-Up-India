import 'package:get/get.dart';
import '../datasources/manager_remote_datasource.dart';
import '../repositories/manager_repository.dart';
import '../controllers/manager_dashboard_controller.dart';
import '../controllers/manager_games_controller.dart';
import '../../../core/network/dio_client.dart';

class ManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerRemoteDataSource>(
      () => ManagerRemoteDataSource(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<ManagerRepository>(
      () => ManagerRepository(
          remoteDataSource: Get.find<ManagerRemoteDataSource>()),
    );
    Get.lazyPut<ManagerDashboardController>(
      () => ManagerDashboardController(),
    );
    Get.lazyPut<ManagerGamesController>(
      () => ManagerGamesController(),
    );
  }
}
