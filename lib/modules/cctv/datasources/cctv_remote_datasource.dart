import '../../../core/network/dio_client.dart';
import '../../../data/models/cctv_models.dart';

class CctvRemoteDataSource {
  final DioClient dioClient;

  CctvRemoteDataSource({required this.dioClient});

  Future<List<CctvCameraModel>> getCameras(String clubId) async {
    return [
      CctvCameraModel(
        id: 'cam_1',
        clubId: clubId,
        name: 'Turf 1 Live Camera',
        status: 'ONLINE',
        healthStatus: 'ONLINE',
      ),
      CctvCameraModel(
        id: 'cam_2',
        clubId: clubId,
        name: 'Badminton Court Cam',
        status: 'ONLINE',
        healthStatus: 'ONLINE',
      ),
    ];
  }

  Future<void> addCamera(Map<String, dynamic> data) async {}

  Future<Map<String, dynamic>> testCameraConnection(String cameraId) async {
    return {'status': 'ONLINE', 'latency': '24ms'};
  }

  Future<CctvRecordingModel?> getRecordingByGame(String gameId) async {
    return CctvRecordingModel(
      id: 'rec_1',
      gameId: gameId,
      clubId: 'club_1',
      status: 'RECORDING',
      recordingStatus: 'RECORDING',
      startedAt: DateTime.now().toIso8601String(),
      scheduledMatchEnd: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      stopDeadline: DateTime.now().add(const Duration(hours: 1, minutes: 15)).toIso8601String(),
    );
  }

  Future<CctvRecordingModel> stopRecording(String recordingId) async {
    return CctvRecordingModel(
      id: recordingId,
      gameId: 'game_1',
      clubId: 'club_1',
      status: 'STOPPED_MANUALLY',
      recordingStatus: 'STOPPED_MANUALLY',
      startedAt: DateTime.now().toIso8601String(),
      scheduledMatchEnd: DateTime.now().toIso8601String(),
      stopDeadline: DateTime.now().toIso8601String(),
    );
  }

  Future<CctvRecordingModel> extendRecording(String recordingId, int minutes) async {
    return CctvRecordingModel(
      id: recordingId,
      gameId: 'game_1',
      clubId: 'club_1',
      status: 'RECORDING',
      recordingStatus: 'RECORDING',
      startedAt: DateTime.now().toIso8601String(),
      scheduledMatchEnd: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      stopDeadline: DateTime.now().add(const Duration(hours: 1, minutes: 15)).toIso8601String(),
    );
  }
}
