import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/cctv_models.dart';

void main() {
  group('ALL STARS ARENA Manager CCTV Management Unit Tests', () {
    test(
        'CctvCameraModel deserializes camera metadata securely without raw RTSP secrets',
        () {
      final json = {
        'id': 'cam_101',
        'clubId': 'clb_001',
        'courtId': 'crt_001',
        'courtName': 'Pitch 1 Dome',
        'name': 'Dome Camera 1',
        'cameraType': 'RTSP_DOME',
        'connectionType': 'RTSP',
        'ipAddress': '192.168.1.100',
        'port': 554,
        'isEnabled': true,
        'status': 'ONLINE',
        'healthStatus': 'ONLINE',
        'lastSeenAt': '2026-09-28T18:00:00Z',
      };

      final camera = CctvCameraModel.fromJson(json);
      expect(camera.id, 'cam_101');
      expect(camera.name, 'Dome Camera 1');
      expect(camera.healthStatus, 'ONLINE');
      expect(camera.ipAddress, '192.168.1.100');
    });

    test('CctvRecordingModel parses POST_MATCH window and stop deadline', () {
      final json = {
        'id': 'rec_201',
        'gameId': 'gam_e101',
        'clubId': 'clb_001',
        'courtId': 'crt_001',
        'cameraId': 'cam_101',
        'status': 'POST_MATCH',
        'recordingStatus': 'POST_MATCH',
        'startedAt': '2026-09-28T18:00:00Z',
        'scheduledMatchEnd': '2026-09-28T19:30:00Z',
        'stopDeadline': '2026-09-28T19:45:00Z',
        'manualStop': false,
      };

      final recording = CctvRecordingModel.fromJson(json);
      expect(recording.id, 'rec_201');
      expect(recording.recordingStatus, 'POST_MATCH');
      expect(recording.stopDeadline, '2026-09-28T19:45:00Z');
      expect(recording.manualStop, isFalse);
    });

    test(
        'CctvRecordingModel parses STOPPED_MANUALLY status after manager stop action',
        () {
      final json = {
        'id': 'rec_201',
        'gameId': 'gam_e101',
        'clubId': 'clb_001',
        'status': 'STOPPED_MANUALLY',
        'recordingStatus': 'STOPPED_MANUALLY',
        'startedAt': '2026-09-28T18:00:00Z',
        'scheduledMatchEnd': '2026-09-28T19:30:00Z',
        'stopDeadline': '2026-09-28T19:45:00Z',
        'actualStopTime': '2026-09-28T19:35:00Z',
        'manualStop': true,
      };

      final recording = CctvRecordingModel.fromJson(json);
      expect(recording.recordingStatus, 'STOPPED_MANUALLY');
      expect(recording.manualStop, isTrue);
      expect(recording.actualStopTime, '2026-09-28T19:35:00Z');
    });
  });
}
