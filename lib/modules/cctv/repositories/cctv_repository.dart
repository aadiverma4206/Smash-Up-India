import '../datasources/cctv_remote_datasource.dart';
import '../../../data/models/cctv_models.dart';

class CctvRepository {
  final CctvRemoteDataSource remoteDataSource;

  CctvRepository({required this.remoteDataSource});

  Future<List<CctvCameraModel>> getCameras(String clubId) async {
    return await remoteDataSource.getCameras(clubId);
  }

  Future<void> addCamera(Map<String, dynamic> data) async {
    return await remoteDataSource.addCamera(data);
  }

  Future<Map<String, dynamic>> testCameraConnection(String cameraId) async {
    return await remoteDataSource.testCameraConnection(cameraId);
  }

  Future<CctvRecordingModel?> getRecordingByGame(String gameId) async {
    return await remoteDataSource.getRecordingByGame(gameId);
  }

  Future<CctvRecordingModel> stopRecording(String recordingId) async {
    return await remoteDataSource.stopRecording(recordingId);
  }

  Future<CctvRecordingModel> extendRecording(String recordingId, int minutes) async {
    return await remoteDataSource.extendRecording(recordingId, minutes);
  }
}
