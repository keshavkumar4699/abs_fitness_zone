import '../app/l10n/l10n.dart';
import 'utils/phone.dart';

/// Form validators with localised messages.
class Validators {
  const Validators(this.l);

  final AppLocalizations l;

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? required(String? v) => (v == null || v.trim().isEmpty) ? l.commonRequired : null;

  String? email(String? v) => (v != null && _email.hasMatch(v.trim())) ? null : l.validationEmail;

  String? phone(String? v) => (v != null && Phone.isValid(v)) ? null : l.validationPhone;
}
