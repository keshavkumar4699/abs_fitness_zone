import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/theme.dart';

/// Pill tabs with a candy indicator that bounces between segments.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.dense = false,
    this.hue = PopHue.lime,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final bool dense;
  final PopHue hue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final p = c.pop(hue);
    final height = dense ? AbsSize.touchTarget - AbsSpace.x1 : AbsSize.touchTarget + AbsSpace.x1;
    return Container(
      height: height,
      padding: const EdgeInsets.all(AbsSpace.x1),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AbsRadius.pill,
        border: Border.all(color: c.isDark ? c.border : c.ink, width: AbsDepth.outline),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segment = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: AbsMotion.bouncy.duration,
                curve: AbsMotion.bouncy.curve,
                left: segment * selected,
                top: 0,
                bottom: 0,
                width: segment,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: p.fill,
                    borderRadius: AbsRadius.pill,
                    border: Border.all(color: c.isDark ? p.deep : c.ink, width: 1.5),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == selected,
                        button: true,
                        onTap: () => onChanged(i),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          excludeFromSemantics: true,
                          onTap: () {
                            if (i == selected) return;
                            HapticFeedback.selectionClick();
                            onChanged(i);
                          },
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: AbsMotion.quick.duration,
                              curve: AbsMotion.quick.curve,
                              style: t.label.copyWith(color: i == selected ? p.onFill : c.textSecondary),
                              child: Text(labels[i], maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
