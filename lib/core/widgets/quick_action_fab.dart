import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';

class QuickAction {
  const QuickAction({required this.icon, required this.label, required this.onTap, this.hue = PopHue.sky});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final PopHue hue;
}

/// FAB that pops open into colourful stacked actions (New member, Collect,
/// Check-in, Enquiry) with a bouncy stagger.
class QuickActionFab extends StatefulWidget {
  const QuickActionFab({super.key, required this.actions});

  final List<QuickAction> actions;

  @override
  State<QuickActionFab> createState() => _QuickActionFabState();
}

class _QuickActionFabState extends State<QuickActionFab> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AbsMotion.bouncy.duration);
  bool get _open => _c.status == AnimationStatus.forward || _c.status == AnimationStatus.completed;

  void _toggle() {
    HapticFeedback.lightImpact();
    _open ? _c.reverse() : _c.forward();
    setState(() {});
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final n = widget.actions.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < n; i++)
          _Staggered(
            controller: _c,
            index: n - 1 - i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x3),
              child: Semantics(
                button: true,
                label: widget.actions[i].label,
                onTap: () {
                  _toggle();
                  widget.actions[i].onTap();
                },
                excludeSemantics: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _toggle();
                    widget.actions[i].onTap();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3, vertical: AbsSpace.x1 + 2),
                        decoration: stickerDecoration(c, lipDepth: 2, borderRadius: AbsRadius.chipAll),
                        child: Text(widget.actions[i].label, style: t.label),
                      ),
                      const SizedBox(width: AbsSpace.x3),
                      Container(
                        width: AbsSize.touchTarget,
                        height: AbsSize.touchTarget,
                        decoration: stickerDecoration(
                          c,
                          color: c.pop(widget.actions[i].hue).fill,
                          lipDepth: 3,
                          borderRadius: AbsRadius.pill,
                        ),
                        child: Icon(widget.actions[i].icon, color: c.pop(widget.actions[i].hue).onFill),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Tooltip(
          message: context.l10n.fabOpen,
          child: Semantics(
            button: true,
            label: context.l10n.fabOpen,
            onTap: _toggle,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                key: const ValueKey('quick-action-fab'),
                width: AbsSpace.x14 + 4,
                height: AbsSpace.x14 + 4,
                decoration: stickerDecoration(
                  c,
                  color: c.accent,
                  lip: c.isDark ? c.primary.deep : c.ink,
                  borderRadius: AbsRadius.cardAll,
                ),
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, child) =>
                      Transform.rotate(angle: AbsMotion.bouncy.curve.transform(_c.value) * math.pi / 4, child: child),
                  child: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold), color: c.onAccent, size: 28),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Staggered extends StatelessWidget {
  const _Staggered({required this.controller, required this.index, required this.child});

  final AnimationController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final total = controller.duration!.inMilliseconds;
    final start = (AbsMotion.staggerDelay(index).inMilliseconds / total).clamp(0.0, 0.6);
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(start, 1, curve: AbsMotion.bouncy.curve),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        if (controller.value == 0) return const SizedBox.shrink();
        return Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.6 + 0.4 * anim.value, alignment: Alignment.centerRight, child: child),
        );
      },
      child: child,
    );
  }
}

/// The four staff quick actions, each in its own hue.
List<QuickAction> staffQuickActions(
  BuildContext context, {
  required VoidCallback onNewMember,
  required VoidCallback onCollect,
  required VoidCallback onCheckIn,
  required VoidCallback onEnquiry,
}) {
  final l = context.l10n;
  return [
    QuickAction(
      icon: PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
      label: l.fabNewMember,
      onTap: onNewMember,
      hue: PopHue.sky,
    ),
    QuickAction(
      icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.bold),
      label: l.fabCollect,
      onTap: onCollect,
      hue: PopHue.tangerine,
    ),
    QuickAction(
      icon: PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
      label: l.fabCheckIn,
      onTap: onCheckIn,
      hue: PopHue.mint,
    ),
    QuickAction(
      icon: PhosphorIcons.chatCircleText(PhosphorIconsStyle.bold),
      label: l.fabEnquiry,
      onTap: onEnquiry,
      hue: PopHue.bubblegum,
    ),
  ];
}
