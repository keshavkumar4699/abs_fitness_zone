/// Indian mobile numbers, stored as E.164 (+91XXXXXXXXXX).
abstract final class Phone {
  static final _mobile = RegExp(r'^[6-9]\d{9}$');

  /// Normalises "98765 43210", "+91-98765-43210", "09876543210" or
  /// "919876543210" to "+919876543210". Returns null if it is not a valid
  /// Indian mobile number.
  static String? normalize(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 12 && digits.startsWith('91')) {
      digits = digits.substring(2);
    } else if (digits.length == 11 && digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (!_mobile.hasMatch(digits)) return null;
    return '+91$digits';
  }

  static bool isValid(String input) => normalize(input) != null;

  /// "+91 98765 43210" for display.
  static String display(String e164) {
    final n = normalize(e164);
    if (n == null) return e164;
    final d = n.substring(3);
    return '+91 ${d.substring(0, 5)} ${d.substring(5)}';
  }

  /// The ten local digits, for prefilled "+91" fields.
  static String local(String e164) => normalize(e164)?.substring(3) ?? e164;
}
