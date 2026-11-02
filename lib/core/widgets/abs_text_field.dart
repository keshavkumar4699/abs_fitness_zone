import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/theme.dart';

/// Floating-label field, 52 high, validated when it loses focus, with
/// optional prefix text such as "₹" or "+91".
class AbsTextField extends StatelessWidget {
  const AbsTextField({
    super.key,
    required this.label,
    this.controller,
    this.prefixText,
    this.helperText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.numeric = false,
    this.suffix,
  });

  final String label;
  final TextEditingController? controller;
  final String? prefixText;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autofocus;

  /// Renders the value in the numeric face (money, phone, PIN).
  final bool numeric;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AbsSize.fieldHeight),
      child: TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUnfocus,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        autofillHints: autofillHints,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        enabled: enabled,
        autofocus: autofocus,
        style: numeric ? t.numericOf(t.body) : t.body,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText == null ? null : '$prefixText ',
          helperText: helperText,
          counterText: '',
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
