import 'dart:async';
import 'package:get/get.dart';
import '../repositories/cctv_repository.dart';
import '../../../data/models/cctv_models.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/app_date_utils.dart';

class CctvController extends GetxController {
  final CctvRepository repository = Get.find<CctvRepository>();

  final RxList<CctvCameraModel> cameras = <CctvCameraModel>[].obs;
  final Rxn<CctvRecordingModel> currentRecording = Rxn<CctvRecordingModel>();
  final RxBool isLoading = false.obs;

  // Visual countdown timer for POST_MATCH window (+15 min)
  final RxInt remainingCountdownSeconds = 0.obs;
  Timer? _countdownTimer;

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchCameras(String clubId) async {
    isLoading.value = true;
    try {
      final list = await repository.getCameras(clubId);
      cameras.assignAll(list);
    } catch (e) {
      AppLogger.warning('Failed to load CCTV cameras: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCamera({
    required String clubId,
    String? courtId,
    required String name,
    required String rtspUrl,
    String? ipAddress,
    int port = 554,
  }) async {
    isLoading.value = true;
    try {
      final data = {
        'clubId': clubId,
        'courtId': courtId,
        'name': name,
        'rtspUrl': rtspUrl,
        'ipAddress': ipAddress,
        'port': port,
      };

      await repository.addCamera(data);
      await fetchCameras(clubId);
      Get.back();
      ErrorHandler.showSuccessSnackBar(
          'Camera Added', 'CCTV camera added and RTSP secret encrypted!');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> testCamera(String cameraId) async {
    isLoading.value = true;
    try {
      final result = await repository.testCameraConnection(cameraId);
      ErrorHandler.showSuccessSnackBar(
          'CCTV Health Test', 'Status: ${result["status"] ?? "ONLINE"}');
    } catch (e) {
      ErrorHandler.showErrorSnackBar(
          'Test Failed', 'Camera unreachable or RTSP connection timed out.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGameRecording(String gameId) async {
    try {
      final rec = await repository.getRecordingByGame(gameId);
      currentRecording.value = rec;

      if (rec != null &&
          (rec.recordingStatus == 'RECORDING' ||
              rec.recordingStatus == 'POST_MATCH')) {
        _startVisualCountdown(rec.stopDeadline);
      }
    } catch (e) {
      AppLogger.warning('Failed to load recording: $e');
    }
  }

  void _startVisualCountdown(String stopDeadlineIso) {
    _countdownTimer?.cancel();
    final deadline = AppDateUtils.parseDate(stopDeadlineIso);
    if (deadline == null) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final diff = deadline.difference(now).inSeconds;
      if (diff > 0) {
        remainingCountdownSeconds.value = diff;
      } else {
        remainingCountdownSeconds.value = 0;
        timer.cancel();
      }
    });
  }

  Future<void> stopRecordingNow(String recordingId) async {
    isLoading.value = true;
    try {
      final updated = await repository.stopRecording(recordingId);
      currentRecording.value = updated;
      _countdownTimer?.cancel();
      remainingCountdownSeconds.value = 0;
      ErrorHandler.showSuccessSnackBar(
          'Recording Stopped', 'CCTV recording finalized and saved to S3.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Stop Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> extendRecording(String recordingId, int minutes) async {
    isLoading.value = true;
    try {
      final updated = await repository.extendRecording(recordingId, minutes);
      currentRecording.value = updated;
      _startVisualCountdown(updated.stopDeadline);
      ErrorHandler.showSuccessSnackBar('Deadline Extended',
          'Added +$minutes minutes to post-match recording.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Extension Error', e);
    } finally {
      isLoading.value = false;
    }
  }
}
