import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import 'status_pill.dart';

/// Round avatar: photo, or initials on a pop colour picked from the name.
/// An optional status ring shows membership state.
class AbsAvatar extends StatelessWidget {
  const AbsAvatar({super.key, required this.name, this.imageUrl, this.ringColor, this.size = AbsSize.avatar, this.hue});

  final String name;
  final String? imageUrl;
  final Color? ringColor;
  final double size;
  final PopHue? hue;

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(hue ?? hueForName(name));
    final inner = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: p.fill,
        shape: BoxShape.circle,
        border: Border.all(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline),
        image: imageUrl == null ? null : DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: imageUrl != null
          ? null
          : Text(
              initials(name),
              textScaler: TextScaler.noScaling,
              style: context.text.heading.copyWith(color: p.onFill, fontSize: size * 0.36, height: 1),
            ),
    );
    if (ringColor == null) return inner;
    return Container(
      padding: const EdgeInsets.all(AbsSize.avatarRing),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor!, width: AbsSize.avatarRing),
      ),
      child: inner,
    );
  }
}

/// Avatar with status ring, name, plan, days-left sticker and a trailing quick
/// action. Swipe right = collect payment, swipe left = send reminder. The tile
/// stays in the list; the swipe only triggers the callback.
class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.name,
    required this.plan,
    required this.status,
    this.daysLeft,
    this.photoUrl,
    this.trailing,
    this.onTap,
    this.onCollect,
    this.onRemind,
    this.heroTag,
  });

  /// Hero tag shared with the member detail avatar (usually the member id).
  final Object? heroTag;
  final String name;
  final String plan;
  final PillStatus status;
  final int? daysLeft;
  final String? photoUrl;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onCollect;
  final VoidCallback? onRemind;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final ring = StatusPill.colorFor(c, status);
    final avatar = AbsAvatar(name: name, imageUrl: photoUrl, ringColor: ring);

    final tile = Material(
      color: c.bg,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AbsSize.touchTarget + AbsSpace.x4),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding, vertical: AbsSpace.x3),
            child: Row(
              children: [
                if (heroTag != null) Hero(tag: heroTag!, child: avatar) else avatar,
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        plan,
                        style: t.caption.copyWith(color: c.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AbsSpace.x2),
                if (daysLeft != null && daysLeft! >= 0)
                  PopSticker(label: context.l10n.daysLeft(daysLeft!), hue: StatusPill.hueFor(status), numeric: true)
                else
                  StatusPill(status: status, days: daysLeft ?? 0),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );

    if (onCollect == null && onRemind == null) return tile;

    return _SwipeActions(
      onSwipeRight: onCollect,
      onSwipeLeft: onRemind,
      rightLabel: context.l10n.swipeCollect,
      leftLabel: context.l10n.swipeRemind,
      child: tile,
    );
  }
}

class _SwipeActions extends StatefulWidget {
  const _SwipeActions({
    required this.child,
    required this.rightLabel,
    required this.leftLabel,
    this.onSwipeRight,
    this.onSwipeLeft,
  });

  final Widget child;
  final String rightLabel;
  final String leftLabel;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;

  @override
  State<_SwipeActions> createState() => _SwipeActionsState();
}

class _SwipeActionsState extends State<_SwipeActions> {
  static const _threshold = 0.35;
  double _progress = 0;
  bool _reached = false;
  int _key = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final scale = 0.7 + 0.6 * (_progress / _threshold).clamp(0.0, 1.0);

    Widget background(PopHue hue, IconData icon, String label, Alignment align) {
      final p = c.pop(hue);
      return Container(
        color: _reached ? p.fill : p.soft,
        alignment: align,
        padding: EdgeInsets.symmetric(horizontal: context.screenPadding + AbsSpace.x1),
        child: Transform.scale(
          scale: scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: _reached ? p.onFill : p.text),
              Text(label, style: context.text.caption.copyWith(color: _reached ? p.onFill : p.text)),
            ],
          ),
        ),
      );
    }

    return Dismissible(
      key: ValueKey(_key),
      direction: widget.onSwipeRight != null && widget.onSwipeLeft != null
          ? DismissDirection.horizontal
          : widget.onSwipeRight != null
          ? DismissDirection.startToEnd
          : DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.startToEnd: _threshold, DismissDirection.endToStart: _threshold},
      onUpdate: (d) {
        if (d.reached != _reached) HapticFeedback.selectionClick();
        setState(() {
          _progress = d.progress;
          _reached = d.reached;
        });
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onSwipeRight?.call();
        } else {
          widget.onSwipeLeft?.call();
        }
        return false; // keep the tile in the list
      },
      onDismissed: (_) => setState(() => _key++),
      background: background(PopHue.mint, PhosphorIcons.currencyInr(), widget.rightLabel, Alignment.centerLeft),
      secondaryBackground: background(
        PopHue.sky,
        PhosphorIcons.whatsappLogo(),
        widget.leftLabel,
        Alignment.centerRight,
      ),
      child: widget.child,
    );
  }
}
