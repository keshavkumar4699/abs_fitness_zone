import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/phone.dart';
import '../../../core/utils/phone_input.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../data/gym_settings_repository.dart';

/// Owner: gym name, contact, UPI ID, GSTIN and the member rules.
class GymProfileScreen extends ConsumerWidget {
  const GymProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(gymSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.gymProfileTitle)),
      body: AsyncView<GymSettings>(
        value: settings,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(gymSettingsProvider),
        data: (s) => _Form(settings: s),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.settings});

  final GymSettings settings;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.settings.gymName);
  late final _phone = TextEditingController(
    text: widget.settings.text('gym_phone').isEmpty ? '' : Phone.local(widget.settings.text('gym_phone')),
  );
  late final _address = TextEditingController(text: widget.settings.text('gym_address'));
  late final _upi = TextEditingController(text: widget.settings.upiId);
  late final _gstin = TextEditingController(text: widget.settings.text('gstin'));
  late final _window = TextEditingController(text: '${widget.settings.expiringWindowDays}');
  late final _absent = TextEditingController(text: '${widget.settings.absentDays}');
  late String _lapsed = widget.settings.lapsedRenewFrom;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _address, _upi, _gstin, _window, _absent]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    final l = context.l10n;
    setState(() => _busy = true);
    String? blank(String s) => s.trim().isEmpty ? null : s.trim();
    try {
      await ref.read(gymSettingsRepositoryProvider).save({
        'gym_name': _name.text.trim(),
        'gym_phone': _phone.text.trim().isEmpty ? null : Phone.normalize(_phone.text),
        'gym_address': blank(_address.text),
        'upi_id': blank(_upi.text)?.toLowerCase(),
        'gstin': blank(_gstin.text)?.toUpperCase(),
        'expiring_window_days': int.parse(_window.text.trim()),
        'absent_days': int.parse(_absent.text.trim()),
        'lapsed_renew_from': _lapsed,
      });
      ref
        ..invalidate(gymSettingsProvider)
        ..invalidate(publicGymProfileProvider);
      if (!mounted) return;
      showAbsSnackbar(context, l.saved, tone: SnackTone.success);
      context.pop();
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = Validators(l);
    const gap = SizedBox(height: AbsSpace.x4);
    String? days(String? s) {
      final n = int.tryParse(s?.trim() ?? '');
      return n == null || n < 1 || n > 60 ? l.commonRequired : null;
    }

    return Form(
      key: _form,
      child: ListView(
        padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x10),
        children: [
          AbsTextField(label: l.fieldGymName, controller: _name, validator: v.required),
          gap,
          AbsTextField(
            label: l.fieldGymPhone,
            controller: _phone,
            prefixText: '+91',
            numeric: true,
            keyboardType: TextInputType.phone,
            inputFormatters: const [IndianMobileInputFormatter()],
            validator: (s) => (s == null || s.isEmpty) ? null : v.phone(s),
          ),
          gap,
          AbsTextField(label: l.fieldGymAddress, controller: _address),
          gap,
          AbsTextField(
            label: l.fieldUpi,
            controller: _upi,
            validator: (s) =>
                (s == null || s.trim().isEmpty || RegExp(r'^[\w.\-]{2,}@[a-zA-Z]{2,}$').hasMatch(s.trim()))
                ? null
                : l.commonRequired,
          ),
          gap,
          AbsTextField(
            label: l.fieldGstin,
            controller: _gstin,
            inputFormatters: [LengthLimitingTextInputFormatter(15)],
            validator: (s) => (s == null || s.trim().isEmpty || s.trim().length == 15) ? null : l.commonRequired,
          ),
          const SizedBox(height: AbsSpace.x6),
          Text(l.rulesTitle, style: context.text.title),
          gap,
          AbsTextField(
            label: l.fieldExpiringWindow,
            controller: _window,
            numeric: true,
            keyboardType: TextInputType.number,
            validator: days,
          ),
          gap,
          AbsTextField(
            label: l.fieldAbsentDays,
            controller: _absent,
            numeric: true,
            keyboardType: TextInputType.number,
            validator: days,
          ),
          gap,
          Text(l.fieldLapsedRenew, style: context.text.label),
          const SizedBox(height: AbsSpace.x2),
          SegmentedTabs(
            hue: PopHue.grape,
            labels: [l.lapsedToday, l.lapsedEnd],
            selected: _lapsed == 'end' ? 1 : 0,
            onChanged: (i) => setState(() => _lapsed = i == 1 ? 'end' : 'today'),
          ),
          const SizedBox(height: AbsSpace.x6),
          AbsButton(label: l.commonSave, hue: PopHue.grape, isLoading: _busy, onPressed: _save),
        ],
      ),
    );
  }
}
