import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/phone_input.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../data/member_pin_repository.dart';

/// Front desk / owner: find a member by phone and set their 4-digit app PIN.
class MemberPinScreen extends ConsumerStatefulWidget {
  const MemberPinScreen({super.key, this.initialPhone});

  /// Prefilled from the member detail screen.
  final String? initialPhone;

  @override
  ConsumerState<MemberPinScreen> createState() => _MemberPinScreenState();
}

class _MemberPinScreenState extends ConsumerState<MemberPinScreen> {
  final _findForm = GlobalKey<FormState>();
  final _pinForm = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  MemberLookup? _member;
  bool _finding = false;
  bool _saving = false;
  bool _done = false;
  int _celebrate = 0;
  Timer? _resetDone;

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null) {
      _phone.text = widget.initialPhone!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _find());
    }
  }

  @override
  void dispose() {
    _resetDone?.cancel();
    _phone.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _find() async {
    if (_finding || !_findForm.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _finding = true;
      _member = null;
      _done = false;
    });
    try {
      final m = await ref.read(memberPinRepositoryProvider).findByPhone(_phone.text);
      if (mounted) setState(() => _member = m);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _finding = false);
    }
  }

  Future<void> _setPin() async {
    final m = _member;
    if (m == null || _saving || !_pinForm.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    try {
      await ref.read(memberPinRepositoryProvider).setPin(memberId: m.id, pin: _pin.text);
      _pin.clear();
      if (!mounted) return;
      setState(() {
        _done = true;
        _celebrate++;
      });
      showAbsSnackbar(context, context.l10n.memberPinDone(m.name), tone: SnackTone.success);
      // Let the check show, then make the button usable again.
      _resetDone?.cancel();
      _resetDone = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _done = false);
      });
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final v = Validators(l);

    return Scaffold(
      appBar: AppBar(title: Text(l.memberPinTitle)),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              context.screenPadding,
              AbsSpace.x2,
              context.screenPadding,
              MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
            ),
            children: [
              Row(
                children: [
                  IconBubble(icon: PhosphorIcons.password(PhosphorIconsStyle.bold), hue: PopHue.tangerine, size: 52),
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(
                    child: Text(l.memberPinSubtitle, style: t.body.copyWith(color: c.textSecondary)),
                  ),
                ],
              ),
              const SizedBox(height: AbsSpace.x6),
              Form(
                key: _findForm,
                child: AbsTextField(
                  label: l.fieldPhone,
                  controller: _phone,
                  prefixText: '+91',
                  numeric: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: const [IndianMobileInputFormatter()],
                  validator: v.phone,
                  onFieldSubmitted: (_) => _find(),
                ),
              ),
              const SizedBox(height: AbsSpace.x4),
              AbsButton(
                label: l.memberPinFind,
                hue: PopHue.tangerine,
                icon: PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                isLoading: _finding,
                onPressed: _find,
              ),
              AnimatedSwitcher(
                duration: AbsMotion.bouncy.duration,
                switchInCurve: AbsMotion.bouncy.curve,
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: _member == null
                    ? const SizedBox.shrink()
                    : Padding(
                        key: ValueKey(_member!.id),
                        padding: const EdgeInsets.only(top: AbsSpace.x6),
                        child: AbsCard(
                          hue: PopHue.tangerine,
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: v.pin,
                                  onFieldSubmitted: (_) => _setPin(),
                                ),
                                const SizedBox(height: AbsSpace.x4),
                                AbsButton(
                                  label: l.memberPinSet,
                                  hue: PopHue.mint,
                                  isLoading: _saving,
                                  isSuccess: _done,
                                  onPressed: _setPin,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Positioned.fill(
            child: ConfettiBurst(key: ValueKey(_celebrate), play: _celebrate > 0),
          ),
        ],
      ),
    );
  }
}
