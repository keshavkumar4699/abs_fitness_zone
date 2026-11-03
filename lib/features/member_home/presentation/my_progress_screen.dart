import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../members/application/members_providers.dart';
import '../../members/presentation/member_detail_screen.dart' show AttendanceGrid, MeasurementsView;
import '../../workouts/presentation/workout_progress_card.dart';

/// Member: workouts and PRs, visits, and own measurements (read-only,
/// recorded by the trainer).
class MyProgressScreen extends ConsumerWidget {
  const MyProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final id = ref.watch(currentUserProvider).value?.memberId;
    if (id == null) return const SizedBox.shrink();
    final visits = ref.watch(memberAttendanceProvider(id)).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l.myProgressTitle)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x3),
            child: WorkoutProgressCard(memberId: id),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            child: AttendanceGrid(visits: visits),
          ),
          Expanded(child: MeasurementsView(memberId: id, canAdd: false)),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
