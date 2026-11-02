import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';

class QuickAction {
  const QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// FAB that expands into stacked actions (New member, Collect, Check-in,
/// Enquiry) with a staggered reveal.
class QuickActionFab extends StatefulWidget {
  const QuickActionFab({super.key, required this.actions});

  final List<QuickAction> actions;

  @override
  State<QuickActionFab> createState() => _QuickActionFabState();
}

class _QuickActionFabState extends State<QuickActionFab> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AbsMotion.standard.duration);
  bool get _open => _c.status == AnimationStatus.forward || _c.status == AnimationStatus.completed;

  void _toggle() {
    HapticFeedback.lightImpact();
    if (_open) {
      _c.reverse();
    } else {
      _c.forward();
    }
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
            // The action nearest the FAB appears first.
            index: n - 1 - i,
            count: n,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AbsSpace.x3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _toggle();
                      widget.actions[i].onTap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x3, vertical: AbsSpace.x1 + 2),
                      decoration: BoxDecoration(
                        color: c.surfaceRaised,
                        borderRadius: AbsRadius.chipAll,
                        border: Border.all(color: c.border),
                      ),
                      child: Text(widget.actions[i].label, style: t.label),
                    ),
                  ),
                  const SizedBox(width: AbsSpace.x3),
                  SizedBox.square(
                    dimension: AbsSize.touchTarget,
                    child: Material(
                      color: c.surfaceRaised,
                      shape: CircleBorder(side: BorderSide(color: c.border)),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          _toggle();
                          widget.actions[i].onTap();
                        },
                        child: Icon(
                          widget.actions[i].icon,
                          color: c.textPrimary,
                          semanticLabel: widget.actions[i].label,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        FloatingActionButton(
          heroTag: null,
          onPressed: _toggle,
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          tooltip: context.l10n.fabOpen,
          shape: const RoundedRectangleBorder(borderRadius: AbsRadius.cardAll),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) =>
                Transform.rotate(angle: AbsMotion.standard.curve.transform(_c.value) * math.pi / 4, child: child),
            child: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
          ),
        ),
      ],
    );
  }
}

class _Staggered extends StatelessWidget {
  const _Staggered({required this.controller, required this.index, required this.count, required this.child});

  final AnimationController controller;
  final int index;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final total = controller.duration!.inMilliseconds;
    final start = (AbsMotion.staggerDelay(index).inMilliseconds / total).clamp(0.0, 0.6);
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(start, 1, curve: AbsMotion.staggerCurve),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        if (anim.value == 0) return const SizedBox.shrink();
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(offset: Offset(0, AbsMotion.entranceOffset * (1 - anim.value)), child: child),
        );
      },
      child: child,
    );
  }
}

/// The four staff quick actions from the spec, wired to callbacks.
List<QuickAction> staffQuickActions(
  BuildContext context, {
  required VoidCallback onNewMember,
  required VoidCallback onCollect,
  required VoidCallback onCheckIn,
  required VoidCallback onEnquiry,
}) {
  final l = context.l10n;
  return [
    QuickAction(icon: PhosphorIcons.userPlus(), label: l.fabNewMember, onTap: onNewMember),
    QuickAction(icon: PhosphorIcons.currencyInr(), label: l.fabCollect, onTap: onCollect),
    QuickAction(icon: PhosphorIcons.qrCode(), label: l.fabCheckIn, onTap: onCheckIn),
    QuickAction(icon: PhosphorIcons.chatCircleText(), label: l.fabEnquiry, onTap: onEnquiry),
  ];
}
