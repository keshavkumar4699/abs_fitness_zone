import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/application/members_providers.dart';
import '../../members/presentation/member_ui.dart' show batchLabel;
import '../../settings/data/gym_settings_repository.dart';
import '../application/whatsapp_providers.dart';
import '../data/whatsapp_repository.dart';
import '../domain/message_text.dart';
import '../domain/whatsapp_models.dart';
import 'whatsapp_ui.dart';

/// Compose once, send to a segment (8.8). Opted-out members and members
/// who never agreed to WhatsApp are skipped by the database.
class BroadcastScreen extends ConsumerStatefulWidget {
  const BroadcastScreen({super.key, this.initialSegment});

  /// Members picked in the members list (bulk WhatsApp, 1.14).
  final Segment? initialSegment;

  @override
  ConsumerState<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends ConsumerState<BroadcastScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  late Segment _segment = widget.initialSegment ?? const Segment('active');
  MessageCategory _category = MessageCategory.marketing;
  DateTime? _day;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _body.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _insert(String variable) {
    final text = _body.text;
    final sel = _body.selection;
    final at = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    final token = '{$variable}';
    _body.value = TextEditingValue(
      text: text.replaceRange(at, end, token),
      selection: TextSelection.collapsed(offset: at + token.length),
    );
  }

