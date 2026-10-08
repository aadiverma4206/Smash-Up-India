import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/game_model.dart';
import 'package:all_stars_arena/data/models/court_model.dart';
import 'package:all_stars_arena/data/models/booking_model.dart';
import 'package:all_stars_arena/data/models/tournament_model.dart';
import 'package:all_stars_arena/data/models/leaderboard_model.dart';

void main() {
  group('ALL STARS ARENA Player Game Ecosystem Unit Tests', () {
    test('GameModel deserializes game details and roster correctly', () {
      final json = {
        'id': 'gam_e101',
        'title': 'Weekend 5v5 Match',
        'clubId': 'clb_001',
        'clubName': 'All Stars Turf Raipur',
        'courtName': 'Pitch 1',
        'matchDate': '2026-09-28',
        'startTime': '18:00:00',
        'endTime': '19:30:00',
        'status': 'OPEN_FOR_JOINING',
        'perPlayerFee': 150.0,
        'maxPlayers': 10,
        'currentPlayers': 2,
        'teamAScore': 0,
        'teamBScore': 0,
        'roster': [
          {'userId': 'usr_1', 'name': 'Player 1', 'team': 'TEAM_A', 'position': 'ST'},
          {'userId': 'usr_2', 'name': 'Player 2', 'team': 'TEAM_B', 'position': 'GK'},
        ],
      };

      final game = GameModel.fromJson(json);
      expect(game.id, 'gam_e101');
      expect(game.perPlayerFee, 150.0);
      expect(game.roster?.length, 2);
      expect(game.roster?.first.team, 'TEAM_A');
    });

    test('CourtModel and BookingModel parse price quotes accurately', () {
      final jsonCourt = {
        'id': 'crt_101',
        'clubId': 'clb_001',
        'clubName': 'Raipur Turf Club',
        'name': 'Pitch A',
        'surfaceType': 'TURF_GRASS',
        'basePricePerHour': 1200.0,
        'status': 'AVAILABLE',
        'city': 'Raipur',
        'address': 'VIP Road',
      };

      final court = CourtModel.fromJson(jsonCourt);
      expect(court.basePricePerHour, 1200.0);
      expect(court.surfaceType, 'TURF_GRASS');

      final jsonBooking = {
        'id': 'bkg_201',
        'courtId': 'crt_101',
        'courtName': 'Pitch A',
        'clubName': 'Raipur Turf Club',
        'bookingDate': '2026-09-28',
        'startTime': '20:00:00',
        'endTime': '21:00:00',
        'totalAmount': 1200.0,
        'status': 'CONFIRMED',
      };

      final booking = BookingModel.fromJson(jsonBooking);
      expect(booking.totalAmount, 1200.0);
      expect(booking.status, 'CONFIRMED');
    });

    test('TournamentModel and LeaderboardEntryModel deserialize correctly', () {
      final jsonTournament = {
        'id': 'tr_01',
        'title': 'Raipur Champions League 2026',
        'format': 'KNOCKOUT',
        'startDate': '2026-10-01',
        'endDate': '2026-10-05',
        'prizePool': 50000.0,
        'entryFee': 2000.0,
        'maxTeams': 16,
        'registeredTeamsCount': 8,
        'status': 'REGISTRATION_OPEN',
      };

      final tournament = TournamentModel.fromJson(jsonTournament);
      expect(tournament.prizePool, 50000.0);
      expect(tournament.registeredTeamsCount, 8);

      final jsonLeaderboard = {
        'rank': 1,
        'userId': 'usr_p1',
        'playerName': 'Top Striker',
        'city': 'Raipur',
        'ovr': 92,
        'matchesPlayed': 45,
        'matchesWon': 38,
        'goalsScored': 60,
      };

      final entry = LeaderboardEntryModel.fromJson(jsonLeaderboard);
      expect(entry.rank, 1);
      expect(entry.ovr, 92);
    });
  });
}
