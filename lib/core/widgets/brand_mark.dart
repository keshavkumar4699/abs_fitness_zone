import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Original ABS Fitness mark: "ABS" in the display face on a Volt tile.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = AbsSpace.x14});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: 'ABS Fitness',
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(size * 0.28)),
        child: Text(
          'ABS',
          textScaler: TextScaler.noScaling,
          style: context.text.title.copyWith(
            color: c.onAccent,
            fontSize: size * 0.32,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
