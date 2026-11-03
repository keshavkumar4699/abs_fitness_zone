import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../app/theme/theme.dart';
import 'member_tile.dart';
import 'status_pill.dart';

/// Shimmer skeletons that match the real list layout.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 8, this.itemBuilder});

  final int itemCount;

  /// Builds a fake item with the real layout; defaults to a member tile.
  final IndexedWidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Skeletonizer(
      // Neutral placeholders: no pop colours while loading.
      containersColor: c.surfaceRaised,
      effect: ShimmerEffect(baseColor: c.border, highlightColor: c.surfaceRaised),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder:
            itemBuilder ??
            (context, i) => const MemberTile(
              name: 'Member name here',
              plan: 'Quarterly plan',
              status: PillStatus.active,
              daysLeft: 30,
            ),
      ),
    );
  }
}

/// Generic skeleton block for non-list layouts (cards, heroes).
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Skeletonizer(
      // Neutral placeholders: no pop colours while loading.
      containersColor: c.surfaceRaised,
      effect: ShimmerEffect(baseColor: c.border, highlightColor: c.surfaceRaised),
      child: child,
    );
  }
}
