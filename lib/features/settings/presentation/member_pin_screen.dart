import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../data/member_pin_repository.dart';

/// Front desk / owner: find a member by phone and set their 4-digit app PIN.
class MemberPinScreen extends ConsumerStatefulWidget {
  const MemberPinScreen({super.key});

  @override
  ConsumerState<MemberPinScreen> createState() => _MemberPinScreenState();
}

class _MemberPinScreenState extends ConsumerState<MemberPinScreen> {
  final _findForm = GlobalKey<FormState>();
  final _pinForm = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  MemberLookup? _member;
  bool _busy = false;
  bool _done = false;

  @override
  void dispose() {
    _phone.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _find() async {
    if (!_findForm.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _member = null;
      _done = false;
    });
    try {
      final m = await ref.read(memberPinRepositoryProvider).findByPhone(_phone.text);
      if (mounted) setState(() => _member = m);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setPin() async {
    final m = _member;
    if (m == null || !_pinForm.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(memberPinRepositoryProvider).setPin(memberId: m.id, pin: _pin.text);
      _pin.clear();
      if (!mounted) return;
      setState(() => _done = true);
      showAbsSnackbar(context, context.l10n.memberPinDone(m.name), tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final v = Validators(l);
    final digits = [FilteringTextInputFormatter.digitsOnly];

    return Scaffold(
      appBar: AppBar(title: Text(l.memberPinTitle)),
      body: ListView(
        padding: EdgeInsets.all(context.screenPadding),
        children: [
          Text(l.memberPinSubtitle, style: t.body.copyWith(color: c.textSecondary)),
          const SizedBox(height: AbsSpace.x6),
          Form(
            key: _findForm,
            child: AbsTextField(
              label: l.fieldPhone,
              controller: _phone,
              prefixText: '+91',
              numeric: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [...digits, LengthLimitingTextInputFormatter(10)],
              validator: v.phone,
              onFieldSubmitted: (_) => _find(),
            ),
          ),
          const SizedBox(height: AbsSpace.x4),
          AbsButton.secondary(label: l.memberPinFind, isLoading: _busy && _member == null, onPressed: _find),
          AnimatedSwitcher(
            duration: AbsMotion.standard.duration,
            switchInCurve: AbsMotion.standard.curve,
            child: _member == null
                ? const SizedBox.shrink()
                : Padding(
                    key: ValueKey(_member!.id),
                    padding: const EdgeInsets.only(top: AbsSpace.x6),
                    child: AbsCard(
                      child: Form(
                        key: _pinForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                AbsAvatar(name: _member!.name),
                                const SizedBox(width: AbsSpace.x3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_member!.name, style: t.heading),
                                      Text(
                                        _member!.memberCode,
                                        style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AbsSpace.x5),
                            AbsTextField(
                              label: l.fieldPin,
                              controller: _pin,
                              numeric: true,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [...digits, LengthLimitingTextInputFormatter(4)],
                              validator: v.pin,
                              onFieldSubmitted: (_) => _setPin(),
                            ),
                            const SizedBox(height: AbsSpace.x4),
                            AbsButton(label: l.memberPinSet, isLoading: _busy, isSuccess: _done, onPressed: _setPin),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
