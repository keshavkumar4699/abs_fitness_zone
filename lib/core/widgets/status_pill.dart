import 'package:flutter/material.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';

enum PillStatus { active, expiring, expired, frozen, paid, partial, overdue, lead }

/// Sticker-style status: solid pop colour + ink text, never colour alone.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, this.days = 0});

  final PillStatus status;

  /// Days until expiry, used by [PillStatus.expiring].
  final int days;

  static PopHue hueFor(PillStatus status) => switch (status) {
    PillStatus.active || PillStatus.paid => PopHue.mint,
    PillStatus.expiring || PillStatus.partial => PopHue.tangerine,
    PillStatus.expired || PillStatus.overdue => PopHue.coral,
    PillStatus.frozen => PopHue.sky,
    PillStatus.lead => PopHue.grape,
  };

  /// Text-safe colour for rings and icons.
  static Color colorFor(AbsColors c, PillStatus status) => c.pop(hueFor(status)).text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final p = c.pop(hueFor(status));
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
    return PopSticker(label: label, hue: hueFor(status), dot: true, color: p);
  }
}

/// A small pill sticker (role chips, counts, "12 days left").
class PopSticker extends StatelessWidget {
  const PopSticker({
    super.key,
    required this.label,
    required this.hue,
    this.dot = false,
    this.color,
    this.numeric = false,
  });

  final String label;
  final PopHue hue;
  final bool dot;
  final PopColor? color;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = color ?? c.pop(hue);
    final t = context.text;
    final style = (numeric ? t.numericOf(t.label) : t.label).copyWith(color: p.onFill);
    return Container(
      constraints: const BoxConstraints(minHeight: AbsSize.pillHeight),
      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3, vertical: 2),
      decoration: BoxDecoration(
        color: p.fill,
        borderRadius: AbsRadius.pill,
        border: Border.all(color: c.isDark ? p.deep : c.ink, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: p.onFill, shape: BoxShape.circle),
            ),
            const SizedBox(width: AbsSpace.x1 + 2),
          ],
          Flexible(
            child: Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// Backwards-compatible alias used across screens.
class InfoPill extends StatelessWidget {
  const InfoPill({super.key, required this.label, this.hue = PopHue.grape});

  final String label;
  final PopHue hue;

  @override
  Widget build(BuildContext context) => PopSticker(label: label, hue: hue, numeric: true);
}
