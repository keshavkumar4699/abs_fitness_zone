import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Opens a sheet with a drag handle and 28 px top radius that snaps at 50%
/// and 92% of the screen height. Used for quick actions instead of screens.
Future<T?> showAbsBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context, ScrollController controller) builder,
  bool expandToFull = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    sheetAnimationStyle: AnimationStyle(
      duration: AbsMotion.standard.duration,
      reverseDuration: AbsMotion.quick.duration,
      curve: AbsMotion.standard.curve,
    ),
    builder: (context) =>
        _SnappingSheet(initial: expandToFull ? AbsSheetSnap.full : AbsSheetSnap.half, builder: builder),
  );
}

abstract final class AbsSheetSnap {
  static const half = 0.5;
  static const full = 0.92;
}

class _SnappingSheet extends StatelessWidget {
  const _SnappingSheet({required this.initial, required this.builder});

  final double initial;
  final Widget Function(BuildContext context, ScrollController controller) builder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Keep the sheet above the keyboard.
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: initial,
        minChildSize: AbsSheetSnap.half - 0.1,
        maxChildSize: AbsSheetSnap.full,
        snap: true,
        snapSizes: const [AbsSheetSnap.half, AbsSheetSnap.full],
        snapAnimationDuration: AbsMotion.standard.duration,
        builder: (context, controller) => DecoratedBox(
          decoration: BoxDecoration(color: c.surfaceRaised, borderRadius: AbsRadius.sheetTop),
          child: Column(
            children: [
              const SizedBox(height: AbsSpace.x3),
              Container(
                width: AbsSize.dragHandleWidth,
                height: AbsSize.dragHandleHeight,
                decoration: BoxDecoration(color: c.border, borderRadius: AbsRadius.pill),
              ),
              const SizedBox(height: AbsSpace.x3),
              Expanded(child: builder(context, controller)),
            ],
          ),
        ),
      ),
    );
  }
}
