import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/validators.dart';
import '../../../core/widgets/abs_button.dart';
import '../../../core/widgets/abs_snackbar.dart';
import '../../../core/widgets/abs_text_field.dart';
import '../application/auth_providers.dart';
import 'auth_scaffold.dart';

/// Forced on a staff member's first sign-in (temporary password).
class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).setPassword(_password.text);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = Validators(l);
    return AuthScaffold(
      title: l.setPasswordTitle,
      subtitle: l.setPasswordSubtitle,
      showBack: false,
      icon: PhosphorIcons.lockKey(PhosphorIconsStyle.bold),
      hue: PopHue.tangerine,
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AbsTextField(
                label: l.fieldNewPassword,
                controller: _password,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                validator: v.newPassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AbsSpace.x4),
              AbsTextField(
                label: l.fieldConfirmPassword,
                controller: _confirm,
                obscureText: true,
                validator: (value) => value == _password.text ? null : l.validationPasswordMatch,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AbsSpace.x6),
              AbsButton(label: l.setPasswordAction, hue: PopHue.tangerine, isLoading: _busy, onPressed: _submit),
              const SizedBox(height: AbsSpace.x3),
              AbsButton.ghost(label: l.commonSignOut, onPressed: () => ref.read(authRepositoryProvider).signOut()),
            ],
          ),
        ),
      ],
    );
  }
}
