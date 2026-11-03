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

  /// Paise as plain keypad input: 150000 → "1500", 150050 → "1500.50".
  static String inputOf(int paise) {
    final rupees = paise ~/ paisePerRupee;
    final rest = paise % paisePerRupee;
    return rest == 0 ? '$rupees' : '$rupees.${rest.toString().padLeft(2, '0')}';
  }

  /// Indian digit grouping for text being typed ("150000.5" → "1,50,000.5").
  static String groupInput(String input) {
    final dot = input.indexOf('.');
    final whole = dot < 0 ? input : input.substring(0, dot);
    final tail = dot < 0 ? '' : input.substring(dot);
    if (whole.length <= 3) return '$whole$tail';
    final last3 = whole.substring(whole.length - 3);
    var head = whole.substring(0, whole.length - 3);
    final parts = <String>[];
    while (head.length > 2) {
      parts.insert(0, head.substring(head.length - 2));
      head = head.substring(0, head.length - 2);
    }
    if (head.isNotEmpty) parts.insert(0, head);
    return '${parts.join(',')},$last3$tail';
  }

  /// Applies a percentage (basis points avoid floating error: 1250 = 12.5%)
  /// to [paise], rounding half up to the nearest paisa.
  static int percentOf(int paise, int basisPoints) {
    return (paise * basisPoints + 5000) ~/ 10000;
  }
}
