import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Surface card, radius 20, padding 16–20, optional header row with action.
/// Pressed state darkens by 4%.
class AbsCard extends StatefulWidget {
  const AbsCard({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.onTap,
    this.padding = const EdgeInsets.all(AbsSpace.x5),
    this.raised = false,
  });

  final Widget child;
  final String? title;
  final Widget? action;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool raised;

  @override
  State<AbsCard> createState() => _AbsCardState();
}

class _AbsCardState extends State<AbsCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final base = widget.raised ? c.surfaceRaised : c.surface;
    final color = _pressed ? Color.alphaBlend(Colors.black.withValues(alpha: AbsOpacity.pressedOverlay), base) : base;

    Widget body = widget.child;
    if (widget.title != null || widget.action != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (widget.title != null) Expanded(child: Text(widget.title!, style: context.text.heading)),
              ?widget.action,
            ],
          ),
          const SizedBox(height: AbsSpace.x3),
          widget.child,
        ],
      );
    }

    final card = AnimatedContainer(
      duration: AbsMotion.instant.duration,
      curve: AbsMotion.instant.curve,
      padding: widget.padding,
      decoration: absSurfaceDecoration(context, color: color),
      child: body,
    );

    if (widget.onTap == null) return card;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: card,
      ),
    );
  }
}

/// Depth per spec: dark mode uses a 1 px top highlight (white 4%) and no
/// heavy shadow; light mode uses one soft shadow (0 4 16, 6%).
BoxDecoration absSurfaceDecoration(
  BuildContext context, {
  Color? color,
  BorderRadius borderRadius = AbsRadius.cardAll,
}) {
  final c = context.colors;
  final base = color ?? c.surface;
  return BoxDecoration(
    color: c.isDark ? null : base,
    // A hard-edged gradient stop gives a crisp highlight along the top edge,
    // which a non-uniform Border cannot do together with rounded corners.
    gradient: c.isDark
        ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.alphaBlend(c.highlight, base), Color.alphaBlend(c.highlight, base), base],
            stops: const [0, 0.012, 0.012],
          )
        : null,
    borderRadius: borderRadius,
    boxShadow: c.isDark
        ? null
        : [BoxShadow(color: c.shadow, offset: AbsElevation.shadowOffset, blurRadius: AbsElevation.shadowBlur)],
  );
}
