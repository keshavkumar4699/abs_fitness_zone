import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/theme/theme.dart';

enum AbsButtonVariant { primary, secondary, ghost, destructive }

/// Chunky "candy" button: a vivid fill sitting on a darker lip that squishes
/// down when pressed. Loading swaps the label for a spinner (width kept);
/// success pops in a check with a medium haptic.
class AbsButton extends StatefulWidget {
  const AbsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AbsButtonVariant.primary,
    this.hue = PopHue.lime,
    this.icon,
    this.isLoading = false,
    this.isSuccess = false,
    this.expand = true,
  });

  const AbsButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSuccess = false,
    this.expand = true,
  }) : variant = AbsButtonVariant.secondary,
       hue = PopHue.lime;

  const AbsButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.hue = PopHue.grape,
    this.isLoading = false,
    this.isSuccess = false,
    this.expand = false,
  }) : variant = AbsButtonVariant.ghost;

  const AbsButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSuccess = false,
    this.expand = true,
  }) : variant = AbsButtonVariant.destructive,
       hue = PopHue.coral;

  final String label;
  final VoidCallback? onPressed;
  final AbsButtonVariant variant;

  /// Fill colour for primary buttons.
  final PopHue hue;
  final IconData? icon;
  final bool isLoading;
  final bool isSuccess;
  final bool expand;

  @override
  State<AbsButton> createState() => _AbsButtonState();
}

class _AbsButtonState extends State<AbsButton> {
  bool _down = false;

  @override
  void didUpdateWidget(AbsButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) HapticFeedback.mediumImpact();
  }

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final busy = widget.isLoading || widget.isSuccess;
    final enabled = widget.onPressed != null && !busy;
    final reduced = AbsMotion.reduced(context);

    final pop = c.pop(widget.variant == AbsButtonVariant.destructive ? PopHue.coral : widget.hue);
    final outline = c.isDark ? pop.deep : c.ink;
    final (Color bg, Color fg, Color? border, Color? lip) = switch (widget.variant) {
      AbsButtonVariant.primary ||
      AbsButtonVariant.destructive => (pop.fill, pop.onFill, outline, c.isDark ? pop.deep : c.ink),
      AbsButtonVariant.secondary => (
        c.surface,
        c.textPrimary,
        c.isDark ? c.border : c.ink,
        c.isDark ? c.shadow : c.ink,
      ),
      AbsButtonVariant.ghost => (Colors.transparent, pop.text, null, null),
    };
    final lipDepth = lip == null ? 0.0 : AbsDepth.lip;
    final pressed = _down && enabled && !reduced;

    final label = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: AbsSize.iconSmall + 2, color: fg),
          const SizedBox(width: AbsSpace.x2),
        ],
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.heading.copyWith(color: fg),
          ),
        ),
      ],
    );

    final Widget overlay = widget.isSuccess
        ? Icon(
            PhosphorIcons.check(PhosphorIconsStyle.bold),
            key: const ValueKey('success'),
            color: fg,
            size: AbsSize.icon,
          )
        : widget.isLoading
        ? SizedBox.square(
            key: const ValueKey('loading'),
            dimension: AbsSize.iconSmall,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        : const SizedBox.shrink(key: ValueKey('idle'));

    final face = AnimatedContainer(
      duration: AbsMotion.instant.duration,
      curve: AbsMotion.instant.curve,
      height: AbsSize.buttonHeight,
      width: widget.expand ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x5),
      transform: Matrix4.translationValues(0, pressed ? lipDepth : 0, 0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AbsRadius.buttonAll,
        border: border == null ? null : Border.all(color: border, width: AbsDepth.outline),
        boxShadow: lip == null || pressed ? null : [BoxShadow(color: lip, offset: Offset(0, lipDepth))],
      ),
      // A Container with an alignment grows to fill its parent, so only set it
      // for full-width buttons; compact buttons hug their label.
      alignment: widget.expand ? Alignment.center : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The label stays laid out (invisible while busy) so width is kept.
          AnimatedOpacity(opacity: busy ? 0 : 1, duration: AbsMotion.quick.duration, child: label),
          AnimatedSwitcher(
            duration: AbsMotion.bouncy.duration,
            switchInCurve: AbsMotion.bouncy.curve,
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: overlay,
          ),
        ],
      ),
    );

    return Semantics(
      label: widget.label,
      button: true,
      enabled: enabled,
      onTap: enabled ? widget.onPressed : null,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.onPressed == null ? AbsOpacity.disabled : 1,
        child: Padding(
          // Reserve room for the lip so pressing never shifts the layout.
          padding: EdgeInsets.only(bottom: lipDepth),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled ? (_) => _set(true) : null,
            onTapUp: enabled ? (_) => _set(false) : null,
            onTapCancel: enabled ? () => _set(false) : null,
            onTap: enabled
                ? () {
                    HapticFeedback.lightImpact();
                    widget.onPressed!();
                  }
                : null,
            child: face,
          ),
        ),
      ),
    );
  }
}
