import 'package:intl/intl.dart';

/// Money is always stored and passed around as integer paise (spec rule 6).
/// These helpers are the only place rupees ↔ paise conversion happens.
abstract final class Money {
  static const paisePerRupee = 100;

  static final _whole = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final _exact = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  static final _compact = NumberFormat.compactCurrency(locale: 'en_IN', symbol: '₹', decimalDigits: 1);

  /// ₹1,23,456 (whole rupees) or ₹1,23,456.50 when there are paise.
  static String format(int paise) {
    if (paise % paisePerRupee == 0) return _whole.format(paise ~/ paisePerRupee);
    return _exact.format(paise / paisePerRupee);
  }

  /// ₹1.2L style for tight spaces such as chart axes.
  static String compact(int paise) => _compact.format(paise / paisePerRupee);

  /// Parses user input like "1,250", "₹ 1250.5" or "1250.50" into paise.
  /// Returns null when the text is not a valid non-negative amount with at
  /// most two decimal places.
  static int? parse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[₹,\s]'), '');
    if (cleaned.isEmpty) return null;
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(cleaned);
    if (match == null) return null;
    final rupees = int.parse(match.group(1)!);
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    return rupees * paisePerRupee + int.parse(fraction);
  }

  /// Applies a percentage (basis points avoid floating error: 1250 = 12.5%)
  /// to [paise], rounding half up to the nearest paisa.
  static int percentOf(int paise, int basisPoints) {
    return (paise * basisPoints + 5000) ~/ 10000;
  }
}
