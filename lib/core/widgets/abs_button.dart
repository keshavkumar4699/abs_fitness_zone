import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/theme/theme.dart';
import 'pressable.dart';

enum AbsButtonVariant { primary, secondary, ghost, destructive }

/// Height 52, radius 14. Loading morphs the label into a progress ring while
/// keeping the width; success morphs it into a check with a medium haptic.
class AbsButton extends StatefulWidget {
  const AbsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AbsButtonVariant.primary,
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
  }) : variant = AbsButtonVariant.secondary;

  const AbsButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
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
  }) : variant = AbsButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final AbsButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isSuccess;
  final bool expand;

  @override
  State<AbsButton> createState() => _AbsButtonState();
}

class _AbsButtonState extends State<AbsButton> {
  @override
  void didUpdateWidget(AbsButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final busy = widget.isLoading || widget.isSuccess;
    final enabled = widget.onPressed != null && !busy;

    final (Color bg, Color fg, Color? border) = switch (widget.variant) {
      AbsButtonVariant.primary => (c.accent, c.onAccent, null),
      AbsButtonVariant.secondary => (c.surface, c.textPrimary, c.border),
      AbsButtonVariant.ghost => (Colors.transparent, c.accentText, null),
      AbsButtonVariant.destructive => (c.danger, c.onAccent, null),
    };

    final label = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: AbsSize.iconSmall, color: fg),
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
        ? Icon(PhosphorIcons.check(PhosphorIconsStyle.bold), key: const ValueKey('success'), color: fg)
        : widget.isLoading
        ? SizedBox.square(
            key: const ValueKey('loading'),
            dimension: AbsSize.iconSmall,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : const SizedBox.shrink(key: ValueKey('idle'));

    final content = Stack(
      alignment: Alignment.center,
      children: [
        // The label stays in the tree (invisible while busy) so width is preserved.
        AnimatedOpacity(
          opacity: busy ? 0 : 1,
          duration: AbsMotion.quick.duration,
          curve: AbsMotion.quick.curve,
          child: label,
        ),
        AnimatedSwitcher(
          duration: AbsMotion.quick.duration,
          switchInCurve: AbsMotion.quick.curve,
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: overlay,
        ),
      ],
    );

    return Semantics(
      label: widget.label,
      button: true,
      enabled: enabled,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.onPressed == null ? AbsOpacity.disabled : 1,
        child: Pressable(
          onTap: enabled ? widget.onPressed : null,
          child: AnimatedContainer(
            duration: AbsMotion.quick.duration,
            curve: AbsMotion.quick.curve,
            height: AbsSize.buttonHeight,
            width: widget.expand ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x5),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: AbsRadius.buttonAll,
              border: border == null ? null : Border.all(color: border),
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
