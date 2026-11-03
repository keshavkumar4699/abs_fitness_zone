import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/money.dart';

/// Rupee amount typed on a big on-screen keypad (no system keyboard at the
/// desk). Keeps at most 2 decimals and 7 rupee digits.
class AmountKeypad extends StatelessWidget {
  const AmountKeypad({super.key, required this.text, required this.onChanged});

  final String text;
  final ValueChanged<String> onChanged;

  static int? paiseOf(String text) => text.isEmpty ? null : Money.parse(text);

  void _press(String key) {
    HapticFeedback.selectionClick();
    var next = text;
    if (key == '<') {
      if (next.isNotEmpty) next = next.substring(0, next.length - 1);
    } else if (key == '.') {
      if (next.contains('.')) return;
      next = next.isEmpty ? '0.' : '$next.';
    } else {
      final dot = next.indexOf('.');
      if (dot >= 0 && next.length - dot > 2) return;
      if (dot < 0 && next.replaceAll(RegExp('^0+'), '').length >= 7) return;
      next = next == '0' ? key : '$next$key';
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '<'];
    return LayoutBuilder(
      builder: (context, box) {
        final w = (box.maxWidth - AbsSpace.x2 * 2) / 3;
        return Wrap(
          spacing: AbsSpace.x2,
          runSpacing: AbsSpace.x2,
          children: [
            for (final k in keys)
              SizedBox(
                width: w,
                height: 52,
                child: _Key(
                  label: k == '<' ? null : k,
                  semantics: k == '<' ? l.keypadBackspace : k,
                  icon: k == '<' ? PhosphorIcons.backspace(PhosphorIconsStyle.bold) : null,
                  onTap: () => _press(k),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.semantics, required this.onTap, this.icon});

  final String? label;
  final String semantics;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      label: semantics,
      excludeSemantics: true,
      child: Material(
        color: c.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: AbsRadius.buttonAll,
          side: BorderSide(color: c.border, width: AbsDepth.outline),
        ),
        child: InkWell(
          key: ValueKey('key-$semantics'),
          customBorder: const RoundedRectangleBorder(borderRadius: AbsRadius.buttonAll),
          onTap: onTap,
          child: Center(
            child: icon != null
                ? Icon(icon, color: c.textPrimary)
                : Text(label!, style: t.numericOf(t.title).copyWith(height: 1)),
          ),
        ),
      ),
    );
  }
}
