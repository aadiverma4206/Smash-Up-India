import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/player_profile_model.dart';
import 'package:all_stars_arena/data/models/player_stats_model.dart';
import 'package:all_stars_arena/data/models/notification_model.dart';

void main() {
  group('ALL STARS ARENA Player Foundation Module Tests', () {
    test('PlayerProfileModel parses correctly with default OVR 75', () {
      final json = {
        'userId': 'usr_p101',
        'name': 'Ronaldo Nazario',
        'email': 'r9@example.com',
        'phone': '+919876543210',
        'city': 'Raipur',
        'position': 'ST',
        'preferredFoot': 'RIGHT',
        'skillLevel': 'PRO',
        'ovr': 92,
      };

      final profile = PlayerProfileModel.fromJson(json);
      expect(profile.name, 'Ronaldo Nazario');
      expect(profile.position, 'ST');
      expect(profile.ovr, 92);
      expect(profile.skillLevel, 'PRO');
    });

    test('PlayerStatsModel calculates win rate percentage correctly', () {
      final stats = PlayerStatsModel(
        matchesPlayed: 10,
        matchesWon: 7,
        matchesLost: 2,
        matchesDrawn: 1,
        goalsScored: 12,
        assists: 5,
        motmCount: 4,
        winRatePercentage: 70.0,
      );

      expect(stats.matchesPlayed, 10);
      expect(stats.winRatePercentage, 70.0);
      expect(stats.motmCount, 4);
    });

    test('NotificationModel parses notification item correctly', () {
      final json = {
        'id': 'notif_001',
        'title': 'Match Starting Soon',
        'body': 'Your pickup match starts in 15 minutes at Court 1',
        'type': 'MATCH_STARTING',
        'data': {'gameId': 'gam_101', 'link': '/games/gam_101'},
        'isRead': false,
        'createdAt': '2026-09-28T18:00:00Z',
      };

      final notif = NotificationModel.fromJson(json);
      expect(notif.id, 'notif_001');
      expect(notif.type, 'MATCH_STARTING');
      expect(notif.isRead, isFalse);
      expect(notif.data?['gameId'], 'gam_101');
    });
  });
}
