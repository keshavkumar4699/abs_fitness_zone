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

class StaffLoginScreen extends ConsumerStatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  ConsumerState<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends ConsumerState<StaffLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Ignore repeat taps / keyboard "done" while a request is in flight.
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).signInStaff(email: _email.text, password: _password.text);
      // The router redirects once the session and profile arrive.
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
      title: l.staffLoginTitle,
      subtitle: l.staffLoginSubtitle,
      icon: PhosphorIcons.identificationBadge(PhosphorIconsStyle.bold),
      hue: PopHue.grape,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AbsTextField(
                  label: l.fieldEmail,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email, AutofillHints.username],
                  validator: v.email,
                ),
                const SizedBox(height: AbsSpace.x4),
                AbsTextField(
                  label: l.fieldPassword,
                  controller: _password,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: v.required,
                  onFieldSubmitted: (_) => _submit(),
                  suffix: IconButton(
                    tooltip: l.fieldPassword,
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? PhosphorIcons.eye(PhosphorIconsStyle.bold)
                          : PhosphorIcons.eyeSlash(PhosphorIconsStyle.bold),
                    ),
                  ),
                ),
                const SizedBox(height: AbsSpace.x6),
                AbsButton(label: l.actionSignIn, hue: PopHue.grape, isLoading: _busy, onPressed: _submit),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
