import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/phone_input.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/abs_bottom_sheet.dart';
import '../../../core/widgets/abs_button.dart';
import '../../../core/widgets/abs_snackbar.dart';
import '../../../core/widgets/abs_text_field.dart';
import '../application/auth_providers.dart';
import 'auth_scaffold.dart';

/// Phone + 4-digit PIN (validated by the member-login Edge Function, with a
/// 15-minute lock after 5 wrong PINs). Fallback: email magic link.
class MemberLoginScreen extends ConsumerStatefulWidget {
  const MemberLoginScreen({super.key});

  @override
  ConsumerState<MemberLoginScreen> createState() => _MemberLoginScreenState();
}

class _MemberLoginScreenState extends ConsumerState<MemberLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).signInMember(phone: _phone.text, pin: _pin.text);
    } catch (e) {
      _pin.clear();
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _forgotPin() {
    final l = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.memberForgotPinTitle),
        content: Text(l.memberForgotPinBody),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l.commonClose))],
      ),
    );
  }

  void _emailLink() {
    showAbsBottomSheet<void>(context: context, builder: (context, controller) => _EmailLinkSheet(controller));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = Validators(l);
    return AuthScaffold(
      title: l.memberLoginTitle,
      subtitle: l.memberLoginSubtitle,
      icon: PhosphorIcons.userCircle(PhosphorIconsStyle.bold),
      hue: PopHue.sky,
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AbsTextField(
                label: l.fieldPhone,
                controller: _phone,
                prefixText: '+91',
                numeric: true,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: const [IndianMobileInputFormatter()],
                validator: v.phone,
              ),
              const SizedBox(height: AbsSpace.x4),
              AbsTextField(
                label: l.fieldPin,
                controller: _pin,
                numeric: true,
                obscureText: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                validator: v.pin,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AbsSpace.x6),
              AbsButton(label: l.actionSignIn, hue: PopHue.sky, isLoading: _busy, onPressed: _submit),
              const SizedBox(height: AbsSpace.x4),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  AbsButton.ghost(label: l.memberForgotPin, onPressed: _forgotPin),
                  AbsButton.ghost(label: l.memberUseEmailLink, onPressed: _emailLink),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmailLinkSheet extends ConsumerStatefulWidget {
  const _EmailLinkSheet(this.controller);

  final ScrollController controller;

  @override
  ConsumerState<_EmailLinkSheet> createState() => _EmailLinkSheetState();
}

class _EmailLinkSheetState extends ConsumerState<_EmailLinkSheet> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).sendMemberMagicLink(email: _email.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    return Form(
      key: _form,
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
        children: [
          Text(l.memberEmailLinkTitle, style: t.title),
          const SizedBox(height: AbsSpace.x2),
          Text(
            _sent ? l.memberEmailLinkSent : l.memberEmailLinkBody,
            style: t.body.copyWith(color: context.colors.textSecondary),
          ),
          const SizedBox(height: AbsSpace.x5),
          AbsTextField(
            label: l.fieldEmail,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: Validators(l).email,
            onFieldSubmitted: (_) => _send(),
          ),
          const SizedBox(height: AbsSpace.x5),
          AbsButton(
            label: l.memberEmailLinkSend,
            hue: PopHue.sky,
            isLoading: _busy,
            isSuccess: _sent,
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}
