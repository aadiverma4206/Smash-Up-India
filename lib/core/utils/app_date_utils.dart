import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Central utility class for robust date and time parsing, formatting, and validation across the app.
class AppDateUtils {
  AppDateUtils._();

  /// Parses any input (DateTime, String, int timestamp) safely into a local [DateTime].
  /// Returns `null` if the input cannot be parsed.
  static DateTime? parseDate(dynamic input) {
    if (input == null) return null;
    if (input is DateTime) return input.toLocal();
    if (input is int) {
      return DateTime.fromMillisecondsSinceEpoch(input).toLocal();
    }
    if (input is double) {
      return DateTime.fromMillisecondsSinceEpoch(input.toInt()).toLocal();
    }

    if (input is String) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) return null;

      // Try standard DateTime parsing (ISO-8601, etc.)
      final direct = DateTime.tryParse(trimmed);
      if (direct != null) return direct.toLocal();

      // Common custom format matchers
      final formats = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm',
        'yyyy-MM-dd',
        'dd-MM-yyyy HH:mm:ss',
        'dd-MM-yyyy HH:mm',
        'dd-MM-yyyy',
        'dd/MM/yyyy HH:mm:ss',
        'dd/MM/yyyy HH:mm',
        'dd/MM/yyyy',
        'yyyy/MM/dd HH:mm:ss',
        'yyyy/MM/dd HH:mm',
        'yyyy/MM/dd',
        'EEE, dd MMM yyyy',
        'dd MMM yyyy',
      ];

      for (final fmt in formats) {
        try {
          final dt = DateFormat(fmt).parseStrict(trimmed);
          return dt;
        } catch (_) {}
      }
    }

    return null;
  }

  /// Parses a time string (e.g., "18:00", "18:00:00", "6:00 PM", "06:30 AM") or [DateTime]/[TimeOfDay]
  /// safely into a [TimeOfDay]. Returns `null` if parsing fails.
  static TimeOfDay? parseTimeOfDay(dynamic input) {
    if (input == null) return null;
    if (input is TimeOfDay) return input;
    if (input is DateTime) {
      return TimeOfDay(hour: input.hour, minute: input.minute);
    }

    if (input is String) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) return null;

      // Check regex for HH:mm or HH:mm:ss or h:mm a
      final timeRegex = RegExp(
        r'^(\d{1,2}):(\d{2})(?::\d{2})?(?:\.\d+)?(?:\s*([AaPp][Mm]))?$',
      );
      final match = timeRegex.firstMatch(trimmed);

      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final ampm = match.group(3)?.toUpperCase();

        if (ampm != null) {
          if (ampm == 'PM' && hour < 12) hour += 12;
          if (ampm == 'AM' && hour == 12) hour = 0;
        }

        if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }

      // Try DateFormat time parsing
      final timeFormats = [
        'HH:mm:ss',
        'HH:mm',
        'h:mm a',
        'hh:mm a',
        'h:mma',
        'hh:mma',
      ];

      for (final fmt in timeFormats) {
        try {
          final dt = DateFormat(fmt).parseStrict(trimmed);
          return TimeOfDay(hour: dt.hour, minute: dt.minute);
        } catch (_) {}
      }
    }

    return null;
  }

  /// Safely combines [matchDate] (ISO string, date string, or DateTime) and
  /// [startTime] (time string or TimeOfDay) into a single [DateTime].
  static DateTime? parseMatchDateTime(dynamic matchDate, dynamic startTime) {
    if (matchDate == null) return null;

    final dateObj = parseDate(matchDate);
    if (dateObj == null) return null;

    if (startTime == null ||
        (startTime is String && startTime.trim().isEmpty)) {
      return DateTime(dateObj.year, dateObj.month, dateObj.day);
    }

    final timeObj = parseTimeOfDay(startTime);
    if (timeObj == null) {
      return DateTime(dateObj.year, dateObj.month, dateObj.day);
    }

    return DateTime(
      dateObj.year,
      dateObj.month,
      dateObj.day,
      timeObj.hour,
      timeObj.minute,
    );
  }

  /// Formats a date into a clean string (default: "EEE, dd MMM yyyy").
  /// Returns [fallback] if [input] is invalid/null.
  static String formatDate(
    dynamic input, {
    String format = 'EEE, dd MMM yyyy',
    String fallback = 'TBD',
  }) {
    if (input == null) return fallback;
    final dt = parseDate(input);
    if (dt == null) {
      if (input is String && input.trim().isNotEmpty) return input.trim();
      return fallback;
    }
    try {
      return DateFormat(format).format(dt);
    } catch (_) {
      return fallback;
    }
  }

  /// Formats a time into 12-hour format with AM/PM (default: "h:mm a").
  /// Returns [fallback] if [input] is invalid/null.
  static String formatTime(
    dynamic input, {
    String format = 'h:mm a',
    String fallback = '',
  }) {
    if (input == null) return fallback;
    final time = parseTimeOfDay(input);
    if (time == null) {
      if (input is String && input.trim().isNotEmpty) return input.trim();
      return fallback;
    }
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    try {
      return DateFormat(format).format(dt);
    } catch (_) {
      return fallback;
    }
  }

  /// Formats a start and end time range (e.g. "6:00 PM - 7:30 PM").
  static String formatTimeRange(
    dynamic startTime,
    dynamic endTime, {
    String fallback = 'Time TBD',
  }) {
    final startStr = formatTime(startTime);
    final endStr = formatTime(endTime);

    if (startStr.isNotEmpty && endStr.isNotEmpty) {
      return '$startStr - $endStr';
    } else if (startStr.isNotEmpty) {
      return startStr;
    } else if (endStr.isNotEmpty) {
      return endStr;
    }

    return fallback;
  }

  /// Formats full date & time (default: "dd MMM yyyy, h:mm a").
  static String formatDateTime(
    dynamic input, {
    String format = 'dd MMM yyyy, h:mm a',
    String fallback = 'TBD',
  }) {
    if (input == null) return fallback;
    final dt = parseDate(input);
    if (dt == null) {
      if (input is String && input.trim().isNotEmpty) return input.trim();
      return fallback;
    }
    try {
      return DateFormat(format).format(dt);
    } catch (_) {
      return fallback;
    }
  }

  /// Formats relative time / ago string (e.g. "Just now", "5 mins ago", "2 hours ago", "Yesterday").
  static String formatRelativeTime(
    dynamic input, {
    String fallback = 'Just now',
  }) {
    if (input == null) return fallback;
    final dt = parseDate(input);
    if (dt == null) return fallback;

    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.isNegative) {
      return formatDate(dt);
    }

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      final mins = diff.inMinutes;
      return '$mins ${mins == 1 ? 'min' : 'mins'} ago';
    } else if (diff.inHours < 24) {
      final hrs = diff.inHours;
      return '$hrs ${hrs == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays < 7) {
      final days = diff.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('dd MMM yyyy').format(dt);
    }
  }

  /// Formats a [DateTime] object to ISO date string "yyyy-MM-dd".
  static String formatIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats a [TimeOfDay] object to 24-hour time string "HH:mm:ss".
  static String format24HourTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  /// Checks if a match start time is in the past.
  static bool isMatchInPast(dynamic matchDate, dynamic startTime) {
    final matchStart = parseMatchDateTime(matchDate, startTime);
    if (matchStart == null) return false;
    return DateTime.now().isAfter(matchStart);
  }

  /// Checks if a match start time is in the future.
  static bool isMatchInFuture(dynamic matchDate, dynamic startTime) {
    final matchStart = parseMatchDateTime(matchDate, startTime);
    if (matchStart == null) return true;
    return DateTime.now().isBefore(matchStart);
  }

  /// Calculates start and end [DateTime] for a match given [selectedDate], [start], and [end].
  /// Handles overnight matches (e.g., 11:00 PM to 1:00 AM) automatically.
  static Map<String, DateTime> calculateMatchStartAndEnd(
    DateTime selectedDate,
    TimeOfDay start,
    TimeOfDay end,
  ) {
    final matchStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      start.hour,
      start.minute,
    );

    var matchEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      end.hour,
      end.minute,
    );

    // If end time is earlier or equal to start time, assume match ends next day
    if (!matchEnd.isAfter(matchStart)) {
      matchEnd = matchEnd.add(const Duration(days: 1));
    }

    return {
      'start': matchStart,
      'end': matchEnd,
    };
  }

  /// Validates game start & end time. Returns an error message if invalid, or `null` if valid.
  static String? validateGameTimes(
    DateTime selectedDate,
    TimeOfDay start,
    TimeOfDay end,
  ) {
    final times = calculateMatchStartAndEnd(selectedDate, start, end);
    final matchStart = times['start']!;
    final matchEnd = times['end']!;
    final now = DateTime.now();

    if (matchStart.isBefore(now)) {
      return 'Match start time cannot be in the past';
    }

    if (!matchEnd.isAfter(matchStart)) {
      return 'Match end time must be after start time';
    }

    return null;
  }
}
