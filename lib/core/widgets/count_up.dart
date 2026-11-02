import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Animates a number from its previous value (or 0 on first show) to [value]
/// using the expressive token. Respects reduced motion.
class CountUp extends StatefulWidget {
  const CountUp({super.key, required this.value, required this.style, this.format, this.semanticsLabel});

  final num value;
  final TextStyle style;
  final String Function(num value)? format;
  final String? semanticsLabel;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  num _from = 0;

  @override
  void didUpdateWidget(CountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _from = oldWidget.value;
  }

  String _text(num v) {
    final isInt = widget.value is int;
    final shown = isInt ? v.round() : v;
    return widget.format?.call(shown) ?? shown.toString();
  }

  @override
  Widget build(BuildContext context) {
    final finalText = _text(widget.value);
    if (AbsMotion.reduced(context)) {
      return Text(finalText, style: widget.style, semanticsLabel: widget.semanticsLabel);
    }
    return Semantics(
      label: widget.semanticsLabel ?? finalText,
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: _from.toDouble(), end: widget.value.toDouble()),
        duration: AbsMotion.expressive.duration,
        // The expressive spring overshoots; a non-overshooting curve keeps
        // counts from ever showing beyond the target.
        curve: AbsMotion.quick.curve,
        builder: (context, v, _) => Text(_text(v), style: widget.style),
      ),
    );
  }
}
