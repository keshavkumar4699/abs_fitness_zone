import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../members/application/members_providers.dart';
import '../application/whatsapp_providers.dart';
import '../domain/whatsapp_models.dart';
import 'message_log_view.dart';
import 'send_queue_view.dart';
import 'whatsapp_ui.dart';

/// WhatsApp home for the front desk and owner: today's queue, the log and
/// broadcasts, with templates, festivals and settings one tap away.
class WhatsAppScreen extends ConsumerStatefulWidget {
  const WhatsAppScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<WhatsAppScreen> createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends ConsumerState<WhatsAppScreen> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final settings = ref.watch(whatsAppSettingsProvider);
    final mode = settings.value?.mode ?? WhatsAppMode.link;
    final api = mode == WhatsAppMode.api;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.waTitle),
        actions: [
          IconButton(
            key: const ValueKey('wa-templates'),
            tooltip: l.waTemplatesTitle,
            icon: Icon(PhosphorIcons.chatText(PhosphorIconsStyle.bold)),
            onPressed: () => context.push(Routes.whatsAppTemplates),
          ),
          IconButton(
            key: const ValueKey('wa-festivals'),
            tooltip: l.waFestivalsTitle,
            icon: Icon(PhosphorIcons.confetti(PhosphorIconsStyle.bold)),
            onPressed: () => context.push(Routes.whatsAppFestivals),
          ),
          if (owner)
            IconButton(
              key: const ValueKey('wa-settings'),
              tooltip: l.waSettingsTitle,
              icon: Icon(PhosphorIcons.gearSix(PhosphorIconsStyle.bold)),
              onPressed: () => context.push(Routes.whatsAppSettings),
            ),
        ],
      ),
      floatingActionButton: _tab == 0
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              child: FloatingActionButton.extended(
                key: const ValueKey('wa-new-broadcast'),
                onPressed: () => context.push(Routes.whatsAppBroadcast),
                icon: Icon(PhosphorIcons.megaphone(PhosphorIconsStyle.bold)),
                label: Text(l.waNewBroadcast),
              ),
            ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x3),
            child: Row(
              children: [
                PopSticker(
                  key: const ValueKey('wa-mode'),
                  label: api ? l.waModeApi : l.waModeFree,
                  hue: api ? PopHue.sky : PopHue.mint,
                  dot: true,
                ),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Text(
                    api ? l.waModeApiBody : l.waModeFreeBody,
                    style: t.caption.copyWith(color: c.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            child: SegmentedTabs(
              labels: [l.waTabQueue, l.waTabLog, l.waTabBroadcasts],
              selected: _tab,
              hue: PopHue.mint,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          const SizedBox(height: AbsSpace.x3),
          Expanded(
            child: switch (_tab) {
              0 => SendQueueView(mode: mode),
              1 => const MessageLogView(),
              _ => const _BroadcastList(),
            },
          ),
        ],
      ),
    );
  }
}

class _BroadcastList extends ConsumerWidget {
  const _BroadcastList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final list = ref.watch(broadcastListProvider);
    final trainers = ref.watch(trainersProvider).value ?? const [];
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 600) ref.read(broadcastListProvider.notifier).loadMore();
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(broadcastListProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            0,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
          ),
          children: [
            switch (list) {
              AsyncData(:final value) when value.items.isNotEmpty => Column(
                children: [
                  for (final b in value.items)
                    Padding(
                      key: ValueKey(b.id),
                      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                      child: AbsCard(
                        padding: const EdgeInsets.all(AbsSpace.x4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconBubble(
                                  icon: PhosphorIcons.megaphone(PhosphorIconsStyle.bold),
                                  hue: b.category == MessageCategory.marketing ? PopHue.bubblegum : PopHue.sky,
                                  size: 36,
                                ),
                                const SizedBox(width: AbsSpace.x3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(b.title, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text(
                                        '${segmentLabel(l, b.segment, trainers: trainers)} · '
                                        '${IstDates.formatDateTime(b.scheduledFor)}',
                                        style: t.caption.copyWith(color: c.textSecondary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AbsSpace.x3),
                            Text(b.body, style: t.body, maxLines: 3, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: AbsSpace.x3),
                            Wrap(
                              spacing: AbsSpace.x2,
                              runSpacing: AbsSpace.x2,
                              children: [
                                PopSticker(label: l.waBroadcastQueued(b.queued), hue: PopHue.mint),
                                if (b.skipped > 0)
                                  PopSticker(label: l.waBroadcastSkipped(b.skipped), hue: PopHue.grape),
                                PopSticker(label: categoryLabel(l, b.category), hue: PopHue.sky),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (value.loadingMore) const SizedBox(height: 120, child: SkeletonList(itemCount: 1)),
                ],
              ),
              AsyncData() => EmptyState(
                title: l.waBroadcastsEmptyTitle,
                message: l.waBroadcastsEmptyBody,
                illustration: EmptyIllustration.rocket,
                hue: PopHue.bubblegum,
                actionLabel: l.waNewBroadcast,
                onAction: () => context.push(Routes.whatsAppBroadcast),
              ),
              AsyncError(:final error) => ErrorState(
                message: friendlyError(l, error),
                onRetry: () => ref.invalidate(broadcastListProvider),
              ),
              _ => const SizedBox(height: 420, child: SkeletonList(itemCount: 4)),
            },
          ],
        ),
      ),
    );
  }
}
