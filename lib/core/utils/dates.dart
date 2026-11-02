import 'package:intl/intl.dart';

/// Timestamps are stored in UTC and displayed in Asia/Kolkata (spec rule 6).
/// India has no daylight saving, so IST is a fixed UTC+05:30 offset.
abstract final class IstDates {
  static const offset = Duration(hours: 5, minutes: 30);

  /// Wall-clock IST for an instant. The returned value is a UTC-flagged
  /// DateTime whose fields read as IST, so it never shifts with the device
  /// time zone.
  static DateTime toIst(DateTime instant) => instant.toUtc().add(offset);

  /// The IST calendar date (midnight, UTC-flagged) for an instant.
  static DateTime istDate(DateTime instant) {
    final ist = toIst(instant);
    return DateTime.utc(ist.year, ist.month, ist.day);
  }

  /// Today's IST date.
  static DateTime today({DateTime? now}) => istDate(now ?? DateTime.now());

  /// Whole days from IST today until [date] (negative when in the past).
  static int daysUntil(DateTime date, {DateTime? now}) {
    final target = DateTime.utc(date.year, date.month, date.day);
    return target.difference(today(now: now)).inDays;
  }

  /// "2 Nov 2026"
  static String formatDate(DateTime instantOrDate, {String locale = 'en_US', bool isDateOnly = false}) {
    final d = isDateOnly ? instantOrDate : toIst(instantOrDate);
    return DateFormat('d MMM yyyy', locale).format(d);
  }

  /// "2 Nov, 6:45 pm"
  static String formatDateTime(DateTime instant, {String locale = 'en_US'}) {
    return DateFormat('d MMM, h:mm a', locale).format(toIst(instant)).replaceAll('AM', 'am').replaceAll('PM', 'pm');
  }

  /// "6:45 pm"
  static String formatTime(DateTime instant, {String locale = 'en_US'}) {
    return DateFormat('h:mm a', locale).format(toIst(instant)).replaceAll('AM', 'am').replaceAll('PM', 'pm');
  }
}
