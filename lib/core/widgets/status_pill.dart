import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';

enum PillStatus { active, expiring, expired, frozen, paid, partial, overdue, lead }

/// Colour + text, never colour alone (spec §4).
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, this.days = 0});

  final PillStatus status;

  /// Days until expiry, used by [PillStatus.expiring].
  final int days;

  static Color colorFor(AbsColors c, PillStatus status) => switch (status) {
    PillStatus.active || PillStatus.paid => c.success,
    PillStatus.expiring || PillStatus.partial => c.warning,
    PillStatus.expired || PillStatus.overdue => c.danger,
    PillStatus.frozen => c.info,
    PillStatus.lead => c.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final color = colorFor(c, status);
    final label = switch (status) {
      PillStatus.active => l.statusActive,
      PillStatus.expiring => l.statusExpiring(days),
      PillStatus.expired => l.statusExpired,
      PillStatus.frozen => l.statusFrozen,
      PillStatus.paid => l.statusPaid,
      PillStatus.partial => l.statusPartial,
      PillStatus.overdue => l.statusOverdue,
      PillStatus.lead => l.statusLead,
    };
    return AnimatedContainer(
      duration: AbsMotion.quick.duration,
      curve: AbsMotion.quick.curve,
      constraints: const BoxConstraints(minHeight: AbsSize.pillHeight),
      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x2 + AbsSpace.x1 / 2, vertical: AbsSpace.x1 / 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AbsOpacity.subtleFill),
        borderRadius: AbsRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AbsSpace.x2 - 2,
            height: AbsSpace.x2 - 2,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AbsSpace.x1 + 2),
          Text(label, style: context.text.label.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// A small numeric pill such as "12 days left".
class InfoPill extends StatelessWidget {
  const InfoPill({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = color ?? c.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x2 + 2, vertical: AbsSpace.x1 / 2),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: AbsOpacity.subtleFill),
        borderRadius: AbsRadius.pill,
      ),
      child: Text(label, style: context.text.numericOf(context.text.label).copyWith(color: fg)),
    );
  }
}
