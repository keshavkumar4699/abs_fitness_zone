import 'package:flutter/services.dart';

/// Keeps a "+91" phone field to exactly the 10 local digits, even when people
/// type or paste "+91 98765 43210", "919876543210" or "09876543210".
class IndianMobileInputFormatter extends TextInputFormatter {
  const IndianMobileInputFormatter();

  static String clean(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10 && digits.startsWith('91')) digits = digits.substring(2);
    if (digits.length > 10 && digits.startsWith('0')) digits = digits.substring(1);
    return digits.length > 10 ? digits.substring(0, 10) : digits;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final cleaned = clean(newValue.text);
    if (cleaned == newValue.text) return newValue;
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}
