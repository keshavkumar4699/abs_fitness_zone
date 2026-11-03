import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';
import 'abs_text_field.dart';

/// Asks for one value in a dialog; returns null when cancelled. The dialog
/// owns its text controller, so nothing is disposed while it animates out.
Future<String?> promptText(
  BuildContext context, {
  String? title,
  required String label,
  String initial = '',
  bool numeric = false,
  TextInputType? keyboardType,
}) => showDialog<String>(
  context: context,
  builder: (_) =>
      _PromptDialog(title: title, label: label, initial: initial, numeric: numeric, keyboardType: keyboardType),
);

class _PromptDialog extends StatefulWidget {
  const _PromptDialog({
    required this.title,
    required this.label,
    required this.initial,
    required this.numeric,
    this.keyboardType,
  });

  final String? title;
  final String label;
  final String initial;
  final bool numeric;
  final TextInputType? keyboardType;

  @override
  State<_PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: AbsTextField(
        key: const ValueKey('prompt-field'),
        label: widget.label,
        controller: _c,
        autofocus: true,
        numeric: widget.numeric,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.commonCancel)),
        TextButton(
          key: const ValueKey('prompt-ok'),
          onPressed: () => Navigator.pop(context, _c.text.trim()),
          child: Text(l.commonDone),
        ),
      ],
    );
  }
}
