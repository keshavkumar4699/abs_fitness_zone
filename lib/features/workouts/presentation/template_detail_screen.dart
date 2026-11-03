import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../exercises/application/exercise_providers.dart';
import '../../exercises/presentation/exercise_ui.dart';
import '../../members/presentation/member_ui.dart' show levelLabel;
import '../../payments/application/receipt_pdf.dart' show ReceiptFonts;
import '../../settings/data/gym_settings_repository.dart';
import '../application/workouts_providers.dart';
import '../data/workouts_repository.dart';
import '../domain/workout_models.dart';
import 'assign_sheet.dart';
import 'plan_share.dart';
import 'workout_ui.dart';

/// A program in the gym library (5.3): its days and exercises, and the
/// actions to assign, duplicate, edit, share or remove it.
class TemplateDetailScreen extends ConsumerWidget {
  const TemplateDetailScreen({super.key, required this.templateId});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final template = ref.watch(templateDetailProvider(templateId));
    final role = ref.watch(currentUserProvider).value?.role;
    final coach = role == UserRole.owner || role == UserRole.trainer;
    return Scaffold(
      appBar: AppBar(
        title: Text(template.value?.name ?? l.wkProgram, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (template.value != null) ShareMenu(template: template.value!),
          if (coach && template.value != null)
            PopupMenuButton<String>(
              tooltip: l.actionMore,
              onSelected: (a) => _menu(context, ref, a, template.value!),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: Text(l.progEdit)),
                PopupMenuItem(value: 'duplicate', child: Text(l.progDuplicate)),
                PopupMenuItem(
                  value: 'archive',
                  child: Text(l.progArchive, style: TextStyle(color: context.colors.danger)),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: coach && template.value != null
          ? FloatingActionButton.extended(
              key: const ValueKey('template-assign'),
              onPressed: () => showAssignSheet(context, template: template.value!),
              icon: Icon(PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold)),
              label: Text(l.progAssign),
            )
          : null,
      body: AsyncView<WorkoutTemplate>(
        value: template,
        isEmpty: (_) => false,
        empty: const SizedBox.shrink(),
        onRetry: () => ref.invalidate(templateDetailProvider(templateId)),
        loading: const SkeletonList(itemCount: 5),
        data: (t) => ListView(
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x2,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
          ),
          children: [
            if (t.description != null) Text(t.description!, style: context.text.body),
            const SizedBox(height: AbsSpace.x3),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                if (t.goal != null) PopSticker(label: goalShort(l, t.goal), hue: PopHue.coral),
                if (t.level != null) PopSticker(label: levelLabel(l, t.level!), hue: PopHue.sky),
                PopSticker(label: l.progWeeks(t.weeks), hue: PopHue.grape),
                PopSticker(label: l.progDays(t.days.length), hue: PopHue.lime),
                PopSticker(label: progressionLabel(l, t), hue: PopHue.tangerine),
              ],
            ),
            const SizedBox(height: AbsSpace.x4),
            for (final d in t.orderedDays) ProgramDayCard(day: d),
          ],
        ),
      ),
    );
  }

  Future<void> _menu(BuildContext context, WidgetRef ref, String action, WorkoutTemplate t) async {
    final l = context.l10n;
    final repo = ref.read(workoutsRepositoryProvider);
    try {
      switch (action) {
        case 'edit':
          await context.push(Routes.programEdit(t.id!));
          ref.invalidate(templateDetailProvider(templateId));
        case 'duplicate':
          final name = l.progCopyName(t.name);
          final id = await repo.duplicateTemplate(t.id!, name: name);
          ref.invalidate(templateListProvider);
          if (!context.mounted) return;
          showAbsSnackbar(context, l.progDuplicated(name), tone: SnackTone.success);
          await context.push(Routes.programEdit(id));
        case 'archive':
          await repo.archiveTemplate(t.id!);
          ref.invalidate(templateListProvider);
          if (!context.mounted) return;
          showAbsSnackbar(context, l.progArchived, tone: SnackTone.success);
          context.pop();
      }
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }
}

/// Share a plan as a PDF or WhatsApp-friendly text (5.12).
class ShareMenu extends ConsumerWidget {
  const ShareMenu({super.key, required this.template, this.memberName, this.weekdays});

  final WorkoutTemplate template;
  final String? memberName;
  final List<int>? weekdays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      key: const ValueKey('share-plan'),
      tooltip: l.progShare,
      icon: Icon(PhosphorIcons.shareNetwork(PhosphorIconsStyle.bold)),
      onSelected: (kind) async {
        try {
          final catalogue = await ref.read(exerciseCatalogueProvider.future);
          final gym = ref.read(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
          if (kind == 'text') {
            await SharePlus.instance.share(
              ShareParams(
                text: planText(l, template, catalogue, memberName: memberName, weekdays: weekdays, gym: gym),
              ),
            );
          } else {
            final bytes = await planPdf(
              l,
              template,
              catalogue,
              memberName: memberName,
              weekdays: weekdays,
              gym: gym,
              fonts: await ReceiptFonts.load(),
            );
            final name = template.name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-').toLowerCase();
            await Printing.sharePdf(bytes: bytes, filename: 'abs-$name.pdf');
          }
        } catch (e) {
          if (context.mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'pdf', child: Text(l.progSharePdf)),
        PopupMenuItem(value: 'text', child: Text(l.progShareText)),
      ],
    );
  }
}
