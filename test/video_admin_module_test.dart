import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/admin_models.dart';
import 'package:all_stars_arena/data/models/video_model.dart';

void main() {
  group('ALL STARS ARENA Video & Admin Module Unit Tests', () {
    test('AdminDashboardModel deserializes platform analytics correctly', () {
      final json = {
        'totalUsers': 1250,
        'totalManagers': 15,
        'totalPlayers': 1235,
        'totalClubs': 8,
        'totalRevenue': 345000.0,
        'totalRefunds': 2500.0,
        'pendingDisputes': 2,
        'activeRecordings': 4,
        'onlineCameras': 16,
      };

      final admin = AdminDashboardModel.fromJson(json);
      expect(admin.totalUsers, 1250);
      expect(admin.totalRevenue, 345000.0);
      expect(admin.pendingDisputes, 2);
      expect(admin.onlineCameras, 16);
    });

    test('AdminUserModel deserializes user roles and statuses', () {
      final json = {
        'id': 'usr_m201',
        'name': 'Turf Manager One',
        'email': 'mgr1@example.com',
        'phone': '+919876543210',
        'roleId': 2,
        'roleName': 'MANAGER',
        'status': 'ACTIVE',
        'createdAt': '2026-09-28T18:00:00Z',
      };

      final user = AdminUserModel.fromJson(json);
      expect(user.id, 'usr_m201');
      expect(user.roleName, 'MANAGER');
      expect(user.status, 'ACTIVE');
    });

    test('VideoModel deserializes short-lived signed S3 playback URL securely',
        () {
      final json = {
        'id': 'vid_501',
        'gameId': 'gam_e101',
        'title': 'Weekend Match Final',
        'clubName': 'All Stars Turf Raipur',
        'courtName': 'Pitch 1',
        'matchDate': '2026-09-28',
        'playbackUrl':
            'https://all-stars-arena-recordings.s3.ap-south-1.amazonaws.com/recordings/test.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA...',
        'durationSeconds': 5400,
      };

      final video = VideoModel.fromJson(json);
      expect(video.id, 'vid_501');
      expect(video.playbackUrl, contains('X-Amz-Algorithm'));
      expect(video.playbackUrl, isNot(contains('secretKey')));
    });
  });
}
