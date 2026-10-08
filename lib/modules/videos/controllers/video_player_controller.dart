import 'package:get/get.dart';

class VideoPlayerController extends GetxController {
  final RxString playbackUrl = ''.obs;
  final RxBool isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['playbackUrl'] != null) {
      playbackUrl.value = args['playbackUrl'] as String;
    }
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }
}
