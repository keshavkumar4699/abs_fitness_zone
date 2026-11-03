import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/theme.dart';

/// Squishes its child while pressed and fires a light haptic on tap.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.haptic = true,
    this.semanticLabel,
    this.isButton = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool haptic;
  final String? semanticLabel;
  final bool isButton;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  void _tap() {
    if (widget.haptic) HapticFeedback.lightImpact();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = AbsMotion.reduced(context);
    return Semantics(
      button: widget.isButton && _enabled,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: widget.onTap == null ? null : _tap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapDown: _enabled ? (_) => _set(true) : null,
        onTapUp: _enabled ? (_) => _set(false) : null,
        onTapCancel: _enabled ? () => _set(false) : null,
        onTap: widget.onTap == null ? null : _tap,
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _down && !reduced ? AbsMotion.pressScale : 1,
          duration: AbsMotion.instant.duration,
          curve: AbsMotion.instant.curve,
          child: widget.child,
        ),
      ),
    );
  }
}
