import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/theme.dart';

/// Pill indicator that slides between equal-width segments.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.dense = false,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final height = dense ? AbsSize.touchTarget - AbsSpace.x2 : AbsSize.touchTarget;
    return Container(
      height: height,
      padding: const EdgeInsets.all(AbsSpace.x1),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AbsRadius.pill,
        border: Border.all(color: c.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segment = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: AbsMotion.quick.duration,
                curve: AbsMotion.quick.curve,
                left: segment * selected,
                top: 0,
                bottom: 0,
                width: segment,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: c.accent, borderRadius: AbsRadius.pill),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == selected,
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (i == selected) return;
                            HapticFeedback.selectionClick();
                            onChanged(i);
                          },
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: AbsMotion.quick.duration,
                              curve: AbsMotion.quick.curve,
                              style: t.label.copyWith(
                                color: i == selected ? c.onAccent : c.textSecondary,
                                fontWeight: i == selected ? FontWeight.w600 : FontWeight.w500,
                              ),
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
