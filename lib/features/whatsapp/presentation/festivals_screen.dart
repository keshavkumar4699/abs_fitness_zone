import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/providers.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../application/whatsapp_providers.dart';
import '../data/whatsapp_repository.dart';
import '../domain/whatsapp_models.dart';
import 'whatsapp_ui.dart';

/// Festival calendar (8.6): wishes go out at 9:00 am on the day to the
/// chosen segment. Lunar dates move every year, so the owner edits them.
class FestivalsScreen extends ConsumerWidget {
  const FestivalsScreen({super.key});

  Future<void> _toggle(BuildContext context, WidgetRef ref, Festival f, bool on) async {
    try {
      await ref.read(whatsAppRepositoryProvider).saveFestival(f.copyWith(isEnabled: on));
      ref.invalidate(festivalsProvider);
    } catch (e) {
      if (context.mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final festivals = ref.watch(festivalsProvider);
    final today = IstDates.today(now: ref.watch(clockProvider)());
    return Scaffold(
      appBar: AppBar(title: Text(l.waFestivalsTitle)),
      floatingActionButton: owner
          ? Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              child: FloatingActionButton.extended(
                key: const ValueKey('fest-add'),
                onPressed: () => showFestivalEditor(context, null),
                icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
                label: Text(l.waFestivalAdd),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(festivalsProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x2,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
          ),
          children: [
            Text(l.waFestivalsNote, style: t.caption.copyWith(color: c.textSecondary)),
            const SizedBox(height: AbsSpace.x3),
            AsyncView<List<Festival>>(
              value: festivals,
              onRetry: () => ref.invalidate(festivalsProvider),
              loading: const SizedBox(height: 480, child: SkeletonList(itemCount: 5)),
              empty: EmptyState(
                title: l.waFestivalsEmptyTitle,
                message: l.waFestivalsEmptyBody,
                illustration: EmptyIllustration.trophy,
                hue: PopHue.bubblegum,
                actionLabel: owner ? l.waFestivalAdd : null,
                onAction: owner ? () => showFestivalEditor(context, null) : null,
              ),
              data: (list) => Column(
                children: [
                  for (final f in list)
                    () {
                      final days = f.day.difference(today).inDays;
                      return Padding(
                        key: ValueKey(f.id),
                        padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                        child: AbsCard(
                          onTap: owner ? () => showFestivalEditor(context, f) : null,
                          padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
                          child: Row(
                            children: [
                              IconBubble(
                                icon: PhosphorIcons.confetti(PhosphorIconsStyle.bold),
                                hue: days < 0 ? PopHue.grape : PopHue.bubblegum,
                                size: 40,
                              ),
                              const SizedBox(width: AbsSpace.x3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [f.name, if (f.localName?.trim().isNotEmpty ?? false) f.localName!].join(' · '),
                                      style: t.heading,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${IstDates.formatDate(f.day, isDateOnly: true)} · '
                                      '${days < 0 ? l.waFestivalPast : l.waFestivalIn(days)} · '
                                      '${segmentLabel(l, f.segment)}',
                                      style: t.caption.copyWith(color: c.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                key: ValueKey('fest-on-${f.id}'),
                                value: f.isEnabled,
                                onChanged: owner && days >= 0 ? (v) => _toggle(context, ref, f, v) : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showFestivalEditor(BuildContext context, Festival? festival) => showAbsBottomSheet<void>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _FestivalEditor(festival: festival, scroll: controller),
);

class _FestivalEditor extends ConsumerStatefulWidget {
  const _FestivalEditor({required this.festival, required this.scroll});

  final Festival? festival;
  final ScrollController scroll;

  @override
  ConsumerState<_FestivalEditor> createState() => _FestivalEditorState();
}

class _FestivalEditorState extends ConsumerState<_FestivalEditor> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.festival?.name ?? '');
  late final _local = TextEditingController(text: widget.festival?.localName ?? '');
  late final _message = TextEditingController(text: widget.festival?.message ?? '');
  late DateTime _day = widget.festival?.day ?? IstDates.today().add(const Duration(days: 7));
  late String _segment = widget.festival?.segment.kind == 'active' ? 'active' : 'all';
  late bool _enabled = widget.festival?.isEnabled ?? true;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _local.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final today = IstDates.today();
    final picked = await showDatePicker(
      context: context,
      firstDate: today.subtract(const Duration(days: 30)),
      lastDate: today.add(const Duration(days: 730)),
      initialDate: _day,
    );
    if (picked != null) setState(() => _day = DateTime.utc(picked.year, picked.month, picked.day));
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(whatsAppRepositoryProvider)
          .saveFestival(
            Festival(
              id: widget.festival?.id ?? '',
              name: _name.text,
              localName: _local.text,
              day: _day,
              message: _message.text,
              segment: Segment(_segment),
              isEnabled: _enabled,
            ),
          );
      ref.invalidate(festivalsProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
      showAbsSnackbar(context, l.waFestivalSaved, tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    try {
      await ref.read(whatsAppRepositoryProvider).deleteFestival(widget.festival!.id);
      ref.invalidate(festivalsProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    const gap = SizedBox(height: AbsSpace.x4);
    return Form(
      key: _form,
      child: ListView(
        controller: widget.scroll,
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.viewInsetsOf(context).bottom + AbsSpace.x8,
        ),
        children: [
          Text(widget.festival == null ? l.waFestivalAdd : widget.festival!.name, style: t.title),
          gap,
          AbsTextField(
            key: const ValueKey('fest-name'),
            label: l.waFestivalName,
            controller: _name,
            maxLength: 60,
            validator: (v) => (v ?? '').trim().length < 2 ? l.waNeedTitle : null,
          ),
          gap,
          AbsTextField(label: l.waFestivalLocalName, controller: _local, maxLength: 60),
          gap,
          AbsCard(
            key: const ValueKey('fest-day'),
            onTap: _pickDay,
            padding: const EdgeInsets.all(AbsSpace.x4),
            child: Row(
              children: [
                Icon(PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold)),
                const SizedBox(width: AbsSpace.x3),
                Expanded(child: Text(l.waFestivalDate, style: t.body)),
                Text(IstDates.formatDate(_day, isDateOnly: true), style: t.heading),
              ],
            ),
          ),
          gap,
          TextFormField(
            controller: _message,
            minLines: 2,
            maxLines: 6,
            maxLength: 1000,
            decoration: InputDecoration(labelText: l.waFestivalMessage, helperText: l.waFestivalMessageHelp),
          ),
          gap,
          Text(l.waSegment, style: t.heading),
          const SizedBox(height: AbsSpace.x2),
          PopSingleChips<String>(
            options: const ['all', 'active'],
            labelOf: (k) => segmentLabel(l, Segment(k)),
            value: _segment,
            allowEmpty: false,
            hue: PopHue.mint,
            onChanged: (k) => setState(() => _segment = k ?? _segment),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.waFestivalOn, style: t.body),
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),
          Text(l.waFestivalMarketingNote, style: t.caption.copyWith(color: c.textSecondary)),
          gap,
          AbsButton(
            key: const ValueKey('fest-save'),
            label: l.commonSave,
            hue: PopHue.mint,
            isLoading: _saving,
            onPressed: _saving ? null : _save,
          ),
          if (widget.festival != null) ...[
            const SizedBox(height: AbsSpace.x3),
            AbsButton.ghost(
              key: const ValueKey('fest-delete'),
              label: l.waFestivalDelete,
              hue: PopHue.coral,
              icon: PhosphorIcons.trash(PhosphorIconsStyle.bold),
              onPressed: _delete,
            ),
          ],
        ],
      ),
    );
  }
}
