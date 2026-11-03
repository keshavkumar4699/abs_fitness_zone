import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Sticker card: surface with a bold outline and a hard lip. With [hue] it is
/// tinted in that pop colour. Tappable cards squish onto their lip.
class AbsCard extends StatefulWidget {
  const AbsCard({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.onTap,
    this.padding = const EdgeInsets.all(AbsSpace.x5),
    this.hue,
    this.solid = false,
  });

  final Widget child;
  final String? title;
  final Widget? action;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Optional pop tint.
  final PopHue? hue;

  /// Solid pop fill (with ink text) instead of a light tint.
  final bool solid;

  @override
  State<AbsCard> createState() => _AbsCardState();
}

class _AbsCardState extends State<AbsCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pop = widget.hue == null ? null : c.pop(widget.hue!);
    final Color color = switch ((pop, widget.solid)) {
      (null, _) => c.surface,
      (final p?, true) => p.fill,
      (final p?, false) => Color.alphaBlend(p.fill.withValues(alpha: c.isDark ? 0.16 : 0.2), c.surface),
    };
    final pressed = _pressed && !AbsMotion.reduced(context);

    Widget body = widget.child;
    if (widget.title != null || widget.action != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (widget.title != null)
                Expanded(
                  child: Text(
                    widget.title!,
                    style: context.text.heading.copyWith(color: widget.solid && pop != null ? pop.onFill : null),
                  ),
                ),
              ?widget.action,
            ],
          ),
          const SizedBox(height: AbsSpace.x3),
          widget.child,
        ],
      );
    }

    final card = Padding(
      padding: const EdgeInsets.only(bottom: AbsDepth.cardLip),
      child: AnimatedContainer(
        duration: AbsMotion.instant.duration,
        curve: AbsMotion.instant.curve,
        padding: widget.padding,
        transform: Matrix4.translationValues(0, pressed ? AbsDepth.cardLip : 0, 0),
        decoration: stickerDecoration(
          c,
          color: color,
          outline: pop != null && c.isDark ? pop.deep : null,
          lipDepth: pressed ? 0 : AbsDepth.cardLip,
        ),
        // Transparent Material so ListTiles and InkWells inside paint on the card.
        child: Material(
          type: MaterialType.transparency,
          child: widget.solid && pop != null
              ? DefaultTextStyle.merge(
                  style: TextStyle(color: pop.onFill),
                  child: IconTheme.merge(
                    data: IconThemeData(color: pop.onFill),
                    child: body,
                  ),
                )
              : body,
        ),
      ),
    );

    if (widget.onTap == null) return card;
    return Semantics(
      button: true,
      onTap: widget.onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: card,
      ),
    );
  }
}
