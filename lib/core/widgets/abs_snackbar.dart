import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';

enum SnackTone { neutral, success, error }

/// Floating sticker snackbar in the tone's pop colour; Undo when reversible.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAbsSnackbar(
  BuildContext context,
  String message, {
  SnackTone tone = SnackTone.neutral,
  VoidCallback? onUndo,
}) {
  final c = context.colors;
  final (IconData icon, PopHue hue) = switch (tone) {
    SnackTone.neutral => (PhosphorIcons.info(PhosphorIconsStyle.bold), PopHue.sky),
    SnackTone.success => (PhosphorIcons.checkCircle(PhosphorIconsStyle.bold), PopHue.mint),
    SnackTone.error => (PhosphorIcons.warningCircle(PhosphorIconsStyle.bold), PopHue.coral),
  };
  final p = c.pop(hue);
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      backgroundColor: p.fill,
      content: Row(
        children: [
          Icon(icon, color: p.onFill, size: AbsSize.icon),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Text(message, style: context.text.body.copyWith(color: p.onFill)),
          ),
        ],
      ),
      margin: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x4),
      shape: RoundedRectangleBorder(
        borderRadius: AbsRadius.buttonAll,
        side: BorderSide(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline),
      ),
      action: onUndo == null
          ? null
          : SnackBarAction(label: context.l10n.commonUndo, textColor: p.onFill, onPressed: onUndo),
    ),
  );
}
