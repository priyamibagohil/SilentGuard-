// Time utility functions for SilentGuard+
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  /// Check if current time falls within a given range.
  /// Handles overnight ranges (e.g., 22:00 - 06:00).
  static bool isTimeInRange(TimeOfDay start, TimeOfDay end) {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      // Normal range (e.g., 08:00 - 17:00)
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    } else {
      // Overnight range (e.g., 22:00 - 06:00)
      return nowMinutes >= startMinutes || nowMinutes < endMinutes;
    }
  }

  /// Check if today's weekday index (0=Mon..6=Sun) is in the list.
  static bool isTodayInDays(List<int> days) {
    if (days.isEmpty) return false;
    final today = DateTime.now().weekday - 1; // weekday: 1=Mon..7=Sun → 0..6
    return days.contains(today);
  }

  /// Format TimeOfDay to "HH:mm" string.
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format TimeOfDay to "h:mm AM/PM" string.
  static String formatTimeOfDayAmPm(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  /// Parse "HH:mm" string to TimeOfDay.
  static TimeOfDay parseTimeOfDay(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Get a human-readable duration string between two TimeOfDay values.
  static String getDuration(TimeOfDay start, TimeOfDay end) {
    int startMins = start.hour * 60 + start.minute;
    int endMins = end.hour * 60 + end.minute;
    if (endMins < startMins) endMins += 24 * 60;
    final diff = endMins - startMins;
    final hours = diff ~/ 60;
    final mins = diff % 60;
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  /// Format DateTime to readable string.
  static String formatDateTime(DateTime dt) {
    return DateFormat('MMM d, yyyy • h:mm a').format(dt);
  }

  /// Format DateTime to date only.
  static String formatDate(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year && dt.month == yesterday.month && dt.day == yesterday.day) {
      return 'Yesterday';
    }
    return DateFormat('MMM d, yyyy').format(dt);
  }

  /// Get day abbreviations for selected days.
  static String getDaysLabel(List<int> days) {
    if (days.isEmpty) return 'No days selected';
    if (days.length == 7) return 'Every day';
    if (days.length == 5 && !days.contains(5) && !days.contains(6)) return 'Weekdays';
    if (days.length == 2 && days.contains(5) && days.contains(6)) return 'Weekends';
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final sorted = List<int>.from(days)..sort();
    return sorted.map((d) => names[d]).join(', ');
  }
}
