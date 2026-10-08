import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/data/models/manager_models.dart';

void main() {
  group('ALL STARS ARENA Manager Module Unit Tests', () {
    test('ManagerDashboardModel deserializes club analytics correctly', () {
      final json = {
        'club': {
          'id': 'clb_101',
          'name': 'All Stars Turf Raipur',
          'city': 'Raipur',
          'address': 'VIP Road',
          'status': 'ACTIVE',
        },
        'totalRevenue': 48500.0,
        'totalBookings': 32,
        'activeMatches': 3,
        'occupancyRatePercentage': 82.5,
        'onlineCctvCount': 4,
      };

      final dashboard = ManagerDashboardModel.fromJson(json);
      expect(dashboard.club.id, 'clb_101');
      expect(dashboard.club.name, 'All Stars Turf Raipur');
      expect(dashboard.totalRevenue, 48500.0);
      expect(dashboard.occupancyRatePercentage, 82.5);
      expect(dashboard.onlineCctvCount, 4);
    });

    test('ManagerClubModel parses assigned club scoping details', () {
      final json = {
        'id': 'clb_102',
        'name': 'Raipur Turf Club',
        'city': 'Raipur',
        'address': 'Telibandha',
        'status': 'ACTIVE',
      };

      final club = ManagerClubModel.fromJson(json);
      expect(club.id, 'clb_102');
      expect(club.status, 'ACTIVE');
    });
  });
}
