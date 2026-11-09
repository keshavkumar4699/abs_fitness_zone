import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/presentation/widgets/member_photo.dart';
import '../application/whatsapp_providers.dart';
import '../data/whatsapp_repository.dart';
import '../domain/whatsapp_models.dart';
import 'whatsapp_ui.dart';

/// The free-mode send queue (8.9): each row opens WhatsApp with the message
/// ready; coming back ticks it as sent. "Send next" walks the queue.
class SendQueueView extends ConsumerStatefulWidget {
  const SendQueueView({super.key, required this.mode});

  final WhatsAppMode mode;

  @override
  ConsumerState<SendQueueView> createState() => _SendQueueViewState();
}

class _SendQueueViewState extends ConsumerState<SendQueueView> {
  /// Opened in WhatsApp; ticked when the app comes back to the front.
  QueuedMessage? _pending;
  late final AppLifecycleListener _life;
  bool _building = false;

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(onResume: _onResume);
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  void _onResume() {
    final m = _pending;
    if (m == null || !mounted) return;
    setState(() => _pending = null);
    _mark(m, MessageStatus.sent);
  }

  Future<void> _open(QueuedMessage m) async {
    final l = context.l10n;
    // Moving on to another message means the last one was sent.
    final previous = _pending;
    if (previous != null && previous.id != m.id) {
      setState(() => _pending = null);
      await _mark(previous, MessageStatus.sent, quiet: true);
    }
    final ok = await ref.read(whatsAppLauncherProvider)(m.memberPhone, m.body);
    if (!mounted) return;
    if (!ok) {
      showAbsSnackbar(context, l.waNoWhatsApp, tone: SnackTone.error);
      return;
    }
    setState(() => _pending = m);
  }

