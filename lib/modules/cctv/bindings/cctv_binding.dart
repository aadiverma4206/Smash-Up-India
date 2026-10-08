import 'package:get/get.dart';
import '../datasources/cctv_remote_datasource.dart';
import '../repositories/cctv_repository.dart';
import '../controllers/cctv_controller.dart';
import '../../../core/network/dio_client.dart';

class CctvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CctvRemoteDataSource>(
      () => CctvRemoteDataSource(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<CctvRepository>(
      () => CctvRepository(remoteDataSource: Get.find<CctvRemoteDataSource>()),
    );
    Get.lazyPut<CctvController>(
      () => CctvController(),
    );
  }
}
