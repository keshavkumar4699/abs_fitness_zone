import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/application/members_providers.dart';
import '../application/whatsapp_providers.dart';
import 'whatsapp_ui.dart';

String logFilterLabel(AppLocalizations l, LogFilter f) => switch (f) {
  LogFilter.all => l.waLogAll,
  LogFilter.queued => l.waLogQueued,
  LogFilter.sent => l.waLogSent,
  LogFilter.failed => l.waLogFailed,
  LogFilter.skipped => l.waLogSkipped,
};

/// The message log (8.13): template, time, channel and status, gym-wide or
/// for one member, filtered by status.
class MessageLogView extends ConsumerStatefulWidget {
  const MessageLogView({super.key, this.memberId});

  final String? memberId;

  @override
  ConsumerState<MessageLogView> createState() => _MessageLogViewState();
}

class _MessageLogViewState extends ConsumerState<MessageLogView> {
  LogFilter _filter = LogFilter.all;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = messageLogProvider(widget.memberId, _filter);
    final log = ref.watch(provider);
    final forMember = widget.memberId != null;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 600) ref.read(provider.notifier).loadMore();
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: AbsSize.touchTarget,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
                  children: [
                    for (final f in LogFilter.values) ...[
                      PopChip(
                        key: ValueKey('wa-log-${f.name}'),
                        label: logFilterLabel(l, f),
                        selected: _filter == f,
                        hue: f == LogFilter.failed ? PopHue.coral : PopHue.mint,
                        onTap: () => setState(() => _filter = f),
                      ),
                      const SizedBox(width: AbsSpace.x2),
                    ],
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AbsSpace.x3)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
              sliver: switch (log) {
                AsyncData(:final value) when value.items.isNotEmpty => SliverList.builder(
                  itemCount: value.items.length + (value.loadingMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == value.items.length) return const SizedBox(height: 120, child: SkeletonList(itemCount: 1));
                    final m = value.items[i];
                    return MessageTile(
                      key: ValueKey(m.id),
                      message: m,
                      showMember: !forMember,
                      onTap: forMember ? null : () => context.push(Routes.memberDetail(m.memberId)),
                    );
                  },
                ),
                AsyncData() => SliverToBoxAdapter(
                  child: EmptyState(
                    title: l.waLogEmptyTitle,
                    message: l.waLogEmptyBody,
                    illustration: EmptyIllustration.clock,
                    hue: PopHue.mint,
                  ),
                ),
                AsyncError(:final error) => SliverToBoxAdapter(
                  child: ErrorState(message: friendlyError(l, error), onRetry: () => ref.invalidate(provider)),
                ),
                _ => const SliverToBoxAdapter(child: SizedBox(height: 420, child: SkeletonList(itemCount: 4))),
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2)),
          ],
        ),
      ),
    );
  }
}

/// One member's messages (opened from the member's WhatsApp card).
class MemberMessagesScreen extends ConsumerWidget {
  const MemberMessagesScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final name = ref.watch(memberProvider(memberId)).value?.name;
    return Scaffold(
      appBar: AppBar(title: Text(name == null ? l.waMemberMessages : l.waMemberMessagesOf(name.split(' ').first))),
      body: MessageLogView(memberId: memberId),
    );
  }
}