  Future<void> _pickDay() async {
    final today = IstDates.today();
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDate: _day ?? today.add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _day = DateTime.utc(picked.year, picked.month, picked.day));
  }

  /// 9:00 am IST on the chosen day; null = now.
  DateTime? get _scheduledFor =>
      _day == null ? null : DateTime.utc(_day!.year, _day!.month, _day!.day, 9).subtract(IstDates.offset);

  Future<void> _send() async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final r = await ref
          .read(whatsAppRepositoryProvider)
          .broadcast(
            title: _title.text,
            body: _body.text,
            category: _category,
            segment: _segment,
            scheduledFor: _scheduledFor,
          );
      ref.refreshWhatsApp();
      if (!mounted) return;
      showAbsSnackbar(
        context,
        r.skipped == 0 ? l.waBroadcastQueued(r.queued) : l.waBroadcastDone(r.queued, r.skipped),
        tone: SnackTone.success,
      );
      context.pop(true);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final trainers = ref.watch(trainersProvider).value ?? const [];
    final gym = ref.watch(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
    final count = _segment.isComplete ? ref.watch(segmentCountProvider(_segment)) : null;
    final kinds = [...Segment.kinds, if (_segment.kind == 'members') 'members'];
    const gap = SizedBox(height: AbsSpace.x4);

    return Scaffold(
      appBar: AppBar(title: Text(l.waBroadcastTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x3),
          child: AbsButton(
            key: const ValueKey('wa-broadcast-send'),
            label: count?.value == null ? l.waQueueBroadcast : l.waQueueBroadcastN(count!.value!.reachable),
            icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
            hue: PopHue.mint,
            isLoading: _saving,
            onPressed: _saving || !_segment.isComplete || (count?.value?.reachable ?? 1) == 0 ? null : _send,
          ),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x8),
          children: [
            AbsTextField(
              key: const ValueKey('wa-broadcast-title'),
              label: l.waBroadcastName,
              controller: _title,
              maxLength: 80,
              validator: (v) => (v ?? '').trim().length < 2 ? l.waNeedTitle : null,
            ),
            gap,
            TextFormField(
              key: const ValueKey('wa-broadcast-body'),
              controller: _body,
              minLines: 4,
              maxLines: 10,
              maxLength: 1000,
              decoration: InputDecoration(labelText: l.waBroadcastMessage),
              validator: (v) => (v ?? '').trim().length < 2 ? l.waNeedMessage : null,
            ),
            Text(l.waInsertVariable, style: t.caption.copyWith(color: c.textSecondary)),
            const SizedBox(height: AbsSpace.x2),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                for (final v in kBroadcastVariables)
                  PopChip(label: '{$v}', selected: false, hue: PopHue.sky, onTap: () => _insert(v)),
              ],
            ),
            gap,
            Text(l.waCategory, style: t.heading),
            const SizedBox(height: AbsSpace.x2),
            PopSingleChips<MessageCategory>(
              options: const [MessageCategory.marketing, MessageCategory.utility],
              labelOf: (v) => v == MessageCategory.marketing ? l.waCategoryMarketing : l.waCategoryUtility,
              value: _category,
              allowEmpty: false,
              hue: PopHue.bubblegum,
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: AbsSpace.x2),
            Text(l.waCategoryHelp, style: t.caption.copyWith(color: c.textSecondary)),
            gap,
            Text(l.waSegment, style: t.heading),
            const SizedBox(height: AbsSpace.x2),
            PopSingleChips<String>(
              key: const ValueKey('wa-segments'),
              options: kinds,
              labelOf: (k) => k == 'members' ? segmentLabel(l, _segment) : segmentLabel(l, Segment(k)),
              value: _segment.kind,
              allowEmpty: false,
              hue: PopHue.mint,
              onChanged: (k) {
                if (k == null || k == _segment.kind) return;
                setState(() => _segment = k == 'members' ? widget.initialSegment! : Segment(k));
              },
            ),
            if (_segment.kind == 'trainer') ...[
              const SizedBox(height: AbsSpace.x3),
              PopSingleChips<String>(
                options: [for (final tr in trainers) tr.id],
                labelOf: (id) => trainers.firstWhere((tr) => tr.id == id).name,
                value: _segment.trainerId,
                allowEmpty: false,
                hue: PopHue.grape,
                onChanged: (id) => setState(() => _segment = Segment('trainer', trainerId: id)),
              ),
            ],
            if (_segment.kind == 'batch') ...[
              const SizedBox(height: AbsSpace.x3),
              PopSingleChips<String>(
                options: const ['morning', 'evening'],
                labelOf: (b) => batchLabel(l, b),
                value: _segment.batch,
                allowEmpty: false,
                hue: PopHue.grape,
                onChanged: (b) => setState(() => _segment = Segment('batch', batch: b)),
              ),
            ],
            const SizedBox(height: AbsSpace.x3),
            if (count != null)
              AsyncView<SegmentCount>(
                value: count,
                isEmpty: (_) => false,
                empty: const SizedBox.shrink(),
                onRetry: () => ref.invalidate(segmentCountProvider(_segment)),
                loading: const SkeletonBlock(child: SizedBox(height: 56, width: double.infinity)),
                data: (n) => AbsCard(
                  key: const ValueKey('wa-reach'),
                  hue: n.reachable == 0 ? PopHue.coral : PopHue.mint,
                  padding: const EdgeInsets.all(AbsSpace.x4),
                  child: Row(
                    children: [
                      IconBubble(icon: PhosphorIcons.usersThree(PhosphorIconsStyle.bold), hue: PopHue.mint, size: 36),
                      const SizedBox(width: AbsSpace.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.waReach(n.reachable, n.total), style: t.heading),
                            Text(l.waReachNote, style: t.caption.copyWith(color: c.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            gap,
            Text(l.waSchedule, style: t.heading),
            const SizedBox(height: AbsSpace.x2),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                PopChip(
                  label: l.waScheduleNow,
                  selected: _day == null,
                  hue: PopHue.sky,
                  onTap: () => setState(() => _day = null),
                ),
                PopChip(
                  label: _day == null ? l.waSchedulePick : l.waScheduleOn(IstDates.formatDate(_day!, isDateOnly: true)),
                  icon: PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                  selected: _day != null,
                  hue: PopHue.sky,
                  onTap: _pickDay,
                ),
              ],
            ),
            gap,
            Text(l.waPreview, style: t.heading),
            const SizedBox(height: AbsSpace.x2),
            MessageBubble(
              text: _body.text.trim().isEmpty
                  ? l.waPreviewEmpty
                  : renderMessage(_body.text.trim(), sampleVariables(firstName: l.waSampleName, gym: gym)),
            ),
          ],
        ),
      ),
    );
  }
}

/// A WhatsApp-style chat bubble for previews.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(PopHue.mint);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        key: const ValueKey('wa-preview'),
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(AbsSpace.x3),
        decoration: BoxDecoration(
          color: p.soft,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AbsRadius.chip / 3),
            topRight: Radius.circular(AbsRadius.button),
            bottomLeft: Radius.circular(AbsRadius.button),
            bottomRight: Radius.circular(AbsRadius.button),
          ),
          border: Border.all(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline),
        ),
        child: Text(text, style: context.text.body.copyWith(color: c.textPrimary)),
      ),
    );
  }
}
