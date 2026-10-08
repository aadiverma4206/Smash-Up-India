import 'package:get/get.dart';
import '../datasources/admin_remote_datasource.dart';
import '../repositories/admin_repository.dart';
import '../controllers/admin_controller.dart';
import '../../../core/network/dio_client.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRemoteDataSource>(
      () => AdminRemoteDataSource(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<AdminRepository>(
      () =>
          AdminRepository(remoteDataSource: Get.find<AdminRemoteDataSource>()),
    );
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
  }
}
