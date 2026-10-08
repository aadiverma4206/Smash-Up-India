import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        isConnected.value = false;
      } else {
        isConnected.value = true;
      }
    });
  }
}
