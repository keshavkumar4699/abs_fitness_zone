import 'package:url_launcher/url_launcher.dart';

import '../utils/phone.dart';

/// Free-mode WhatsApp and phone links (F8 free mode, F7 one-tap call).
abstract final class ContactLinks {
  /// https://wa.me/919876543210?text=… opens the gym's WhatsApp with the
  /// message pre-filled; staff press send.
  static Uri whatsapp(String phone, {String? text}) {
    final digits = (Phone.normalize(phone) ?? phone).replaceAll(RegExp(r'\D'), '');
    return Uri.https('wa.me', '/$digits', text == null || text.isEmpty ? null : {'text': text});
  }

  static Uri call(String phone) => Uri(scheme: 'tel', path: Phone.normalize(phone) ?? phone);

  static Future<bool> openWhatsApp(String phone, {String? text}) =>
      launchUrl(whatsapp(phone, text: text), mode: LaunchMode.externalApplication);

  static Future<bool> openCall(String phone) => launchUrl(call(phone));
}
