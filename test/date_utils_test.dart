import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:all_stars_arena/core/utils/app_date_utils.dart';

void main() {
  group('AppDateUtils Unit Tests', () {
    test('parseDate handles various date string formats and types', () {
      final isoDate = AppDateUtils.parseDate('2025-05-15T18:30:00.000Z');
      expect(isoDate, isNotNull);
      expect(isoDate!.year, 2025);
      expect(isoDate.month, 5);

      final simpleDate = AppDateUtils.parseDate('2025-05-15');
      expect(simpleDate, isNotNull);
      expect(simpleDate!.year, 2025);
      expect(simpleDate.month, 5);
      expect(simpleDate.day, 15);

      final epochMillis = DateTime(2025, 5, 15, 10, 0).millisecondsSinceEpoch;
      final fromInt = AppDateUtils.parseDate(epochMillis);
      expect(fromInt, isNotNull);
      expect(fromInt!.year, 2025);

      expect(AppDateUtils.parseDate(null), isNull);
      expect(AppDateUtils.parseDate(''), isNull);
      expect(AppDateUtils.parseDate('invalid-date'), isNull);
    });

    test('parseTimeOfDay parses 24h, 12h, and TimeOfDay inputs', () {
      final t24 = AppDateUtils.parseTimeOfDay('18:30');
      expect(t24, isNotNull);
      expect(t24!.hour, 18);
      expect(t24.minute, 30);

      final t24Sec = AppDateUtils.parseTimeOfDay('18:30:00');
      expect(t24Sec, isNotNull);
      expect(t24Sec!.hour, 18);

      final t12Pm = AppDateUtils.parseTimeOfDay('06:30 PM');
      expect(t12Pm, isNotNull);
      expect(t12Pm!.hour, 18);

      final t12Am = AppDateUtils.parseTimeOfDay('12:15 AM');
      expect(t12Am, isNotNull);
      expect(t12Am!.hour, 0);
      expect(t12Am.minute, 15);

      const tod = TimeOfDay(hour: 14, minute: 45);
      expect(AppDateUtils.parseTimeOfDay(tod), tod);
      expect(AppDateUtils.parseTimeOfDay(null), isNull);
    });

    test('parseMatchDateTime combines matchDate and startTime safely', () {
      final combined = AppDateUtils.parseMatchDateTime(
          '2025-05-15T00:00:00.000Z', '18:00:00');
      expect(combined, isNotNull);
      expect(combined!.year, 2025);
      expect(combined.month, 5);
      expect(combined.day, 15);
      expect(combined.hour, 18);
      expect(combined.minute, 0);

      final combined12h =
          AppDateUtils.parseMatchDateTime('2025-05-15', '6:30 PM');
      expect(combined12h, isNotNull);
      expect(combined12h!.hour, 18);
      expect(combined12h.minute, 30);

      final dateOnly = AppDateUtils.parseMatchDateTime('2025-05-15', null);
      expect(dateOnly, isNotNull);
      expect(dateOnly!.year, 2025);
      expect(dateOnly.hour, 0);
    });

    test('formatDate produces clean user-friendly date strings', () {
      expect(
        AppDateUtils.formatDate('2025-05-15T00:00:00.000Z'),
        contains('May 2025'),
      );
      expect(
        AppDateUtils.formatDate('2025-05-15', format: 'EEEE, dd MMMM yyyy'),
        contains('May 2025'),
      );
      expect(AppDateUtils.formatDate(null, fallback: 'N/A'), 'N/A');
    });

    test('formatTime and formatTimeRange work as expected', () {
      expect(AppDateUtils.formatTime('18:00:00'), '6:00 PM');
      expect(AppDateUtils.formatTime('09:05'), '9:05 AM');

      expect(
        AppDateUtils.formatTimeRange('18:00', '19:30'),
        '6:00 PM - 7:30 PM',
      );
      expect(
        AppDateUtils.formatTimeRange(null, null, fallback: 'TBD'),
        'TBD',
      );
    });

    test('formatRelativeTime formats past times accurately', () {
      final now = DateTime.now();
      expect(AppDateUtils.formatRelativeTime(now), 'Just now');

      final minAgo = now.subtract(const Duration(minutes: 5));
      expect(AppDateUtils.formatRelativeTime(minAgo), '5 mins ago');

      final hrsAgo = now.subtract(const Duration(hours: 3));
      expect(AppDateUtils.formatRelativeTime(hrsAgo), '3 hours ago');

      final daysAgo = now.subtract(const Duration(days: 2));
      expect(AppDateUtils.formatRelativeTime(daysAgo), '2 days ago');
    });

    test('calculateMatchStartAndEnd supports overnight matches', () {
      final baseDate = DateTime(2025, 5, 15);
      const start = TimeOfDay(hour: 23, minute: 0);
      const end = TimeOfDay(hour: 1, minute: 0);

      final times =
          AppDateUtils.calculateMatchStartAndEnd(baseDate, start, end);
      expect(times['start']!.day, 15);
      expect(times['end']!.day, 16); // Crosses midnight to next day
      expect(times['end']!.isAfter(times['start']!), isTrue);
    });

    test('formatIsoDate and format24HourTime format correctly', () {
      final dt = DateTime(2025, 5, 15);
      expect(AppDateUtils.formatIsoDate(dt), '2025-05-15');

      const tod = TimeOfDay(hour: 18, minute: 30);
      expect(AppDateUtils.format24HourTime(tod), '18:30:00');
    });
  });
}