  Future<void> _mark(QueuedMessage m, MessageStatus status, {bool quiet = false}) async {
    final l = context.l10n;
    final first = m.memberName.split(' ').first;
    try {
      await ref.read(sendQueueProvider.notifier).mark(m, status);
      if (!mounted || quiet) return;
      showAbsSnackbar(
        context,
        status == MessageStatus.sent ? l.waMarkedSent(first) : l.waMarkedSkipped(first),
        tone: SnackTone.success,
        onUndo: () => _undo(m.copyWith(status: status)),
      );
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  Future<void> _undo(QueuedMessage m) async {
    try {
      await ref.read(sendQueueProvider.notifier).mark(m, MessageStatus.queued);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(context.l10n, e), tone: SnackTone.error);
    }
  }

  Future<void> _buildToday() async {
    final l = context.l10n;
    setState(() => _building = true);
    try {
      final counts = await ref.read(whatsAppRepositoryProvider).buildToday();
      ref.refreshWhatsApp();
      if (!mounted) return;
      final n = counts.values.fold<int>(0, (a, b) => a + b);
      showAbsSnackbar(context, l.waBuilt(n), tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _building = false);
    }
  }

  Future<void> _sendNow() async {
    final l = context.l10n;
    try {
      await ref.read(whatsAppRepositoryProvider).sendNow();
      ref.refreshWhatsApp();
      if (mounted) showAbsSnackbar(context, l.waSendNowDone, tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final queue = ref.watch(sendQueueProvider);
    final items = queue.value?.items ?? const <QueuedMessage>[];
    final open = items.where((m) => m.status == MessageStatus.queued).toList();
    final next = open.where((m) => m.id != _pending?.id).firstOrNull ?? open.firstOrNull;
    final left = open.length + ((queue.value?.hasMore ?? false) ? 1 : 0);

    Widget header() => Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              queue.value?.hasMore ?? false ? l.waQueueLeftMore(open.length) : l.waQueueLeft(open.length),
              style: t.title,
            ),
          ),
          if (widget.mode == WhatsAppMode.api)
            AbsButton.ghost(
              key: const ValueKey('wa-send-now'),
              label: l.waSendNow,
              icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
              hue: PopHue.mint,
              onPressed: _sendNow,
            ),
          IconButton(
            key: const ValueKey('wa-build'),
            tooltip: l.waBuildToday,
            onPressed: _building ? null : _buildToday,
            icon: Icon(PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold)),
          ),
        ],
      ),
    );

    final list = NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 600) ref.read(sendQueueProvider.notifier).loadMore();
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(queueSummaryProvider);
          return ref.refresh(sendQueueProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x2,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSize.buttonHeight + AbsSpace.x8,
          ),
          children: [
            header(),
            if (widget.mode == WhatsAppMode.api) ...[
              Text(l.waApiQueueNote, style: t.caption.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x3),
            ],
            switch (queue) {
              AsyncData() when items.isEmpty => EmptyState(
                title: l.waQueueEmptyTitle,
                message: l.waQueueEmptyBody,
                illustration: EmptyIllustration.rocket,
                hue: PopHue.mint,
                actionLabel: l.waBuildToday,
                onAction: _building ? null : _buildToday,
              ),
              AsyncData() => Column(
                children: [
                  for (final m in items)
                    _QueueRow(
                      key: ValueKey(m.id),
                      message: m,
                      pending: m.id == _pending?.id,
                      onSend: () => _open(m),
                      onSkip: () => _mark(m, MessageStatus.skipped),
                      onMarkSent: () {
                        setState(() => _pending = null);
                        _mark(m, MessageStatus.sent);
                      },
                      onUndo: () => _undo(m),
                    ),
                  if (queue.value.loadingMore) const SizedBox(height: 120, child: SkeletonList(itemCount: 1)),
                ],
              ),
              AsyncError(:final error) => ErrorState(
                message: friendlyError(l, error),
                onRetry: () => ref.invalidate(sendQueueProvider),
              ),
              _ => const SizedBox(height: 420, child: SkeletonList(itemCount: 4)),
            },
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(child: list),
        if (next != null)
          Positioned(
            left: context.screenPadding,
            right: context.screenPadding,
            bottom: MediaQuery.paddingOf(context).bottom + AbsSpace.x4,
            child: AbsButton(
              key: const ValueKey('wa-next'),
              label: l.waSendNext(next.memberName.split(' ').first, left),
              icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
              hue: PopHue.mint,
              onPressed: () => _open(next),
            ),
          ),
      ],
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({
    super.key,
    required this.message,
    required this.pending,
    required this.onSend,
    required this.onSkip,
    required this.onMarkSent,
    required this.onUndo,
  });

  final QueuedMessage message;
  final bool pending;
  final VoidCallback onSend;
  final VoidCallback onSkip;
  final VoidCallback onMarkSent;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final m = message;
    final done = m.status != MessageStatus.queued;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AnimatedOpacity(
        duration: AbsMotion.quick.duration,
        opacity: done ? 0.6 : 1,
        child: AbsCard(
          hue: pending ? PopHue.mint : null,
          padding: const EdgeInsets.all(AbsSpace.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MemberPhoto(name: m.memberName, path: m.memberPhoto, size: 40),
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.memberName, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          '${messageKindLabel(l, m.kind)} · ${IstDates.formatTime(m.scheduledFor)}',
                          style: t.caption.copyWith(color: c.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (done)
                    PopSticker(label: messageStatusLabel(l, m.status), hue: messageStatusHue(m.status))
                  else
                    IconBubble(icon: messageKindIcon(m.kind), hue: messageKindHue(m.kind), size: 32),
                ],
              ),
              const SizedBox(height: AbsSpace.x3),
              Text(m.body, style: t.body, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: AbsSpace.x3),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (done)
                    AbsButton.ghost(
                      key: ValueKey('wa-undo-${m.id}'),
                      label: l.commonUndo,
                      icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.bold),
                      onPressed: onUndo,
                    )
                  else ...[
                    AbsButton.ghost(
                      key: ValueKey('wa-skip-${m.id}'),
                      label: l.waSkip,
                      hue: PopHue.grape,
                      onPressed: onSkip,
                    ),
                    const SizedBox(width: AbsSpace.x2),
                    if (pending)
                      AbsButton(
                        key: ValueKey('wa-mark-${m.id}'),
                        label: l.waMarkSent,
                        icon: PhosphorIcons.check(PhosphorIconsStyle.bold),
                        hue: PopHue.mint,
                        expand: false,
                        onPressed: onMarkSent,
                      )
                    else
                      AbsButton(
                        key: ValueKey('wa-send-${m.id}'),
                        label: l.waSend,
                        icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
                        hue: PopHue.mint,
                        expand: false,
                        onPressed: onSend,
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
