import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';

enum SnackTone { neutral, success, error }

/// Floating, rounded snackbar; shows Undo when [onUndo] is given.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAbsSnackbar(
  BuildContext context,
  String message, {
  SnackTone tone = SnackTone.neutral,
  VoidCallback? onUndo,
}) {
  final c = context.colors;
  final (IconData icon, Color color) = switch (tone) {
    SnackTone.neutral => (PhosphorIcons.info(), c.info),
    SnackTone.success => (PhosphorIcons.checkCircle(), c.success),
    SnackTone.error => (PhosphorIcons.warningCircle(), c.danger),
  };
  final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: color, size: AbsSize.iconSmall + 2),
          const SizedBox(width: AbsSpace.x3),
          Expanded(child: Text(message)),
        ],
      ),
      margin: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x4),
      shape: RoundedRectangleBorder(
        borderRadius: AbsRadius.buttonAll,
        side: BorderSide(color: c.border),
      ),
      action: onUndo == null ? null : SnackBarAction(label: context.l10n.commonUndo, onPressed: onUndo),
    ),
  );
}
