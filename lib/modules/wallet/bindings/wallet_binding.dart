import 'package:get/get.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../repositories/wallet_repository.dart';
import '../controllers/wallet_controller.dart';
import '../../../core/network/dio_client.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletRemoteDataSource>(
      () => WalletRemoteDataSource(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<WalletRepository>(
      () => WalletRepository(
          remoteDataSource: Get.find<WalletRemoteDataSource>()),
    );
    Get.lazyPut<WalletController>(
      () => WalletController(),
    );
  }
}
