import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../diet/presentation/diet_training_views.dart';
import '../../exercises/presentation/exercise_library.dart';
import '../../shell/staff_shell.dart' show StaffHues;
import 'coach_members_view.dart';
import 'programs_view.dart';

/// Staff "Plans" tab, in two areas. Workouts: My members (coaches), the
/// program library and the exercise library. Diet: the nutrition overview
/// (coaches), the diet plan library and the food database. Front desk can
/// browse the libraries; only coaches build and assign.
class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  int _tab = 0;
  int _area = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();
    final coach = user.role == UserRole.owner || user.role == UserRole.trainer;
    final diet = _area == 1;
    final tabs = diet
        ? [if (coach) l.trainTabMembers, l.trainTabDiets, l.trainTabFoods]
        : [if (coach) l.trainTabMembers, l.trainTabPrograms, l.trainTabExercises];
    final tab = _tab.clamp(0, tabs.length - 1);
    final kind = tabs[tab];
    final footer = AbsSpace.x14 * 2 + MediaQuery.paddingOf(context).bottom;

    Widget? fab;
    if (coach && diet && kind == l.trainTabDiets) {
      fab = AbsButton(
        key: const ValueKey('new-diet'),
        label: l.dietNew,
        icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
        hue: PopHue.mint,
        expand: false,
        onPressed: () => context.push(Routes.dietNew),
      );
    } else if (coach && diet && kind == l.trainTabFoods) {
      fab = AbsButton(
        key: const ValueKey('new-food'),
        label: l.foodAdd,
        icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
        hue: PopHue.mint,
        expand: false,
        onPressed: () => context.push(Routes.foodNew),
      );
    } else if (coach && kind == l.trainTabPrograms) {
      fab = AbsButton(
        key: const ValueKey('new-program'),
        label: l.progNew,
        icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
        hue: StaffHues.plans,
        expand: false,
        onPressed: () => context.push(Routes.programNew),
      );
    } else if (coach && kind == l.trainTabExercises) {
      fab = AbsButton(
        key: const ValueKey('new-exercise'),
        label: l.exAdd,
        icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
        hue: StaffHues.plans,
        expand: false,
        onPressed: () => context.push(Routes.exerciseNew),
      );
    }

    return Scaffold(
      floatingActionButton: fab == null
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              child: fab,
            ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.trainTitle,
                      style: context.text.displayL.copyWith(fontSize: context.text.title.fontSize! * 1.3),
                    ),
                  ),
                  SizedBox(
                    width: 196,
                    child: SegmentedTabs(
                      key: const ValueKey('training-area'),
                      labels: [l.trainAreaWorkouts, l.trainAreaDiet],
                      selected: _area,
                      hue: diet ? PopHue.mint : StaffHues.plans,
                      dense: true,
                      onChanged: (i) => setState(() {
                        _area = i;
                        _tab = 0;
                      }),
                    ),
                  ),
                  if (user.role.isOwner && !diet && kind == l.trainTabExercises)
                    IconButton(
                      tooltip: l.exEquipmentTitle,
                      icon: Icon(PhosphorIcons.wrench(PhosphorIconsStyle.bold)),
                      onPressed: () => showEquipmentSheet(context),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x4),
              child: SegmentedTabs(
                labels: tabs,
                selected: tab,
                hue: diet ? PopHue.mint : StaffHues.plans,
                dense: true,
                onChanged: (i) => setState(() => _tab = i),
              ),
            ),
            Expanded(
              child: switch (kind) {
                _ when diet && kind == l.trainTabMembers => DietMembersView(footerPad: footer),
                _ when kind == l.trainTabDiets => DietPlansView(footerPad: footer),
                _ when kind == l.trainTabFoods => FoodsView(footerPad: footer),
                _ when kind == l.trainTabMembers => CoachMembersView(footerPad: footer),
                _ when kind == l.trainTabPrograms => ProgramsView(footerPad: footer),
                _ => ExerciseLibraryView(footerPad: footer, onOpen: (e) => context.push(Routes.exerciseDetail(e.id))),
              },
            ),
          ],
        ),
      ),
    );
  }
}
