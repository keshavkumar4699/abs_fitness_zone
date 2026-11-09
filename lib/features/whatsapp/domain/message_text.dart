/// Template text helpers. [renderMessage] matches the database's `_render`
/// exactly, so the preview shows what members receive.
library;

final _variable = RegExp(r'\{([a-z_]+)\}');

/// Fills `{name}`-style variables; any variable without a value is dropped.
String renderMessage(String body, Map<String, String> vars) {
  var out = body;
  for (final e in vars.entries) {
    out = out.replaceAll('{${e.key}}', e.value);
  }
  return out.replaceAll(_variable, '');
}

/// The variables a template uses, in order (Meta's {{1}}, {{2}}, …).
List<String> messageVariables(String body) => [for (final m in _variable.allMatches(body)) m.group(1)!];

/// The template body in Meta's numbered form, for registering it in
/// WhatsApp Manager (API mode).
String metaTemplateBody(String body) {
  var i = 0;
  return body.replaceAllMapped(_variable, (_) => '{{${++i}}}');
}

/// Variables offered as chips in the editors, per template key (8.1).
const kMessageVariables = <String, List<String>>{
  'expiry_soon': ['first_name', 'plan', 'end_date', 'days', 'gym_name'],
  'expiry_today': ['first_name', 'plan', 'gym_name'],
  'expired': ['first_name', 'plan', 'end_date', 'gym_name'],
  'dues_reminder': ['first_name', 'amount', 'invoice_no', 'due_date', 'pay_link', 'gym_name'],
  'dues_reminder_desk': ['first_name', 'amount', 'invoice_no', 'due_date', 'gym_name'],
  'payment_received': ['first_name', 'amount', 'receipt_no', 'gym_name'],
  'membership_started': ['first_name', 'plan', 'start_date', 'end_date', 'gym_name'],
  'membership_renewed': ['first_name', 'plan', 'end_date', 'gym_name'],
  'program_assigned': ['first_name', 'gym_name'],
  'diet_assigned': ['first_name', 'gym_name'],
  'birthday': ['first_name', 'gym_name'],
  'festival': ['festival', 'first_name', 'gym_name'],
};

/// Broadcasts know only the member and the gym.
const kBroadcastVariables = ['first_name', 'name', 'gym_name', 'gym_phone'];

/// Sample values for previews ("preview with a sample member", 8.1).
Map<String, String> sampleVariables({required String firstName, required String gym, String plan = 'Quarterly'}) => {
  'first_name': firstName,
  'name': '$firstName Sharma',
  'gym_name': gym,
  'gym_phone': '+91 98765 43210',
  'plan': plan,
  'end_date': '10 Nov 2026',
  'start_date': '10 Aug 2026',
  'days': '7',
  'amount': '₹2,500',
  'invoice_no': 'INV-0042',
  'due_date': '5 Nov 2026',
  'pay_link': 'upi://pay?pa=gym@upi&am=2500.00&cu=INR',
  'receipt_no': 'RCP-0042',
  'festival': 'Diwali',
};
