import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Original ABS Fitness mark: a slightly tilted lime sticker with "ABS".
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = AbsSpace.x14, this.tilt = -0.08});

  final double size;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.primary;
    return Semantics(
      label: 'ABS Fitness',
      child: Transform.rotate(
        angle: tilt,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: stickerDecoration(
            c,
            color: p.fill,
            outline: c.ink,
            lip: c.isDark ? p.deep : c.ink,
            lipDepth: size * 0.07,
            borderRadius: BorderRadius.circular(size * 0.3),
          ),
          child: Text(
            'ABS',
            textScaler: TextScaler.noScaling,
            style: context.text.displayL.copyWith(color: p.onFill, fontSize: size * 0.36, height: 1),
          ),
        ),
      ),
    );
  }
}
