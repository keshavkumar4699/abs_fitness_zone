/// UPI "pay" deep link (free mode, F2 2.3): opens the member's UPI app with
/// the gym's UPI ID, amount and invoice number filled in.
abstract final class UpiLink {
  static final _vpa = RegExp(r'^[\w.\-]{2,256}@[a-zA-Z][a-zA-Z0-9]{1,63}$');

  static bool isValidVpa(String vpa) => _vpa.hasMatch(vpa.trim());

  /// upi://pay?pa=gym@bank&pn=ABS%20Fitness&am=1500.00&cu=INR&tn=ABS%2F26-27%2F0001&tr=...
  ///
  /// Spaces are encoded as %20 (some UPI apps mis-read "+").
  static String build({
    required String vpa,
    required String payeeName,
    required int amountPaise,
    required String note,
    String? reference,
  }) {
    if (!isValidVpa(vpa)) throw ArgumentError.value(vpa, 'vpa', 'not a UPI ID');
    if (amountPaise <= 0) throw ArgumentError.value(amountPaise, 'amountPaise');
    final rupees = '${amountPaise ~/ 100}.${(amountPaise % 100).toString().padLeft(2, '0')}';
    final params = <String, String>{
      'pa': vpa.trim(),
      'pn': payeeName.trim().isEmpty ? 'ABS Fitness' : payeeName.trim(),
      'am': rupees,
      'cu': 'INR',
      'tn': note.length > 50 ? note.substring(0, 50) : note,
      if (reference != null && reference.isNotEmpty) 'tr': reference.replaceAll(RegExp(r'[^A-Za-z0-9]'), ''),
    };
    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    return 'upi://pay?$query';
  }
}
