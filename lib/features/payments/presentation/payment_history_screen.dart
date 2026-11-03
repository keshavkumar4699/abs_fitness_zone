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
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/payments_providers.dart';
import '../domain/payment_models.dart';
import 'payment_ui.dart';

/// Every confirmed payment, newest first, with search, mode and date filters.
class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  final _search = TextEditingController();
  PaymentFilter _filter = const PaymentFilter();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final today = IstDates.today();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.utc(today.year - 3),
      lastDate: today,
      initialDateRange: _filter.from == null ? null : DateTimeRange(start: _filter.from!, end: _filter.to ?? today),
    );
    if (range == null) return;
    setState(
      () => _filter = _filter.copyWith(
        range: (
          DateTime.utc(range.start.year, range.start.month, range.start.day),
          DateTime.utc(range.end.year, range.end.month, range.end.day),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = ref.watch(paymentHistoryProvider(_filter));
    final dates = _filter.from == null ? l.historyDates : '${dateLabel(_filter.from)} – ${dateLabel(_filter.to)}';
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 600) ref.read(paymentHistoryProvider(_filter).notifier).loadMore();
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SearchBarHero(
              title: l.historyTitle,
              hint: l.historySearchHint,
              controller: _search,
              leading: const BackButton(),
              onChanged: (v) => setState(() => _filter = _filter.copyWith(search: v.trim())),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: AbsSize.touchTarget,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
                  children: [
                    PopChip(
                      label: dates,
                      icon: PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                      selected: _filter.from != null,
                      hue: PopHue.sky,
                      onTap: _pickDates,
                    ),
                    const SizedBox(width: AbsSpace.x2),
                    PopChip(
                      label: l.historyAllModes,
                      selected: _filter.mode == null,
                      onTap: () => setState(() => _filter = _filter.copyWith(mode: () => null)),
                    ),
                    for (final m in PaymentMode.values) ...[
                      const SizedBox(width: AbsSpace.x2),
                      PopChip(
                        label: modeName(l, m),
                        selected: _filter.mode == m,
                        hue: modeHue(m),
                        onTap: () => setState(() => _filter = _filter.copyWith(mode: () => m)),
                      ),
                    ],
                    if (_filter.isFiltered) ...[
                      const SizedBox(width: AbsSpace.x2),
                      PopChip(
                        label: l.historyClear,
                        icon: PhosphorIcons.x(PhosphorIconsStyle.bold),
                        selected: false,
                        hue: PopHue.coral,
                        onTap: () => setState(() => _filter = PaymentFilter(search: _filter.search)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AbsSpace.x3)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
              sliver: switch (list) {
                AsyncData(:final value) when value.items.isNotEmpty => SliverList.builder(
                  itemCount: value.items.length,
                  itemBuilder: (context, i) {
                    final p = value.items[i];
                    return PaymentTile(
                      key: ValueKey(p.id),
                      payment: p,
                      onTap: p.invoiceId == null ? null : () => context.push(Routes.invoiceDetail(p.invoiceId!)),
                    );
                  },
                ),
                AsyncData() => SliverToBoxAdapter(
                  child: EmptyState(
                    title: l.historyEmptyTitle,
                    message: l.historyEmptyBody,
                    illustration: EmptyIllustration.search,
                    hue: PopHue.sky,
                  ),
                ),
                AsyncError(:final error) => SliverToBoxAdapter(
                  child: ErrorState(
                    message: friendlyError(l, error),
                    onRetry: () => ref.invalidate(paymentHistoryProvider(_filter)),
                  ),
                ),
                _ => const SliverToBoxAdapter(child: SizedBox(height: 400, child: SkeletonList(itemCount: 5))),
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom + AbsSpace.x8)),
          ],
        ),
      ),
    );
  }
}
